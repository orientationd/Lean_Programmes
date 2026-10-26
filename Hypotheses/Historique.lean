import Modele

/-!
# Comptes publics observés, 2017-2025 (rétro-test)

Données d'entrée du rétro-test (`Modele/Retro.lean`). Comptes nationaux de
l'INSEE en base 2020 (comptes publiés le 29 mai 2026), sauf mention
contraire. Montants en M€ courants, taux en pb.

**Sources.**

* PIB, croissance en volume, déflateur (calculé : (1 + croissance en
  valeur) / (1 + croissance en volume) − 1, à partir des PIB annuels en
  valeur et en volume), inflation (IPC, moyenne annuelle) et chômage BIT
  (moyenne annuelle, France hors Mayotte) : INSEE (Insee Première n° 2105 et
  2106, mai 2026 ; « L'essentiel sur l'inflation » ; Insee Références,
  juillet 2026) ; croissances en valeur recoupées avec le Trésor-Éco n° 403
  (septembre 2026).
* Recettes, dépenses, solde et dette des administrations publiques : INSEE
  (Insee Première n° 2106, tableau de la figure 2 et « Principaux
  agrégats » 2018-2025 ; révision des ratios en base 2020, mars 2024 ;
  compléments à l'IR n° 74, mars 2024 ; IR n° 78, mars 2026). 2017 et 2018 :
  montants dérivés des ratios publiés (± 1,2 Md€ d'arrondi) ; dépenses 2018
  ajustées pour retrouver le solde publié (−2,3 % du PIB).
* Prélèvements obligatoires (au sens de l'INSEE, nets des crédits d'impôt) :
  taux publiés × PIB (INSEE, « Finances publiques en 2025 ») ; 2017 : taux en
  base 2014 (45,2 %, Tableaux de l'économie française 2020) × PIB en base
  2020 (raccord approché).
* Mesures nouvelles de prélèvements obligatoires (nettes, au sens des
  prélèvements nets des crédits d'impôt) : INSEE (Insee Première n° 1698,
  1801, 1859, 1903, 1949, 1998, 2054, 2106 ; Économie française 2019, fiche
  12 pour 2018). Elles bouclent avec l'évolution spontanée publiée par la
  Cour des comptes (rapports sur la situation et les perspectives des
  finances publiques) à quelques milliards près.
* Charge d'intérêts (intérêts versés, hors correction Sifim) : INSEE, base
  2020 pour 2021-2025 ; **base 2014 pour 2017-2020** (IR et Insee Première
  de 2018 à 2021 : l'écart entre bases, constaté en 2021 et 2022, est
  d'environ 0,5 Md€).
* Indexation du capital des titres indexés de l'État : provision pour
  indexation en droits constatés (comptabilité générale, reprise par la
  comptabilité nationale), 2020-2025 ; 2017-2019 : provision budgétaire du
  programme 117 (rapports annuels de performances « Engagements financiers
  de l'État »). Encours de titres indexés et durée de vie moyenne de la
  dette négociable : Agence France Trésor (bulletins mensuels, rapports
  annuels) ; encours 2017 et 2018 non publiés dans les sources consultées :
  interpolés entre 2016 (200 Md€) et 2019 (226 Md€).
* Inflation des titres indexés : moyenne annuelle de l'IPCH de la zone euro
  (Eurostat) et de l'IPC français (INSEE), pondérée par les encours d'OAT€i
  (236 Md€) et d'OATi (66 Md€) au 31 août 2025 (78 % et 22 %). Les titres
  sont indexés sur l'indice de référence de trois mois auparavant : la
  moyenne annuelle n'en est qu'une approximation (voir le rétro-test).
* Taux de l'OAT à 10 ans, moyenne annuelle : OCDE (FRED, série
  IRLTLT01FRA156N), Agence France Trésor. Taux moyen à l'émission des BTF,
  encours de la dette négociable de l'État et des BTF en fin d'année :
  Agence France Trésor (bulletins mensuels n° 316, 328, 388, 399, 435 ;
  rapports annuels ; rapports annuels de performances « Engagements
  financiers de l'État ») ; taux des BTF 2020 non publié dans les sources
  consultées : −0,55 % retenu (taux des années voisines) ; encours de BTF
  2017 et 2018 interpolés entre 2016 (134 Md€) et 2019 (107 Md€). La dette
  à court terme des organismes de sécurité sociale (titres négociables de
  l'Urssaf) n'est pas comptée, faute d'encours publié dans les sources
  consultées.
* Croissance potentielle : estimation officielle de l'époque (loi de
  programmation 2018-2022 pour 2017-2019 : 1,25 % ; rapport économique,
  social et financier du PLF 2022 pour 2020 et 2021 : 0 % et 0,8 % ; loi de
  programmation 2023-2027 pour 2022-2024 : 1,35 % ; PLF 2026 pour 2025 :
  1,2 %).
* Dette 2017 (base 2020) : non publiée dans les sources consultées ;
  2 258,7 Md€ en base 2014 (variation de 2018 publiée en mai 2019), plus
  l'écart entre bases constaté en 2018 (+ 7 Md€) : 2 265,8 Md€ (raccord
  approché). Elle ne sert qu'à la dette de début de l'année 2018.

Valeurs dérivées ou raccordées : signalées dans le commentaire de la ligne.
-/

namespace Hypotheses
open Modele

def observations : List AnneeObservee := [
  { annee := 2017, pib := 2291700, croissanceVolumePb := 210, deflateurPb := 60,
    croissancePotentiellePb := 125, inflationConsoPb := 100, inflationIndexationPb := 139,
    tauxOat10Pb := 81, tauxCourtPb := -62, chomagePb := 940,
    recettes := 1244400, prelevements := 1035800,      -- dérivés des ratios ; PO : taux base 2014
    depenses := 1322300, interets := 44400, chargeIndexation := 2309,   -- intérêts base 2014 ; provision budgétaire
    dette := 2265800, detteNegociableEtat := 1686000, detteCourtTerme := 125000, titresIndexes := 205000, dureeVieDixiemes := 78,  -- dette raccordée ; encours interpolé
    mesuresNouvellesPO := 3600 },
  { annee := 2018, pib := 2355400, croissanceVolumePb := 160, deflateurPb := 110,
    croissancePotentiellePb := 125, inflationConsoPb := 190, inflationIndexationPb := 182,
    tauxOat10Pb := 78, tauxCourtPb := -60, chomagePb := 910,
    recettes := 1271900, prelevements := 1057600,      -- dérivés des ratios
    depenses := 1326100, interets := 44200, chargeIndexation := 3348,   -- dépenses : recettes + solde publié ; intérêts base 2014
    dette := 2322400, detteNegociableEtat := 1756000, detteCourtTerme := 116000, titresIndexes := 215000, dureeVieDixiemes := 79,  -- dette : 98,6 % × PIB ; encours interpolé
    mesuresNouvellesPO := -9700 },
  { annee := 2019, pib := 2432200, croissanceVolumePb := 200, deflateurPb := 120,
    croissancePotentiellePb := 125, inflationConsoPb := 110, inflationIndexationPb := 118,
    tauxOat10Pb := 13, tauxCourtPb := -58, chomagePb := 850,
    recettes := 1287900, prelevements := 1070200,
    depenses := 1346200, interets := 38800, chargeIndexation := 2764,   -- intérêts base 2014 ; provision budgétaire
    dette := 2386100, detteNegociableEtat := 1823000, detteCourtTerme := 107000, titresIndexes := 226000, dureeVieDixiemes := 82,
    mesuresNouvellesPO := -23600 },
  { annee := 2020, pib := 2318300, croissanceVolumePb := -740, deflateurPb := 300,
    croissancePotentiellePb := 0, inflationConsoPb := 50, inflationIndexationPb := 34,
    tauxOat10Pb := -14, tauxCourtPb := -55, chomagePb := 810,
    recettes := 1223300, prelevements := 1027000,
    depenses := 1430400, interets := 33200, chargeIndexation := -782,   -- intérêts base 2014
    dette := 2663900, detteNegociableEtat := 2001000, detteCourtTerme := 162000, titresIndexes := 220000, dureeVieDixiemes := 82,
    mesuresNouvellesPO := 5100 },
  { annee := 2021, pib := 2508100, croissanceVolumePb := 690, deflateurPb := 120,
    croissancePotentiellePb := 80, inflationConsoPb := 160, inflationIndexationPb := 238,
    tauxOat10Pb := 1, tauxCourtPb := -67, chomagePb := 790,
    recettes := 1326300, prelevements := 1108600,
    depenses := 1491400, interets := 37600, chargeIndexation := 8045,
    dette := 2828800, detteNegociableEtat := 2145000, detteCourtTerme := 155000, titresIndexes := 236000, dureeVieDixiemes := 84,
    mesuresNouvellesPO := -14800 },
  { annee := 2022, pib := 2654000, croissanceVolumePb := 270, deflateurPb := 300,
    croissancePotentiellePb := 135, inflationConsoPb := 520, inflationIndexationPb := 770,
    tauxOat10Pb := 170, tauxCourtPb := 19, chomagePb := 730,
    recettes := 1425000, prelevements := 1194300,
    depenses := 1550700, interets := 52700, chargeIndexation := 22997,
    dette := 2955600, detteNegociableEtat := 2278000, detteCourtTerme := 148000, titresIndexes := 262000, dureeVieDixiemes := 85,
    mesuresNouvellesPO := -7700 },
  { annee := 2023, pib := 2833800, croissanceVolumePb := 160, deflateurPb := 510,
    croissancePotentiellePb := 135, inflationConsoPb := 490, inflationIndexationPb := 529,
    tauxOat10Pb := 299, tauxCourtPb := 333, chomagePb := 740,
    recettes := 1456400, prelevements := 1224200,
    depenses := 1608300, interets := 51000, chargeIndexation := 8491,
    dette := 3103200, detteNegociableEtat := 2430000, detteCourtTerme := 169000, titresIndexes := 271000, dureeVieDixiemes := 85,
    mesuresNouvellesPO := -7100 },
  { annee := 2024, pib := 2935200, croissanceVolumePb := 150, deflateurPb := 200,
    croissancePotentiellePb := 135, inflationConsoPb := 200, inflationIndexationPb := 231,
    tauxOat10Pb := 298, tauxCourtPb := 339, chomagePb := 740,
    recettes := 1503600, prelevements := 1254200,
    depenses := 1672700, interets := 58100, chargeIndexation := 4743,
    dette := 3306100, detteNegociableEtat := 2602000, detteCourtTerme := 201000, titresIndexes := 289000, dureeVieDixiemes := 85,
    mesuresNouvellesPO := 3600 },
  { annee := 2025, pib := 2991100, croissanceVolumePb := 80, deflateurPb := 110,
    croissancePotentiellePb := 120, inflationConsoPb := 90, inflationIndexationPb := 184,
    tauxOat10Pb := 337, tauxCourtPb := 212, chomagePb := 770,
    recettes := 1561700, prelevements := 1305100,
    depenses := 1714200, interets := 64700, chargeIndexation := 5309,
    dette := 3460500, detteNegociableEtat := 2737000, detteCourtTerme := 196000, titresIndexes := 307000, dureeVieDixiemes := 85,
    mesuresNouvellesPO := 23000 } ]

/-- Années de départ du rétro-test sur plusieurs années : 2018 (toute la
période), 2021 (intérêts en base 2020). -/
def departsRetro : List Nat := [2018, 2021]

end Hypotheses
