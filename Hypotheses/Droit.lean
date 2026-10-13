import Modele

/-!
# Axe juridique

Les contraintes de droit sont traitées comme des hypothèses : un programme
peut être cohérent dans un cadre et pas dans un autre (renégociation d'une
règle, activation d'une clause dérogatoire, nouvelle loi climat…).
-/

namespace Hypotheses.Droit
open Modele

def cadreActuel : CadreJuridique where
  id := "droit-actuel"
  description := "Règles budgétaires et objectifs climatiques en vigueur (provisoire)"
  plafondDeficitPb := 300
  plafondEmissionsMt := 300
  sources := ["À COMPLÉTER"]

def clauseDerogatoire : CadreJuridique where
  id := "droit-derogation"
  description := "Clause dérogatoire budgétaire activée, objectifs climatiques inchangés"
  plafondDeficitPb := 500
  plafondEmissionsMt := 300
  sources := ["À COMPLÉTER"]

def toutes : List CadreJuridique := [cadreActuel, clauseDerogatoire]

end Hypotheses.Droit
