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
