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
  /-- Assurance chômage, règles contracycliques en vigueur : seuil de taux de
  chômage, pb, à partir duquel la durée d'indemnisation réduite est
  complétée (complément de fin de droits), et surcoût annuel de ce
  complément, M€ de l'année de départ (indexé sur le PIB nominal). Par
  défaut : aucune règle. -/
  seuilChomageContracyclePb : Int := 10000
  surcoutComplementChomageMeur : Int := 0
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

/-- Hypothèses macroéconomiques et de comportement. -/
structure Economie where
  id : String
  description : String
  /-- Croissance annuelle du PIB en valeur, pb. -/
  croissancePb : Int
  /-- Croissance annuelle tendancielle des dépenses à législation constante, pb. -/
  croissanceDepensesPb : Int
  /-- Croissance au-delà de laquelle le chômage baisse (loi d'Okun), pb. -/
  seuilOkunPb : Int
  /-- Baisse du chômage (pb) par pb de croissance au-delà du seuil, en pm. -/
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
  /-- Hausse du chômage (pb) par pb de hausse du SMIC, pm. -/
  elasticiteChomageSmicPm : Int
  /-- Économie annuelle (M€) par mois de recul de l'âge légal. -/
  economieParMoisRetraite : Int
  /-- Taux d'intérêt marginal sur la dette nouvelle et refinancée, pb. -/
  tauxMarginalPb : Int
  /-- Variation annuelle maximale du taux apparent vers le taux marginal, pb
  (rythme de refinancement du stock), à la hausse comme à la baisse. -/
  deriveTauxPb : Int
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
  -1000 ≤ H.eco.croissancePb ∧ H.eco.croissancePb ≤ 2000 ∧
  -1000 ≤ H.eco.croissanceDepensesPb ∧ H.eco.croissanceDepensesPb ≤ 2000 ∧
  0 ≤ H.eco.okunPm ∧ H.eco.okunPm ≤ 2000 ∧
  0 ≤ H.eco.multiplicateurPm ∧ H.eco.multiplicateurPm ≤ 3000 ∧
  0 ≤ H.eco.fuiteFiscalePm ∧ H.eco.fuiteFiscalePm ≤ 1000 ∧
  0 ≤ H.eco.elasticiteChomageSmicPm ∧ 0 ≤ H.eco.economieParMoisRetraite ∧
  0 ≤ H.eco.tauxMarginalPb ∧ H.eco.tauxMarginalPb ≤ 1500 ∧ 0 ≤ H.eco.deriveTauxPb ∧
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
  H.eco.incidenceDepensePm.toutEntre 0 3000 = true ∧
  0 ≤ H.eco.incidenceInvestissementPm ∧ H.eco.incidenceInvestissementPm ≤ 3000 ∧
  H.eco.elasticiteEmploiCoutTravailPm.toutEntre 0 3000 = true ∧
  H.eco.emploiPriveTrancheMilliers.toutEntre 0 30000 = true ∧
  H.eco.coutTravailTrancheMeur.toutEntre 1 2000000 = true ∧
  0 ≤ H.eco.ajustementCoutTravailPm ∧ H.eco.ajustementCoutTravailPm ≤ 1000 ∧
  0 ≤ H.eco.chomeursEvitesParConseiller ∧ H.eco.chomeursEvitesParConseiller ≤ 100 ∧
  0 ≤ H.reference.seuilChomageContracyclePb ∧ 0 ≤ H.reference.surcoutComplementChomageMeur

/-- Bornes de plausibilité. Elles ne disent pas qu'une hypothèse est
*juste*, seulement qu'elle n'est pas absurde. Les resserrer est une
décision du modèle commun. -/
abbrev Valide (H : Scenario) : Prop :=
  H.ValideReference ∧ H.ValideEco ∧ H.ValideAxes ∧ H.ValideClimat ∧ H.ValideTravail

-- Instances nommées : la conjonction complète dépasse la profondeur de
-- recherche d'instances si on la laisse se décomposer atome par atome.
instance (H : Scenario) : Decidable H.ValideReference := inferInstance
instance (H : Scenario) : Decidable H.ValideEco := inferInstance
instance (H : Scenario) : Decidable H.ValideAxes := inferInstance
instance (H : Scenario) : Decidable H.ValideClimat := inferInstance
instance (H : Scenario) : Decidable H.ValideTravail := inferInstance
instance (H : Scenario) : Decidable H.Valide := instDecidableAnd

end Scenario

end Modele
