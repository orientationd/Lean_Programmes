import Modele
import Hypotheses
import Proprietes

/-!
# Place publique — Raphaël Glucksmann (campagne 2027)

Transcription **partielle et non officielle**. Au 26 octobre 2026, aucun
programme présidentiel détaillé ni chiffrage global n'est publié (Euronews,
16 octobre 2026) ; le programme est annoncé pour la suite de la campagne.
Sources retenues :

* les propositions chiffrées de la campagne de R. Glucksmann, vainqueur de
  la primaire de la gauche sociale-démocrate (vote du 9 au 11 octobre 2026,
  66,2 % au premier tour), reprises par plusieurs médias (Public Sénat,
  LCP, Sud Radio, AFP) ;
* le projet de Place publique « Notre vision pour la France — Acte 1 »
  (23 juin 2025), seul texte programmatique complet, non chiffré.

Règle de transcription (commune au dépôt) : une proposition devient un
levier seulement si la source donne un montant annuel, ou un paramètre que
le modèle commun représente directement (SMIC, âge légal). Les conversions
faites ici sont écrites dans le champ `source` de la mesure. Les autres
propositions sont listées dans README.md, sans levier. Aucun engagement
n'est déclaré.
-/

namespace Programmes.PlacePublique
open Modele

def campagne : String := "Campagne présidentielle de R. Glucksmann, 2026"

/-- Taxe sur les « méga-héritages » (au-delà de 2 M€, réforme du Pacte
Dutreil) : « 15 milliards d'euros » (TF1, 23 août 2026 ; débats de la
primaire, 23 septembre et 4 octobre 2026). Le candidat ne précise pas la
période ; retenu par an, comme la presse économique. Les droits de
succession et de donation rapportent 20,7 Md€ en 2025 : la mesure les
relève de plus de 70 %. -/
def megaHeritages : Int := 15000

/-- Enseignants : au moins +10 %, jusqu'à +25 % en milieu de carrière,
6 Md€ (Public Sénat, 31 août 2026 ; Sud Radio, 3 septembre 2026), retenus
par an et en traitement indiciaire. -/
def enseignants : Int := 6000

/-- Leasing social : un million de voitures électriques à 100 € par mois,
6 Md€ (AFP, 2 octobre 2026), sans période précisée. Retenu : sur le
quinquennat, soit 200 000 voitures par an et 6 000 € d'aide par voiture
(6 Md€ / 1 million). Variante : un million de voitures et 6 Md€ par an. -/
def leasingVoituresParAn : Int := 200000
def leasingAideEuros : Int := 6000

def mesures : List Mesure := [
  { id := "PP-01", titre := "Taxe sur les méga-héritages au-delà de 2 M€, Pacte Dutreil réformé"
    source := s!"{campagne} (TF1, 23 août 2026 ; Public Sénat, 24 août ; débats LCI du 23 septembre et BFMTV du 4 octobre) : « 15 milliards d'euros », retenus par an et imputés aux droits de succession et de donation (voir `megaHeritages`). La suppression des niches Dutreil (≈ 3 Md€, communiqué de Place publique du 2 septembre 2025) est supposée comprise"
    leviers := [.prelevementSur .droitsMutation megaHeritages] },
  { id := "PP-02", titre := "Baisse de la CSG sur les salaires, financée par la taxe sur les méga-héritages"
    source := s!"{campagne} : les 15 Md€ de PP-01 « à verser sur la fiche de paie » (Public Sénat, 24 août 2026 ; LCP, 9 octobre 2026) pour rapprocher le net du brut ; montant déduit de PP-01"
    leviers := [.prelevementSur .csgCrds (-megaHeritages)] },
  { id := "PP-03", titre := "Enseignants : +10 % au moins, jusqu'à +25 % en milieu de carrière"
    source := s!"{campagne} (Public Sénat, 31 août 2026 ; Sud Radio, 3 septembre 2026) : 6 Md€, retenus par an, en traitement indiciaire d'agents en poste (voir `enseignants`)"
    leviers := [.remunerationPublique .traitement .enseignement [enseignants]] },
  { id := "PP-04", titre := "Leasing social : un million de voitures électriques à 100 € par mois"
    source := s!"{campagne} (AFP, 2 octobre 2026) : 6 Md€ pour un million de voitures, sans période ; retenu sur cinq ans : {leasingVoituresParAn} voitures par an à {leasingAideEuros} € d'aide"
    leviers := [.aideAchatElectrique leasingVoituresParAn leasingAideEuros]
    variantes := [
      { nom := "un million de voitures et 6 Md€ par an", leviers := [.aideAchatElectrique 1000000 leasingAideEuros] }] },
  { id := "PP-05", titre := "Retraites : abrogation de la réforme de 2023, âge légal à 62 ans"
    source := s!"{campagne} (débat BFMTV, 4 octobre 2026 : « ce sera 62 ans » ; LCP, 9 octobre) ; Place publique, Acte 1 (juin 2025), p. 43 : « Abroger la réforme Macron de 2023 ». 62 ans dès l'entrée en vigueur : −9 mois en 2027, l'écart au calendrier légal atteint 24 mois en 2033"
    leviers := [.ageLegalCible 744 0] }
]

def programme : Programme where
  id := "PlacePublique"
  nom := "Place publique — Raphaël Glucksmann (campagne 2027)"
  description := "Transcription partielle et non officielle des propositions chiffrées de la campagne de Raphaël Glucksmann (taxe sur les méga-héritages et baisse de la CSG sur les salaires, enseignants, leasing social, retraite à 62 ans), en l'absence de programme présidentiel publié au 26 octobre 2026."
  mainteneurs := ["@orientationd"]
  source := "Déclarations de campagne de R. Glucksmann (août-octobre 2026) ; Place publique, « Notre vision pour la France — Acte 1 » (23 juin 2025)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.PlacePublique
