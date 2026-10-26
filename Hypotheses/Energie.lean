import Modele
import Hypotheses.Electricite

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

CO₂ : une voiture thermique du parc émet 156 g CO₂e/km (SDES, 2023) sur
11 600 km/an (SDES, 2026), soit 1,81 t/an ; une électrique consomme
20,6 kWh/100 km pertes de recharge comprises (ICCT, 2021), soit 2 390 kWh
à 46,1 g/kWh (ADEME, mix moyen 2025) : 0,11 t/an. `co2EviteParVehiculeKg`
= 1 700 kg par an (fabrication exclue). Seules les voitures électriques
ajoutées par les mesures comptent : celles des ventes tendancielles sont
déjà dans la baisse tendancielle des émissions.

Particules selon la vignette Crit'Air (`pmRelatifCritAirPm`, pm de la
moyenne du parc thermique) : limites d'émission des normes Euro (diesel
Euro 2 : 80 mg/km, Euro 3 : 50, Euro 4 : 25, Euro 5-6 : 4,5 ; essence
Euro 5-6 : 4,5 ; Crit'Air 3 supposée pour moitié diesel Euro 4 et pour
moitié essence Euro 2-3, ≈ 3 mg/km, soit 14) pondérées par le parc au
1er janvier 2026 (SDES : Crit'Air 1 38,0 %, 2 34,2 %, 3 16,6 %, 4 4,6 %,
5 et non classées 3,0 %, électriques 3,5 %) : moyenne 10,7 mg/km. Facteurs :
Crit'Air 1 et 2 0,42, Crit'Air 3 1,31, Crit'Air 4 4,69, Crit'Air 5 7,5.
Les limites d'homologation servent d'indicateur relatif ; les vieilles
voitures roulent moins que la moyenne, ce qui réduit l'effet (non modélisé).

## Rénovation énergétique des logements (sous-modèle `Renovation`)

* Volume et aide moyenne : budget 2026 de 3,5 Md€ pour au moins 120 000
  rénovations d'ampleur et 150 000 gestes (réponse ministérielle à la
  question n° 9948, JO du 17 mars 2026) : 270 000 rénovations, 13 000 €
  d'aide en moyenne (2025 : 307 731 logements, 3,81 Md€, bilan de l'Anah
  du 20 février 2026). Les dépôts de dossiers d'ampleur ont été divisés par
  quatre au premier semestre 2026 après la baisse des plafonds (AFP,
  27 juillet 2026).
* Part rurale : 47,7 % des logements aidés par l'Anah en 2021 étaient en
  zone rurale (bassins de vie ; réponse à la question écrite Sénat
  n° 00291, 2022) : `partRuralePm` = 480. Aucune donnée plus récente.
* Travaux : 59 474 € en moyenne par rénovation d'ampleur (Anah, bilan
  2025) et 12 100 € par geste (ONRE) : 33 000 € pour le mélange 2026. Les
  rénovations suscitées sont des travaux adressés à la construction (aide
  et part des ménages) ; le bonus versé aux rénovations qui auraient eu
  lieu est un transfert aux ménages.
* Effet d'aubaine : aucune estimation propre à MaPrimeRénov' ; ≈ 80 % de
  bénéficiaires non additionnels pour le crédit d'impôt CITE (CAE, Focus
  n° 107, juin 2024), aubaine supposée nulle par France Stratégie (2024),
  qui juge lui-même l'hypothèse irréaliste. `aubainePm` = 500 (hypothèse
  intermédiaire, aide mieux ciblée que le CITE). Avec une demande
  linéaire en l'aide, une hausse de 1 % de l'aide suscite 0,5 % de
  rénovations en plus.
* Économies : 17,1 MWh/an conventionnels par rénovation d'ampleur et
  5,9 MWh/an par geste (ONRE, 2026), soit 10,9 MWh/an pour le mélange
  2026 ; les économies réelles valent 42 % des conventionnelles pour
  l'isolation (INSEE-SDES, document de travail 2025-16) et la moitié pour
  les certificats d'économies d'énergie (Wald et Glachant, 2023) :
  `economieKWhParRenovation` = 5 400.
