import Modele.Leviers

/-!
# Projection à l'horizon

Le même moteur projette le tendanciel et chaque programme :

* `tendanciel H = projeter H (situation de départ)`
* `avecProgramme H = projeter H (situation de départ + mesures)`

Les mesures sont appliquées l'année de leur entrée en vigueur (`Mesure.debut`,
0 par défaut) puis portées par la projection : leurs effets sur le solde
s'accumulent dans la dette, dont la charge d'intérêts suit.
-/

namespace Modele

/-- Une année de projection sous un moteur. -/
def anneeSuivante (M : Moteur) (H : Scenario) (s : Etat) : Etat :=
  -- effet d'offre (moteur) : prélèvements obligatoires au-dessus du niveau
  -- de départ → croissance amputée ; en dessous → croissance accrue
  let croissance := H.eco.croissancePb
    - appliquerPm (s.prelevementsPb - H.reference.etat.prelevementsPb) M.elasticiteCroissancePoPm
  let pib := s.pib + appliquerPb s.pib croissance
  -- charge d'intérêts : taux apparent qui converge vers le taux marginal,
  -- appliqué à la dette de fin d'année précédente (effet boule de neige)
  let taux := min H.eco.tauxMarginalPb (s.tauxApparentPb + H.eco.deriveTauxPb)
  -- OAT numériques : la tranche `part` de la dette est servie au taux
  -- apparent diminué de la décote ; ses intérêts, pour la part défiscalisée,
  -- échappent au PFU (perte de recettes de l'année)
  let tranche := s.dette * s.partDetteNumeriquePm / 1000
  let economieNum := tranche * taux * s.decoteDetteNumeriquePm / 10000000
  let interetsTranche := tranche * taux / 10000 - economieNum
  let tPfu := H.eco.tauxPfuIrPm + H.eco.tauxPfuCsgCrdsPm + H.eco.tauxPfuSolidaritePm
  let pertePfu := interetsTranche * s.partDefiscaliseePm * tPfu / 1000000
  let interets := s.dette * taux / 10000 - economieNum
  -- assiettes supposées proportionnelles au PIB nominal (élasticité unitaire)
  -- la perte de PFU de l'an dernier est déjà dans l'assiette et croît avec
  -- elle : on n'ajoute que l'écart, réparti selon l'affectation du PFU
  let dPerte := pertePfu - (s.pertePfuMeur + appliquerPb s.pertePfuMeur croissance)
  let dIr := if tPfu = 0 then 0 else dPerte * H.eco.tauxPfuIrPm / tPfu
  let dCsg := if tPfu = 0 then 0 else dPerte * H.eco.tauxPfuCsgCrdsPm / tPfu
  let impots := ((s.impots.croitre croissance).ajouter .ir (-dIr)
    |>.ajouter .csgCrds (-dCsg)) |>.ajouter .autres (-(dPerte - dIr - dCsg))
  let autresRecettes := s.autresRecettes + appliquerPb s.autresRecettes croissance
  let recettes := impots.total + autresRecettes
  -- vieillissement : le surcoût total à l'horizon est réparti sur les années
  let surcoutVieillissement :=
    (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * H.eco.coutParPbPlus65
      / (H.horizon : Int)
  let surcoutSante :=
    (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * H.eco.coutSanteParPbPlus65
      / (H.horizon : Int)
  let depensesF := (((s.depensesF.croitrePrimaires H.eco.croissanceDepensesPb s.robotisationPb)
    |>.ajouter .retraites surcoutVieillissement)
    |>.ajouter .sante surcoutSante)
    |>.ajouter .interets (interets - s.depensesF.interets)
  let depenses := depensesF.total
  -- population active : tendance démographique et migrations du scénario
  -- d'une part, migrations dues aux mesures d'autre part
  let solde := H.demo.soldeMigratoireMilliers + s.migrationAnnuelleMilliers
  let actifsTendance := appliquerPb s.actifs H.demo.croissanceActifsPb
    + appliquerPm (H.demo.soldeMigratoireMilliers * 1000) H.demo.partActiveMigrantsPm
  let actifsMesures := appliquerPm (s.migrationAnnuelleMilliers * 1000) H.demo.partActiveMigrantsPm
  -- emploi : la tendance est absorbée au taux d'emploi courant (chômage
  -- tendanciel inchangé) ; les migrants dus aux mesures entrent au taux
  -- d'emploi des immigrés ; l'écart à l'emploi d'équilibre se résorbe
  let emploiTendance := if s.actifs = 0 then 0 else actifsTendance * s.emploiTotal / s.actifs
  let emploiEntrants := appliquerPm actifsMesures H.eco.tauxEmploiMigrantsPm
  let equilibreEntrants := if s.actifs = 0 then 0 else actifsMesures * s.emploiTotal / s.actifs
  let absorption := appliquerPm s.chomeursExcedentaires H.eco.absorptionChomagePm
  -- loi d'Okun : le chômage baisse de `okun × (croissance − seuil)` ; emplois
  -- et actifs supplémentaires s'en déduisent par l'effet de flexion
  let actifs := s.actifs + actifsTendance + actifsMesures
  let dChomeursOkun := actifs * (croissance - H.eco.seuilOkunPb) * H.eco.okunPm / 10000000
  let emploisOkun := emploisPourChomeurs H dChomeursOkun
  -- transports : parc électrique, bornes, décès évités par la baisse des particules
  let dParc := H.energie.electrificationTendancielleMilliers + s.electrificationAnnuelleMilliers
  let s' : Etat := { s with
    pib := pib
    impots := impots
    autresRecettes := autresRecettes
    depensesF := depensesF
    tauxApparentPb := taux
    partDetteNumeriquePm := min s.cibleDetteNumeriquePm (s.partDetteNumeriquePm + s.rythmeDetteNumeriquePm)
    economieInteretsNumeriqueMeur := economieNum
    pertePfuMeur := pertePfu
    dette := s.dette + (depenses - recettes) + s.operationsFinancieres
    emissionsMt := s.emissionsMt - appliquerPm s.emissionsMt H.eco.baisseEmissionsPm
    populationMilliers := s.populationMilliers + H.natalite.naissancesMilliers
      - H.demo.decesMilliers + solde
    actifs := actifs + (emploisOkun - dChomeursOkun)
    chomeursExcedentaires := s.chomeursExcedentaires - absorption + (equilibreEntrants - emploiEntrants)
    depenseParTouriste := s.depenseParTouriste + appliquerPb s.depenseParTouriste croissance
    -- commerce extérieur : exportations et importations suivent le PIB nominal,
    -- plus les flux d'importations dus aux mesures
    exportations := s.exportations + appliquerPb s.exportations croissance
    importations := s.importations + appliquerPb s.importations croissance + s.variationImportsAnnuelle
    parcElectriqueMilliers := s.parcElectriqueMilliers + dParc
    bornesMilliers := s.bornesMilliers + H.energie.bornesTendanciellesMilliers + s.bornesAnnuellesMilliers
    decesPollutionAir := max 0 (s.decesPollutionAir
      - dParc * H.energie.decesEvitesParMillionVehicules / 1000) }
  let s₁ := ajouterEmploi H none (emploiTendance + emploisOkun) s'
  -- l'emploi dû aux mesures (entrants, résorption) produit : PIB à l'élasticité
  -- du scénario (la tendance est déjà dans la croissance)
  let dEmploiMesures := emploiEntrants + absorption
  let s₂ := chocEmploi H dEmploiMesures (ajouterEmploi H none dEmploiMesures s₁)
  -- dépenses à échéancier : niveau prévu (indexé) moins niveau reconduit, avec
  -- son effet de demande
  let pas (e : Echeance) : Echeance × Int :=
    let t := ParFonction.tauxCroissance e.fonction H.eco.croissanceDepensesPb s.robotisationPb
    let indice := e.indice + appliquerPb e.indice t
    let reconduit := e.niveau + appliquerPb e.niveau t
    match e.restants with
    | [] => ({ e with indice := indice, niveau := reconduit }, 0)
    | x :: r =>
      let prevu := x * indice / 10000
      ({ e with restants := r, indice := indice, niveau := prevu }, prevu - reconduit)
  let pasEcheances := s.echeances.map pas
  pasEcheances.foldl
    (fun st (e, d) => effetDemande H e.fonction.secteur d
      { st with depensesF := st.depensesF.ajouter e.fonction d })
    { s₂ with echeances := pasEcheances.map (·.1) }

/-- Situation de départ du scénario : la référence observée, après le choc
de niveau dû au prix du pétrole (nul au prix de référence). -/
def etatDepart (H : Scenario) : Etat :=
  let s := H.reference.etat
  -- effet (pb du PIB par tranche de 10 $) × écart de prix / 10 $, sans arrondi intermédiaire
  let dPib := s.pib * H.energie.effetPibPar10DollarsPb
    * (H.energie.prixBrentDollars - H.energie.prixReferenceDollars) / 100000
  -- facture énergétique importée proportionnelle au prix du Brent
  let dImports := H.energie.factureEnergetiqueMeur
    * (H.energie.prixBrentDollars - H.energie.prixReferenceDollars) / H.energie.prixReferenceDollars
  let s := { s with importations := s.importations + dImports, robotisationPb := H.eco.robotisationTendanciellePb }
  chocPib H none dPib s

/-- `f` appliquée `n` fois. -/
def iterer (f : Etat → Etat) : Nat → Etat → Etat
  | 0, s => s
  | n + 1, s => iterer f n (f s)

/-- Projette un état de départ sur `n` années. -/
def projeterN (M : Moteur) (H : Scenario) (n : Nat) (s : Etat) : Etat :=
  iterer (anneeSuivante M H) n s

/-- Projette un état de départ jusqu'à l'horizon du scénario. -/
def projeter (M : Moteur) (H : Scenario) (s : Etat) : Etat :=
  projeterN M H H.horizon s

/-- États successifs sur `n` années, état de départ compris (`n + 1` états). -/
def trajectoire (M : Moteur) (H : Scenario) : Nat → Etat → List Etat
  | 0, s => [s]
  | n + 1, s => s :: trajectoire M H n (anneeSuivante M H s)

/-- Situation sans programme après `n` années. -/
def tendancielA (M : Moteur) (H : Scenario) (n : Nat) : Etat :=
  projeterN M H n (etatDepart H)

/-- Situation à l'horizon sans aucun programme. -/
def tendanciel (M : Moteur) (H : Scenario) : Etat :=
  tendancielA M H H.horizon

end Modele
