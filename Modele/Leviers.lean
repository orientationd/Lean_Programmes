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
  /-- Durée du travail : variation des heures annuelles par emploi, pm
  (`-86` : 35 h → 32 h). Le PIB suit le volume d'heures à l'élasticité du
  scénario, sans effet d'Okun sur l'emploi. -/
  | dureeTravail (variationPm : Int)
  /-- Taux normal de l'impôt sur les sociétés porté à `tauxPb`, avec un
  retour d'assiette : `retourAssiettePm` de la perte statique est
  récupérée par les bénéfices rapatriés ou relocalisés (entreprises
  revenues ou nouvellement implantées). -/
  | impotSocietes (tauxPb : Int) (retourAssiettePm : Int)
  deriving Repr, DecidableEq

/-- Ajoute `d` emplois (personnes, signé) au secteur `cible`, ou au prorata
des secteurs. Une hausse ne fait jamais passer le chômage sous son niveau
frictionnel. -/
def ajouterEmploi (H : Scenario) (cible : Option Secteur) (d : Int) (s : Etat) : Etat :=
  let plafond := s.actifs * (10000 - H.eco.chomageFrictionnelPb) / 10000
  let d' := if 0 < d then min d (max (plafond - s.emploiTotal) 0) else d
  { s with emploi := s.emploi.repartir d' cible }

/-- Choc sur le niveau du PIB (M€) : recettes au prorata ; emploi via la loi
d'Okun (le chômage baisse de `okun × dPib / PIB`), au bénéfice de `cible`. -/
def chocPib (H : Scenario) (cible : Option Secteur) (dPib : Int) (s : Etat) : Etat :=
  let dRecettes := if s.pib = 0 then 0 else dPib * s.recettes / s.pib
  let dEmploi := if s.pib = 0 then 0 else s.actifs * dPib * H.eco.okunPm / (s.pib * 1000)
  ajouterEmploi H cible dEmploi { s.ajouterRecettesProrata dRecettes with pib := s.pib + dPib }

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

/-- Choc d'offre de travail : variation du volume d'heures (pm) → PIB à
l'élasticité du scénario, recettes au prorata, sans effet d'Okun. -/
def chocHeures (H : Scenario) (variationPm : Int) (s : Etat) : Etat :=
  let dPib := s.pib * variationPm * H.eco.elasticitePibHeuresPm / 1000000
  let dRecettes := if s.pib = 0 then 0 else dPib * s.recettes / s.pib
  { s.ajouterRecettesProrata dRecettes with pib := s.pib + dPib }

/-- Variation du PIB induite par `dEmploi` personnes en emploi de plus (ou
de moins), à durée du travail inchangée. -/
def chocEmploi (H : Scenario) (dEmploi : Int) (s : Etat) : Etat :=
  if s.emploiTotal = 0 then s else chocHeures H (dEmploi * 1000 / s.emploiTotal) s

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
  | .prelevement r, s => appliquerPrelevement M H .autres r s
  | .baissePrelevement c, s => appliquerPrelevement M H .autres (-c) s
  | .prestationParHabitant e, s =>
      appliquerDepense H none .famille (e * s.populationMilliers / 1000) s
  -- le chômage augmente de `hausse × élasticité` : autant d'emplois en moins,
  -- et autant d'heures en moins dans le PIB
  | .revalorisationSmic h, s =>
      let dEmploi := -(s.actifs * h * H.eco.elasticiteChomageSmicPm / 10000000)
      chocEmploi H dEmploi (ajouterEmploi H none dEmploi
        { s with smicMensuel := s.smicMensuel + appliquerPb s.smicMensuel h })
  -- les actifs supplémentaires trouvent un emploi au taux de chômage courant
  -- et produisent à la durée du travail en vigueur
  | .ageLegal d, s =>
      let dActifs := d * H.eco.actifsParMoisAgeLegal
      let dEmploi := if s.actifs = 0 then 0 else dActifs * s.emploiTotal / s.actifs
      chocEmploi H dEmploi
        { s with
          ageLegalMois := s.ageLegalMois + d
          depensesF := s.depensesF.ajouter .retraites (-(d * H.eco.economieParMoisRetraite))
          actifs := s.actifs + dActifs
          emploi := s.emploi.repartir dEmploi none }
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
               parcElectriqueMilliers := s.parcElectriqueMilliers + r.nombre / 1000
               decesPollutionAir := s.decesPollutionAir
                 - r.nombre * H.energie.decesEvitesParMillionVehicules / 1000000 }
  | .prelevementSur i r, s => appliquerPrelevement M H i r s
  | .depenseSecteur sec m, s => appliquerDepense H (some sec) .nonVentile m s
  | .pretEtat m, s => { s with operationsFinancieres := s.operationsFinancieres + m }
  | .aideAchatElectrique n prime, s =>
      appliquerDepense H none .logementEnvironnement (n * prime / 1000000)
        { s with electrificationAnnuelleMilliers := s.electrificationAnnuelleMilliers + n / 1000 }
  | .deploiementBornes n cout, s =>
      appliquerDepense H (some .construction) .affairesEconomiques (n * cout / 1000000)
        { s with bornesAnnuellesMilliers := s.bornesAnnuellesMilliers + n / 1000 }

end Modele
