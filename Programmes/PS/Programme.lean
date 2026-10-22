import Modele
import Hypotheses
import Proprietes

/-!
# Parti socialiste — Le Projet socialiste (2026)

Transcription **partielle et non officielle** du Projet socialiste adopté
par les adhérents en 2026 (projet-socialiste.fr, consulté le 21 octobre
2026). La source ne publie pas de chiffrage global.

Règle de transcription : une proposition devient un levier seulement si la
source donne un montant annuel, ou un paramètre que le modèle commun
représente directement (SMIC, âge légal). Les conversions faites ici sont
écrites dans le champ `source` de la mesure. Les autres propositions sont
listées dans README.md, sans levier. Aucun engagement n'est déclaré.
-/

namespace Programmes.PS
open Modele

def site : String := "projet-socialiste.fr"

def mesures : List Mesure := [
  { id := "P-01", titre := "SMIC porté à 1 690 € net"
    source := s!"{site}, chap. 1 « Redonner du sens et de la valeur au travail ». Conversion : la référence du modèle (1 820 € brut) vaut ≈ 1 441 € net au ratio net/brut du SMIC (1 426,30 / 1 801,80 en novembre 2024), d'où +17,3 %"
    leviers := [.revalorisationSmic 1730] },
  { id := "P-02", titre := "Âge légal de départ ramené à 62 ans"
    source := s!"{site}, chap. 1 « Pouvoir profiter de sa retraite » (avec 43 annuités et 10 critères de pénibilité, non modélisés)"
    leviers := [.ageLegal (-24)] },
  { id := "P-03", titre := "Revue des niches fiscales et sociales"
    source := s!"{site}, chap. 16 « Imposer la justice fiscale » : « 11 milliards d'euros par an »"
    leviers := [.prelevement 11000] },
  { id := "P-04", titre := "Impôt sur les grandes successions"
    source := s!"{site}, chap. 16 : rendement cumulé de 400 Md€ sur 2025-2040, soit 25 Md€/an en moyenne (400 / 16)"
    leviers := [.prelevement 25000] },
  { id := "P-05", titre := "Suppression des doublons entre l'État et les collectivités"
    source := s!"{site}, chap. 18 « Achever la décentralisation » : économie de « plus de 7,5 Mds € »"
    leviers := [.economieSur .fonctionnement 7500] },
  { id := "P-06", titre := "Taxe de 1 €/kg sur les emballages non recyclables, affectée au recyclage"
    source := s!"{site}, chap. 7 : taxe de 1 €/kg pour financer le recyclage « à hauteur de 500 M€/an »"
    leviers := [.prelevement 500, .depenseSur .logementEnvironnement 500] },
  { id := "P-07", titre := "Loi intégrale contre les violences sexistes et sexuelles"
    source := s!"{site}, chap. 13 : « mobiliser 2,6 milliards d'euros par an ». Traité comme dépense nouvelle ; à réduire de la part déjà engagée si la source la précise"
    leviers := [.depenseSur .securiteJustice 2600] },
  { id := "P-08", titre := "Aide humanitaire d'urgence portée à 1 Md€ par an"
    source := s!"{site}, chap. 19 : de 500 M€ en 2025 à 1 Md€ par an, soit +500 M€/an"
    leviers := [.depenseSur .fonctionnement 500] }
]

def programme : Programme where
  id := "PS"
  nom := "Parti socialiste — Le Projet socialiste (2026)"
  description := "Transcription partielle et non officielle du Projet socialiste : 8 propositions chiffrées ou directement modélisables sur environ 400 ; la source ne publie pas de chiffrage global."
  mainteneurs := ["@orientationd"]
  source := "https://projet-socialiste.fr/ (consulté le 21 octobre 2026)"
  mesures := mesures

end Programmes.PS
