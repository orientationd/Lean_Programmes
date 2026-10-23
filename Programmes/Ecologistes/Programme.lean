import Modele
import Hypotheses
import Proprietes

/-!
# Les Écologistes — « Pour une prospérité écologique » (2027)

Transcription **partielle et non officielle** du programme des Écologistes
adopté le 13 juillet 2026 (lesecologistes.fr, « Projet 2027 », 557
mesures ; pages citées d'après MonVote2027 et Votons 2027, consultés le
22 octobre 2026). La source ne publie pas de chiffrage global.

Règle de transcription : une mesure devient un levier si la source donne
un montant annuel ou un paramètre que le modèle représente (SMIC, âge
légal) ; les conversions sont écrites dans `source`. Aucun engagement n'est
déclaré.
-/

namespace Programmes.Ecologistes
open Modele

def projet : String := "Les Écologistes, « Pour une prospérité écologique », 13 juillet 2026"

def mesures : List Mesure := [
  { id := "E-01", titre := "SMIC porté à 2 000 € brut dès 2027"
    source := s!"{projet}, p. 55 ; +9,9 % par rapport à la référence du modèle (1 820 € brut)"
    leviers := [.revalorisationSmic 990] },
  { id := "E-02", titre := "Âge légal ramené de 64 à 62 ans, objectif 60 ans selon la pénibilité"
    source := s!"{projet}, p. 116 ; −24 mois (l'objectif de 60 ans n'est pas modélisé)"
    leviers := [.ageLegal (-24)] },
  { id := "E-03", titre := "Plan national d'adaptation au changement climatique"
    source := s!"{projet} : « 7 milliards d'euros par an d'ici 2032 » ; emplois dans la construction"
    leviers := [.depenseSur .logementEnvironnement 7000] },
  { id := "E-04", titre := "Loi intégrale contre les violences sexistes et sexuelles"
    source := s!"{projet} : « dotée de 3 milliards d'euros » (traités comme dépense annuelle nouvelle)"
    leviers := [.depenseSur .securiteJustice 3000] },
  { id := "E-05", titre := "Taxe Zucman : 2 % du patrimoine au-delà de 100 M€"
    source := s!"{projet}, p. 66 ; rendement non chiffré par la source : 15 Md€/an retenus (chiffrage du budget rectificatif LFI 2027 pour la même mesure, hypothèse)"
    leviers := [.prelevementSur .autres 15000] },
  { id := "E-06", titre := "Justice : 9 000 magistrats, 10 000 greffiers, 7 000 attachés de justice sur dix ans"
    source := s!"{projet} ; conversion : 26 000 postes × 60 000 € = 1,56 Md€/an en régime de croisière (hypothèse de coût unitaire)"
    leviers := [.depenseSur .securiteJustice 1560, .annonceEmplois 26000] },
  { id := "E-07", titre := "Enseignants : +15 % de salaire en cinq ans ; recherche publique : +10 %"
    source := s!"{projet} ; conversion : masse salariale enseignante ≈ 60 Md€ × 15 % = 9 Md€, recherche publique ≈ 10 Md€ × 10 % = 1 Md€ (hypothèses)"
    leviers := [.depenseSur .enseignement 10000] },
  { id := "E-08", titre := "AAH augmentée de 250 € par mois"
    source := s!"{projet} ; conversion : 1,3 million d'allocataires × 250 € × 12 = 3,9 Md€/an (hypothèse)"
    leviers := [.depenseSur .famille 3900] },
  { id := "E-09", titre := "32 heures sans perte de salaire dans les métiers pénibles ou de nuit"
    source := s!"{projet}, p. 57 ; conversion : −8,6 % d'heures pour 15 % des salariés (métiers exposés, hypothèse) → −1,3 % d'heures par emploi"
    leviers := [.dureeTravail (-13)] }
]

def programme : Programme where
  id := "Ecologistes"
  nom := "Les Écologistes — Prospérité écologique 2027"
  description := "Transcription partielle et non officielle du programme du 13 juillet 2026 : SMIC à 2 000 € brut, retraite à 62 ans, adaptation climatique 7 Md€/an, loi VSS, taxe Zucman, justice, salaires enseignants et chercheurs, AAH. Garantie d'autonomie, 500 000 rénovations par an, ISF climatique, TVA verte et sortie du nucléaire : sans montant publié."
  mainteneurs := ["@orientationd"]
  source := "lesecologistes.fr, Projet 2027 « Pour une prospérité écologique » (via MonVote2027 et Votons 2027, consultés le 22 octobre 2026)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.Ecologistes
