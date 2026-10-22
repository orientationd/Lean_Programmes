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
    leviers := [.annonceEmplois 100000] }
]

def programme : Programme where
  id := "Renaissance"
  nom := "Renaissance — Gabriel Attal 2027"
  description := "Transcription partielle et non officielle : « droit au brut » (−40 Md€ de cotisations). Retraite universelle par points, année blanche sur les dépenses sociales, réforme de l'assurance chômage, quotas d'immigration : sans montant publié."
  mainteneurs := ["@orientationd"]
  source := "attalpresident.fr/programme et presse (RMC 6 octobre 2026, Le Parisien 23 mai 2026, CNews 30 avril 2026), consultés le 22 octobre 2026"
  mesures := mesures

end Programmes.Renaissance
