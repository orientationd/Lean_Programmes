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
  description := "Mortalité et migrations de 2025 prolongées, population active quasi stable"
  partPlus65Pb := 2350
  decesMilliers := 651
  soldeMigratoireMilliers := 176
  croissanceActifsPb := 10
  sources := [
    "Décès 651 000 et solde migratoire +176 000 en 2025 (INSEE, bilan démographique 2025)",
    "Population active : +0,1 %/an, ordre de grandeur de la projection INSEE 2022 hors réforme (30 194 milliers en 2030) ; l'effet de l'âge légal passe par les mesures",
    "Part des 65 ans et plus à l'horizon : hypothèse (22,2 % au 1er janvier 2026)"]

def vieillissementRapide : Demographie where
  id := "demo-vieillissement"
  description := "Vieillissement plus rapide : plus de décès, moins de migrations, population active stable"
  partPlus65Pb := 2450
  decesMilliers := 670
  soldeMigratoireMilliers := 140
  croissanceActifsPb := 0
  sources := ["Variante : hypothèses à sourcer (projections de population INSEE 2021-2070)"]

def toutes : List Demographie := [centrale, vieillissementRapide]

end Hypotheses.Demo
