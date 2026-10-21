import Modele

namespace Proprietes
open Modele

/-- Le taux de chômage à l'horizon n'est pas supérieur au tendanciel
(produit en croix sur les effectifs, les populations actives étant
positives : aucun arrondi au point de base près). -/
abbrev ChomageNonDegrade (_H : Scenario) (a s : Etat) : Prop :=
  (s.actifs - s.emploiTotal) * a.actifs ≤ (a.actifs - a.emploiTotal) * s.actifs

def chomage : Propriete :=
  .mk' "chomage-non-degrade" "Chômage non dégradé"
    "Le taux de chômage à l'horizon est inférieur ou égal à celui du tendanciel."
    ChomageNonDegrade

end Proprietes
