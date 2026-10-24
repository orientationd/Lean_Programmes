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
    source := s!"{emission} : 65 ans « en moins de dix ans », un tiers des salariés exemptés (non modélisé) ; +3 mois par an à partir de 2028, 65 ans atteints en 2036 (64 ans et 6 mois en 2033, contre 64 ans au calendrier légal)"
    leviers := [.ageLegalCible 780 3] },
  { id := "H-02", titre := "Non-remplacement d'un fonctionnaire sur trois : 250 000 postes sur cinq ans"
    source := s!"{emission} : 250 000 postes sur 750 000 départs ; conversion : 62 500 € par poste et par an (ratio du plan Retailleau, 25 Md€ pour 400 000), soit 15,6 Md€/an en régime de croisière"
    leviers := [.economieSur .fonctionnement 15600] },
  { id := "H-03", titre := "Fonds unique d'adaptation au changement climatique"
    source := s!"{emission} : 2 Md€/an (Euronews)"
    leviers := [.depenseSur .logementEnvironnement 2000] },
  { id := "H-04", titre := "Deux heures supplémentaires par semaine exonérées de cotisations"
    source := s!"{emission} : gain d'environ 1 000 €/an au SMIC ; conversion : +2 h sur 35 h = +5,7 % pour les salariés qui les font, recours supposé de 30 % → +1,7 % d'heures par emploi ; exonération : 0,3 Md€/an (hypothèse)"
    leviers := [.dureeTravail 17, .prelevementSur .cotisations (-300)] },
  { id := "H-05", titre := "Immigration légale divisée par deux en cinq ans"
    source := s!"{emission} : « largement inférieur à 200 000 » titres par an ; conversion : solde migratoire réduit de 90 000 par an (moitié du solde 2025 de 176 000, hypothèse : les titres ne sont pas le solde)"
    leviers := [.migration (-90)] },
  { id := "H-06", titre := "Retraite : 15 % de capitalisation en complément de la répartition"
    source := "É. Philippe, AmCham, février 2026 (via ÉlyséeScope) ; sans montant ni calendrier : non modélisé (le modèle n'a pas de fonds de pension) ; mesure enregistrée pour mémoire"
    leviers := [] }
]

def programme : Programme where
  id := "Horizons"
  nom := "Horizons — Édouard Philippe 2027"
  description := "Transcription partielle et non officielle des propositions d'octobre 2026 : âge légal à 65 ans, non-remplacement d'un fonctionnaire sur trois, fonds d'adaptation climatique, deux heures supplémentaires exonérées. Allocation familiale unique et chômage à 12 mois n'ont pas de montant publié."
  mainteneurs := ["@orientationd"]
  source := "« L'Heure de vérité », France 2, 8 octobre 2026 (Euronews, franceinfo, Echos Plus, consultés le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.Horizons
