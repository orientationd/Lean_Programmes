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
R. Glucksmann, dont les propositions sont transcrites dans
`Programmes/PlacePublique/`.

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

/-- Coût moyen d'un enseignant, hors pensions : 59,23 Md€ de masse salariale
hors CAS Pensions pour 852 752 enseignants en 2026 (PLF 2026, rapport du
Sénat sur la mission Enseignement scolaire), soit 69 457 € (calcul),
appliqué aux postes de l'enseignement supérieur (hypothèse). -/
def coutEnseignantEuros : Int := 59230000000 / 852752
def postesSuperieur : List Int :=
  ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List Int).map fun k => k * 2000 * coutEnseignantEuros / 1000000

/-- Petite enfance, 200 000 solutions d'accueil de plus : construction à
35 000 € par place (17,5 Md€ pour 500 000 places, Institut Montaigne,
2022, calcul) en cinq ans ; fonctionnement à 15 381 € par place et par an
(coût CNAF cité par l'Institut Montaigne), tous financeurs (majorant de la
part publique). -/
def placesAccueil : Int := 200000
def investissementAccueil : Int := placesAccueil * 35000 / 5 / 1000000
def fonctionnementAccueil : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * placesAccueil * 15381 / 5 / 1000000

/-- Aide publique au développement portée à 0,7 % du RNB (chap. 20). En
2025 : 12,9 Md€, soit 0,42 % du RNB (75 Secondes, 30 août 2026, d'après
les données préliminaires de l'OCDE) ; écart de 0,28 point du RNB implicite
(calcul), atteint en cinq ans (hypothèse). -/
def hausseApd : Int := 12900 * 10000 / 42 * 28 / 10000
def apdEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * hausseApd / 5

theorem valeurs :
    postesSuperieur = [138, 277, 416, 555, 694, 833, 972, 1111, 1250, 1389] ∧
    investissementAccueil = 1400 ∧ fonctionnementAccueil = [615, 1230, 1845, 2460, 3076] ∧
    hausseApd = 8599 ∧ apdEcheancier = [1719, 3439, 5159, 6879, 8599] := by decide

def mesures : List Mesure := [
  { id := "P-01", titre := "SMIC porté à 1 690 € net"
    source := s!"{site}, chap. 1 « Redonner du sens et de la valeur au travail ». Conversion au brut au ratio net/brut du SMIC (1 443,11 / 1 823,03 au 1er janvier 2026, cotisations salariales de 20,84 %) : 2 134 € bruts, hausse calculée sur le SMIC projeté de 2027 (≈ +13,8 %)"
    leviers := [.smicCibleBrut 2134] },
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
                .economieSur .fonctionnement 3600, .economieSur .sante 4000] },
  { id := "P-16", titre := "Taxe Zucman : 2 % sur les patrimoines de plus de 100 M€"
    source := s!"{site}, chap. 16 « Refaire société » : « taxe Zucman de 2 % sur le patrimoine des grandes fortunes de plus de 100 millions d'euros » ; 15 Md€ par an dans les contre-budgets 2026 (30 août 2025) et 2027 (16 septembre 2026), chiffrage du parti (≈ 20 Md€ selon G. Zucman ; « 2 à 3 milliards » selon le rapporteur du Sénat, 4 juin 2025) ; même imputation que L-14 et E-05"
    leviers := [.prelevementSur .autres 15000] },
  { id := "P-17", titre := "Fiscalité des dividendes : prélèvement forfaitaire unique relevé"
    source := s!"{site}, chap. 16 : « suppression du prélèvement forfaitaire unique et hausse de la CSG sur les revenus du capital » ; chiffrage du parti dans le contre-budget 2026 (LCP, Public Sénat, 30 août 2025) : flat tax de 30 % à 32 %, 3,8 Md€ (la suppression coûterait davantage aux contribuables : 3,2 Md€ avec l'exit tax selon l'Institut Montaigne, 2024)"
    leviers := [.prelevementSur .ir 3800] },
  { id := "P-18", titre := "Leasing social : un million de voitures électriques à 100 € par mois"
    source := s!"{site} (via Votons 2027) ; non chiffré par le PS : même traduction que PP-04 (6 Md€ pour un million de voitures selon R. Glucksmann, AFP, 2 octobre 2026), sur cinq ans : 200 000 voitures par an à 6 000 € d'aide"
    leviers := [.aideAchatElectrique 200000 6000] },
  { id := "P-19", titre := "Classes de 19 élèves au plus, de 22,4 à 18,2 élèves en moyenne en dix ans"
    source := s!"{site}, chap. 11 ; non chiffré : 6,8 Md€ par an pour les classes à 19 (Institut Montaigne, 2022, même mesure de LFI, fourchette 4,6 à 11 Md€ ; traduction de E-12), atteints en dix ans (hypothèse)"
    leviers := [.depenseEcheancier .enseignement (([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List Int).map fun k => k * 680)] },
  { id := "P-20", titre := "Enseignement supérieur : 20 000 postes en dix ans"
    source := s!"{site}, chap. 11 : « créer 20 000 postes sur dix ans » ; non chiffré : 2 000 postes par an à {coutEnseignantEuros} € (hypothèse, voir `coutEnseignantEuros`), {postesSuperieur.getLastD 0} M€ par an la dixième année"
    leviers := [.creationPostes .enseignement (([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : List Int).map fun k => 2000 * k)
                  coutEnseignantEuros, .annonceEmplois 20000] },
  { id := "P-21", titre := "Service public de la petite enfance : 200 000 solutions d'accueil de plus"
    source := s!"{site}, chap. 10 : combler « le déficit de 200 000 solutions d'accueil » de 3 mois à 3 ans ; non chiffré : {investissementAccueil} M€ par an de construction pendant cinq ans, fonctionnement jusqu'à {fonctionnementAccueil.getLastD 0} M€ par an (voir `placesAccueil`)"
    leviers := [.investissementEcheancier .famille [investissementAccueil, investissementAccueil, investissementAccueil,
                                                    investissementAccueil, investissementAccueil, 0],
                .depenseEcheancier .famille fonctionnementAccueil] },
  { id := "P-22", titre := "Aide publique au développement portée à 0,7 % du RNB"
    source := s!"{site}, chap. 20 : « augmenter le niveau de l'APD pour atteindre 0,7 % du RNB » ; non chiffré : de 0,42 % à 0,7 %, +{hausseApd} M€ par an atteints en cinq ans ; versements à l'étranger, sans effet sur la demande intérieure (recette non fiscale négative, comme O-114) (voir `hausseApd`)"
    leviers := [.recetteEcheancier none (apdEcheancier.map (fun x => -x))] }
]

def programme : Programme where
  id := "PS"
  nom := "Parti socialiste — Le Projet socialiste (2026)"
  description := "Transcription partielle et non officielle du Projet socialiste (8 propositions chiffrées ou directement modélisables sur environ 400) et du contre-budget 2027 des députés socialistes (16 septembre 2026 : CSG progressive, taxe numérique, santé, climat, école, exonérations, fraude et économies). Ajouts du 28 octobre 2026 : taxe Zucman, dividendes, leasing social, classes à 19 élèves, 20 000 postes dans le supérieur, petite enfance, aide au développement à 0,7 % du RNB."
  mainteneurs := ["@orientationd"]
  source := "https://projet-socialiste.fr/ (consulté le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.PS
