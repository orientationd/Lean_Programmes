import Modele
import Hypotheses
import Proprietes

/-!
# Programme fictif « Exemple consolidation »

⚠️ Programme **fictif** à visée pédagogique. Il ne reproduit le programme
d'aucun parti ; les montants sont arbitraires.
-/

namespace Programmes.ExempleConsolidation
open Modele

def mesures : List Mesure := [
  { id := "C-01", titre := "Revue des dépenses de fonctionnement"
    source := "Exemple fictif, §1"
    leviers := [.economie 35000] },
  { id := "C-02", titre := "Recul de l'âge légal à 65 ans"
    source := "Exemple fictif, §2"
    leviers := [.ageLegal 12] },
  { id := "C-03", titre := "Baisse des impôts de production"
    source := "Exemple fictif, §3"
    leviers := [.baissePrelevement 8000] },
  { id := "C-04", titre := "Rénovation thermique ciblée"
    source := "Exemple fictif, §4"
    leviers := [.transition 12 6000] },
  { id := "C-05", titre := "Sous-indexation temporaire des prestations"
    source := "Exemple fictif, §5"
    leviers := [.economie 10000] }
]

open Hypotheses in
def programme : Programme where
  id := "ExempleConsolidation"
  nom := "Exemple consolidation (fictif)"
  description := "Réduction du déficit par les économies de dépense et le recul de l'âge légal, avec une baisse ciblée des impôts de production."
  mainteneurs := ["@mainteneur-exemple-consolidation"]
  source := "Programme fictif — aucun document source"
  mesures := mesures
  engagements :=
    -- « Sous TOUTES les hypothèses du dépôt, le ratio dette/PIB est meilleur qu'au tendanciel. »
    tous.map (fun H => ⟨H, Proprietes.dette⟩) ++
    -- « Avec une croissance forte, le déficit respecte les règles actuelles. »
    [⟨scenario Demo.centrale Eco.croissanceHaute Droit.cadreActuel, Proprietes.deficit⟩]

end Programmes.ExempleConsolidation
