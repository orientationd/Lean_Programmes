import Modele
import Hypotheses
import Proprietes

/-!
# Rassemblement national — contre-budget du 6 octobre 2026

Transcription **partielle et non officielle** du dossier de presse « Pour la
Renaissance de la France : l'urgence de réparer les finances publiques »
(RN, 6 octobre 2026), connu par la note de contexte de l'Institut de
l'Entreprise (IDEP, octobre 2026) et la presse ; le dossier lui-même n'est
pas publié en ligne à la date de consultation (21 octobre 2026). Le RN
annonce une amélioration nette du solde de 141,7 Md€ en 2031, un déficit
de 2,2 % du PIB et une dette de 112,1 % en 2032.

Règle de transcription : montants **annuels 2031** du dossier (année
pleine), appliqués par le modèle dès l'année 0 ; les montées en charge ne
sont pas reproduites. Les agrégats sans détail de mesure sont transcrits
comme une seule mesure, dont le champ `source` donne le calcul. Le modèle
applique ses propres hypothèses (fuite fiscale, multiplicateur, coût d'un
mois d'âge légal) aux montants annoncés. Aucun engagement n'est déclaré.
-/

namespace Programmes.RN
open Modele

def dossier : String :=
  "RN, « Pour la Renaissance de la France », 6 octobre 2026, via la note IDEP (Institut de l'Entreprise)"

def mesures : List Mesure := [
  { id := "RN-01", titre := "TVA à 5,5 % sur les énergies"
    source := s!"{dossier} : −12,2 Md€/an (chiffrage du parti ; carburants inclus)"
    leviers := [.prelevementSur .tva (-12200)] },
  { id := "RN-02", titre := "Suppression de la CFE, de la CVAE et de la C3S"
    source := s!"{dossier} : −17 Md€/an d'impôts de production (presse) ; l'agrégat « ensemble des entreprises » du dossier est de −11,1 Md€ en 2031, suramortissement et surcroît d'IS compris"
    leviers := [.prelevementSur .autres (-17000)] },
  { id := "RN-03", titre := "Fiscalité des grandes entreprises : rachats d'actions, IS sur le chiffre d'affaires, superdividendes"
    source := s!"{dossier} : +5,6 Md€ en 2031 (agrégat « grandes entreprises », dont IS sur le chiffre d'affaires 7,5), imputé à l'impôt sur les sociétés"
    leviers := [.prelevementSur .impotSocietes 5600] },
  { id := "RN-04", titre := "Autres baisses d'impôts des ménages : TVA à 0 % sur 100 produits, part fiscale, IR des moins de 30 ans, IFF"
    source := s!"{dossier} : agrégat « ménages, fiscalité » −22,1 Md€ en 2031, dont −12,2 de TVA énergies (RN-01) : reste −9,9 Md€, imputé aux « autres impôts »"
    leviers := [.prelevementSur .autres (-9900)] },
  { id := "RN-05", titre := "Retraite à 62 ans avec 42 annuités"
    source := s!"{dossier} : le parti chiffre 9 Md€/an ; le modèle applique son propre coût par mois d'âge légal (hypothèse économique du scénario)"
    leviers := [.ageLegal (-24)] },
  { id := "RN-06", titre := "Non-renouvellement de 201 000 postes publics"
    source := s!"{dossier} : ≈ 13,5 Md€/an en 2032 (presse)"
    leviers := [.economieSur .fonctionnement 13500] },
  { id := "RN-07", titre := "Effort des collectivités territoriales"
    source := s!"{dossier} : 8,2 Md€/an (presse)"
    leviers := [.economieSur .fonctionnement 8200] },
  { id := "RN-08", titre := "Priorité nationale : prestations de solidarité après cinq ans de résidence, prestations familiales"
    source := s!"{dossier} : 12,2 + 5,9 = 18,1 Md€ en 2031 (agrégat « immigration » : 29,0 avec l'AMU, la taxe sur les transferts et la taxe à l'embauche, non détaillées) ; suppose une révision constitutionnelle"
    leviers := [.economieSur .famille 18100] },
  { id := "RN-09", titre := "Baisse unilatérale de la contribution à l'Union européenne"
    source := s!"{dossier} : 13,1 Md€ en 2031"
    leviers := [.economieSur .fonctionnement 13100] },
  { id := "RN-10", titre := "TVA prélevée à la source et lutte contre les cartels de marchés publics"
    source := s!"{dossier} : 18,0 + 5,8 = 23,8 Md€ en 2031 ; traité comme une recette de TVA (le modèle lui applique sa fuite fiscale et son effet de demande)"
    leviers := [.prelevementSur .tva 23800] },
  { id := "RN-11", titre := "Suppression d'agences de l'État et parc immobilier"
    source := s!"{dossier} : 10,1 + 5,1 = 15,2 Md€ en 2031"
    leviers := [.economieSur .fonctionnement 15200] },
  { id := "RN-12", titre := "Sécurité sociale : réparation des retraites, dépenses indues, coûts hospitaliers"
    source := s!"{dossier} : 15,0 + 9,5 + 8,3 = 32,8 Md€ en 2031 (agrégat « Sécurité sociale » : 53,1 avec ALD et carte Vitale biométrique, non détaillées)"
    leviers := [.economieSur .sante 32800] },
  { id := "RN-13", titre := "Rebudgétisation des certificats d'économies d'énergie"
    source := s!"{dossier} : 8,0 Md€ en 2031 ; charge transférée des fournisseurs d'énergie au budget, comptée par le dossier comme recette : traitée comme prélèvement sur les « autres impôts »"
    leviers := [.prelevementSur .autres 8000] },
  { id := "RN-14", titre := "Dispositif « 100 % Rénov' »"
    source := s!"{dossier} : +3,8 Md€/an (presse)"
    leviers := [.depenseSur .logementEnvironnement 3800] },
  { id := "RN-15", titre := "Recherche publique"
    source := s!"{dossier} : +9 Md€/an (presse)"
    leviers := [.depenseSur .enseignement 9000] }
]

def programme : Programme where
  id := "RN"
  nom := "Rassemblement national — contre-budget 2027"
  description := "Transcription partielle et non officielle du dossier « Pour la Renaissance de la France » (6 octobre 2026) : baisses de TVA et d'impôts de production, retraite à 62 ans, économies sur l'État, les collectivités, l'Union européenne, les prestations et la Sécurité sociale. Le RN annonce 141,7 Md€ d'amélioration du solde en 2031."
  mainteneurs := ["@orientationd"]
  source := "Dossier de presse du 6 octobre 2026, via Institut de l'Entreprise (note IDEP) et presse (consultés le 21 octobre 2026)"
  mesures := mesures

end Programmes.RN
