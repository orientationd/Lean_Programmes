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
(1 + 0,222) × 10⁻⁴ ≈ 20 M€ par point de base. Ils ne s'appliquent qu'à
l'écart entre l'hypothèse démographique et la démographie des tendances de
dépenses (`Reference.partPlus65TendancePb`), déjà vieillissante : nul dans
le scénario central.
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
`robotisationTendanciellePb` = 0 : les tendances de dépenses ci-dessous
intègrent déjà les gains de productivité ; la robotisation reste un levier
des programmes.

**Trajectoire macroéconomique.** Les premières années suivent les
prévisions publiées (`trajectoireVolume`, `trajectoirePotentiel`,
`trajectoireDeflateur`, `trajectoireConso`, `trajectoireTaux`,
`trajectoireTauxCourt`, sources en docstring) : croissance de 0,4 %,
0,9 % et 1,2 % de 2026 à 2028 (Banque de France, septembre 2026), puis
rattrapage de 0,2 point par an au-dessus du potentiel en 2029-2030 (mission
d'experts sur la transparence des finances publiques, juillet 2026) ;
croissance potentielle de 1,2 % jusqu'en 2028 (PSMT d'octobre 2024, PLF
2027), puis 1 % (mission d'experts, PSMT) dans le scénario central ;
déflateur de 1,3 % en 2026 puis 1,7, 1,6, 1,4 et 1,4 % (mission) ;
inflation de 2,3 %, 1,8 % et 1,6 % de 2026 à 2028 (INSEE, PLF 2027,
Banque de France) ; OAT à 10 ans à 3,8 % en 2026 et 4,3 % en 2027
(hypothèses des PLF 2026 et 2027), puis 4,4 % (taux à terme fin 2029 cité
par la mission). Au-delà : valeurs de long terme de la variante. La loi
d'Okun et les élasticités des prélèvements s'appliquent à l'écart entre la
croissance en volume et la croissance potentielle.

**Élasticités des prélèvements au cycle** (`elasticitesCycliques`) : impôt
sur le revenu et CSG-CRDS 1,86, impôt sur les sociétés 2,76, cotisations
sociales 0,63, impôts indirects et autres 1,00 : celles de la loi de
programmation 2023-2027 (DG Trésor, document de travail 2025/2, tableau 1,
calibrage 2008-2017), qui coïncident avec celles de la Commission
européenne (Mourre, Poissonnier et Lausegger, 2019) et de l'OCDE (Price,
Dang et Botev, 2015). Les recettes non fiscales sont acycliques. Avec
l'élasticité des dépenses de chômage (−3,23), la semi-élasticité du solde
vaut ≈ 0,57 (LPFP ; 0,63 pour la Commission) : test
`Tests.Mecanismes.semi_elasticite_solde`.

**Prélèvements sur leur assiette naturelle** (`assiettesFrance`,
`Modele/Projection.lean`, `Assiettes.taux`). Les élasticités au cycle
ci-dessus ne servent plus qu'aux chocs de demande des mesures et aux autres
impôts ; chaque grand prélèvement suit chaque année son assiette :

* *Masse salariale* (salaires et traitements bruts, 1 157,2 Md€ en 2025,
  INSEE) : emploi × rémunération par emploi. Celle-ci croît de la
  productivité tendancielle (croissance potentielle moins croissance
  tendancielle de l'emploi) et des prix : 64 % de l'inflation de l'année,
  36 % de celle de l'année précédente (`retardSalairesPm` = 360 : maquette
  Opale de la DG Trésor, +10 % de prix donnent +6,4 % de salaire moyen par
  tête la première année, +10 % à long terme ; billet du 23 décembre 2022).
  Élasticité de la masse salariale au cycle : 0,66 (Commission européenne,
  Economic Paper 536, 2014, tableau 3.4) ; l'emploi y répond par la loi
  d'Okun, la rémunération par emploi (heures, primes) pour le reste.
* *Cotisations* : masse salariale ; élasticité 0,95 sur sa part cyclique
  (même source ; plafond de la sécurité sociale, allègements). *CSG-CRDS* : revenus d'activité 70 %,
  de remplacement 18,2 %, du capital et jeux le reste (Fipeco d'après la
  Commission des comptes de la sécurité sociale, 2024), à taux
  proportionnels.
