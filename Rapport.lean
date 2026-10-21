import Programmes
import Lean.Data.Json

/-!
# Rapport d'évaluation

`lake exe rapport [--json FICHIER] [--md FICHIER]`

Calcule la matrice programme × scénario × propriété et l'état des
engagements, puis écrit :
* un JSON stable (comparé entre la branche de base et la PR par
  `scripts/diff_rapport.py`) ;
* un Markdown lisible (résumé de job CI, commentaire de PR).

Le rapport ne dépend **pas** de `Engagements` : il se construit même quand un
engagement est cassé, et c'est lui qui dit lequel.

Code de sortie : 0 si la structure est saine, 1 en cas d'identifiants
dupliqués ou de scénario invalide (erreurs de registre).
-/

open Modele Lean

namespace Rapport

/-! ## Mise en forme -/

/-- `581` (pb) ↦ `"5,81"`. -/
def fmtPb (x : Int) : String :=
  let signe := if x < 0 then "-" else ""
  let a := x.natAbs
  let frac := toString (a % 100)
  let frac := if frac.length < 2 then "0" ++ frac else frac
  s!"{signe}{a / 100},{frac}"

def coche (b : Bool) : String := if b then "✅" else "❌"

def ligne (cellules : List String) : String :=
  "| " ++ " | ".intercalate cellules ++ " |"

def separateur (n : Nat) : String :=
  ligne (List.replicate n "---")

/-- `1218750` ↦ `"1 218 750 €"` (espace fine insécable). -/
def fmtEuros (x : Int) : String :=
  let chiffres := (toString x.natAbs).toList
  let groupes := (chiffres.reverse.toArray.toList.foldl (fun (acc : List (List Char)) ch =>
    match acc with
    | g :: rest => if g.length < 3 then (ch :: g) :: rest else [ch] :: g :: rest
    | [] => [[ch]]) []).map String.ofList
  (if x < 0 then "-" else "") ++ " ".intercalate groupes ++ " €"

/-- Coefficient en pm ↦ `"×1,48"`. -/
def fmtCoef (pm : Int) : String :=
  let frac := toString ((pm.natAbs % 1000) / 10)
  s!"×{pm.natAbs / 1000},{if frac.length < 2 then "0" ++ frac else frac}"

/-! ## Calculs -/

structure Evaluation where
  scenario : Scenario
  tendanciel : Etat
  avec : Etat
  resultats : List (Propriete × Bool)

def evaluer (p : Programme) (H : Scenario) : Evaluation :=
  let a := tendanciel H
  let s := p.resultat H
  { scenario := H, tendanciel := a, avec := s
    resultats := Proprietes.toutes.map fun q => (q, q.evaluer H a s) }

def engagementTenu (p : Programme) (e : Engagement) : Bool :=
  e.propriete.evaluer e.scenario (tendanciel e.scenario) (p.resultat e.scenario)

/-- Contrats des mesures : (mesure, titre). Ils sont prouvés par
construction : un contrat faux empêche la compilation. -/
def contrats (p : Programme) : List (String × String) :=
  p.mesures.flatMap fun m => m.contrats.map fun k => (m.id, k.titre)

/-- Mesures utilisant le levier `amendeSRU`, avec leur barème. -/
def baremesSRU (p : Programme) : List (String × BaremeSRU) :=
  p.mesures.flatMap fun m => m.leviers.filterMap fun
    | .amendeSRU b => some (m.id, b)
    | _ => none

structure LigneSRU where
  commune : Commune
  actuel : Int
  maxActuel : Int
  amende : Int
  plafonnee : Bool

def panelSRU (b : BaremeSRU) : List LigneSRU :=
  Hypotheses.Communes.panel.map fun c =>
    { commune := c, actuel := SRU.prelevementActuel c
      maxActuel := SRU.majorationMaxActuelle Hypotheses.Communes.medianePFH c
      amende := b.amende c
      plafonnee := decide (c.plafond b.plafondPb < b.brut c) }

/-- Identifiants présents plusieurs fois dans une liste. -/
def doublons (ids : List String) : List String :=
  (ids.filter fun i => (ids.filter (· == i)).length > 1).eraseDups

def erreursRegistre : List String := Id.run do
  let mut errs : List String := []
  for d in doublons (Programmes.tous.map (·.id)) do
    errs := errs ++ [s!"identifiant de programme dupliqué : {d}"]
  for d in doublons (Hypotheses.tous.map (·.id)) do
    errs := errs ++ [s!"identifiant de scénario dupliqué : {d}"]
  for d in doublons (Proprietes.toutes.map (·.id)) do
    errs := errs ++ [s!"identifiant de propriété dupliqué : {d}"]
  for p in Programmes.tous do
    for d in doublons (p.mesures.map (·.id)) do
      errs := errs ++ [s!"{p.id} : identifiant de mesure dupliqué : {d}"]
  for H in Hypotheses.tous do
    unless decide H.Valide do
      errs := errs ++ [s!"scénario invalide (hors bornes de plausibilité) : {H.id}"]
  return errs

