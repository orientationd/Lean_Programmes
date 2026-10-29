import Modele
import Hypotheses

/-!
# Tests du modèle commun : mécanismes

Chaque test isole un mécanisme en faisant varier une seule hypothèse ou une
seule mesure, et compare la réponse du modèle à son paramètre ou à une
estimation publiée (fourchettes larges : ce sont des garde-fous contre une
erreur de mécanisme, pas des calages).
-/

namespace Tests.Mecanismes
open Modele

def D : Moteur := Hypotheses.Moteurs.demande

/-- Scénario central dont la situation de départ est débarrassée des
échéanciers (dépenses et recettes temporaires, lois de programmation) et
des calendriers d'âge légal : les mécanismes y sont isolés. -/
def H : Scenario :=
  let C := Hypotheses.central
  { C with reference := { C.reference with etat := { C.reference.etat with
      echeances := [], echeancesRecettes := [], calendrierAgeLegal := [],
      calendrierAgeTendanciel := [] } } }

/-- Ce scénario avec une autre trajectoire de première année. -/
def avecPremiereAnnee (volume prix conso taux : Int) : Scenario :=
  { H with eco := { H.eco with
      croissancePotentielleAnneesPb := [H.eco.croissancePotentiellePb],
      croissanceVolumeAnneesPb := [volume], inflationAnneesPb := [prix],
      inflationConsoAnneesPb := [conso], tauxMarginalAnneesPb := [taux] } }

def base : Scenario := avecPremiereAnnee H.eco.croissancePotentiellePb H.eco.inflationPb H.eco.inflationPb H.eco.tauxMarginalPb

/-- Première année projetée. -/
def an1 (S : Scenario) : Etat := anneeSuivante D S (etatDepart S)

/-! ## Croissance et PIB -/

/-- Le PIB de la première année croît de la croissance nominale de la
trajectoire (volume et prix), à l'arrondi près. -/
theorem pib_suit_la_trajectoire :
    let s0 := etatDepart base
    let s1 := an1 base
    (s1.pib - s0.pib) * 10000 / s0.pib = base.eco.croissanceNominaleA 0 := by decide +kernel

/-- Loi d'Okun : un point de croissance en volume de plus la première année
abaisse le taux de chômage d'environ `okunPm` × 1 point (0,4 point ; la
flexion de la population active en retient un peu). -/
theorem okun_un_point :
    let haut := an1 (avecPremiereAnnee (H.eco.croissancePotentiellePb + 100) H.eco.inflationPb H.eco.inflationPb H.eco.tauxMarginalPb)
    let d := (an1 base).chomagePb - haut.chomagePb
    35 ≤ d ∧ d ≤ 45 := by decide +kernel

/-- Semi-élasticité du solde public au cycle : un point de croissance en
volume de plus réduit le déficit d'environ 0,5 à 0,65 point de PIB une
fois l'IS encaissé (LPFP 2023-2027 : 0,57 ; Commission européenne : 0,6
environ), un peu moins la première année : l'IS des entreprises hors
cinquième acompte suit le bénéfice avec un an de retard (acomptes et
solde), ce que les élasticités de la LPFP, contemporaines, ne
représentent pas. -/
theorem semi_elasticite_solde :
    let haut := avecPremiereAnnee (H.eco.croissancePotentiellePb + 100) H.eco.inflationPb H.eco.inflationPb H.eco.tauxMarginalPb
    let d1 := (an1 base).deficitPb - (an1 haut).deficitPb
    let d2 := (projeterN D base 2 (etatDepart base)).deficitPb - (projeterN D haut 2 (etatDepart haut)).deficitPb
    40 ≤ d1 ∧ d1 ≤ 55 ∧ 50 ≤ d2 ∧ d2 ≤ 65 := by decide +kernel

/-! ## Charge d'intérêts -/

/-- Indexation : un point d'inflation de plus sur les prix à la
consommation accroît la charge d'intérêts de la part indexée de la dette
(× 1 %), au million près. -/
theorem indexation_un_point :
    let s0 := etatDepart base
    let haut := an1 (avecPremiereAnnee H.eco.croissancePotentiellePb H.eco.inflationPb (H.eco.inflationPb + 100) H.eco.tauxMarginalPb)
    let d := haut.chargeInterets - (an1 base).chargeInterets
    let attendu := s0.dette * H.eco.partDetteIndexeePm / 1000 / 100
    attendu - 1 ≤ d ∧ d ≤ attendu + 1 := by decide +kernel

