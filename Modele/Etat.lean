import Modele.Unites

/-!
# État macro suivi par le modèle

Un `Etat` est la photographie d'une année. Le modèle compare toujours deux
états à l'horizon du scénario : le **tendanciel** (sans programme) et
l'état **avec programme**.

Ajouter un champ ici est une modification du modèle commun : elle doit être
discutée en issue avant toute PR (voir CONTRIBUTING.md).
-/

namespace Modele

structure Etat where
  /-- PIB, M€ courants. -/
  pib : Int
  /-- Recettes des administrations publiques, M€. -/
  recettes : Int
  /-- Dépenses des administrations publiques, M€. -/
  depenses : Int
  /-- Dette publique, M€. -/
  dette : Int
  /-- Taux de chômage, pb (`750` = 7,5 %). -/
  chomagePb : Int
  /-- SMIC mensuel brut, €. -/
  smicMensuel : Int
  /-- Émissions territoriales de gaz à effet de serre, MtCO₂e. -/
  emissionsMt : Int
  /-- Âge légal de départ à la retraite, mois. -/
  ageLegalMois : Int
  deriving Repr, DecidableEq, Inhabited

namespace Etat

/-- Déficit public, M€ (positif = déficit). -/
def deficit (s : Etat) : Int := s.depenses - s.recettes

/-- Déficit en pb du PIB. -/
def deficitPb (s : Etat) : Int := ratioPb s.deficit s.pib

/-- Dette en pb du PIB. -/
def dettePb (s : Etat) : Int := ratioPb s.dette s.pib

end Etat

end Modele
