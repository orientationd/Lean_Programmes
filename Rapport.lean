import Programmes
import Moteurs
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
  moteur : Moteur
  scenario : Scenario
  tendanciel : Etat
  avec : Etat
  /-- Chaque propriété est évaluée à son année propre (`Propriete.horizon`). -/
  resultats : List (Propriete × Bool)

def evaluer (M : Moteur) (p : Programme) (H : Scenario) : Evaluation :=
  { moteur := M, scenario := H, tendanciel := tendanciel M H, avec := p.resultat M H
    resultats := Proprietes.toutes.map fun q => (q, decide (p.Verifie M H q)) }

def engagementTenu (p : Programme) (e : Engagement) : Bool :=
  decide (p.Verifie e.moteur e.scenario e.propriete)

def moteurs : List Moteur := Moteurs.tous
def standard : Moteur := Hypotheses.Moteurs.standard

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

/-- Variantes SRU des mesures : (mesure, nom de la variante, barème). -/
def variantesSRU (p : Programme) : List (String × String × BaremeSRU) :=
  p.mesures.flatMap fun m => m.variantes.flatMap fun v => v.leviers.filterMap fun
    | .amendeSRU b => some (m.id, v.nom, b)
    | _ => none

/-- Remplacements de véhicules : (mesure, version, opération), version
retenue puis variantes. -/
def remplacements (p : Programme) : List (String × String × Remplacement) :=
  p.mesures.flatMap fun m =>
    (m.leviers.filterMap fun
      | .remplacementVehicules r => some (m.id, "retenue", r)
      | _ => none) ++
    (m.variantes.flatMap fun v => v.leviers.filterMap fun
      | .remplacementVehicules r => some (m.id, v.nom, r)
      | _ => none)

/-- Centimes ↦ `"-166,6 M€"` (arrondi au dixième). -/
def fmtMEurosCts (cts : Int) : String :=
  let d := (cts.natAbs + 5000000) / 10000000
  s!"{if cts < 0 && d > 0 then "-" else ""}{d / 10},{d % 10} M€"

def equilibreTexte (h : HypAuto) (r : Remplacement) : String :=
  match r.anneeEquilibre h with
  | some n => s!"{n} ans"
  | none => "jamais"

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
    ("emissionsMt", toJson s.emissionsMt), ("ageLegalMois", toJson s.ageLegalMois),
    ("populationMilliers", toJson s.populationMilliers),
    ("actifs", toJson s.actifs),
    ("emploiTotal", toJson s.emploiTotal),
    ("pibParHabitant", toJson s.pibParHabitant),
    ("autresRecettes", toJson s.autresRecettes),
    ("chargeInterets", toJson s.chargeInterets),
    ("heuresParEmploi", toJson s.heuresParEmploi),
    ("emploisEtp", toJson s.emploisEtp),
    ("emploisAnnonces", toJson s.emploisAnnonces),
    ("touristesMilliers", toJson s.touristesMilliers),
    ("depenseParTouriste", toJson s.depenseParTouriste),
    ("recettesTourisme", toJson s.recettesTourisme),
    ("exportations", toJson s.exportations), ("importations", toJson s.importations),
    ("balanceCommerciale", toJson s.balanceCommerciale),
    ("balanceCourante", toJson s.balanceCourante), ("balanceCourantePb", toJson s.balanceCourantePb),
    ("robotisationPb", toJson s.robotisationPb),
    ("migrationAnnuelleMilliers", toJson s.migrationAnnuelleMilliers),

    ("heuresTotalesMillions", toJson s.heuresTotales),
    ("heuresParHabitant", toJson s.heuresParHabitant),
    ("pibParHeure", toJson s.pibParHeure),
    ("depensesParFonction", Json.mkObj <| Fonction.tous.map fun f => (f.id, toJson (s.depensesF.get f))),
    ("tauxApparentPb", toJson s.tauxApparentPb),
    ("soldePrimaire", toJson s.soldePrimaire),
    ("decesPollutionAir", toJson s.decesPollutionAir),
    ("parcElectriqueMilliers", toJson s.parcElectriqueMilliers),
    ("bornesMilliers", toJson s.bornesMilliers),
    ("operationsFinancieres", toJson s.operationsFinancieres),
    ("impots", Json.mkObj <| Impot.tous.map fun i => (i.id, toJson (s.impots.get i))),
    ("emploi", Json.mkObj <| Secteur.tous.map fun x => (x.id, toJson (s.emploi.get x)))]

