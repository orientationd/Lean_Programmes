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
  sources : List String
  deriving Repr

/-- Hypothèses démographiques **à l'horizon**. -/
structure Demographie where
  id : String
  description : String
  populationMilliers : Int
  partPlus65Pb : Int
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
  /-- Hausse du chômage (pb) par pb de hausse du SMIC, pm. -/
  elasticiteChomageSmicPm : Int
  /-- Économie annuelle (M€) par mois de recul de l'âge légal. -/
  economieParMoisRetraite : Int
  /-- Surcoût annuel de dépenses (M€) par pb de part des 65 ans et plus. -/
  coutParPbPlus65 : Int
  /-- Baisse tendancielle annuelle des émissions, pm. -/
  baisseEmissionsPm : Int
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
  eco : Economie
  droit : CadreJuridique
  /-- Nombre d'années projetées. -/
  horizon : Nat
  deriving Repr

namespace Scenario

/-- Identifiant stable, utilisé dans les rapports et les diffs. -/
def id (H : Scenario) : String :=
  s!"{H.demo.id}/{H.eco.id}/{H.droit.id}"

/-- Bornes de plausibilité. Elles ne disent pas qu'une hypothèse est
*juste*, seulement qu'elle n'est pas absurde. Les resserrer est une
décision du modèle commun. -/
abbrev Valide (H : Scenario) : Prop :=
  0 < H.reference.etat.pib ∧ 0 < H.reference.populationMilliers ∧
  0 < H.demo.populationMilliers ∧
  0 ≤ H.demo.partPlus65Pb ∧ H.demo.partPlus65Pb ≤ 10000 ∧
  -1000 ≤ H.eco.croissancePb ∧ H.eco.croissancePb ≤ 2000 ∧
  -1000 ≤ H.eco.croissanceDepensesPb ∧ H.eco.croissanceDepensesPb ≤ 2000 ∧
  0 ≤ H.eco.okunPm ∧ H.eco.okunPm ≤ 2000 ∧
  0 ≤ H.eco.multiplicateurPm ∧ H.eco.multiplicateurPm ≤ 3000 ∧
  0 ≤ H.eco.fuiteFiscalePm ∧ H.eco.fuiteFiscalePm ≤ 1000 ∧
  0 ≤ H.eco.elasticiteChomageSmicPm ∧
  0 ≤ H.eco.economieParMoisRetraite ∧
  0 ≤ H.eco.baisseEmissionsPm ∧ H.eco.baisseEmissionsPm ≤ 1000 ∧
  0 < H.droit.plafondDeficitPb ∧ 0 < H.droit.plafondEmissionsMt ∧
  1 ≤ H.horizon ∧ H.horizon ≤ 20

end Scenario

end Modele