* *Impôt sur le revenu* : revenus déclarés de 2022 (DGFiP) : salaires
  61,7 %, pensions 25,7 %, indépendants (BIC, BNC, BA) 4,8 %, capital et
  plus-values 7,8 % ; élasticité à l'assiette 1,68 (Commission ; OCDE,
  Price, Dang et Botev, 2015) appliquée à la seule hausse au-delà de la
  revalorisation du barème (inflation de l'année précédente : l'INSEE,
  Lafféter et Pak 2015, trouve ≈ 1,7 au volume et ≈ 1,0 aux prix). Revenus
  des indépendants et du capital : PIB nominal et cycle, élasticités 1,33 et
  3,52 (OCDE, tableau 5).
* *TVA* : consommation des ménages (1 545,9 Md€ en 2025), volume de
  l'activité et prix à la consommation.
* *IS* : excédent des entreprises = valeur ajoutée des sociétés non
  financières (51,6 % du PIB en 2025 : 1 543,8 Md€) moins leurs
  rémunérations (87,1 % des salaires bruts : 1 007,9 Md€, INSEE IP n° 1997,
  2053, 2105) ; le bénéfice fiscal amplifie 2,03 fois (Commission) les
  écarts de l'excédent à sa tendance (PIB en valeur à la croissance
  potentielle) et suit cette tendance à long terme. L'IS
  encaissé suit les règles de paiement (art. 1668 du CGI) : les entreprises
  au dernier acompte (chiffre d'affaires > 250 M€, 95 à 98 % de l'IS de
  l'exercice dans l'année depuis 2019) en paient l'IS de l'année ; les
  autres versent des acomptes sur l'exercice précédent, réduits si leur
  bénéfice baisse, et le solde l'année suivante. `partIsAnneeCourantePm` =
  450 : les entreprises de plus de 250 M€ de chiffre d'affaires (≈ 1 000
  sociétés) sont toutes les grandes entreprises, qui paient 30 à 38 % de
  l'IS brut, et le haut des ETI (grandes entreprises et ETI : 53 à 60 %,
  INSEE, « Les entreprises en France », 2018-2023) : milieu de la fourchette.
* *Accises sur l'énergie* : tarifs en euros par unité, non indexés ;
  volume de carburants hors électrification stable (`elasticiteCarburants`
  = 0 : 50,3 Mm³ en 2019, 47,8 en 2024, CCFA, dont l'électrification déjà
  retirée par le modèle).
* *Taxe foncière* : revalorisation forfaitaire légale des valeurs locatives
  (glissement de l'IPCH de novembre à novembre, art. 1518 bis du CGI ;
  +0,8 % en 2026, puis l'inflation de l'année précédente) et croissance
  physique des bases de 0,8 % par an (produit moins revalorisation et effet
  taux : ≈ 1,0 point en 2020, 0,7 en 2022, 0,6 en 2024, DGCL, Fipeco).
* *Droits de mutation à titre onéreux* : valeur des transactions
  immobilières (au-delà des années observées : PIB nominal).

Les élasticités au cycle qui en résultent (tests `Tests.Assiettes`) :
cotisations 0,59, TVA 0,97, IS 1,45 la première année et 3,2 en régime
établi ; semi-élasticité du solde 0,45 la première année, 0,56 ensuite
(LPFP : 0,57).

