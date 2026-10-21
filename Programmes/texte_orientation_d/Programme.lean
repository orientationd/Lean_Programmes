import Modele
import Hypotheses
import Proprietes

/-!
# Programme « texte_orientation_d »

Programme de orientation_d, à rédiger. Seuls les comptes listés dans
`PROPRIETAIRES` peuvent modifier ce dossier : la CI refuse toute autre PR
(contrôle d'accès aux programmes).

Une mesure s'écrit avec les leviers du modèle commun
(`Modele/Leviers.lean`) ; voir `Programmes/ExempleRelance/` pour un
exemple complet (mesures, engagements, contrats).
-/

namespace Programmes.texte_orientation_d
open Modele

def mesures : List Mesure := []

def programme : Programme where
  id := "texte_orientation_d"
  nom := "texte_orientation_d"
  description := "Programme de orientation_d (à rédiger)."
  mainteneurs := ["@orientationd"]
  source := "À compléter"
  mesures := mesures

end Programmes.texte_orientation_d
