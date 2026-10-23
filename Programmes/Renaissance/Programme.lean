import Modele
import Hypotheses
import Proprietes

/-!
# Renaissance — Gabriel Attal 2027

Transcription **partielle et non officielle** des propositions de Gabriel
Attal (attalpresident.fr, 75 mesures ; interviews d'avril à octobre 2026),
d'après la presse (RMC, 6 octobre 2026 ; Le Parisien, 23 mai 2026 ;
CNews, 30 avril 2026), consultée le 22 octobre 2026. Le programme ne
publie pas de chiffrage d'ensemble : une seule proposition a un montant.

Règle de transcription : seules les propositions avec un montant annuel ou
un paramètre que le modèle représente deviennent des leviers. Aucun
engagement n'est déclaré.
-/

namespace Programmes.Renaissance
open Modele

def mesures : List Mesure := [
  { id := "RE-01", titre := "« Droit au brut » : baisse des cotisations salariales, jusqu'à 250 € net par mois au salaire médian"
    source := "G. Attal, RMC, 6 octobre 2026 : coût estimé 40 Md€/an, financement non précisé ; imputé aux cotisations sociales"
    leviers := [.prelevementSur .cotisations (-40000)] },
  { id := "RE-02", titre := "Réforme de l'assurance chômage « qui incite au travail »"
    source := "attalpresident.fr/programme (via Votons 2027) : « 100 000 emplois supplémentaires » ; sans montant : seul l'objectif d'emplois est enregistré"
    leviers := [.annonceEmplois 100000] },
  { id := "RE-03", titre := "Année blanche sur les prestations sociales en 2028, petites retraites épargnées"
    source := "G. Attal, Le Parisien, 2 juillet 2026 (via MoneyVox) ; conversion : non-indexation d'un an de ≈ 700 Md€ de prestations hors petites retraites, inflation 1,5 % → ≈ 10 Md€/an d'économie permanente, répartie 6 Md€ retraites et 4 Md€ autres prestations (hypothèses) ; entrée en vigueur la troisième année (2028)"
    leviers := [.economieSur .retraites 6000, .economieSur .famille 4000]
    debut := 1 },
  { id := "RE-04", titre := "100 000 postes de fonctionnaires supprimés par départs volontaires et non-remplacements"
    source := "G. Attal, Le Parisien, 2 juillet 2026 (via MoneyVox) : Éducation, Armées, Justice et Intérieur préservés ; conversion : 62 500 € par poste → 6,25 Md€/an en régime de croisière"
    leviers := [.economieSur .fonctionnement 6250] },
  { id := "RE-05", titre := "Taxe sur les rachats d'actions"
    source := "Programme de juin 2024 repris en 2026 (Europe 1, Ifrap) : ≈ 300 M€/an"
    leviers := [.prelevementSur .impotSocietes 300] }
]

def programme : Programme where
  id := "Renaissance"
  nom := "Renaissance — Gabriel Attal 2027"
  description := "Transcription partielle et non officielle : « droit au brut » (−40 Md€ de cotisations), année blanche 2028 sur les prestations, 100 000 postes de fonctionnaires, taxe sur les rachats d'actions, objectif de 100 000 emplois par la réforme du chômage. Retraite universelle par points, quotas d'immigration : sans montant publié. Objectif annoncé : 120 à 150 Md€ d'économies et déficit sous 3 % avant 2032."
  mainteneurs := ["@orientationd"]
  source := "attalpresident.fr/programme et presse (RMC 6 octobre 2026, Le Parisien 23 mai 2026, CNews 30 avril 2026), consultés le 22 octobre 2026"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.Renaissance
