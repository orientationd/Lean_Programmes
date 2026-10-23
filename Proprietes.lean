import Proprietes.Finances
import Proprietes.Emploi
import Proprietes.Climat
import Proprietes.Europe

/-!
# Registre des propriétés partagées

Toute propriété listée dans `toutes` est évaluée pour chaque programme sous
chaque scénario. Ajouter une propriété : un fichier (ou un ajout dans un
fichier thématique) + une ligne ici.
-/

namespace Proprietes

def toutes : List Modele.Propriete :=
  [deficit, dette, chomage, emissions, deficit2035, equilibre2035, dette2035, air, bornes2035, emploisAnnonces,
   balanceCourante, accidentsTravail] ++ europeennes

end Proprietes
