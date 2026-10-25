import Modele

/-!
# Axe économique

`actifsParMoisAgeLegal` = 30 000 personnes : la réforme de 2023 (+2 ans)
ajoute 737 000 actifs en 2030 selon l'INSEE (actualisation des projections
de population active, 2023), soit ≈ 30 000 par mois.
`economieParMoisRetraite` = 650 M€ : 13,6 à 17,7 Md€ d'économies en 2030
pour 24 mois selon les chiffres gouvernementaux de la réforme de 2023 (via
IFRAP), soit 570 à 740 M€ par mois ; valeur centrale retenue (auparavant
1 500 M€, valeur provisoire surestimée).
`elasticiteChomageSmicPm` reste une valeur jouet, à sourcer.
`elasticitePibHeuresPm` = 650 : part du travail dans la valeur ajoutée
(INSEE, comptes nationaux, ≈ 65 %), prise comme élasticité du PIB au
volume d'heures travaillées à capital donné. `tauxISPb` = 2 500 : taux
normal de l'IS de 25 % depuis 2022.
`coutParPbPlus65` = 185 M€ : 410 Md€ de retraites pour 22,2 % de plus de
65 ans, soit 185 M€ par point de base de part ; `coutSanteParPbPlus65`
= 20 M€ : les plus de 65 ans consomment environ deux fois la dépense de
santé moyenne (DREES, comptes de la santé), soit 247 Md€ × (2 − 1) /
(1 + 0,222) × 10⁻⁴ ≈ 20 M€ par point de base.
`contenuImportDemandePm` = 300 : contenu en importations de la demande
intérieure ≈ 30 % (INSEE, tableaux entrées-sorties).
Accidents du travail : 564 000 accidents avec arrêt et 759 décès en 2023
(Assurance maladie — Risques professionnels, rapport annuel 2023), soit
190 pour 10 000 personnes en emploi et 13 décès pour 10 000 accidents ;
coût de la branche AT-MP ≈ 13,5 Md€ → 24 000 € par accident (maladies
professionnelles comprises, approximation) ; ≈ 40 millions de journées
indemnisées → 70 jours par accident. Moyenne de l'Union : incidence
française ≈ 1,75 fois la moyenne UE-27 (Eurostat, accidents non mortels
> 3 jours, 2022), d'où une cible de 110 pour 10 000.
`robotisationTendanciellePb` = 20 : gains de productivité de 0,2 %/an sur
les dépenses de fonctionnement, d'affaires économiques et de santé
(hypothèse ; la productivité des services publics est mal mesurée).
`tauxMarginalPb` : taux auquel la dette nouvelle et refinancée est émise
(OAT 10 ans autour de 3,3 % fin 2025, hypothèse) ; `deriveTauxPb` : le
taux apparent (1,87 % en 2025, INSEE) y converge d'environ 20 pb par an,
rythme de renouvellement du stock (maturité moyenne ≈ 8,5 ans, AFT), à la
hausse comme à la baisse. `primeDeficitPb` = 25 : une hausse d'un point du
déficit/PIB anticipé relève les taux longs d'environ 25 pb, une hausse d'un
point de dette/PIB de 3 à 4 pb (Laubach, « New Evidence on the Interest
Rate Effects of Budget Deficits and Debt », JEEA, 2009). Appliquée à
l'écart entre le déficit de l'année précédente et celui de départ
(5,1 %) : un déficit ramené à 3 % abaisse le taux marginal de ≈ 50 pb, un
déficit de 8 % le relève de ≈ 75 pb.
Prélèvement forfaitaire unique (PFU) : 31,4 % depuis le 1er janvier 2026
(loi n° 2025-1403 du 30 décembre 2025 de financement de la Sécurité sociale
pour 2026, art. L. 136-6 et L. 136-7 CSS), soit 12,8 % d'impôt sur le revenu
(`tauxPfuIrPm` = 128), 10,6 % de CSG et 0,5 % de CRDS (`tauxPfuCsgCrdsPm` =
111) et 7,5 % de prélèvement de solidarité (`tauxPfuSolidaritePm` = 75).
Législation en vigueur, identique dans les trois variantes.

