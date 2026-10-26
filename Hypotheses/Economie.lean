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

Émissions : `baisseEmissionsSecteurPm`, baisse annuelle par secteur à
politiques constantes, calée sur le scénario « avec mesures existantes » du
ministère (326 Mt en 2030, scénario AME 2024 publié par le ministère de la
Transition écologique, mesures adoptées jusqu'au 31 décembre 2023) en partant des émissions de 2025 (Citepa, Secten
2026) et des baisses récentes par secteur (2024-2025 : transports −1,9 %,
bâtiments −2,1 %, agriculture −1,3 %, industrie −5,2 % et −3,6 % en
2023-2024, déchets −2,2 % ; énergie très variable). Identique dans les trois
variantes (la croissance n'agit pas sur les émissions dans ce modèle).

Emplois par secteur : `intensiteEmploiSecteurPm` = valeur ajoutée par
personne en emploi de l'ensemble (87,0 k€) / celle du secteur, 2025 (INSEE,
comptes nationaux base 2020 : valeur ajoutée publiée le 29 mai 2026, emploi
intérieur par branche, tableaux 6.208 et 6.209) : agriculture
87,0 / 59,8 = 1,46 ; industrie 87,0 / 115,4 = 0,75 ; construction
87,0 / 74,1 = 1,17 ; tertiaire marchand 87,0 / 96,8 = 0,90 ; tertiaire non
marchand 87,0 / 64,7 = 1,34. Une demande adressée à un secteur y crée autant
d'emplois de plus (ou de moins) que la loi d'Okun en donne pour une demande
moyenne, multipliés par cette intensité. Ordre de grandeur obtenu pour la
construction : ≈ 5 emplois par M€ de dépense (Okun, à court terme), contre
6,5 à 7 emplois directs et ≈ 16 emplois directs et indirects par M€ de
travaux dans les études de contenu en emplois (FNTP 2025 ; ADEME, marché
2019 ; CERC Nouvelle-Aquitaine 2018), qui comptent les emplois mobilisés
sans tenir compte de ceux qu'ils prennent ailleurs.

