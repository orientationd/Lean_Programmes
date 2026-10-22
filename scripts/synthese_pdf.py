#!/usr/bin/env python3
"""Synthèse PDF des programmes : tableaux et courbes sur dix ans.

Lit l'export de `Rapport.lean --synthese` (trajectoires calculées par le
modèle commun du dépôt) et produit un PDF : PIB, déficit et dette publics,
chômage, population active, emploi par secteur, impôts et taxes majeurs,
sensibilité au prix du pétrole et à la natalité, propriétés et engagements,
hypothèses et sources.

Aucun calcul économique ici : le script met en forme des chiffres produits
par le modèle (écarts et ratios d'affichage exceptés).

Usage :
    lake env lean --run Rapport.lean --synthese out/synthese.json
    python3 scripts/synthese_pdf.py out/synthese.json out/synthese.pdf [--commit SHA]

Dépendances : matplotlib, reportlab.
"""

from __future__ import annotations

import argparse
import datetime as dt
import io
import json
import os
import sys
from collections import OrderedDict
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.ticker import FuncFormatter, MaxNLocator  # noqa: E402
from reportlab.lib import colors  # noqa: E402
from reportlab.lib.pagesizes import A4  # noqa: E402
from reportlab.lib.styles import ParagraphStyle  # noqa: E402
from reportlab.lib.units import mm  # noqa: E402
from reportlab.pdfbase import pdfmetrics  # noqa: E402
from reportlab.pdfbase.ttfonts import TTFont  # noqa: E402
from reportlab.platypus import (  # noqa: E402
    CondPageBreak, Image, KeepTogether, PageBreak, Paragraph, SimpleDocTemplate,
    Spacer, Table, TableStyle)

# ---------------------------------------------------------------------------
# Charte : palette catégorielle validée (ordre fixe), encres, police
# ---------------------------------------------------------------------------

SERIES = ["#2a78d6", "#eb6834", "#1baf7a", "#eda100", "#e87ba4",
          "#008300", "#6250d6", "#e34948"]
ORDINAL = ["#86b6ef", "#2a78d6", "#104281"]   # bas → haut, une seule teinte
TENDANCIEL = "#898781"
INK, INK2, MUTED = "#0b0b0b", "#52514e", "#898781"
GRID, BASE, FOND = "#e1e0d9", "#c3c2b7", "#f4f3ef"
PAR_FIGURE = 6          # au-delà, les programmes sont répartis sur plusieurs figures

FONT_DIR = Path(matplotlib.get_data_path()) / "fonts" / "ttf"
pdfmetrics.registerFont(TTFont("Sans", str(FONT_DIR / "DejaVuSans.ttf")))
pdfmetrics.registerFont(TTFont("Sans-Bold", str(FONT_DIR / "DejaVuSans-Bold.ttf")))
pdfmetrics.registerFontFamily("Sans", normal="Sans", bold="Sans-Bold")

plt.rcParams.update({
    "font.family": "DejaVu Sans", "font.size": 7.5,
    "axes.edgecolor": BASE, "axes.labelcolor": INK2, "axes.titlecolor": INK,
    "axes.titlesize": 8.5, "axes.titleweight": "bold", "axes.titlelocation": "left",
    "axes.titlepad": 7,
    "axes.spines.top": False, "axes.spines.right": False, "axes.spines.left": False,
    "axes.grid": True, "axes.grid.axis": "y", "axes.axisbelow": True,
    "grid.color": GRID, "grid.linewidth": 0.6, "grid.linestyle": "-",
    "xtick.color": BASE, "ytick.color": BASE,
    "xtick.labelcolor": MUTED, "ytick.labelcolor": MUTED,
    "xtick.labelsize": 7, "ytick.labelsize": 7,
    "ytick.major.size": 0, "xtick.major.size": 3,
    "legend.frameon": False, "legend.fontsize": 7, "legend.labelcolor": INK2,
    "figure.facecolor": "white", "axes.facecolor": "white",
    "savefig.facecolor": "white", "lines.solid_capstyle": "round",
    "lines.solid_joinstyle": "round",
    "figure.constrained_layout.h_pad": 0.03, "figure.constrained_layout.w_pad": 0.03,
})

LARGEUR = A4[0] - 36 * mm       # largeur utile (marges de 18 mm), en points
POUCES = LARGEUR / 72           # idem en pouces : les figures sont tracées à l'échelle 1

# ---------------------------------------------------------------------------
# Formats français
# ---------------------------------------------------------------------------

NBSP = " "


def nombre(v: float, dec: int = 0) -> str:
    s = f"{abs(v):,.{dec}f}".replace(",", NBSP).replace(".", ",")
    return ("−" if v < 0 and round(abs(v), dec) != 0 else "") + s


def signe(v: float, dec: int = 1) -> str:
    if round(v, dec) == 0:
        return nombre(0, dec)
    return ("+" if v > 0 else "−") + nombre(abs(v), dec)


def pct_pb(pb: int, dec: int = 1) -> str:
    return nombre(pb / 100, dec) + NBSP + "%"


def md(meur: int, dec: int = 0) -> str:
    return nombre(meur / 1000, dec)


def fmt_axe(dec: int, suffixe: str = ""):
    return FuncFormatter(lambda v, _: nombre(v, dec) + suffixe)


# ---------------------------------------------------------------------------
# Données
# ---------------------------------------------------------------------------

def nom_court(nom: str) -> str:
    """« La France insoumise — Mélenchon 2027 (…) » → « La France insoumise »."""
    return nom.split(" — ")[0]


