import Modele.Etat

/-!
# Hypothèses : les quatre axes d'un scénario

Un `Scenario` combine une valeur sur chacun des axes :

* `Reference` — la situation de départ (données observées) ;
* `Demographie` — population et vieillissement à l'horizon ;
* `Economie` — croissance et paramètres de comportement (multiplicateur,
  élasticités…) ;
* `CadreJuridique` — les contraintes de droit qui s'imposent au programme
  (règles budgétaires, objectifs climatiques légaux…).

Les **valeurs** de ces axes vivent dans `Hypotheses/`. Ici on ne définit que
leur forme et ce qu'est une hypothèse *valide* : un jeu d'hypothèses absurde
(population négative, fuite fiscale > 100 %…) rendrait toutes les
conclusions vides de sens, d'où le prédicat `Scenario.Valide` vérifié en CI.
-/

namespace Modele

/-- Situation de départ. -/
structure Reference where
  id : String
  description : String
  annee : Nat
  etat : Etat
  populationMilliers : Int
  /-- Part des 65 ans et plus dans la population, pb. -/
  partPlus65Pb : Int
  /-- Part des 65 ans et plus à l'horizon dans la projection démographique
  qui sous-tend les tendances de dépenses de l'axe économique (projections
  du COR, scénario central de l'INSEE), pb : seul l'écart de l'hypothèse
  démographique à cette projection ajoute un surcoût de vieillissement. -/
  partPlus65TendancePb : Int := 0
  /-- Assurance chômage, règles contracycliques en vigueur : seuil de taux de
  chômage, pb, à partir duquel la durée d'indemnisation réduite est
  complétée (complément de fin de droits), et surcoût annuel de ce
  complément, M€ de l'année de départ (indexé sur le PIB nominal). Par
  défaut : aucune règle. -/
  seuilChomageContracyclePb : Int := 10000
  surcoutComplementChomageMeur : Int := 0
  /-- IDH : RNB par habitant de départ, dollars PPA constants, et
  ln(RNB / 100) en millionièmes (calculé une fois) ; hausse tendancielle
  annuelle de la durée moyenne de scolarisation (renouvellement des
  générations), centièmes d'année. -/
  rnbParHabitantPpaDollars : Int := 0
  lnRnbSur100Millioniemes : Int := 0
  hausseDureeMoyenneCentiemes : Int := 0
  sources : List String
  deriving Repr