* Chauffage (INSEE Première n° 2088, janvier 2026, données 2022) : fioul
  8,5 % des résidences principales, 16,7 % en rural ; gaz 35 % ; part du
  gaz en rural non publiée, 20 % supposés (réseau moins dense).
* Facteurs : fioul 324,7 g CO₂e/kWh, gaz 239 g/kWh PCI (Base Carbone
  v23.9) ; accise sur le fioul ≈ 15 €/MWh et sur le gaz 16,66 €/MWh
  (août 2026) ; TVA de 20 % ≈ 18 €/MWh pour un prix TTC de ≈ 110 €/MWh
  (hypothèse) ; valeur importée du fioul 56 €/MWh au prix de référence
  (0,56 €/L, comme le carburant du sous-modèle automobile), du gaz
  35 €/MWh (hypothèse : prix de gros européen moyen).
* Non modélisés : l'électricité économisée (exportable), l'effet de levier
  sur les travaux financés par les ménages (≈ 1 € par € d'aide, CAE) et la
  captation d'une partie de l'aide par les prix (IPP, travaux en cours).

## Élasticités-prix des activités taxées (levier `taxeEnvironnementale`)

Valeurs de long terme, en valeur absolue : recul de l'activité (et de ses
émissions) pour +1 % de coût.
* Vols intérieurs : 0,9 (demande nationale −0,8, courts-courriers ×1,1 :
  InterVISTAS pour l'IATA, 2007 ; −0,4 à −1,1 à court terme pour le trafic
  intérieur français, Sauvant, Notes de synthèse du SES, 2003).
* Poids lourds : 0,5 (véhicules-kilomètres au prix au kilomètre, meilleure
  estimation de long terme de 0,6 dans une fourchette de 0,1 à 0,5, report
  modal compris : Significance et CE Delft pour la Commission européenne,
  2010 ; valeur médiane retenue).
* Carburants routiers : 0,6 (consommation de carburant au prix, long terme :
  Goodwin, Dargay et Hanly, Transport Reviews, 2004).
* Chauffage fossile : 0,3 (hypothèse ; non utilisée par les programmes à ce
  jour).

Outre-mer (zones non interconnectées) : l'électricité y coûte bien plus à
produire que le tarif péréqué ne rapporte ; le surcoût est compensé par les
charges de service public de l'énergie (3,18 Md€ en 2025, 3,27 Md€ en
2026 ; CRE, délibération 2026-149), financées depuis août 2025 par une
part de l'accise sur l'électricité. Coût de production en 2022 : Mayotte
445 €/MWh, Guadeloupe 351, Martinique 323, Guyane 274, Réunion 267 (CRE,
délibération 2024-65) ; ≈ 1 000 €/MWh dans les communes de l'intérieur de
la Guyane (CRE, délibération 2019-006). À Mayotte, les recettes couvrent
≈ 20 % du coût (43,7 M€ sur 219,5 M€ prévus en 2026, CRE 2025-180) :
`surcoutPerequationZniEurosMWh` = 360 (80 % de 445, base Mayotte ;
prudent pour les sites isolés de Guyane). Consommation d'un foyer
nouvellement raccordé : `consommationFoyerZniKWh` = 2 500 kWh/an
(hypothèse : moitié des 5 100 kWh d'un foyer guadeloupéen, OREC 2024, pour
des ménages modestes jusque-là sans électricité).

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
  "CO₂ évité par voiture : 156 g/km (SDES, « Quels freins à la baisse des émissions du parc automobile », 3 juillet 2023) × 11 600 km (SDES, 40 millions de voitures au 1er janvier 2026) − 2 390 kWh (ICCT, Bieker 2021) × 46,1 g/kWh (ADEME, Base Empreinte, mix moyen 2025)",
  "Particules : limites des normes Euro (directives et règlements UE, d'après Wikipédia « European emission standards ») ; vignettes Crit'Air (arrêté du 21 juin 2016) ; parc par vignette au 1er janvier 2026 (SDES, 10 juillet 2026)",
  "Décès évités : 40 000 décès/an attribuables aux PM2,5 (Santé publique France, 2021) ; le trafic routier pèse ≈ 15 % des PM2,5 primaires (Citepa), dont la moitié à l'échappement ; rapporté à 39 millions de voitures : ≈ 90 décès/an par million de véhicules remplacés (hypothèse de calcul, à affiner)",
  "Infrastructure : 1 point de recharge public pour 10 véhicules électriques (recommandation AFIR / objectif français de 400 000 points, hypothèse)",
  "Gain commercial par véhicule remplacé : 770 L × valeur à l'import du carburant (0,45 / 0,56 / 0,78 €/L selon le Brent) − 1 870 kWh × 60 €/MWh d'électricité non exportée (sous-modèle automobile)",
  "Facture énergétique importée : ≈ 60 Md€ en 2024 (Douanes, Le chiffre du commerce extérieur), supposée proportionnelle au prix du Brent",
  "Rénovation : Anah (chiffres clés 2024, bilan 2025) ; réponse ministérielle n° 9948 (JO du 17 mars 2026) ; ONRE (2026) ; INSEE Première n° 2088 (janvier 2026) ; INSEE-SDES DT 2025-16 ; CAE Focus n° 107 (juin 2024) ; Base Carbone v23.9",
  "Outre-mer : CRE, délibérations 2026-149, 2025-180, 2024-65, 2019-006 ; OREC Guadeloupe, bilan de l'énergie 2024"]

