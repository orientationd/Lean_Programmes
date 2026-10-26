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
  hausseDecesMilliers := 9
  soldeMigratoireMilliers := 176
  croissanceActifsPb := -23        -- hors migrations : +0,1 %/an au total − 176 000 × 60 % ≈ −73 000/an
  partActiveMigrantsPm := 600
  sources := [
    "Décès 651 000 et solde migratoire +176 000 en 2025 (INSEE, bilan démographique 2025)",
    "Hausse des décès : 651 000 en 2025, 690 752 en 2030, 738 019 en 2035 (INSEE, projections de population à l'horizon 2070, scénario central, Insee Première n° 2108, 8 juin 2026), soit ≈ +9 000 par an",
    "Population active : +0,1 %/an au total, ordre de grandeur de la projection INSEE 2022 hors réforme (30 194 milliers en 2030) ; l'effet de l'âge légal passe par les mesures",
    "Part active des migrants : ≈ 60 % du solde migratoire en âge de travailler et actif (INSEE, immigrés et descendants d'immigrés, 2023 : taux d'activité des immigrés 15-64 ans ≈ 68 %, part des 15-64 ans dans les entrées ≈ 85 %)",
    "Part des 65 ans et plus à l'horizon : hypothèse (22,2 % au 1er janvier 2026)"]

def vieillissementRapide : Demographie where
  id := "demo-vieillissement"
  description := "Vieillissement plus rapide : plus de décès, moins de migrations, population active stable"
  partPlus65Pb := 2450
  decesMilliers := 670
  hausseDecesMilliers := 9
  soldeMigratoireMilliers := 140
  croissanceActifsPb := -26        -- hors migrations : population active stable − 140 000 × 60 %
  partActiveMigrantsPm := 600
  sources := ["Variante : hypothèses à sourcer (projections de population INSEE 2021-2070) ; hausse des décès du scénario central de l'INSEE (2026)"]

def toutes : List Demographie := [centrale, vieillissementRapide]

end Hypotheses.Demo
