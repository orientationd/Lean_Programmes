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
* **O-12** — qualité d'accueil des touristes : six zones de rénovation de
  qualité (dont Le Grau-du-Roi), pour accroître la dépense par touriste et
  le nombre de nuitées.
* **O-13** — autorisation de la conduite autonome (FSD), avec indemnisation
  des chauffeurs de taxi titulaires d'une licence jusqu'à leur retraite.
* **O-14** — partenaires d'accompagnement à l'application des normes et à
  la lutte contre les accidents du travail, financés par des fonds dédiés
  de l'État ; objectif : la moyenne de l'Union européenne.
* **O-15** — passage au logiciel libre pour tous les logiciels de l'État et
  tous ses ordinateurs.
* **O-20** à **O-23** — économies et recettes : aide à l'apprentissage
  recentrée, commande publique, médicaments et dispositifs avec une agence
  française du médicament qui produit les références en rupture, lutte
  contre la fraude et le travail dissimulé.
* **O-16** à **O-19** — universités : reprise de la dette et apurement des
  déficits, reconstruction aux normes de campus dégradés (Nanterre,
  Toulouse, Montpellier, Grenoble), Parcoursup pour les étudiants
  étrangers à nombre constant, places pour les bacheliers sans
  affectation.

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
25 % en France. Le levier `impotSocietes` calcule la perte statique au
prorata des taux (58,9 Md€ × (1 − 9/25) = −37,7 Md€) puis applique un
**coefficient de retour d'assiette** : part de la perte récupérée grâce aux
bénéfices rapatriés et aux sociétés qui reviennent ou s'implantent. Valeur
centrale 30 % (hypothèse : élasticité de l'assiette de l'IS au taux de
l'ordre de 1, littérature Devereux-Griffith / OCDE, pour un pays de la
taille de la France) ; variantes 0 %, 60 % et taux irlandais. -/
def tauxISCible : Int := 900
def retourAssiette : Int := 300

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