Stabilisateur automatique : `coutParChomeurEuros` = 10 000 € par chômeur
BIT supplémentaire. Les dépenses de chômage (allocations et aides de
l'Unédic, 37,2 Md€ en 2025, et allocation de solidarité) ont une élasticité de
−3,23 à l'écart de production (DG Trésor, document de travail 2025/2, août
2025, paramètres de la LPFP 2023-2027) : 1 % de PIB, soit 0,4 point de
chômage avec la loi d'Okun du modèle (127 000 chômeurs), fait varier ces
dépenses de 1,27 Md€, ≈ 10 000 € par chômeur (contre 14 200 € par
indemnisé en moyenne : 37,2 Md€ pour 2,624 millions d'allocataires en 2025,
Unédic, juin 2026 ; les indemnisés ne sont qu'une partie des chômeurs). Côté recettes, l'élasticité unitaire au PIB
du modèle donne une semi-élasticité de ≈ 0,52 ; avec le chômage, le solde
réagit de ≈ 0,57 point par point de PIB, la valeur retenue par la LPFP (0,63
pour la Commission européenne, Mourre et al., 2019).

Rémunérations publiques (levier `remunerationPublique`). Pour des agents
déjà en poste, une hausse de rémunération ne crée ni production ni emploi
public : elle coûte le brut (les cotisations employeur versées à des
administrations publiques, comme le CAS Pensions à 78,28 % du traitement,
se compensent dans le compte consolidé) ; une part revient aussitôt en
prélèvements, et le net soutient la consommation comme un transfert aux
ménages. Taux (2026) :
* CSG 9,2 % et CRDS 0,5 % sur 98,25 % du brut : `tauxCsgCrdsRemunerationPm`
  = 95 ;
* retenue pour pension de 11,10 % du traitement indiciaire :
  `tauxCotisationsTraitementPm` = 111 ;
* RAFP (5 % agent) plafonnée à 20 % du traitement : les enseignants
  (primes ≈ 20,8 % du traitement) et les policiers (≈ 39 %) y sont déjà ;
  `tauxCotisationsPrimesPm` = 0 ;
* heures supplémentaires : RAFP compensée par la réduction de cotisations
  (décret n° 2019-133), exonérées d'impôt sur le revenu jusqu'à 7 500 € par
  an (CGI, art. 81 quater) : `tauxCotisationsHeuresSupPm` = 0, impôt nul ;
* impôt sur le revenu : taux marginal de 11 % (couple d'enseignants avec
  deux enfants) à 30 % (célibataire), sur ≈ 77 % du brut après abattement
  de 10 % : `tauxIrRemunerationPm` = 150 (calcul, barème 2026).
Sources : taux de cotisations 2026 (CDG 33) ; fiche RAFP (COR, 2024) ;
contribution employeur au CAS Pensions (Service des retraites de l'État,
2025) ; barème de l'IR 2026.

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

Incidence des prélèvements (`incidencePrelevementPm`). Le moteur fixe
l'effet moyen d'un prélèvement sur la demande (moitié de celui d'une dépense
au moteur de demande) ; l'axe économique le répartit selon l'impôt, la
moyenne pondérée par les prélèvements de 2025 restant proche de l'effet
moyen (970 ‰). Repères,
multiplicateurs à 2 à 5 ans pour un point de PIB : dépense publique
générique 1,0 puis 0,9 ; IR et CSG ≈ 0,8 ; TVA 0,66 puis 0,8 ; cotisations
salariés 0,75 (Mésange : DG Trésor pour le COR, 26 mars 2026, tableaux 1 à
3 ; Institut Avant-garde, 2025, tableau 7) ; IS 0,3 à 0,4 (OFCE, Policy
Brief 25, 2017) ; impôts sur le patrimoine et le foncier 0 à 0,2, très hauts
revenus 0,1 à 0,6 (Commission européenne, QUEST, in 't Veld 2012 ; CBO
2014). Propension à consommer le patrimoine financier : 0,115 pour la
moitié la moins dotée des ménages, 0,001 entre les 90e et 99e centiles
(Arrondel, Lamarche et Savignac, Économie et Statistique 472-473, 2014) ;
taux d'épargne de 27 % pour le quintile le plus aisé (INSEE Focus 338,
2024). D'où, relativement à l'effet moyen : TVA, IR, CSG 1,10 ;
cotisations 1,05 (prélèvement sans tranche : surtout des cotisations
salariales, les allègements patronaux passant par le coût du travail) ;
accises 1,00 (Mésange vert : un peu moins que la TVA) ; autres impôts 0,80
(impôts de production, taxes diverses) ; IS et taxe foncière 0,55 ;
successions et patrimoine 0,20. Les profils dans le temps (TVA et
cotisations montent avec les années, IR et CSG plus tôt) ne sont pas
modélisés ; la Banque de France (FR-BDF, 2020) trouve des effets de court
terme environ deux fois plus faibles.

