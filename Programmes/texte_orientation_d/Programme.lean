import Modele
import Hypotheses
import Proprietes

/-!
# Programme « texte_orientation_d »

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

Les valeurs marquées « hypothèse » restent à sourcer ou à arbitrer.
-/

namespace Programmes.texte_orientation_d
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

/-! ## Mesures -/

def mesures : List Mesure := [
  { id := "O-01"
    titre := "Remplacement gratuit par l'État des 10 000 voitures les plus polluantes"
    source := "texte_orientation_d, mesure 1 ; prix unitaire et part importée : hypothèses (voir Programme.lean)"
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
    source := "texte_orientation_d, mesure 2 ; remplace la majoration préfectorale discrétionnaire (CCH L.302-9-1)"
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
    source := "texte_orientation_d, mesure 3 ; chiffrage provisoire (hypothèses) : 20 M€ de développement, 5 M€/an d'exploitation ; effet sur l'immobilier non modélisé"
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
    source := "texte_orientation_d, mesure 4 ; programme gouvernemental : devis EDF du 18 décembre 2025 (72,8 Md€₂₀₂₀ pour 6 EPR2), accord État-EDF du 19 juin 2025 (prêt de l'État ≥ 50 %, CfD 100 €/MWh), première mise en service 2038. Effets hors horizon : production, CfD, remboursements"
    leviers := [.pretEtat pretEPR2]
    variantes := [
      { nom := "prêt de l'État couvrant la totalité du coût", leviers := [.pretEtat pretEPR2Total] }] }
]

def programme : Programme where
  id := "texte_orientation_d"
  nom := "texte_orientation_d"
  description := "Programme de orientation_d : remplacement des voitures les plus polluantes, amendes SRU proportionnelles, attributions HLM vérifiables par preuve ZK, six EPR2 financés par prêt de l'État."
  mainteneurs := ["@orientationd"]
  source := "Programme de orientation_d (texte en cours de rédaction)"
  mesures := mesures

end Programmes.texte_orientation_d
