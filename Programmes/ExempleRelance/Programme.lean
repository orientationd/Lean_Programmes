import Modele
import Hypotheses
import Proprietes

/-!
# Programme fictif « Exemple relance »

⚠️ Programme **fictif** à visée pédagogique. Il ne reproduit le programme
d'aucun parti ; les montants sont arbitraires.
-/

namespace Programmes.ExempleRelance
open Modele

def mesures : List Mesure := [
  { id := "R-01", titre := "Plan d'investissement de transition"
    source := "Exemple fictif, §1"
    leviers := [.transition 30 30000] },
  { id := "R-02", titre := "Revalorisation du SMIC de 8 %"
    source := "Exemple fictif, §2"
    leviers := [.revalorisationSmic 800] },
  { id := "R-03", titre := "Prestation forfaitaire de 250 €/an par habitant"
    source := "Exemple fictif, §3"
    leviers := [.prestationParHabitant 250] },
  { id := "R-04", titre := "Contribution sur les hauts patrimoines"
    source := "Exemple fictif, §4"
    leviers := [.prelevement 20000] },
  { id := "R-05", titre := "Retour de l'âge légal à 62 ans"
    source := "Exemple fictif, §5"
    leviers := [.ageLegal (-24)] },
  { id := "R-06", titre := "Taxe sur les profits exceptionnels"
    source := "Exemple fictif, §6"
    leviers := [.prelevement 15000] }
]

open Hypotheses in
def programme : Programme where
  id := "ExempleRelance"
  nom := "Exemple relance (fictif)"
  description := "Relance par l'investissement de transition et le pouvoir d'achat, financée en partie par des prélèvements nouveaux."
  mainteneurs := ["@mainteneur-exemple-relance"]
  source := "Programme fictif — aucun document source"
  mesures := mesures
  engagements := [
    -- « Nos émissions passent sous le plafond légal en hypothèses centrales. »
    ⟨central, Proprietes.emissions⟩,
    -- « Avec une croissance forte et la clause dérogatoire, le déficit reste sous le plafond. »
    ⟨scenario Demo.centrale Eco.croissanceHaute Droit.clauseDerogatoire, Proprietes.deficit⟩,
    -- « Avec une croissance forte, le chômage ne dépasse pas le tendanciel. »
    ⟨scenario Demo.centrale Eco.croissanceHaute Droit.cadreActuel, Proprietes.chomage⟩
  ]

end Programmes.ExempleRelance
