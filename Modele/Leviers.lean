import Modele.Scenario
import Modele.Moteur
import Modele.Logement
import Modele.Automobile

/-!
# Leviers : le vocabulaire fermé des mesures

Une mesure de programme n'est **pas** une fonction arbitraire sur l'état :
c'est une liste de `Levier`, interprétés ici, une seule fois, pour tous les
programmes. C'est la garantie d'équité du dépôt : un programme ne peut pas
apporter ses propres élasticités ni son propre multiplicateur. Il choisit des
leviers et des montants ; c'est le modèle commun, sous les hypothèses du
scénario, qui en calcule les effets.

Conséquences :
* les fichiers de programmes sont de la donnée pure, lisible par des
  non-spécialistes de Lean ;
* une PR qui ne touche qu'un dossier `Programmes/X/` ne peut changer que
  l'évaluation de X ;
* ajouter un levier ou changer son interprétation est une modification du
  modèle commun, revue par les mainteneurs (CODEOWNERS).

Ce modèle est volontairement **jouet** : il sert à montrer l'architecture.
Le remplacer par un modèle sérieux (ou brancher une microsimulation qui émet
des certificats vérifiés ici) est le premier chantier.
-/

namespace Modele

inductive Levier where
  /-- Dépense publique nouvelle, M€/an. -/
  | depense (montant : Int)
  /-- Économie sur la dépense, M€/an. -/
  | economie (montant : Int)
  /-- Prélèvement nouveau, rendement **statique** en M€/an (avant
  comportements). -/
  | prelevement (rendementStatique : Int)
  /-- Baisse de prélèvement, coût **statique** en M€/an. -/
  | baissePrelevement (coutStatique : Int)
  /-- Prestation forfaitaire, €/an par habitant (coût calculé sur la
  population de l'année de mise en œuvre). -/
  | prestationParHabitant (eurosParAn : Int)
  /-- Revalorisation du SMIC, pb. -/
  | revalorisationSmic (hausse : Int)
  /-- Modification de l'âge légal, mois (positif = recul), par rapport au
  calendrier en vigueur (qui continue de s'appliquer). -/
  | ageLegal (deltaMois : Int)
  /-- Investissement de transition : réduction d'émissions (MtCO₂e) d'un
  secteur pour un coût annuel (M€). -/
  | transition (secteur : SecteurGes) (reductionMt : Int) (coutAnnuel : Int)
  /-- Amende SRU automatique selon la part de logements sociaux manquants
  (barème et propriétés : `Modele/Logement.lean`). C'est un transfert des
  communes vers le FNAP et les établissements fonciers : **neutre sur le
  solde consolidé** des administrations publiques. Ses effets se lisent
  dans le panel communal du rapport et dans les contrats de la mesure. -/
  | amendeSRU (bareme : BaremeSRU)
  /-- Dépense versée **une fois**, M€ (achat, développement…) : inscrite
  dans les dépenses (et le déficit) de l'année, retirée l'année suivante,
  avec un effet de demande qui s'annule à son tour. -/
  | depensePonctuelle (montant : Int)
  /-- Remplacement de véhicules par l'État (sous-modèle :
  `Modele/Automobile.lean`). Effet macro : achat inscrit dans les dépenses
  de l'année (part importée aux importations, effet de demande sur la part
  intérieure), puis, en niveau : carburant importé évité, accises et TVA
  perdues, CO₂ évité, et décès évités selon la vignette Crit'Air des
  voitures retirées. Effet sur la balance commerciale cumulée : calculé
  par le sous-modèle et affiché dans le rapport à 5 et 10 ans. -/
  | remplacementVehicules (operation : Remplacement)
  /-- Prélèvement nouveau affecté à un impôt identifié, rendement statique
  M€/an (négatif pour une baisse). `prelevement` seul va dans « autres
  impôts ». -/
  | prelevementSur (impot : Impot) (rendementStatique : Int)
  /-- Dépense nouvelle, M€/an, dont l'effet sur l'emploi bénéficie à un
  secteur identifié (sinon : au prorata de tous les secteurs). -/
  | depenseSecteur (secteur : Secteur) (montant : Int)
  /-- Prêt ou prise de participation de l'État dans une entité hors
  administrations publiques (EDF, entreprise nationalisée…), M€/an,
  versé chaque année de la projection. Opération financière : la dette
  augmente, pas le déficit. L'activité financée (chantiers, emplois) se
  déroule hors des administrations publiques et n'est pas modélisée (choix
  prudent), pas plus que les remboursements au-delà de l'horizon. -/
  | pretEtat (montantAnnuel : Int)
  /-- Aide à l'achat de voitures électriques : `vehiculesParAn` véhicules
  aidés par an à `primeEuros` chacun. Dépense annuelle ; le flux
  d'électrification croît d'autant, dans la limite des ventes neuves (au-delà,
  la prime ne paie que des achats que le règlement (UE) 2023/851 impose déjà :
  effet d'aubaine). -/
  | aideAchatElectrique (vehiculesParAn : Int) (primeEuros : Int)
  /-- Déploiement de points de recharge publics : `bornesParAn` par an à
  `coutParBorne` € (dépense annuelle, emplois dans la construction). -/
  | deploiementBornes (bornesParAn : Int) (coutParBorne : Int)
  /-- Dépense nouvelle, M€/an, imputée à une fonction de la nomenclature
  COFOG (les emplois vont au secteur de la fonction). `depense` seul va
  dans « non ventilé ». -/
  | depenseSur (fonction : Fonction) (montant : Int)
  /-- Économie, M€/an, sur une fonction identifiée. -/
  | economieSur (fonction : Fonction) (montant : Int)
  /-- Investissement public (bâtiments, infrastructures), M€/an, imputé à une
  fonction mais dont les emplois vont à la construction. -/
  | investissement (fonction : Fonction) (montant : Int)
  /-- Durée du travail : variation des heures annuelles par emploi, pm
  (`-86` : 35 h → 32 h). Le PIB suit le volume d'heures à l'élasticité du
  scénario, sans effet d'Okun sur l'emploi. -/
  | dureeTravail (variationPm : Int)
  /-- Taux normal de l'impôt sur les sociétés porté à `tauxPb`. Le modèle
  applique le plancher du pilier 2 aux grands groupes (taux effectif moyen)
  et la réponse de l'assiette au taux effectif (bénéfices transférés ou
  relocalisés) ; les deux paramètres sont dans l'axe économique, communs à
  tous les programmes. -/
  | impotSocietes (tauxPb : Int)
  /-- Politique migratoire : écart de solde migratoire net, milliers par an
  (négatif = moins d'entrées). Population et population active suivent
  (part active des migrants du scénario). -/
  | migration (deltaMilliersParAn : Int)
  /-- Objectif d'emplois annoncé par le programme pour cette mesure
  (personnes). Déclaratif : n'agit pas sur le modèle, mais la propriété
  « emplois annoncés réalisables » vérifie que la somme des objectifs tient
  dans la population active du programme. -/
  | annonceEmplois (emplois : Int)
  /-- Programme de qualité d'accueil touristique : `zones` zones de
  rénovation à `coutParZone` M€/an chacune (dépense d'affaires
  économiques, emplois dans la construction), qui relèvent la
  fréquentation de `hausseTouristesPm` et la dépense par touriste de
  `hausseDepensePm`. Le surcroît de recettes touristiques est une demande
  extérieure : il entre dans le PIB au prorata de son contenu en valeur
  ajoutée nationale (80 %). -/
  | accueilTouristique (zones : Int) (coutParZone : Int) (hausseTouristesPm : Int)
      (hausseDepensePm : Int)
  /-- Robotisation accélérée des services automatisables : `gainPb` de
  moins de croissance des dépenses de fonctionnement, d'affaires
  économiques et de santé chaque année, en plus de la tendance. -/
  | robotisation (gainPb : Int)
  /-- Automatisation d'une activité (véhicules autonomes, caisses…) : gain
  de productivité `gainPibPb` sur le niveau du PIB (sans effet d'Okun) et
  `emploisSupprimes` emplois en moins. Parmi les personnes concernées,
  `sortiesActivite` quittent la population active (fin de carrière) ; les
  autres restent actives et sont réabsorbées au rythme du scénario
  (réallocation, voir `Etat.chomeursExcedentaires`). -/
  | automatisation (gainPibPb : Int) (emploisSupprimes : Int) (sortiesActivite : Int)
  /-- Suppression de `postes` emplois publics de la fonction `f`, au coût
  complet `coutParPosteEuros` par an : économie de dépense (impulsion
  pondérée par le moteur), baisse directe de l'emploi public, et réponse de
  l'emploi privé (loi d'Okun) à la seule part de la variation du PIB qui
  n'est pas la production publique supprimée. -/
  | suppressionPostes (f : Fonction) (postes : Int) (coutParPosteEuros : Int)
  /-- Dépense à échéancier sur la fonction `f` : `niveaux` = montants des
  années successives, M€ de l'année d'entrée en vigueur (le premier est
  versé tout de suite, les suivants dans la projection, indexés ; le dernier
  est conservé). Des niveaux négatifs sont des économies (gel d'une
  revalorisation…). L'impulsion de demande suit le niveau pondéré : un
  niveau positif est une dépense (multiplicateur plein), un niveau négatif
  une économie (pondérée par le moteur). Voir `Echeance`. -/
  | depenseEcheancier (f : Fonction) (niveaux : List Int)
  /-- Variation du niveau des importations, M€ (substitution d'une énergie
  importée par une production nationale…). Comme dans le sous-modèle
  automobile, l'effet passe par la balance commerciale, pas par le PIB. -/
  | importationsNiveau (deltaMeur : Int)
  /-- Norme de dépense : les fonctions pilotables (santé, affaires
  économiques, sécurité-justice, logement-environnement, culture, services
  généraux) croissent chaque année de `moderationPb` de moins que la
  tendance. L'économie de l'année passe par le multiplicateur, pondérée par
  le moteur (dans la projection). -/
  | normeDepense (moderationPb : Int)
  /-- Recette à échéancier : impôt (`some i`, avec effet de demande pondéré
  comme un prélèvement) ou recette non fiscale (`none`, sans effet de
  demande : péages, redevances déjà acquittés par les usagers). Niveaux
  annuels nets, M€ de l'année d'entrée en vigueur, indexés sur le PIB
  nominal ; le dernier est conservé. Voir `EcheanceRecette`. -/
  | recetteEcheancier (impot : Option Impot) (niveaux : List Int)
  /-- Prises de participation de l'État dans des entreprises, M€ par an (flux
  porté) : dette sans déficit, portefeuille et dividendes au rendement du
  portefeuille de départ. -/
  | prisesDeParticipation (montantAnnuel : Int)
  /-- Durée de cotisation requise allongée de `moisRequis` mois ; seule la part
  `partDepartsDureePm` des départs, liée à la durée, est retardée d'autant.
  Même effet par mois que `ageLegal`, au millième de mois près. -/
  | dureeCotisation (moisRequis : Int) (partDepartsDureePm : Int)
  /-- Âge légal porté à `cibleMois`. Sous l'âge courant : baisse immédiate et
  fin du calendrier légal. Au-dessus : le calendrier en vigueur est suivi
  (`rythmeMois` = 0) ou remplacé par des hausses de `rythmeMois` mois par an,
  jusqu'à la cible. Les effets sont ceux de `ageLegal`, mois par mois, par
  écart au calendrier dont la tendance du scénario tient déjà compte. -/
  | ageLegalCible (cibleMois : Int) (rythmeMois : Int)
  /-- Prévention des accidents du travail : `fondsMeur` M€/an de fonds
  publics (accompagnement des entreprises, inspection, formation) et
  baisse du taux d'accidents de `baissePm` (pour mille du taux courant).
  Les accidents évités réduisent la dépense d'indemnisation (fonction
  famille-chômage) et rendent des journées de travail au PIB. -/
  | preventionAccidents (fondsMeur : Int) (baissePm : Int)
  /-- Dette numérique : OAT tokenisées, souscrites et échangées en jetons de
  monnaie électronique euro (mécanisme « USDC »), dont les intérêts sont
  exonérés de PFU pour les particuliers résidents. La tranche monte de
  `rythmePm` de la dette par an jusqu'à `ciblePm`. Le taux servi sur la
  tranche est réduit de `capitalisationPm` × taux du PFU (part de
  l'avantage fiscal que le prix des titres capitalise). Les intérêts de la
  tranche détenus par des particuliers résidents (`partResidentsPm`) et
  qui, sans la mesure, auraient été placés en produits imposés au PFU
  (`partImposeeAvantPm`) sont autant de recettes perdues. Calcul annuel
  dans `anneeSuivante`. -/
  | detteNumerique (ciblePm rythmePm capitalisationPm partResidentsPm partImposeeAvantPm : Int)
  /-- Aide à la rénovation énergétique relevée de `bonusEuros` par rénovation
  dans le territoire `cible`. Le modèle en déduit, avec le sous-modèle
  rénovation de l'axe énergie : le coût (bonus sur les rénovations déjà
  aidées, aide entière sur les rénovations suscitées), les rénovations
  suscitées (effet d'aubaine), et chaque année les économies de fioul et de
  gaz (importations, accises, TVA, CO₂). -/
  | bonusRenovation (cible : Territoire) (bonusEuros : Int)
  /-- Investissement public outre-mer, échéancier de niveaux annuels (M€ de
  l'année d'entrée en vigueur ; le dernier niveau est reconduit, 0 pour
  arrêter). Emplois dans la construction ; la part importée de la dépense,
  plus forte qu'en métropole (axe économique), ne soutient pas l'activité
  intérieure et accroît les importations. -/
  | investissementOutreMer (fonction : Fonction) (niveaux : List Int)
  /-- Investissement public échelonné (bâtiments, équipements) : niveaux
  annuels en M€ de l'année d'entrée en vigueur (le dernier niveau est
  reconduit, 0 pour arrêter), imputés à une fonction, emplois dans la
  construction ; l'arrêt des travaux retire ces emplois. -/
  | investissementEcheancier (fonction : Fonction) (niveaux : List Int)
  /-- Raccordement de `foyers` foyers d'outre-mer au réseau électrique : leur
  consommation est produite au coût des zones non interconnectées et le
  tarif péréqué n'en couvre qu'une partie ; le surcoût, financé par les
  charges de service public de l'énergie, est une dépense annuelle
  (affaires économiques). -/
  | raccordementZni (foyers : Int)
  /-- Rémunération supplémentaire d'agents publics déjà en poste (primes,
  traitement, heures supplémentaires), échéancier de niveaux bruts annuels
  (M€ de l'année d'entrée en vigueur ; négatif pour une baisse). Le modèle
  en retire les prélèvements qui reviennent aussitôt (CSG-CRDS, cotisations,
  impôt sur le revenu selon la nature) ; le net soutient la consommation
  (effet de demande d'un transfert), sans production ni emplois publics en
  plus. -/
  | remunerationPublique (nature : NatureRemuneration) (fonction : Fonction) (niveaux : List Int)
  /-- Apurement de `partPm` du stock de passifs implicites du type `type`
  (« dettes cachées » : heures supplémentaires non payées…), payé l'année
  même comme des heures supplémentaires (dépense et déficit de l'année). -/
  | apurementPassifs (type : TypePassif) (fonction : Fonction) (partPm : Int)
  /-- Paiement au fil de l'eau de `partPm` des nouveaux passifs implicites
  du type `type` (heures supplémentaires payées l'année où elles sont
  faites) : dépense permanente, et le stock cesse de croître d'autant. -/
  | paiementFluxPassifs (type : TypePassif) (fonction : Fonction) (partPm : Int)
  /-- Taxe environnementale sur une activité (kérosène des vols intérieurs,
  poids lourds…) : rendement statique `rendementStatique` M€/an sur
  l'impôt `impot`, hausse du coût de l'activité `hausseCoutPm`, émissions
  de l'activité `emissionsViseesKt`. Le modèle applique l'élasticité-prix
  de l'activité (axe énergie) : l'activité, donc ses émissions et
  l'assiette de la taxe, reculent de élasticité × hausse. -/
  | taxeEnvironnementale (activite : ActiviteTaxee) (impot : Impot) (emissionsViseesKt : Int)
      (hausseCoutPm : Int) (rendementStatique : Int)
  deriving Repr, DecidableEq

/-- Ajoute `d` emplois (personnes, signé) au secteur `cible`, ou au prorata
des secteurs. Une hausse ne fait jamais passer le chômage sous son niveau
frictionnel. -/
def ajouterEmploi (H : Scenario) (cible : Option Secteur) (d : Int) (s : Etat) : Etat :=
  let plafond := s.actifs * (10000 - H.eco.chomageFrictionnelPb) / 10000
  let d' := if 0 < d then min d (max (plafond - s.emploiTotal) 0) else d
  { s with emploi := s.emploi.repartir d' cible }

/-- Choc de demande de travail de `d` emplois (signé), au bénéfice de
`cible`. Effet de flexion : la population active varie de
`flexion / (1000 + flexion)` de ces emplois (des inactifs prennent une
partie des emplois créés ; une partie des emplois détruits pousse à
l'inactivité), le reste passe par le chômage. -/
def chocDemandeTravail (H : Scenario) (cible : Option Secteur) (d : Int) (s : Etat) : Etat :=
  let dActifs := d * H.eco.flexionPm / (1000 + H.eco.flexionPm)
  ajouterEmploi H cible d { s with actifs := s.actifs + dActifs }

/-- Emplois correspondant à `dChomeurs` chômeurs de moins (loi d'Okun,
élasticité au SMIC… sont exprimées en chômage) : `(1000 + flexion)/1000`
emploi par chômeur. -/
def emploisPourChomeurs (H : Scenario) (dChomeurs : Int) : Int :=
  dChomeurs * (1000 + H.eco.flexionPm) / 1000

/-- Variation de PIB et de recettes sans effet sur l'emploi. -/
def chocPibSeul (H : Scenario) (dPib : Int) (s : Etat) : Etat :=
  let dRecettes := if s.pib = 0 then 0 else dPib * s.recettes / s.pib
  { s.ajouterRecettesProrata dRecettes with
    pib := s.pib + dPib
    importations := s.importations + appliquerPm dPib H.eco.contenuImportDemandePm }

/-- Choc sur le niveau du PIB (M€) : recettes au prorata ; le chômage baisse
de `okun × dPib / PIB` (loi d'Okun), converti en emplois avec l'effet de
flexion, au bénéfice de `cible`. -/
def chocPib (H : Scenario) (cible : Option Secteur) (dPib : Int) (s : Etat) : Etat :=
  -- une demande adressée à un secteur y crée des emplois selon son intensité
  -- en main-d'œuvre relative (construction, non marchand > industrie)
  let intensite := match cible with
    | some sec => H.eco.intensiteEmploiSecteurPm.get sec
    | none => 1000
  let dEmploi := if s.pib = 0 then 0
    else s.actifs * dPib * H.eco.okunPm * (1000 + H.eco.flexionPm) * intensite / (s.pib * 1000000000)
  chocDemandeTravail H cible dEmploi (chocPibSeul H dPib s)

/-- Effet de demande d'une impulsion budgétaire signée (M€) : PIB via le
multiplicateur, puis `chocPib`. -/
def effetDemande (H : Scenario) (cible : Option Secteur) (impulsion : Int) (s : Etat) : Etat :=
  chocPib H cible (appliquerPm impulsion H.eco.multiplicateurPm) s

/-- Dépense nouvelle sur une fonction (partagée par plusieurs leviers). -/
def appliquerDepense (H : Scenario) (cible : Option Secteur) (f : Fonction) (montant : Int)
    (s : Etat) : Etat :=
  effetDemande H cible montant { s with depensesF := s.depensesF.ajouter f montant }

/-- Économie de dépense : l'impulsion négative est pondérée par le moteur. -/
def appliquerEconomie (M : Moteur) (H : Scenario) (f : Fonction) (montant : Int) (s : Etat) : Etat :=
  effetDemande H none (-(appliquerPm montant M.multiplicateurEconomiesPm))
    { s with depensesF := s.depensesF.ajouter f (-montant) }

/-- Choc d'offre de travail : variation relative `num / den` du volume
d'heures → PIB à l'élasticité du scénario, recettes au prorata, sans effet
d'Okun. Une seule division : pas de perte de précision pour les petits chocs. -/
def chocHeuresRatio (H : Scenario) (num den : Int) (s : Etat) : Etat :=
  if den = 0 then s else
  let dPib := s.pib * num * H.eco.elasticitePibHeuresPm / (den * 1000)
  let dRecettes := if s.pib = 0 then 0 else dPib * s.recettes / s.pib
  { s.ajouterRecettesProrata dRecettes with pib := s.pib + dPib }

/-- Variation du volume d'heures de `variationPm` pour mille. -/
def chocHeures (H : Scenario) (variationPm : Int) (s : Etat) : Etat :=
  chocHeuresRatio H variationPm 1000 s

/-- Variation du PIB induite par `dEmploi` personnes en emploi de plus (ou
de moins), à durée du travail inchangée. -/
def chocEmploi (H : Scenario) (dEmploi : Int) (s : Etat) : Etat :=
  chocHeuresRatio H dEmploi s.emploiTotal s

/-- Prélèvement nouveau (rendement statique `r`, négatif pour une baisse) sur
l'impôt `i`. Le rendement est réduit de la fuite fiscale ; l'impulsion de
demande est pondérée par le moteur (moitié du multiplicateur de dépense dans
le moteur standard). -/
def appliquerPrelevement (M : Moteur) (H : Scenario) (i : Impot) (r : Int) (s : Etat) : Etat :=
  let rendement := r - appliquerPm r H.eco.fuiteFiscalePm
  effetDemande H none (-(appliquerPm r M.multiplicateurPrelevementsPm))
    { s with impots := s.impots.ajouter i rendement }

/-- Recul de l'âge moyen de départ de `moisPm` millièmes de mois : actifs
supplémentaires en emploi au taux observé lors du report de 2010 (l'écart à
l'emploi d'équilibre est résorbé dans la projection), pensions économisées,
PIB par le volume d'heures. -/
def reculDepart (H : Scenario) (moisPm : Int) (s : Etat) : Etat :=
  let dActifs := moisPm * H.eco.actifsParMoisAgeLegal / 1000
  let dEmploi := appliquerPm dActifs H.eco.tauxEmploiSeniorsMaintenusPm
  let dEquilibre := if s.actifs = 0 then 0 else dActifs * s.emploiTotal / s.actifs
  chocEmploi H dEmploi
    { s with
      ageLegalMois := s.ageLegalMois + moisPm / 1000
      depensesF := s.depensesF.ajouter .retraites (-(moisPm * H.eco.economieParMoisRetraite / 1000))
      actifs := s.actifs + dActifs
      emploi := s.emploi.repartir dEmploi none
      chomeursExcedentaires := s.chomeursExcedentaires + (dEquilibre - dEmploi) }

/-- Taux effectif moyen de l'IS pour un taux normal `taux` : les groupes du
pilier 2 (part `partISPilier2Pm` de l'IS) restent imposés au taux minimal
(directive (UE) 2022/2523, impôt complémentaire national depuis la loi de
finances pour 2024). -/
def tauxISEffectif (H : Scenario) (taux : Int) : Int :=
  ((1000 - H.eco.partISPilier2Pm) * taux
    + H.eco.partISPilier2Pm * max taux H.eco.tauxMinimumPilier2Pb) / 1000

/-- Part d'une dépense dont le contenu en importations est `contenuPm`
adressée à la production intérieure, pm, relativement au multiplicateur
national (dont la fuite d'importations est déjà `contenuImportDemandePm`). -/
def partInterieure (H : Scenario) (contenuPm : Int) : Int :=
  if H.eco.contenuImportDemandePm ≥ 1000 then 0
  else max 0 (min 1000 ((1000 - contenuPm) * 1000 / (1000 - H.eco.contenuImportDemandePm)))

/-- Investissement outre-mer : contenu importé de l'axe économique. -/
def partInterieureOutreMer (H : Scenario) : Int :=
  partInterieure H H.eco.contenuImportOutreMerPm

/-- Dépense d'une seule année (achat) : inscrite dans les dépenses de l'année
et retirée l'année suivante (échéancier `[0]`), avec un effet de demande
symétrique ; la part importée va aux importations. -/
def depenseUneAnnee (H : Scenario) (f : Fonction) (secteur : Option Secteur) (part montant : Int)
    (s : Etat) : Etat :=
  let e : Echeance := { fonction := f, restants := [0], niveau := montant, indice := 10000,
                        secteur := secteur, partInterieurePm := part }
  effetDemande H secteur (montant * part / 1000)
    { s with echeances := s.echeances ++ [e]
             depensesF := s.depensesF.ajouter f montant
             importations := s.importations + montant * (1000 - part) / 1000 }

/-- Prélèvements qui reviennent sur une rémunération publique brute `brut`,
selon sa nature : (CSG-CRDS, cotisations salariales, impôt sur le revenu). -/
def retoursRemuneration (H : Scenario) (nature : NatureRemuneration) (brut : Int) : Int × Int × Int :=
  let csg := appliquerPm brut H.eco.tauxCsgCrdsRemunerationPm
  match nature with
  | .traitement => (csg, appliquerPm brut H.eco.tauxCotisationsTraitementPm,
      appliquerPm brut H.eco.tauxIrRemunerationPm)
  | .primes => (csg, appliquerPm brut H.eco.tauxCotisationsPrimesPm,
      appliquerPm brut H.eco.tauxIrRemunerationPm)
  | .heuresSup => (csg, appliquerPm brut H.eco.tauxCotisationsHeuresSupPm, 0)

/-- Effets d'une variation `brut` de rémunération publique, hors inscription
de la dépense : prélèvements qui en reviennent, et effet de demande du
revenu net (pondéré comme un transfert aux ménages). -/
def effetRemuneration (M : Moteur) (H : Scenario) (nature : NatureRemuneration) (brut : Int)
    (s : Etat) : Etat :=
  let (csg, cot, ir) := retoursRemuneration H nature brut
  effetDemande H none (appliquerPm (brut - csg - cot - ir) M.multiplicateurPrelevementsPm)
    { s with impots := ((s.impots.ajouter .csgCrds csg).ajouter .cotisations cot).ajouter .ir ir }

/-- Rémunération publique d'une seule année (apurement d'un arriéré) :
inscrite dans les dépenses de l'année, retirée l'année suivante. -/
def remunerationUneAnnee (M : Moteur) (H : Scenario) (nature : NatureRemuneration) (f : Fonction)
    (montant : Int) (s : Etat) : Etat :=
  let e : Echeance := { fonction := f, restants := [0], niveau := montant, indice := 10000,
                        remuneration := some nature }
  effetRemuneration M H nature montant
    { s with echeances := s.echeances ++ [e], depensesF := s.depensesF.ajouter f montant }

/-- Hausses régulières de `pas` mois par an jusqu'à `reste` mois (dernière
hausse partielle). Vide si `reste` ou `pas` n'est pas positif. -/
def pasReguliers (reste pas : Int) : List Int :=
  if reste ≤ 0 ∨ pas ≤ 0 then []
  else List.replicate (reste / pas).toNat pas ++ (if reste % pas = 0 then [] else [reste % pas])

/-- Calendrier qui suit `cal` en plafonnant la hausse cumulée à `reste` mois,
puis monte de 3 mois par an (rythme de la réforme de 2023) jusqu'à `reste`. -/
def calendrierVers : Int → List Int → List Int
  | reste, [] => pasReguliers reste 3
  | reste, x :: xs =>
      let y := max 0 (min x reste)
      y :: calendrierVers (reste - y) xs

-- 63 ans et 6 mois depuis 62 ans et 9 mois (+9 mois), puis 65 ans (+27) :
-- le calendrier légal est suivi, puis prolongé de 3 mois par an
example : calendrierVers 9 [3, 0, 3, 3, 3, 3] = [3, 0, 3, 3, 0, 0] := by decide
example : calendrierVers 27 [3, 0, 3, 3, 3, 3] = [3, 0, 3, 3, 3, 3, 3, 3, 3, 3] := by decide

/-- Interprétation d'un levier sous un moteur et un scénario. -/
def Levier.appliquer (M : Moteur) (H : Scenario) : Levier → Etat → Etat
  | .depense m, s => appliquerDepense H none .nonVentile m s
  | .economie m, s => appliquerEconomie M H .nonVentile m s
  | .depenseSur f m, s => appliquerDepense H f.secteur f m s
  | .economieSur f m, s => appliquerEconomie M H f m s
  | .investissement f m, s => appliquerDepense H (some .construction) f m s
  | .prelevement r, s => appliquerPrelevement M H .autres r s
  | .baissePrelevement c, s => appliquerPrelevement M H .autres (-c) s
  | .prestationParHabitant e, s =>
      appliquerDepense H none .famille (e * s.populationMilliers / 1000) s
  -- le chômage augmente de `hausse × élasticité` : autant d'emplois en moins,
  -- et autant d'heures en moins dans le PIB
  | .revalorisationSmic h, s =>
      let dEmploi := -(emploisPourChomeurs H (s.actifs * h * H.eco.elasticiteChomageSmicPm / 10000000))
      chocEmploi H dEmploi (chocDemandeTravail H none dEmploi
        { s with smicMensuel := s.smicMensuel + appliquerPb s.smicMensuel h })
  | .ageLegal d, s => reculDepart H (d * 1000) s
  | .dureeCotisation m part, s => reculDepart H (m * part) s
  | .ageLegalCible c r, s =>
      if c ≤ s.ageLegalMois then
        reculDepart H ((c - s.ageLegalMois) * 1000) { s with calendrierAgeLegal := [] }
      else
        { s with calendrierAgeLegal :=
            if r ≤ 0 then calendrierVers (c - s.ageLegalMois) s.calendrierAgeLegal
            else pasReguliers (c - s.ageLegalMois) r }
  | .dureeTravail v, s =>
      chocHeures H v { s with heuresParEmploi := s.heuresParEmploi + appliquerPm s.heuresParEmploi v }
  -- IS : taux effectif moyen (plancher du pilier 2 pour les grands groupes),
  -- assiette qui répond au taux effectif, impulsion de demande sur la
  -- variation statique
  | .impotSocietes taux, s =>
      let t0 := H.eco.tauxISPb
      let tEff := tauxISEffectif H taux
      let statique := s.impots.impotSocietes * (tEff - t0) / t0
      -- recettes après réponse de l'assiette : IS × tEff/t0 × (1 + ε × (t0 − tEff)/100)
      let apres := s.impots.impotSocietes * tEff
        * (100000 + H.eco.semiElasticiteAssietteISPm * (t0 - tEff)) / (t0 * 100000)
      effetDemande H none (-(appliquerPm statique M.multiplicateurPrelevementsPm))
        { s with impots := s.impots.ajouter .impotSocietes (apres - s.impots.impotSocietes) }
  | .transition sec r c, s =>
      appliquerDepense H none .logementEnvironnement c (s.reduireEmissions sec (r * 1000))
  -- Transfert interne aux APU : aucun effet sur l'état consolidé. Un effet
  -- logement (rattrapage induit) demanderait un indicateur et une hypothèse
  -- de comportement des communes : évolution du modèle commun, à discuter
  -- en issue.
  | .amendeSRU _, s => s
  | .depensePonctuelle m, s => depenseUneAnnee H .nonVentile none 1000 m s
  -- achat : dépense de l'année (déficit), dont la part importée suit les
  -- importations, retirée l'année suivante ; dès l'année 0 et en niveau :
  -- parc électrique, particules selon la vignette Crit'Air des voitures
  -- retirées, CO₂, carburant importé en moins, accises et TVA perdues
  | .remplacementVehicules r, s =>
      let pm := (H.energie.pmRelatifCritAirPm.getD r.vignetteCritAir 1000)
      let s : Etat := depenseUneAnnee H .logementEnvironnement (some .industrie)
        (partInterieure H r.partImporteePm) (r.cout / 1000000)
        (s.reduireEmissions .transports (r.nombre * H.energie.co2EviteParVehiculeKg / 1000000))
      { s with importations := s.importations
                 - r.nombre * H.energie.gainCommercialParVehiculeEuros / 1000000
               impots := (s.impots.ajouter .accisesEnergie
                   (-(r.nombre * H.energie.accisesParVehiculeEuros / 1000000)))
                 |>.ajouter .tva (-(r.nombre * H.energie.tvaParVehiculeEuros / 1000000))
               parcElectriqueMilliers := s.parcElectriqueMilliers + r.nombre / 1000
               decesPollutionAir := s.decesPollutionAir
                 - r.nombre * H.energie.decesEvitesParMillionVehicules * pm / 1000000000 }
  | .prelevementSur i r, s => appliquerPrelevement M H i r s
  | .depenseSecteur sec m, s => appliquerDepense H (some sec) .nonVentile m s
  | .pretEtat m, s => { s with operationsFinancieres := s.operationsFinancieres + m }
  | .migration d, s => { s with migrationAnnuelleMilliers := s.migrationAnnuelleMilliers + d }
  | .accueilTouristique zones cout hT hD, s =>
      let s₁ := appliquerDepense H (some .construction) .affairesEconomiques (zones * cout) s
      let s₂ := { s₁ with touristesMilliers := s₁.touristesMilliers + appliquerPm s₁.touristesMilliers hT
                          depenseParTouriste := s₁.depenseParTouriste + appliquerPm s₁.depenseParTouriste hD }
      let dExport := s₂.recettesTourisme - s₁.recettesTourisme
      chocPib H none (appliquerPm dExport 800) { s₂ with exportations := s₂.exportations + dExport }
  | .robotisation g, s => { s with robotisationPb := s.robotisationPb + g }
  | .preventionAccidents fonds baisse, s =>
      let s₁ := appliquerDepense H none .famille fonds s
      let avant := s₁.accidentsTravail
      let s₂ := { s₁ with tauxAccidentsPdm := s₁.tauxAccidentsPdm - appliquerPm s₁.tauxAccidentsPdm baisse }
      let evites := avant - s₂.accidentsTravail
      let economie := evites * H.eco.coutParAccidentEuros / 1000000
      -- journées rendues au travail : 7 h chacune, rapportées au volume d'heures
      let heures : Int := evites * H.eco.joursPerdusParAccident * 7
      chocHeuresRatio H heures (s₂.heuresTotales * 1000000)
        { s₂ with depensesF := s₂.depensesF.ajouter .famille (-economie) }
  -- réallocation : l'écart à l'emploi d'équilibre (taux d'emploi courant
  -- appliqué à la population active restante) est résorbé dans la projection
  | .automatisation g emplois sorties, s =>
      let dEquilibre := if s.actifs = 0 then 0 else -(sorties * s.emploiTotal / s.actifs)
      let s' : Etat := { s with
        actifs := s.actifs - sorties
        emploi := s.emploi.repartir (-emplois) none
        chomeursExcedentaires := s.chomeursExcedentaires + (dEquilibre + emplois) }
      let dPib := appliquerPb s'.pib g
      let dRecettes := if s'.pib = 0 then 0 else dPib * s'.recettes / s'.pib
      { s'.ajouterRecettesProrata dRecettes with pib := s'.pib + dPib }
  -- la production publique supprimée (au coût des facteurs) est la part
  -- directe de la baisse du PIB ; l'emploi privé répond au reste
  | .suppressionPostes f postes cout, s =>
      let economie := postes * cout / 1000000
      let dPib := -(appliquerPm (appliquerPm economie M.multiplicateurEconomiesPm) H.eco.multiplicateurPm)
      let s₁ := chocPibSeul H dPib { s with depensesF := s.depensesF.ajouter f (-economie) }
      let s₂ := chocDemandeTravail H (some .tertiaireNonMarchand) (-postes) s₁
      let reste := dPib + economie
      let dEmploi := if s₂.pib = 0 then 0
        else s₂.actifs * reste * H.eco.okunPm * (1000 + H.eco.flexionPm) / (s₂.pib * 1000000)
      chocDemandeTravail H none dEmploi s₂
  | .depenseEcheancier _ [], s => s
  | .depenseEcheancier f (n :: reste), s =>
      let s' := { s with echeances := s.echeances ++ [{ fonction := f, restants := reste, niveau := n, indice := 10000 }] }
      if n < 0 then appliquerEconomie M H f (-n) s' else appliquerDepense H f.secteur f n s'
  | .importationsNiveau d, s => { s with importations := s.importations + d }
  | .normeDepense m, s => { s with moderationDepensesPb := s.moderationDepensesPb + m }
  | .recetteEcheancier _ [], s => s
  | .recetteEcheancier i (n :: reste), s =>
      let e : EcheanceRecette := { impot := i, restants := reste, niveau := n, indice := 10000 }
      let s' : Etat := { s with echeancesRecettes := s.echeancesRecettes ++ [e] }
      match i with
      | some imp =>
          effetDemande H none (-(appliquerPm n M.multiplicateurPrelevementsPm))
            { s' with impots := s'.impots.ajouter imp n }
      | none => { s' with autresRecettes := s'.autresRecettes + n }
  | .prisesDeParticipation m, s =>
      { s with investissementsParticipations := s.investissementsParticipations + m }
  | .annonceEmplois n, s => { s with emploisAnnonces := s.emploisAnnonces + n }
  | .aideAchatElectrique n prime, s =>
      appliquerDepense H none .logementEnvironnement (n * prime / 1000000)
        { s with electrificationAnnuelleMilliers := s.electrificationAnnuelleMilliers + n / 1000 }
  -- rénovation : rénovations déjà aidées dans la cible, rénovations suscitées
  -- par le bonus (demande linéaire en l'aide), coût annuel, économies
  -- d'énergie portées par la projection
  -- le bonus versé aux rénovations qui auraient eu lieu est un transfert aux
  -- ménages (effet de demande d'une baisse de prélèvement) ; les rénovations
  -- suscitées sont des travaux, aide et part des ménages comprises, adressés
  -- à la construction
  | .bonusRenovation cible bonus, s =>
      let R := H.energie.renovation
      let base := R.renovationsAideesParAn * R.part cible / 1000
      let suscitees := base * (1000 - R.aubainePm) * bonus / (1000 * R.aideMoyenneEuros)
      let transfert := base * bonus / 1000000
      let aideSuscitees := suscitees * (R.aideMoyenneEuros + bonus) / 1000000
      let travaux := suscitees * max R.coutTravauxMoyenEuros (R.aideMoyenneEuros + bonus) / 1000000
      let mwh := suscitees * R.economieKWhParRenovation / 1000
      let s₁ : Etat := { s with
        depensesF := s.depensesF.ajouter .logementEnvironnement (transfert + aideSuscitees)
        economiesFioulMWhAnnuelles := s.economiesFioulMWhAnnuelles + mwh * R.partFioul cible / 1000
        economiesGazMWhAnnuelles := s.economiesGazMWhAnnuelles + mwh * R.partGaz cible / 1000 }
      effetDemande H (some .construction) travaux
        (effetDemande H none (appliquerPm transfert M.multiplicateurPrelevementsPm) s₁)
  | .investissementEcheancier _ [], s => s
  | .investissementEcheancier f (n :: reste), s =>
      let e : Echeance := { fonction := f, restants := reste, niveau := n, indice := 10000,
                            secteur := some .construction }
      appliquerDepense H (some .construction) f n { s with echeances := s.echeances ++ [e] }
  | .investissementOutreMer _ [], s => s
  | .investissementOutreMer f (n :: reste), s =>
      let part := partInterieureOutreMer H
      let e : Echeance := { fonction := f, restants := reste, niveau := n, indice := 10000,
                            secteur := some .construction, partInterieurePm := part }
      let s' : Etat := { s with echeances := s.echeances ++ [e]
                                depensesF := s.depensesF.ajouter f n
                                importations := s.importations + n * (1000 - part) / 1000 }
      effetDemande H (some .construction) (n * part / 1000) s'
  | .remunerationPublique _ _ [], s => s
  | .remunerationPublique nat f (n :: reste), s =>
      let e : Echeance := { fonction := f, restants := reste, niveau := n, indice := 10000,
                            remuneration := some nat }
      effetRemuneration M H nat n
        { s with echeances := s.echeances ++ [e], depensesF := s.depensesF.ajouter f n }
  | .apurementPassifs t f part, s =>
      let montant := s.passifs.get t * part / 1000
      remunerationUneAnnee M H .heuresSup f montant
        { s with passifs := s.passifs.ajouter t (-montant) }
  | .paiementFluxPassifs t f part, s =>
      let montant := s.fluxPassifs.get t * part / 1000
      let e : Echeance := { fonction := f, restants := [], niveau := montant, indice := 10000,
                            remuneration := some .heuresSup }
      effetRemuneration M H .heuresSup montant
        { s with echeances := s.echeances ++ [e], depensesF := s.depensesF.ajouter f montant
                 fluxPassifs := s.fluxPassifs.ajouter t (-montant) }
  | .taxeEnvironnementale act imp emissions hausse statique, s =>
      let recul := H.energie.elasticitesPrix.get act * hausse / 1000
      appliquerPrelevement M H imp (statique * (1000 - recul) / 1000)
        (s.reduireEmissions act.secteur (emissions * recul / 1000))
  | .raccordementZni foyers, s =>
      appliquerDepense H none .affairesEconomiques
        (foyers * H.energie.consommationFoyerZniKWh * H.energie.surcoutPerequationZniEurosMWh / 1000000000) s
  | .detteNumerique cible rythme cap res imp, s =>
      let tPfu := H.eco.tauxPfuIrPm + H.eco.tauxPfuCsgCrdsPm + H.eco.tauxPfuSolidaritePm
      { s with cibleDetteNumeriquePm := cible
               rythmeDetteNumeriquePm := rythme
               decoteDetteNumeriquePm := cap * tPfu / 1000
               partDefiscaliseePm := res * imp / 1000 }
  | .deploiementBornes n cout, s =>
      appliquerDepense H (some .construction) .affairesEconomiques (n * cout / 1000000)
        { s with bornesAnnuellesMilliers := s.bornesAnnuellesMilliers + n / 1000 }

end Modele
