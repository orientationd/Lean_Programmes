import Modele

/-!
# Axe énergie : prix du pétrole

Prix du Brent appliqué comme un choc de niveau sur le PIB de départ, pour le
tendanciel comme pour chaque programme : −0,25 % de PIB par tranche de
+10 $ au-dessus du prix de référence de 63 $.

* Élasticité : +10 $ par baril réduit le PIB de 0,2 à 0,3 % à long terme
  (INSEE, Note de conjoncture, mars 2019, éclairage « pétrole » : modèles
  Mésange, SVAR, NiGEM) ; valeur médiane retenue.
* Référence : 63 $ par baril, hypothèse de la Note de conjoncture de
  l'INSEE de décembre 2025 pour le premier semestre 2026.

Non modélisé : effet sur l'inflation, sur les volumes et donc les recettes
de TICPE, sur la balance commerciale (voir le sous-modèle automobile).
-/

namespace Hypotheses.Energie
open Modele

def sources : List String := [
  "INSEE, Note de conjoncture mars 2019, éclairage pétrole : +10 $ → −0,2 à −0,3 % de PIB",
  "INSEE, Note de conjoncture décembre 2025 : Brent figé à 63 $ au premier semestre 2026"]

def bas : Energie where
  id := "petrole-bas"
  description := "Brent à 50 $"
  prixBrentDollars := 50
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  sources := sources

def central : Energie where
  id := "petrole-central"
  description := "Brent à 63 $"
  prixBrentDollars := 63
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  sources := sources

def haut : Energie where
  id := "petrole-haut"
  description := "Brent à 100 $ (choc)"
  prixBrentDollars := 100
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  sources := sources

def toutes : List Energie := [bas, central, haut]

end Hypotheses.Energie