class Donnees:
    def __init__(self, d: dict):
        self.d = d
        self.annees = d["annees"]
        self.var = {v["id"]: v for v in d["variantes"]}
        self.progs = d["programmes"]
        # la couleur suit le programme (ordre du registre), jamais son rang
        self.couleur = {p["id"]: SERIES[i % PAR_FIGURE] for i, p in enumerate(self.progs)}
        self.groupes = [self.progs[i:i + PAR_FIGURE] for i in range(0, len(self.progs), PAR_FIGURE)]
        self.secteurs = d["secteurs"]
        self.impots = d["impots"]

    def traj(self, variante: str, prog: str | None) -> list[dict]:
        v = self.var[variante]
        return v["tendanciel"] if prog is None else v["programmes"][prog]

    def fin(self, variante: str, prog: str | None) -> dict:
        return self.traj(variante, prog)[-1]

    def brent(self, variante: str) -> int:
        return self.var[variante]["prixBrentDollars"]

    def icf(self, variante: str) -> str:
        return nombre(self.var[variante]["icfCentiemes"] / 100, 2)

    def lignes(self):
        """(id, nom court) : tendanciel puis programmes."""
        return [(None, "Tendanciel (sans programme)")] + [(p["id"], nom_court(p["nom"])) for p in self.progs]


def impots_total(e: dict) -> int:
    return sum(e["impots"].values())


def po_pb(e: dict) -> int:
    return impots_total(e) * 10000 // e["pib"]


# ---------------------------------------------------------------------------
# Figures (tracées à la largeur exacte de la page : échelle 1)
# ---------------------------------------------------------------------------

def figure(hauteur: float, *args, **kw):
    return plt.subplots(*args, figsize=(POUCES, hauteur), layout="constrained", **kw)


def png(fig) -> Image:
    buf = io.BytesIO()
    fig.savefig(buf, format="png", dpi=220)
    w, h = fig.get_size_inches()
    plt.close(fig)
    buf.seek(0)
    return Image(buf, width=w * 72, height=h * 72)


def ligne(ax, x, y, couleur, label, epaisseur=1.6, z=3):
    ax.plot(x, y, color=couleur, lw=epaisseur, label=label, zorder=z)
    ax.plot([x[-1]], [y[-1]], "o", ms=4.6, color=couleur, mec="white", mew=1.2, zorder=z + 1)


def legende(fig, ncol=3):
    fig.legend(loc="outside lower left", ncol=ncol, handlelength=1.6, columnspacing=1.8)


def courbes(D: Donnees, groupe, valeur, titre, dec, suffixe="", ecart=False, reference=None):
    """Une courbe par programme (scénario central), et le tendanciel."""
    fig, ax = figure(2.6)
    x = D.annees
    base = [valeur(e) for e in D.traj("central", None)]
    if not ecart:
        ligne(ax, x, base, TENDANCIEL, "Tendanciel (sans programme)", epaisseur=1.3, z=2)
    for p in groupe:
        y = [valeur(e) for e in D.traj("central", p["id"])]
        if ecart:
            y = [a - b for a, b in zip(y, base)]
        ligne(ax, x, y, D.couleur[p["id"]], nom_court(p["nom"]))
    if ecart:
        ax.axhline(0, color=BASE, lw=0.8, zorder=1)
    if reference is not None:
        ax.axhline(reference[0], color=INK2, lw=0.8, zorder=1)
        ax.annotate(reference[1], (x[0], reference[0]), xytext=(2, 3),
                    textcoords="offset points", color=INK2, fontsize=7)
    ax.set_title(titre)
    ax.yaxis.set_major_formatter(fmt_axe(dec, suffixe))
    ax.yaxis.set_major_locator(MaxNLocator(5))
    ax.set_xticks(x[::2] if len(x) > 6 else x)
    ax.set_xlim(x[0] - 0.3, x[-1] + 0.3)
    legende(fig)
    return fig


def barres_secteurs(D: Donnees, groupe, variante="central"):
    """Écart d'emploi au tendanciel en fin de période, par secteur et programme."""
    secs = D.secteurs
    n = len(groupe)
    fig, ax = figure(0.12 * len(secs) * n + 0.9)
    pas = 0.82 / max(n, 1)
    base = D.fin(variante, None)["emploi"]
    for j, p in enumerate(groupe):
        e = D.fin(variante, p["id"])["emploi"]
        ys = [i + (j - (n - 1) / 2) * pas for i in range(len(secs))]
        vals = [(e[s["id"]] - base[s["id"]]) / 1000 for s in secs]
        ax.barh(ys, vals, height=pas * 0.84, color=D.couleur[p["id"]],
                label=nom_court(p["nom"]), zorder=3)
    ax.set_yticks(range(len(secs)), [s["nom"] for s in secs])
    ax.set_ylim(len(secs) - 0.5, -0.5)
    ax.tick_params(axis="y", labelcolor=INK2, labelsize=7.5)
    ax.grid(axis="y", visible=False)
    ax.grid(axis="x", visible=True)
    ax.axvline(0, color=BASE, lw=0.8, zorder=2)
    ax.xaxis.set_major_formatter(fmt_axe(0, ""))
    ax.set_title(f"Écart d'emploi au tendanciel en {D.annees[-1]}, par secteur (milliers)")
    legende(fig)
    return fig


