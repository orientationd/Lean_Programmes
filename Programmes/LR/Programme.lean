import Modele
import Hypotheses
import Proprietes

/-!
# Les Républicains — plan Retailleau du 12 octobre 2026

Transcription **partielle et non officielle** du plan de redressement des
finances publiques présenté par Bruno Retailleau le 12 octobre 2026
(Public Sénat, Europe 1, AFP, consultés le 21 octobre 2026) : 197 Md€
d'économies « jusqu'en 2032 », 51 à 56 Md€ d'allègements fiscaux,
excédent primaire en 2030, déficit sous 3 % du PIB en 2031 et 2,2 % en
fin de quinquennat.

Règle de transcription : les montants sont lus comme des économies
**annuelles en régime de croisière** (2032) et appliqués par le modèle dès
l'année 0, sans montée en charge. Les mesures dont le mécanisme n'est pas
détaillé (retraites) sont transcrites comme économie forfaitaire. Aucun
engagement n'est déclaré.
-/

namespace Programmes.LR
open Modele

def plan : String := "Plan Retailleau, 12 octobre 2026 (Public Sénat, Europe 1, AFP)"

def mesures : List Mesure := [
  { id := "LR-01", titre := "Non-remplacement de 400 000 agents publics partant à la retraite"
    source := s!"{plan} : 25 Md€ (sur 5,9 millions d'agents)"
    leviers := [.economieSur .fonctionnement 25000] },
  { id := "LR-02", titre := "Opérateurs de l'État : départs volontaires, suppressions"
    source := s!"{plan} : 5 + 7,5 = 12,5 Md€"
    leviers := [.economieSur .fonctionnement 12500] },
  { id := "LR-03", titre := "Budgets en base zéro, délégation au privé, formation professionnelle aux régions"
    source := s!"{plan} : 11,5 + 5 + 6 = 22,5 Md€"
    leviers := [.economieSur .fonctionnement 22500] },
  { id := "LR-04", titre := "Fin de soutiens : nouvelles installations photovoltaïques et éoliennes, aide au développement, culture et audiovisuel public, contrats aidés, SNU, MaPrimeRénov'"
    source := s!"{plan} : 23 Md€ (agrégat)"
    leviers := [.economieSur .affairesEconomiques 23000] },
  { id := "LR-05", titre := "Immigration : prestations non contributives après cinq ans, asile hors des frontières"
    source := s!"{plan} : 10 Md€, dont 4,5 conditionnés à une révision constitutionnelle"
    leviers := [.economieSur .famille 10000] },
  { id := "LR-06", titre := "Lutte contre la fraude fiscale et sociale"
    source := s!"{plan} : 5 Md€ ; traité comme recette (le modèle lui applique sa fuite fiscale)"
    leviers := [.prelevement 5000] },
  { id := "LR-07", titre := "Subventions publiques aux associations"
    source := s!"{plan} : 3 Md€"
    leviers := [.economieSur .culture 3000] },
  { id := "LR-08", titre := "Retraites : décote entre 63 et 65 ans et autres mesures"
    source := s!"{plan} : « environ 42 Md€ d'amélioration, dont 12 Md€ pour la décote entre 63 et 65 ans » ; mécanisme non détaillé, transcrit comme économie forfaitaire (l'âge légal du modèle reste inchangé)"
    leviers := [.economieSur .retraites 42000] },
  { id := "LR-09", titre := "Assurance chômage et prestations : plafond de 70 % du SMIC pour les aides non contributives"
    source := s!"{plan} : 30 Md€"
    leviers := [.economieSur .famille 30000] },
  { id := "LR-10", titre := "Jour de carence d'ordre public dans le privé"
    source := s!"{plan} : 4 Md€ d'arrêts maladie"
    leviers := [.economieSur .sante 4000] },
  { id := "LR-11", titre := "Effort des collectivités de plus de 10 M€ de budget"
    source := s!"{plan} : 10 Md€ sur 335 Md€ de dépenses, fonctionnement hors personnel et prestations"
    leviers := [.economieSur .fonctionnement 10000] },
  { id := "LR-12", titre := "Baisse des impôts de production"
    source := s!"{plan} : 30 Md€ d'allègements pour les entreprises, dont 15 Md€ d'impôts de production (comparateur IFRAP 2027 ; les 15 Md€ de cotisations patronales sont en LR-14)"
    leviers := [.prelevementSur .autres (-15000)] },
  { id := "LR-13", titre := "Exonération de cotisations sur les heures supplémentaires et autres allègements des ménages"
    source := s!"{plan} : 21 Md€, imputés aux cotisations sociales"
    leviers := [.prelevementSur .cotisations (-21000)] },
  { id := "LR-14", titre := "Baisse de 15 Md€ des cotisations patronales"
    source := s!"{plan} ; comparateur IFRAP 2027 : la moitié des 30 Md€ d'allègements pour les entreprises ; sans ciblage précisé, allègements relevés au prorata des tranches (modèle commun)"
    leviers := [.reductionAllegements (-15000)] },
  { id := "LR-15", titre := "Revenu familial dès le premier enfant (240 € par mois, près de 1 000 € au troisième) à la place de 12 dispositifs ; congé de naissance de six mois à 70 %"
    source := "B. Retailleau, AFP 30 avril 2026 ; Public Sénat, 9 octobre 2026 : 40,3 Md€ bruts financés par 41 Md€ d'aides supprimées et 0,6 à 0,8 Md€ d'économies de gestion, soit ≈ 1,4 Md€ d'économie nette (calcul) ; congé de naissance +0,7 Md€ (chiffrage du parti)"
    leviers := [.economieSur .famille 1400, .depenseSur .famille 700] },
  { id := "LR-16", titre := "Réduction d'impôt sur les intérêts d'emprunt des familles"
    source := "Le Figaro (via SeLoger, 29 septembre 2026) : 220 000 familles par an ; non chiffré : 220 000 × ≈ 1 200 € ≈ 0,27 Md€ par génération de prêts (calcul, hypothèse), cumulés sur la durée des prêts"
    leviers := [.prelevementSur .ir (-270)]
    repetitions := 9 },
  { id := "LR-17", titre := "Fin des 35 heures : durée annuelle de référence portée de 1 607 à 1 623 heures"
    source := "B. Retailleau, Public Sénat, 7 janvier 2026 : +16 heures par an, +1,0 % de durée du travail (calcul)"
    leviers := [.dureeTravail 10] }
]

def programme : Programme where
  id := "LR"
  nom := "Les Républicains — plan Retailleau 2027"
  description := "Transcription partielle et non officielle du plan du 12 octobre 2026 : 197 Md€ d'économies (État, protection sociale, collectivités) et 51 Md€ d'allègements fiscaux, déficit sous 3 % en 2031 ; revenu familial, intérêts d'emprunt des familles, fin des 35 heures ; les 30 Md€ pour les entreprises répartis entre impôts de production et cotisations patronales."
  mainteneurs := ["@orientationd"]
  source := "Présentation du 12 octobre 2026 (Public Sénat, Europe 1, AFP, consultés le 21 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.LR
