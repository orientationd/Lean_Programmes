import Modele

/-!
# Axe énergie et transports : prix du pétrole, électrification, air

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
  "INSEE, Note de conjoncture décembre 2025 : Brent figé à 63 $ au premier semestre 2026",
  "Électrification : ≈ 350 000 voitures électriques neuves par an (PFA, immatriculations 2025, ordre de grandeur) ; bornes : ≈ 30 000 points publics ouverts par an (Avere-France, baromètre 2025)",
  "Décès évités : 40 000 décès/an attribuables aux PM2,5 (Santé publique France, 2021) ; le trafic routier pèse ≈ 15 % des PM2,5 primaires (Citepa), dont la moitié à l'échappement ; rapporté à 39 millions de voitures : ≈ 90 décès/an par million de véhicules remplacés (hypothèse de calcul, à affiner)",
  "Infrastructure : 1 point de recharge public pour 10 véhicules électriques (recommandation AFIR / objectif français de 400 000 points, hypothèse)",
  "Gain commercial par véhicule remplacé : 770 L × valeur à l'import du carburant (0,45 / 0,56 / 0,78 €/L selon le Brent) − 1 870 kWh × 60 €/MWh d'électricité non exportée (sous-modèle automobile)",
  "Facture énergétique importée : ≈ 60 Md€ en 2024 (Douanes, Le chiffre du commerce extérieur), supposée proportionnelle au prix du Brent"]

def bas : Energie where
  id := "petrole-bas"
  description := "Brent à 50 $"
  prixBrentDollars := 50
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  electrificationTendancielleMilliers := 350
  bornesTendanciellesMilliers := 30
  decesEvitesParMillionVehicules := 90
  vehiculesParBorne := 10
  gainCommercialParVehiculeEuros := 238
  factureEnergetiqueMeur := 60000
  sources := sources

def central : Energie where
  id := "petrole-central"
  description := "Brent à 63 $"
  prixBrentDollars := 63
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  electrificationTendancielleMilliers := 350
  bornesTendanciellesMilliers := 30
  decesEvitesParMillionVehicules := 90
  vehiculesParBorne := 10
  gainCommercialParVehiculeEuros := 319
  factureEnergetiqueMeur := 60000
  sources := sources

def haut : Energie where
  id := "petrole-haut"
  description := "Brent à 100 $ (choc)"
  prixBrentDollars := 100
  prixReferenceDollars := 63
  effetPibPar10DollarsPb := -25
  electrificationTendancielleMilliers := 350
  bornesTendanciellesMilliers := 30
  decesEvitesParMillionVehicules := 90
  vehiculesParBorne := 10
  gainCommercialParVehiculeEuros := 488
  factureEnergetiqueMeur := 60000
  sources := sources

def toutes : List Energie := [bas, central, haut]

end Hypotheses.Energie