def petits_multiples_impots(D: Donnees, groupe, variante="central"):
    """Écart de recettes au tendanciel par prélèvement : un panneau par programme,
    même échelle partout."""
    imp = D.impots
    n = len(groupe)
    cols = 3 if n > 2 else n
    rangs = (n + cols - 1) // cols
    fig, axes = figure(1.75 * rangs + 0.35, rangs, cols, sharex=True, sharey=True, squeeze=False)
    base = D.fin(variante, None)["impots"]
    ecarts = {p["id"]: [(D.fin(variante, p["id"])["impots"][i["id"]] - base[i["id"]]) / 1000
                        for i in imp] for p in groupe}
    m = max([abs(v) for vs in ecarts.values() for v in vs] + [1.0])
    for k, ax in enumerate(axes.flat):
        if k >= n:
            ax.axis("off")
            continue
        p = groupe[k]
        vals = ecarts[p["id"]]
        ax.barh(range(len(imp)), vals, height=0.62, color=D.couleur[p["id"]], zorder=3)
        ax.axvline(0, color=BASE, lw=0.8, zorder=2)
        ax.set_title(nom_court(p["nom"]), fontsize=7.5)
        ax.grid(axis="y", visible=False)
        ax.grid(axis="x", visible=True)
        ax.set_xlim(-m * 1.35, m * 1.35)
        ax.set_yticks(range(len(imp)), [COURTS_FIG.get(i["id"], i["nom"]) for i in imp])
        ax.set_ylim(len(imp) - 0.5, -0.5)
        ax.tick_params(axis="y", labelcolor=INK2, labelsize=6.8)
        ax.xaxis.set_major_formatter(fmt_axe(0, ""))
        ax.xaxis.set_major_locator(MaxNLocator(4))
        kmax = max(range(len(vals)), key=lambda i: abs(vals[i]))
        if abs(vals[kmax]) >= 0.05:      # seule la plus grande barre est étiquetée
            v = vals[kmax]
            ax.annotate(signe(v, 1), (v, kmax), xytext=(3 if v >= 0 else -3, 0),
                        textcoords="offset points", ha="left" if v >= 0 else "right",
                        va="center", fontsize=6.8, color=INK)
        else:
            ax.annotate("aucun écart notable", (0, (len(imp) - 1) / 2), xytext=(5, 0),
                        textcoords="offset points", fontsize=6.8, color=MUTED, va="center")
    fig.suptitle(f"Écart de recettes au tendanciel en {D.annees[-1]}, par prélèvement (Md€)",
                 x=0.0, ha="left", fontsize=8.5, fontweight="bold", color=INK)
    return fig


def structure_impots(D: Donnees):
    """Prélèvements de la situation de départ (une seule série)."""
    e = D.traj("central", None)[0]
    imp = sorted(D.impots, key=lambda i: e["impots"][i["id"]], reverse=True)
    vals = [e["impots"][i["id"]] / 1000 for i in imp]
    fig, ax = figure(2.1)
    ax.barh(range(len(imp)), vals, height=0.58, color=SERIES[0], zorder=3)
    ax.set_yticks(range(len(imp)), [i["nom"] for i in imp])
    ax.set_ylim(len(imp) - 0.5, -0.5)
    ax.tick_params(axis="y", labelcolor=INK2, labelsize=7.2)
    ax.grid(axis="y", visible=False)
    ax.grid(axis="x", visible=True)
    for k, v in enumerate(vals):
        ax.annotate(nombre(v, 0), (v, k), xytext=(3, 0), textcoords="offset points",
                    va="center", fontsize=6.8, color=INK2)
    ax.set_xlim(0, max(vals) * 1.1)
    ax.xaxis.set_major_formatter(fmt_axe(0, ""))
    ax.set_title(f"Impôts et cotisations en {D.annees[0]}, situation de départ (Md€)")
    return fig


def points_petrole(D: Donnees, champs):
    """Valeur en fin de période selon le prix du pétrole : trois points par ligne."""
    variantes = [(v, f"{D.brent(v)} $") for v in ("petrole-bas", "central", "petrole-haut")]
    lignes = D.lignes()
    fig, axes = figure(0.24 * len(lignes) + 0.9, 1, len(champs), sharey=True)
    for ax, (champ, titre, dec, suffixe, tr) in zip(axes, champs):
        for k, (pid, _nom) in enumerate(lignes):
            vals = [tr(D.fin(v, pid)[champ]) for v, _ in variantes]
            ax.plot([min(vals), max(vals)], [k, k], color=BASE, lw=1.2, zorder=2)
            for (_v, lab), val, c in zip(variantes, vals, ORDINAL):
                ax.plot([val], [k], "o", ms=5.5, color=c, mec="white", mew=1.0, zorder=3,
                        label=f"Brent à {lab}" if k == 0 else None)
        ax.set_title(titre, fontsize=8)
        ax.grid(axis="y", visible=False)
        ax.grid(axis="x", visible=True)
        ax.xaxis.set_major_formatter(fmt_axe(dec, suffixe))
        ax.xaxis.set_major_locator(MaxNLocator(4))
        ax.set_ylim(len(lignes) - 0.5, -0.5)
    axes[0].set_yticks(range(len(lignes)), [n for _, n in lignes])
    axes[0].tick_params(axis="y", labelcolor=INK2, labelsize=7.2)
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="outside lower left", ncol=3, handlelength=1.0)
    return fig


def courbes_natalite(D: Donnees):
    variantes = [("natalite-basse", f"basse ({D.icf('natalite-basse')} enfant par femme)"),
                 ("central", f"centrale ({D.icf('central')})"),
                 ("natalite-haute", f"haute ({D.icf('natalite-haute')})")]
    fig, ax = figure(2.3)
    x = D.annees
    for (v, lab), c in zip(variantes, ORDINAL):
        y = [e["populationMilliers"] / 1000 for e in D.traj(v, None)]
        ligne(ax, x, y, c, f"Natalité {lab}")
        ax.annotate(nombre(y[-1], 1) + NBSP + "M", (x[-1], y[-1]), xytext=(7, 0),
                    textcoords="offset points", va="center", fontsize=7, color=INK2)
    ax.set_title("Population (millions) selon la fécondité, identique pour tous les programmes")
    ax.yaxis.set_major_formatter(fmt_axe(1, ""))
    ax.yaxis.set_major_locator(MaxNLocator(5))
    ax.set_xticks(x[::2])
    ax.set_xlim(x[0] - 0.3, x[-1] + 1.3)
    legende(fig)
    return fig


COURTS_FIG = {"tva": "TVA", "ir": "IR", "csgCrds": "CSG-CRDS", "cotisations": "Cotisations",
              "impotSocietes": "IS", "accisesEnergie": "Accise énergie",
              "taxeFonciere": "Taxe foncière", "autres": "Autres impôts"}
COURTS_TAB = {"tva": "TVA", "ir": "IR", "csgCrds": "CSG", "cotisations": "Cotis.",
              "impotSocietes": "IS", "accisesEnergie": "Accise", "taxeFonciere": "T. fonc.",
              "autres": "Autres"}
