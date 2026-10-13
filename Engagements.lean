import Programmes

/-!
# Vérification des engagements de tous les programmes

Un seul théorème couvre tous les programmes enregistrés : un programme ajouté
à `Programmes.tous` ne peut pas échapper à la vérification.

Si ce fichier ne compile plus, au moins un engagement est devenu faux.
Le rapport (`lake exe rapport`) indique lequel, sous quel scénario, et avec
quelles valeurs.

Un programme peut ajouter ici des théorèmes plus forts que ses engagements
ponctuels, par exemple des énoncés paramétriques (« pour toute croissance
≥ 2 %… ») prouvés avec `omega`.
-/

namespace Engagements

theorem tous_tenus : ∀ p ∈ Programmes.tous, p.EngagementsTenus := by
  decide +kernel

end Engagements
