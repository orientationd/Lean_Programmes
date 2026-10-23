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

## Électrification du parc (règlement (UE) 2023/851)

Le règlement impose 0 g CO₂/km aux voitures neuves vendues à partir de 2035.
Sa révision n'est pas adoptée : la Commission a proposé 90 % en décembre
2025, le compromis en discussion au Parlement européen retient 87,5 %
(vote en plénière attendu en décembre 2026, puis Conseil) ; le modèle
applique le droit en vigueur. Ventes de voitures électriques neuves : 331 200 en
2025 (19,9 % de 1 665 000 immatriculations, PFA / AAA Data), portées
linéairement à la totalité des ventes neuves en 2035 : +133 000 par an. Les
mesures (primes) s'ajoutent dans la limite des ventes neuves.

Chaque voiture thermique remplacée retire de l'assiette fiscale (É. Pichet,
Kedge, Connaissance des Énergies, 5 septembre 2026 : 16 Md€ d'accises et 8 Md€ de TVA sur les carburants des 38,6 M de
voitures thermiques, moins ≈ 112 € de taxes sur l'électricité consommée) :
354 € d'accises et 155 € de TVA par an. La projection retire ces montants
chaque année pour les nouvelles électriques ; ils suivent ensuite le PIB
nominal comme le reste de l'assiette.

Bornes : l'ouverture de points publics (30 000 en 2025) suit les ventes
tendancielles d'électriques. Puissance moyenne d'un point : 16,6 kW, calée
sur la référence (1,6 M de voitures électriques, 175 000 points) pour
retrouver les 140 % de l'objectif AFIR mesurés fin mars 2026 (Transport &
Environment) ; les hybrides rechargeables (0,8 kW chacun dans l'AFIR) ne
sont pas suivis par le modèle, d'où une puissance moyenne prudente.

Non modélisé : effet du prix du pétrole et de l'ETS2 sur l'inflation et sur
les volumes de carburant (et donc les accises) ; importations de véhicules
électriques (le sous-modèle automobile les traite pour le remplacement
public).
-/

namespace Hypotheses.Energie
open Modele

def sources : List String := [
  "INSEE, Note de conjoncture mars 2019, éclairage pétrole : +10 $ → −0,2 à −0,3 % de PIB",
  "INSEE, Note de conjoncture décembre 2025 : Brent figé à 63 $ au premier semestre 2026",
  "Électrification : 331 200 voitures électriques neuves en 2025, 19,9 % de 1 665 000 immatriculations (PFA, AAA Data) ; 100 % des ventes neuves en 2035 (règlement (UE) 2023/851) ; bornes : ≈ 30 000 points publics ouverts par an (Avere-France, 200 045 points au 31 juillet 2026)",
  "Érosion fiscale par voiture électrique : 354 € d'accises et 155 € de TVA par an (É. Pichet, « La voiture électrique peut-elle faire disparaître 20 milliards de recettes fiscales ? », Connaissance des Énergies, 5 septembre 2026 : 16 et 8 Md€ en 2024 sur 38,6 M de voitures thermiques, 4 à 5 Md€ de taxes sur l'électricité pour un parc entièrement électrique)",
  "AFIR (règlement (UE) 2023/1804, art. 3) : 1,3 kW par voiture électrique à batterie ; la France à 140 % de l'objectif fin mars 2026 (Transport & Environment, cité par Auto Infos, 23 juillet 2026)",
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
  electrificationTendancielleMilliers := 331
  hausseElectrificationMilliers := 133
  ventesNeuvesMilliers := 1665
  bornesTendanciellesMilliers := 30
  accisesParVehiculeEuros := 354
  tvaParVehiculeEuros := 155
  puissanceParBorneW := 16600
  puissanceAfirParVehiculeW := 1300
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
  electrificationTendancielleMilliers := 331
  hausseElectrificationMilliers := 133
  ventesNeuvesMilliers := 1665
  bornesTendanciellesMilliers := 30
  accisesParVehiculeEuros := 354
  tvaParVehiculeEuros := 155
  puissanceParBorneW := 16600
  puissanceAfirParVehiculeW := 1300
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
  electrificationTendancielleMilliers := 331
  hausseElectrificationMilliers := 133
  ventesNeuvesMilliers := 1665
  bornesTendanciellesMilliers := 30
  accisesParVehiculeEuros := 354
  tvaParVehiculeEuros := 155
  puissanceParBorneW := 16600
  puissanceAfirParVehiculeW := 1300
  decesEvitesParMillionVehicules := 90
  vehiculesParBorne := 10
  gainCommercialParVehiculeEuros := 488
  factureEnergetiqueMeur := 60000
  sources := sources

def toutes : List Energie := [bas, central, haut]

end Hypotheses.Energie
