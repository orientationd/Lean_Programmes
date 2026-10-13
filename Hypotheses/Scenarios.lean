import Hypotheses.Reference
import Hypotheses.Demographie
import Hypotheses.Economie
import Hypotheses.Droit

/-!
# Scénarios : produit cartésien des axes

`tous` croise chaque valeur de chaque axe. Ajouter une valeur sur un axe
ajoute automatiquement une ligne par combinaison dans la matrice d'évaluation
de **tous** les programmes.

Les théorèmes ci-dessous sont des garde-fous de CI :
* `tous_valides` — aucune hypothèse absurde ;
* `tous_non_vide` — l'espace des hypothèses n'est pas vide (sinon tout
  énoncé « pour tout scénario » serait vrai par vacuité).
-/

namespace Hypotheses
open Modele

/-- Horizon commun de projection, en années. -/
def horizon : Nat := 5

/-- Construit un scénario à partir de ses axes (pour les engagements). -/
def scenario (d : Demographie) (e : Economie) (j : CadreJuridique) : Scenario :=
  { reference := reference2026, demo := d, eco := e, droit := j, horizon := horizon }

def tous : List Scenario :=
  Demo.toutes.flatMap fun d =>
    Eco.toutes.flatMap fun e =>
      Droit.toutes.map fun j => scenario d e j

/-- Scénario de référence. -/
def central : Scenario := scenario Demo.centrale Eco.centrale Droit.cadreActuel

theorem tous_valides : ∀ H ∈ tous, H.Valide := by decide +kernel

theorem tous_non_vide : 0 < tous.length := by decide +kernel

theorem central_valide : central.Valide := by decide +kernel

end Hypotheses
