import Modele

/-!
# Moteurs du dépôt

Deux lectures des mêmes mesures (plus le moteur contribué « Exemple
équilibre », entre les deux) :

* **demande** (moteur standard) : les effets de demande sont permanents et
  symétriques ; un prélèvement pèse moitié moins sur l'activité qu'une
  dépense ; aucun effet des prélèvements sur la croissance potentielle.
* **offre** : une économie de dépense ne retire que la moitié de l'effet
  de demande d'une dépense équivalente ; chaque point de prélèvements
  obligatoires au-dessus de son niveau de départ retire 0,1 point de
  croissance par an (et en ajoute autant en dessous). Ordres de grandeur
  d'une lecture « offre » de la littérature (élasticité de la croissance au
  taux de PO : hypothèse, à sourcer). S'y ajoute le canal du capital
  (`canalCapitalPm`) : l'investissement public des mesures accroît le stock
  de capital public, donc le PIB potentiel (élasticité de 0,12) ; le taux
  d'IS des mesures change le coût du capital des entreprises, dont le stock
  rejoint progressivement son nouveau niveau (+0,10 % de PIB à long terme par
  point de taux en moins). Pour l'IS, ce canal remplace l'effet générique
  des prélèvements. Paramètres et sources : `Hypotheses/Economie.lean`.
  Le moteur de demande n'a pas ce canal.

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
  description := "Économies à demi-multiplicateur ; +1 point de prélèvements obligatoires retire 0,1 point de croissance par an ; canal du capital (investissement public, IS) sur le PIB potentiel"
  multiplicateurEconomiesPm := 500
  multiplicateurPrelevementsPm := 500
  elasticiteCroissancePoPm := 100
  canalCapitalPm := 1000

def tous : List Moteur := [demande, offre]

/-- Moteur de référence des engagements qui n'en précisent pas. -/
def standard : Moteur := demande

theorem tous_valides : ∀ M ∈ tous, M.Valide := by decide +kernel

end Hypotheses.Moteurs
