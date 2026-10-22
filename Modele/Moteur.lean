import Modele.Unites

/-!
# Moteurs : plusieurs lectures du même état

Un **moteur** est un jeu de règles d'interprétation des leviers et de
projection. Tous les programmes sont évalués sous tous les moteurs
(`Modeles.tous`), avec les mêmes hypothèses de scénario : la matrice du
rapport est programme × moteur × scénario × propriété.

Les moteurs partagent l'état, les leviers et les hypothèses ; ils diffèrent
par des **paramètres de mécanisme** (comment une économie de dépense agit
sur la demande, si les prélèvements pèsent sur la croissance potentielle…).
Ajouter un moteur ou en changer les règles est une modification du socle.
-/

namespace Modele

structure Moteur where
  id : String
  nom : String
  description : String
  /-- Part du multiplicateur budgétaire appliquée aux économies de dépenses,
  pm (`1000` = symétrique aux dépenses nouvelles). -/
  multiplicateurEconomiesPm : Int
  /-- Part du multiplicateur appliquée à l'impulsion d'un prélèvement, pm
  (`500` : un prélèvement pèse moitié moins sur la demande qu'une dépense). -/
  multiplicateurPrelevementsPm : Int
  /-- Croissance annuelle perdue, en pb, par pb de prélèvements obligatoires
  au-dessus de leur niveau de départ, en pm (`0` : aucun effet d'offre ;
  `100` : +1 point de PO retire 0,1 point de croissance chaque année). -/
  elasticiteCroissancePoPm : Int
  deriving Repr

abbrev Moteur.Valide (M : Moteur) : Prop :=
  0 ≤ M.multiplicateurEconomiesPm ∧ M.multiplicateurEconomiesPm ≤ 1000 ∧
  0 ≤ M.multiplicateurPrelevementsPm ∧ M.multiplicateurPrelevementsPm ≤ 1000 ∧
  0 ≤ M.elasticiteCroissancePoPm ∧ M.elasticiteCroissancePoPm ≤ 1000

end Modele