SECTEURS_TAB = {"agriculture": "Agric.", "industrie": "Industrie", "construction": "Constr.",
                "tertiaireMarchand": "Tert. march.", "tertiaireNonMarchand": "Tert. non m."}

# ---------------------------------------------------------------------------
# Mise en page
# ---------------------------------------------------------------------------


def style(nom, police="Sans", taille=8.8, interligne=None, couleur=INK, **kw):
    return ParagraphStyle(nom, fontName=police, fontSize=taille,
                          leading=interligne or taille * 1.4, textColor=couleur, **kw)


STYLES = {
    "titre": style("titre", "Sans-Bold", 21, 26, spaceAfter=6),
    "soustitre": style("soustitre", taille=10.5, interligne=14, couleur=INK2, spaceAfter=12),
    "h1": style("h1", "Sans-Bold", 13.5, 17, spaceBefore=6, spaceAfter=6),
    "h2": style("h2", "Sans-Bold", 9.8, 13, spaceBefore=8, spaceAfter=4),
    "corps": style("corps", taille=8.8, interligne=12.6, spaceAfter=6),
    "puce": style("puce", taille=8.6, interligne=12, leftIndent=10, spaceAfter=2.5),
    "note": style("note", taille=7.2, interligne=9.6, couleur=INK2, spaceBefore=3, spaceAfter=8),
    "cell": style("cell", taille=7.2, interligne=9.0),
    "celld": style("celld", taille=7.2, interligne=9.0, alignment=2),
    "cellg": style("cellg", "Sans-Bold", 7.2, 9.0, couleur=INK2),
    "cellgd": style("cellgd", "Sans-Bold", 7.2, 9.0, couleur=INK2, alignment=2),
    "petit": style("petit", taille=7, interligne=9, couleur=INK2, leftIndent=10, spaceAfter=1.5),
}


def P(texte: str, nom: str = "corps") -> Paragraph:
    return Paragraph(texte, STYLES[nom])


