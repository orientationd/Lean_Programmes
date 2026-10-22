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
  -- assiettes supposées proportionnelles au PIB nominal (élasticité unitaire)
  let impots := s.impots.croitre croissance
  let autresRecettes := s.autresRecettes + appliquerPb s.autresRecettes croissance
  let recettes := impots.total + autresRecettes
  -- vieillissement : le surcoût total à l'horizon est réparti sur les années
  let surcoutVieillissement :=
    (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * H.eco.coutParPbPlus65
      / (H.horizon : Int)
  -- charge d'intérêts : taux apparent qui converge vers le taux marginal,
  -- appliqué à la dette de fin d'année précédente (effet boule de neige)
  let taux := min H.eco.tauxMarginalPb (s.tauxApparentPb + H.eco.deriveTauxPb)
  let interets := s.dette * taux / 10000
  let surcoutSante :=
    (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * H.eco.coutSanteParPbPlus65
      / (H.horizon : Int)
  let depensesF := (((s.depensesF.croitrePrimaires H.eco.croissanceDepensesPb s.robotisationPb)
    |>.ajouter .retraites surcoutVieillissement)
    |>.ajouter .sante surcoutSante)
    |>.ajouter .interets (interets - s.depensesF.interets)
  let depenses := depensesF.total
  -- population active : tendance hors migrations + part active du solde migratoire
  let solde := H.demo.soldeMigratoireMilliers + s.migrationAnnuelleMilliers
  let actifs := s.actifs + appliquerPb s.actifs H.demo.croissanceActifsPb
    + appliquerPm (solde * 1000) H.demo.partActiveMigrantsPm
  -- emploi : suit la population active à chômage constant, puis loi d'Okun
  -- (le chômage baisse de `okun × (croissance − seuil)`)
  let emploiSuivi := if s.actifs = 0 then 0 else s.emploiTotal * actifs / s.actifs
  let dOkun := actifs * (croissance - H.eco.seuilOkunPb) * H.eco.okunPm / 10000000
  -- transports : parc électrique, bornes, décès évités par la baisse des particules
  let dParc := H.energie.electrificationTendancielleMilliers + s.electrificationAnnuelleMilliers
  let s' : Etat := { s with
    pib := pib
    impots := impots
    autresRecettes := autresRecettes
    depensesF := depensesF
    tauxApparentPb := taux
    dette := s.dette + (depenses - recettes) + s.operationsFinancieres
    emissionsMt := s.emissionsMt - appliquerPm s.emissionsMt H.eco.baisseEmissionsPm
    populationMilliers := s.populationMilliers + H.natalite.naissancesMilliers
      - H.demo.decesMilliers + solde
    actifs := actifs
    depenseParTouriste := s.depenseParTouriste + appliquerPb s.depenseParTouriste croissance
    parcElectriqueMilliers := s.parcElectriqueMilliers + dParc
    bornesMilliers := s.bornesMilliers + H.energie.bornesTendanciellesMilliers + s.bornesAnnuellesMilliers
    decesPollutionAir := max 0 (s.decesPollutionAir
      - dParc * H.energie.decesEvitesParMillionVehicules / 1000) }
  ajouterEmploi H none (emploiSuivi - s.emploiTotal + dOkun) s'

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