**Structure de la dette.** `partDetteCourtTerme` = 57 ‰ : BTF (196 Md€ fin
2025, Agence France Trésor) rapportés à la dette de Maastricht ; renouvelés
chaque année au taux court (2,25 %, hypothèse du PLF 2026). La dette à
moyen et long terme est refinancée à raison de `renouvellementDette` =
109 ‰ par an : durée de vie moyenne de la dette négociable de l'État de
8,5 ans (AFT, 2025), soit 9,2 ans hors BTF. `partDetteIndexee` = 89 ‰ :
307 Md€ d'OATi et d'OAT€i fin 2025 (AFT) ; leur capital suit l'inflation
(charge d'intérêts en comptabilité nationale) et ils sont émis au taux
réel (taux marginal moins inflation de long terme). `primeDeficitPb` = 25 :
une hausse d'un point du déficit/PIB anticipé relève les taux longs
d'environ 25 pb, une hausse d'un point de dette/PIB de 3 à 4 pb (Laubach,
« New Evidence on the Interest Rate Effects of Budget Deficits and Debt »,
JEEA, 2009). Appliquée à l'écart entre le déficit de l'année précédente et
celui de départ (5,1 %) : un déficit ramené à 3 % abaisse le taux marginal
de ≈ 50 pb, un déficit de 8 % le relève de ≈ 75 pb. Rétro-test 2019-2025
de la charge d'intérêts : erreur moyenne de 2,2 Md€ (voir
`Modele/Retro.lean`), contre 4,6 Md€ avec la convergence à 20 pb par an de
la version précédente.