def echap(t: str) -> str:
    return t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def tableau(entetes, lignes, largeurs, droite_des=1, surligner_premiere=False) -> Table:
    """Tableau sobre : filets fins, nombres alignés à droite."""
    def cellule(c, j, entete):
        if isinstance(c, Paragraph):
            return c
        nom = ("cellg" if entete else "cell") + ("d" if j >= droite_des else "")
        return P(echap(str(c)), nom)

    data = [[cellule(h, j, True) for j, h in enumerate(entetes)]]
    data += [[cellule(c, j, False) for j, c in enumerate(ln)] for ln in lignes]
    t = Table(data, colWidths=[w * LARGEUR for w in largeurs], repeatRows=1)
    st = [("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
          ("VALIGN", (0, 0), (-1, 0), "BOTTOM"),
          ("LINEBELOW", (0, 0), (-1, 0), 0.7, colors.HexColor(BASE)),
          ("LINEBELOW", (0, 1), (-1, -1), 0.3, colors.HexColor(GRID)),
          ("TOPPADDING", (0, 0), (-1, -1), 2.4), ("BOTTOMPADDING", (0, 0), (-1, -1), 2.4),
          ("LEFTPADDING", (0, 0), (-1, -1), 3), ("RIGHTPADDING", (0, 0), (-1, -1), 3)]
    if surligner_premiere:
        st.append(("BACKGROUND", (0, 1), (-1, 1), colors.HexColor(FOND)))
    t.setStyle(TableStyle(st))
    return t


def puces(items):
    return [Paragraph(t, STYLES["puce"], bulletText="•") for t in items]


# ---------------------------------------------------------------------------
# Sections
# ---------------------------------------------------------------------------

def table_proprietes(D: Donnees) -> Table:
    n = D.d["nbScenarios"]
    props = D.d["proprietes"]
    ent = [f"Programme (sur {n} scénarios)"] + [q["titre"] for q in props]
    rows = [[nom_court(p["nom"])] + [f"{p['matrice'][q['id']]} / {n}" for q in props]
            for p in D.progs]
    return tableau(ent, rows, [0.32] + [0.68 / len(props)] * len(props))


def section_resume(D: Donnees, meta) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    base = D.fin("central", None)
    out = [P("Synthèse des programmes", "titre"),
           P(f"Projections {a0}–{a1} sous hypothèses partagées : PIB, finances publiques, "
             f"emploi par secteur, impôts et taxes, sensibilité au prix du pétrole et à la natalité.",
             "soustitre"),
           P(f"Généré le {meta['date']} à partir du dépôt <b>orientationd/Lean_Programmes</b>"
             f"{meta['commit']}. Tous les chiffres sont calculés par le modèle commun du dépôt, "
             f"le même pour chaque programme ; ce document ne fait que les mettre en forme.")]
    out.append(P(f"Indicateurs en {a1}, scénario central", "h2"))
    ent = ["Programme", "PIB (Md€)", "Écart de PIB", "Déficit public", "Dette", "Chômage",
           "Actifs (millions)", "Prélèv. oblig."]
    rows = []
    for pid, nom in D.lignes():
        e = D.fin("central", pid)
        ecart = "—" if pid is None else signe((e["pib"] - base["pib"]) * 100 / base["pib"], 2) + NBSP + "%"
        rows.append([nom, md(e["pib"]), ecart, pct_pb(e["deficitPb"]), pct_pb(e["dettePb"], 0),
                     pct_pb(e["chomagePb"]), nombre(e["actifs"] / 1e6, 2), pct_pb(po_pb(e))])
    out.append(tableau(ent, rows, [0.27, 0.095, 0.1, 0.1, 0.085, 0.09, 0.13, 0.13],
                       surligner_premiere=True))
    out.append(P("Déficit, dette et prélèvements obligatoires (impôts et cotisations sociales) en % "
                 "du PIB. Écart de PIB : par rapport au tendanciel, même année, même scénario.", "note"))

    def ext(cle, variante="central"):
        vals = sorted((cle(D.fin(variante, p["id"])), nom_court(p["nom"])) for p in D.progs)
        return vals[0], vals[-1]

    (dmin, nmin), (dmax, nmax) = ext(lambda e: e["deficitPb"])
    (cmin, ncmin), (cmax, ncmax) = ext(lambda e: e["chomagePb"])
    ids = [None] + [p["id"] for p in D.progs]
    pertes = [(D.fin("central", i)["pib"] - D.fin("petrole-haut", i)["pib"]) * 100
              / D.fin("central", i)["pib"] for i in ids]
    hausses = [(D.fin("petrole-haut", i)["deficitPb"] - D.fin("central", i)["deficitPb"]) / 100
               for i in ids]

    def plage(vals, dec, unite):
        a, b = nombre(min(vals), dec), nombre(max(vals), dec)
        return f"{a}{unite}" if a == b else f"{a} à {b}{unite}"
    out.append(P("Ce qu'il faut retenir", "h2"))
    out += puces([
        f"En {a1}, le déficit public va de {pct_pb(dmin)} ({echap(nmin)}) à {pct_pb(dmax)} "
        f"({echap(nmax)}), contre {pct_pb(base['deficitPb'])} sans programme.",
        f"Le chômage va de {pct_pb(cmin, 2)} ({echap(ncmin)}) à {pct_pb(cmax, 2)} "
        f"({echap(ncmax)}), contre {pct_pb(base['chomagePb'], 2)} sans programme.",
        f"Un Brent à {D.brent('petrole-haut')} $ au lieu de {D.brent('central')} $ réduit le PIB "
        f"de {plage(pertes, 1, NBSP + '%')} et creuse le déficit de {plage(hausses, 1, ' point')} "
        "selon le programme (tendanciel compris).",
        f"La natalité ne change que la population "
        f"({nombre(D.fin('natalite-basse', None)['populationMilliers'] / 1000, 1)} à "
        f"{nombre(D.fin('natalite-haute', None)['populationMilliers'] / 1000, 1)} millions en {a1}) "
        "et le PIB par habitant : les enfants nés d'ici là n'arrivent pas sur le marché du travail "
        "avant l'horizon.",
    ])
    out.append(P("Propriétés partagées", "h2"))
    out.append(table_proprietes(D))
    out.append(P(f"Nombre de scénarios (démographie × économie × pétrole × cadre juridique) où la "
                 f"propriété tient, à l'horizon de {D.d['horizonProprietes']} ans. Détail page "
                 "« Propriétés et engagements ».", "note"))
    out.append(P("Comment lire ce document", "h2"))
    out += puces([
        "Chaque programme est une liste de mesures traduites en leviers communs (dépense, "
        "prélèvement, âge légal, SMIC…). Le modèle en calcule les effets sous chaque jeu "
        "d'hypothèses ; aucun programme n'apporte ses propres élasticités.",
        f"Les mesures sont supposées appliquées dès {a0} (année 0), puis la projection les "
        "porte jusqu'à l'horizon : les écarts au tendanciel sont des effets de niveau durables.",
        "Le déficit présenté est celui des administrations publiques (État, sécurité sociale, "
        "collectivités), au sens de Maastricht : le modèle ne sépare pas le budget de l'État.",
        "Le modèle est volontairement simple ; ses limites sont détaillées en annexe C. Les "
        "programmes « Exemple » sont fictifs ; LFI et PS sont des transcriptions partielles.",
    ])
    return out


def section_courbe(D, titre, intro, valeur, titre_fig, dec, suffixe, fmt_table,
                   note=None, ecart=False, reference=None, valeur_table=None):
    out = [P(titre, "h1"), P(intro)]
    for g in D.groupes:
        out.append(png(courbes(D, g, valeur, titre_fig, dec, suffixe, ecart=ecart,
                               reference=reference)))
    ans = [D.annees[2], D.annees[5], D.annees[-1]]
    idx = [D.annees.index(a) for a in ans]
    vt = valeur_table or valeur
    rows = [[nom] + [fmt_table(vt(D.traj("central", pid)[i])) for i in idx]
            for pid, nom in D.lignes()]
    out.append(Spacer(1, 3))
    out.append(tableau(["Scénario central"] + [str(a) for a in ans], rows,
                       [0.46] + [0.54 / len(ans)] * len(ans), surligner_premiere=True))
    if note:
        out.append(P(note, "note"))
    else:
        out.append(Spacer(1, 6))
    return out


def section_emploi(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    secs = D.secteurs
    out = [P("Emploi par secteur", "h1"),
           P("Répartition des personnes en emploi entre les cinq grands secteurs de l'INSEE. "
             "Une dépense ciblée sur un secteur (levier « dépense sectorielle ») y place les emplois "
             "qu'elle crée ; les autres effets (âge légal, SMIC, demande générale) se répartissent "
             "au prorata de la structure de l'emploi.")]
    for g in D.groupes:
        out.append(png(barres_secteurs(D, g)))
    larg = [0.25, 0.085, 0.1, 0.09, 0.12, 0.12, 0.11, 0.125]
    ent = ["Emploi (milliers)"] + [SECTEURS_TAB.get(s["id"], s["nom"]) for s in secs] \
        + ["Total", "Part industrie"]

    def rangee(nom, e):
        return [nom] + [nombre(e["emploi"][s["id"]] / 1000) for s in secs] \
            + [nombre(e["emploiTotal"] / 1000),
               nombre(e["emploi"]["industrie"] * 100 / e["emploiTotal"], 2) + NBSP + "%"]

    rows = [rangee(f"Situation de départ ({a0})", D.traj("central", None)[0])]
    rows += [rangee(f"{nom} ({a1})", D.fin("central", pid)) for pid, nom in D.lignes()]
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, larg))
    base = D.fin("central", None)["emploi"]
    ent2 = [f"Écart au tendanciel en {a1} (emplois)"] + [SECTEURS_TAB.get(s["id"], s["nom"]) for s in secs] + ["Total"]
    rows2 = []
    for p in D.progs:
        e = D.fin("central", p["id"])["emploi"]
        ds = [e[s["id"]] - base[s["id"]] for s in secs]
        rows2.append([nom_court(p["nom"])] + [signe(v, 0) for v in ds] + [signe(sum(ds), 0)])
    out.append(Spacer(1, 6))
    out.append(tableau(ent2, rows2, [0.25, 0.1, 0.11, 0.11, 0.13, 0.15, 0.15]))
    e0 = D.traj("central", None)[0]
    out.append(P("Emploi au sens du BIT. Structure de départ : estimations d'emploi INSEE 2024 "
                 f"par secteur, appliquées à l'emploi {a0} ({nombre(e0['actifs'] / 1e6, 1)} millions "
                 f"d'actifs, chômage {pct_pb(e0['chomagePb'])}). "
                 "Agric. : agriculture ; Constr. : construction ; Tert. march. / non m. : tertiaire "
                 "marchand / non marchand.", "note"))
    return out