def rapportJson : Json :=
  Json.mkObj [
    ("version", toJson (2 : Nat)),
    ("moteurs", Json.arr <| moteurs.toArray.map fun M =>
      Json.mkObj [("id", toJson M.id), ("nom", toJson M.nom), ("description", toJson M.description)]),
    ("scenarios", Json.arr <| Hypotheses.tous.toArray.map fun H =>
      Json.mkObj [("id", toJson H.id), ("demo", toJson H.demo.id),
        ("natalite", toJson H.natalite.id), ("eco", toJson H.eco.id),
        ("energie", toJson H.energie.id), ("droit", toJson H.droit.id),
        ("horizon", toJson H.horizon)]),
    ("proprietes", Json.arr <| Proprietes.toutes.toArray.map fun q =>
      Json.mkObj [("id", toJson q.id), ("titre", toJson q.titre),
        ("description", toJson q.description), ("annee", toJson q.annee)]),
    ("programmes", Json.arr <| Programmes.tous.toArray.map fun p =>
      Json.mkObj [
        ("id", toJson p.id), ("nom", toJson p.nom),
        ("nbMesures", toJson p.mesures.length),
        ("evaluations", Json.arr <| (moteurs.toArray.flatMap fun M => Hypotheses.tous.toArray.map fun H =>
          let ev := evaluer M p H
          Json.mkObj [
            ("moteur", toJson M.id), ("scenario", toJson H.id),
            ("tendanciel", etatJson ev.tendanciel),
            ("programme", etatJson ev.avec),
            ("proprietes", Json.mkObj <| ev.resultats.map fun (q, b) => (q.id, toJson b))])),
        ("engagements", Json.arr <| p.engagements.toArray.map fun e =>
          Json.mkObj [("moteur", toJson e.moteur.id), ("scenario", toJson e.scenario.id),
            ("propriete", toJson e.propriete.id),
            ("tenu", toJson (engagementTenu p e))]),
        ("contrats", Json.arr <| (contrats p).toArray.map fun (m, t) =>
          Json.mkObj [("mesure", toJson m), ("titre", toJson t)]),
        ("sru", Json.arr <| (baremesSRU p).toArray.flatMap fun (m, b) =>
          (panelSRU b).toArray.map fun l =>
            Json.mkObj [("mesure", toJson m), ("commune", toJson l.commune.id),
              ("actuel", toJson l.actuel), ("maxActuel", toJson l.maxActuel),
              ("amende", toJson l.amende), ("plafonnee", toJson l.plafonnee)]),
        ("automobile", Json.arr <| (remplacements p).toArray.flatMap fun (m, v, r) =>
          Hypotheses.Automobile.toutes.toArray.map fun h =>
            Json.mkObj [("mesure", toJson m), ("version", toJson v), ("hypothese", toJson h.id),
              ("coutEuros", toJson r.cout), ("importsInitialesCts", toJson r.importsInitialesCts),
              ("gainAnnuelCts", toJson (r.gainAnnuelCts h)),
              ("solde5ansCts", toJson (r.soldeCumuleCts h 5)),
              ("solde10ansCts", toJson (r.soldeCumuleCts h 10)),
              ("equilibre", toJson (equilibreTexte h r))])]),
    ("erreurs", toJson erreursRegistre)]

/-! ## Synthèse (données des graphiques et tableaux du PDF) -/

/-- Horizon de la synthèse, en années. -/
def horizonSynthese : Nat := 10

def sourcesJson (l : List String) : Json := toJson l

/-- Effet d'une mesure prise isolément : le programme réduit à cette seule
mesure, projeté `n` années sous le scénario central, comparé au tendanciel
et au programme complet. Mesure la contribution de chaque mesure à la
croissance, au solde et à l'emploi. -/
def effetMesure (M : Moteur) (p : Programme) (m : Mesure) (n : Nat) : Json :=
  let H := Hypotheses.central
  let seul : Programme := { p with mesures := [m] }
  let a := tendancielA M H n
  let s := seul.resultatA M H n
  Json.mkObj [
    ("mesure", toJson m.id), ("moteur", toJson M.id),
    ("pibPb", toJson (ratioPb (s.pib - a.pib) a.pib)),
    ("deficitPb", toJson (s.deficitPb - a.deficitPb)),
    ("dettePb", toJson (s.dettePb - a.dettePb)),
    ("emplois", toJson (s.emploiTotal - a.emploiTotal)),
    ("recettes", toJson (s.recettes - a.recettes)),
    ("depenses", toJson (s.depenses - a.depenses))]