/-! ## JSON -/

def etatJson (s : Etat) : Json :=
  Json.mkObj [
    ("pib", toJson s.pib), ("recettes", toJson s.recettes),
    ("depenses", toJson s.depenses), ("dette", toJson s.dette),
    ("deficitPb", toJson s.deficitPb), ("dettePb", toJson s.dettePb),
    ("chomagePb", toJson s.chomagePb), ("smicMensuel", toJson s.smicMensuel),
    ("emissionsMt", toJson s.emissionsMt), ("ageLegalMois", toJson s.ageLegalMois)]

def rapportJson : Json :=
  Json.mkObj [
    ("version", toJson (1 : Nat)),
    ("scenarios", Json.arr <| Hypotheses.tous.toArray.map fun H =>
      Json.mkObj [("id", toJson H.id), ("demo", toJson H.demo.id),
        ("eco", toJson H.eco.id), ("droit", toJson H.droit.id),
        ("horizon", toJson H.horizon)]),
    ("proprietes", Json.arr <| Proprietes.toutes.toArray.map fun q =>
      Json.mkObj [("id", toJson q.id), ("titre", toJson q.titre),
        ("description", toJson q.description)]),
    ("programmes", Json.arr <| Programmes.tous.toArray.map fun p =>
      Json.mkObj [
        ("id", toJson p.id), ("nom", toJson p.nom),
        ("nbMesures", toJson p.mesures.length),
        ("evaluations", Json.arr <| Hypotheses.tous.toArray.map fun H =>
          let ev := evaluer p H
          Json.mkObj [
            ("scenario", toJson H.id),
            ("tendanciel", etatJson ev.tendanciel),
            ("programme", etatJson ev.avec),
            ("proprietes", Json.mkObj <| ev.resultats.map fun (q, b) => (q.id, toJson b))]),
        ("engagements", Json.arr <| p.engagements.toArray.map fun e =>
          Json.mkObj [("scenario", toJson e.scenario.id),
            ("propriete", toJson e.propriete.id),
            ("tenu", toJson (engagementTenu p e))]),
        ("contrats", Json.arr <| (contrats p).toArray.map fun (m, t) =>
          Json.mkObj [("mesure", toJson m), ("titre", toJson t)]),
        ("sru", Json.arr <| (baremesSRU p).toArray.flatMap fun (m, b) =>
          (panelSRU b).toArray.map fun l =>
            Json.mkObj [("mesure", toJson m), ("commune", toJson l.commune.id),
              ("actuel", toJson l.actuel), ("maxActuel", toJson l.maxActuel),
              ("amende", toJson l.amende), ("plafonnee", toJson l.plafonnee)])]),
    ("erreurs", toJson erreursRegistre)]

/-! ## Markdown -/

