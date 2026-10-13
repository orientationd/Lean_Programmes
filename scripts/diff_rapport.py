#!/usr/bin/env python3
"""Compare deux rapports JSON (base vs PR) et produit un résumé Markdown.

Usage :
    python3 scripts/diff_rapport.py BASE.json PR.json [--fichiers CHANGES.txt] [--out DIFF.md]

`--fichiers` : liste des chemins modifiés par la PR (un par ligne), pour
indiquer si la PR touche le socle commun (et donc tous les programmes).
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

SOCLE = ("Modele/", "Modele.lean", "Hypotheses/", "Hypotheses.lean",
         "Proprietes/", "Proprietes.lean", "lakefile.toml", "lean-toolchain")
INDICATEURS = [("deficitPb", "Déficit % PIB", True), ("dettePb", "Dette % PIB", True),
               ("chomagePb", "Chômage %", True), ("emissionsMt", "Émissions Mt", False)]
MAX_LIGNES = 30


def charger(chemin: str) -> dict:
    p = Path(chemin)
    if not p.exists():
        return {"scenarios": [], "proprietes": [], "programmes": [], "erreurs": []}
    return json.loads(p.read_text(encoding="utf-8"))


def fmt(v: int, pb: bool) -> str:
    if not pb:
        return str(v)
    signe = "-" if v < 0 else ""
    a = abs(v)
    return f"{signe}{a // 100},{a % 100:02d}"


def index_cellules(r: dict) -> dict:
    out = {}
    for p in r.get("programmes", []):
        for ev in p["evaluations"]:
            for prop, ok in ev["proprietes"].items():
                out[(p["id"], ev["scenario"], prop)] = ok
    return out


def index_indicateurs(r: dict) -> dict:
    return {(p["id"], ev["scenario"]): ev["programme"]
            for p in r.get("programmes", []) for ev in p["evaluations"]}


def index_engagements(r: dict) -> dict:
    return {(p["id"], e["scenario"], e["propriete"]): e["tenu"]
            for p in r.get("programmes", []) for e in p["engagements"]}


def ids(r: dict, cle: str) -> set:
    return {x["id"] for x in r.get(cle, [])}


def perimetre(fichiers: list[str]) -> list[str]:
    lignes = []
    socle = sorted({f for f in fichiers if f.startswith(SOCLE)})
    progs = sorted({f.split("/")[1] for f in fichiers
                    if f.startswith("Programmes/") and f.count("/") >= 2})
    if socle:
        lignes.append("> ⚠️ **Cette PR modifie le socle commun** (modèle, hypothèses ou "
                      "propriétés) : elle change l'évaluation de **tous** les programmes "
                      "et requiert la revue des mainteneurs du socle.")
        lignes.append(">")
        lignes.append("> Fichiers du socle : " + ", ".join(f"`{f}`" for f in socle))
    if progs:
        if lignes:
            lignes.append("")
        lignes.append("Programmes modifiés : " + ", ".join(f"`{p}`" for p in progs))
    return lignes


def diff(base: dict, pr: dict, fichiers: list[str]) -> str:
    out = ["## Impact de la PR sur l'évaluation", ""]
    out += perimetre(fichiers)
    if out[-1] != "":
        out.append("")

    for cle, nom in (("programmes", "Programmes"), ("scenarios", "Scénarios"),
                     ("proprietes", "Propriétés")):
        ajout = sorted(ids(pr, cle) - ids(base, cle))
        retrait = sorted(ids(base, cle) - ids(pr, cle))
        if ajout:
            out.append(f"- {nom} ajoutés : " + ", ".join(f"`{x}`" for x in ajout))
        if retrait:
            out.append(f"- {nom} retirés : " + ", ".join(f"`{x}`" for x in retrait))

    # Engagements
    eb, ep = index_engagements(base), index_engagements(pr)
    casses = sorted(k for k, v in ep.items() if not v)
    nouvellement_casses = [k for k in casses if eb.get(k, True)]
    if casses:
        out += ["", "### ❌ Engagements non tenus", "",
                "| Programme | Scénario | Propriété | Nouveau ? |", "| --- | --- | --- | --- |"]
        for k in casses[:MAX_LIGNES]:
            out.append(f"| {k[0]} | {k[1]} | {k[2]} | {'oui' if k in nouvellement_casses else 'non'} |")
        if len(casses) > MAX_LIGNES:
            out.append(f"| … | {len(casses) - MAX_LIGNES} de plus | | |")

    # Cellules de la matrice
    cb, cp = index_cellules(base), index_cellules(pr)
    changes = sorted(k for k in cb.keys() & cp.keys() if cb[k] != cp[k])
    if changes:
        out += ["", f"### Propriétés qui changent de statut ({len(changes)})", "",
                "| Programme | Scénario | Propriété | Avant | Après |",
                "| --- | --- | --- | --- | --- |"]
        for k in changes[:MAX_LIGNES]:
            out.append(f"| {k[0]} | {k[1]} | {k[2]} | {'✅' if cb[k] else '❌'} | {'✅' if cp[k] else '❌'} |")
        if len(changes) > MAX_LIGNES:
            out.append(f"| … | {len(changes) - MAX_LIGNES} de plus | | | |")

    # Indicateurs
    ib, ip = index_indicateurs(base), index_indicateurs(pr)
    lignes = []
    for k in sorted(ib.keys() & ip.keys()):
        deltas = []
        for champ, libelle, pb in INDICATEURS:
            a, b = ib[k][champ], ip[k][champ]
            if a != b:
                deltas.append(f"{libelle} {fmt(a, pb)} → {fmt(b, pb)}")
        if deltas:
            lignes.append(f"| {k[0]} | {k[1]} | {'<br>'.join(deltas)} |")
    if lignes:
        out += ["", f"<details><summary>Indicateurs modifiés ({len(lignes)} couples programme × scénario)</summary>",
                "", "| Programme | Scénario | Changements |", "| --- | --- | --- |"]
        out += lignes[:MAX_LIGNES]
        if len(lignes) > MAX_LIGNES:
            out.append(f"| … | {len(lignes) - MAX_LIGNES} de plus | |")
        out += ["", "</details>"]

    if pr.get("erreurs"):
        out += ["", "### ⛔ Erreurs de registre", ""] + [f"- {e}" for e in pr["erreurs"]]

    if not (changes or lignes or casses or pr.get("erreurs")) and len(out) <= 3:
        out.append("Aucun changement d'évaluation.")
    elif not (changes or lignes or casses or pr.get("erreurs")):
        out += ["", "Aucun changement sur les programmes existants."]
    return "\n".join(out) + "\n"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("base")
    ap.add_argument("pr")
    ap.add_argument("--fichiers")
    ap.add_argument("--out")
    a = ap.parse_args()
    fichiers = []
    if a.fichiers and Path(a.fichiers).exists():
        fichiers = [l.strip() for l in Path(a.fichiers).read_text().splitlines() if l.strip()]
    texte = diff(charger(a.base), charger(a.pr), fichiers)
    if a.out:
        Path(a.out).write_text(texte, encoding="utf-8")
    else:
        sys.stdout.write(texte)
    return 0


if __name__ == "__main__":
    sys.exit(main())
