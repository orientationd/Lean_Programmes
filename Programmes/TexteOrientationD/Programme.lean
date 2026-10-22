import Modele
import Hypotheses
import Proprietes

/-!
# Programme « Texte Orientation D »

Programme de orientation_d. Seuls les comptes listés dans `PROPRIETAIRES`
peuvent modifier ce dossier : la CI refuse toute autre PR (contrôle d'accès
aux programmes).

Trois mesures :

* **O-01** — remplacement gratuit par l'État des 10 000 voitures les plus
  polluantes. Balance commerciale à 5 et 10 ans : sous-modèle automobile.
* **O-02** — amendes SRU proportionnelles à la part de logements sociaux
  manquants, avec comparaison de plusieurs taux. Effet par commune et
  destination des fonds : sous-modèle SRU.
* **O-03** — transparence des attributions de logements sociaux par preuve
  à divulgation nulle de connaissance (ZK). Spécification et garanties :
  sous-modèle d'attribution.
* **O-04** — construction de six EPR2, au niveau du programme
  gouvernemental en cours, financée comme lui par un prêt de l'État.
* **O-05** — prime à l'achat d'une voiture électrique pour 300 000 ménages
  par an ; **O-06** — 50 000 points de recharge publics par an : effets sur
  le parc électrique, les bornes nécessaires et la mortalité liée aux
  particules fines.
* **O-07** — fin de l'âge légal de départ : seule compte la durée cotisée
  (seuil actuel, 172 trimestres), réduite selon la pénibilité.
* **O-08** — impôt sur les sociétés au taux le plus bas de l'Union
  européenne.
* **O-09** — la démission ouvre des droits au chômage (six mois, une fois
  tous les cinq ans).
* **O-10** — moyens pour la justice, prud'hommes en priorité.
* **O-11** — financement des lignes nouvelles Lyon-Turin, Bordeaux-Toulouse
  et Montpellier-Perpignan.

Les valeurs marquées « hypothèse » restent à sourcer ou à arbitrer.
-/

namespace Programmes.TexteOrientationD
open Modele

/-! ## O-01 — Remplacement des 10 000 voitures les plus polluantes -/

/-- 10 000 citadines électriques à 25 000 € (hypothèse de prix), achetées
sans critère d'origine : 73 % de la valeur importée, puisque 27 % des
voitures électriques vendues en France y sont fabriquées (IMT, 2025). -/
def remplacement : Remplacement where
  nombre := 10000
  prixUnitaire := 25000
  partImporteePm := 730

/-- Variante : véhicules assemblés en France, dont 35 % de la valeur reste
importée (batteries, composants ; hypothèse). -/
def remplacementFabriqueEnFrance : Remplacement :=
  { remplacement with partImporteePm := 350 }

/-! ## O-02 — Amendes SRU proportionnelles -/

/-- Barème retenu : ×1 à ×5 selon la part de l'objectif non atteinte,
plafond porté à 10 % des dépenses réelles de fonctionnement, seuil actuel. -/
def baremeSRU : BaremeSRU where
  tauxBasePm := 250
  coefMinPm := 1000
  coefMaxPm := 5000
  plafondPb := 1000
  seuil := 4000

theorem baremeSRU_valide : baremeSRU.Valide := by decide

def baremeSRUPlafondActuel : BaremeSRU := { baremeSRU with plafondPb := 500 }
def baremeSRUModere : BaremeSRU := { baremeSRU with coefMaxPm := 3000, plafondPb := 500 }
def baremeSRUSevere : BaremeSRU := { baremeSRU with coefMaxPm := 10000, plafondPb := 1500 }

/-! ## O-04 — Six EPR2, comme le programme gouvernemental -/

/-- Programme gouvernemental : 6 EPR2 (Penly, Gravelines, Bugey), devis EDF
du 18 décembre 2025 de 72,8 Md€ (euros 2020), décision finale
d'investissement fin 2026, première mise en service visée en 2038. Accord
État-EDF de juin 2025 : prêt bonifié de l'État couvrant au moins la moitié
des coûts de construction, contrat pour différence à 100 €/MWh sur 40 ans.
Prêt supposé versé linéairement de 2027 à 2038 : 72 800 / 2 / 12 ≈ 3 033
M€/an. -/
def pretEPR2 : Int := 3033

