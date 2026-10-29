import Modele

/-!
# Moteur contribué « ExempleEquilibre » (exemple, modèle de dossier)

Lecture intermédiaire entre les moteurs « demande » et « offre » du socle :
les économies de dépense gardent les trois quarts de leur effet de demande,
et chaque point de prélèvements obligatoires au-dessus du niveau de départ
retire 0,05 point de croissance par an.

Copier ce dossier pour proposer son propre moteur ; expliquer ici les choix
et leurs sources. Les paramètres disponibles sont ceux de
`Modele.Moteur` ; en demander d'autres relève d'une issue « modèle commun ».
-/

namespace Moteurs.ExempleEquilibre

def moteur : Modele.Moteur where
  id := "ExempleEquilibre"
  nom := "Exemple équilibre"
  description := "Économies aux trois quarts du multiplicateur ; +1 point de prélèvements obligatoires retire 0,05 point de croissance par an (exemple)"
  multiplicateurEconomiesPm := 750
  multiplicateurPrelevementsPm := 500
  elasticiteCroissancePoPm := 50
  canalCapitalPm := 500

end Moteurs.ExempleEquilibre