/-- Hypothèses démographiques **à l'horizon**. -/
structure Demographie where
  id : String
  description : String
  /-- Part des 65 ans et plus à l'horizon, pb. -/
  partPlus65Pb : Int
  /-- Décès de l'année de départ, milliers. -/
  decesMilliers : Int
  /-- Hausse annuelle des décès (arrivée des générations du baby-boom aux
  grands âges), milliers par an. -/
  hausseDecesMilliers : Int
  /-- Solde migratoire par an, milliers. -/
  soldeMigratoireMilliers : Int
  /-- Évolution tendancielle de la population active **hors migrations**, pb
  par an (vieillissement, taux d'activité ; hors effet des mesures). -/
  croissanceActifsPb : Int
  /-- Part du solde migratoire qui entre dans la population active, pm. -/
  partActiveMigrantsPm : Int
  /-- Gain tendanciel annuel d'espérance de vie à la naissance, centièmes
  d'année. -/
  gainEsperanceVieCentiemes : Int := 0
  /-- Santé publique : décès attribuables à chaque cause (année de départ),
  années de vie perdues par décès (dixièmes d'année), délai pour que l'effet
  d'une mesure sur la mortalité soit complet (années) ; années de vie perdues
  par décès dû à la pollution de l'air et par accident du travail mortel
  (dixièmes d'année). -/
  decesAttribuables : ParCause := {}
  anneesVieParDecesDixiemes : ParCause := {}
  delaiEffetMortaliteAns : ParCause := {}
  anneesVieParDecesPollutionDixiemes : Int := 0
  anneesVieParDecesAccidentDixiemes : Int := 0
  sources : List String
  deriving Repr

/-- Hypothèse de natalité. Elle n'agit dans le modèle que sur la population :
un enfant né pendant la période n'entre pas dans la population active avant
l'horizon. -/
structure Natalite where
  id : String
  description : String
  /-- Indicateur conjoncturel de fécondité, centièmes d'enfant par femme. -/
  icfCentiemes : Int
  /-- Naissances par an, milliers. -/
  naissancesMilliers : Int
  sources : List String
  deriving Repr

/-- Activité visée par une taxe environnementale ; elle fixe le secteur
d'émission touché et l'élasticité-prix (axe énergie). -/
inductive ActiviteTaxee where
  | aerienInterieur | poidsLourds | carburantsRoutiers | chauffageFossile
  deriving Repr, DecidableEq, Inhabited

def ActiviteTaxee.secteur : ActiviteTaxee → SecteurGes
  | .aerienInterieur => .transports
  | .poidsLourds => .transports
  | .carburantsRoutiers => .transports
  | .chauffageFossile => .batiments

/-- Élasticités-prix de long terme des activités taxées (valeur absolue, pm :
`500` = −0,5 % d'activité pour +1 % de coût). -/
structure ElasticitesPrix where
  aerienInterieur : Int
  poidsLourds : Int
  carburantsRoutiers : Int
  chauffageFossile : Int
  deriving Repr

def ElasticitesPrix.get (e : ElasticitesPrix) : ActiviteTaxee → Int
  | .aerienInterieur => e.aerienInterieur
  | .poidsLourds => e.poidsLourds
  | .carburantsRoutiers => e.carburantsRoutiers
  | .chauffageFossile => e.chauffageFossile

/-- Territoire visé par une aide (rénovation…). -/
inductive Territoire where
  | national | rural
  deriving Repr, DecidableEq, Inhabited

/-- Sous-modèle de la rénovation énergétique des logements aidée par l'État
(MaPrimeRénov'). Les montants en € sont ceux de l'année de départ. -/
structure Renovation where
  /-- Rénovations aidées par an (gestes et rénovations d'ampleur). -/
  renovationsAideesParAn : Int
  /-- Part de ces rénovations située dans les communes rurales, pm. -/
  partRuralePm : Int
  /-- Aide moyenne par rénovation, €. -/
  aideMoyenneEuros : Int
  /-- Effet d'aubaine : part des rénovations aidées qui auraient eu lieu sans
  l'aide, pm. Demande supposée linéaire en l'aide : une hausse de l'aide de
  `b` € suscite `(1 − aubaine) × b / aide moyenne` rénovations de plus par
  rénovation aidée. -/
  aubainePm : Int
  /-- Économie d'énergie finale par rénovation, kWh/an. -/
  economieKWhParRenovation : Int
  /-- Coût moyen des travaux d'une rénovation aidée, € (aide et part des
  ménages). -/
  coutTravauxMoyenEuros : Int
  /-- Parts du fioul et du gaz dans le chauffage des logements rénovés, pm. -/
  partFioulNationalPm : Int
  partGazNationalPm : Int
  partFioulRuralPm : Int
  partGazRuralPm : Int
  /-- Émissions par MWh consommé, kg CO₂. -/
  co2FioulKgMWh : Int
  co2GazKgMWh : Int
  /-- Valeur importée par MWh, € (fioul : au prix de référence du pétrole,
  proportionnelle au Brent). -/
  importFioulEurosMWh : Int
  importGazEurosMWh : Int
  /-- Accises et TVA par MWh, €. -/
  accisesFioulEurosMWh : Int
  tvaFioulEurosMWh : Int
  accisesGazEurosMWh : Int
  tvaGazEurosMWh : Int
  deriving Repr

namespace Renovation

def part (r : Renovation) : Territoire → Int
  | .national => 1000
  | .rural => r.partRuralePm

def partFioul (r : Renovation) : Territoire → Int
  | .national => r.partFioulNationalPm
  | .rural => r.partFioulRuralPm

def partGaz (r : Renovation) : Territoire → Int
  | .national => r.partGazNationalPm
  | .rural => r.partGazRuralPm

end Renovation

/-- Hypothèse sur le prix du pétrole, appliquée comme un choc de niveau sur
le PIB de départ, identique pour le tendanciel et pour chaque programme. -/
structure Energie where
  id : String
  description : String
  /-- Prix du Brent, $ par baril. -/
  prixBrentDollars : Int
  /-- Prix de référence implicite des hypothèses économiques, $ par baril. -/
  prixReferenceDollars : Int
  /-- Effet sur le niveau du PIB de +10 $ par baril, pb (négatif). -/
  effetPibPar10DollarsPb : Int
  /-- Ventes de voitures électriques neuves de l'année de départ, milliers :
  premier flux d'électrification tendancielle du parc. -/
  electrificationTendancielleMilliers : Int
  /-- Hausse annuelle des ventes de voitures électriques neuves imposée par
  le règlement (UE) 2023/851 (100 % des ventes neuves en 2035), milliers
  par an. -/
  hausseElectrificationMilliers : Int
  /-- Ventes de voitures particulières neuves, milliers par an : plafond du
  flux d'électrification (tendance et mesures confondues). -/
  ventesNeuvesMilliers : Int
  /-- Ouverture de points de recharge publics l'année de départ, milliers ;
  elle suit ensuite les ventes tendancielles de voitures électriques. -/
  bornesTendanciellesMilliers : Int
  /-- Accises perdues par voiture thermique remplacée par une électrique,
  €/an (accise sur les carburants moins accise sur l'électricité). -/
  accisesParVehiculeEuros : Int
  /-- TVA perdue par voiture thermique remplacée, €/an (carburant moins
  électricité). -/
  tvaParVehiculeEuros : Int
  /-- Puissance moyenne d'un point de recharge public, W. -/
  puissanceParBorneW : Int
  /-- Puissance publique exigée par voiture électrique à batterie, W
  (règlement (UE) 2023/1804, AFIR, art. 3). -/
  puissanceAfirParVehiculeW : Int
  /-- Émissions évitées par voiture thermique remplacée par une électrique,
  kg CO₂ par an, nettes de l'électricité consommée. -/
  co2EviteParVehiculeKg : Int
  /-- Particules à l'échappement selon la vignette Crit'Air, pm de la moyenne
  du parc thermique : indice 0 = moyenne, 1 à 5 = Crit'Air 1 à 5. -/
  pmRelatifCritAirPm : List Int
  /-- Rénovation énergétique des logements. -/
  renovation : Renovation
  /-- Élasticités-prix des activités visées par une taxe environnementale. -/
  elasticitesPrix : ElasticitesPrix
  /-- Consommation d'électricité d'un foyer d'outre-mer, kWh/an. -/
  consommationFoyerZniKWh : Int
  /-- Surcoût de production de l'électricité dans les zones non
  interconnectées, financé par les charges de service public de l'énergie
  (péréquation tarifaire), €/MWh. -/
  surcoutPerequationZniEurosMWh : Int
  /-- Décès annuels évités par million de voitures thermiques remplacées par
  des électriques (particules fines à l'échappement). -/
  decesEvitesParMillionVehicules : Int
  /-- Véhicules électriques par point de recharge public, cible
  d'infrastructure suffisante. -/
  vehiculesParBorne : Int
  /-- Amélioration annuelle de la balance commerciale par voiture thermique
  remplacée par une électrique, € (carburant importé évité moins
  électricité non exportée). -/
  gainCommercialParVehiculeEuros : Int
  /-- Facture énergétique importée au prix de référence, M€/an ; elle varie
  proportionnellement au prix du Brent. -/
  factureEnergetiqueMeur : Int
  sources : List String
  deriving Repr

/-- Chaque prélèvement sur son assiette naturelle (`anneeSuivante`) :
masse salariale (emploi × rémunération par emploi) pour les cotisations, la
CSG et l'impôt sur le revenu ; consommation des ménages pour la TVA ;
excédent des entreprises pour l'IS ; volume de carburants pour les accises
sur l'énergie (montants par litre, non indexés) ; valeurs locatives
revalorisées sur l'inflation passée pour la taxe foncière. Parts en pm. -/
structure Assiettes where
  /-- Part de l'inflation de l'année précédente dans la hausse des
  rémunérations (le reste : inflation de l'année). -/
  retardSalairesPm : Int
  /-- Élasticités au cycle (variation de l'écart de production) : masse
  salariale (l'emploi y répond par la loi d'Okun, la rémunération par
  emploi — heures, primes — pour le reste), revenus des indépendants,
  revenus du capital. -/
  elasticiteMasseSalarialeCyclePm : Int
  elasticiteIndependantsCyclePm : Int
  elasticiteCapitalCyclePm : Int
  /-- Assiette de la CSG et de la CRDS : parts des revenus d'activité
  (salaires) et des revenus de remplacement (le reste : revenus du
  capital). -/
  csgActivitePm : Int
  csgRemplacementPm : Int
  /-- Assiette de l'impôt sur le revenu : parts des salaires, des pensions
  et des revenus des indépendants (le reste : revenus du capital). -/
  irSalairesPm : Int
  irPensionsPm : Int
  irIndependantsPm : Int
  /-- Élasticité de l'impôt sur le revenu à son assiette, à barème constant
  (progressivité) ; le barème est revalorisé de l'inflation de l'année
  précédente. -/
  progressiviteIrPm : Int
  /-- Élasticité des cotisations sociales à la masse salariale (plafond de
  la sécurité sociale, allègements). -/
  elasticiteCotisationsPm : Int
  /-- Élasticité de l'IS dû à l'excédent des entreprises (le bénéfice
  fiscal varie plus que l'excédent : amortissements, intérêts, reports de
  déficits). -/
  elasticiteIsPm : Int
  /-- Part de l'IS acquittée par les entreprises soumises au cinquième
  acompte (IS de l'exercice presque entièrement payé dans l'année) ; les
  autres paient des acomptes sur l'exercice précédent et le solde l'année
  suivante (`Assiettes.croissanceIs`). -/
  partIsAnneeCourantePm : Int
  /-- Excédent des entreprises = part `partValeurAjouteePm` du PIB (valeur
  ajoutée des sociétés non financières) moins part `partSalairesPm` de la
  masse salariale (leurs rémunérations). -/
  partValeurAjouteePm : Int
  partSalairesPm : Int
  /-- Croissance physique annuelle des bases de la taxe foncière
  (constructions nouvelles), pb ; s'y ajoute la revalorisation légale des
  valeurs locatives (inflation de l'année précédente). -/
  croissancePhysiqueFoncierPb : Int
  /-- Élasticité du volume de carburants taxés à l'activité en volume ;
  les tarifs des accises sont fixés en euros par unité (non indexés). -/
  elasticiteCarburantsPm : Int
  deriving Repr

/-- Hypothèses macroéconomiques et de comportement. -/
structure Economie where
  id : String
  description : String
  /-- Croissance potentielle du PIB en volume, pb par an : croissance de
  long terme de la projection, et seuil de la loi d'Okun (le chômage baisse
  quand la croissance en volume la dépasse). -/
  croissancePotentiellePb : Int
  /-- Trajectoire des premières années, élément `k` = année `k + 1` après le
  départ (prévisions publiées pour une projection, valeurs observées pour un
  rétro-test) ; au-delà de la liste, valeurs de long terme : croissance du
  PIB en volume (long terme : `croissancePotentiellePb`), évolution du
  déflateur du PIB (long terme : `inflationPb`), inflation des prix à la
  consommation (indexation des pensions, des prestations et des titres
  indexés ; long terme : `inflationPb`), taux marginal de la dette (long
  terme : `tauxMarginalPb`), pb. -/
  croissanceVolumeAnneesPb : List Int := []
  /-- Croissance potentielle des premières années (élément `k` = année
  `k + 1`), pb ; au-delà : `croissancePotentiellePb`. -/
  croissancePotentielleAnneesPb : List Int := []
  inflationAnneesPb : List Int := []
  inflationConsoAnneesPb : List Int := []
  /-- Inflation qui revalorise le capital des titres indexés (moyenne des
  indices de la zone euro et de la France pondérée par l'encours des OAT€i
  et des OATi), pb ; au-delà de la liste : l'inflation des prix à la
  consommation de l'année (`inflationConsoA`). -/
  inflationIndexationAnneesPb : List Int := []
  tauxMarginalAnneesPb : List Int := []
  /-- Taux court (émission des titres à moins d'un an) des premières années,
  pb ; au-delà : `tauxCourtPb`. -/
  tauxCourtAnneesPb : List Int := []
  /-- Coefficient de revalorisation forfaitaire des valeurs locatives des
  premières années, connu à l'avance (art. 1518 bis du CGI : glissement de
  l'indice des prix harmonisé de novembre à novembre), pb ; au-delà :
  inflation de l'année précédente. -/
  revalorisationFoncierAnneesPb : List Int := []
  /-- Croissance de la valeur des transactions immobilières (assiette des
  droits de mutation à titre onéreux) des premières années, pb ; au-delà :
  croissance du PIB en valeur. -/
  croissanceImmobilierAnneesPb : List Int := []
  /-- Élasticité de chaque prélèvement à l'écart de production, pm (`1000` :
  le prélèvement suit le PIB) : un prélèvement d'élasticité `ε` croît comme
  le PIB nominal potentiel plus `ε` fois la variation de l'écart de
  production (méthode de la Commission européenne et de l'OCDE). Les
  recettes non fiscales sont supposées acycliques. Sert aux chocs de demande
  des mesures (`chocPibSeul`) et aux prélèvements sans assiette propre ;
  l'évolution annuelle des autres suit leur assiette (`assiettes`). -/
  elasticiteCycliquePm : ParImpot
  /-- Assiettes naturelles des prélèvements. -/
  assiettes : Assiettes
  /-- Évolution tendancielle des dépenses primaires à législation constante,
  en volume (au-delà des prix), par fonction, pb par an. -/
  croissanceDepensesVolumePb : ParFonction
  /-- Part de la dépense de chaque fonction revalorisée sur l'inflation des
  prix à la consommation de l'année précédente (pensions, prestations
  indexées), pm ; le reste suit le déflateur du PIB de l'année. -/
  indexationDecaleePm : ParFonction
  /-- Baisse du chômage (pb) par pb de croissance en volume au-delà de la
  croissance potentielle, en pm. -/
  okunPm : Int
  /-- Plancher de chômage frictionnel, pb. -/
  chomageFrictionnelPb : Int
  /-- Multiplicateur budgétaire, pm (`800` = 0,8). -/
  multiplicateurPm : Int
  /-- Part du rendement statique d'un prélèvement perdue par les
  comportements (évasion, délocalisation, baisse d'assiette), pm. -/
  fuiteFiscalePm : Int
  /-- Effet sur la demande d'un prélèvement selon sa nature, relativement à
  l'effet moyen fixé par le moteur (`Moteur.multiplicateurPrelevementsPm`),
  pm (`1000` = effet moyen) : qui le paie (propension à consommer), délai de
  transmission aux prix et aux salaires. -/
  incidencePrelevementPm : ParImpot
  /-- Effet sur la demande d'une dépense selon sa fonction, relativement à
  une dépense de consommation publique, pm (`1000`) : les transferts aux
  ménages (pensions) et aux entreprises soutiennent moins l'activité que la
  consommation publique ; `incidenceInvestissementPm` pour l'investissement
  public (bâtiments, infrastructures), qui la soutient davantage. -/
  incidenceDepensePm : ParFonction
  incidenceInvestissementPm : Int
  /-- Inflation annuelle (déflateur du PIB), pb : sépare le volume des prix
  pour le RNB par habitant de l'IDH. -/
  inflationPb : Int
  /-- Santé publique et éducation (leviers de l'IDH) : élasticité-prix de la
  consommation de tabac (valeur absolue, pm) et accises sur le tabac de
  l'année de départ (M€, comprises dans les autres impôts) ; baisse des décès
  attribuables à l'alcool pour 10 centimes de prix minimum par verre (pm) ;
  dépistage du cancer colorectal : participation de départ (pm), baisse des
  décès par point de participation (pm), population invitée par an
  (milliers) et coût par dépistage supplémentaire (€) ; scolarisation des
  18-24 ans : jeunes par génération (milliers) et dépense par étudiant (€). -/
  elasticitePrixTabacPm : Int := 0
  accisesTabacMeur : Int := 0
  baisseDecesAlcoolPar10CentimesPm : Int := 0
  participationDepistagePm : Int := 0
  baisseDecesColorectalParPointPm : Int := 0
  populationDepistageMilliers : Int := 0
  coutParDepistageEuros : Int := 0
  jeunesParGenerationMilliers : Int := 0
  depenseParEtudiantEuros : Int := 0
  /-- Hausse du chômage (pb) par pb de hausse du SMIC, pm. -/
  elasticiteChomageSmicPm : Int
  /-- Économie annuelle (M€) par mois de recul de l'âge légal. -/
  economieParMoisRetraite : Int
  /-- Taux d'intérêt marginal sur la dette nouvelle et refinancée, valeur de
  long terme, pb. -/
  tauxMarginalPb : Int
  /-- Part de la dette à court terme (titres à moins d'un an), pm : elle est
  renouvelée chaque année au taux court de l'année. -/
  partDetteCourtTermePm : Int
  /-- Taux court de long terme, pb. -/
  tauxCourtPb : Int
  /-- Part de la dette à moyen et long terme refinancée chaque année, pm
  (inverse de sa durée de vie moyenne) : elle est réémise au taux marginal,
  comme la dette nouvelle. -/
  renouvellementDettePm : Int
  /-- Part de la dette indexée sur l'inflation, pm : son capital est
  revalorisé chaque année de l'inflation des prix à la consommation, ce que
  la comptabilité nationale enregistre en charge d'intérêts ; elle est émise
  au taux réel (taux marginal moins inflation de long terme). -/
  partDetteIndexeePm : Int
  /-- Prime de risque : hausse du taux marginal (pb) par point de PIB de
  déficit au-dessus du déficit de départ (baisse en dessous). -/
  primeDeficitPb : Int
  /-- Croissance du patrimoine transmis par décès au-delà du PIB nominal, pb
  par an. -/
  excesPatrimoineParDecesPb : Int
  /-- Élasticité des droits de succession et de donation au patrimoine
  transmis par décès, pm : au-dessus de 1 000, car abattements et barème ne
  sont pas indexés (la part taxable et le taux moyen montent avec les
  montants nominaux). -/
  elasticiteDroitsSuccessionPm : Int
  /-- Part de l'IS acquittée par les groupes du champ du pilier 2 (chiffre
  d'affaires consolidé d'au moins 750 M€), pm. -/
  partISPilier2Pm : Int
  /-- Taux effectif minimal des groupes du pilier 2 (directive (UE)
  2022/2523), pb. -/
  tauxMinimumPilier2Pb : Int
  /-- Semi-élasticité de l'assiette de l'IS au taux effectif : hausse de
  l'assiette, pm, pour un point de taux en moins. -/
  semiElasticiteAssietteISPm : Int
  /-- Contenu en importations de l'investissement public outre-mer, pm. -/
  contenuImportOutreMerPm : Int
  /-- Intensité en emplois relative de chaque secteur (part de l'emploi /
  part de la valeur ajoutée), pm : une demande adressée à un secteur y crée
  d'autant plus d'emplois qu'il est riche en main-d'œuvre. -/
  intensiteEmploiSecteurPm : ParSecteur
  /-- Dépense d'indemnisation par chômeur supplémentaire (assurance chômage
  et solidarité), € de l'année de départ, indexée sur le PIB nominal. -/
  coutParChomeurEuros : Int
  /-- Prélèvements qui reviennent aussitôt sur une rémunération publique
  supplémentaire, pm du brut : CSG et CRDS (toutes natures), cotisations
  salariales selon la nature (traitement : retenue pour pension ; primes :
  RAFP ; heures supplémentaires), impôt sur le revenu (taux marginal moyen ;
  nul pour les heures supplémentaires, exonérées). -/
  tauxCsgCrdsRemunerationPm : Int
  tauxCotisationsTraitementPm : Int
  tauxCotisationsPrimesPm : Int
  tauxCotisationsHeuresSupPm : Int
  tauxIrRemunerationPm : Int
  /-- Actifs supplémentaires (personnes) par mois de recul de l'âge légal. -/
  actifsParMoisAgeLegal : Int
  /-- Élasticité du PIB au volume d'heures travaillées, pm (`650` : part du
  travail dans la valeur ajoutée). -/
  elasticitePibHeuresPm : Int
  /-- Taux normal de l'impôt sur les sociétés en vigueur, pb (`2500` = 25 %). -/
  tauxISPb : Int
  /-- Surcoût annuel de retraites (M€) par pb de part des 65 ans et plus. -/
  coutParPbPlus65 : Int
  /-- Surcoût annuel de dépenses de santé (M€) par pb de part des 65 ans et
  plus (les plus de 65 ans consomment environ deux fois la moyenne). -/
  coutSanteParPbPlus65 : Int
  /-- Contenu en importations d'un supplément de demande intérieure, pm. -/
  contenuImportDemandePm : Int
  /-- Gains tendanciels de productivité par robotisation des services
  automatisables, pb par an (voir `ParFonction.croitrePrimaires`). -/
  robotisationTendanciellePb : Int
  /-- Coût moyen d'un accident du travail avec arrêt pour les finances
  publiques (indemnités journalières, soins, rentes), €. -/
  coutParAccidentEuros : Int
  /-- Journées de travail perdues par accident avec arrêt. -/
  joursPerdusParAccident : Int
  /-- Décès pour 10 000 accidents du travail avec arrêt. -/
  letaliteAccidentsPdm : Int
  /-- Taux d'accidents du travail de la moyenne de l'Union européenne, pour
  10 000 personnes en emploi (norme visée par certaines mesures). -/
  tauxAccidentsUEPdm : Int
  /-- Baisse tendancielle annuelle des émissions de chaque secteur, pm du
  niveau (politiques en vigueur). -/
  baisseEmissionsSecteurPm : ParSecteurGes
  /-- Prélèvement forfaitaire unique sur les revenus de capitaux mobiliers,
  par affectation, pm : part impôt sur le revenu (État), CSG + CRDS
  (Sécurité sociale, CADES), prélèvement de solidarité (État). -/
  tauxPfuIrPm : Int
  tauxPfuCsgCrdsPm : Int
  tauxPfuSolidaritePm : Int
  /-- Effet de flexion : actifs supplémentaires pour un chômeur de moins, pm
  (une partie des emplois créés va à des personnes inactives). -/
  flexionPm : Int
  /-- Part en emploi des actifs maintenus en activité par un recul de l'âge
  de départ (ou libérés par une avance), pm. -/
  tauxEmploiSeniorsMaintenusPm : Int
  /-- Part en emploi des actifs immigrés à leur arrivée, pm. -/
  tauxEmploiMigrantsPm : Int
  /-- Part de l'écart à l'emploi d'équilibre (`chomeursExcedentaires`)
  résorbée chaque année, pm. -/
  absorptionChomagePm : Int
  /-- Coût du travail : élasticité de l'emploi au coût du travail par tranche
  de salaire, pm (valeur absolue : `800` = −0,8 % d'emplois pour +1 % de
  coût) ; emploi salarié privé (milliers) et coût du travail (salaires et
  cotisations, M€) de chaque tranche, année de départ ; part de l'écart à
  l'emploi visé résorbée chaque année, pm. -/
  elasticiteEmploiCoutTravailPm : ParTranche
  emploiPriveTrancheMilliers : ParTranche
  coutTravailTrancheMeur : ParTranche
  ajustementCoutTravailPm : Int
  /-- Accompagnement des demandeurs d'emploi : baisse du nombre de chômeurs
  (personnes, en régime permanent) par conseiller supplémentaire. -/
  chomeursEvitesParConseiller : Int
  sources : List String
  deriving Repr

namespace Economie

/-- Élément `k` d'une trajectoire, ou la valeur de long terme au-delà. -/
def annee (l : List Int) (longTerme : Int) (k : Nat) : Int := l.getD k longTerme

/-- Croissance du PIB en volume de l'année `k + 1`, pb. -/
def croissanceVolumeA (e : Economie) (k : Nat) : Int :=
  annee e.croissanceVolumeAnneesPb e.croissancePotentiellePb k

/-- Croissance potentielle de l'année `k + 1`, pb. -/
def croissancePotentielleA (e : Economie) (k : Nat) : Int :=
  annee e.croissancePotentielleAnneesPb e.croissancePotentiellePb k

/-- Évolution du déflateur du PIB de l'année `k + 1`, pb. -/
def inflationA (e : Economie) (k : Nat) : Int := annee e.inflationAnneesPb e.inflationPb k

/-- Inflation des prix à la consommation de l'année `k + 1`, pb. -/
def inflationConsoA (e : Economie) (k : Nat) : Int :=
  annee e.inflationConsoAnneesPb e.inflationPb k

/-- Inflation des titres indexés de l'année `k + 1`, pb. -/
def inflationIndexationA (e : Economie) (k : Nat) : Int :=
  annee e.inflationIndexationAnneesPb (e.inflationConsoA k) k

/-- Taux marginal de la dette de l'année `k + 1` (avant prime de risque), pb. -/
def tauxMarginalA (e : Economie) (k : Nat) : Int := annee e.tauxMarginalAnneesPb e.tauxMarginalPb k

/-- Revalorisation des valeurs locatives de l'année `k + 1`, pb (au-delà de
la liste : `inflationPrecedente`). -/
def revalorisationFoncierA (e : Economie) (k : Nat) (inflationPrecedente : Int) : Int :=
  annee e.revalorisationFoncierAnneesPb inflationPrecedente k

/-- Croissance de la valeur des transactions immobilières de l'année
`k + 1`, pb (au-delà de la liste : `croissanceNominale`). -/
def croissanceImmobilierA (e : Economie) (k : Nat) (croissanceNominale : Int) : Int :=
  annee e.croissanceImmobilierAnneesPb croissanceNominale k

/-- Taux court de l'année `k + 1`, pb. -/
def tauxCourtA (e : Economie) (k : Nat) : Int := annee e.tauxCourtAnneesPb e.tauxCourtPb k

/-- Croissance du PIB en valeur de l'année `k + 1`, pb : (1 + volume) ×
(1 + prix) − 1. -/
def croissanceNominaleA (e : Economie) (k : Nat) : Int :=
  let v := e.croissanceVolumeA k
  let p := e.inflationA k
  v + p + v * p / 10000

/-- Taux de croissance tendanciel des dépenses de chaque fonction l'année
`k + 1`, pb : volume propre à la fonction, plus les prix (inflation de
l'année précédente pour la part indexée avec décalage, déflateur de l'année
pour le reste). -/
def tauxDepenses (e : Economie) (k : Nat) (inflationConsoPrecedente : Int) : ParFonction :=
  ParFonction.depuis fun f =>
    e.croissanceDepensesVolumePb.get f
      + (e.indexationDecaleePm.get f * inflationConsoPrecedente
          + (1000 - e.indexationDecaleePm.get f) * e.inflationA k) / 1000

/-- Croissance nominale de long terme, pb. -/
def croissanceNominaleLongTerme (e : Economie) : Int :=
  e.croissancePotentiellePb + e.inflationPb + e.croissancePotentiellePb * e.inflationPb / 10000

/-- Toutes les valeurs d'une trajectoire sont dans `[lo, hi]`. -/
def trajectoireEntre (l : List Int) (lo hi : Int) : Bool := l.all fun x => decide (lo ≤ x ∧ x ≤ hi)

end Economie

/-- Contraintes juridiques prises comme hypothèses. -/
structure CadreJuridique where
  id : String
  description : String
  /-- Plafond de déficit public, pb du PIB. -/
  plafondDeficitPb : Int
  /-- Plafond légal d'émissions à l'horizon, MtCO₂e. -/
  plafondEmissionsMt : Int
  sources : List String
  deriving Repr

/-- Un scénario = un point de l'espace des hypothèses. -/
structure Scenario where
  reference : Reference
  demo : Demographie
  natalite : Natalite
  eco : Economie
  energie : Energie
  droit : CadreJuridique
  /-- Nombre d'années projetées. -/
  horizon : Nat
  deriving Repr

namespace Scenario

/-- Identifiant stable, utilisé dans les rapports et les diffs. -/
def id (H : Scenario) : String :=
  s!"{H.demo.id}/{H.natalite.id}/{H.eco.id}/{H.energie.id}/{H.droit.id}"

/-- Bornes sur la situation de départ. -/
abbrev ValideReference (H : Scenario) : Prop :=
  0 < H.reference.etat.pib ∧ 0 < H.reference.populationMilliers ∧
  0 < H.reference.etat.actifs ∧ H.reference.etat.emploiTotal ≤ H.reference.etat.actifs ∧
  H.reference.etat.emploi.Positif ∧
  0 ≤ H.reference.etat.tauxApparentPb ∧ 0 ≤ H.reference.etat.chargeInterets ∧
  0 ≤ H.reference.etat.exportations ∧ 0 ≤ H.reference.etat.importations ∧
  0 ≤ H.reference.etat.touristesMilliers ∧ 0 ≤ H.reference.etat.depenseParTouriste ∧
  0 ≤ H.reference.etat.decesPollutionAir ∧ 0 ≤ H.reference.etat.parcElectriqueMilliers ∧
  0 ≤ H.reference.etat.bornesMilliers ∧ 0 < H.reference.etat.heuresParEmploi ∧
  0 ≤ H.reference.etat.tauxAccidentsPdm

/-- Bornes sur l'axe économique. -/
abbrev ValideEco (H : Scenario) : Prop :=
  0 ≤ H.eco.chomageFrictionnelPb ∧ H.eco.chomageFrictionnelPb < 10000 ∧
  0 ≤ H.eco.okunPm ∧ H.eco.okunPm ≤ 2000 ∧
  0 ≤ H.eco.multiplicateurPm ∧ H.eco.multiplicateurPm ≤ 3000 ∧
  0 ≤ H.eco.fuiteFiscalePm ∧ H.eco.fuiteFiscalePm ≤ 1000 ∧
  0 ≤ H.eco.elasticiteChomageSmicPm ∧ 0 ≤ H.eco.economieParMoisRetraite ∧
  0 ≤ H.eco.tauxMarginalPb ∧ H.eco.tauxMarginalPb ≤ 1500 ∧
  0 ≤ H.eco.primeDeficitPb ∧ H.eco.primeDeficitPb ≤ 100 ∧
  -200 ≤ H.eco.excesPatrimoineParDecesPb ∧ H.eco.excesPatrimoineParDecesPb ≤ 300 ∧
  500 ≤ H.eco.elasticiteDroitsSuccessionPm ∧ H.eco.elasticiteDroitsSuccessionPm ≤ 2000 ∧
  0 ≤ H.eco.partISPilier2Pm ∧ H.eco.partISPilier2Pm ≤ 1000 ∧
  0 ≤ H.eco.tauxMinimumPilier2Pb ∧ H.eco.tauxMinimumPilier2Pb ≤ H.eco.tauxISPb ∧
  0 ≤ H.eco.semiElasticiteAssietteISPm ∧ H.eco.semiElasticiteAssietteISPm ≤ 50 ∧
  0 ≤ H.eco.contenuImportOutreMerPm ∧ H.eco.contenuImportOutreMerPm ≤ 1000 ∧
  0 ≤ H.eco.coutParChomeurEuros ∧
  0 ≤ H.eco.tauxCsgCrdsRemunerationPm ∧ 0 ≤ H.eco.tauxCotisationsTraitementPm ∧
  0 ≤ H.eco.tauxCotisationsPrimesPm ∧ 0 ≤ H.eco.tauxCotisationsHeuresSupPm ∧
  0 ≤ H.eco.tauxIrRemunerationPm ∧
  H.eco.tauxCsgCrdsRemunerationPm + H.eco.tauxCotisationsTraitementPm + H.eco.tauxIrRemunerationPm ≤ 1000 ∧
  0 ≤ H.eco.coutSanteParPbPlus65 ∧
  0 ≤ H.eco.contenuImportDemandePm ∧ H.eco.contenuImportDemandePm ≤ 1000 ∧
  0 ≤ H.eco.robotisationTendanciellePb ∧ H.eco.robotisationTendanciellePb ≤ 500 ∧
  0 ≤ H.eco.coutParAccidentEuros ∧ 0 ≤ H.eco.joursPerdusParAccident ∧
  0 ≤ H.eco.letaliteAccidentsPdm ∧ 0 < H.eco.tauxAccidentsUEPdm ∧
  0 ≤ H.eco.actifsParMoisAgeLegal ∧
  0 ≤ H.eco.elasticitePibHeuresPm ∧ H.eco.elasticitePibHeuresPm ≤ 1000 ∧
  0 < H.eco.tauxISPb ∧ H.eco.tauxISPb ≤ 10000 ∧
  0 ≤ H.eco.tauxPfuIrPm ∧ 0 ≤ H.eco.tauxPfuCsgCrdsPm ∧ 0 ≤ H.eco.tauxPfuSolidaritePm ∧
  H.eco.tauxPfuIrPm + H.eco.tauxPfuCsgCrdsPm + H.eco.tauxPfuSolidaritePm ≤ 1000 ∧
  0 ≤ H.eco.flexionPm ∧ H.eco.flexionPm ≤ 1000 ∧
  0 ≤ H.eco.tauxEmploiSeniorsMaintenusPm ∧ H.eco.tauxEmploiSeniorsMaintenusPm ≤ 1000 ∧
  0 ≤ H.eco.tauxEmploiMigrantsPm ∧ H.eco.tauxEmploiMigrantsPm ≤ 1000 ∧
  0 ≤ H.eco.absorptionChomagePm ∧ H.eco.absorptionChomagePm ≤ 1000

/-- Bornes sur les trajectoires macroéconomiques et la dette. -/
abbrev ValideTrajectoires (H : Scenario) : Prop :=
  -500 ≤ H.eco.croissancePotentiellePb ∧ H.eco.croissancePotentiellePb ≤ 500 ∧
  Economie.trajectoireEntre H.eco.croissanceVolumeAnneesPb (-1500) 1500 = true ∧
  Economie.trajectoireEntre H.eco.croissancePotentielleAnneesPb (-500) 500 = true ∧
  Economie.trajectoireEntre H.eco.inflationAnneesPb (-500) 2000 = true ∧
  Economie.trajectoireEntre H.eco.inflationConsoAnneesPb (-500) 2000 = true ∧
  Economie.trajectoireEntre H.eco.inflationIndexationAnneesPb (-500) 2000 = true ∧
  Economie.trajectoireEntre H.eco.tauxMarginalAnneesPb (-200) 1500 = true ∧
  0 < H.eco.renouvellementDettePm ∧ H.eco.renouvellementDettePm ≤ 1000 ∧
  0 ≤ H.eco.partDetteCourtTermePm ∧ H.eco.partDetteCourtTermePm < 1000 ∧
  -200 ≤ H.eco.tauxCourtPb ∧ H.eco.tauxCourtPb ≤ 1500 ∧
  Economie.trajectoireEntre H.eco.tauxCourtAnneesPb (-200) 1500 = true ∧
  Economie.trajectoireEntre H.eco.revalorisationFoncierAnneesPb (-500) 2000 = true ∧
  Economie.trajectoireEntre H.eco.croissanceImmobilierAnneesPb (-5000) 5000 = true ∧
  0 ≤ H.eco.partDetteIndexeePm ∧ H.eco.partDetteIndexeePm ≤ 1000 ∧
  0 ≤ H.reference.etat.detteDebut ∧
  H.eco.croissanceDepensesVolumePb.toutEntre (-500) 1000 = true ∧
  H.eco.indexationDecaleePm.toutEntre 0 1000 = true

/-- Assiettes : parts dans [0, 1000], sommes au plus 1000, progressivité
entre 1 et 3, excédent des entreprises positif à la référence. -/
abbrev ValideAssiettes (H : Scenario) : Prop :=
  0 ≤ H.eco.assiettes.retardSalairesPm ∧ H.eco.assiettes.retardSalairesPm ≤ 1000 ∧
  0 ≤ H.eco.assiettes.csgActivitePm ∧ 0 ≤ H.eco.assiettes.csgRemplacementPm ∧ H.eco.assiettes.csgActivitePm + H.eco.assiettes.csgRemplacementPm ≤ 1000 ∧
  0 ≤ H.eco.assiettes.irSalairesPm ∧ 0 ≤ H.eco.assiettes.irPensionsPm ∧ 0 ≤ H.eco.assiettes.irIndependantsPm ∧
  H.eco.assiettes.irSalairesPm + H.eco.assiettes.irPensionsPm + H.eco.assiettes.irIndependantsPm ≤ 1000 ∧
  0 ≤ H.eco.assiettes.elasticiteMasseSalarialeCyclePm ∧ H.eco.assiettes.elasticiteMasseSalarialeCyclePm ≤ 2000 ∧
  0 ≤ H.eco.assiettes.elasticiteIndependantsCyclePm ∧ H.eco.assiettes.elasticiteIndependantsCyclePm ≤ 5000 ∧
  0 ≤ H.eco.assiettes.elasticiteCapitalCyclePm ∧ H.eco.assiettes.elasticiteCapitalCyclePm ≤ 6000 ∧
  1000 ≤ H.eco.assiettes.progressiviteIrPm ∧ H.eco.assiettes.progressiviteIrPm ≤ 3000 ∧
  0 ≤ H.eco.assiettes.partIsAnneeCourantePm ∧ H.eco.assiettes.partIsAnneeCourantePm ≤ 1000 ∧
  500 ≤ H.eco.assiettes.elasticiteCotisationsPm ∧ H.eco.assiettes.elasticiteCotisationsPm ≤ 1500 ∧
  500 ≤ H.eco.assiettes.elasticiteIsPm ∧ H.eco.assiettes.elasticiteIsPm ≤ 4000 ∧
  0 < H.eco.assiettes.partValeurAjouteePm ∧ H.eco.assiettes.partValeurAjouteePm ≤ 1000 ∧
  0 ≤ H.eco.assiettes.partSalairesPm ∧ H.eco.assiettes.partSalairesPm ≤ 1000 ∧
  -200 ≤ H.eco.assiettes.croissancePhysiqueFoncierPb ∧ H.eco.assiettes.croissancePhysiqueFoncierPb ≤ 500 ∧
  0 ≤ H.eco.assiettes.elasticiteCarburantsPm ∧ H.eco.assiettes.elasticiteCarburantsPm ≤ 2000 ∧
  0 < H.reference.etat.remunerationParEmploiEuros ∧ 0 < H.reference.etat.consommationMenages ∧
  H.reference.etat.masseSalariale * H.eco.assiettes.partSalairesPm < H.reference.etat.pib * H.eco.assiettes.partValeurAjouteePm

/-- Bornes sur les axes démographie, natalité, énergie et droit. -/
abbrev ValideAxes (H : Scenario) : Prop :=
  0 ≤ H.demo.partPlus65Pb ∧ H.demo.partPlus65Pb ≤ 10000 ∧
  0 ≤ H.demo.decesMilliers ∧ -50 ≤ H.demo.hausseDecesMilliers ∧ H.demo.hausseDecesMilliers ≤ 50 ∧
  -2000 ≤ H.demo.croissanceActifsPb ∧ H.demo.croissanceActifsPb ≤ 2000 ∧
  0 ≤ H.demo.partActiveMigrantsPm ∧ H.demo.partActiveMigrantsPm ≤ 1000 ∧
  0 ≤ H.natalite.naissancesMilliers ∧ 0 < H.natalite.icfCentiemes ∧
  0 < H.energie.prixBrentDollars ∧ 0 < H.energie.prixReferenceDollars ∧
  H.energie.effetPibPar10DollarsPb ≤ 0 ∧ -2000 ≤ H.energie.effetPibPar10DollarsPb ∧
  0 ≤ H.energie.electrificationTendancielleMilliers ∧ 0 ≤ H.energie.bornesTendanciellesMilliers ∧
  0 ≤ H.energie.hausseElectrificationMilliers ∧
  H.energie.electrificationTendancielleMilliers ≤ H.energie.ventesNeuvesMilliers ∧
  0 ≤ H.energie.accisesParVehiculeEuros ∧ 0 ≤ H.energie.tvaParVehiculeEuros ∧
  0 < H.energie.puissanceParBorneW ∧ 0 ≤ H.energie.puissanceAfirParVehiculeW ∧
  0 ≤ H.energie.co2EviteParVehiculeKg ∧ 0 < H.energie.renovation.aideMoyenneEuros ∧
  0 ≤ H.energie.renovation.aubainePm ∧ H.energie.renovation.aubainePm ≤ 1000 ∧
  0 ≤ H.energie.surcoutPerequationZniEurosMWh ∧
  0 ≤ H.energie.decesEvitesParMillionVehicules ∧ 0 < H.energie.vehiculesParBorne ∧
  0 ≤ H.energie.factureEnergetiqueMeur ∧
  0 < H.droit.plafondDeficitPb ∧ 0 < H.droit.plafondEmissionsMt ∧
  1 ≤ H.horizon ∧ H.horizon ≤ 20

/-- Bornes sur les tendances d'émissions par secteur. -/
abbrev ValideClimat (H : Scenario) : Prop :=
  -100 ≤ H.eco.baisseEmissionsSecteurPm.transports ∧ H.eco.baisseEmissionsSecteurPm.transports ≤ 200 ∧
  -100 ≤ H.eco.baisseEmissionsSecteurPm.batiments ∧ H.eco.baisseEmissionsSecteurPm.batiments ≤ 200 ∧
  -100 ≤ H.eco.baisseEmissionsSecteurPm.agriculture ∧ H.eco.baisseEmissionsSecteurPm.agriculture ≤ 200 ∧
  -100 ≤ H.eco.baisseEmissionsSecteurPm.industrie ∧ H.eco.baisseEmissionsSecteurPm.industrie ≤ 200 ∧
  -100 ≤ H.eco.baisseEmissionsSecteurPm.energie ∧ H.eco.baisseEmissionsSecteurPm.energie ≤ 200 ∧
  -100 ≤ H.eco.baisseEmissionsSecteurPm.dechets ∧ H.eco.baisseEmissionsSecteurPm.dechets ≤ 200

/-- Bornes sur l'incidence des prélèvements, le coût du travail et
l'assurance chômage. -/
abbrev ValideTravail (H : Scenario) : Prop :=
  H.eco.incidencePrelevementPm.toutEntre 0 3000 = true ∧
  H.eco.elasticiteCycliquePm.toutEntre 0 3000 = true ∧
  H.eco.incidenceDepensePm.toutEntre 0 3000 = true ∧
  0 ≤ H.eco.incidenceInvestissementPm ∧ H.eco.incidenceInvestissementPm ≤ 3000 ∧
  H.eco.elasticiteEmploiCoutTravailPm.toutEntre 0 3000 = true ∧
  H.eco.emploiPriveTrancheMilliers.toutEntre 0 30000 = true ∧
  H.eco.coutTravailTrancheMeur.toutEntre 1 2000000 = true ∧
  0 ≤ H.eco.ajustementCoutTravailPm ∧ H.eco.ajustementCoutTravailPm ≤ 1000 ∧
  0 ≤ H.eco.chomeursEvitesParConseiller ∧ H.eco.chomeursEvitesParConseiller ≤ 100 ∧
  0 ≤ H.reference.seuilChomageContracyclePb ∧ 0 ≤ H.reference.surcoutComplementChomageMeur ∧
  -500 ≤ H.eco.inflationPb ∧ H.eco.inflationPb ≤ 2000 ∧
  H.demo.decesAttribuables.toutEntre 0 300000 = true ∧
  H.demo.anneesVieParDecesDixiemes.toutEntre 0 800 = true ∧
  H.demo.delaiEffetMortaliteAns.toutEntre 1 50 = true ∧
  0 ≤ H.eco.elasticitePrixTabacPm ∧ H.eco.elasticitePrixTabacPm ≤ 2000 ∧
  0 < H.reference.rnbParHabitantPpaDollars

/-- Bornes de plausibilité. Elles ne disent pas qu'une hypothèse est
*juste*, seulement qu'elle n'est pas absurde. Les resserrer est une
décision du modèle commun. -/
abbrev Valide (H : Scenario) : Prop :=
  H.ValideReference ∧ H.ValideEco ∧ H.ValideAxes ∧ H.ValideClimat ∧ H.ValideTravail ∧
  H.ValideTrajectoires ∧ H.ValideAssiettes

-- Instances nommées : la conjonction complète dépasse la profondeur de
-- recherche d'instances si on la laisse se décomposer atome par atome.
instance (H : Scenario) : Decidable H.ValideReference := inferInstance
instance (H : Scenario) : Decidable H.ValideEco := inferInstance
instance (H : Scenario) : Decidable H.ValideAxes := inferInstance
instance (H : Scenario) : Decidable H.ValideClimat := inferInstance
instance (H : Scenario) : Decidable H.ValideTravail := inferInstance
instance (H : Scenario) : Decidable H.ValideTrajectoires := inferInstance
instance (H : Scenario) : Decidable H.Valide := instDecidableAnd

end Scenario

end Modele
