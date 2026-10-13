import Modele

/-!
# Situation de départ

⚠️ VALEURS PROVISOIRES — ordres de grandeur arrondis pour amorcer le dépôt.
Elles doivent être remplacées par des données sourcées (comptes nationaux,
programme de stabilité, inventaire national d'émissions…) avant toute
publication. Chaque champ modifié doit citer sa source dans `sources`.
-/

namespace Hypotheses
open Modele

def reference2026 : Reference where
  id := "ref-2026"
  description := "Situation de départ 2026 (ordres de grandeur provisoires)"
  annee := 2026
  etat := {
    pib := 2900000
    recettes := 1490000
    depenses := 1650000
    dette := 3350000
    chomagePb := 750
    smicMensuel := 1820
    emissionsMt := 370
    ageLegalMois := 768 }
  populationMilliers := 68500
  partPlus65Pb := 2200
  sources := ["À COMPLÉTER — aucune valeur n'est encore sourcée"]

end Hypotheses