/-- Refinancement : un point de taux marginal de plus ne relève le taux
apparent que de la part émise dans l'année (part refinancée du stock),
soit `renouvellementDettePm` × 1 point, à l'arrondi près. -/
theorem refinancement_un_point :
    let haut := an1 (avecPremiereAnnee H.eco.croissancePotentiellePb H.eco.inflationPb H.eco.inflationPb (H.eco.tauxMarginalPb + 100))
    let d := haut.tauxApparentPb - (an1 base).tauxApparentPb
    let attendu := 100 * H.eco.renouvellementDettePm / 1000
    attendu - 1 ≤ d ∧ d ≤ attendu + 1 := by decide +kernel

/-- Le taux apparent reste entre le taux du stock et le taux d'émission, et
s'approche du second chaque année (taux marginal constant, sans programme). -/
def convergeVers : List Etat → Bool
  | a :: b :: r =>
    let ecartA := a.tauxEmissionPb - a.tauxApparentPb
    let ecartB := b.tauxEmissionPb - b.tauxApparentPb
    decide (0 ≤ ecartB ∧ ecartB ≤ ecartA) && convergeVers (b :: r)
  | _ => true

/-- À taux marginal constant (sans prime de risque ni trajectoire de
taux), le taux apparent se rapproche du taux d'émission chaque année sans
le dépasser. -/
def sansPrime : Scenario := { H with eco := { H.eco with primeDeficitPb := 0, tauxMarginalAnneesPb := [] } }

theorem taux_apparent_converge :
    convergeVers ((trajectoire D sansPrime 10 (etatDepart sansPrime)).drop 1) = true := by
  decide +kernel

/-! ## Mesures -/

def mesure (l : Levier) : Programme :=
  { id := "M", nom := "M", description := "", mainteneurs := [], source := "",
    mesures := [{ id := "M-1", titre := "", source := "", leviers := [l] }] }

def depart (p : Programme) : Etat := p.etatInitial D H

/-- Multiplicateur : une dépense de consommation publique d'un point de PIB
relève le PIB de l'année du multiplicateur du scénario (0,8 point), un peu
moins une fois déduite la moindre indemnisation des chômeurs qui retrouvent
un emploi (stabilisateur automatique). -/
theorem multiplicateur_depense :
    let s0 := etatDepart H
    let un := s0.pib / 100
    let p := depart (mesure (.depenseSur .enseignement un))
    let d := (p.pib - s0.pib) * 10000 / s0.pib
    75 ≤ d ∧ d ≤ 80 := by decide +kernel

/-- Une dépense creuse le déficit, mais moins que son montant (recettes
induites par l'activité) ; une économie du même montant, au moteur de
demande, a l'effet opposé (aux arrondis près : un million par prélèvement
et par étape). -/
theorem depense_economie_symetriques :
    let s0 := etatDepart H
    let dep := depart (mesure (.depenseSur .enseignement 10000))
    let eco := depart (mesure (.economieSur .enseignement 10000))
    0 < dep.deficit - s0.deficit ∧ dep.deficit - s0.deficit < 10000 ∧
      dep.deficit - s0.deficit + (eco.deficit - s0.deficit) ≤ 25 ∧
      -25 ≤ dep.deficit - s0.deficit + (eco.deficit - s0.deficit) := by decide +kernel

/-- Un prélèvement réduit le déficit de moins que son rendement statique :
fuite fiscale et activité perdue. -/
theorem prelevement_rendement :
    let s0 := etatDepart H
    let p := depart (mesure (.prelevementSur .tva 10000))
    0 < s0.deficit - p.deficit ∧ s0.deficit - p.deficit < 10000 - 10000 * H.eco.fuiteFiscalePm / 1000 + 1 := by
  decide +kernel