/-- Variante : l'État prête la totalité du coût de construction. -/
def pretEPR2Total : Int := 6067

/-! ## O-07 à O-11 — Hypothèses de chiffrage -/

/-- Impôt sur les sociétés au taux le plus bas de l'UE : 9 % (Hongrie), contre
25 % en France. Rendement statique : 58,9 Md€ × (1 − 9/25) = −37,7 Md€ ;
le modèle y applique sa fuite fiscale (ici, un retour d'assiette) et le
moteur « offre » un surcroît de croissance. -/
def baisseIS : Int := -37700

/-- Variante : taux irlandais de 12,5 % : 58,9 × (1 − 12,5/25) = −29,5 Md€. -/
def baisseISIrlande : Int := -29450

/-- Démission indemnisée six mois, une fois tous les cinq ans. Hypothèse :
1,9 million de démissions de CDI par an (DARES, ordre de grandeur), 20 %
donnent lieu à indemnisation, 1 300 € par mois pendant 6 mois :
≈ 3,0 Md€/an. Effet sur le chômage non modélisé. -/
def coutDemission : Int := 3000

/-- Lignes nouvelles : accès français au Lyon-Turin (≈ 10 Md€), Bordeaux-
Toulouse et Bordeaux-Dax (14,3 Md€ en valeur 2020), Montpellier-Perpignan
(≈ 6 Md€) : ≈ 30 Md€ sur dix ans, dont 80 % portés par l'État, les
collectivités et SNCF Réseau (administrations publiques), le reste par
l'Union européenne : 2,4 Md€/an. Hypothèses d'ordre de grandeur. -/
def lignesNouvelles : Int := 2400

/-! ## Mesures -/

def mesures : List Mesure := [
  { id := "O-01"
    titre := "Remplacement gratuit par l'État des 10 000 voitures les plus polluantes"
    source := "Texte Orientation D, mesure 1 ; prix unitaire et part importée : hypothèses (voir Programme.lean)"
    leviers := [.remplacementVehicules remplacement]
    variantes := [
      { nom := "véhicules fabriqués en France"
        leviers := [.remplacementVehicules remplacementFabriqueEnFrance] }]
    contrats := [
      { titre := "Le déficit commercial induit se résorbe d'année en année dès que le carburant évité vaut plus que l'électricité consommée"
        enonce := ∀ (h : HypAuto) (m n : Nat), 0 ≤ remplacement.gainAnnuelCts h → m ≤ n →
          remplacement.soldeCumuleCts h m ≤ remplacement.soldeCumuleCts h n
        preuve := fun h _ _ hg hmn => Remplacement.soldeCumule_mono h remplacement hg hmn },
      { titre := "L'année d'équilibre commercial annoncée est exacte : solde positif cette année-là, négatif l'année précédente"
        enonce := ∀ (h : HypAuto) (n : Nat), remplacement.anneeEquilibre h = some n →
          0 ≤ remplacement.soldeCumuleCts h n ∧ (0 < n → remplacement.soldeCumuleCts h (n - 1) < 0)
        preuve := fun h _ hn => Remplacement.anneeEquilibre_correcte h remplacement hn }] },

  { id := "O-02"
    titre := "Amendes SRU proportionnelles à la part de logements sociaux manquants"
    source := "Texte Orientation D, mesure 2 ; remplace la majoration préfectorale discrétionnaire (CCH L.302-9-1)"
    leviers := [.amendeSRU baremeSRU]
    variantes := [
      { nom := "plafond actuel (5 %)", leviers := [.amendeSRU baremeSRUPlafondActuel] },
      { nom := "modérée (×1 à ×3, plafond 5 %)", leviers := [.amendeSRU baremeSRUModere] },
      { nom := "sévère (×1 à ×10, plafond 15 %)", leviers := [.amendeSRU baremeSRUSevere] }]
    contrats := [
      { titre := "Nulle pour toute commune qui atteint son objectif"
        enonce := ∀ c : Commune, c.Valide → c.objectif ≤ c.logementsSociaux →
          baremeSRU.amende c = 0
        preuve := fun _ hc h => BaremeSRU.amende_nulle_si_conforme baremeSRU_valide hc h },
      { titre := "Ne dépasse jamais 10 % des dépenses réelles de fonctionnement"
        enonce := ∀ c : Commune, c.Valide → baremeSRU.amende c ≤ c.plafond 1000
        preuve := fun _ hc => BaremeSRU.amende_plafonnee baremeSRU_valide hc },
      { titre := "Construire des logements sociaux ne fait jamais payer plus"
        enonce := ∀ c : Commune, c.Valide → ∀ k, 0 ≤ k →
          baremeSRU.amende { c with logementsSociaux := c.logementsSociaux + k } ≤
            baremeSRU.amende c
        preuve := fun _ hc _ hk =>
          BaremeSRU.amende_decroit_avec_logements_sociaux baremeSRU_valide hc hk },
      { titre := "Jamais moins que le prélèvement de base actuel"
        enonce := ∀ c : Commune, c.Valide → SRU.prelevementActuel c ≤ baremeSRU.amende c
        preuve := fun _ hc => BaremeSRU.amende_ge_prelevement_actuel baremeSRU_valide hc
          (by decide) (by decide) (by decide) }] },

  { id := "O-03"
    titre := "Attributions de logements sociaux vérifiables par preuve à divulgation nulle de connaissance"
    source := "Texte Orientation D, mesure 3 ; chiffrage provisoire (hypothèses) : 20 M€ de développement, 5 M€/an d'exploitation ; effet sur l'immobilier non modélisé"
    leviers := [.depensePonctuelle 20, .depense 5]
    contrats := [
      { titre := "Dès qu'un candidat est éligible, la règle publiée désigne un attributaire"
        enonce := ∀ cs : List Candidat, (∃ c ∈ cs, c.eligible = true) → ∃ a, choisir cs = some a
        preuve := fun _ h => choisir_complet h },
      { titre := "L'attributaire désigné est éligible et aucun éligible ne passe devant lui"
        enonce := ∀ (cs : List Candidat) (a : Candidat), choisir cs = some a → Conforme cs a
        preuve := fun _ _ h => choisir_conforme h },
      { titre := "Pour une liste donnée, un seul attributaire est conforme : aucune marge d'appréciation"
        enonce := ∀ (cs : List Candidat) (a b : Candidat), (cs.map (·.id)).Nodup →
          Conforme cs a → Conforme cs b → a = b
        preuve := fun _ _ _ hnd ha hb => conforme_unique hnd ha hb },
      { titre := "Deux preuves ZK acceptées pour le même engagement désignent la même personne"
        enonce := ∀ (R : Type) (engager : List Candidat → R), (∀ x y, engager x = engager y → x = y) →
          ∀ (r : R) (i j : Nat), EnonceZK engager r i → EnonceZK engager r j → i = j
        preuve := fun _ _ hlie _ _ _ hi hj => zk_sans_discretion hlie hi hj },
      { titre := "La commission peut toujours produire la preuve pour l'attributaire légitime"
        enonce := ∀ (R : Type) (engager : List Candidat → R) (cs : List Candidat) (a : Candidat),
          (cs.map (·.id)).Nodup → choisir cs = some a → EnonceZK engager (engager cs) a.id
        preuve := fun _ engager _ _ hnd h => zk_complet engager hnd h }] },

  { id := "O-04"
    titre := "Construction de six EPR2, au niveau du programme gouvernemental"
    source := "Texte Orientation D, mesure 4 ; programme gouvernemental : devis EDF du 18 décembre 2025 (72,8 Md€₂₀₂₀ pour 6 EPR2), accord État-EDF du 19 juin 2025 (prêt de l'État ≥ 50 %, CfD 100 €/MWh), première mise en service 2038. Effets hors horizon : production, CfD, remboursements"
    leviers := [.pretEtat pretEPR2]
    debut := 2  -- décision finale d'investissement fin 2026, premiers décaissements 2027
    variantes := [
      { nom := "prêt de l'État couvrant la totalité du coût", leviers := [.pretEtat pretEPR2Total] }] },

  { id := "O-05"
    titre := "Prime de 4 000 € à l'achat d'une voiture électrique, 300 000 ménages par an"
    source := "Texte Orientation D, mesure 5 ; montant et nombre : hypothèses (bonus écologique 2025 : 2 000 à 4 000 € selon le revenu, ≈ 300 000 électriques neuves par an) ; 1,2 Md€/an"
    leviers := [.aideAchatElectrique 300000 4000]
    variantes := [
      { nom := "prime de 6 000 €, 400 000 ménages (2,4 Md€/an)", leviers := [.aideAchatElectrique 400000 6000] }] },

  { id := "O-06"
    titre := "50 000 points de recharge publics supplémentaires par an"
    source := "Texte Orientation D, mesure 6 ; coût moyen 8 000 € par point, accélérée et normale confondues (hypothèse, programme Advenir) ; 0,4 Md€/an"
    leviers := [.deploiementBornes 50000 8000] },

  { id := "O-07"
    titre := "Fin de l'âge légal : départ à la durée cotisée (172 trimestres), réduite selon la pénibilité"
    source := "Texte Orientation D, mesure 7. Conversion : le modèle ne connaît qu'un âge moyen de départ ; sans borne d'âge, les carrières commencées avant 21 ans partent avant 64 ans et la réduction pour pénibilité avance encore les métiers exposés : âge moyen de départ supposé avancé de 6 mois (hypothèse à étayer avec le COR), coût et actifs selon l'hypothèse économique du scénario"
    leviers := [.ageLegal (-6)]
    variantes := [
      { nom := "âge moyen avancé de 12 mois (pénibilité large)", leviers := [.ageLegal (-12)] }] },

  { id := "O-08"
    titre := "Impôt sur les sociétés au taux le plus bas de l'Union européenne (9 %)"
    source := s!"Texte Orientation D, mesure 8 ; taux : Hongrie 9 %, Irlande 12,5 % (Commission européenne, Taxation trends 2025) ; rendement statique {baisseIS} M€/an sur 58,9 Md€ d'IS 2025"
    leviers := [.prelevementSur .impotSocietes baisseIS]
    variantes := [
      { nom := "taux irlandais de 12,5 %", leviers := [.prelevementSur .impotSocietes baisseISIrlande] }] },

  { id := "O-09"
    titre := "La démission ouvre des droits au chômage : six mois d'indemnités, une fois tous les cinq ans"
    source := s!"Texte Orientation D, mesure 9 ; chiffrage : hypothèse de recours de 20 % sur 1,9 million de démissions de CDI, 1 300 €/mois × 6 : {coutDemission} M€/an"
    leviers := [.depense coutDemission]
    variantes := [
      { nom := "recours de 40 % (6 Md€/an)", leviers := [.depense 6000] }] },

  { id := "O-10"
    titre := "Moyens pour la justice : réduction des délais, prud'hommes en priorité"
    source := "Texte Orientation D, mesure 10 ; +300 M€/an (hypothèse : +3 % du budget de la justice, greffiers et juges départiteurs) ; effet sur les délais non modélisé"
    leviers := [.depenseSecteur .tertiaireNonMarchand 300] },

  { id := "O-11"
    titre := "Financement des lignes nouvelles Lyon-Turin, Bordeaux-Toulouse et Montpellier-Perpignan"
    source := s!"Texte Orientation D, mesure 11 ; ≈ 30 Md€ sur dix ans dont 80 % d'argent public français : {lignesNouvelles} M€/an (hypothèses, voir `lignesNouvelles`)"
    leviers := [.depenseSecteur .construction lignesNouvelles] }
]

def programme : Programme where
  id := "TexteOrientationD"
  nom := "Texte Orientation D"
  description := "Texte Orientation D : remplacement des voitures les plus polluantes, amendes SRU proportionnelles, attributions HLM vérifiables par preuve ZK, six EPR2, prime à l'électrique et bornes, retraite à la durée cotisée sans âge légal, IS au taux le plus bas de l'UE, démission indemnisée, moyens pour la justice, lignes nouvelles ferroviaires."
  mainteneurs := ["@orientationd"]
  source := "Programme de orientation_d (texte en cours de rédaction)"
  mesures := mesures

end Programmes.TexteOrientationD
