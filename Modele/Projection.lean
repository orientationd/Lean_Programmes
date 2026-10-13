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
  let recettes := s.recettes + appliquerPb s.recettes H.eco.croissancePb
  -- vieillissement : le surcoût total à l'horizon est réparti sur les années
  let surcoutVieillissement :=
    (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * H.eco.coutParPbPlus65
      / (H.horizon : Int)
  let depenses :=
    s.depenses + appliquerPb s.depenses H.eco.croissanceDepensesPb + surcoutVieillissement
  let chomage :=
    s.chomagePb - appliquerPm (H.eco.croissancePb - H.eco.seuilOkunPb) H.eco.okunPm
  { s with
    pib := pib
    recettes := recettes
    depenses := depenses
    dette := s.dette + (depenses - recettes)
    chomagePb := max chomage H.eco.chomageFrictionnelPb
    emissionsMt := s.emissionsMt - appliquerPm s.emissionsMt H.eco.baisseEmissionsPm }

/-- `f` appliquée `n` fois. -/
def iterer (f : Etat → Etat) : Nat → Etat → Etat
  | 0, s => s
  | n + 1, s => iterer f n (f s)

/-- Projette un état de départ jusqu'à l'horizon du scénario. -/
def projeter (H : Scenario) (s : Etat) : Etat :=
  iterer (anneeSuivante H) H.horizon s

/-- Situation à l'horizon sans aucun programme. -/
def tendanciel (H : Scenario) : Etat :=
  projeter H H.reference.etat

end Modele