def section_impots(D: Donnees) -> list:
    a0, a1 = D.annees[0], D.annees[-1]
    imp = D.impots
    out = [P("Impôts et taxes majeurs", "h1"),
           P("Les recettes publiques sont suivies par grand prélèvement. Leur assiette évolue "
             "comme le PIB. Une mesure fiscale s'impute sur le prélèvement qu'elle vise (levier "
             "« prélèvement sur ») ou, faute de précision dans le programme, sur « autres impôts » "
             "(patrimoine, successions, taxes diverses) ; les effets d'activité se répartissent au "
             "prorata.")]
    out.append(png(structure_impots(D)))
    for g in D.groupes:
        out.append(png(petits_multiples_impots(D, g)))
    larg = [0.22] + [0.077] * len(imp) + [0.164]
    ent = [f"Recettes {a1} (Md€)"] + [COURTS_TAB.get(i["id"], i["nom"]) for i in imp] + ["Prélèv. oblig."]
    rows = [[nom] + [md(D.fin("central", pid)["impots"][i["id"]], 1) for i in imp]
            + [md(impots_total(D.fin("central", pid)), 1)] for pid, nom in D.lignes()]
    out.append(KeepTogether([Spacer(1, 3), tableau(ent, rows, larg, surligner_premiere=True)]))
    base = D.fin("central", None)
    ent2 = [f"Écart au tendanciel {a1} (Md€)"] + [COURTS_TAB.get(i["id"], i["nom"]) for i in imp] + ["Prélèv. oblig."]
    rows2 = []
    for p in D.progs:
        e = D.fin("central", p["id"])
        rows2.append([nom_court(p["nom"])]
                     + [signe((e["impots"][i["id"]] - base["impots"][i["id"]]) / 1000, 1) for i in imp]
                     + [signe((impots_total(e) - impots_total(base)) / 1000, 1)])
    out.append(KeepTogether([Spacer(1, 6), tableau(ent2, rows2, larg)]))
    out.append(P(f"CSG : CSG et CRDS ; Cotis. : cotisations sociales ; IS : impôt sur les sociétés ; "
                 f"Accise : accise sur les énergies (TICPE) ; T. fonc. : taxe foncière ; Prélèv. oblig. : "
                 f"somme des colonnes (hors recettes non fiscales). Situation de "
                 f"départ {a0} : INSEE, comptes des administrations publiques 2025 ; DGCL (taxe "
                 "foncière) ; ministère de la Transition écologique (accise, dernier chiffre publié : "
                 "2022). Rendements nets des pertes dues aux comportements (fuite fiscale).", "note"))
    return out


def section_petrole(D: Donnees) -> list:
    a1 = D.annees[-1]
    out = [P("Sensibilité au prix du pétrole", "h1"),
           P(f"Trois prix du Brent : {D.brent('petrole-bas')} $, {D.brent('central')} $ (référence, "
             f"prix figé par l'INSEE pour 2026) et {D.brent('petrole-haut')} $ (choc). Chaque hausse "
             f"de 10 $ coûte {nombre(-D.var['central']['effetPibPar10DollarsPb'] / 100, 2)} % de PIB "
             "l'année de départ (INSEE : −0,2 à −0,3 %) ; l'effet se propage aux recettes et à "
             "l'emploi.")]
    champs = [("deficitPb", f"Déficit public en {a1} (% du PIB)", 1, NBSP + "%", lambda v: v / 100),
              ("chomagePb", f"Chômage en {a1} (%)", 1, NBSP + "%", lambda v: v / 100)]
    out.append(png(points_petrole(D, champs)))
    prix = " / ".join(str(D.brent(v)) for v in ("petrole-bas", "central", "petrole-haut"))
    ent = [f"{a1}, Brent à {prix} $", "PIB (Md€)", "Déficit public (%)", "Dette (%)", "Chômage (%)"]
    rows = []
    for pid, nom in D.lignes():
        es = [D.fin(v, pid) for v in ("petrole-bas", "central", "petrole-haut")]
        rows.append([nom, " / ".join(md(e["pib"]) for e in es),
                     " / ".join(nombre(e["deficitPb"] / 100, 1) for e in es),
                     " / ".join(nombre(e["dettePb"] / 100, 0) for e in es),
                     " / ".join(nombre(e["chomagePb"] / 100, 1) for e in es)])
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.28, 0.22, 0.17, 0.16, 0.17], surligner_premiere=True))
    out.append(P("Déficit et dette en % du PIB, chômage en % des actifs. Effet de niveau uniquement : "
                 "pas d'effet modélisé sur l'inflation, la facture énergétique ou le rendement de "
                 "l'accise.", "note"))
    return out