/-- Qualité d'accueil touristique : six zones de rénovation (Le Grau-du-Roi
et cinq autres stations), 150 M€/an par zone pendant dix ans (hypothèse :
rénovation du bâti, espaces publics, mobilités). Effet attendu, hypothèse à
étayer (Atout France, études d'impact des stations rénovées) : +2 % de
visiteurs internationaux et +3 % de dépense par touriste, soit ≈ +3,6 Md€/an
de recettes touristiques sur 71 Md€. -/
def zonesTouristiques : Int := 6
def coutParZone : Int := 150

/-- Conduite autonome : ≈ 60 000 licences de taxi en France (dont 20 000 à
Paris). Indemnisation jusqu'à la retraite : 25 000 €/an en moyenne
(hypothèse : perte de revenu et de valeur de licence lissée), soit 1,5 Md€/an
au départ, décroissant avec les départs en retraite (non modélisé : montant
constant, prudent). Automatisation du transport de personnes : +0,05 % de
PIB (hypothèse : 0,3 % de PIB pour taxis, VTC et livraison, 15 % de gain
de coût) et 20 000 emplois de chauffeurs en moins. -/
def indemnisationTaxis : Int := 1500

/-- Accidents du travail : 190 accidents avec arrêt pour 10 000 emplois en
France contre ≈ 110 en moyenne dans l'Union (Eurostat). Fonds dédiés :
500 M€/an (hypothèse : réseau de partenaires d'accompagnement des
entreprises, renfort de l'inspection et de la médecine du travail). Objectif
atteint à l'horizon : −42,5 % du taux (190 → 110, arrondi entier). Variante : fonds doublés,
objectif inchangé. -/
def fondsPrevention : Int := 500
def baisseAccidentsPm : Int := 425

/-- Logiciel libre : licences et services propriétaires de l'État ≈ 1 Md€/an
(hypothèse : accords-cadres Microsoft, Oracle, SAP… de l'État et de ses
opérateurs) ; économie nette de 400 M€/an à partir de la quatrième année,
après une migration de 900 M€ (formation, adaptation, matériel) étalée sur
trois ans et comptée en une fois dans la dette, par prudence. -/
def economieLibre : Int := 400
def coutMigrationLibre : Int := 900

/-- Universités. Reprise de la dette : les universités sont des organismes
divers d'administration centrale, déjà consolidés dans la dette publique ;
la reprise par l'État est un transfert interne, neutre sur le solde et la
dette des administrations publiques. Ce qui coûte, c'est l'apurement des
déficits de fonctionnement : ≈ 60 universités en déficit en 2024, pour
environ 500 M€/an (hypothèse ; Cour des comptes, situation financière des
universités, 2025). Reconstruction : quatre campus démolis puis rebâtis aux
normes, 1 Md€ chacun (hypothèse : opérations campus comparables, Jussieu
≈ 2 Md€), étalés sur huit ans à partir de 2027 : 500 M€/an. Places pour les
bacheliers sans affectation : ≈ 10 000 par an sans proposition en fin de
procédure Parcoursup (SIES), trois années de licence, 10 500 € par
étudiant et par an (dépense moyenne, MESR) : 315 M€/an, et 2 000 postes
d'enseignants-chercheurs annoncés. -/
def deficitsUniversites : Int := 500
def reconstructionCampus : Int := 500
def placesSansFac : Int := 315

/-- Économies et recettes. Apprentissage : 6 Md€ d'aides à l'embauche
d'apprentis, dont la moitié pour des niveaux bac+3 et plus et dans de
grandes entreprises (Cour des comptes, 2025) ; recentrage sur l'infra-bac et
les PME : 2 Md€/an. Commande publique : centrales d'achat, standardisation,
lutte contre les ententes ; 3 Md€/an (hypothèse médiane des estimations,
Autorité de la concurrence, IGF). Médicaments et dispositifs : génériques,
biosimilaires, prix des innovations, pertinence des prescriptions, 2 Md€/an
(Assurance maladie, rapport charges et produits 2025) ; l'agence française
du médicament qui produit les références en rupture coûte 300 M€/an
(hypothèse : établissement pharmaceutique public de taille moyenne,
investissement initial de 500 M€). Fraude et travail dissimulé (BTP,
restauration, services à la personne) : manque à gagner de cotisations
estimé entre 6 et 8 Md€ par an (Haut Conseil du financement de la
protection sociale, 2024) ; récupération de 2 Md€/an de cotisations et 1 Md€
de TVA, montée en charge sur deux ans. -/
def economieApprentissage : Int := 2000
def economieCommandePublique : Int := 3000
def economieMedicament : Int := 2000
def coutAgenceMedicament : Int := 300
def investissementAgence : Int := 500
def fraudeCotisations : Int := 2000
def fraudeTVA : Int := 1000

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
    leviers := [.depensePonctuelle 20, .depenseSur .logementEnvironnement 5]
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
    source := s!"Texte Orientation D, mesure 8 ; taux : Hongrie 9 %, Irlande 12,5 % (Commission européenne, Taxation trends 2025) ; perte statique −37,7 Md€/an sur 58,9 Md€ d'IS 2025, retour d'assiette {retourAssiette / 10} % (voir `retourAssiette`)"
    leviers := [.impotSocietes tauxISCible retourAssiette]
    variantes := [
      { nom := "aucun retour d'assiette", leviers := [.impotSocietes tauxISCible 0] },
      { nom := "retour d'assiette de 60 %", leviers := [.impotSocietes tauxISCible 600] },
      { nom := "taux irlandais de 12,5 %, retour de 30 %", leviers := [.impotSocietes 1250 retourAssiette] }] },

  { id := "O-09"
    titre := "La démission ouvre des droits au chômage : six mois d'indemnités, une fois tous les cinq ans"
    source := s!"Texte Orientation D, mesure 9 ; chiffrage : hypothèse de recours de 20 % sur 1,9 million de démissions de CDI, 1 300 €/mois × 6 : {coutDemission} M€/an"
    leviers := [.depenseSur .famille coutDemission]
    variantes := [
      { nom := "recours de 40 % (6 Md€/an)", leviers := [.depenseSur .famille 6000] }] },

  { id := "O-10"
    titre := "Moyens pour la justice : réduction des délais, prud'hommes en priorité"
    source := "Texte Orientation D, mesure 10 ; +300 M€/an (hypothèse : +3 % du budget de la justice, greffiers et juges départiteurs) ; effet sur les délais non modélisé"
    leviers := [.depenseSur .securiteJustice 300] },

  { id := "O-11"
    titre := "Financement des lignes nouvelles Lyon-Turin, Bordeaux-Toulouse et Montpellier-Perpignan"
    source := s!"Texte Orientation D, mesure 11 ; ≈ 30 Md€ sur dix ans dont 80 % d'argent public français : {lignesNouvelles} M€/an (hypothèses, voir `lignesNouvelles`)"
    leviers := [.depenseSur .affairesEconomiques lignesNouvelles] },

  { id := "O-12"
    titre := "Qualité d'accueil des touristes : six zones de rénovation de qualité, dont Le Grau-du-Roi"
    source := s!"Texte Orientation D, mesure 12 ; {zonesTouristiques} zones × {coutParZone} M€/an (hypothèse) ; effet +2 % de visiteurs et +3 % de dépense par touriste (hypothèse, voir `zonesTouristiques`) ; base 2024 : 100 M de visiteurs, 71 Md€ (Atout France, Banque de France)"
    leviers := [.accueilTouristique zonesTouristiques coutParZone 20 30]
    variantes := [
      { nom := "effet faible : +1 % de visiteurs, +1 % de dépense", leviers := [.accueilTouristique zonesTouristiques coutParZone 10 10] },
      { nom := "effet fort : +4 % de visiteurs, +5 % de dépense", leviers := [.accueilTouristique zonesTouristiques coutParZone 40 50] }] },

  { id := "O-13"
    titre := "Autorisation de la conduite autonome (FSD) ; indemnisation des chauffeurs de taxi titulaires d'une licence jusqu'à leur retraite"
    source := s!"Texte Orientation D, mesure 13 ; {indemnisationTaxis} M€/an d'indemnisation (60 000 licences × 25 000 €, hypothèse), +0,05 % de PIB et −20 000 emplois de chauffeurs (hypothèses, voir `indemnisationTaxis`)"
    leviers := [.depenseSur .famille indemnisationTaxis, .automatisation 5 20000]
    variantes := [
      { nom := "automatisation plus large : +0,15 % de PIB, −60 000 emplois", leviers := [.depenseSur .famille indemnisationTaxis, .automatisation 15 60000] }] },

  { id := "O-14"
    titre := "Partenaires d'accompagnement des normes et de lutte contre les accidents du travail, financés par l'État ; objectif : moyenne de l'Union européenne"
    source := s!"Texte Orientation D, mesure 14 ; {fondsPrevention} M€/an de fonds dédiés et taux d'accidents ramené de 190 à 110 pour 10 000 emplois (hypothèses, voir `fondsPrevention`) ; sources du sous-modèle : CNAM, rapport AT-MP 2023 ; Eurostat, accidents du travail 2022"
    leviers := [.preventionAccidents fondsPrevention baisseAccidentsPm]
    variantes := [
      { nom := "fonds doublés (1 Md€/an)", leviers := [.preventionAccidents 1000 baisseAccidentsPm] },
      { nom := "objectif à moitié atteint (−21 %)", leviers := [.preventionAccidents fondsPrevention 210] }] },

  { id := "O-15"
    titre := "Passage au logiciel libre pour tous les logiciels et tous les ordinateurs de l'État"
    source := s!"Texte Orientation D, mesure 15 ; migration {coutMigrationLibre} M€ en une fois puis {economieLibre} M€/an d'économies de licences à partir de la quatrième année (hypothèses, voir `economieLibre`)"
    leviers := [.depensePonctuelle coutMigrationLibre] },
  { id := "O-15b"
    titre := "Logiciel libre : économies de licences en régime de croisière"
    source := "Texte Orientation D, mesure 15 (suite) ; entrée en vigueur la quatrième année"
    leviers := [.economieSur .fonctionnement economieLibre]
    debut := 3 },

  { id := "O-16"
    titre := "Reprise de la dette des universités et apurement de leurs déficits"
    source := s!"Texte Orientation D, mesure 16 ; la reprise de dette est un transfert interne aux administrations publiques (neutre) ; apurement des déficits : {deficitsUniversites} M€/an (hypothèse, Cour des comptes 2025 : ≈ 60 universités en déficit)"
    leviers := [.depenseSur .enseignement deficitsUniversites] },

  { id := "O-17"
    titre := "Reconstruction aux normes des universités de Nanterre, Toulouse, Montpellier et Grenoble (démolition puis construction)"
    source := s!"Texte Orientation D, mesure 17 ; 4 × 1 Md€ sur huit ans à partir de 2027 : {reconstructionCampus} M€/an d'investissement (hypothèse), emplois dans la construction ; le modèle garde la dépense constante au-delà des huit ans (prudent)"
    leviers := [.investissement .enseignement reconstructionCampus]
    debut := 2 },

  { id := "O-18"
    titre := "Parcoursup ouvert aux étudiants étrangers, à nombre d'admis constant"
    source := "Texte Orientation D, mesure 18 ; à effectifs constants, sans effet budgétaire : procédure d'admission unifiée (remplace Études en France pour les candidats hors UE) ; enregistrée pour mémoire"
    leviers := [] },

  { id := "O-19"
    titre := "Ouverture de places pour tous les bacheliers sans affectation"
    source := s!"Texte Orientation D, mesure 19 ; ≈ 10 000 bacheliers sans proposition par an (SIES, Parcoursup 2025) × 3 ans × 10 500 € : {placesSansFac} M€/an ; 2 000 postes d'enseignants-chercheurs annoncés"
    leviers := [.depenseSur .enseignement placesSansFac, .annonceEmplois 2000] },

  { id := "O-20"
    titre := "Aide à l'apprentissage réservée aux niveaux infra-bac et aux PME"
    source := s!"Texte Orientation D, mesure 20 ; Cour des comptes, « L'aide exceptionnelle à l'apprentissage », 2025 : 6 Md€ dont la moitié pour des bac+3 et plus ; économie retenue {economieApprentissage} M€/an"
    leviers := [.economieSur .famille economieApprentissage] },

  { id := "O-21"
    titre := "Commande publique : centrales d'achat, standardisation, lutte contre les ententes"
    source := s!"Texte Orientation D, mesure 21 ; {economieCommandePublique} M€/an (hypothèse médiane : Autorité de la concurrence sur les ententes, IGF sur la mutualisation des achats) ; répartie sur les services généraux"
    leviers := [.economieSur .fonctionnement economieCommandePublique] },

  { id := "O-22"
    titre := "Médicaments et dispositifs : génériques, biosimilaires, prix, pertinence ; agence française du médicament produisant les références en rupture"
    source := s!"Texte Orientation D, mesure 22 ; économies {economieMedicament} M€/an (Assurance maladie, charges et produits 2025) ; agence publique : {investissementAgence} M€ d'investissement puis {coutAgenceMedicament} M€/an de fonctionnement (hypothèses) ; 1 500 emplois industriels annoncés"
    leviers := [.economieSur .sante economieMedicament, .depensePonctuelle investissementAgence,
                .depenseSur .sante coutAgenceMedicament, .annonceEmplois 1500] },

  { id := "O-23"
    titre := "Lutte contre la fraude et le travail dissimulé (BTP, restauration, services à la personne)"
    source := s!"Texte Orientation D, mesure 23 ; HCFiPS 2024 : 6 à 8 Md€ de cotisations éludées par an ; récupération de {fraudeCotisations} M€ de cotisations et {fraudeTVA} M€ de TVA par an, en régime de croisière la troisième année ; le modèle applique sa fuite fiscale à ces recettes"
    leviers := [.prelevementSur .cotisations fraudeCotisations, .prelevementSur .tva fraudeTVA]
    debut := 2 }
]

def programme : Programme where
  id := "TexteOrientationD"
  nom := "Texte Orientation D"
  description := "Texte Orientation D : remplacement des voitures les plus polluantes, amendes SRU proportionnelles, attributions HLM vérifiables par preuve ZK, six EPR2, prime à l'électrique et bornes, retraite à la durée cotisée sans âge légal, IS au taux le plus bas de l'UE, démission indemnisée, moyens pour la justice, lignes nouvelles ferroviaires, qualité d'accueil touristique, conduite autonome avec indemnisation des taxis, prévention des accidents du travail, logiciel libre, universités (dette, reconstruction, Parcoursup, places), économies et recettes (apprentissage, commande publique, médicament, fraude)."
  mainteneurs := ["@orientationd"]
  source := "Programme de orientation_d (texte en cours de rédaction)"
  mesures := mesures

end Programmes.TexteOrientationD