Droits de succession et de donation : 20,7 Md€ en 2025, dont 16,2 sur les
successions et 4,5 sur les donations (Legifiscal, 23 septembre 2026).
Leur assiette, le flux successoral (464 Md€ en 2025, 16,1 % du PIB),
monterait à 20,2 % du PIB en 2040 (Fondation Jean-Jaurès, novembre 2024) :
+1,5 % par an au-delà du PIB, dont ≈ 1,1 point de hausse des décès (INSEE,
projections 2026) ; `excesPatrimoineParDecesPb` = 40 pour le reste
(patrimoine transmis par décès). Les abattements (100 000 € par enfant
depuis 2012) et le barème (5 % à 45 %) ne sont pas indexés : la part
taxable et le taux moyen montent avec les montants nominaux.
`elasticiteDroitsSuccessionPm` = 1 200 : ≈ 0,1 au titre de l'abattement en
ligne directe (relever celui-ci de 50 000 € coûterait ≈ 1 Md€, Institut
Montaigne 2022, d'après l'étude d'impact de 2012 : ≈ 22 M€ par point
d'érosion de 2025, soit 0,11 % des droits) et ≈ 0,1 pour les abattements
en ligne indirecte et les tranches (hypothèse). Les droits ont progressé de
4 % par an de 2014 à 2022 (Institut Montaigne), contre ≈ 2,6 % pour le PIB
nominal.

Impôt sur les sociétés. Le levier `impotSocietes` applique le plancher du
pilier 2 (directive (UE) 2022/2523 ; impôt complémentaire national de la loi
de finances pour 2024) : `tauxMinimumPilier2Pb` = 1 500 pour la part
`partISPilier2Pm` = 400 de l'IS acquittée par les groupes de plus de
750 M€ de chiffre d'affaires. Aucune part publiée pour ce seuil : les
grandes entreprises acquittent 33 % de l'IS brut (23,5 Md€ sur 71,2 Md€ en
2021, INSEE, Les entreprises en France, édition 2023, fiche 3.6) et une
partie des ETI appartient à des groupes de cette taille ; 40 % retenus
(fourchette 35 à 50 %). Le pilier 2 rapporte ≈ 0,5 Md€ en 2026 (Voies et
moyens, PLF 2026 ; audition du directeur de la législation fiscale,
commission des finances de l'Assemblée, 1er avril 2026).
`semiElasticiteAssietteISPm` = 10 : un point de taux effectif en moins
accroît les bénéfices déclarés en France de 1 % (transfert de bénéfices :
valeur de consensus 0,98, Beer, de Mooij et Liu, Journal of Economic
Surveys, 2020 ; 0,8 pour Heckemeyer et Overesch, 2017 ; 1,5 en fin de
période chez Beer et al.). Les effets réels (investissement, localisation)
porteraient la semi-élasticité totale vers 3 (de Mooij et Ederveen, 2008,
cité de seconde main) ; ils ne sont pas retenus ici, le moteur d'offre
traitant à part l'effet des prélèvements sur la croissance.

Outre-mer : `contenuImportOutreMerPm` = 500 (hypothèse). Aucune étude du
contenu importé de l'investissement dans les outre-mer n'a été trouvée ;
les importations y valent 31,5 % du PIB à La Réunion, 34,6 % en
Martinique, 38,9 % en Guadeloupe (INSEE, comptes 2025, calcul), mais les
investissements de réseaux (canalisations, pompes, membranes de
dessalement, panneaux solaires, batteries) sont presque entièrement
importés et les matériaux de construction y coûtent 35 à 39 % de plus
qu'en métropole (Autorité de la concurrence, avis 18-A-09). Contre 30 %
pour la demande nationale (`contenuImportDemandePm`).

Marché du travail. L'emploi ne suit plus mécaniquement la population
active : la tendance démographique est absorbée au taux d'emploi courant
(chômage tendanciel inchangé), mais les chocs d'offre de travail des
mesures entrent au taux d'emploi propre aux personnes concernées, puis
l'écart à l'emploi d'équilibre se résorbe progressivement. À long terme,
le taux de chômage ne dépend donc pas de la taille de la population active
(résultat empirique usuel) ; à court terme, il réagit à sa composition.
* `flexionPm` = 150 : une hausse de 10 000 chômeurs réduit la population
  active d'environ 1 500 personnes (INSEE, Note de conjoncture, juin 2017,
  éclairage « chômage ») ; d'où 1,15 emploi par chômeur en moins, et 13 %
  des emplois créés ou détruits qui passent par l'inactivité plutôt que
  par le chômage. La loi d'Okun et l'élasticité au SMIC restent exprimées
  en chômage ; les emplois s'en déduisent.
