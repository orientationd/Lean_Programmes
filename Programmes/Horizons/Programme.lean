import Modele
import Hypotheses
import Proprietes

/-!
# Horizons — projet d'Édouard Philippe (octobre 2026)

Transcription **partielle et non officielle** des propositions exposées par
Édouard Philippe dans « L'Heure de vérité » (France 2, 8 octobre 2026),
d'après Euronews, franceinfo et Echos Plus (consultés le 21 octobre 2026).
Aucun document programme chiffré n'est publié à cette date : la plupart
des propositions n'ont pas de montant et restent hors modèle (README.md).

Règle de transcription : seules les propositions avec un montant annuel
ou un paramètre que le modèle représente (âge légal) deviennent des
leviers ; les conversions sont écrites dans `source`. Aucun engagement
n'est déclaré.
-/

namespace Programmes.Horizons
open Modele

def emission : String := "É. Philippe, « L'Heure de vérité », France 2, 8 octobre 2026"

def mesures : List Mesure := [
  { id := "H-01", titre := "Âge légal porté progressivement à 65 ans, 45 annuités"
    source := s!"{emission} : 65 ans « en moins de dix ans », un tiers des salariés exemptés (non modélisé) ; +12 mois par rapport au repère de 64 ans du modèle, appliqués dès l'année 0"
    leviers := [.ageLegal 12] },
  { id := "H-02", titre := "Non-remplacement d'un fonctionnaire sur trois : 250 000 postes sur cinq ans"
    source := s!"{emission} : 250 000 postes sur 750 000 départs ; conversion : 62 500 € par poste et par an (ratio du plan Retailleau, 25 Md€ pour 400 000), soit 15,6 Md€/an en régime de croisière"
    leviers := [.economie 15600] },
  { id := "H-03", titre := "Fonds unique d'adaptation au changement climatique"
    source := s!"{emission} : 2 Md€/an (Euronews)"
    leviers := [.depenseSecteur .construction 2000] }
]

def programme : Programme where
  id := "Horizons"
  nom := "Horizons — Édouard Philippe 2027"
  description := "Transcription partielle et non officielle des propositions d'octobre 2026 : âge légal à 65 ans, non-remplacement d'un fonctionnaire sur trois, fonds d'adaptation climatique. Les autres propositions (allocation familiale unique, heures supplémentaires, chômage) n'ont pas de montant publié."
  mainteneurs := ["@orientationd"]
  source := "« L'Heure de vérité », France 2, 8 octobre 2026 (Euronews, franceinfo, Echos Plus, consultés le 21 octobre 2026)"
  mesures := mesures

end Programmes.Horizons
