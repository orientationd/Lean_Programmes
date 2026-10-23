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
  /-- Modification de l'âge légal, mois (positif = recul). -/
  | ageLegal (deltaMois : Int)
  /-- Investissement de transition : réduction d'émissions (MtCO₂e) pour un
  coût annuel (M€). -/
  | transition (reductionMt : Int) (coutAnnuel : Int)
  /-- Amende SRU automatique selon la part de logements sociaux manquants
  (barème et propriétés : `Modele/Logement.lean`). C'est un transfert des
  communes vers le FNAP et les établissements fonciers : **neutre sur le
  solde consolidé** des administrations publiques. Ses effets se lisent
  dans le panel communal du rapport et dans les contrats de la mesure. -/
  | amendeSRU (bareme : BaremeSRU)
  /-- Dépense versée **une fois**, M€ (achat, développement…). Elle augmente
  la dette dès l'année 0 mais pas les dépenses des années suivantes. Effet
  de demande non modélisé (choix prudent). -/
  | depensePonctuelle (montant : Int)
  /-- Remplacement de véhicules par l'État (sous-modèle :
  `Modele/Automobile.lean`). Effet macro : coût d'achat versé une fois.
  Effet sur la balance commerciale : calculé par le sous-modèle et affiché
  dans le rapport à 5 et 10 ans. -/
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
  aidés par an à `primeEuros` chacun. Dépense annuelle ; le parc électrique
  croît d'autant chaque année (effet d'aubaine non modélisé). -/
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
  /-- Taux normal de l'impôt sur les sociétés porté à `tauxPb`, avec un
  retour d'assiette : `retourAssiettePm` de la perte statique est
  récupérée par les bénéfices rapatriés ou relocalisés (entreprises
  revenues ou nouvellement implantées). -/
  | impotSocietes (tauxPb : Int) (retourAssiettePm : Int)
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
  let dEmploi := if s.pib = 0 then 0
    else s.actifs * dPib * H.eco.okunPm * (1000 + H.eco.flexionPm) / (s.pib * 1000000)
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
  -- les actifs maintenus (ou libérés) sont en emploi au taux observé lors du
  -- report de 2010 ; l'écart à l'emploi d'équilibre (taux d'emploi courant)
  -- est résorbé dans la projection
  | .ageLegal d, s =>
      let dActifs := d * H.eco.actifsParMoisAgeLegal
      let dEmploi := appliquerPm dActifs H.eco.tauxEmploiSeniorsMaintenusPm
      let dEquilibre := if s.actifs = 0 then 0 else dActifs * s.emploiTotal / s.actifs
      chocEmploi H dEmploi
        { s with
          ageLegalMois := s.ageLegalMois + d
          depensesF := s.depensesF.ajouter .retraites (-(d * H.eco.economieParMoisRetraite))
          actifs := s.actifs + dActifs
          emploi := s.emploi.repartir dEmploi none
          chomeursExcedentaires := s.chomeursExcedentaires + (dEquilibre - dEmploi) }
  | .dureeTravail v, s =>
      chocHeures H v { s with heuresParEmploi := s.heuresParEmploi + appliquerPm s.heuresParEmploi v }
  -- IS : perte statique au prorata des taux, retour d'assiette, impulsion de demande
  | .impotSocietes taux retour, s =>
      let statique := s.impots.impotSocietes * (taux - H.eco.tauxISPb) / H.eco.tauxISPb
      let rendement := statique - appliquerPm statique retour
      effetDemande H none (-(appliquerPm statique M.multiplicateurPrelevementsPm))
        { s with impots := s.impots.ajouter .impotSocietes rendement }
  | .transition r c, s =>
      appliquerDepense H none .logementEnvironnement c { s with emissionsMt := s.emissionsMt - r }
  -- Transfert interne aux APU : aucun effet sur l'état consolidé. Un effet
  -- logement (rattrapage induit) demanderait un indicateur et une hypothèse
  -- de comportement des communes : évolution du modèle commun, à discuter
  -- en issue.
  | .amendeSRU _, s => s
  | .depensePonctuelle m, s => { s with dette := s.dette + m }
  -- achat versé une fois ; parc électrique et décès évités dès l'année 0
  | .remplacementVehicules r, s =>
      { s with dette := s.dette + r.cout / 1000000
               importations := s.importations + r.importsInitialesCts / 100000000
               variationImportsAnnuelle := s.variationImportsAnnuelle
                 - r.nombre * H.energie.gainCommercialParVehiculeEuros / 1000000
               parcElectriqueMilliers := s.parcElectriqueMilliers + r.nombre / 1000
               decesPollutionAir := s.decesPollutionAir
                 - r.nombre * H.energie.decesEvitesParMillionVehicules / 1000000 }
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
  | .annonceEmplois n, s => { s with emploisAnnonces := s.emploisAnnonces + n }
  | .aideAchatElectrique n prime, s =>
      appliquerDepense H none .logementEnvironnement (n * prime / 1000000)
        { s with electrificationAnnuelleMilliers := s.electrificationAnnuelleMilliers + n / 1000 }
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
