import Modele
import Hypotheses
import Proprietes

/-!
# Parti socialiste — Le Projet socialiste (2026)

Transcription **partielle et non officielle** du Projet socialiste adopté
par les adhérents en 2026 (projet-socialiste.fr, consulté le 21 octobre
2026). La source ne publie pas de chiffrage global. Complété par le
contre-budget 2027 des députés socialistes (16 septembre 2026, chiffres du
parti rapportés par la presse ; document non consulté directement).
Candidat issu de la primaire « Choisir 2027 » (9-11 octobre 2026) :
R. Glucksmann, dont les propositions ne sont pas transcrites ici.

Règle de transcription : une proposition devient un levier seulement si la
source donne un montant annuel, ou un paramètre que le modèle commun
représente directement (SMIC, âge légal). Les conversions faites ici sont
écrites dans le champ `source` de la mesure. Les autres propositions sont
listées dans README.md, sans levier. Aucun engagement n'est déclaré.
-/

namespace Programmes.PS
open Modele

def site : String := "projet-socialiste.fr"

def contreBudget : String :=
  "Contre-budget 2027 des députés socialistes, 16 septembre 2026 (Selectra, JDN, LCP, Planet ; chiffres du parti, sans contre-expertise)"

def mesures : List Mesure := [
  { id := "P-01", titre := "SMIC porté à 1 690 € net"
    source := s!"{site}, chap. 1 « Redonner du sens et de la valeur au travail ». Conversion : la référence du modèle (1 820 € brut) vaut ≈ 1 441 € net au ratio net/brut du SMIC (1 426,30 / 1 801,80 en novembre 2024), d'où +17,3 %"
    leviers := [.revalorisationSmic 1730] },
  { id := "P-02", titre := "Âge légal de départ ramené à 62 ans"
    source := s!"{site}, chap. 1 « Pouvoir profiter de sa retraite » (avec 43 annuités et 10 critères de pénibilité, non modélisés) ; 62 ans dès l'entrée en vigueur : −9 mois en 2027, l'écart au calendrier légal atteint 24 mois en 2033"
    leviers := [.ageLegalCible 744 0] },
  { id := "P-03", titre := "Revue des niches fiscales et sociales"
    source := s!"{site}, chap. 16 « Imposer la justice fiscale » : « 11 milliards d'euros par an »"
    leviers := [.prelevement 11000] },
  { id := "P-04", titre := "Impôt sur les grandes successions"
    source := s!"{site}, chap. 16 : rendement cumulé de 400 Md€ sur 2025-2040, soit 25 Md€/an en moyenne (400 / 16), imputés aux droits de succession et de donation dès 2027 ; l'assiette successorale croissant plus vite que le PIB, le rendement modélisé dépasse ensuite cette moyenne"
    leviers := [.prelevementSur .droitsMutation 25000] },
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
    leviers := [.depenseSur .fonctionnement 500] },
  { id := "P-09", titre := "CSG progressive sur les revenus d'activité jusqu'à 2 700 € net"
    source := s!"{contreBudget} : ≈ 10 Md€ de moindres recettes (21 millions d'actifs ; CSG au SMIC de 9,2 % à moins de 1 %)"
    leviers := [.prelevementSur .csgCrds (-10000)] },
  { id := "P-10", titre := "Taxe sur les géants du numérique"
    source := s!"{contreBudget} : +10 Md€ (l'assiette dépasserait de loin celle de la taxe actuelle, ≈ 0,7 Md€)"
    leviers := [.prelevementSur .autres 10000] },
  { id := "P-11", titre := "Accès aux soins : hôpitaux et EHPAD publics, mutuelle publique gratuite pour les 18-25 ans"
    source := s!"{contreBudget} : +5 Md€ (3 Md€ hôpitaux et EHPAD, 1 Md€ mutuelle des 18-25 ans)"
    leviers := [.depenseSur .sante 5000] },
  { id := "P-12", titre := "Climat : fonds de sécurité climatique, fonds vert des collectivités"
    source := s!"{contreBudget} : +10 Md€ pour le climat (dont 5 Md€ de fonds de sécurité climatique et 1,5 Md€ de fonds vert)"
    leviers := [.depenseSur .logementEnvironnement 10000] },
  { id := "P-13", titre := "École, agriculteurs, sécurité civile"
    source := s!"{contreBudget} : +2 Md€ (école), +2 Md€ (agriculteurs), sécurité civile doublée à 1 Md€ (+0,5 Md€, calcul)"
    leviers := [.depenseSur .enseignement 2000, .depenseSur .affairesEconomiques 2000, .depenseSur .securiteJustice 500] },
  { id := "P-14", titre := "Révision des exonérations de cotisations patronales"
    source := s!"{contreBudget} : +4 Md€ ; sans ciblage précisé, réduction au prorata des allègements (modèle commun). Recouvrement possible avec P-03 (niches sociales)"
    leviers := [.reductionAllegements 4000] },
  { id := "P-15", titre := "Fraude, travail dissimulé, économies sur l'État et sur les marges du secteur de la santé"
    source := s!"{contreBudget} : fraude fiscale 2,4 Md€, travail dissimulé 1,1 Md€, État 3,6 Md€, santé 4 Md€ (Selectra ; 15,1 Md€ détaillés sur 17,5 annoncés)"
    leviers := [.prelevementSur .autres 2400, .prelevementSur .cotisations 1100,
                .economieSur .fonctionnement 3600, .economieSur .sante 4000] }
]

def programme : Programme where
  id := "PS"
  nom := "Parti socialiste — Le Projet socialiste (2026)"
  description := "Transcription partielle et non officielle du Projet socialiste (8 propositions chiffrées ou directement modélisables sur environ 400) et du contre-budget 2027 des députés socialistes (16 septembre 2026 : CSG progressive, taxe numérique, santé, climat, école, exonérations, fraude et économies)."
  mainteneurs := ["@orientationd"]
  source := "https://projet-socialiste.fr/ (consulté le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.PS
