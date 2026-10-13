import Modele

namespace Proprietes
open Modele

/-- Le chômage à l'horizon n'est pas supérieur au tendanciel. -/
abbrev ChomageNonDegrade (_H : Scenario) (a s : Etat) : Prop :=
  s.chomagePb ≤ a.chomagePb

def chomage : Propriete :=
  .mk' "chomage-non-degrade" "Chômage non dégradé"
    "Le taux de chômage à l'horizon est inférieur ou égal à celui du tendanciel."
    ChomageNonDegrade

end Proprietes