/-- Postes publics : 10 000 postes créés à 50 000 € (500 M€) ajoutent
10 000 emplois publics, l'emploi privé ne bougeant que de la réponse de
la loi d'Okun à l'écart entre la variation du PIB (multiplicateur) et la
production publique ajoutée ; la même dépense sans postes (`depenseSur`)
crée beaucoup moins d'emplois ; une création et une suppression du même
nombre de postes se compensent presque, au moteur de demande. -/
theorem postes_publics_un_pour_un :
    let s0 := etatDepart H
    let cr := depart (mesure (.creationPostes .enseignement [10000] 50000))
    let dep := depart (mesure (.depenseSur .enseignement 500))
    let sup := depart (mesure (.suppressionPostes .enseignement 10000 50000))
    let dCr := cr.emploiTotal - s0.emploiTotal
    let dSup := sup.emploiTotal - s0.emploiTotal
    9000 ≤ dCr ∧ dCr ≤ 10000 ∧ dep.emploiTotal - s0.emploiTotal < dCr / 2 ∧
      cr.depensesF.enseignement - s0.depensesF.enseignement = 500 ∧
      -300 ≤ dCr + dSup ∧ dCr + dSup ≤ 300 := by decide +kernel

/-- Échéancier de postes : 2 000 puis 4 000 postes cumulés ; la deuxième
année ajoute 2 000 emplois publics de plus (à l'arrondi près), au coût du
poste indexé comme la fonction. -/
theorem postes_publics_echeancier :
    let p := mesure (.creationPostes .enseignement [2000, 4000] 50000)
    let t := Modele.Programme.trajectoire p D H 2 0 (etatDepart H)
    let a := Modele.trajectoire D H 2 (etatDepart H)
    let e1 := (t.getD 1 (etatDepart H)).emploi.tertiaireNonMarchand - (a.getD 1 (etatDepart H)).emploi.tertiaireNonMarchand
    let e0 := (t.getD 0 (etatDepart H)).emploi.tertiaireNonMarchand - (a.getD 0 (etatDepart H)).emploi.tertiaireNonMarchand
    1900 ≤ e0 ∧ e0 ≤ 2100 ∧ 3800 ≤ e1 ∧ e1 ≤ 4200 := by decide +kernel

def O : Moteur := Hypotheses.Moteurs.offre

/-- Le moteur d'offre sans canal du capital. -/
def O0 : Moteur := { O with canalCapitalPm := 0 }

/-- Canal du capital public : un investissement public durable d'un point
de PIB relève le PIB de 2035, au moteur d'offre, de 1,2 à 1,7 % de plus que
sans le canal (calcul : ≈ 1,5 % avec une élasticité de 0,12, un stock de
59 % du PIB et 5 % de dépréciation ; FMI, WEO 2014 : +1,5 % après quatre
ans, demande comprise) ; le moteur de demande n'a pas ce canal. -/
theorem capital_public_offre :
    let p := mesure (.investissement .affairesEconomiques ((etatDepart H).pib / 100))
    let a := p.resultatA O H 10
    let b := p.resultatA O0 H 10
    let dPm := (a.pib - b.pib) * 10000 / b.pib
    120 ≤ dPm ∧ dPm ≤ 170 ∧ D.canalCapitalPm = 0 := by
  decide +kernel

/-- Canal du capital des entreprises : l'IS ramené de 25 à 20 % fixe un effet
de long terme de +0,5 % de PIB (0,10 % par point) ; dix ans après, 61 % en est
atteint (accumulation à 9 % par an) ; au moteur d'offre, le PIB de 2035
dépasse celui de l'IS inchangé d'au moins cet effet. -/
theorem capital_entreprises_is :
    let p := mesure (.impotSocietes 2000)
    let a := p.resultatA O H 10
    let b := (mesure (.depenseSur .affairesEconomiques 0)).resultatA O H 10
    a.ecartTauxISPb = -500 ∧ 2900 ≤ a.effetCapitalPrivePpm ∧ a.effetCapitalPrivePpm ≤ 3200 ∧
      (a.pib - b.pib) * 1000000 / b.pib ≥ 2900 := by
  decide +kernel

/-- SMIC : un point de hausse augmente les allègements de 1 490 M€ (Institut
Montaigne, 2024) et fait perdre à terme 13 800 emplois (OFCE, 2012), ajoutés
progressivement par la projection ; une cible en euros se rapporte au SMIC
de l'année (1 802 € au départ : 1 820 € valent +0,99 %). -/
theorem smic_un_point :
    let s0 := etatDepart H
    let a := depart (mesure (.revalorisationSmic 100))
    let c := depart (mesure (.smicCibleBrut 1820))
    a.allegementsTranche.bas - s0.allegementsTranche.bas = 1490 ∧
      a.emploisCoutTravailRestants - s0.emploisCoutTravailRestants = -13800 ∧
      a.smicMensuel = 1820 ∧ c.smicMensuel - s0.smicMensuel = 17 := by
  decide +kernel

end Tests.Mecanismes
