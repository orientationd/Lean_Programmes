import Modele

namespace Proprietes
open Modele

/-- Émissions à l'horizon sous le plafond légal du scénario. -/
abbrev EmissionsSousPlafond (H : Scenario) (_tendanciel s : Etat) : Prop :=
  s.emissionsMt ≤ H.droit.plafondEmissionsMt

def emissions : Propriete :=
  .mk' "emissions-plafond" "Émissions sous le plafond légal"
    "Les émissions territoriales à l'horizon respectent le plafond du cadre juridique du scénario."
    EmissionsSousPlafond

end Proprietes

namespace Proprietes
open Modele

/-- Les décès attribuables à la pollution de l'air ne dépassent pas le tendanciel. -/
abbrev AirNonDegrade (_H : Scenario) (a s : Etat) : Prop :=
  s.decesPollutionAir ≤ a.decesPollutionAir

def air : Propriete :=
  .mk' "air-non-degrade" "Mortalité liée à l'air non dégradée"
    "À l'horizon, les décès annuels attribuables à la pollution de l'air ne dépassent pas ceux du tendanciel."
    AirNonDegrade

/-- Points de recharge publics suffisants pour le parc électrique en 2035. -/
abbrev BornesSuffisantesEn2035 (H : Scenario) (_tendanciel s : Etat) : Prop :=
  s.parcElectriqueMilliers ≤ s.bornesMilliers * H.energie.vehiculesParBorne

def bornes2035 : Propriete :=
  .mk' "bornes-suffisantes-2035" "Bornes suffisantes en 2035"
    "En 2035, le nombre de points de recharge publics atteint la cible du scénario (un point pour dix véhicules électriques)."
    BornesSuffisantesEn2035 (annee := some 10)

end Proprietes