def rapportMarkdown : String := Id.run do
  let props := Proprietes.toutes
  let scens := Hypotheses.tous
  let nS := scens.length
  let mut out : Array String := #[]
  out := out.push "# Rapport d'évaluation"
  out := out.push ""
  out := out.push s!"{Programmes.tous.length} programmes × {nS} scénarios × {props.length} propriétés."
  out := out.push ""

  let errs := erreursRegistre
  unless errs.isEmpty do
    out := out.push "## ⛔ Erreurs de registre"
    for e in errs do out := out.push s!"- {e}"
    out := out.push ""

  -- Engagements
  out := out.push "## Engagements revendiqués"
  out := out.push ""
  out := out.push (ligne ["Programme", "Scénario", "Propriété", "Tenu"])
  out := out.push (separateur 4)
  let tousIds := scens.map (·.id)
  for p in Programmes.tous do
    for q in props do
      let es := p.engagements.filter (·.propriete.id == q.id)
      let couverts := (es.map (·.scenario.id)).eraseDups
      if !es.isEmpty && tousIds.all couverts.contains then
        -- engagement universel : une seule ligne
        let casses := es.filter fun e => !engagementTenu p e
        let detail := if casses.isEmpty then coche true
          else s!"{coche false} ({", ".intercalate (casses.map (·.scenario.id))})"
        out := out.push (ligne [p.id, s!"**tous** ({nS})", q.id, detail])
      else
        for e in es do
          out := out.push (ligne [p.id, e.scenario.id, q.id, coche (engagementTenu p e)])
  out := out.push ""

  -- Synthèse
  out := out.push "## Synthèse : scénarios où la propriété tient"
  out := out.push ""
  out := out.push (ligne ("Programme" :: props.map (·.id)))
  out := out.push (separateur (props.length + 1))
  for p in Programmes.tous do
    let evs := scens.map (evaluer p)
    let cellules := props.map fun q =>
      let n := (evs.filter fun ev =>
        ev.resultats.any fun (q', b) => q'.id == q.id && b).length
      s!"{n}/{nS}"
    out := out.push (ligne (p.id :: cellules))
  out := out.push ""

  -- Détail par programme
  for p in Programmes.tous do
    out := out.push s!"## {p.nom}"
    out := out.push ""
    out := out.push p.description
    out := out.push ""
    out := out.push "<details><summary>Propriétés par scénario</summary>"
    out := out.push ""
    out := out.push (ligne ("Scénario" :: props.map (·.id)))
    out := out.push (separateur (props.length + 1))
    for H in scens do
      let ev := evaluer p H
      out := out.push (ligne (H.id :: ev.resultats.map fun (_, b) => coche b))
    out := out.push ""
    out := out.push "</details>"
    out := out.push ""
    out := out.push "<details><summary>Indicateurs à l'horizon (tendanciel → programme)</summary>"
    out := out.push ""
    out := out.push (ligne ["Scénario", "Déficit % PIB", "Dette % PIB", "Chômage %", "Émissions Mt"])
    out := out.push (separateur 5)
    for H in scens do
      let ev := evaluer p H
      let a := ev.tendanciel
      let s := ev.avec
      out := out.push (ligne [H.id,
        s!"{fmtPb a.deficitPb} → {fmtPb s.deficitPb}",
        s!"{fmtPb a.dettePb} → {fmtPb s.dettePb}",
        s!"{fmtPb a.chomagePb} → {fmtPb s.chomagePb}",
        s!"{a.emissionsMt} → {s.emissionsMt}"])
    out := out.push ""
    out := out.push "</details>"
    out := out.push ""
    let ks := contrats p
    unless ks.isEmpty do
      out := out.push "**Contrats des mesures** (prouvés pour tous les cas, vérifiés à la compilation) :"
      out := out.push ""
      for (m, t) in ks do
        out := out.push s!"- ✅ {m} — {t}"
      out := out.push ""
    for (m, b) in baremesSRU p do
      let lignes := panelSRU b
      out := out.push s!"<details><summary>{m} — panel communal SRU (communes fictives)</summary>"
      out := out.push ""
      out := out.push "Neutre sur le solde consolidé des APU (transfert communes → FNAP / EPF) : aucun effet sur la matrice ci-dessus."
      out := out.push ""
      out := out.push (ligne ["Commune", "Logements sociaux", "Part manquante", "Droit actuel (base)",
        "Maximum préfectoral actuel", s!"Amende {m}", "Coefficient"])
      out := out.push (separateur 7)
      for l in lignes do
        let c := l.commune
        out := out.push (ligne [c.id, s!"{fmtPb c.tauxLogementsSociauxPb} % / {fmtPb c.tauxLegalPb} %",
          s!"{fmtPb (c.partManquantePm * 10)} %", fmtEuros l.actuel, fmtEuros l.maxActuel,
          fmtEuros l.amende,
          if c.manquants = 0 then "—"
          else if l.plafonnee then s!"{fmtCoef (b.coefPm c)} → plafonné"
          else fmtCoef (b.coefPm c)])
      let total (f : LigneSRU → Int) := lignes.foldl (fun acc l => acc + f l) 0
      out := out.push (ligne ["**Total**", "", "", fmtEuros (total (·.actuel)),
        fmtEuros (total (·.maxActuel)), fmtEuros (total (·.amende)), ""])
      out := out.push ""
      out := out.push "</details>"
      out := out.push ""

  -- Légende
  out := out.push "## Propriétés"
  out := out.push ""
  for q in props do
    out := out.push s!"- **{q.id}** — {q.titre}. {q.description}"
  out := out.push ""
  out := out.push "_Modèle et hypothèses provisoires : voir README._"
  return "\n".intercalate out.toList ++ "\n"

end Rapport

/-- Valeur de l'option `--nom` dans `args`, sinon `defaut`. -/
def option (args : List String) (nom defaut : String) : String :=
  match args.dropWhile (· != nom) with
  | _ :: v :: _ => v
  | _ => defaut

def main (args : List String) : IO UInt32 := do
  let fJson := option args "--json" "rapport.json"
  let fMd := option args "--md" "rapport.md"
  IO.FS.writeFile fJson (Rapport.rapportJson.pretty ++ "\n")
  IO.FS.writeFile fMd Rapport.rapportMarkdown
  let errs := Rapport.erreursRegistre
  let casses := Programmes.tous.foldl (fun n p =>
    n + (p.engagements.filter fun e => !Rapport.engagementTenu p e).length) 0
  IO.println s!"Rapport écrit : {fJson}, {fMd}"
  IO.println s!"Engagements non tenus : {casses}"
  for e in errs do IO.eprintln s!"ERREUR : {e}"
  return if errs.isEmpty then 0 else 1
