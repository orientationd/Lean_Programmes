import Modele.Leviers

/-!
# Projection à l'horizon

Le même moteur projette le tendanciel et chaque programme :

* `tendanciel H = projeter H (situation de départ)`
* `avecProgramme H = projeter H (situation de départ + mesures)`

Les mesures sont appliquées en année 0 puis portées par la projection : leurs
effets sur le solde s'accumulent donc naturellement dans la dette.
-/

namespace Modele

/-- Une année de projection tendancielle. -/
def anneeSuivante (H : Scenario) (s : Etat) : Etat :=
  let pib := s.pib + appliquerPb s.pib H.eco.croissancePb
  -- assiettes supposées proportionnelles au PIB nominal (élasticité unitaire)
  let impots := s.impots.croitre H.eco.croissancePb
  let autresRecettes := s.autresRecettes + appliquerPb s.autresRecettes H.eco.croissancePb
  let recettes := impots.total + autresRecettes
  -- vieillissement : le surcoût total à l'horizon est réparti sur les années
  let surcoutVieillissement :=
    (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * H.eco.coutParPbPlus65
      / (H.horizon : Int)
  let depenses :=
    s.depenses + appliquerPb s.depenses H.eco.croissanceDepensesPb + surcoutVieillissement
  let actifs := s.actifs + appliquerPb s.actifs H.demo.croissanceActifsPb
  -- emploi : suit la population active à chômage constant, puis loi d'Okun
  -- (le chômage baisse de `okun × (croissance − seuil)`)
  let emploiSuivi := if s.actifs = 0 then 0 else s.emploiTotal * actifs / s.actifs
  let dOkun := actifs * (H.eco.croissancePb - H.eco.seuilOkunPb) * H.eco.okunPm / 10000000
  let s' : Etat := { s with
    pib := pib
    impots := impots
    autresRecettes := autresRecettes
    depenses := depenses
    dette := s.dette + (depenses - recettes) + s.operationsFinancieres
    emissionsMt := s.emissionsMt - appliquerPm s.emissionsMt H.eco.baisseEmissionsPm
    populationMilliers := s.populationMilliers + H.natalite.naissancesMilliers
      - H.demo.decesMilliers + H.demo.soldeMigratoireMilliers
    actifs := actifs }
  ajouterEmploi H none (emploiSuivi - s.emploiTotal + dOkun) s'

/-- Situation de départ du scénario : la référence observée, après le choc
de niveau dû au prix du pétrole (nul au prix de référence). -/
def etatDepart (H : Scenario) : Etat :=
  let s := H.reference.etat
  -- effet (pb du PIB par tranche de 10 $) × écart de prix / 10 $, sans arrondi intermédiaire
  let dPib := s.pib * H.energie.effetPibPar10DollarsPb
    * (H.energie.prixBrentDollars - H.energie.prixReferenceDollars) / 100000
  chocPib H none dPib s

/-- `f` appliquée `n` fois. -/
def iterer (f : Etat → Etat) : Nat → Etat → Etat
  | 0, s => s
  | n + 1, s => iterer f n (f s)

/-- Projette un état de départ jusqu'à l'horizon du scénario. -/
def projeter (H : Scenario) (s : Etat) : Etat :=
  iterer (anneeSuivante H) H.horizon s

/-- États successifs sur `n` années, état de départ compris (`n + 1` états). -/
def trajectoire (H : Scenario) : Nat → Etat → List Etat
  | 0, s => [s]
  | n + 1, s => s :: trajectoire H n (anneeSuivante H s)

/-- Situation à l'horizon sans aucun programme. -/
def tendanciel (H : Scenario) : Etat :=
  projeter H (etatDepart H)

end Modele