def rapportSyntheseJson : Json :=
  let annee0 := Hypotheses.reference2026.annee
  let scens := Hypotheses.tous
  Json.mkObj [
    ("version", toJson (1 : Nat)),
    ("anneeDepart", toJson annee0),
    ("annees", toJson ((List.range (horizonSynthese + 1)).map (annee0 + ·))),
    ("horizonProprietes", toJson Hypotheses.horizon),
    ("nbScenarios", toJson scens.length),
    ("moteurs", Json.arr <| moteurs.toArray.map fun M =>
      Json.mkObj [("id", toJson M.id), ("nom", toJson M.nom), ("description", toJson M.description)]),
    ("moteurStandard", toJson standard.id),
    ("secteurs", Json.arr <| Secteur.tous.toArray.map fun x =>
      Json.mkObj [("id", toJson x.id), ("nom", toJson x.nom)]),
    ("impots", Json.arr <| Impot.tous.toArray.map fun i =>
      Json.mkObj [("id", toJson i.id), ("nom", toJson i.nom)]),
    ("fonctions", Json.arr <| Fonction.tous.toArray.map fun f =>
      Json.mkObj [("id", toJson f.id), ("nom", toJson f.nom)]),
    ("proprietes", Json.arr <| Proprietes.toutes.toArray.map fun q =>
      Json.mkObj [("id", toJson q.id), ("titre", toJson q.titre),
        ("description", toJson q.description), ("annee", toJson q.annee)]),
    ("programmes", Json.arr <| Programmes.tous.toArray.map fun p =>
      Json.mkObj [("id", toJson p.id), ("nom", toJson p.nom),
        ("description", toJson p.description), ("nbMesures", toJson p.mesures.length),
        ("mesures", Json.arr <| p.mesures.toArray.map fun m =>
          Json.mkObj [("id", toJson m.id), ("titre", toJson m.titre), ("debut", toJson m.debut)]),
        ("contrats", toJson ((contrats p).map fun (m, t) => s!"{m} — {t}")),
        -- effet de chaque mesure seule, à l'horizon de la synthèse, par moteur
        ("effetsMesures", Json.arr <| (moteurs.toArray.flatMap fun M =>
          p.mesures.toArray.map fun m => effetMesure M p m horizonSynthese)),
        ("effetTotal", Json.arr <| moteurs.toArray.map fun M =>
          let H := Hypotheses.central
          let a := tendancielA M H horizonSynthese
          let s := p.resultatA M H horizonSynthese
          Json.mkObj [("moteur", toJson M.id), ("pibPb", toJson (ratioPb (s.pib - a.pib) a.pib)),
            ("deficitPb", toJson (s.deficitPb - a.deficitPb)), ("emplois", toJson (s.emploiTotal - a.emploiTotal))]),
        ("engagements", Json.arr <| p.engagements.toArray.map fun e =>
          Json.mkObj [("moteur", toJson e.moteur.id), ("scenario", toJson e.scenario.id),
            ("propriete", toJson e.propriete.id), ("tenu", toJson (engagementTenu p e))]),
        -- par moteur : nombre de scénarios où chaque propriété tient, et statut au scénario central
        ("matrice", Json.mkObj <| moteurs.map fun M =>
          (M.id, Json.mkObj <| Proprietes.toutes.map fun q =>
            (q.id, toJson (scens.filter fun H => decide (p.Verifie M H q)).length))),
        ("central", Json.mkObj <| moteurs.map fun M =>
          (M.id, Json.mkObj <| Proprietes.toutes.map fun q =>
            (q.id, toJson (decide (p.Verifie M Hypotheses.central q)))))]),
    ("variantes", Json.arr <| Hypotheses.variantesSynthese.toArray.map fun (vid, nom, H) =>
      Json.mkObj [("id", toJson vid), ("nom", toJson nom), ("scenario", toJson H.id),
        ("natalite", toJson H.natalite.description), ("energie", toJson H.energie.description),
        ("icfCentiemes", toJson H.natalite.icfCentiemes),
        ("naissancesMilliers", toJson H.natalite.naissancesMilliers),
        ("prixBrentDollars", toJson H.energie.prixBrentDollars),
        ("prixReferenceDollars", toJson H.energie.prixReferenceDollars),
        ("effetPibPar10DollarsPb", toJson H.energie.effetPibPar10DollarsPb),
        ("decesEvitesParMillionVehicules", toJson H.energie.decesEvitesParMillionVehicules),
        ("vehiculesParBorne", toJson H.energie.vehiculesParBorne),
        ("chomageFrictionnelPb", toJson H.eco.chomageFrictionnelPb),
        ("soldeMigratoireMilliers", toJson H.demo.soldeMigratoireMilliers),
        ("partActiveMigrantsPm", toJson H.demo.partActiveMigrantsPm),
        ("moteurs", Json.mkObj <| moteurs.map fun M =>
          (M.id, Json.mkObj [
            ("tendanciel", Json.arr <| (trajectoire M H horizonSynthese (etatDepart H)).toArray.map etatJson),
            ("programmes", Json.mkObj <| Programmes.tous.map fun p =>
              (p.id, Json.arr <| (p.trajectoire M H horizonSynthese 0 (etatDepart H)).toArray.map etatJson))]))]),
    ("hypotheses", Json.mkObj [
      ("reference", Json.mkObj [("description", toJson Hypotheses.reference2026.description),
        ("sources", sourcesJson Hypotheses.reference2026.sources)]),
      ("demographie", Json.arr <| Hypotheses.Demo.toutes.toArray.map fun d =>
        Json.mkObj [("id", toJson d.id), ("description", toJson d.description),
          ("sources", sourcesJson d.sources)]),
      ("natalite", Json.arr <| Hypotheses.Natalite.toutes.toArray.map fun n =>
        Json.mkObj [("id", toJson n.id), ("description", toJson n.description),
          ("sources", sourcesJson n.sources)]),
      ("economie", Json.arr <| Hypotheses.Eco.toutes.toArray.map fun e =>
        Json.mkObj [("id", toJson e.id), ("description", toJson e.description),
          ("sources", sourcesJson e.sources)]),
      ("energie", Json.arr <| Hypotheses.Energie.toutes.toArray.map fun e =>
        Json.mkObj [("id", toJson e.id), ("description", toJson e.description),
          ("sources", sourcesJson e.sources)]),
      ("droit", Json.arr <| Hypotheses.Droit.toutes.toArray.map fun j =>
        Json.mkObj [("id", toJson j.id), ("description", toJson j.description),
          ("sources", sourcesJson j.sources)])])]

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
  out := out.push (ligne ["Programme", "Moteur", "Scénario", "Propriété", "Tenu"])
  out := out.push (separateur 5)
  let tousIds := scens.map (·.id)
  for p in Programmes.tous do
    for M in moteurs do
      for q in props do
        let es := p.engagements.filter fun e => e.propriete.id == q.id && e.moteur.id == M.id
        let couverts := (es.map (·.scenario.id)).eraseDups
        if !es.isEmpty && tousIds.all couverts.contains then
          -- engagement universel : une seule ligne
          let casses := es.filter fun e => !engagementTenu p e
          let detail := if casses.isEmpty then coche true
            else s!"{coche false} ({", ".intercalate (casses.map (·.scenario.id))})"
          out := out.push (ligne [p.id, M.id, s!"**tous** ({nS})", q.id, detail])
        else
          for e in es do
            out := out.push (ligne [p.id, M.id, e.scenario.id, q.id, coche (engagementTenu p e)])
  out := out.push ""

  -- Synthèse par moteur
  for M in moteurs do
    out := out.push s!"## Synthèse, moteur « {M.nom} » : scénarios où la propriété tient"
    out := out.push ""
    out := out.push M.description
    out := out.push ""
    out := out.push (ligne ("Programme" :: props.map (·.id)))
    out := out.push (separateur (props.length + 1))
    for p in Programmes.tous do
      let cellules := props.map fun q =>
        s!"{(scens.filter fun H => decide (p.Verifie M H q)).length}/{nS}"
      out := out.push (ligne (p.id :: cellules))
    out := out.push ""

  -- Détail par programme
  for p in Programmes.tous do
    out := out.push s!"## {p.nom}"
    out := out.push ""
    out := out.push p.description
    out := out.push ""
    out := out.push s!"<details><summary>Propriétés par scénario (moteur « {standard.nom} »)</summary>"
    out := out.push ""
    out := out.push (ligne ("Scénario" :: props.map (·.id)))
    out := out.push (separateur (props.length + 1))
    for H in scens do
      let ev := evaluer standard p H
      out := out.push (ligne (H.id :: ev.resultats.map fun (_, b) => coche b))
    out := out.push ""
    out := out.push "</details>"
    out := out.push ""
    out := out.push s!"<details><summary>Indicateurs à l'horizon, moteur « {standard.nom} » (tendanciel → programme)</summary>"
    out := out.push ""
    out := out.push (ligne ["Scénario", "Déficit % PIB", "Dette % PIB", "Chômage %", "Émissions Mt"])
    out := out.push (separateur 5)
    for H in scens do
      let ev := evaluer standard p H
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
      let versions := (("retenue", b) :: (variantesSRU p).filterMap fun (m', nom, b') =>
        if m' == m then some (nom, b') else none)
      if versions.length > 1 then
        let panel := Hypotheses.Communes.panel
        let tot (f : Commune → Int) := panel.foldl (fun acc c => acc + f c) 0
        out := out.push s!"<details><summary>{m} — comparaison des taux d'amende (communes fictives)</summary>"
        out := out.push ""
        out := out.push (ligne ["Version", "Barème", "Total du panel", "Communes plafonnées",
          "Charge maximale (% des DRF)"])
        out := out.push (separateur 5)
        out := out.push (ligne ["Droit actuel, prélèvement de base", "×1, plafond 5 %",
          fmtEuros (tot SRU.prelevementActuel), "", ""])
        out := out.push (ligne ["Droit actuel, maximum préfectoral", "jusqu'à ×5, plafond 5 % ou 7,5 %",
          fmtEuros (tot (SRU.majorationMaxActuelle Hypotheses.Communes.medianePFH)), "", ""])
        for (nom, b') in versions do
          let plafonnees := (panel.filter fun c => decide (c.plafond b'.plafondPb < b'.brut c)).length
          let charge := panel.foldl (fun acc c =>
            max acc (ratioPb (b'.amende c) c.depensesReellesFonctionnement)) 0
          out := out.push (ligne [nom,
            s!"{fmtCoef b'.coefMinPm} à {fmtCoef b'.coefMaxPm}, plafond {fmtPb b'.plafondPb} %",
            fmtEuros (tot b'.amende), s!"{plafonnees}/{panel.length}", s!"{fmtPb charge} %"])
        out := out.push ""
        out := out.push ("Destination des fonds : le prélèvement net va à l'EPCI délégataire des aides " ++
          "à la pierre ou à l'établissement public foncier, la majoration au FNAP. Effet direct sur " ++
          "le budget de l'État : nul. Ordre de grandeur : en PACA, bilan 2020-2022, 63,2 M€ nets et " ++
          "32,6 M€ de majorations (préfecture de région PACA).")
        out := out.push ""
        out := out.push "</details>"
        out := out.push ""

    let rs := remplacements p
    unless rs.isEmpty do
      out := out.push "<details><summary>Remplacement de véhicules — balance commerciale à 5 et 10 ans</summary>"
      out := out.push ""
      out := out.push ("Sous-modèle `Modele/Automobile.lean` : importations de véhicules l'année 0, puis " ++
        "chaque année carburant importé évité moins électricité non exportée. Pour mémoire, déficit " ++
        "commercial automobile de la France en 2025 ≈ 20 Md€ (Douanes).")
      out := out.push ""
      out := out.push (ligne ["Mesure", "Version", "Hypothèse", "Coût budgétaire", "Importations an 0",
        "Effet annuel", "Solde à 5 ans", "Solde à 10 ans", "Équilibre"])
      out := out.push (separateur 9)
      for (m, v, r) in rs do
        for h in Hypotheses.Automobile.toutes do
          out := out.push (ligne [m, v, h.id, fmtMEurosCts (r.cout * 100),
            fmtMEurosCts (-r.importsInitialesCts), s!"{fmtMEurosCts (r.gainAnnuelCts h)}/an",
            fmtMEurosCts (r.soldeCumuleCts h 5), fmtMEurosCts (r.soldeCumuleCts h 10),
            equilibreTexte h r])
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
  if args.contains "--synthese" then
    let f := option args "--synthese" "synthese.json"
    IO.FS.writeFile f (Rapport.rapportSyntheseJson.compress ++ "\n")
    IO.println s!"Synthèse écrite : {f}"
  IO.FS.writeFile fJson (Rapport.rapportJson.pretty ++ "\n")
  IO.FS.writeFile fMd Rapport.rapportMarkdown
  let errs := Rapport.erreursRegistre
  let casses := Programmes.tous.foldl (fun n p =>
    n + (p.engagements.filter fun e => !Rapport.engagementTenu p e).length) 0
  IO.println s!"Rapport écrit : {fJson}, {fMd}"
  IO.println s!"Engagements non tenus : {casses}"
  for e in errs do IO.eprintln s!"ERREUR : {e}"
  return if errs.isEmpty then 0 else 1