Coût du travail par tranche de salaire (levier `allegementsCotisations`).
Emploi salarié privé ≈ 20 millions, dont ≈ 2/3 sous 1,6 SMIC, 89 % sous
2,5 SMIC, 98 % sous 3,5 SMIC (Bozio et Wasmer, rapport d'étape, mai 2024,
p. 27) : `emploiPriveTranche2025` = 13 340, 4 460 et 2 200 milliers. Coût du
travail (salaires bruts et cotisations patronales après allègements) :
salaire moyen de 1,3, 2,0 et 4,5 SMIC ; ≈ 367, 219 et 484 Md€ (calcul,
total ≈ 1 070 Md€, rémunérations du secteur privé des comptes nationaux).
Élasticités (valeur absolue) : 0,4 de 1 à 1,6 SMIC (−1 à −1,5 de 1 à
1,3 SMIC, ≈ −0,5 de 1,3 à 1,6 SMIC : Crépon et Desplatz 2001, Bunel et
L'Horty 2012, note CAE n° 49, 2019 ; Bozio et Wasmer, 2024, révisent ces
valeurs à la baisse), soit ≈ 14 500 emplois par Md€ (CAE : 23 000 à 57 000
pour 4 points de baisse au SMIC ; Groupe d'experts SMIC, 2025 : 17 000 à
25 000 en moyenne de tous les allègements ; Bozio et Wasmer : 7 500 à
10 800 dans leurs scénarios de hausse) ; 0,25 de 1,6 à 2,5 SMIC, soit
≈ 5 100 emplois par Md€ (bandeaux maladie et famille : 61 000 ETP pour
12,1 Md€, Bozio et Wasmer ; CICE : 5 500 à 9 000, France Stratégie 2020) ;
0,05 au-delà (effets « très faibles et peu significatifs », CAE). Pour une
hausse uniforme des cotisations patronales, on obtient ≈ 8 600 emplois par
Md€, contre 12 000 à 14 000 pour Mésange (calcul). Ajustement :
`ajustementCoutTravailPm` = 350, soit 35 % de l'effet à un an, 58 % à deux
ans, 88 % à cinq ans (Mésange 2026 : 23 %, 57 %, 87 %). Le PIB suit les
emplois pondérés par le coût du travail par emploi de la tranche (un emploi
au voisinage du SMIC coûte ≈ 0,5 fois la moyenne).

Accompagnement des demandeurs d'emploi (`chomeursEvitesParConseiller` = 5,
hypothèse prudente). Autriche, expérience aléatoire de 2015 : portefeuille
ramené de 250 à 100 demandeurs par conseiller, chômage plus court de
62 jours (−14 %), sorties vers l'emploi +4,8 points et vers l'inactivité
+3,0, gain net pour les finances publiques de 1 075 € par bénéficiaire hors
éviction (Böheim, Eppel et Mahringer, WIFO, 2022) : ≈ 26 années de chômage
évitées par conseiller et par an (calcul : 390 € par bénéficiaire, soit
≈ 150 bénéficiaires pour un conseiller). France, expérience de 2007 :
+9 à +10 points de sortie vers l'emploi à six mois avec 40 demandeurs par
conseiller contre 120 (Behaghel, Crépon et Gurgand, 2014). Allemagne :
490 conseillers de plus dans 14 agences, taux de chômage local −0,5 point
(Hainmueller, Hofmann, Krug et Wolf, 2016). Les effets d'éviction peuvent
annuler l'effet net (Crépon et al., QJE 2013 ; Dares-IPP, juin 2026, pour
l'accompagnement des bénéficiaires du RSA) : 26 réduit de 40 % (sorties
vers l'inactivité) et de moitié (éviction), d'où ≈ 5 à 8 ; 5 retenus.

C'est l'axe le plus disputé : multiplicateur, élasticités et fuite fiscale
déterminent l'essentiel des écarts entre programmes. D'où trois variantes
dès le départ, plutôt qu'une valeur « officielle ».
-/

namespace Hypotheses.Eco
open Modele

/-- Baisse tendancielle des émissions par secteur, pm par an (voir le
docstring du module). -/
def baisseEmissionsAME : ParSecteurGes :=
  { transports := 19, batiments := 21, agriculture := 10, industrie := 30, energie := 20, dechets := 22 }

/-- Effet sur la demande de chaque prélèvement, relativement à l'effet moyen
d'un prélèvement fixé par le moteur, pm (voir le docstring du module). -/
def incidencePrelevements : ParImpot :=
  { tva := 1100, ir := 1100, csgCrds := 1100, cotisations := 1050, impotSocietes := 550,
    accisesEnergie := 1000, taxeFonciere := 550, droitsMutation := 200, patrimoine := 200,
    autres := 800 }

-- moyenne pondérée par les prélèvements de 2025 : 970 ‰ (le moteur garde à
-- peu près son niveau moyen)
example : (221100 * 1100 + 103800 * 1100 + 167200 * 1100 + 446300 * 1050 + 58900 * 550
    + 30500 * 1000 + 44100 * 550 + 20700 * 200 + 2300 * 200 + 233400 * 800)
    / (221100 + 103800 + 167200 + 446300 + 58900 + 30500 + 44100 + 20700 + 2300 + 233400) = 969 := by decide