/-- Particules à l'échappement par vignette Crit'Air (indice 0 : moyenne du
parc thermique ; 1 à 5 : Crit'Air 1 à 5), pm de la moyenne. -/
def pmRelatifCritAir : List Int := [1000, 420, 420, 1310, 4690, 7500]

/-- Rénovation énergétique aidée (MaPrimeRénov'), commune aux trois
variantes ; la valeur importée du fioul suit le prix du Brent dans la
projection. Sources et calculs : docstring du module. -/
def renovation : Renovation where
  renovationsAideesParAn := 270000
  partRuralePm := 480
  aideMoyenneEuros := 13000
  aubainePm := 500
  economieKWhParRenovation := 5400
  coutTravauxMoyenEuros := 33000
  partFioulNationalPm := 85
  partGazNationalPm := 350
  partFioulRuralPm := 167
  partGazRuralPm := 200
  co2FioulKgMWh := 325
  co2GazKgMWh := 239
  importFioulEurosMWh := 56
  importGazEurosMWh := 35
  accisesFioulEurosMWh := 15
  tvaFioulEurosMWh := 18
  accisesGazEurosMWh := 17
  tvaGazEurosMWh := 18

/-- Élasticités-prix de long terme (valeur absolue, pm) : voir le docstring
du module. -/
def elasticitesPrix : ElasticitesPrix :=
  { aerienInterieur := 900, poidsLourds := 500, carburantsRoutiers := 600, chauffageFossile := 300 }

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
  co2EviteParVehiculeKg := 1700
  pmRelatifCritAirPm := pmRelatifCritAir
  renovation := renovation
  elasticitesPrix := elasticitesPrix
  consommationFoyerZniKWh := 2500
  surcoutPerequationZniEurosMWh := 360
  decesEvitesParMillionVehicules := 90
  electricite := Hypotheses.Electricite.electriciteFrance
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
  co2EviteParVehiculeKg := 1700
  pmRelatifCritAirPm := pmRelatifCritAir
  renovation := renovation
  elasticitesPrix := elasticitesPrix
  consommationFoyerZniKWh := 2500
  surcoutPerequationZniEurosMWh := 360
  decesEvitesParMillionVehicules := 90
  electricite := Hypotheses.Electricite.electriciteFrance
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
  co2EviteParVehiculeKg := 1700
  pmRelatifCritAirPm := pmRelatifCritAir
  renovation := renovation
  elasticitesPrix := elasticitesPrix
  consommationFoyerZniKWh := 2500
  surcoutPerequationZniEurosMWh := 360
  decesEvitesParMillionVehicules := 90
  electricite := Hypotheses.Electricite.electriciteFrance
  vehiculesParBorne := 10
  gainCommercialParVehiculeEuros := 488
  factureEnergetiqueMeur := 60000
  sources := sources

def toutes : List Energie := [bas, central, haut]

end Hypotheses.Energie
