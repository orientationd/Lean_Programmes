import Modele
import Hypotheses

/-!
# Tests du modèle commun : électricité et sols

Garde-fous sur le sous-modèle électrique (capacités, production,
consommation, modulation) et sur celui des sols (enveloppe du ZAN,
abrogation, imputation des surfaces des mesures). Les fourchettes viennent
des sources des hypothèses (RTE, PPE3, Cerema), pas d'un calage.
-/

namespace Tests.ElectriciteSols
open Modele

def D : Moteur := Hypotheses.Moteurs.demande
def H : Scenario := Hypotheses.central
def E : Electricite := H.energie.electricite

/-- Tendanciel, de 2025 (rang 0) à 2035 (rang 10). -/
def tend : List Etat := trajectoire D H 10 (etatDepart H)
def en (k : Nat) : Etat := tend.getD k default

def mesure (ls : List Levier) : Programme :=
  { id := "M", nom := "M", description := "", mainteneurs := [], source := "",
    mesures := [{ id := "M-1", titre := "", source := "", leviers := ls }] }

/-- Première année projetée avec les leviers `ls` appliqués au départ. -/
def an1 (ls : List Levier) : Etat := anneeSuivante D H ((mesure ls).etatInitial D H)

/-! ## Électricité -/

/-- La situation de départ reprend le bilan électrique 2025 de RTE. -/
theorem depart_rte :
    (en 0).productionGwh.total = 547500 ∧ (en 0).consommationGwh = 446100 := by decide +kernel

/-- Aux facteurs de charge de référence, la production de la première
année reste à moins de 3 % de celle de 2025 (les facteurs de charge sont
des moyennes observées, pas une année particulière). -/
theorem production_premiere_annee :
    let p := (en 1).productionGwh.total
    547500 * 97 / 100 ≤ p ∧ p ≤ 547500 * 103 / 100 := by decide +kernel

/-- Les installations tendancielles atteignent les objectifs 2030 de la
PPE3 (solaire 48 GW, éolien terrestre 31 GW, en mer 3,6 GW) et le milieu
des fourchettes 2035. -/
theorem capacites_ppe3 :
    (en 5).capacitesMw.solaire = 48000 ∧ (en 5).capacitesMw.eolienTerrestre = 31000 ∧
    (en 5).capacitesMw.eolienMer = 3600 ∧
    (en 10).capacitesMw.solaire = 67500 ∧ (en 10).capacitesMw.eolienTerrestre = 37500 ∧
    (en 10).capacitesMw.eolienMer = 15000 := by decide +kernel

/-- La consommation tendancielle de 2030 se situe entre les trajectoires
« stagnation » (445 TWh) et « décarbonation rapide » (510 TWh) du bilan
prévisionnel 2025 de RTE. -/
theorem consommation_2030_rte :
    445000 ≤ (en 5).consommationGwh ∧ (en 5).consommationGwh ≤ 510000 := by decide +kernel

/-- Consommation = base + voitures électriques du parc (aucune mesure). -/
theorem consommation_decomposee :
    (en 1).consommationGwh = (en 1).consommationBaseGwh
      + (en 1).parcElectriqueMilliers * E.consommationVoitureKwh / 1000 := by decide +kernel

/-- Chaque année, l'écart entre production et consommation ne dépasse pas
le solde exportateur maximal (la modulation du nucléaire y pourvoit). -/
theorem solde_borne :
    (tend.drop 1).all (fun s => decide (s.productionGwh.total - s.consommationGwh ≤ E.ecartProductionMaxGwh)) = true := by
  decide +kernel

/-- Retirer les volumes aidés du solaire (2,9 GW/an) laisse 620 MW
installés la première année ; un levier plus fort que la tendance n'en
démantèle aucun. -/
theorem levier_capacite :
    let s0 := etatDepart H
    (an1 [.capaciteElectrique .solaire (-2900)]).capacitesMw.solaire - s0.capacitesMw.solaire = 620 ∧
    (an1 [.capaciteElectrique .solaire (-10000)]).capacitesMw.solaire = s0.capacitesMw.solaire := by
  decide +kernel

/-! ## Sols -/

/-- Sous le ZAN, la consommation d'ENAF de 2021 à 2030 tient dans
l'enveloppe de la première tranche, à 20 ha près (arrondis de
la répartition par destination). -/
theorem zan_enveloppe :
    let c := (en 5).surfacesHa.totalEnaf
    H.sols.enveloppeHa - 20 ≤ c ∧ c ≤ H.sols.enveloppeHa := by decide +kernel

/-- Abrogé, le ZAN laisse la consommation revenir au rythme 2011-2021. -/
theorem zan_abroge :
    (an1 [.regimeZan 1000]).surfacesAnneeHa.totalEnaf = H.sols.consommationSansZanHa.total := by
  decide +kernel

/-- Sous le ZAN, 1 000 ha d'infrastructures d'une mesure s'imputent sur
l'enveloppe : le total de l'année ne change pas (à l'arrondi près), les
infrastructures gagnent 1 000 ha moins leur part de l'éviction. Sans ZAN,
ils s'ajoutent. -/
theorem zan_imputation :
    let base := (an1 []).surfacesAnneeHa
    let avec := (an1 [.artificialisation .infrastructures [1000]]).surfacesAnneeHa
    let sans := (an1 [.regimeZan 1000, .artificialisation .infrastructures [1000]]).surfacesAnneeHa
    avec.totalEnaf - base.totalEnaf ≤ 5 ∧ base.totalEnaf - avec.totalEnaf ≤ 5 ∧
    940 ≤ avec.infrastructures - base.infrastructures ∧ avec.infrastructures - base.infrastructures ≤ 960 ∧
    sans.totalEnaf = H.sols.consommationSansZanHa.total + 1000 := by
  decide +kernel

/-- L'échéancier d'une mesure s'épuise : la deuxième année ne porte plus
les surfaces d'une mesure d'un an. -/
theorem echeancier_surfaces :
    let p := mesure [.regimeZan 1000, .artificialisation .infrastructures [1000]]
    let s2 := anneeSuivante D H (anneeSuivante D H (p.etatInitial D H))
    s2.surfacesAnneeHa.totalEnaf = H.sols.consommationSansZanHa.total := by
  decide +kernel

/-- L'emprise énergétique de la première année est celle des installations
nouvelles de solaire au sol et d'éolien terrestre. -/
theorem emprise_energie :
    let s0 := etatDepart H
    let s1 := en 1
    s1.surfacesAnneeHa.energie =
      (s1.capacitesMw.solaire - s0.capacitesMw.solaire) * E.partSolaireSolPm * E.haParMwSolaireCentiemes / 100000
      + (s1.capacitesMw.eolienTerrestre - s0.capacitesMw.eolienTerrestre) * E.haParMwEolienCentiemes / 100 := by
  decide +kernel

end Tests.ElectriciteSols
