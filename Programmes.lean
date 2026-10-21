import Programmes.ExempleRelance.Programme
import Programmes.ExempleConsolidation.Programme
import Programmes.texte_orientation_d.Programme
import Programmes.LFI.Programme

/-!
# Registre des programmes

Ajouter un programme :
1. copier un dossier d'exemple dans `Programmes/<NomDuProgramme>/` et y
   lister son compte GitHub dans `PROPRIETAIRES` ;
2. ajouter son `import` ci-dessus ;
3. l'ajouter à `tous` ci-dessous.

Ses engagements sont alors vérifiés automatiquement par `Engagements.lean`.

`scripts/verifier_registre.py` (lancé en CI) échoue si un dossier de
`Programmes/` n'est pas enregistré ici.
-/

namespace Programmes

def tous : List Modele.Programme := [
  ExempleRelance.programme,
  ExempleConsolidation.programme,
  texte_orientation_d.programme,
  LFI.programme
]

end Programmes
