import Modele

/-!
# Axe démographique

Ajouter une hypothèse : définir une valeur ci-dessous **et** l'ajouter à
`toutes`. Elle sera automatiquement croisée avec tous les autres axes.
-/

namespace Hypotheses.Demo
open Modele

def centrale : Demographie where
  id := "demo-centrale"
  description := "Projection centrale (valeurs provisoires)"
  populationMilliers := 69000
  partPlus65Pb := 2350
  sources := ["À COMPLÉTER"]

def vieillissementRapide : Demographie where
  id := "demo-vieillissement"
  description := "Vieillissement plus rapide, population stable"
  populationMilliers := 68500
  partPlus65Pb := 2450
  sources := ["À COMPLÉTER"]

def toutes : List Demographie := [centrale, vieillissementRapide]

end Hypotheses.Demo
