import Modele.Projection

/-!
# Propriétés

Une propriété est un énoncé décidable sur le triplet
`(scénario, état tendanciel, état avec programme)`. Elle peut donc exprimer
une contrainte absolue (« déficit sous le plafond légal ») comme une
comparaison au tendanciel (« le programme n'augmente pas le chômage »).

Les **valeurs** vivent dans `Proprietes/`. Toute propriété est évaluée pour
chaque programme sous chaque scénario : c'est la matrice du rapport.
-/

namespace Modele

structure Propriete where
  id : String
  titre : String
  description : String
  /-- `tient H tendanciel avecProgramme` -/
  tient : Scenario → Etat → Etat → Prop
  dec : ∀ H a b, Decidable (tient H a b)

instance (p : Propriete) (H : Scenario) (a b : Etat) : Decidable (p.tient H a b) :=
  p.dec H a b

/-- Constructeur qui infère l'instance de décidabilité. -/
def Propriete.mk' (id titre description : String)
    (tient : Scenario → Etat → Etat → Prop)
    [inst : ∀ H a b, Decidable (tient H a b)] : Propriete :=
  ⟨id, titre, description, tient, inst⟩

/-- Évaluation calculable (utilisée par le rapport). -/
def Propriete.evaluer (p : Propriete) (H : Scenario) (a b : Etat) : Bool :=
  decide (p.tient H a b)

end Modele