* `tauxEmploiSeniorsMaintenusPm` = 720 : report de 60 à 61 ans (réforme de
  2010), à 60 ans : +24 points d'activité et +17 points d'emploi pour les
  hommes, +22 et +16 pour les femmes (INSEE Analyses n° 30, 2017), soit
  ≈ 72 % des actifs supplémentaires en emploi.
* `tauxEmploiMigrantsPm` = 876 : taux de chômage des immigrés de 12,4 % en
  2025, contre 7,7 % pour l'ensemble (INSEE, enquête Emploi).
* `absorptionChomagePm` = 200 : 20 % de l'écart résorbé par an (demi-vie
  ≈ 3 ans). Hypothèse, à sourcer : convergence du chômage des immigrés avec
  l'ancienneté de résidence, retour au taux d'avant choc en 5 à 10 ans dans
  la littérature sur les chocs migratoires.

C'est l'axe le plus disputé : multiplicateur, élasticités et fuite fiscale
déterminent l'essentiel des écarts entre programmes. D'où trois variantes
dès le départ, plutôt qu'une valeur « officielle ».
-/

namespace Hypotheses.Eco
open Modele

def centrale : Economie where
  id := "eco-centrale"
  description := "Croissance nominale 3 %, paramètres médians"
  croissancePb := 300
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 800
  fuiteFiscalePm := 200
  elasticiteChomageSmicPm := 100
  economieParMoisRetraite := 650
  tauxMarginalPb := 330
  deriveTauxPb := 20
  primeDeficitPb := 25
  excesPatrimoineParDecesPb := 40
  elasticiteDroitsSuccessionPm := 1200
  partISPilier2Pm := 400
  tauxMinimumPilier2Pb := 1500
  semiElasticiteAssietteISPm := 10
  contenuImportOutreMerPm := 500
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 20
  coutParAccidentEuros := 24000
  joursPerdusParAccident := 70
  letaliteAccidentsPdm := 13
  tauxAccidentsUEPdm := 110
  baisseEmissionsPm := 30
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  sources := ["À COMPLÉTER"]

def croissanceBasse : Economie where
  id := "eco-basse"
  description := "Croissance nominale 2 %, multiplicateur faible, fuite fiscale forte"
  croissancePb := 200
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 500
  fuiteFiscalePm := 350
  elasticiteChomageSmicPm := 150
  economieParMoisRetraite := 650
  tauxMarginalPb := 380
  deriveTauxPb := 25
  primeDeficitPb := 25
  excesPatrimoineParDecesPb := 40
  elasticiteDroitsSuccessionPm := 1200
  partISPilier2Pm := 400
  tauxMinimumPilier2Pb := 1500
  semiElasticiteAssietteISPm := 10
  contenuImportOutreMerPm := 500
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 20
  coutParAccidentEuros := 24000
  joursPerdusParAccident := 70
  letaliteAccidentsPdm := 13
  tauxAccidentsUEPdm := 110
  baisseEmissionsPm := 20
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  sources := ["À COMPLÉTER"]

def croissanceHaute : Economie where
  id := "eco-haute"
  description := "Croissance nominale 4 %, multiplicateur élevé, fuite fiscale faible"
  croissancePb := 400
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 1100
  fuiteFiscalePm := 100
  elasticiteChomageSmicPm := 50
  economieParMoisRetraite := 650
  tauxMarginalPb := 300
  deriveTauxPb := 20
  primeDeficitPb := 25
  excesPatrimoineParDecesPb := 40
  elasticiteDroitsSuccessionPm := 1200
  partISPilier2Pm := 400
  tauxMinimumPilier2Pb := 1500
  semiElasticiteAssietteISPm := 10
  contenuImportOutreMerPm := 500
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 20
  coutParAccidentEuros := 24000
  joursPerdusParAccident := 70
  letaliteAccidentsPdm := 13
  tauxAccidentsUEPdm := 110
  baisseEmissionsPm := 40
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  sources := ["À COMPLÉTER"]

def toutes : List Economie := [centrale, croissanceBasse, croissanceHaute]

end Hypotheses.Eco