def section_natalite(D: Donnees) -> list:
    a1 = D.annees[-1]
    out = [P("Sensibilité à la natalité", "h1"),
           P(f"Trois hypothèses de fécondité : {D.icf('natalite-basse')} enfant par femme "
             f"(poursuite de la baisse), {D.icf('central')} (niveau de 2025) et "
             f"{D.icf('natalite-haute')} (niveau de 2014). Sur dix ans, la natalité modifie la "
             "population, donc le PIB par habitant, mais pas encore la population active.")]
    out.append(png(courbes_natalite(D)))
    ent = [f"PIB par habitant en {a1} (€)", "Natalité basse", "Centrale", "Haute"]
    rows = [[nom] + [nombre(D.fin(v, pid)["pibParHabitant"])
                     for v in ("natalite-basse", "central", "natalite-haute")]
            for pid, nom in D.lignes()]
    out.append(Spacer(1, 3))
    out.append(tableau(ent, rows, [0.46, 0.18, 0.18, 0.18], surligner_premiere=True))
    naiss = " / ".join(nombre(D.var[v]["naissancesMilliers"] * 1000)
                       for v in ("natalite-basse", "central", "natalite-haute"))
    out.append(P(f"Naissances par an : {naiss} (2025 : 645 000, INSEE, bilan démographique 2025 ; "
                 "variantes mises à l'échelle de la fécondité). Décès et solde migratoire de 2025 "
                 "prolongés.", "note"))
    return out


def section_proprietes(D: Donnees) -> list:
    d = D.d
    n = d["nbScenarios"]
    out = [P("Propriétés et engagements", "h1"),
           P(f"Chaque programme est évalué sous les {n} scénarios du dépôt (démographie × économie "
             f"× prix du pétrole × cadre juridique), à l'horizon de {d['horizonProprietes']} ans. "
             "Une propriété est un critère partagé ; un engagement est une propriété qu'un programme "
             "revendique sous un ou plusieurs scénarios, vérifiée par le noyau Lean à chaque "
             "modification du dépôt."),
           table_proprietes(D), Spacer(1, 4), P("Engagements revendiqués", "h2")]
    rows = []
    for p in D.progs:
        groupes: OrderedDict[str, list] = OrderedDict()
        for e in p["engagements"]:
            groupes.setdefault(e["propriete"], []).append(e)
        for prop, es in groupes.items():
            tenus = sum(1 for e in es if e["tenu"])
            if len(es) == n:
                scen, statut = f"tous les scénarios ({n})", f"tenu ({tenus}/{n})" if tenus == n else f"NON TENU ({tenus}/{n})"
                rows.append([nom_court(p["nom"]), prop, scen, statut])
            else:
                for e in es:
                    rows.append([nom_court(p["nom"]), prop,
                                 P(echap(e["scenario"].replace("/", " / ")), "cell"),
                                 "tenu" if e["tenu"] else "NON TENU"])
    if rows:
        out.append(tableau(["Programme", "Propriété", "Scénario", "Statut"], rows,
                           [0.22, 0.18, 0.46, 0.14], droite_des=3))
    else:
        out.append(P("Aucun engagement déclaré.", "note"))
    out.append(P("Contrats de mesure", "h2"))
    out.append(P("Un contrat est un théorème démontré sur une mesure (par exemple : « l'amende est "
                 "nulle pour toute commune qui atteint son objectif »), valable pour toutes les "
                 "valeurs possibles et pas seulement pour les scénarios. Nombre de contrats : "
                 + " ; ".join(f"{echap(nom_court(p['nom']))} {len(p['contrats'])}" for p in D.progs)
                 + ". Liste en annexe A."))
    return out


def section_annexes(D: Donnees) -> list:
    out = [PageBreak(), P("Annexe A — Mesures et contrats par programme", "h1")]
    for p in D.progs:
        bloc = [P(echap(p["nom"]), "h2"), P(echap(p["description"]), "note")]
        bloc += [Paragraph(f"<b>{echap(m['id'])}</b> {echap(m['titre'])}", STYLES["puce"],
                           bulletText="•") for m in p["mesures"]]
        if p["contrats"]:
            bloc.append(P("Contrats démontrés :", "note"))
            bloc += [P(echap(c), "petit") for c in p["contrats"]]
        out.append(KeepTogether(bloc[:4]))
        out += bloc[4:]
    out += [CondPageBreak(80 * mm), P("Annexe B — Hypothèses et sources", "h1")]
    h = D.d["hypotheses"]
    groupes = [("Situation de départ", [h["reference"] | {"id": "référence"}]),
               ("Démographie", h["demographie"]), ("Natalité", h["natalite"]),
               ("Économie", h["economie"]), ("Prix du pétrole", h["energie"]),
               ("Cadre juridique", h["droit"])]
    for titre, items in groupes:
        out.append(P(titre, "h2"))
        for it in items:
            out.append(Paragraph(f"<b>{echap(it['id'])}</b> — {echap(it['description'])}",
                                 STYLES["puce"], bulletText="•"))
            out += [P(echap(s), "petit") for s in it["sources"]]
    out += [CondPageBreak(60 * mm), P("Annexe C — Méthode et limites", "h1")]
    out += puces([
        "Modèle commun en nombres entiers (M€, points de base, personnes), écrit en Lean 4 : la "
        "même fonction projette le tendanciel et chaque programme. Engagements et contrats sont "
        "vérifiés par le noyau Lean ; les trajectoires de ce document sont calculées par le même "
        "code.",
        "Le modèle est volontairement jouet : multiplicateur budgétaire, fuite fiscale, loi "
        "d'Okun et élasticité du chômage au SMIC sont des paramètres de comportement encore à "
        "sourcer (annexe B, « À COMPLÉTER »). Trois jeux d'hypothèses économiques encadrent ces "
        "incertitudes dans la matrice des propriétés ; ce document ne montre que le jeu central.",
        "Assiettes fiscales proportionnelles au PIB nominal ; pas d'inflation séparée, pas de "
        "charge d'intérêts distincte, pas de balance commerciale macroéconomique (le sous-modèle "
        "automobile la calcule pour la mesure O-01 seulement).",
        "Déficit « de l'État » : le modèle suit les administrations publiques consolidées ; les "
        "transferts internes (par exemple les amendes SRU versées par les communes) sont neutres "
        "sur le solde.",
        "Prêts et prises de participation de l'État (financement des EPR2, nationalisations) : "
        "opérations financières, comptées dans la dette mais pas dans le déficit, conformément au "
        "traitement de Maastricht. L'activité qu'ils financent se déroule hors des administrations "
        "publiques et n'est pas modélisée.",
        "Population active : tendance démographique et effet de l'âge légal (30 000 actifs par "
        "mois, INSEE). La natalité n'agit pas sur les actifs avant l'horizon.",
        f"Les hypothèses démographiques sont fixées à l'horizon des propriétés "
        f"({D.d['horizonProprietes']} ans). Au-delà, la synthèse prolonge au même rythme la hausse "
        "de la part des 65 ans et plus, donc le surcoût de vieillissement. Ce prolongement pèse "
        "de la même façon sur tous les programmes et sur le tendanciel ; il ne change pas les "
        "écarts entre eux.",
        "Programmes réels : transcriptions partielles et non officielles, limitées aux mesures "
        "chiffrées dans la source ; toute erreur se signale par une issue sur le dépôt.",
    ])
    return out


