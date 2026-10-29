import Modele

/-!
# Moteurs du dépôt

Deux lectures des mêmes mesures :

* **demande** (moteur standard) : les effets de demande sont permanents et
  symétriques ; un prélèvement pèse moitié moins sur l'activité qu'une
  dépense ; aucun effet des prélèvements sur la croissance potentielle.
* **offre** : une économie de dépense ne retire que la moitié de l'effet
  de demande d'une dépense équivalente ; chaque point de prélèvements
  obligatoires au-dessus de son niveau de départ retire 0,1 point de
  croissance par an (et en ajoute autant en dessous). Ordres de grandeur
  d'une lecture « offre » de la littérature (élasticité de la croissance au
  taux de PO : hypothèse, à sourcer).

Tous les programmes sont évalués sous les deux ; les engagements précisent
leur moteur.
-/

namespace Hypotheses.Moteurs
open Modele

def demande : Moteur where
  id := "demande"
  nom := "Demande"
  description := "Effets de demande permanents et symétriques, pas d'effet d'offre des prélèvements"
  multiplicateurEconomiesPm := 1000
  multiplicateurPrelevementsPm := 500
  elasticiteCroissancePoPm := 0

def offre : Moteur where
  id := "offre"
  nom := "Offre"
  description := "Économies à demi-multiplicateur ; +1 point de prélèvements obligatoires retire 0,1 point de croissance par an"
  multiplicateurEconomiesPm := 500
  multiplicateurPrelevementsPm := 500
  elasticiteCroissancePoPm := 100
  canalCapitalPm := 1000

def tous : List Moteur := [demande, offre]

/-- Moteur de référence des engagements qui n'en précisent pas. -/
def standard : Moteur := demande

theorem tous_valides : ∀ M ∈ tous, M.Valide := by decide +kernel

end Hypotheses.Moteurs
