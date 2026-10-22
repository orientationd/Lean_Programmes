import Modele

/-!
# Axe économique

`actifsParMoisAgeLegal` = 30 000 personnes : la réforme de 2023 (+2 ans)
ajoute 737 000 actifs en 2030 selon l'INSEE (actualisation des projections
de population active, 2023), soit ≈ 30 000 par mois.
`economieParMoisRetraite` = 650 M€ : 13,6 à 17,7 Md€ d'économies en 2030
pour 24 mois selon les chiffres gouvernementaux de la réforme de 2023 (via
IFRAP), soit 570 à 740 M€ par mois ; valeur centrale retenue (auparavant
1 500 M€, valeur provisoire surestimée).
`elasticiteChomageSmicPm` reste une valeur jouet, à sourcer.
`elasticitePibHeuresPm` = 650 : part du travail dans la valeur ajoutée
(INSEE, comptes nationaux, ≈ 65 %), prise comme élasticité du PIB au
volume d'heures travaillées à capital donné. `tauxISPb` = 2 500 : taux
normal de l'IS de 25 % depuis 2022.
`coutParPbPlus65` = 185 M€ : 410 Md€ de retraites pour 22,2 % de plus de
65 ans, soit 185 M€ par point de base de part ; `coutSanteParPbPlus65`
= 20 M€ : les plus de 65 ans consomment environ deux fois la dépense de
santé moyenne (DREES, comptes de la santé), soit 247 Md€ × (2 − 1) /
(1 + 0,222) × 10⁻⁴ ≈ 20 M€ par point de base.
`contenuImportDemandePm` = 300 : contenu en importations de la demande
intérieure ≈ 30 % (INSEE, tableaux entrées-sorties).
`robotisationTendanciellePb` = 20 : gains de productivité de 0,2 %/an sur
les dépenses de fonctionnement, d'affaires économiques et de santé
(hypothèse ; la productivité des services publics est mal mesurée).
`tauxMarginalPb` : taux auquel la dette nouvelle et refinancée est émise
(OAT 10 ans autour de 3,3 % fin 2025, hypothèse) ; `deriveTauxPb` : le
taux apparent (1,87 % en 2025, INSEE) y converge d'environ 20 pb par an,
rythme de renouvellement du stock (maturité moyenne ≈ 8,5 ans, AFT).

C'est l'axe le plus disputé : multiplicateur, élasticités et fuite fiscale
déterminent l'essentiel des écarts entre programmes. D'où trois variantes
dès le départ, plutôt qu'une valeur « officielle ».
-/

namespace Hypotheses.Eco
open Modele

def centrale : Economie where
  id := "eco-centrale"
  description := "Croissance nominale 3 %, paramètres médians"
  croissancePb := 300
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 800
  fuiteFiscalePm := 200
  elasticiteChomageSmicPm := 100
  economieParMoisRetraite := 650
  tauxMarginalPb := 330
  deriveTauxPb := 20
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 20
  baisseEmissionsPm := 30
  sources := ["À COMPLÉTER"]

def croissanceBasse : Economie where
  id := "eco-basse"
  description := "Croissance nominale 2 %, multiplicateur faible, fuite fiscale forte"
  croissancePb := 200
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 500
  fuiteFiscalePm := 350
  elasticiteChomageSmicPm := 150
  economieParMoisRetraite := 650
  tauxMarginalPb := 380
  deriveTauxPb := 25
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 20
  baisseEmissionsPm := 20
  sources := ["À COMPLÉTER"]

def croissanceHaute : Economie where
  id := "eco-haute"
  description := "Croissance nominale 4 %, multiplicateur élevé, fuite fiscale faible"
  croissancePb := 400
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 1100
  fuiteFiscalePm := 100
  elasticiteChomageSmicPm := 50
  economieParMoisRetraite := 650
  tauxMarginalPb := 300
  deriveTauxPb := 20
  actifsParMoisAgeLegal := 30000
  elasticitePibHeuresPm := 650
  tauxISPb := 2500
  coutParPbPlus65 := 185
  coutSanteParPbPlus65 := 20
  contenuImportDemandePm := 300
  robotisationTendanciellePb := 20
  baisseEmissionsPm := 40
  sources := ["À COMPLÉTER"]

def toutes : List Economie := [centrale, croissanceBasse, croissanceHaute]

end Hypotheses.Eco
