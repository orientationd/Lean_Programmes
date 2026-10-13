import Modele

namespace Proprietes
open Modele

/-- Déficit public à l'horizon sous le plafond du cadre juridique. -/
abbrev DeficitSousPlafond (H : Scenario) (_tendanciel s : Etat) : Prop :=
  10000 * s.deficit ≤ H.droit.plafondDeficitPb * s.pib

def deficit : Propriete :=
  .mk' "deficit-plafond" "Déficit sous le plafond juridique"
    "Le déficit public à l'horizon, en % du PIB, respecte le plafond du cadre juridique du scénario."
    DeficitSousPlafond

/-- Le ratio dette/PIB à l'horizon n'est pas pire qu'au tendanciel
(produit en croix, les PIB étant positifs). -/
abbrev DetteNonDegradee (_H : Scenario) (a s : Etat) : Prop :=
  s.dette * a.pib ≤ a.dette * s.pib

def dette : Propriete :=
  .mk' "dette-non-degradee" "Dette/PIB non dégradée"
    "Le ratio dette/PIB à l'horizon est inférieur ou égal à celui du tendanciel."
    DetteNonDegradee

end Proprietes
