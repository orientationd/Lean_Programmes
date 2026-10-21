import Modele.Scenario
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
  /-- Prestation forfaitaire, €/an par habitant (le coût dépend de
  l'hypothèse démographique). -/
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
  deriving Repr, DecidableEq

/-- Effet de demande d'une impulsion budgétaire signée (M€) : PIB via le
multiplicateur, recettes au taux moyen de prélèvement, chômage via Okun. -/
def effetDemande (H : Scenario) (impulsion : Int) (s : Etat) : Etat :=
  let dPib := appliquerPm impulsion H.eco.multiplicateurPm
  let dRecettes := if s.pib = 0 then 0 else dPib * s.recettes / s.pib
  let dChomage := appliquerPm (ratioPb dPib s.pib) H.eco.okunPm
  { s with
    pib := s.pib + dPib
    recettes := s.recettes + dRecettes
    chomagePb := max (s.chomagePb - dChomage) H.eco.chomageFrictionnelPb }

/-- Dépense nouvelle (partagée par plusieurs leviers). -/
def appliquerDepense (H : Scenario) (montant : Int) (s : Etat) : Etat :=
  effetDemande H montant { s with depenses := s.depenses + montant }

/-- Interprétation d'un levier sous un scénario. -/
def Levier.appliquer (H : Scenario) : Levier → Etat → Etat
  | .depense m, s => appliquerDepense H m s
  | .economie m, s =>
      effetDemande H (-m) { s with depenses := s.depenses - m }
  | .prelevement r, s =>
      let rendement := r - appliquerPm r H.eco.fuiteFiscalePm
      -- multiplicateur fiscal pris égal à la moitié du multiplicateur de dépense
      effetDemande H (-(r / 2)) { s with recettes := s.recettes + rendement }
  | .baissePrelevement c, s =>
      let cout := c - appliquerPm c H.eco.fuiteFiscalePm
      effetDemande H (c / 2) { s with recettes := s.recettes - cout }
  | .prestationParHabitant e, s =>
      appliquerDepense H (e * H.demo.populationMilliers / 1000) s
  | .revalorisationSmic h, s =>
      { s with
        smicMensuel := s.smicMensuel + appliquerPb s.smicMensuel h
        chomagePb := s.chomagePb + appliquerPm h H.eco.elasticiteChomageSmicPm }
  | .ageLegal d, s =>
      { s with
        ageLegalMois := s.ageLegalMois + d
        depenses := s.depenses - d * H.eco.economieParMoisRetraite }
  | .transition r c, s =>
      appliquerDepense H c { s with emissionsMt := s.emissionsMt - r }
  -- Transfert interne aux APU : aucun effet sur l'état consolidé. Un effet
  -- logement (rattrapage induit) demanderait un indicateur et une hypothèse
  -- de comportement des communes : évolution du modèle commun, à discuter
  -- en issue.
  | .amendeSRU _, s => s
  | .depensePonctuelle m, s => { s with dette := s.dette + m }
  | .remplacementVehicules r, s => { s with dette := s.dette + r.cout / 1000000 }

end Modele
