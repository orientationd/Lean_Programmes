import Modele
import Hypotheses
import Proprietes

/-!
# La France insoumise — Mélenchon 2027 (volet automobile)

Transcription **partielle et non officielle** du plan d'investissement
productif « Automobile » publié sur melenchon2027.fr (consulté le
21 octobre 2026). Chaque mesure reprend une ligne du tableau « Les
investissements supplémentaires », en millions d'euros par an.

Seule la colonne **État** est imputée aux dépenses publiques. La colonne
« pôle public bancaire et autres » relève d'acteurs hors administrations
publiques dans le modèle (prêts, prises de participation) ; elle est citée
dans le champ `source` de chaque mesure.

Les mesures sans montant dans la source (sanctions des flottes
d'entreprises, critères de production française, moratoire sur les
fermetures, prix national de l'électricité…) ne sont pas traduites en
leviers : voir README.md. Aucun engagement n'est déclaré, la source n'en
formulant pas dans les termes des propriétés du dépôt.
-/

namespace Programmes.LFI
open Modele

/-- Référence commune des mesures. -/
def page : String :=
  "melenchon2027.fr/programme/plans-investissement/automobile, tableau « Les investissements supplémentaires »"

def mesures : List Mesure := [
  { id := "L-01", titre := "Nouvelles lignes de production"
    source := s!"{page} : État 100 M€/an, pôle public bancaire et autres 200 M€/an"
    leviers := [.depense 100] },
  { id := "L-02", titre := "Service public de la location abordable"
    source := s!"{page} : État 300 M€/an, pôle public bancaire et autres 700 M€/an ; parc public de 1,4 million de véhicules d'ici 2032"
    leviers := [.depense 300] },
  { id := "L-03", titre := "Aides à l'achat électrique et local"
    source := s!"{page} : État 200 M€/an, pôle public bancaire et autres 200 M€/an"
    leviers := [.depense 200] },
  { id := "L-04", titre := "Sous-traitance et équipementiers (Fonds Avenir Automobile)"
    source := s!"{page} : État 200 M€/an, pôle public bancaire et autres 800 M€/an"
    leviers := [.depense 200] },
  { id := "L-05", titre := "Batteries"
    source := s!"{page} : État 500 M€/an, pôle public bancaire et autres 900 M€/an ; cible d'au moins 100 GWh de capacité annuelle"
    leviers := [.depense 500] },
  { id := "L-06", titre := "Réparation, recyclage, réemploi"
    source := s!"{page} : État 50 M€/an, pôle public bancaire et autres 240 M€/an"
    leviers := [.depense 50] },
  { id := "L-07", titre := "Bornes de recharge"
    source := s!"{page} : État 0, pôle public bancaire et autres 20 M€/an"
    leviers := [] },
  { id := "L-08", titre := "Formation"
    source := s!"{page} : État 0, pôle public bancaire et autres 10 M€/an"
    leviers := [] },
  { id := "L-09", titre := "Recherche et développement : minibus autonomes"
    source := s!"{page} : État 20 M€/an, pôle public bancaire et autres 30 M€/an"
    leviers := [.depense 20] }
]

def programme : Programme where
  id := "LFI"
  nom := "La France insoumise — Mélenchon 2027 (volet automobile)"
  description := "Transcription partielle et non officielle du plan d'investissement productif « Automobile » : 1,37 Md€/an de dépenses de l'État (la source annonce 1,4 Md€) et 3,1 Md€/an du pôle public bancaire et d'autres acteurs."
  mainteneurs := ["@orientationd"]
  source := "https://melenchon2027.fr/programme/plans-investissement/automobile/ (consulté le 21 octobre 2026)"
  mesures := mesures

end Programmes.LFI