**Tendances des dépenses à législation constante** (`volumeDepenses`,
`indexationDecalee`) : prix plus volume propre à chaque fonction, d'après
les hypothèses « à politique inchangée » de la mission d'experts (rapport du
15 juillet 2026, p. 6-8 et tableau 4) et du COR (rapport de juin 2026,
tableau 2.1) :
* retraites : revalorisation sur l'inflation de l'année précédente (code de
  la sécurité sociale, art. L. 161-25), volume +0,85 % par an (COR :
  +0,9 % par an de 2025 à 2045, effectifs +0,5 %, pension moyenne réelle
  +0,5 % ; moins ≈ 0,05 point pour la suspension de la réforme de 2023, que
  le modèle compte à part par le calendrier de l'âge légal) ;
* santé : +1,95 % en volume (ONDAM tendanciel +3,5 % par an en valeur selon
  la mission, +3,4 % « pur » selon le PLFSS 2027, moins le déflateur de la
  mission, ≈ 1,55 %) ;
* famille, chômage, solidarité : revalorisation sur l'inflation de l'année
  précédente, volume nul (prestations familiales +1,7 % par an, chômage
  +0,6 %, prestations de l'État au rythme du potentiel nominal : ≈ prix) ;
* fonctions surtout portées par l'État (enseignement, sécurité et justice) :
  +0,95 % en volume (crédits des ministères +2,5 % par an en valeur, point
  d'indice gelé, effectifs stables, glissement vieillesse-technicité
  +0,6 %) ;
* fonctions surtout portées par les collectivités (logement et
  environnement, culture) : +1,1 % en volume (fonctionnement au rythme de
  la croissance potentielle) ; fonctions mixtes (affaires économiques,
  services généraux) : +1 % ;
* défense : prix seulement, la loi de programmation militaire passant par
  son échéancier (`echeancesDepart`).
Dépense hors intérêts obtenue : ≈ +2,8 % par an en valeur de 2026 à
2030 (mission : +3,1 %, avec une contribution à l'Union qui suit la
proposition de cadre financier 2028-2034, non retenue ici). Test
`Tests.Tendanciel` : dérive du déficit tendanciel 2026-2030 à moins d'un
demi-point de celle de la mission. Sur le passé (rétro-test, à titre
d'information), la règle s'écarte des dépenses observées de +0,4 point de
PIB en 2019 (maîtrise de la dépense), −1,7 point en 2020 et 2021 (crise
sanitaire), ≈ 0 en 2022, +1,1 point en 2023 (dépense en retard sur
l'inflation), +0,2 et +0,1 point en 2024 et 2025.
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

Incidence des dépenses (`incidenceDepensePm`, `incidenceInvestissementPm`).
Le multiplicateur du scénario est celui d'une dépense de consommation
publique ; une dépense le module selon sa nature. Multiplicateurs à 2 à
5 ans pour un point de PIB : dépense générique 1,01 puis 0,88, baisse des
pensions 0,80 puis 0,80, investissement public 1,29 puis 0,8 à 1,1 (Mésange :
DG Trésor pour le COR, mars 2026 ; Bourgeois et Favetto, document de travail
de l'INSEE 2024-07) ; transferts généraux 0,2 à 0,5 et transferts ciblés sur
les ménages contraints 0,7 à 0,9 contre 0,8 à 1,0 pour les achats publics la
première année (Commission européenne, QUEST, in 't Veld 2012) ;
prestations bien en dessous de la consommation publique à court terme
(Banque de France, FR-BDF, 2020). D'où : retraites 0,85 ; famille,
chômage, solidarité 0,90 (transferts plus ciblés) ; affaires économiques
0,85 (subventions aux entreprises) ; défense 0,85 (contenu importé des
équipements, hypothèse) ; autres fonctions 1,00 ; investissement public
1,25. La moyenne pondérée par les dépenses de 2025 vaut ≈ 0,92.

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

IDH (`Modele/Idh.lean`). `inflationPb` = 175, 125 et 200 (hypothèses : la
croissance réelle vaut alors 1,25 %, 0,75 % et 2 %) : déflate le PIB pour le
RNB par habitant en volume. Santé publique : élasticité-prix du tabac 0,4
(Santé publique France) ; accises sur le tabac 13,2 Md€ (2024) ; prix
minimum de l'alcool de 0,50 € par verre : −22 % de décès par cancers liés à
l'alcool (Etilé et al., INCa-MILDECA, 2022), soit ≈ 3 500 décès, 8,5 % des
41 000 décès attribuables, 17 ‰ par tranche de 10 centimes (estimation
basse : les autres causes ne sont pas comptées ; en Écosse, −13,4 % des
décès entièrement dus à l'alcool, Lancet 2023) ; dépistage du cancer
colorectal : participation de 30,7 % (2024-2025), et de 34 % à 65 % de
participation −22 % de mortalité (Barré et al., 2020), soit 0,7 ‰ des décès
par point ; 21,5 millions de personnes de 50 à 74 ans invitées tous les deux
ans (≈ 10,75 millions par an) ; 70 € par dépistage supplémentaire
(hypothèse : test et analyse, coloscopie pour les tests positifs).
Scolarisation : ≈ 800 000 jeunes par génération (hypothèse) ; 13 300 € par
étudiant (DEPP, 2024) ; +1 point de scolarisation à chaque âge de 18 à
24 ans = +0,07 an de durée attendue de scolarisation (taux INSEE, rentrée
2023 ; la durée attendue est la somme des taux de scolarisation par âge).

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

/-- Élasticités des prélèvements à l'écart de production, pm (voir le
docstring du module). -/
def elasticitesCycliques : ParImpot :=
  { tva := 1000, ir := 1860, csgCrds := 1860, cotisations := 630, impotSocietes := 2760,
    accisesEnergie := 1000, taxeFonciere := 1000, droitsMutation := 1000, mutationsOnereuses := 1000,
    patrimoine := 1000,
    autres := 1000 }

/-- Assiettes naturelles des prélèvements (voir le docstring du module). -/
def assiettesFrance : Assiettes :=
  { retardSalairesPm := 360, elasticiteMasseSalarialeCyclePm := 660,
    elasticiteIndependantsCyclePm := 1330, elasticiteCapitalCyclePm := 3520,
    csgActivitePm := 700, csgRemplacementPm := 182,
    irSalairesPm := 617, irPensionsPm := 257, irIndependantsPm := 48, progressiviteIrPm := 1680,
    elasticiteCotisationsPm := 950, elasticiteIsPm := 2030, partIsAnneeCourantePm := 450,
    partValeurAjouteePm := 516, partSalairesPm := 871,
    croissancePhysiqueFoncierPb := 80, elasticiteCarburantsPm := 0 }

/-- Évolution tendancielle des dépenses à législation constante, en volume,
par fonction, pb par an (voir le docstring du module). -/
def volumeDepenses : ParFonction :=
  { retraites := 85, sante := 195, famille := 0, enseignement := 95,
    affairesEconomiques := 100, defense := 0, securiteJustice := 95,
    logementEnvironnement := 110, culture := 110, interets := 0, fonctionnement := 100,
    nonVentile := 0 }

/-- Part de chaque fonction revalorisée sur l'inflation de l'année
précédente, pm : pensions et prestations (voir le docstring du module). -/
def indexationDecalee : ParFonction :=
  ParFonction.depuis fun f => match f with
    | .retraites | .famille => 1000
    | _ => 0

/-- Croissance du PIB en volume, 2026-2030 : Banque de France (projections
de septembre 2026) pour 2026-2028, puis rattrapage de 0,2 point par an
au-dessus de la croissance potentielle en 2029 et 2030 (mission d'experts
sur la transparence des finances publiques, juillet 2026 : 1,2 % pour un
potentiel de 1 %). -/
def trajectoireVolume (potentiel : Int) : List Int := [40, 90, 120, potentiel + 20, potentiel + 20]

/-- Croissance potentielle, 2026-2030 : 1,2 % jusqu'en 2028 (plan
budgétaire et structurel de moyen terme d'octobre 2024, PLF 2027, mission
d'experts), puis la valeur de long terme de la variante. -/
def trajectoirePotentiel (potentiel : Int) : List Int := [120, 120, 120, potentiel, potentiel]

/-- Déflateur du PIB, 2026-2030 : ≈ 1,3 % en 2026 (Gouvernement, juillet
2026), puis croissance nominale moins croissance réelle de la mission
d'experts (2,7 %, 2,8 %, 2,6 %, 2,6 % ; 1,0 %, 1,2 %, 1,2 %, 1,2 %). -/
def trajectoireDeflateur : List Int := [130, 170, 160, 140, 140]

/-- Inflation des prix à la consommation, 2026-2028 : 2,3 % (INSEE, note de
conjoncture de septembre 2026), 1,8 % (PLF 2027), 1,6 % (Banque de France,
septembre 2026). -/
def trajectoireConso : List Int := [230, 180, 160]

/-- Taux de l'OAT à 10 ans, 2026-2027 : 3,8 % (hypothèse du PLF 2026 ; 3,7 %
mi-2026 selon la mission d'experts, 4,84 % le 7 octobre 2026), 4,3 %
(hypothèse du PLF 2027). Au-delà : valeur de long terme de la variante
(centrale : 4,4 %, taux à terme fin 2029 cité par la mission d'experts). -/
def trajectoireTaux : List Int := [380, 430]

/-- Revalorisation forfaitaire des valeurs locatives en 2026 : +0,8 %
(glissement de l'IPCH de novembre 2024 à novembre 2025, Banque des
Territoires, 28 novembre 2025). Au-delà : inflation de l'année précédente. -/
def revalorisationFonciere : List Int := [80]

/-- Taux des BTF : 2,25 % (hypothèse du PLF 2026), maintenu. -/
def trajectoireTauxCourt : List Int := [225]

/-- Part du stock de dette refinancée chaque année, pm (voir le docstring du
module). -/
def renouvellementDette : Int := 109

/-- Part de la dette à court terme (BTF), pm (voir le docstring du module). -/
def partDetteCourtTerme : Int := 57

/-- Part de la dette indexée sur l'inflation, pm (voir le docstring du
module). -/
def partDetteIndexee : Int := 89

/-- Effet sur la demande de chaque prélèvement, relativement à l'effet moyen
d'un prélèvement fixé par le moteur, pm (voir le docstring du module). -/
def incidencePrelevements : ParImpot :=
  { tva := 1100, ir := 1100, csgCrds := 1100, cotisations := 1050, impotSocietes := 550,
    accisesEnergie := 1000, taxeFonciere := 550, droitsMutation := 200, mutationsOnereuses := 800,
    patrimoine := 200, autres := 800 }

-- moyenne pondérée par les prélèvements de 2025 : 970 ‰ (le moteur garde à
-- peu près son niveau moyen) ; les droits de mutation à titre onéreux,
-- comptés jusqu'ici dans les autres impôts, en gardent l'incidence
example : (221100 * 1100 + 103800 * 1100 + 167200 * 1100 + 446300 * 1050 + 58900 * 550
    + 30500 * 1000 + 44100 * 550 + 20700 * 200 + 17600 * 800 + 2300 * 200 + 215800 * 800)
    / (221100 + 103800 + 167200 + 446300 + 58900 + 30500 + 44100 + 20700 + 17600 + 2300 + 215800) = 969 := by decide

/-- Effet sur la demande d'une dépense selon sa fonction, relativement à la
consommation publique, pm (voir le docstring du module). -/
def incidenceDepenses : ParFonction :=
  { retraites := 850, sante := 1000, famille := 900, enseignement := 1000,
    affairesEconomiques := 850, defense := 850, securiteJustice := 1000,
    logementEnvironnement := 1000, culture := 1000, interets := 0, fonctionnement := 1000,
    nonVentile := 1000 }

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

/-- Canal du capital public (moteurs qui l'activent : `Moteur.canalCapitalPm`).
Élasticité de la production au capital public : 0,12 à long terme pour le
capital installé par l'État, 0,083 à court terme (Bom et Ligthart, Journal of
Economic Surveys 28(5), 2014, méta-analyse de 578 estimations) ; 0,12 dans
QUEST (Commission européenne, Motyovszki, Pfeiffer et in 't Veld, Discussion
Paper 204, 2024, tableau 2.1) ; 0,17 pour les infrastructures de base dans les
simulations du FMI (WEO, octobre 2014, chap. 3). Retenu : 0,12. -/
def elasticitePibCapitalPublic : Int := 120

/-- Actifs fixes nets des administrations publiques fin 2024 : actifs non
financiers (2 821 Md€) moins terrains (903), autres actifs non produits (154)
et stocks (32), soit 1 732 Md€ (Insee Première n° 2081, novembre 2025), pour
un PIB 2024 de ≈ 2 935 Md€ (2 991,1 Md€ en 2025, +1,9 % en valeur : Insee
Première n° 2105, 2026) : 59 % du PIB (calcul). -/
def actifsFixesApu2024 : Int := 2821000 - 903000 - 154000 - 32000
def pib2024 : Int := 2935000
def stockCapitalPublicPib : Int := actifsFixesApu2024 * 1000 / pib2024

theorem stockCapitalPublic_eq : actifsFixesApu2024 = 1732000 ∧ stockCapitalPublicPib = 590 := by decide

/-- Dépréciation du capital public : 5 % par an (QUEST, ibid. ; OCDE, document
de travail n° 1351, 2016 : 4,2 à 5 %) ; 4,55 % pour les pays à haut revenu dans
la base du FMI (Investment and Capital Stock Dataset, manuel 2021) ; 6,5 %
implicites dans les comptes français, qui incluent les logiciels et la R&D
(consommation de capital fixe des APU de 113,1 Md€ en 2025, INSEE, tableau
1.112 ; calcul). À +1 point de PIB d'investissement public durable, le PIB
potentiel gagne 1,6 % en dix ans et 4 % à très long terme (calcul) ; le FMI
trouve +1,5 % après quatre ans (estimation empirique, demande comprise) et
≈ +2,5 % à long terme (modèle GIMF, avec éviction). Les modèles français
Mésange et FR-BDF n'ont pas de canal d'offre du capital public (INSEE,
document de travail 2024-07 ; Banque de France, document de travail 750). -/
def depreciationCapitalPublic : Int := 50

/-- Canal du capital des entreprises : à compléter (sources en cours). -/
def effetPibLongTermePointIS : Int := 0
def ajustementCapitalPrive : Int := 0

def centrale : Economie where
  id := "eco-centrale"
  description := "Prévisions publiées jusqu'en 2030, puis croissance potentielle de 1 %, inflation de 1,75 %, OAT à 4,4 %"
  croissancePotentiellePb := 100
  croissanceVolumeAnneesPb := trajectoireVolume 100
  croissancePotentielleAnneesPb := trajectoirePotentiel 100
  inflationAnneesPb := trajectoireDeflateur
  inflationConsoAnneesPb := trajectoireConso
  tauxMarginalAnneesPb := trajectoireTaux
  tauxCourtAnneesPb := trajectoireTauxCourt
  revalorisationFoncierAnneesPb := revalorisationFonciere
  elasticiteCycliquePm := elasticitesCycliques
  assiettes := assiettesFrance
  croissanceDepensesVolumePb := volumeDepenses
  indexationDecaleePm := indexationDecalee
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 800
  fuiteFiscalePm := 200
  incidencePrelevementPm := incidencePrelevements
  incidenceDepensePm := incidenceDepenses
  incidenceInvestissementPm := 1250
  inflationPb := 175
  elasticitePrixTabacPm := 400
  accisesTabacMeur := 13200
  baisseDecesAlcoolPar10CentimesPm := 17
  participationDepistagePm := 307
  baisseDecesColorectalParPointPm := 7
  populationDepistageMilliers := 10750
  coutParDepistageEuros := 70
  jeunesParGenerationMilliers := 800
  depenseParEtudiantEuros := 13300
  elasticiteChomageSmicPm := 100
  economieParMoisRetraite := 650
  tauxMarginalPb := 440
  partDetteCourtTermePm := partDetteCourtTerme
  tauxCourtPb := 225
  renouvellementDettePm := renouvellementDette
  partDetteIndexeePm := partDetteIndexee
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
  robotisationTendanciellePb := 0
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
  elasticitePibCapitalPublicPm := elasticitePibCapitalPublic
  stockCapitalPublicPibPm := stockCapitalPublicPib
  depreciationCapitalPublicPm := depreciationCapitalPublic
  effetPibLongTermePointISPpm := effetPibLongTermePointIS
  ajustementCapitalPrivePm := ajustementCapitalPrive
  chomeursEvitesParConseiller := 5
  sources := [
    "Banque de France, projections macroéconomiques de septembre 2026",
    "Mission d'experts indépendants sur la transparence des finances publiques, rapport du 15 juillet 2026 (tableaux 3 à 6, p. 6-8)",
    "PLF 2026 et PLF 2027 (hypothèses de taux, d'inflation et de croissance potentielle) ; avis du HCFP du 1er octobre 2026",
    "INSEE, note de conjoncture de septembre 2026 (inflation 2026)",
    "COR, rapport annuel de juin 2026, tableau 2.1 (masse des pensions en volume)",
    "DG Trésor, document de travail 2025/2 (élasticités des prélèvements et des dépenses de chômage au cycle)",
    "Agence France Trésor, bulletin mensuel n° 435 et rapport annuel 2025 (structure de la dette)"]

def croissanceBasse : Economie where
  id := "eco-basse"
  description := "Prévisions publiées jusqu'en 2030, puis croissance potentielle de 0,6 %, inflation de 1,25 %, OAT à 4,8 % ; multiplicateur faible, fuite fiscale forte"
  croissancePotentiellePb := 60
  croissanceVolumeAnneesPb := trajectoireVolume 60
  croissancePotentielleAnneesPb := trajectoirePotentiel 60
  inflationAnneesPb := trajectoireDeflateur
  inflationConsoAnneesPb := trajectoireConso
  tauxMarginalAnneesPb := trajectoireTaux
  tauxCourtAnneesPb := trajectoireTauxCourt
  revalorisationFoncierAnneesPb := revalorisationFonciere
  elasticiteCycliquePm := elasticitesCycliques
  assiettes := assiettesFrance
  croissanceDepensesVolumePb := volumeDepenses
  indexationDecaleePm := indexationDecalee
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 500
  fuiteFiscalePm := 350
  incidencePrelevementPm := incidencePrelevements
  incidenceDepensePm := incidenceDepenses
  incidenceInvestissementPm := 1250
  inflationPb := 125
  elasticitePrixTabacPm := 400
  accisesTabacMeur := 13200
  baisseDecesAlcoolPar10CentimesPm := 17
  participationDepistagePm := 307
  baisseDecesColorectalParPointPm := 7
  populationDepistageMilliers := 10750
  coutParDepistageEuros := 70
  jeunesParGenerationMilliers := 800
  depenseParEtudiantEuros := 13300
  elasticiteChomageSmicPm := 150
  economieParMoisRetraite := 650
  tauxMarginalPb := 480
  partDetteCourtTermePm := partDetteCourtTerme
  tauxCourtPb := 225
  renouvellementDettePm := renouvellementDette
  partDetteIndexeePm := partDetteIndexee
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
  robotisationTendanciellePb := 0
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
  elasticitePibCapitalPublicPm := elasticitePibCapitalPublic
  stockCapitalPublicPibPm := stockCapitalPublicPib
  depreciationCapitalPublicPm := depreciationCapitalPublic
  effetPibLongTermePointISPpm := effetPibLongTermePointIS
  ajustementCapitalPrivePm := ajustementCapitalPrive
  chomeursEvitesParConseiller := 5
  sources := [
    "Banque de France, projections macroéconomiques de septembre 2026",
    "Mission d'experts indépendants sur la transparence des finances publiques, rapport du 15 juillet 2026 (tableaux 3 à 6, p. 6-8)",
    "PLF 2026 et PLF 2027 (hypothèses de taux, d'inflation et de croissance potentielle) ; avis du HCFP du 1er octobre 2026",
    "INSEE, note de conjoncture de septembre 2026 (inflation 2026)",
    "COR, rapport annuel de juin 2026, tableau 2.1 (masse des pensions en volume)",
    "DG Trésor, document de travail 2025/2 (élasticités des prélèvements et des dépenses de chômage au cycle)",
    "Agence France Trésor, bulletin mensuel n° 435 et rapport annuel 2025 (structure de la dette)"]

def croissanceHaute : Economie where
  id := "eco-haute"
  description := "Prévisions publiées jusqu'en 2030, puis croissance potentielle de 1,5 %, inflation de 2 %, OAT à 4 % ; multiplicateur élevé, fuite fiscale faible"
  croissancePotentiellePb := 150
  croissanceVolumeAnneesPb := trajectoireVolume 150
  croissancePotentielleAnneesPb := trajectoirePotentiel 150
  inflationAnneesPb := trajectoireDeflateur
  inflationConsoAnneesPb := trajectoireConso
  tauxMarginalAnneesPb := trajectoireTaux
  tauxCourtAnneesPb := trajectoireTauxCourt
  revalorisationFoncierAnneesPb := revalorisationFonciere
  elasticiteCycliquePm := elasticitesCycliques
  assiettes := assiettesFrance
  croissanceDepensesVolumePb := volumeDepenses
  indexationDecaleePm := indexationDecalee
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 1100
  fuiteFiscalePm := 100
  incidencePrelevementPm := incidencePrelevements
  incidenceDepensePm := incidenceDepenses
  incidenceInvestissementPm := 1250
  inflationPb := 200
  elasticitePrixTabacPm := 400
  accisesTabacMeur := 13200
  baisseDecesAlcoolPar10CentimesPm := 17
  participationDepistagePm := 307
  baisseDecesColorectalParPointPm := 7
  populationDepistageMilliers := 10750
  coutParDepistageEuros := 70
  jeunesParGenerationMilliers := 800
  depenseParEtudiantEuros := 13300
  elasticiteChomageSmicPm := 50
  economieParMoisRetraite := 650
  tauxMarginalPb := 400
  partDetteCourtTermePm := partDetteCourtTerme
  tauxCourtPb := 225
  renouvellementDettePm := renouvellementDette
  partDetteIndexeePm := partDetteIndexee
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
  robotisationTendanciellePb := 0
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
  elasticitePibCapitalPublicPm := elasticitePibCapitalPublic
  stockCapitalPublicPibPm := stockCapitalPublicPib
  depreciationCapitalPublicPm := depreciationCapitalPublic
  effetPibLongTermePointISPpm := effetPibLongTermePointIS
  ajustementCapitalPrivePm := ajustementCapitalPrive
  chomeursEvitesParConseiller := 5
  sources := [
    "Banque de France, projections macroéconomiques de septembre 2026",
    "Mission d'experts indépendants sur la transparence des finances publiques, rapport du 15 juillet 2026 (tableaux 3 à 6, p. 6-8)",
    "PLF 2026 et PLF 2027 (hypothèses de taux, d'inflation et de croissance potentielle) ; avis du HCFP du 1er octobre 2026",
    "INSEE, note de conjoncture de septembre 2026 (inflation 2026)",
    "COR, rapport annuel de juin 2026, tableau 2.1 (masse des pensions en volume)",
    "DG Trésor, document de travail 2025/2 (élasticités des prélèvements et des dépenses de chômage au cycle)",
    "Agence France Trésor, bulletin mensuel n° 435 et rapport annuel 2025 (structure de la dette)"]

def toutes : List Economie := [centrale, croissanceBasse, croissanceHaute]

end Hypotheses.Eco
