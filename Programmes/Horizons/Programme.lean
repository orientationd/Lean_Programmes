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

/-- Rémunération moyenne des enseignants +20 % sur le quinquennat (Le
Figaro, repris par LCP le 24 août 2026). Masse salariale des enseignants
hors CAS Pensions : 59,23 Md€ en 2026 pour 852 752 enseignants (PLF 2026,
rapport du Sénat sur la mission Enseignement scolaire) ; +20 % atteints en
cinq hausses égales (calcul). -/
def hausseEnseignants : Int := 59230 * 20 / 100
def enseignantsEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * hausseEnseignants / 5

/-- Réserve portée de 45 000 à 250 000 réservistes et service militaire
volontaire de 3 000 à 50 000 places par an (edouardphilippe.fr, via
Votons 2027). Réserve : 98 M€ pour 4 400 réservistes de plus à 45 jours
par an (Sénat, rapport sur le PLF 2026, Défense), soit 22 272 € par
réserviste (calcul ; majorant, l'équipement compris). Service militaire
volontaire : 800 € par mois pendant dix mois (Euronews, 31 août 2026),
solde seule (plancher). Montée en charge en cinq ans (hypothèse). -/
def coutReservisteEuros : Int := 98000000 / 4400
def coutDefense : Int := 205000 * coutReservisteEuros / 1000000 + 47000 * 800 * 10 / 1000000
def defenseEcheancier : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => k * coutDefense / 5

theorem ajouts_valeurs :
    hausseEnseignants = 11846 ∧ enseignantsEcheancier = [2369, 4738, 7107, 9476, 11846] ∧
    coutReservisteEuros = 22272 ∧ coutDefense = 4941 ∧
    defenseEcheancier = [988, 1976, 2964, 3952, 4941] := by decide

def mesures : List Mesure := [
  { id := "H-01", titre := "Âge légal porté progressivement à 65 ans, 45 annuités"
    source := s!"{emission} : 65 ans « en moins de dix ans », un tiers des salariés exemptés (non modélisé) ; +3 mois par an à partir de 2028, 65 ans atteints en 2036 (64 ans et 6 mois en 2033, contre 64 ans au calendrier légal)"
    leviers := [.ageLegalCible 780 3] },
  { id := "H-02", titre := "Non-remplacement d'un fonctionnaire sur trois : 250 000 postes sur cinq ans"
    source := s!"{emission} : 250 000 postes sur 750 000 départs ; conversion : 62 500 € par poste et par an (ratio du plan Retailleau, 25 Md€ pour 400 000), soit 15,6 Md€/an en régime de croisière ; 50 000 postes par an, emplois publics retirés un pour un (levier `suppressionPostes`)"
    leviers := [.suppressionPostes .fonctionnement 50000 62500]
    repetitions := 5 },
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
    leviers := [] },
  { id := "H-07", titre := "Pacte fiscal avec les entreprises : −50 Md€ d'impôts de production contre −50 Md€ d'aides"
    source := "É. Philippe, 6 novembre 2025 (Public Sénat), redit en octobre 2026 (LCP) : neutre pour l'État selon lui ; les aides supprimées sont imputées aux affaires économiques (hypothèse ; une partie des aides aux entreprises sont des exonérations de cotisations)"
    leviers := [.prelevementSur .autres (-50000), .economieSur .affairesEconomiques 50000] },
  { id := "H-08", titre := "Part fiscale pleine dès le deuxième enfant"
    source := "edouardphilippe.fr (comparateur IFRAP 2027) ; non chiffré par Horizons : 3,5 Md€ selon le chiffrage par le RN de la même mesure (LCP, 6 octobre 2026), hypothèse"
    leviers := [.prelevementSur .ir (-3500)] },
  { id := "H-09", titre := "Enseignants : rémunération moyenne relevée de 20 % sur le quinquennat"
    source := s!"É. Philippe (Le Figaro, repris par LCP le 24 août 2026), financée en partie par « près d'un million d'élèves en moins » (non modélisé) ; non chiffré : 20 % de 59,23 Md€, {hausseEnseignants} M€ par an atteints en cinq ans (voir `hausseEnseignants`)"
    leviers := [.remunerationPublique .traitement .enseignement enseignantsEcheancier] },
  { id := "H-10", titre := "Défense : 250 000 réservistes, 50 000 places de service militaire volontaire par an"
    source := s!"edouardphilippe.fr, « Pour une France plus sûre » (via Votons 2027, 9 octobre 2026) ; non chiffré : {coutDefense} M€ par an atteints en cinq ans (voir `coutReservisteEuros`) ; obus, drones et nouvelle LPM sans montant"
    leviers := [.depenseEcheancier .defense defenseEcheancier] }
]

def programme : Programme where
  id := "Horizons"
  nom := "Horizons — Édouard Philippe 2027"
  description := "Transcription partielle et non officielle des propositions d'octobre 2026 : âge légal à 65 ans, non-remplacement d'un fonctionnaire sur trois, fonds d'adaptation climatique, deux heures supplémentaires exonérées. Pacte fiscal (−50 Md€ d'impôts de production contre −50 Md€ d'aides), part fiscale dès le deuxième enfant. Ajouts du 28 octobre 2026 : enseignants +20 %, réserve et service militaire volontaire. Allocation familiale unique et chômage à 12 mois n'ont pas de montant publié."
  mainteneurs := ["@orientationd"]
  source := "« L'Heure de vérité », France 2, 8 octobre 2026 (Euronews, franceinfo, Echos Plus, consultés le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.Horizons