/-- Élasticité de l'emploi au coût du travail par tranche, pm (voir le
docstring du module). -/
def elasticitesCoutTravail : ParTranche := { bas := 400, intermediaire := 250, haut := 50 }

/-- Emploi salarié privé par tranche de salaire, milliers (voir le docstring
du module). -/
def emploiPriveTranche2025 : ParTranche := { bas := 13340, intermediaire := 4460, haut := 2200 }

/-- Coût du travail par tranche, M€ (voir le docstring du module). -/
def coutTravailTranche2025 : ParTranche := { bas := 367000, intermediaire := 219000, haut := 484000 }

/-- Intensité en emplois relative par secteur, 2025 (INSEE), pm. -/
def intensiteEmploi2025 : ParSecteur :=
  { agriculture := 1455, industrie := 754, construction := 1174,
    tertiaireMarchand := 899, tertiaireNonMarchand := 1345 }

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
  incidencePrelevementPm := incidencePrelevements
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
  intensiteEmploiSecteurPm := intensiteEmploi2025
  coutParChomeurEuros := 10000
  tauxCsgCrdsRemunerationPm := 95
  tauxCotisationsTraitementPm := 111
  tauxCotisationsPrimesPm := 0
  tauxCotisationsHeuresSupPm := 0
  tauxIrRemunerationPm := 150
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
  baisseEmissionsSecteurPm := baisseEmissionsAME
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  elasticiteEmploiCoutTravailPm := elasticitesCoutTravail
  emploiPriveTrancheMilliers := emploiPriveTranche2025
  coutTravailTrancheMeur := coutTravailTranche2025
  ajustementCoutTravailPm := 350
  chomeursEvitesParConseiller := 5
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
  incidencePrelevementPm := incidencePrelevements
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
  intensiteEmploiSecteurPm := intensiteEmploi2025
  coutParChomeurEuros := 10000
  tauxCsgCrdsRemunerationPm := 95
  tauxCotisationsTraitementPm := 111
  tauxCotisationsPrimesPm := 0
  tauxCotisationsHeuresSupPm := 0
  tauxIrRemunerationPm := 150
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
  baisseEmissionsSecteurPm := baisseEmissionsAME
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  elasticiteEmploiCoutTravailPm := elasticitesCoutTravail
  emploiPriveTrancheMilliers := emploiPriveTranche2025
  coutTravailTrancheMeur := coutTravailTranche2025
  ajustementCoutTravailPm := 350
  chomeursEvitesParConseiller := 5
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
  incidencePrelevementPm := incidencePrelevements
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
  intensiteEmploiSecteurPm := intensiteEmploi2025
  coutParChomeurEuros := 10000
  tauxCsgCrdsRemunerationPm := 95
  tauxCotisationsTraitementPm := 111
  tauxCotisationsPrimesPm := 0
  tauxCotisationsHeuresSupPm := 0
  tauxIrRemunerationPm := 150
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
  baisseEmissionsSecteurPm := baisseEmissionsAME
  tauxPfuIrPm := 128
  tauxPfuCsgCrdsPm := 111
  tauxPfuSolidaritePm := 75
  flexionPm := 150
  tauxEmploiSeniorsMaintenusPm := 720
  tauxEmploiMigrantsPm := 876
  absorptionChomagePm := 200
  elasticiteEmploiCoutTravailPm := elasticitesCoutTravail
  emploiPriveTrancheMilliers := emploiPriveTranche2025
  coutTravailTrancheMeur := coutTravailTranche2025
  ajustementCoutTravailPm := 350
  chomeursEvitesParConseiller := 5
  sources := ["À COMPLÉTER"]

def toutes : List Economie := [centrale, croissanceBasse, croissanceHaute]

end Hypotheses.Eco