# ---------------------------------------------------------------------------

def construire(d: dict, sortie: Path, commit: str | None) -> None:
    D = Donnees(d)
    meta = {"date": dt.date.today().strftime("%d/%m/%Y"),
            "commit": f" (version {commit[:7]})" if commit else ""}
    a0, a1 = D.annees[0], D.annees[-1]
    pib0 = D.traj("central", None)[0]["pib"]
    story = section_resume(D, meta)
    story.append(PageBreak())
    story += section_courbe(
        D, "PIB",
        "Écart du PIB de chaque programme au PIB tendanciel : au-dessus de zéro, le programme "
        "accroît l'activité ; en dessous, il la réduit.",
        lambda e: e["pib"] * 100 / pib0, "Écart de PIB au tendanciel (% du PIB de départ), "
        "scénario central", 2, NBSP + "%", md, ecart=True, valeur_table=lambda e: e["pib"],
        note="Tableau : PIB en Md€ courants.")
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Déficit public",
        "Solde des administrations publiques (État, sécurité sociale, collectivités), en % du PIB. "
        "La ligne de référence marque le seuil de 3 % du traité de Maastricht.",
        lambda e: e["deficitPb"] / 100, "Déficit public (% du PIB), scénario central", 1,
        NBSP + "%", pct_pb, valeur_table=lambda e: e["deficitPb"],
        reference=(3.0, "3 % (Maastricht)"))
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Dette publique", "Dette au sens de Maastricht, en % du PIB.",
        lambda e: e["dettePb"] / 100, "Dette publique (% du PIB), scénario central", 0,
        NBSP + "%", lambda v: pct_pb(v, 1), valeur_table=lambda e: e["dettePb"])
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Chômage", "Taux de chômage au sens du BIT, en % de la population active.",
        lambda e: e["chomagePb"] / 100, "Taux de chômage (%), scénario central", 1, NBSP + "%",
        lambda v: pct_pb(v, 2), valeur_table=lambda e: e["chomagePb"])
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Population active",
        "Nombre d'actifs (en emploi ou au chômage). Il dépend de la démographie et de l'âge légal "
        "de départ à la retraite : chaque mois de recul ajoute environ 30 000 actifs (INSEE).",
        lambda e: e["actifs"] / 1e6, "Population active (millions), scénario central", 1, "",
        lambda v: nombre(v / 1e6, 3), valeur_table=lambda e: e["actifs"],
        note="Tableau en millions de personnes.")
    story.append(CondPageBreak(150 * mm))
    story += section_emploi(D)
    story.append(PageBreak())
    story += section_impots(D)
    story.append(CondPageBreak(110 * mm))
    story += section_courbe(
        D, "Taux de prélèvements obligatoires", "Impôts et cotisations sociales rapportés au PIB.",
        lambda e: po_pb(e) / 100, "Prélèvements obligatoires (% du PIB), scénario central", 1,
        NBSP + "%", pct_pb, valeur_table=po_pb,
        note="Périmètre : impôts et cotisations sociales effectives des comptes des administrations "
             "publiques. Le taux officiel de prélèvements obligatoires de l'INSEE retient un "
             "périmètre un peu plus étroit, d'où un niveau légèrement inférieur.")
    story.append(CondPageBreak(130 * mm))
    story += section_petrole(D)
    story.append(CondPageBreak(120 * mm))
    story += section_natalite(D)
    story.append(CondPageBreak(120 * mm))
    story += section_proprietes(D)
    story += section_annexes(D)

    def pied(canvas, doc):
        canvas.saveState()
        canvas.setFont("Sans", 6.8)
        canvas.setFillColor(colors.HexColor(MUTED))
        canvas.drawString(18 * mm, 10 * mm,
                          f"Synthèse des programmes {a0}–{a1} · orientationd/Lean_Programmes"
                          f"{meta['commit']} · modèle commun, chiffres indicatifs")
        canvas.drawRightString(A4[0] - 18 * mm, 10 * mm, str(doc.page))
        canvas.restoreState()

    doc = SimpleDocTemplate(str(sortie), pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm,
                            topMargin=16 * mm, bottomMargin=17 * mm,
                            title="Synthèse des programmes", author="orientation_d",
                            subject=f"Projections {a0}–{a1} sous hypothèses partagées")
    doc.build(story, onFirstPage=pied, onLaterPages=pied)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("entree", help="JSON produit par Rapport.lean --synthese")
    ap.add_argument("sortie", help="PDF à écrire")
    ap.add_argument("--commit", default=os.environ.get("GITHUB_SHA"))
    a = ap.parse_args()
    d = json.loads(Path(a.entree).read_text(encoding="utf-8"))
    if d.get("version") != 1:
        print(f"Version de synthèse inattendue : {d.get('version')}", file=sys.stderr)
        return 1
    construire(d, Path(a.sortie), a.commit)
    print(f"Synthèse PDF écrite : {a.sortie}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
