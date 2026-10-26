import Modele
import Hypotheses
import Proprietes

/-!
# Programme « Texte Orientation D »

Programme de orientation_d. Seuls les comptes listés dans `PROPRIETAIRES`
peuvent modifier ce dossier : la CI refuse toute autre PR (contrôle d'accès
aux programmes).

Mesures (extrait) :

* **O-01** — remplacement gratuit par l'État de 10 000 voitures Crit'Air 5
  chaque année. Balance commerciale à 5 et 10 ans : sous-modèle automobile.
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
* **O-08** — impôt sur les sociétés à deux points au-dessus du taux le plus
  bas de l'Union européenne (11 %).
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
* **O-24** — dette numérique : OAT tokenisées achetées en stablecoin euro
  (mécanisme USDC), intérêts exonérés de PFU pour les particuliers
  résidents.
* **O-25** — rémunération des enseignants +2 % par an ; **O-26** —
  automatisation des tâches administratives, 10 000 postes de contrôle
  supprimés par an pendant cinq ans ; **O-27** — simplification des tâches
  des généralistes, enquêteurs humains sur les cas anormaux.
* **O-28** à **O-34** — désindexation des très hautes retraites, TVA à
  22 %, taxe à l'atterrissage des jets privés, conversion électrique des
  exploitations agricoles, DPE et climatisation réversible dans les
  quartiers historiques, urbanisme (pas de tours en quartier historique,
  quartiers de gare), TER 24 h sur 24 avec agents de sécurité.
* **O-36** à **O-42** — redressement compatible avec les positions du PS :
  CSG sur les gros héritages, taxe numérique à 15 %,
  exonérations de cotisations, fraude fiscale et train de vie de l'État,
  niches fiscales, Pacte Dutreil divisé par deux et holdings, norme de
  dépense ; **O-43** défense −1 Md€ par an ; **O-44** 174 trimestres ;
  **O-45** lutte contre la fraude fiscale ; **O-46** CSG progressive pour
  les hauts revenus ; **O-47** 100 M€ par an de participations dans les
  entreprises stratégiques ; **O-48** non-renouvellement des concessions
  autoroutières ; **O-49** hauts fonctionnaires −5 % ; **O-50** revenus des
  élus plafonnés ; **O-51** fin du PFU ; **O-52** rachats d'actions ;
  **O-53** cabinets de conseil ; **O-54** à **O-58** trajectoire de baisse
  continue : CRDS prolongée, norme renforcée, aides aux entreprises,
  niches, durée de cotisation ; **O-59** à **O-62** face aux lois en
  vigueur ajoutées à la référence : CVAE maintenue, contribution
  exceptionnelle des grandes entreprises pérennisée, deuxième étape sur les
  aides aux entreprises et les niches ; **O-63** aide à la rénovation
  majorée de 25 % dans les territoires ruraux ; **O-64** à **O-66** eau
  potable et électrification de tous les foyers des outre-mer ; **O-67** et
  **O-68** dettes cachées (heures supplémentaires des policiers, RIFSEEP
  pour les enseignants) ; **O-69** à **O-73** troisième étape du
  redressement (CIR recentré, assurance-vie au barème, contribution des
  poids lourds, kérosène des vols intérieurs, défiscalisation des heures
  supplémentaires réduite de moitié) ; **O-74** heures supplémentaires non
  payées des hôpitaux publics ; **O-75** 100 000 places de prison en
  cellule individuelle ; **O-76** et **O-77** déficit et chômage en baisse
  à la fois (allègements recentrés sous 2 SMIC, accompagnement renforcé des
  demandeurs d'emploi) ; **O-78** à **O-81** indice de développement
  humain (prix minimum de l'alcool, prix du tabac, dépistage du cancer
  colorectal, scolarisation des 18-24 ans) ; **O-82** financement d'une loi
  intégrale contre les violences sexistes et sexuelles ; **O-83**
  allocations familiales dès le premier enfant ; **O-84** deuxième journée
  de solidarité affectée à l'autonomie.

Les valeurs marquées « hypothèse » restent à sourcer ou à arbitrer.
-/

namespace Programmes.TexteOrientationD
open Modele

/-! ## O-01 — Remplacement des 10 000 voitures les plus polluantes -/

/-- 10 000 citadines électriques à 25 000 € (hypothèse de prix) chaque
année, achetées sans critère d'origine : 73 % de la valeur importée,
puisque 27 % des voitures électriques vendues en France y sont fabriquées
(IMT, 2025). Voitures retirées : les plus polluantes, Crit'Air 5 et non
classées (diesel Euro 2 et antérieures ; 1,2 million de voitures au
1er janvier 2026, SDES), dont le modèle déduit les particules évitées
(7,5 fois la moyenne du parc thermique). Neuf vagues de 2027 à 2035 :
90 000 voitures, 7,5 % de ce parc. -/
def remplacement : Remplacement where
  nombre := 10000
  prixUnitaire := 25000
  partImporteePm := 730
  vignetteCritAir := 5

/-- Vagues annuelles de remplacement (2027 à 2035). -/
def vaguesRemplacement : Nat := 9

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

/-- Impôt sur les sociétés à 15 % (`tauxISCible`), le taux minimal du
pilier 2, contre 25 % en France (12 % dans la version précédente : taux
hongrois de 9 %, le plus bas de l'Union, plus trois points). À 15 %, le
plancher du pilier 2 ne joue plus : tous les groupes paient le même taux.

Le modèle commun applique désormais lui-même (levier `impotSocietes`, axe
économique) :

* le **minimum mondial (pilier 2)** : les groupes dont le chiffre
  d'affaires dépasse 750 M€ restent imposés à au moins 15 % effectifs
  (directive (UE) 2022/2523, impôt complémentaire national de la loi de
  finances pour 2024) ; la France perçoit elle-même le complément ;
* la **réponse de l'assiette** au taux effectif (bénéfices transférés ou
  relocalisés), par une semi-élasticité tirée de la littérature, au lieu
  du coefficient de retour d'assiette de 30 % que le programme fixait
  lui-même.

`tauxMinimumPilier2` ne sert plus qu'au calcul de O-60 (taux des grands
groupes). -/
def tauxISCible : Int := 1500
def tauxMinimumPilier2 : Int := 1500

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

/-- Emprise des lignes nouvelles (O-11) : 4 800 ha pour Bordeaux-Toulouse
et Bordeaux-Dax (Politis, 30 avril 2026, d'après le projet GPSO),
150 km × 10 ha/km pour Montpellier-Perpignan (longueur : préfecture de la
région Occitanie ; emprise moyenne d'une ligne à grande vitesse, étude des
impacts des LGV, débat public LGV PACA, 2004, p. 5), soit 630 ha par an
sur les dix ans de travaux. Accès au Lyon-Turin : pas de chiffre officiel,
non compté. Bordeaux-Toulouse et le Lyon-Turin figurent parmi les projets
d'envergure nationale de l'arrêté du 31 mai 2024 : sous le ZAN, leur
emprise s'impute sur l'enveloppe. -/
def surfaceLignesNouvellesHa : Int := (4800 + 150 * 10) / 10

/-- Qualité d'accueil touristique : six zones de rénovation (Le Grau-du-Roi
et cinq autres stations), 150 M€/an par zone pendant dix ans (hypothèse :
rénovation du bâti, espaces publics, mobilités). Effet attendu, hypothèse à
étayer (Atout France, études d'impact des stations rénovées) : +2 % de
visiteurs internationaux et +3 % de dépense par touriste, soit ≈ +3,6 Md€/an
de recettes touristiques sur 71 Md€. -/
def zonesTouristiques : Int := 6
def coutParZone : Int := 150

/-- Conduite autonome et taxis (O-13), par cohorte d'âge.

* Effectif : 62 800 taxis en 2024, autant d'autorisations de stationnement
  (ADS) (Observatoire national des T3P) ; titulaires exploitant eux-mêmes
  leur licence : `titulairesTaxi` = 40 000 (hypothèse : environ deux tiers
  des ADS, le reste étant détenu par des sociétés et des loueurs, surtout à
  Paris ; INSEE : 24 000 taxis non salariés sans salarié en 2016).
* Âges : 49 ans en moyenne, 2,4 % de moins de 30 ans, 12,8 % de 60 ans ou
  plus parmi les taxis non salariés (INSEE, « Les revenus d'activité des
  chauffeurs de taxi et de VTC », 2016). `pyramideTaxis` reconstitue des
  tranches (âge minimal, âge maximal, ‰), uniformes à l'intérieur, qui
  respectent ces trois repères (moyenne 49,3 ans).
* Indemnité : `indemniteTaxi` = 25 000 € par an et par titulaire
  (hypothèse : entre le revenu déclaré, 14 800 € en 2016 selon l'INSEE, et
  le chiffre d'affaires des artisans), versée de l'entrée en vigueur
  jusqu'à `ageRetraiteTaxi` = 64 ans (O-07 : 172 trimestres pour une
  carrière commencée vers 21 ans) ; rien pour ceux qui l'ont déjà atteint.
  Le coût s'éteint cohorte par cohorte (`indemnitesTaxis`).
* Emploi : les titulaires cessent l'activité à l'entrée en vigueur (rachat
  de la licence contre la rente). À partir de `ageSortieTaxi` = 55 ans
  (moins de dix ans d'indemnité), ils quittent la population active ; les
  plus jeunes restent actifs et se reclassent au rythme du scénario.
* Automatisation : +0,05 % de PIB (hypothèse : 0,3 % de PIB pour taxis,
  VTC et livraison, 15 % de gain de coût). -/
def titulairesTaxi : Int := 40000
def indemniteTaxi : Int := 25000
def ageRetraiteTaxi : Nat := 64
def ageSortieTaxi : Nat := 55
def pyramideTaxis : List (Nat × Nat × Int) :=
  [(25, 29, 24), (30, 39, 150), (40, 49, 310), (50, 59, 388), (60, 64, 98), (65, 69, 30)]

/-- Titulaires d'âge `a` parmi `n` (répartition uniforme dans la tranche). -/
def titulairesAge (n : Int) (a : Nat) : Int :=
  pyramideTaxis.foldl (fun acc (lo, hi, pm) =>
    if lo ≤ a ∧ a ≤ hi then acc + n * pm / (1000 * ((hi - lo + 1 : Nat) : Int)) else acc) 0

/-- Somme sur les âges 0 à 99 des titulaires (parmi `n`) qui vérifient `p`. -/
def titulairesSi (n : Int) (p : Nat → Bool) : Int :=
  (List.range 100).foldl (fun acc a => if p a then acc + titulairesAge n a else acc) 0

/-- Indemnités de l'année `k` après l'entrée en vigueur, M€ : titulaires
encore sous l'âge de départ × indemnité. Variante `seuilReconversion` :
sous cet âge, deux ans d'indemnité puis une formation de `formation` €
(versée la première année) au lieu d'une rente jusqu'à la retraite. -/
def indemnitesAnnee (n : Int) (seuilReconversion : Nat) (formation : Int) (k : Nat) : Int :=
  let rente := titulairesSi n (fun a => decide (seuilReconversion ≤ a) && decide (a + k < ageRetraiteTaxi))
  let reconvertis := titulairesSi n (fun a => decide (a < seuilReconversion) && decide (a + k < ageRetraiteTaxi) && decide (k < 2))
  let formations := if k = 0 then titulairesSi n (fun a => decide (a < seuilReconversion)) * formation else 0
  ((rente + reconvertis) * indemniteTaxi + formations) / 1000000

/-- Échéancier sur 40 ans (le plus jeune titulaire atteint 64 ans). -/
def indemnitesTaxis (n : Int) (seuilReconversion : Nat) (formation : Int) : List Int :=
  (List.range 40).map (indemnitesAnnee n seuilReconversion formation)

def sortiesTaxis (n : Int) : Int := titulairesSi n (fun a => decide (ageSortieTaxi ≤ a))

/-- Leviers de O-13 pour `n` titulaires. -/
def leviersTaxis (n : Int) (seuilReconversion : Nat) (formation : Int) : List Levier :=
  [.depenseEcheancier .famille (indemnitesTaxis n seuilReconversion formation),
   .automatisation 5 (titulairesSi n (fun _ => true)) (sortiesTaxis n)]

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

/-- Économies et recettes. Apprentissage : l'aide exceptionnelle à
l'embauche d'apprentis (3,9 Md€ en 2024, dont plus de la moitié pour le
supérieur) s'éteint pour les contrats conclus à partir de 2027 (décret
n° 2026-168, voir la référence) ; le programme maintient une aide réservée
aux niveaux infra-bac (CAP, bac) dans les entreprises de moins de 250
salariés, sur le modèle de l'aide unique de 2019 : ≈ 1 Md€ par an, les
3,9 Md€ de 2024 moins les 2,94 Md€ d'économies que la Cour des comptes
attend de ce recentrage (revue de dépenses, janvier 2025). Le recentrage,
naguère une économie de 2 Md€ par rapport à l'aide de 2025, est donc
désormais un coût par rapport à la référence. Commande publique : centrales d'achat, standardisation,
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
def aideApprentissageCiblee : Int := 1000
def economieCommandePublique : Int := 3000
def economieMedicament : Int := 2000
def coutAgenceMedicament : Int := 300
def investissementAgence : Int := 500
def fraudeCotisations : Int := 2000
def fraudeTVA : Int := 1000

/-- Enseignants (O-25). Masse salariale des enseignants hors CAS Pensions :
59,23 Md€ en 2026 pour 852 752 enseignants du public et du privé sous
contrat (PLF 2026, rapport du Sénat sur la mission Enseignement scolaire) ;
une hausse de 1 % du point d'indice coûte ≈ 0,5 Md€. Base 2027 :
`masseEnseignants2027` = 59,23 × 1,028 ≈ 60,9 Md€ (croissance tendancielle
des dépenses). Rémunération +2 % par an en plus de l'évolution tendancielle,
à partir de 2027 (échéancier sur vingt ans) : niveau atteint après k + 1 hausses = masse × (1,02^(k+1)
− 1), en euros de 2027, indexé ensuite comme la fonction enseignement. -/
def masseEnseignants2027 : Int := 60900
def revalorisationsEnseignants : List Int :=
  (List.range 20).map fun k =>
    masseEnseignants2027 * ((10200 : Int) ^ (k + 1) - (10000 : Int) ^ (k + 1)) / (10000 : Int) ^ (k + 1)

/-- Automatisation des contrôles administratifs (O-26). 10 000 postes par an
pendant cinq ans (50 000), non remplacés au départ en retraite. Coût complet
d'un poste de catégorie B ou C : `coutPosteControle` = 55 000 € par an
(hypothèse : salaire net moyen de la fonction publique de l'État 3 018 €
par mois en 2024, toutes catégories (DGAFP), plus bas en B et C, cotisations
employeur comprises hors pensions). Outil : `investissementParPoste` =
30 000 € par poste supprimé, la même année, et `maintenanceParPoste` =
3 000 € par an ensuite (hypothèses). -/
def postesControleParAn : Int := 10000
def coutPosteControle : Int := 55000
def investissementParPoste : Int := 30000
def maintenanceParPoste : Int := 3000

/-- Médecins généralistes (O-27). Les généralistes libéraux travaillent
54 h par semaine, dont 44 h 30 de soins et ≈ 5 h 30 de gestion et de
coordination ; 18 min par consultation ; 6,2 semaines de congés (DREES,
Études et résultats, mai 2019). `generalistesLiberaux` = 52 000 (ordre de
grandeur, à sourcer). Simplification : `heuresLibereesCentiemes` = 275,
soit la moitié des tâches administratives (2 h 45 par semaine). Temps
libéré : 52 000 × 2,75 h × 45,8 semaines ≈ 6,5 millions d'heures par an,
soit ≈ 3 200 généralistes à temps plein (44 h 30 de soins) ou ≈ 21,8
millions de consultations possibles. Les contrôles systématiques sont
remplacés par `enqueteurs` = 500 enquêteurs sur les cas anormaux, à
`coutEnqueteur` = 65 000 € (hypothèses). Sans hypothèse d'usage du temps
libéré, l'effet budgétaire est le seul coût des enquêteurs ; la variante
convertit le temps libéré en consultations remboursées (30 €, 70 % à la
charge de l'assurance maladie). -/
def generalistesLiberaux : Int := 52000
def heuresLibereesCentiemes : Int := 275
def semainesTravaillees10 : Int := 458
def enqueteurs : Int := 500
def coutEnqueteur : Int := 65000
/-- Heures de soin libérées par an, milliers. -/
def heuresLibereesMilliers : Int := generalistesLiberaux * heuresLibereesCentiemes * semainesTravaillees10 / 1000000
/-- Équivalents temps plein de généralistes (44,5 h de soins × 45,8 semaines). -/
def etpGeneralistesLiberes : Int := heuresLibereesMilliers * 1000 * 10 / (445 * semainesTravaillees10 / 10)
/-- Consultations possibles (18 min), milliers. -/
def consultationsMilliers : Int := heuresLibereesMilliers * 60 / 18
/-- Coût pour l'assurance maladie si elles sont réalisées, M€. -/
def coutConsultations : Int := consultationsMilliers * 30 * 700 / 1000000

/-- Désindexation des très hautes retraites (O-28). ≈ 17 millions de
retraités de droit direct ; 1 % perçoivent plus de 5 150 € bruts par mois,
6 470 € en moyenne (DREES, cité par le Journal de l'économie, août 2026).
Retenu : la revalorisation ne porte plus que sur la part de la pension sous
`seuilTresHautesRetraites` = 5 150 € (pas d'effet de seuil ni d'inversion de
rang) ; part au-delà : 170 000 × 1 320 € × 12 ≈ 2,69 Md€ en 2025, soit
`masseAuDelaSeuil` ≈ 2,85 Md€ en 2027 (× 1,057, tendance). Revalorisation
évitée : `inflationPb` = 180 (hypothèse : 1,8 % d'inflation, cohérente avec
3 % de croissance nominale et 1,2 % réelle). Économie après k + 1 gels, en
euros de 2027 : masse × (1 − 1/1,018^(k+1)). Suppose une loi s'appliquant
aussi aux régimes complémentaires (Agirc-Arrco, gérés par les partenaires
sociaux). Variante : gel de toute la pension au-delà du seuil (13,2 Md€ en
2025, 13,95 Md€ en 2027), avec effets de seuil. -/
def retraitesTresHautes : Int := 170000
def seuilTresHautesRetraites : Int := 5150
def pensionMoyenneTresHautes : Int := 6470
def inflationPb : Int := 180
def masseAuDelaSeuil : Int :=
  retraitesTresHautes * (pensionMoyenneTresHautes - seuilTresHautesRetraites) * 12 * 10570 / 10000000000
def masseTresHautes : Int := retraitesTresHautes * pensionMoyenneTresHautes * 12 * 10570 / 10000000000
def desindexation (masse : Int) : List Int :=
  (List.range 20).map fun k =>
    -(masse * ((10000 + inflationPb) ^ (k + 1) - (10000 : Int) ^ (k + 1)) / (10000 + inflationPb) ^ (k + 1))

/-- TVA (O-29) : taux normal porté de 20 % à 22 %. Un point de taux normal
rapporte un peu plus de 8 Md€ (FIPECO, IPP, Sénat, cités par L'Essentiel de
l'éco, septembre 2026) : rendement statique `tvaDeuxPoints` = 16 Md€, net de
la fuite fiscale du modèle. -/
def tvaDeuxPoints : Int := 16000

/-- Jets privés (O-30) : taxe forfaitaire de `taxeAtterrissage` = 3 000 € par
atterrissage. 84 885 vols de jets privés au départ de la France en 2022
(Greenpeace, repris par la proposition de loi n° 1741) ; atterrissages pris
égaux : `atterrissagesJets` = 85 000. Rendement statique 255 M€ ; la fuite
fiscale du modèle (20 % au scénario central) représente le report vers les
aéroports frontaliers et la baisse des vols. Variante : 1 000 €. -/
def atterrissagesJets : Int := 85000
def taxeAtterrissage : Int := 3000

/-- Conversion électrique des exploitations agricoles (O-31). 389 000
exploitations (recensement agricole 2020). Énergie de l'agriculture et de la
pêche : 52,1 TWh, dont 71 % de produits pétroliers (≈ 37 TWh, ≈ 3,7 Md de
litres ; ministère de la Transition écologique, Chiffres clés de l'énergie
2022), soit ≈ 10 Mt de CO₂ (0,27 t/MWh) : `emissionsEnergieAgricole`.
Plan sur dix ans : aide de `aideConversion` = 30 000 € par exploitation
(hypothèse : moitié d'un surcoût de 60 000 € pour les engins, la recharge
et une production photovoltaïque), soit ≈ 1,17 Md€ par an ; −1 Mt par an.
Commerce extérieur : carburant importé évité ≈ 2,0 Md€ (3,7 Md de litres ×
0,55 € hors taxes), électricité non exportée ≈ 0,84 Md€ (≈ 12 TWh au
rendement électrique, × 70 €/MWh) : −116 M€ d'importations nettes par an.
Les engins lourds électriques restent peu disponibles : l'objectif de
toutes les exploitations en dix ans est un plafond. -/
def exploitationsAgricoles : Int := 389000
def aideConversion : Int := 30000
def emissionsEnergieAgricole : Int := 10
def carburantAgricoleImporte : Int := 2000
def electriciteNonExportee : Int := 840

/-- DPE et climatisation réversible (O-32). Suppression du DPE pour les
immeubles de Paris et des autres quartiers historiques : pas d'effet
budgétaire ; évite le retrait du marché locatif des logements classés F et
G (interdiction de location, loi Climat et résilience). Climatisation
réversible (pompe à chaleur air-air) aidée : `logementsClimatisation` =
50 000 par an × `aideClimatisation` = 2 000 € = 100 M€ par an pendant dix
ans (hypothèses). Émissions : le remplacement du chauffage fossile (≈ 1 t
par logement et par an pour la moitié des logements équipés) et le moindre
effort de rénovation se compensent à moins de 1 Mt : effet non retenu. -/
def logementsClimatisation : Int := 50000
def aideClimatisation : Int := 2000

/-- Urbanisme (O-33). Interdiction des immeubles de grande hauteur dans les
quartiers historiques : sans effet budgétaire. Quartiers nouveaux autour des
pôles très desservis (Val de Fontenay : RER A et E, métro 1 et 15, tramway
T1) : aide aux équipements publics de `aideLogementQuartierGare` = 10 000 €
pour `logementsQuartiersGare` = 20 000 logements par an (hypothèses), soit
200 M€ par an d'investissement. -/
def logementsQuartiersGare : Int := 20000
def aideLogementQuartierGare : Int := 10000

/-- TER 24 h sur 24 (O-34) entre métropoles et villes moyennes (Paris –
Orléans…), avec agents de sécurité à bord, en gare et dans les parkings.
`liaisonsTerNuit` = 20 liaisons de `distanceTerKm` = 100 km ; de 0 h à 5 h,
un train par heure et par sens (`trainsParNuit` = 10). Coût :
`coutTrainKmCentimes` = 2 340 (23,40 € par train-km, moyenne des TER sous
convention SNCF, IFRAP 2024) ; sécurité : `heuresAgentsParNuit` = 46 (10 à
bord, 24 en gare, 12 aux parkings) à `coutHeureAgent` = 35 €. Recettes :
`couvertureRecettesPm` = 250 (hypothèse). La nuit est aussi la plage des
travaux d'entretien du réseau : contrainte d'exploitation non chiffrée. -/
def liaisonsTerNuit : Int := 20
def distanceTerKm : Int := 100
def trainsParNuit : Int := 10
def coutTrainKmCentimes : Int := 2340
def heuresAgentsParNuit : Int := 46
def coutHeureAgent : Int := 35
def couvertureRecettesPm : Int := 250
def coutTerNuit : Int :=
  liaisonsTerNuit * 365 * (trainsParNuit * distanceTerKm * coutTrainKmCentimes / 100
    + heuresAgentsParNuit * coutHeureAgent) * (1000 - couvertureRecettesPm) / 1000000000

/-- Redressement compatible avec les positions du PS (O-36 à O-42 ; la taxe
Zucman, O-35, a été retirée). Base :
propositions du groupe socialiste à l'Assemblée (16 septembre 2026 : taxe
Zucman 15 Md€, CSG sur les gros héritages 10 Md€, taxe sur les géants du
numérique 10 Md€, reconfiguration des exonérations de cotisations 4 Md€,
12,1 Md€ d'économies par la lutte contre la fraude fiscale et le train de
vie de l'État), complétées par la note de la Cour des comptes sur la
fiscalité du patrimoine (septembre 2026) et une revue des niches fiscales.
Les rendements sont statiques ; le modèle retire sa fuite fiscale (20 % au
scénario central) et calcule l'effet d'activité.

* Taxe Zucman (ancienne O-35) : retirée du programme.
* `csgHeritages` = 10 Md€ : chiffrage du groupe PS, sans contre-expertise
  connue (droits de succession et donations : 20,7 Md€ en 2025). Imputée
  à la ligne des droits de succession, dont elle partage l'assiette.
* `taxeNumerique` = 3,1 Md€ : taxe sur les services numériques de 3 % à
  15 %, 0,89 → ≈ 4 Md€ (commission des finances, octobre 2026). Le PS
  annonce 10 Md€ (variante). Risque de représailles commerciales.
* `exonerationsCotisations` = 4 Md€ : reconfiguration des allègements
  généraux (chiffrage PS). Comme O-56 et O-61, réduction des allègements
  au prorata des tranches de salaire (levier `reductionAllegements` : coût
  du travail et emploi par tranche, modèle commun) ; O-76 en recentre le
  reste sous 2 SMIC.
* `trainDeVieEtat` = 3,1 Md€ : part « train de vie » des 12,1 Md€ du PS,
  moins O-21 (commande publique, 3 Md€). La fraude fiscale fait l'objet
  d'une mesure propre (O-45).
* `nichesFiscales` = 8 Md€ : 465 niches pour 88,3 Md€ en 2026 (PLF 2026) ;
  −10 % hors Pacte Dutreil (traité à part) et hors dispositifs pour les
  ménages modestes, réparti entre IR (4), IS (2) et TVA (2).
* `pacteDutreil` = 1,95 Md€ : Pacte Dutreil divisé par deux, abattement de
  75 % à 37,5 %. La Cour des comptes (note du 21 septembre 2026) chiffre à
  1,3 Md€ le passage à 50 % (25 points, pactes futurs, comportements
  inchangés) ; même méthode, proportionnelle aux points d'abattement
  retirés : 1,3 × 37,5 / 25 = 1,95 Md€ (le dispositif coûtait 5,5 Md€ en
  2024). `holdings` = 1,0 Md€ (taxe sur les holdings élargie, même note).
* `normeDepense` = 50 pb : les dépenses pilotables (santé, affaires
  économiques, sécurité-justice, logement-environnement, culture, services
  généraux ; ≈ 739 Md€ en 2025) croissent de 2,3 % au lieu de 2,8 % par an,
  soit +0,5 % en volume pour 1,8 % d'inflation. Retraites, famille,
  enseignement et défense sont hors norme. Variante : zéro volume (100 pb).
-/
def csgHeritages : Int := 10000
def taxeNumerique : Int := 3100
def exonerationsCotisations : Int := 4000
def trainDeVieEtat : Int := 3100
def nichesFiscales : Int := 8000
def pacteDutreil : Int := 1950

/-- Défense (O-43) : −1 Md€ par an sur le budget de la défense (53 Md€ en
2025, COFOG), hors norme de dépense, par rapport à la trajectoire de la LPM
actualisée (loi n° 2026-791, 76,3 Md€ en 2030) que la référence applique. -/
def economieDefense : Int := 1000

/-- Durée de cotisation (O-44) : 174 trimestres au lieu de 172, soit six mois
de plus pour les départs liés à la durée. Sans âge légal (O-07), la durée est
la contrainte de la plupart des départs : plus de neuf retraités sur dix
liquident au taux plein, surtout au titre de la durée (COR, génération 1950) ;
les carrières incomplètes partent à l'âge du taux plein automatique.
`partDepartsDuree` = 800 ‰ (hypothèse) : âge moyen de départ reculé de
6 × 0,8 = 4,8 mois (levier `dureeCotisation`). Coût et actifs par mois : hypothèses économiques du
scénario (réforme de 2023). -/
def partDepartsDuree : Int := 800
def holdings : Int := 1000
def normeDepensePb : Int := 50

/-- Lutte contre la fraude fiscale (O-45), distincte de la fraude sociale et
de la TVA du travail dissimulé (O-23).
* Écart de TVA (conformité) : 12,1 Md€ en 2023, 5,6 % de la TVA théorique ;
  16,5 Md€ en estimation rapide pour 2024 (Commission européenne, VAT gap
  report 2025).
* Facturation électronique (émission obligatoire pour les grandes
  entreprises et ETI en septembre 2026, pour toutes en septembre 2027) :
  l'administration en attend 2 à 3 Md€ par an à terme (question écrite
  n° 17870, Assemblée nationale, 2026) : `fraudeFacturation` = 2,5 Md€ de
  TVA à partir de 2028.
* Contrôle fiscal : 11,4 Md€ encaissés en 2024 (+0,8 Md€ sur 2023), après
  ≈ 800 emplois créés en trois ans (DGFiP) ; la Cour des comptes (décembre
  2025) demande de chiffrer l'écart fiscal et d'évaluer le croisement de
  données. `agentsControle` = 1 500 agents de plus (vérificateurs,
  analystes de données) à `coutAgentControle` = 70 000 € ; encaissements
  supplémentaires `rendementControle` = 1,5 Md€ par an (hypothèse : ≈ 1 M€
  par agent, ordre de grandeur de la hausse récente), répartis entre IR,
  IS et TVA.
Le modèle applique sa fuite fiscale à ces recettes. -/
def fraudeFacturation : Int := 2500
def agentsControle : Int := 1500
def coutAgentControle : Int := 70000
def rendementControle : Int := 1500

/-- CSG progressive pour les hauts revenus (O-46) : +2 points de CSG sur la
part des revenus d'activité et de remplacement au-delà de `seuilCsgHauts`
= 100 000 € par an et par personne. Un point de CSG sur toute l'assiette
rapporte 17 Md€ (FIPECO, 2024). Part de l'assiette au-delà du seuil :
`partAssietteAuDelaPm` = 60 ‰ (hypothèse : ≈ 1 % des contribuables ;
extrapolation de Pareto, coefficient ≈ 2, depuis l'assiette de la
contribution exceptionnelle sur les hauts revenus, au-delà de 250 000 €).
Rendement statique : 2 × 17 Md€ × 6 % ≈ 2,0 Md€, net de la fuite fiscale
dans le modèle. À vérifier sur les données de la DGFiP. -/
def seuilCsgHauts : Int := 100000
def pointsCsgHauts : Int := 2
def partAssietteAuDelaPm : Int := 60
def rendementCsgHauts : Int := pointsCsgHauts * 17000 * partAssietteAuDelaPm / 1000

/-- Entreprises stratégiques (O-47) : 100 M€ par an de prises de participation
de l'État. Opération financière : dette sans déficit ; les dividendes suivent
le rendement du portefeuille de l'APE (4,0 Md€ de dividendes 2025 pour
209,1 Md€, soit ≈ 1,9 %). -/
def participationsStrategiques : Int := 100

/-- Concessions autoroutières (O-48) : pas de renouvellement à l'échéance,
exploitation publique, péages maintenus. Échéances (Arafer, 2018) : Sanef
31/12/2031, Escota 29/02/2032, SAPN 31/08/2033, APRR 30/11/2035, ASF
30/04/2036, AREA 30/09/2036, Cofiroute 31/12/2086.

Secteur en 2023 (Autorité de régulation des transports) : EBITDA 9,1 Md€,
dont ≈ 8,5 Md€ pour les sociétés historiques (93 % du réseau) ;
investissements 1,5 Md€ (92 % pour les historiques, ≈ 1,4 Md€) ; dividendes
4,1 Md€, soit l'ordre de grandeur du bénéfice net, d'où un IS estimé à
≈ 1,4 Md€ (taux de 25,8 %). Parts par société (‰ de l'EBITDA des
historiques), d'après la répartition des dividendes par groupe (ASF-Escota
40,6 %, APRR-AREA 24,3 %, Cofiroute 16 %, Sanef-SAPN 15,1 %) et la
longueur relative des réseaux dans chaque groupe (hypothèse).

Gain pour les administrations publiques à l'échéance : EBITDA − investissements
de renouvellement, recette non fiscale ; IS des concessionnaires en moins.
Une concession est comptée à partir de la première année pleine qui suit son
échéance (prudent). Valeurs 2023 portées en 2027 par la croissance nominale
(× 1,1255). Variante : baisse des péages de 20 % à la reprise. -/
def ebitdaHistoriques : Int := 8500
def investissementsHistoriques : Int := 1400
def isHistoriques : Int := 1400
def indice2023a2027 : Int := 11255
/-- (société, part en ‰, première année pleine après l'échéance, comptée depuis 2027). -/
def concessions : List (String × Int × Nat) :=
  [("Sanef", 118, 5), ("Escota", 76, 6), ("SAPN", 39, 7), ("APRR", 197, 9),
   ("ASF", 347, 10), ("AREA", 56, 10), ("Cofiroute", 167, 60)]
/-- Part du réseau historique revenue à l'État l'année `k` (comptée depuis 2027), ‰. -/
def partReprise (k : Nat) : Int :=
  concessions.foldl (fun acc (_, pm, an) => if an ≤ k then acc + pm else acc) 0
/-- Échéancier (20 ans) d'une grandeur 2023 répartie selon les reprises, M€ de 2027. -/
def echeancierReprise (montant2023 : Int) (facteurPm : Int := 1000) : List Int :=
  (List.range 20).map fun k =>
    montant2023 * indice2023a2027 / 10000 * partReprise k / 1000 * facteurPm / 1000

/-- Hauts fonctionnaires (O-49) : −5 % de rémunération pour l'encadrement
supérieur et dirigeant des trois versants. DGAFP (fin 2012) : 9 900 agents
dans l'État (7 700 € bruts par mois en moyenne), 5 600 dans l'hospitalière
(6 603 €), 6 000 dans la territoriale (5 898 €), soit 1 783 M€ bruts par an ;
× 1,10 pour 2025 (point d'indice et primes, hypothèse) et × 1,5 pour le coût
complet (cotisations employeur) : ≈ 2,94 Md€. Économie : 147 M€, dont 75 %
sur les services généraux (État et collectivités) et 25 % sur la santé. -/
def masseHautsFonctionnaires : Int := 1783 * 110 / 100 * 150 / 100
def economieHautsFonctionnaires : Int := masseHautsFonctionnaires * 5 / 100

/-- Revenus des élus (O-50) : plafond de 10 000 € par mois pour l'ensemble des
mandats et fonctions. Le droit en vigueur plafonne déjà le cumul des
indemnités et rémunérations à une fois et demie l'indemnité parlementaire de
base, soit 8 897,93 € bruts par mois depuis le 1er janvier 2024 (article
L. 2123-20 II du CGCT ; Ville de Paris, 2025). Un plafond de 10 000 € est
donc moins strict : la mesure n'a d'effet qu'en étendant le plafond aux
rémunérations qui y échappent (organismes extérieurs, sociétés publiques),
dont le montant n'est pas publié. Enregistrée pour mémoire, sans effet
budgétaire. -/
def plafondElus : Int := 10000
def plafondCumulActuel : Int := 8898

/-- Fin du prélèvement forfaitaire unique (O-51) : retour au barème de l'IR
pour les revenus du capital, chiffrage PS de longue date. Institut
Montaigne (2024) : +3,2 à 3,6 Md€ par an à comportements inchangés ; perte
de 0,7 Md€ si l'assiette des dividendes revient à son niveau de 2017
(variante). Retenu : 3,4 Md€ statiques. Interaction avec O-24 : les intérêts
des OAT numériques restent exonérés. -/
def finPfu : Int := 3400

/-- Rachats d'actions (O-52) : taxe de 8 % (loi de finances pour 2025,
entreprises de plus de 1 Md€ de chiffre d'affaires) portée à 20 %. Un
amendement à 33 % annonçait 8,4 Md€, soit une assiette implicite d'environ
25 Md€ ; +12 points donneraient 3 Md€ mécaniquement. Les entreprises peuvent
remplacer les rachats par des dividendes : rendement retenu 1,5 Md€ (moitié,
hypothèse). -/
def rachatsActions : Int := 1500

/-- Cabinets de conseil (O-53) : dépenses de conseil des ministères 893,9 M€
en 2021 (commission d'enquête du Sénat, 2022). Division par deux, au profit
de l'expertise interne : `economieConseil` = 400 M€ (sur une base supposée
ramenée à 800 M€ depuis la circulaire de 2022). -/
def economieConseil : Int := 400

/-- Trajectoire de baisse continue du déficit (O-54 à O-58). Sans elles, le
déficit du Texte Orientation D baisse en 2027 puis remonte d'environ
0,2 point par an : la charge d'intérêts passe de 2,6 % à 4,6 % du PIB, le
taux apparent rejoignant le taux de marché. Pour qu'il baisse chaque année,
il faut des mesures dont le rendement croît chaque année plus vite que les
intérêts :

* O-54 : prolongation de la CRDS au-delà de 2033 pour amortir la dette de
  l'ACOSS (59,4 Md€ fin 2025, ≈ 65 Md€ fin 2026, sans ressource dédiée) :
  9,55 Md€ (euros 2027) à partir de 2034 ; loi organique nécessaire.
* O-55 : norme de dépense renforcée de 100 pb (soit 150 pb avec O-42) :
  dépenses pilotables à +1,3 % par an en valeur, ≈ −0,5 % en volume.
* O-56 : aides aux entreprises (211 Md€ selon la commission d'enquête du
  Sénat, juillet 2025) : exonérations de cotisations réduites de 1,5 Md€
  par an pendant six ans (9 Md€ en 2032), en les conditionnant.
* O-57 : niches fiscales : −2 % par an pendant cinq ans en plus de O-40
  (≈ 2 Md€ par an : IR 1, IS 0,5, TVA 0,5).
* O-58 : durée de cotisation +1 trimestre tous les trois ans à partir de
  2028, dans la logique de la réforme de 2014 : +1 mois de durée requise
  par an, 80 % des départs concernés (`partDepartsDuree`).
-/
def crdsProlongee : List Int := (List.range 20).map fun k => if k < 7 then 0 else 9550
def normeRenforceePb : Int := 100
def baisseAidesEntreprises : Int := 1500
def rabotNiches : Int := 2000

/-- Lois de finances en vigueur que la référence applique désormais (O-59,
O-60) :

* O-59 : la CVAE disparaît par étapes (0,28 % en 2027, 0,19 % en 2028,
  0,09 % en 2029, 0 en 2030 ; loi n° 2025-127, art. 62). Son maintien à
  0,28 % rapporte, par rapport à la référence, 1,09 puis 2,31 puis
  3,4 Md€ (euros 2025), soit ×1,0609 en euros 2027 (croissance nominale de
  3 % par an du scénario central) : `cvaeMaintenue`.
* O-60 : la contribution exceptionnelle sur les bénéfices des grandes
  entreprises (7,5 Md€ en 2026) n'est pas reconduite à législation
  constante. Pérennisée aux taux de 2026 (20,6 % et 41,2 % de l'IS dû au-delà
  de 1,5 et 3 Md€ de chiffre d'affaires), elle porte sur l'IS des seuls
  grands groupes, tous soumis au pilier 2 : avec O-08, leur taux effectif
  est de 15 %, d'où 7,5 × 15 / 25 = 4,5 Md€ (euros 2026), 4,64 Md€ en euros
  2027 : `contributionGrandesEntreprises`. -/
def cvaeMaintenue : List Int := [0, 1156, 2451, 3607]

/-- Deuxième étape de la trajectoire (O-61, O-62). Une fois la référence
complétée par les lois en vigueur (LPM actualisée, érosion des accises par
l'électrification, fin de la contribution exceptionnelle et de la CVAE),
le déficit du Texte Orientation D stagne de 2029 à 2032 (≈ 4,6 %) : la
LPM monte jusqu'en 2030, la charge d'intérêts continue de croître et l'âge
moyen de départ cesse de suivre le calendrier légal en 2032 (O-07). Il
faut ≈ 1,5 à 2 Md€ de rendement supplémentaire chaque année de 2029 à 2032
(un peu plus du double en statique, la moitié étant reprise par la baisse
d'activité au moteur de demande) :

* O-61 : aides aux entreprises, deuxième étape : exonérations de
  cotisations réduites de 1,5 Md€ de plus chaque année de 2029 à 2034, sous
  conditions (emploi, salaires, investissement) ; avec O-38 et O-56, 22 Md€
  sur ≈ 80 Md€ d'allègements généraux en 2034.
* O-62 : niches fiscales : −1,5 Md€ de plus chaque année de 2029 à 2035
  (−1 Md€ dans la version précédente ; relevé avec le modèle affiné pour
  que le déficit baisse chaque année sous les trois moteurs) ; avec O-40 et
  O-57, 28,5 Md€ sur 88,3 Md€ de dépenses fiscales en 2035 (hors Pacte
  Dutreil, traité par O-41, et dispositifs des ménages modestes). -/
def aidesSecondeEtape : Int := 1500
def nichesSecondeEtape : Int := 1500

/-- Deuxième journée de solidarité (O-84) : sept heures de travail non
rémunérées de plus par an (+0,44 % de durée annuelle du travail sur
1 607 heures, levier `dureeTravail`), contribution de solidarité pour
l'autonomie des employeurs portée de 0,3 % à 0,6 % de la masse salariale,
affectée à l'autonomie (dépense de santé, au sens de la nomenclature du
modèle). Reprend la contribution de solidarité par le travail votée par le
Sénat le 20 novembre 2024 (PLFSS 2025, amendement adopté par 216 voix
contre 119), chiffrée à ≈ 2,5 Md€ par an. -/
def heuresSolidaritePm : Int := 4
def contributionSolidariteAutonomie : Int := 2500

/-- Santé mentale (O-85) : 100 M€ de moyens de plus par an. Ordre de
grandeur : 23 Md€ remboursés chaque année par l'Assurance maladie pour les
troubles psychiques et les maladies psychiatriques, son premier poste de
dépenses (La Banque Postale, d'après le ministère de la Santé, 24 avril
2025) ; la santé mentale est grande cause nationale 2025. -/
def santeMentale : Int := 100

/-- Liberté fiscale des collectivités (O-86). Taxe foncière : chaque commune
vote son taux, au plus 2,5 fois le taux moyen de l'année précédente dans le
département ou en France (CGI, art. 1636 B septies : plafond de 99,35 % en
2025 pour un taux moyen national de 39,74 %, DGCL), et sous les règles de
lien entre les taux (art. 1636 B sexies) ; la mesure lève plafond et liens.
Taxe d'habitation des résidences principales, supprimée de 2020 à 2023 :
15,3 Md€ perdus par les communes et 7,5 Md€ par les intercommunalités, tous
compensés (DGCL, FAQ de la refonte de la fiscalité locale) ; la mesure
permet de la rétablir, les compensations restant acquises. Sans effet sur
le solde à taux inchangés ; le rétablissement partiel est évalué en
variante. -/
def produitTaxeHabitation : Int := 15300 + 7500

/-- Référendum d'initiative citoyenne (O-87), par révision de la
Constitution (article 89). Un référendum coûte ≈ 200 M€, ≈ 100 M€
dématérialisé (ministre de l'Intérieur, RTL, 11 mai 2025, via Acteurs
publics). Hypothèse : un scrutin par an, non couplé à une élection. -/
def coutReferendum : Int := 200

/-- Médecins scolaires (O-88) : 818 en 2022 contre 1 143 en 2013 (Sénat,
proposition de loi du 13 mars 2024), un pour 13 300 élèves, 44 % des postes
vacants (La Revue du praticien, 19 janvier 2026) ; la Cour des comptes
(avril 2020) juge une revalorisation « indispensable ». La mesure double
l'effectif : 800 médecins de plus en quatre ans (un pour 6 700 élèves
environ), à 100 000 € par médecin et par an, traitement, indemnités
revalorisées pour pourvoir les postes et cotisations de l'employeur
comprises (hypothèse). -/
def medecinsScolairesNouveaux : Int := 800
def coutMedecinScolaireEuros : Int := 100000

/-- Octroi de mer (O-89) : 1,644 Md€ de recettes nettes en 2022 (Cour des
comptes, 5 mars 2024, via economie.gouv.fr), dont 75,8 % pour les communes
(32 % de leurs produits de gestion), le reste pour les régions ; +4,64 % par
an de 2014 à 2022, prolongés jusqu'en 2025 : 1 883 M€ (calcul). Suppression
compensée aux collectivités par une dotation de l'État : la recette
disparaît, les prix baissent dans les cinq départements et régions
d'outre-mer. -/
def octroiDeMer2025 : Int := 1644 * 10464 * 10464 * 10464 / 1000000000000

theorem octroiDeMer2025_eq : octroiDeMer2025 = 1883 := by decide

/-- Pompes à chaleur gratuites en zone rurale (O-90) : 100 000 par an
(hypothèse : un million de maisons en dix ans, sur plus de 1,56 million de
résidences principales rurales chauffées au fioul, Insee Première
n° 2088), à 14 700 €, coût moyen d'une PAC air/eau (gouvernement, « Pompes
à chaleur, l'industrie au service de la planification écologique »). Elles
consomment une part du surplus d'électricité que le nucléaire module faute
de débouchés. Les logements qui quittent le gaz de réseau évitent ≈ 67 €
par an de charges d'exploitation au gestionnaire du réseau, reversés au
financement de la mesure (hypothèse de transcription) ; chaleur,
coefficient de performance, énergies remplacées, taxes : voir
`Hypotheses.Energie.pompesAChaleur`. -/
def pacRuralesParAn : Int := 100000
def coutPacEuros : Int := 14700

/-- Zones d'électrification industrielle (O-91), à tarif d'électricité
négocié et hors ZAN.
* Électricité : les zones portent la consommation de l'industrie de la
  trajectoire « décarbonation lente » (+4 TWh de 2024 à 2030) à la
  trajectoire « rapide » (+13 TWh) du bilan prévisionnel 2025 de RTE, soit
  9 TWh de plus, atteints en cinq ans ; à 40 % de facteur de charge
  (hypothèse de RTE pour les projets industriels), 2 568 MW de projets
  (calcul).
* Emplois : 4 700 emplois annoncés à Dunkerque (ProLogium 3 000, XTC-Orano
  1 700 ; AFP) pour 1 615 MW de raccordements signés (CRE, délibération
  2026-21 du 27 janvier 2026), soit 7 473 emplois industriels (calcul).
* Foncier : 35 000 emplois sur 3 026 ha de sites industriels clés en main
  commercialisés depuis 2019 (DGE, 16 octobre 2026), soit 646 ha (calcul),
  exemptés de l'enveloppe du ZAN.
* Tarif : contrats de long terme d'EDF (cible de 70 €/MWh en moyenne de
  l'accord État-EDF de 2023) pour une électricité que le parc nucléaire
  module faute de débouchés : sans coût budgétaire ; le gain d'EDF n'est
  pas compté. -/
def zonesGwh : Int := 13000 - 4000
def zonesMw : Int := zonesGwh * 1000 / 3504
def zonesEmplois : Int := zonesMw * 4700 / 1615
def zonesHa : Int := zonesEmplois * 3026 / 35000

theorem zones_valeurs : zonesMw = 2568 ∧ zonesEmplois = 7473 ∧ zonesHa = 646 := by decide

/-- Déserts médicaux (O-92) : aide à la première installation d'un médecin
généraliste en zone d'intervention prioritaire (ZIP) portée à 50 000 €,
montant de l'ancien contrat d'aide à l'installation (CAIM), au lieu de
10 000 € depuis le 1er janvier 2026 (convention médicale de 2024) ; puis
5 000 € par an pendant cinq ans à chaque médecin installé, montant de
l'ancien contrat de stabilisation (COSCOM). 891 premières installations
de généralistes en ZIP en 2025 (Cnam, 11 juin 2026). La Cour des comptes
(12 novembre 2025) juge ces aides peu efficaces hors exercice coordonné :
l'effet sur l'accès aux soins n'est pas chiffré. -/
def installationsZip : Int := 891
def aideInstallationZip : Int := 50000 - 10000
def primeExerciceZip : Int := 5000
def primesZip : List Int :=
  ([1, 2, 3, 4, 5] : List Int).map fun k => installationsZip * primeExerciceZip * k / 1000000

/-- Minimum de pension des retraités agricoles (O-93) : garantie des chefs
d'exploitation à carrière complète portée de 85 % à 100 % du SMIC net
agricole (85 % : 1 214,40 € par mois en 2026, soit +214,30 € au plancher).
224 681 bénéficiaires du complément différentiel fin 2025 (MSA, tableau de
bord des retraites des non-salariés agricoles, septembre 2026) :
224 681 × 214,30 € × 12 = 577 M€ par an (calcul ; trop haut pour les
carrières incomplètes, dont la garantie est proratisée, trop bas faute des
nouveaux bénéficiaires entre 85 % et 100 %). -/
def minimumAgricole : Int := 224681 * 21430 * 12 / 100000000

theorem minimumAgricole_eq : minimumAgricole = 577 := by decide

/-- Emplois aidés dans l'industrie (O-94) : 20 000 contrats initiative
emploi en cours dans l'industrie (hypothèse), aide de 47 % du SMIC brut,
plafond du CIE (circulaire FIE 2025), sur un temps plein : 10 160 € par
contrat et par an (calcul) ; 0,16 emploi net par CIE (Dares, via FIPECO,
19 septembre 2017) : aubaine et substitution de 840 pm. -/
def contratsIndustrie : Int := 20000
def aideCieEuros : Int := 10160

/-- Accompagnement des entreprises en cybersécurité (O-98).
* Chèque cyber : 50 % des dépenses de sécurité, au plus 2 500 € pour une TPE
  et 10 000 € pour une PME, sur le modèle du chèque investissement cyber de
  l'Île-de-France (fermé le 21 février 2025) ; 40 000 TPE et 10 000 PME par
  an (hypothèse ; 16 % des TPE-PME ont subi un incident en douze mois, 77 %
  dépensent moins de 2 000 € par an en sécurité et 37 % demandent une aide
  financière : baromètre Cybermalveillance-OpinionWay, 7 octobre 2025) :
  200 M€ par an.
* Cybermalveillance.gouv.fr porté à 3 M€ de financement public, le minimum
  recommandé par le Sénat (subvention de l'ANSSI inchangée à 0,845 M€ par an
  depuis 2017 : Sénat, avis n° 141, 19 novembre 2025).
* CSIRT régionaux : 1 M€ par région métropolitaine sur trois ans, comme la
  première vague financée par l'ANSSI en 2022, arrêtée depuis : 13 M€ / 3
  par an.
Les cyberattaques ont coûté ≈ 2 Md€ aux entreprises en 2022 (Asterès) :
l'effet de la mesure sur ce coût n'est pas chiffré. -/
def chequesCyber : Int := (40000 * 2500 + 10000 * 10000) / 1000000
def cyberGipCsirt : Int := (3000 - 845 + 13000 / 3) / 1000

theorem chequesCyber_eq : chequesCyber = 200 ∧ cyberGipCsirt = 6 := by decide

/-- Amendes renforcées en cas de fuite de données (O-99). Le RGPD,
règlement européen, plafonne l'amende d'un défaut de sécurité à 2 % du
chiffre d'affaires mondial ou 10 M€ (art. 83.4) ; la France ne peut pas
le relever seule, mais elle peut relever les plafonds de la directive
NIS2, qui sont des minimums (au moins 2 % pour les entités essentielles,
1,4 % pour les importantes), dans la loi de transposition encore en
discussion (report du 6 octobre 2026), et les amendes pénales des
personnes morales (art. 226-17 et 131-38 du code pénal). La mesure les
porte à 4 % et 2,8 % du chiffre d'affaires mondial et demande le même
relèvement du RGPD. Les amendes suivent un pourcentage du plafond légal
selon la gravité (lignes directrices 04/2022 du CEPD) : à gravité égale,
doubler le plafond double les amendes pour défaut de sécurité, ≈ 20 M€ par
an de 2023 à 2026 (Amazon France Logistique 32 M€ en 2023, Mobius 1 M€ en
2025, Free 42 M€ et France Travail 5 M€ en 2026 ; calcul), versées au
budget de l'État. L'effet dissuasif n'est pas chiffré. -/
def amendesFuitesSupplementaires : Int := (32 + 1 + 42 + 5) / 4

theorem amendesFuites_eq : amendesFuitesSupplementaires = 20 := by decide

/-- Rénovation énergétique en territoire rural (O-63) : l'aide à la
rénovation (MaPrimeRénov', 13 000 € en moyenne en 2026) est majorée de 25 %
dans les communes rurales, `bonusRenovationRurale` = 3 250 € par
rénovation. Les ménages ruraux se chauffent deux fois plus souvent au
fioul (16,7 % contre 8,5 %, INSEE 2026) : chaque rénovation y évite plus
de CO₂ et d'importations. Le modèle commun (sous-modèle rénovation de l'axe
énergie) en déduit le coût, dont la majoration versée aux rénovations qui
auraient eu lieu sans elle, et les rénovations suscitées. -/
def bonusRenovationRurale : Int := 3250

/-- Eau potable outre-mer (O-64). La Cour des comptes (mars 2025) chiffre à
2,36 Md€ les investissements nécessaires dans les DROM et à Saint-Martin,
dont 1,52 Md€ pour l'eau potable et 841 M€ pour l'assainissement (Mayotte
743 M€, La Réunion 688 M€, Guadeloupe 375 M€) ; le plan Eau-DOM n'en a
couvert qu'environ 10 %. Situation : 25 % des ménages de Mayotte sans eau
courante en 2024 et des coupures quotidiennes pour 63 % des raccordés
(INSEE Analyses Mayotte n° 42, juin 2026) ; 15 % de la population de Guyane
sans eau potable du réseau public (réponse ministérielle, JO du
23 décembre 2025) ; 25 % des Guadeloupéens soumis aux tours d'eau,
rendement des réseaux de 32 % (Sénat, rapport n° 440, mars 2025). La loi
de programmation pour la refondation de Mayotte (n° 2025-797) prévoit déjà
730 M€ : le programme finance le reste, 1,63 Md€ (euros 2027) sur cinq
ans, `eauOutreMer` = 326 M€ par an de 2027 à 2031. Les collectivités du
Pacifique (Polynésie : 62 % de la population desservie en eau conforme en
2024 ; Nouvelle-Calédonie, Wallis-et-Futuna) relèvent de leurs propres
compétences : non chiffrées. -/
def eauOutreMer : Int := 326

/-- Électrification totale des outre-mer (O-65). Logements sans électricité
(INSEE, 2026) : 19 % à Mayotte en 2024, soit ≈ 15 400 ménages (calcul :
323 153 habitants, 4 personnes par ménage) ; 7 % en Guyane, ≈ 6 700
ménages (hypothèse : ≈ 95 000 résidences principales), surtout dans les
communes de l'intérieur (60 % des logements électrifiés, IEDOM 2021). Coût
par foyer non publié : hypothèses de 5 000 € pour un raccordement au réseau
(Mayotte) et de 20 000 € pour un site isolé (micro-réseau solaire avec
stockage, Guyane), soit 77 + 134 = 211 M€ sur trois ans,
`electrificationOutreMer` = [70, 70, 71] M€ ; puis le surcoût de
production de l'électricité consommée par les 22 100 foyers raccordés
(péréquation des zones non interconnectées, modèle commun),
`foyersRaccordesParAn` = 7 367 par an pendant trois ans. -/
def electrificationOutreMer : List Int := [70, 70, 71, 0]

/-- Dettes cachées (O-67, O-68).

* O-67 : paiement immédiat du stock d'heures supplémentaires non payées des
  policiers (passif implicite suivi par le modèle commun : 189 M€, 14,3
  millions d'heures à 13,22 €), en 2027, comme des heures supplémentaires
  (exonérées d'impôt sur le revenu). Au coût complet retenu par la Cour
  des comptes en 2020 (25,6 €/h), le stock vaudrait 366 M€.
* O-68 : RIFSEEP pour les enseignants, c'est-à-dire l'alignement de leurs
  primes sur celles des autres agents de catégorie A. Les primes font
  17,2 % du salaire brut des enseignants contre 32,9 % pour les autres
  agents de catégorie A (DGAFP, rapport annuel 2025, données 2023) ; le
  rapport primes / traitement passe de 0,208 à 0,490, soit +0,283 × un
  traitement de ≈ 38 750 € : ≈ 10 950 € bruts par enseignant et par an,
  × 693 400 enseignants fonctionnaires du public (DEPP, rentrée 2025) =
  7,6 Md€, 8,0 Md€ en euros 2027 (`rifseepEnseignants`). Les primes ne
  donnent pas lieu à RAFP (déjà au plafond de 20 % du traitement) ; la
  CSG et l'impôt sur le revenu en reviennent (≈ 24,5 %). Aucun chiffrage
  officiel ni contentieux de rattrapage n'a été trouvé : chiffrage par le
  programme. Variante : montée en charge sur cinq ans. -/
def rifseepEnseignants : Int := 8000

/-- Baisse du déficit, troisième étape (O-69 à O-73), pour financer O-67 et
O-68 :

* O-69 : crédit d'impôt recherche plafonné par groupe à 50 M€ et
  suppression du taux de 5 % au-delà de 100 M€ de dépenses : ≥ 960 M€
  (IGF, revue de dépenses, mars 2024) ; mesure défendue par le groupe
  socialiste (amendements AN I-754 et Sénat I-674 au PLF 2026). Le CIR
  coûte ≈ 8 Md€, les 50 premiers bénéficiaires en reçoivent 43 % ; sans
  effet significatif sur la R&D des grandes entreprises (CNEPI, 2021).
* O-70 : assurance-vie au barème des successions en ligne directe, à
  partir de la tranche à 20 %, au-delà de 250 000 € par bénéficiaire (au
  lieu des 152 500 € d'abattement actuels). Le Conseil des prélèvements
  obligatoires chiffre à ≈ 1,25 Md€ à terme la même réforme avec
  l'abattement de 152 500 € (rapport du 1er décembre 2025, recommandation
  n° 6). Relever le seuil de 97 500 € allège tous les bénéficiaires de plus
  de 152 500 € (jusqu'à 97 500 × 20 % = 19 500 € chacun), alors que le gain
  du barème vient des très gros contrats (≈ 2 000 défunts, 7 M€ en
  moyenne) : rendement retenu, la moitié, `assuranceVieBareme` = 625 M€
  (hypothèse ; aucun chiffrage publié pour ce seuil). Ligne des droits de
  succession.
* O-71 : contribution kilométrique nationale des poids lourds sur le réseau
  non concédé (≈ 15 000 km, l'assiette de l'écotaxe de 2014) : 1 129 M€
  bruts à 0,13 €/km selon la Cour des comptes (rapport public 2017),
  `ecotaxePoidsLourds` = 1 350 M€ avec ≈ 20 % d'inflation depuis 2014
  (hypothèse). Assiette implicite : 8,7 milliards de véhicules-kilomètres,
  ≈ 29 % du trafic des poids lourds (≈ 30 milliards, ordre de grandeur) :
  émissions visées 29 % × 26,7 Mt (Citepa, 2024). Hausse du coût : 0,156 €
  pour ≈ 1,4 € par kilomètre (coût complet, ordre de grandeur), 11 %. Le
  modèle applique l'élasticité-prix (report modal compris).
* O-72 : accise sur le kérosène des vols intérieurs métropolitains au taux
  du gazole (59,40 €/MWh) : 0,476 Mt de kérosène (1,5 Mt de CO₂, DGAC 2024,
  3,15 t de CO₂ par tonne), 5,7 TWh, ≈ 340 M€ avant comportements (calcul) ;
  ≈ 13,6 € par passager pour ≈ 25 millions de passagers et un billet moyen
  de ≈ 130 € (ordres de grandeur) : +10 % de coût. Outre-mer exclu
  (continuité territoriale).
* O-73 : défiscalisation des heures supplémentaires (loi de 2019) réduite
  de moitié : exonération d'impôt sur le revenu (≈ 2,0 Md€ en 2026 ;
  1,79 Md€ en 2025, ≈ 2,3 Md€ en 2027, Voies et moyens) et réduction de
  cotisations salariales (2,31 Md€ en 2026, annexe 4 du PLFSS 2026)
  divisées par deux, par exemple plafond d'exonération ramené de 7 500 € à
  3 750 € et réduction de cotisations de 11,31 % à 5,66 % : la moitié des
  deux coûts, `partDefiscalisationSupprimeePm` = 500 (rendement supposé
  proportionnel). La loi TEPA n'avait pas augmenté les heures travaillées
  (Cahuc et Carcillo, 2014) : pas d'effet sur les heures, la fuite fiscale
  du modèle couvrant l'optimisation des déclarations. -/
def cirRecentre : Int := 960
def assuranceVieBareme : Int := 625
def assuranceVieBaremeCpo : Int := 1250
def ecotaxePoidsLourds : Int := 1350
def emissionsPoidsLourdsVisees : Int := 26700 * 29 / 100
def kerosene : Int := 340
def heuresSupIr : Int := 2000
def heuresSupCotisations : Int := 2310
def partDefiscalisationSupprimeePm : Int := 500
def foyersRaccordesParAn : Int := 7367

/-- Hôpitaux et prisons (O-74, O-75).

* O-74 : paiement immédiat du stock d'heures supplémentaires non payées ni
  récupérées des hôpitaux publics (passif implicite suivi par le modèle
  commun, `passifsHopital2025` = 720 M€ : 20,8 heures par agent non médical
  et 6,1 demi-journées par médecin, bilan social ATIH 2022, rapportés aux
  effectifs DREES 2024 ; 463 M€ fin 2018 selon la Cour des comptes), en
  2027, comme des heures supplémentaires, sur la fonction santé (les
  hôpitaux publics sont des administrations de sécurité sociale, financées
  à 76,8 % par l'Assurance maladie, DREES 2026). Les comptes épargne-temps
  (≈ 2,6 Md€, provisionnés au moins en partie) ne sont pas payés.
* O-75 : 100 000 places de prison, toutes en cellule individuelle. Au
  1er août 2026 : 63 303 places opérationnelles pour 89 668 détenus
  (densité 141,6 %, 7 956 matelas au sol, 32,3 % des détenus seuls en
  cellule ; ministère de la Justice). Le principe de l'encellulement
  individuel (1875, loi pénitentiaire de 2009) est suspendu par moratoire
  jusqu'au 31 décembre 2027 : la mesure le rend effectif à mesure que les
  places ouvrent. Le plan 15 000 (5 411 places nettes livrées en
  septembre 2025, achèvement en 2031-2032, 5,7 Md€ ; Cour des comptes,
  17 décembre 2025) apporte encore `placesPlan15000Restantes` = 9 589
  places, financées par les crédits immobiliers de l'administration
  pénitentiaire que la tendance des dépenses reconduit (hypothèse) ; la
  mesure finance le reste, `placesPrisonNouvelles` = 27 108 places.
  - Construction : 270 k€ par place nette, coût moyen du plan 15 000 (Cour
    des comptes ; 450 k€ pour les centres pénitentiaires, variante ;
    ≈ 200 k€ en modulaire selon le ministère), soit 7,3 Md€, versés de 2027
    à 2035 (`calendrierConstructionPm`) ; premières places en 2030 en
    construction modulaire (≈ 18 mois), établissements classiques ensuite
    (≈ 7 ans de la recherche foncière à la livraison). Livrer 36 700 places
    de 2030 à 2035, plan 15 000 compris, suppose un rythme près de sept fois
    celui du plan 15 000 ; le rapport Hetzel (Assemblée nationale, 2023)
    juge un tel programme irréalisable en moins de dix ans : délai à
    risque, coût de l'horizon prudent.
  - Fonctionnement des places ouvertes (`ouverturePlacesPm`) : 0,48
    surveillant par place (2 587 emplois ouverts pour 5 411 places, Cour
    des comptes) × 80 800 € (2,9 Md€ pour 35 879 agents de surveillance,
    PAP 2026) = 38 784 €, plus 6 200 € d'entretien et d'énergie (moitié des
    frais hors personnel de la journée de détention, 129,33 € dont 95,48 €
    de personnel en 2024 ; hypothèse : alimentation et frais par détenu
    inchangés, les détenus étant déjà incarcérés) : 44 984 € par place et
    par an, 1,22 Md€ et ≈ 13 000 surveillants une fois les places ouvertes,
    en plus du déficit actuel de 4 000 à 6 000 postes. -/
def placesPrisonCible : Int := 100000
def placesOperationnelles2026 : Int := 63303
def placesPlan15000Restantes : Int := 15000 - 5411
def placesPrisonNouvelles : Int := placesPrisonCible - placesOperationnelles2026 - placesPlan15000Restantes
def coutPlacePrisonKEuros : Int := 270
def coutPlacePrisonCpKEuros : Int := 450
/-- Part du coût de construction versée chaque année, de 2027 à 2035, ‰. -/
def calendrierConstructionPm : List Int := [20, 41, 82, 150, 191, 191, 164, 109, 52, 0]
/-- Part des places nouvelles ouvertes, de 2027 à 2035, ‰. -/
def ouverturePlacesPm : List Int := [0, 0, 0, 55, 184, 369, 590, 812, 1000]
def surveillantsParPlacePm : Int := 480
def coutSurveillantEuros : Int := 80800
def fonctionnementPlaceEuros : Int := 6200
def coutAnnuelPlaceEuros : Int :=
  surveillantsParPlacePm * coutSurveillantEuros / 1000 + fonctionnementPlaceEuros
def constructionPrisons (coutPlaceKEuros : Int) : List Int :=
  calendrierConstructionPm.map fun p => placesPrisonNouvelles * coutPlaceKEuros / 1000 * p / 1000
/-- Emprise des prisons nouvelles (O-75) : 17 ha pour 700 places (centre de
Saint-Saulve, ministère de la Justice, 23 juin 2023), au rythme du
calendrier de construction, ha. -/
def surfacesPrisons : List Int :=
  calendrierConstructionPm.map fun p => placesPrisonNouvelles * 17 / 700 * p / 1000
def fonctionnementPrisons : List Int :=
  ouverturePlacesPm.map fun p => placesPrisonNouvelles * p / 1000 * coutAnnuelPlaceEuros / 1000000

/-- Baisser à la fois le déficit et le chômage (O-76, O-77).

* O-76 : allègements recentrés. La réduction générale dégressive unique
  s'éteint à 3 SMIC depuis 2026 ; elle sortirait à 2 SMIC, et l'économie
  serait reversée aux salaires de 1 à 1,6 SMIC, à coût constant. Au-delà
  de 1,6 SMIC, les allègements créent peu d'emplois (≈ 5 000 par Md€ pour
  les anciens bandeaux maladie et famille, Bozio et Wasmer, 2024 ; effets
  « très faibles » au-delà de 2,5 SMIC, CAE, note n° 49) ; au voisinage du
  SMIC, beaucoup plus (23 000 à 57 000 par Md€ pour 4 points de baisse,
  CAE). Le CAE (2019) recommandait de supprimer les allègements au-delà de
  2,5 SMIC ; Bozio et Wasmer chiffrent la suppression des bandeaux avec
  recyclage complet (sortie à 2,2 SMIC) à +50 000 emplois. Part des
  allègements de 1,6 à 2,5 SMIC versée au-dessus de 2 SMIC :
  `partAllegementsAuDela2Smic` = 343 ‰ (calcul avec le barème de 2026 et
  la distribution des salaires) ; la tranche au-delà de 2,5 SMIC est
  entièrement reversée. Le recentrage s'applique après O-38 ; les
  réductions suivantes (O-56, O-61) portent alors sur les seuls allègements
  restants, au voisinage du SMIC.
* O-77 : accompagnement renforcé. 10 000 conseillers de plus à France
  Travail (52 837 ETP en 2023, IGF-IGAS ; 515 ETPT de moins en 2026), pour
  ramener les portefeuilles de l'accompagnement guidé (≈ 230 demandeurs par
  conseiller, Dares-IPP 2026) vers la centaine des expériences étrangères ;
  `coutConseillerEuros` = 80 000 € par an (hypothèse : rémunération chargée
  d'un conseiller ≈ 55 000 € et frais de structure ; 127 000 € par ETP tous
  coûts de l'opérateur compris, calcul d'après IGF-IGAS). Chômage
  d'équilibre : −5 chômeurs par conseiller (axe économique : expériences
  aléatoires française, autrichienne et allemande, éviction comprise). -/
def partAllegementsAuDela2Smic : Int := 343
def conseillersFranceTravail : Int := 10000
def coutConseillerEuros : Int := 80000

/-- Indice de développement humain (O-78 à O-81). L'IDH de la France (0,920
en 2023, 26e rang, PNUD) est surtout en retard sur l'éducation : une année
de durée attendue de scolarisation vaut ≈ 0,010 d'IDH, deux fois une année
d'espérance de vie (calcul). Mesures dont l'effet est documenté :

* O-78 : prix minimum de 0,50 € par verre standard d'alcool : −15 % de
  consommation, −22 % de décès par cancers liés à l'alcool (Etilé et al.,
  INCa-MILDECA, 2022) ; en Écosse, −13,4 % des décès entièrement dus à
  l'alcool (Lancet, 2023) ; sans effet net sur les finances publiques.
* O-79 : prix du tabac +20 % (paquet de ≈ 12,50 € à ≈ 15 €) par les
  accises : élasticité-prix −0,4 (Santé publique France), −8 % de
  consommation, décès attribuables (68 000 en 2023) en baisse d'autant à
  terme ; recettes calculées par le modèle commun (achats transfrontaliers
  compris dans la fuite fiscale). Le paquet de mesures de 2016-2019 (prix,
  paquet neutre, Mois sans tabac) gagne 644 000 années de vie d'ici 2050
  (OCDE et Santé publique France, Tobacco Control, 2024).
* O-80 : dépistage organisé du cancer colorectal porté de 30,7 % à 65 % de
  participation (Barré et al., 2020 : −22 % de mortalité de 34 % à 65 %) :
  ≈ 3 700 décès évités à terme ; coût des dépistages supplémentaires
  (hypothèse du modèle commun : 70 €).
* O-81 : scolarisation des 18-24 ans relevée d'un point par an pendant trois
  ans (places en BTS, IUT et universités, bourses) : +0,21 an de durée
  attendue de scolarisation, ≈ 2,2 Md€ par an à terme (13 300 € par
  étudiant, DEPP). Variante : +5 points (250 000 places, comme LFI). -/
def prixMinimumAlcoolCentimes : Int := 50
def hausseprixTabacPm : Int := 200
def participationDepistageCible : Int := 650
def hausseScolarisationParAn : Int := 10

/-- Violences sexistes et sexuelles (O-82). La Fondation des femmes estime
le besoin entre 2,6 et 5,4 Md€ par an (« Où est l'argent contre les
violences faites aux femmes ? ») ; les crédits dédiés sont de moins de
200 M€ toutes politiques confondues, dont 95,6 M€ pour l'action 25 du
programme 137 en 2026 (amendement CF1398 au PLF 2026). Retenu : le bas de
la fourchette, moins les crédits existants, soit 2,4 Md€ de dépense
nouvelle (justice, police, hébergement et accompagnement des victimes),
classée en sécurité-justice. -/
def besoinViolencesSexistes : Int := 2600
def creditsViolencesExistants : Int := 200

/-- Allocations familiales dès le premier enfant (O-83), proposition de loi
adoptée en première lecture le 5 juin 2025 : 70 € par mois et par enfant,
2,8 Md€ bruts par an, 1,8 Md€ nets des moindres versements de RSA et de
prime d'activité, dont les allocations sont une ressource (direction de la
Sécurité sociale, rapport AN n° 1473, p. 19-20). -/
def allocationsPremierEnfantBrut : Int := 2800
def allocationsPremierEnfantNet : Int := 1800

theorem placesPrisonNouvelles_eq : placesPrisonNouvelles = 27108 := by decide
theorem calendrierConstruction_total : calendrierConstructionPm.foldl (· + ·) 0 = 1000 := by decide
theorem prisons_cible : placesOperationnelles2026 + placesPlan15000Restantes
    + placesPrisonNouvelles * (ouverturePlacesPm.getLast?.getD 0) / 1000 = placesPrisonCible := by decide
def contributionGrandesEntreprises : Int :=
  7500 * max tauxISCible tauxMinimumPilier2 / 2500 * 103 / 100

/-- Dette numérique (O-24). OAT tokenisées, inscrites sur une chaîne de blocs
et réglées en jetons de monnaie électronique euro conformes à MiCA
(règlement (UE) 2023/1114) : c'est le mécanisme d'USDC (jeton adossé 1:1 à
des réserves, circulant sur une chaîne publique), appliqué à la dette
française. MiCA interdit de rémunérer le jeton lui-même (art. 50) : le
rendement est porté par l'OAT numérique, que le jeton sert à acheter.
Intérêts exonérés de PFU pour les particuliers résidents (31,4 % en 2026) ;
les non-résidents ne paient déjà pas d'impôt français sur ces intérêts.

* `cibleDetteNumerique` = 10 ‰ de la dette (≈ 57 Md€ en 2035 dans le
  scénario central), par paliers de `rythmeDetteNumerique` = 2 ‰ par an :
  mesure votée en 2027, première tranche fin 2028, cible atteinte en 2032.
  Le régime pilote DLT (règlement (UE) 2022/858) plafonne aujourd'hui
  l'ensemble des titres tokenisés à 6 Md€ ; la Commission propose 100 Md€
  pour toute l'Union (paquet « intégration des marchés », décembre 2025),
  les plateformes demandent au moins 150 Md€. La cible suppose un plafond
  relevé au-delà de la proposition, ou une émission hors régime pilote
  par le dépositaire central. Repère de demande : les ménages italiens
  détiennent ≈ 13 % de la dette italienne (SUERF, 2026), contre une
  détention directe marginale en France.
* `capitalisationFiscale` = 500 ‰ : part de l'avantage fiscal capitalisée
  dans le prix. Repère : obligations municipales américaines exonérées,
  ratio de rendement à Treasury ≈ 75 % à 10 ans et ≈ 91 % à 30 ans
  (2025), soit un taux implicite de 25 % et 9 % pour un taux marginal
  maximal de 40,8 % : 60 % et 22 % capitalisés ; maturité moyenne de la
  dette ≈ 8,5 ans. Décote retenue : 500 ‰ × 314 ‰ = 157 ‰ du taux.
* `partResidents` = 800 ‰ : le reste est détenu par des émetteurs de
  jetons (réserves) et des non-résidents, qui ne tirent aucun avantage de
  l'exonération.
* `partImposeeAvant` = 600 ‰ : part de l'épargne attirée qui était placée
  en produits imposés au PFU ou assimilés ; le reste vient de livrets
  exonérés (livret A, LDDS, LEP), sans perte fiscale mais avec moins de
  ressources pour le fonds d'épargne (logement social), non modélisé.

Bilan par euro de tranche, taux `y`, PFU `t`, capitalisation `θ`, part
défiscalisée `ρα` : gain = y·t·(θ − (1 − θt)·ρα). Seuil de rentabilité :
θ* = ρα / (1 + t·ρα) = 0,48 / 1,151 ≈ 0,417 ; avec θ = 0,5 le gain est
≈ 0,030·y, soit ≈ 10 pb sur la tranche quand y = 3,3 % (≈ 56 M€/an en
2035 : 294 M€ d'intérêts économisés, 238 M€ de PFU perdus). -/
def cibleDetteNumerique : Int := 10
def rythmeDetteNumerique : Int := 2
def capitalisationFiscale : Int := 500
def partResidents : Int := 800
def partImposeeAvant : Int := 600

/-! ## Mesures -/

def mesures : List Mesure := [
  { id := "O-01"
    titre := "Remplacement gratuit par l'État de 10 000 voitures parmi les plus polluantes chaque année"
    source := s!"Texte Orientation D, mesure 1 ; 10 000 voitures Crit'Air 5 ou non classées par an pendant {vaguesRemplacement} ans ; prix unitaire et part importée : hypothèses (voir Programme.lean)"
    leviers := [.remplacementVehicules remplacement]
    repetitions := vaguesRemplacement
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
    debut := 0  -- décision finale d'investissement fin 2026, premiers décaissements 2027
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
    titre := "Fin de l'âge légal : départ à la durée cotisée (172 trimestres, 174 avec O-44), réduite selon la pénibilité"
    source := "Texte Orientation D, mesure 7. Conversion : le modèle ne connaît qu'un âge moyen de départ ; sans borne d'âge, les carrières commencées avant 21 ans partent avant l'âge légal et la réduction pour pénibilité avance encore les métiers exposés : âge moyen de départ supposé plafonné à 63 ans et 6 mois, 6 mois sous les 64 ans du calendrier légal (hypothèse à étayer avec le COR) : le calendrier est suivi jusqu'à 63 ans et 6 mois (2031), puis s'arrête ; coût et actifs selon l'hypothèse économique du scénario"
    leviers := [.ageLegalCible 762 0]
    variantes := [
      { nom := "âge moyen avancé de 12 mois (pénibilité large)", leviers := [.ageLegalCible 756 0] },
      { nom := "écart de 6 mois au calendrier légal dès 2027", leviers := [.ageLegal (-6)] }] },

  { id := "O-08"
    titre := "Impôt sur les sociétés à 15 %, le taux minimal du pilier 2"
    source := s!"Texte Orientation D, mesure 8 ; {tauxISCible / 100} %, taux minimal de la directive (UE) 2022/2523 (pilier 2) ; réponse de l'assiette appliquée par le modèle commun (axe économique)"
    leviers := [.impotSocietes tauxISCible]
    variantes := [
      { nom := "12 % (trois points au-dessus du taux hongrois de 9 %, version précédente)", leviers := [.impotSocietes 1200] },
      { nom := "17 % (minimum de 15 % du pilier 2 + 2 points)", leviers := [.impotSocietes 1700] },
      { nom := "IS maintenu à 25 % (abandon de la baisse, piste vers l'équilibre)", leviers := [] }] },

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
    source := s!"Texte Orientation D, mesure 11 ; ≈ 30 Md€ sur dix ans dont 80 % d'argent public français : {lignesNouvelles} M€/an (hypothèses, voir `lignesNouvelles`) ; emprise {surfaceLignesNouvellesHa} ha/an pendant dix ans (voir `surfaceLignesNouvellesHa`)"
    leviers := [.depenseSur .affairesEconomiques lignesNouvelles,
                .artificialisation .infrastructures (List.replicate 10 surfaceLignesNouvellesHa)] },

  { id := "O-12"
    titre := "Qualité d'accueil des touristes : six zones de rénovation de qualité, dont Le Grau-du-Roi"
    source := s!"Texte Orientation D, mesure 12 ; {zonesTouristiques} zones × {coutParZone} M€/an (hypothèse) ; effet +2 % de visiteurs et +3 % de dépense par touriste (hypothèse, voir `zonesTouristiques`) ; base 2024 : 100 M de visiteurs, 71 Md€ (Atout France, Banque de France)"
    leviers := [.accueilTouristique zonesTouristiques coutParZone 20 30]
    variantes := [
      { nom := "effet faible : +1 % de visiteurs, +1 % de dépense", leviers := [.accueilTouristique zonesTouristiques coutParZone 10 10] },
      { nom := "effet fort : +4 % de visiteurs, +5 % de dépense", leviers := [.accueilTouristique zonesTouristiques coutParZone 40 50] }] },

  { id := "O-13"
    titre := "Autorisation de la conduite autonome (FSD) ; indemnisation des chauffeurs de taxi titulaires d'une licence jusqu'à leur retraite"
    source := s!"Texte Orientation D, mesure 13 ; {titulairesTaxi} titulaires (hypothèse sur 62 800 ADS, Observatoire T3P 2024), pyramide des âges INSEE 2016 (moyenne 49 ans), {indemniteTaxi} € par an jusqu'à {ageRetraiteTaxi} ans : {indemnitesAnnee titulairesTaxi 0 0 0} M€ la première année, {indemnitesAnnee titulairesTaxi 0 0 8} M€ au bout de huit ans ; {sortiesTaxis titulairesTaxi} titulaires de {ageSortieTaxi} ans et plus quittent la population active, les autres se reclassent ; +0,05 % de PIB (voir `titulairesTaxi`)"
    leviers := leviersTaxis titulairesTaxi 0 0
    debut := 0
    variantes := [
      { nom := "toutes les ADS indemnisées (62 800)", leviers := leviersTaxis 62800 0 0 },
      { nom := "moins de 50 ans : deux ans d'indemnité et 15 000 € de formation", leviers := leviersTaxis titulairesTaxi 50 15000 }] },

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
    debut := 1 },

  { id := "O-16"
    titre := "Reprise de la dette des universités et apurement de leurs déficits"
    source := s!"Texte Orientation D, mesure 16 ; la reprise de dette est un transfert interne aux administrations publiques (neutre) ; apurement des déficits : {deficitsUniversites} M€/an (hypothèse, Cour des comptes 2025 : ≈ 60 universités en déficit)"
    leviers := [.depenseSur .enseignement deficitsUniversites] },

  { id := "O-17"
    titre := "Reconstruction aux normes des universités de Nanterre, Toulouse, Montpellier et Grenoble (démolition puis construction)"
    source := s!"Texte Orientation D, mesure 17 ; 4 × 1 Md€ sur huit ans à partir de 2027 : {reconstructionCampus} M€/an d'investissement (hypothèse), emplois dans la construction ; le modèle garde la dépense constante au-delà des huit ans (prudent)"
    leviers := [.investissement .enseignement reconstructionCampus]
    debut := 0 },

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
    source := s!"Texte Orientation D, mesure 20 ; l'aide exceptionnelle s'éteint en 2027 à législation constante (décret n° 2026-168) ; aide maintenue pour l'infra-bac dans les entreprises de moins de 250 salariés : 3,9 Md€ (2024) − 2,94 Md€ d'économies (Cour des comptes, revue de dépenses, 2025) ≈ {aideApprentissageCiblee} M€/an (voir `aideApprentissageCiblee`)"
    leviers := [.depenseSur .famille aideApprentissageCiblee] },

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
    debut := 0 },

  { id := "O-25"
    titre := "Rémunération des enseignants : +2 % par an"
    source := s!"Texte Orientation D, mesure 25 ; masse salariale hors CAS Pensions 59,23 Md€ en 2026 (PLF 2026), base 2027 {masseEnseignants2027} M€ ; +2 %/an au-delà de la tendance de 2027 à 2035 : {revalorisationsEnseignants.head!} M€ la première année, {revalorisationsEnseignants[8]!} M€ (euros 2027) la neuvième (2035)"
    leviers := [.remunerationPublique .traitement .enseignement revalorisationsEnseignants]
    debut := 0 },

  { id := "O-26"
    titre := "Automatisation des tâches administratives : 10 000 postes de contrôle supprimés par an pendant cinq ans"
    source := s!"Texte Orientation D, mesure 26 ; {postesControleParAn} postes par an × 5, non remplacés, à {coutPosteControle} € (hypothèse, DGAFP 2024) ; outil : {investissementParPoste} € par poste la même année puis {maintenanceParPoste} €/an (hypothèses)"
    leviers := [.suppressionPostes .fonctionnement postesControleParAn coutPosteControle,
                .depenseEcheancier .fonctionnement [postesControleParAn * investissementParPoste / 1000000, 0],
                .depenseSur .fonctionnement (postesControleParAn * maintenanceParPoste / 1000000)]
    debut := 0
    repetitions := 5 },

  { id := "O-27"
    titre := "Médecins généralistes : simplification des tâches administratives ; enquêteurs humains sur les cas anormaux à la place des contrôles systématiques"
    source := s!"Texte Orientation D, mesure 27 ; DREES 2019 : 5 h 30 de gestion par semaine sur 54 h ; moitié supprimée pour {generalistesLiberaux} généralistes libéraux : {heuresLibereesMilliers} milliers d'heures de soin libérées par an, ≈ {etpGeneralistesLiberes} généralistes à temps plein, {consultationsMilliers} milliers de consultations possibles ; {enqueteurs} enquêteurs à {coutEnqueteur} € (hypothèses)"
    leviers := [.depenseSur .sante (enqueteurs * coutEnqueteur / 1000000)]
    debut := 0
    variantes := [
      { nom := s!"temps libéré converti en consultations remboursées (+{coutConsultations} M€/an)",
        leviers := [.depenseSur .sante (enqueteurs * coutEnqueteur / 1000000), .depenseSur .sante coutConsultations] }] },

  { id := "O-24"
    titre := "Dette numérique : achat d'OAT tokenisées en stablecoin euro (mécanisme USDC), intérêts exonérés de PFU"
    source := s!"Texte Orientation D, mesure 24 ; OAT numériques réglées en jetons de monnaie électronique (MiCA, règlement (UE) 2023/1114, art. 50 : pas d'intérêt sur le jeton), régime pilote DLT (règlement (UE) 2022/858, à réviser) ; exonération du PFU de 31,4 % (LFSS 2026) pour les particuliers résidents ; tranche cible {cibleDetteNumerique} ‰ de la dette (+{rythmeDetteNumerique} ‰/an, première tranche fin 2028), capitalisation fiscale {capitalisationFiscale} ‰ (obligations municipales américaines), part des résidents {partResidents} ‰, part imposée auparavant {partImposeeAvant} ‰"
    leviers := [.detteNumerique cibleDetteNumerique rythmeDetteNumerique capitalisationFiscale
                  partResidents partImposeeAvant]
    debut := 0 },

  { id := "O-28"
    titre := "Désindexation des très hautes retraites : revalorisation limitée à la part sous 5 150 € par mois"
    source := s!"Texte Orientation D, mesure 28 ; 1 % des retraités au-delà de 5 150 € bruts, 6 470 € en moyenne (DREES) ; part au-delà du seuil {masseAuDelaSeuil} M€ (2027), revalorisation évitée {inflationPb} pb/an : {(desindexation masseAuDelaSeuil).head!} M€ la première année, {(desindexation masseAuDelaSeuil)[8]!} M€ en 2035 (euros 2027)"
    leviers := [.depenseEcheancier .retraites (desindexation masseAuDelaSeuil)]
    debut := 0
    variantes := [
      { nom := s!"gel de toute la pension au-delà du seuil ({masseTresHautes} M€ concernés)",
        leviers := [.depenseEcheancier .retraites (desindexation masseTresHautes)] }] },

  { id := "O-29"
    titre := "TVA : taux normal porté de 20 % à 22 %"
    source := s!"Texte Orientation D, mesure 29 ; un point de taux normal ≈ 8 Md€ (FIPECO, IPP, Sénat) : {tvaDeuxPoints} M€ de rendement statique, net de la fuite fiscale du modèle"
    leviers := [.prelevementSur .tva tvaDeuxPoints]
    debut := 0 },

  { id := "O-30"
    titre := "Taxe forfaitaire à l'atterrissage des jets privés"
    source := s!"Texte Orientation D, mesure 30 ; {atterrissagesJets} atterrissages par an (84 885 départs en 2022, Greenpeace) × {taxeAtterrissage} € (hypothèse) ; fuite fiscale du modèle pour le report et la baisse des vols"
    leviers := [.prelevementSur .autres (atterrissagesJets * taxeAtterrissage / 1000000)]
    debut := 0
    variantes := [
      { nom := "taxe de 1 000 € par atterrissage", leviers := [.prelevementSur .autres (atterrissagesJets * 1000 / 1000000)] }] },

  { id := "O-31"
    titre := "Plan de conversion à l'électrique de l'ensemble des exploitations agricoles (dix ans)"
    source := s!"Texte Orientation D, mesure 31 ; {exploitationsAgricoles} exploitations (RA 2020) × {aideConversion} € sur dix ans (hypothèse) ; énergie agricole ≈ 37 TWh de produits pétroliers, {emissionsEnergieAgricole} Mt de CO₂ ; importations nettes −{(carburantAgricoleImporte - electriciteNonExportee) / 10} M€ par an"
    leviers := [.depenseEcheancier .affairesEconomiques [exploitationsAgricoles * aideConversion / 10 / 1000000, 0],
                .transition .agriculture (emissionsEnergieAgricole / 10) 0,
                .importationsNiveau (-((carburantAgricoleImporte - electriciteNonExportee) / 10))]
    debut := 0
    repetitions := 10 },

  { id := "O-32"
    titre := "Suppression du DPE pour les immeubles de Paris et des quartiers historiques ; climatisation réversible aidée par l'État"
    source := s!"Texte Orientation D, mesure 32 ; DPE : sans effet budgétaire ; {logementsClimatisation} logements par an × {aideClimatisation} € pendant dix ans (hypothèses) ; effet sur les émissions inférieur à la résolution du modèle (1 Mt)"
    leviers := [.depenseEcheancier .logementEnvironnement [logementsClimatisation * aideClimatisation / 1000000, 0]]
    debut := 0
    repetitions := 10 },

  { id := "O-33"
    titre := "Pas d'immeubles de grande hauteur dans les quartiers historiques ; quartiers nouveaux autour des pôles très desservis (Val de Fontenay)"
    source := s!"Texte Orientation D, mesure 33 ; interdiction sans effet budgétaire ; {logementsQuartiersGare} logements par an × {aideLogementQuartierGare} € d'équipements publics (hypothèses)"
    leviers := [.investissement .logementEnvironnement (logementsQuartiersGare * aideLogementQuartierGare / 1000000)]
    debut := 0 },

  { id := "O-34"
    titre := "TER 24 h sur 24 entre métropoles et villes moyennes (Orléans…), agents de sécurité à bord, en gare et aux parkings"
    source := s!"Texte Orientation D, mesure 34 ; {liaisonsTerNuit} liaisons de {distanceTerKm} km, {trainsParNuit} trains par nuit, 23,40 € par train-km (IFRAP 2024), {heuresAgentsParNuit} heures d'agents par nuit à {coutHeureAgent} €, {couvertureRecettesPm / 10} % couverts par les recettes : {coutTerNuit} M€ par an"
    leviers := [.depenseSur .affairesEconomiques coutTerNuit]
    debut := 0 },

  { id := "O-36"
    titre := "CSG sur les gros héritages"
    source := s!"Texte Orientation D, mesure 36 ; chiffrage du groupe PS : {csgHeritages} M€ (sans contre-expertise connue) ; prélevée comme la CSG mais assise sur les successions : imputée à la ligne des droits de succession, dont elle suit l'assiette (l'affectation à la Sécurité sociale est neutre sur le solde consolidé)"
    leviers := [.prelevementSur .droitsMutation csgHeritages]
    debut := 0 },

  { id := "O-37"
    titre := "Taxe sur les services numériques portée de 3 % à 15 %"
    source := s!"Texte Orientation D, mesure 37 ; 0,89 Md€ à 3 %, ≈ 4 Md€ à 15 % (commission des finances, octobre 2026) : +{taxeNumerique} M€ ; le PS annonce 10 Md€"
    leviers := [.prelevementSur .autres taxeNumerique]
    debut := 0
    variantes := [{ nom := "chiffrage du groupe PS (10 Md€)", leviers := [.prelevementSur .autres 10000] }] },

  { id := "O-38"
    titre := "Reconfiguration des exonérations de cotisations patronales"
    source := s!"Texte Orientation D, mesure 38 ; chiffrage du groupe PS : {exonerationsCotisations} M€"
    leviers := [.reductionAllegements exonerationsCotisations]
    debut := 0 },

  { id := "O-39"
    titre := "Train de vie de l'État"
    source := s!"Texte Orientation D, mesure 39 ; part « train de vie » des 12,1 Md€ d'économies du groupe PS, moins O-21 déjà compté : {trainDeVieEtat} M€ d'économies de fonctionnement (la lutte contre la fraude fiscale est en O-45)"
    leviers := [.economieSur .fonctionnement trainDeVieEtat]
    debut := 0 },

  { id := "O-40"
    titre := "Revue des niches fiscales : −10 % hors Pacte Dutreil et hors dispositifs pour les ménages modestes"
    source := s!"Texte Orientation D, mesure 40 ; 465 niches, 88,3 Md€ en 2026 (PLF 2026) ; {nichesFiscales} M€ (IR 4, IS 2, TVA 2)"
    leviers := [.prelevementSur .ir 4000, .prelevementSur .impotSocietes 2000, .prelevementSur .tva 2000]
    debut := 0 },

  { id := "O-41"
    titre := "Fiscalité du patrimoine : Pacte Dutreil divisé par deux (abattement 75 % → 37,5 %), taxe sur les holdings élargie"
    source := s!"Texte Orientation D, mesure 41 ; Cour des comptes, note du 21 septembre 2026 (1,3 Md€ pour 75 % → 50 %, proportionnel) : {pacteDutreil} M€ (Dutreil, 5,5 Md€ de coût en 2024) et {holdings} M€ (holdings)"
    leviers := [.prelevementSur .droitsMutation pacteDutreil, .prelevementSur .patrimoine holdings]
    debut := 0 },

  { id := "O-42"
    titre := "Norme de dépense : +0,5 % en volume pour les dépenses pilotables (hors retraites, famille, enseignement, défense)"
    source := s!"Texte Orientation D, mesure 42 ; {normeDepensePb} pb de moins par an sur ≈ 739 Md€ de dépenses pilotables (2025) : 2,3 % au lieu de 2,8 %"
    leviers := [.normeDepense normeDepensePb]
    debut := 0
    variantes := [{ nom := "zéro volume (100 pb)", leviers := [.normeDepense 100] }] },

  { id := "O-43"
    titre := "Budget de la défense : −1 Md€ par an"
    source := s!"Texte Orientation D, mesure 43 ; {economieDefense} M€ par an sur 53 Md€ (2025), en moins de la trajectoire de la LPM actualisée (loi n° 2026-791)"
    leviers := [.economieSur .defense economieDefense]
    debut := 0 },

  { id := "O-44"
    titre := "Durée de cotisation portée de 172 à 174 trimestres"
    source := s!"Texte Orientation D, mesure 44 ; +2 trimestres, {partDepartsDuree / 10} % des départs liés à la durée (hypothèse ; COR) : âge moyen de départ +4,8 mois (levier `dureeCotisation`, au millième de mois)"
    leviers := [.dureeCotisation 6 partDepartsDuree]
    debut := 0 },

  { id := "O-45"
    titre := "Lutte contre la fraude fiscale : facturation électronique, renfort du contrôle fiscal"
    source := s!"Texte Orientation D, mesure 45 ; écart de TVA 12,1 Md€ en 2023 (Commission européenne) ; facturation électronique : {fraudeFacturation} M€ de TVA par an à partir de 2028 (2 à 3 Md€ attendus par l'administration) ; {agentsControle} agents de contrôle à {coutAgentControle} €, {rendementControle} M€ d'encaissements par an (hypothèse)"
    leviers := [.prelevementSur .tva (fraudeFacturation + rendementControle / 3),
                .prelevementSur .ir (rendementControle / 3),
                .prelevementSur .impotSocietes (rendementControle - 2 * (rendementControle / 3)),
                .depenseSur .fonctionnement (agentsControle * coutAgentControle / 1000000)]
    debut := 1 },

  { id := "O-46"
    titre := "CSG progressive pour les hauts revenus : +2 points au-delà de 100 000 € par an"
    source := s!"Texte Orientation D, mesure 46 ; +{pointsCsgHauts} points sur la part des revenus d'activité et de remplacement au-delà de {seuilCsgHauts} € ; 1 point de CSG = 17 Md€ (FIPECO 2024) ; {partAssietteAuDelaPm / 10} % de l'assiette au-delà du seuil (hypothèse) : {rendementCsgHauts} M€"
    leviers := [.prelevementSur .csgCrds rendementCsgHauts]
    debut := 0 },

  { id := "O-47"
    titre := "Investissements de l'État dans les entreprises stratégiques : 100 M€ par an"
    source := s!"Texte Orientation D, mesure 47 ; {participationsStrategiques} M€ par an de prises de participation (opération financière : dette sans déficit) ; dividendes au rendement du portefeuille de l'APE (≈ 1,9 %)"
    leviers := [.prisesDeParticipation participationsStrategiques]
    debut := 0 },

  { id := "O-48"
    titre := "Non-renouvellement des concessions autoroutières : exploitation publique à l'échéance (2031-2036)"
    source := s!"Texte Orientation D, mesure 48 ; échéances Sanef 2031, Escota 2032, SAPN 2033, APRR 2035, ASF et AREA 2036 (Cofiroute 2086) ; EBITDA des historiques ≈ {ebitdaHistoriques} M€, renouvellement {investissementsHistoriques} M€, IS ≈ {isHistoriques} M€ (ART 2023, estimations) ; part reprise en 2035 : {partReprise 8} ‰, en 2037 : {partReprise 10} ‰"
    leviers := [.recetteEcheancier none (echeancierReprise (ebitdaHistoriques - investissementsHistoriques)),
                .recetteEcheancier (some .impotSocietes) (echeancierReprise (-isHistoriques))]
    debut := 0
    variantes := [
      { nom := "péages baissés de 20 % à la reprise",
        leviers := [.recetteEcheancier none (echeancierReprise (ebitdaHistoriques * 800 / 1000 - investissementsHistoriques)),
                    .recetteEcheancier (some .impotSocietes) (echeancierReprise (-isHistoriques))] }] },

  { id := "O-49"
    titre := "Rémunération des hauts fonctionnaires : −5 %"
    source := s!"Texte Orientation D, mesure 49 ; encadrement supérieur et dirigeant (21 500 agents, DGAFP), coût complet ≈ {masseHautsFonctionnaires} M€ : économie {economieHautsFonctionnaires} M€"
    leviers := [.remunerationPublique .traitement .fonctionnement [-(economieHautsFonctionnaires * 3 / 4)],
                .remunerationPublique .traitement .sante [-(economieHautsFonctionnaires - economieHautsFonctionnaires * 3 / 4)]]
    debut := 0 },

  { id := "O-50"
    titre := "Revenus des élus plafonnés à 10 000 € par mois tous mandats confondus (limiter le cumul)"
    source := s!"Texte Orientation D, mesure 50 ; plafond en vigueur {plafondCumulActuel} € bruts par mois (CGCT, art. L. 2123-20 II), plus strict que {plafondElus} € : sans effet budgétaire, enregistrée pour mémoire"
    leviers := []
    debut := 0 },

  { id := "O-51"
    titre := "Fin du prélèvement forfaitaire unique : revenus du capital au barème de l'impôt sur le revenu"
    source := s!"Texte Orientation D, mesure 51 ; Institut Montaigne : +3,2 à 3,6 Md€ à comportements inchangés, −0,7 Md€ si l'assiette revient à 2017 ; retenu {finPfu} M€"
    leviers := [.prelevementSur .ir finPfu]
    debut := 0
    variantes := [{ nom := "assiette des dividendes revenue à 2017 (−0,7 Md€)", leviers := [.prelevementSur .ir (-700)] }] },

  { id := "O-52"
    titre := "Taxe sur les rachats d'actions portée de 8 % à 20 %"
    source := s!"Texte Orientation D, mesure 52 ; assiette implicite ≈ 25 Md€ (amendement PLF 2026), +12 points = 3 Md€ mécaniques, report vers les dividendes : {rachatsActions} M€ retenus"
    leviers := [.prelevementSur .impotSocietes rachatsActions]
    debut := 0 },

  { id := "O-53"
    titre := "Dépenses de cabinets de conseil divisées par deux"
    source := s!"Texte Orientation D, mesure 53 ; 893,9 M€ en 2021 (commission d'enquête du Sénat) : {economieConseil} M€ d'économies"
    leviers := [.economieSur .fonctionnement economieConseil]
    debut := 0 },

  { id := "O-54"
    titre := "Prolongation de la CRDS au-delà de 2033 pour amortir la dette de l'ACOSS"
    source := "Texte Orientation D, mesure 54 ; CRDS 9,22 Md€ en 2026, fin prévue avec la CADES (2033) ; dette de l'ACOSS ≈ 65 Md€ fin 2026 sans ressource ; maintien de 9,55 Md€ (euros 2027) à partir de 2034"
    leviers := [.recetteEcheancier (some .csgCrds) crdsProlongee] },

  { id := "O-55"
    titre := "Norme de dépense renforcée : dépenses pilotables à −0,5 % par an en volume (avec O-42)"
    source := s!"Texte Orientation D, mesure 55 ; +{normeRenforceePb} pb de modération, soit 150 pb avec O-42 : 1,3 % par an en valeur au lieu de 2,8 %"
    leviers := [.normeDepense normeRenforceePb]
    variantes := [
      { nom := "norme renforcée de 100 pb de plus (250 pb avec O-42, piste vers l'équilibre)", leviers := [.normeDepense (normeRenforceePb + 100)] },
      { nom := "norme renforcée de 200 pb de plus (350 pb avec O-42, piste vers l'équilibre)", leviers := [.normeDepense (normeRenforceePb + 200)] }] },

  { id := "O-56"
    titre := "Aides aux entreprises : exonérations de cotisations réduites de 1,5 Md€ par an pendant six ans, sous conditions"
    source := s!"Texte Orientation D, mesure 56 ; 211 Md€ d'aides publiques aux entreprises (commission d'enquête du Sénat, juillet 2025) ; {baisseAidesEntreprises} M€ de plus chaque année de 2027 à 2032"
    leviers := [.reductionAllegements baisseAidesEntreprises]
    repetitions := 6 },

  { id := "O-57"
    titre := "Niches fiscales : −2 % par an pendant cinq ans (en plus de O-40)"
    source := s!"Texte Orientation D, mesure 57 ; 88,3 Md€ de dépenses fiscales (PLF 2026) ; {rabotNiches} M€ de plus chaque année de 2027 à 2031 (IR, IS, TVA)"
    leviers := [.prelevementSur .ir (rabotNiches / 2), .prelevementSur .impotSocietes (rabotNiches / 4),
                .prelevementSur .tva (rabotNiches / 4)]
    repetitions := 5 },

  { id := "O-58"
    titre := "Durée de cotisation : +1 trimestre tous les trois ans à partir de 2028"
    source := s!"Texte Orientation D, mesure 58 ; logique de la réforme de 2014 ; +1 mois de durée requise par an, {partDepartsDuree / 10} % des départs liés à la durée (hypothèse)"
    leviers := [.dureeCotisation 1 partDepartsDuree]
    debut := 1
    repetitions := 8 },

  { id := "O-59"
    titre := "Maintien de la CVAE au taux de 0,28 %"
    source := "Texte Orientation D, mesure 59 ; la loi n° 2025-127 (art. 62) supprime la CVAE par étapes de 2028 à 2030 ; rendement à 0,28 % ≈ 3,4 Md€ (Sénat, amendement I-31 au PLF 2026 : 1,1 Md€ pour 0,09 point) ; voir `cvaeMaintenue`"
    leviers := [.recetteEcheancier (some .autres) cvaeMaintenue] },

  { id := "O-60"
    titre := "Pérennisation de la contribution exceptionnelle sur les bénéfices des grandes entreprises"
    source := s!"Texte Orientation D, mesure 60 ; 7,5 Md€ en 2026 (loi n° 2026-103), non reconduite à législation constante (le PLF 2027 propose 5 Md€ pour 2027) ; aux taux de 2026 sur l'IS des grands groupes, imposés à {max tauxISCible tauxMinimumPilier2 / 100} % avec O-08 : {contributionGrandesEntreprises} M€ (euros 2027)"
    leviers := [.recetteEcheancier (some .impotSocietes) [contributionGrandesEntreprises]] },

  { id := "O-61"
    titre := "Aides aux entreprises, deuxième étape : exonérations de cotisations réduites de 1,5 Md€ de plus par an de 2029 à 2034"
    source := s!"Texte Orientation D, mesure 61 ; même base que O-56 (211 Md€ d'aides, commission d'enquête du Sénat, juillet 2025) ; {aidesSecondeEtape} M€ de plus chaque année de 2029 à 2034, sous conditions (voir `aidesSecondeEtape`)"
    leviers := [.reductionAllegements aidesSecondeEtape]
    debut := 2
    repetitions := 6 },

  { id := "O-62"
    titre := "Niches fiscales : −1,5 Md€ de plus par an de 2029 à 2035"
    source := s!"Texte Orientation D, mesure 62 ; 88,3 Md€ de dépenses fiscales (PLF 2026) ; {nichesSecondeEtape} M€ de plus chaque année de 2029 à 2035 (IR, IS, TVA comme O-57)"
    leviers := [.prelevementSur .ir (nichesSecondeEtape / 2), .prelevementSur .impotSocietes (nichesSecondeEtape / 4),
                .prelevementSur .tva (nichesSecondeEtape / 4)]
    debut := 2
    repetitions := 7 },

  { id := "O-63"
    titre := "Aide à la rénovation énergétique majorée de 25 % dans les territoires ruraux"
    source := s!"Texte Orientation D, mesure 63 ; +{bonusRenovationRurale} € par rénovation aidée dans les communes rurales (48 % des rénovations aidées, Anah 2021) ; effets : sous-modèle rénovation du modèle commun (voir `bonusRenovationRurale`)"
    leviers := [.bonusRenovation .rural bonusRenovationRurale]
    variantes := [
      { nom := "majoration de 50 % (6 500 €)", leviers := [.bonusRenovation .rural (2 * bonusRenovationRurale)] }] },

  { id := "O-64"
    titre := "Accès à l'eau potable dans les outre-mer : réseaux, production, assainissement"
    source := s!"Texte Orientation D, mesure 64 ; besoins de 2,36 Md€ (Cour des comptes, mars 2025), moins les 730 M€ de la loi n° 2025-797 pour Mayotte : {eauOutreMer} M€ par an de 2027 à 2031 (voir `eauOutreMer`)"
    leviers := [.investissementOutreMer .logementEnvironnement [eauOutreMer, eauOutreMer, eauOutreMer, eauOutreMer, eauOutreMer, 0]] },

  { id := "O-65"
    titre := "Électrification totale des outre-mer : raccordement de tous les foyers"
    source := s!"Texte Orientation D, mesure 65 ; ≈ 22 100 foyers sans électricité à Mayotte et en Guyane (INSEE 2026) ; raccordement et sites isolés : 211 M€ sur trois ans (coûts unitaires : hypothèses) ; surcoût de péréquation des zones non interconnectées pour {foyersRaccordesParAn} foyers de plus par an (voir `electrificationOutreMer`)"
    leviers := [.investissementOutreMer .affairesEconomiques electrificationOutreMer] },

  { id := "O-66"
    titre := "Électrification des outre-mer : électricité des foyers raccordés (péréquation tarifaire)"
    source := s!"Texte Orientation D, mesure 65 (suite) ; {foyersRaccordesParAn} foyers raccordés par an de 2027 à 2029, consommation et surcoût de production des zones non interconnectées : axe énergie du modèle commun"
    leviers := [.raccordementZni foyersRaccordesParAn]
    repetitions := 3 },

  { id := "O-67"
    titre := "Dettes cachées : paiement immédiat des heures supplémentaires non payées des policiers"
    source := "Texte Orientation D, mesure 67 ; 14,3 millions d'heures au 31 décembre 2022 (Sénat, rapport n° 34, 2024-2025), 13,22 € l'heure : 189 M€ payés en 2027 (passif implicite du modèle commun)"
    leviers := [.apurementPassifs .heuresSupPolice .securiteJustice 1000] },

  { id := "O-68"
    titre := "Dettes cachées : RIFSEEP pour les enseignants, primes alignées sur les autres agents de catégorie A"
    source := s!"Texte Orientation D, mesure 68 ; primes à 17,2 % du brut contre 32,9 % pour la catégorie A (DGAFP 2025) ; ≈ 10 950 € par enseignant × 693 400 fonctionnaires (DEPP 2025) : {rifseepEnseignants} M€ par an (euros 2027), primes (voir `rifseepEnseignants`)"
    leviers := [.remunerationPublique .primes .enseignement [rifseepEnseignants]]
    variantes := [
      { nom := "montée en charge sur cinq ans", leviers := [.remunerationPublique .primes .enseignement
          [rifseepEnseignants / 5, 2 * rifseepEnseignants / 5, 3 * rifseepEnseignants / 5, 4 * rifseepEnseignants / 5, rifseepEnseignants]] }] },

  { id := "O-69"
    titre := "Crédit d'impôt recherche recentré : plafond de 50 M€ par groupe, fin du taux de 5 %"
    source := s!"Texte Orientation D, mesure 69 ; IGF (revue de dépenses, mars 2024) : au moins {cirRecentre} M€ ; amendements PS au PLF 2026 (AN I-754, Sénat I-674)"
    leviers := [.prelevementSur .impotSocietes cirRecentre] },

  { id := "O-70"
    titre := "Assurance-vie au barème des successions au-delà de 250 000 € par bénéficiaire"
    source := s!"Texte Orientation D, mesure 70 ; {assuranceVieBaremeCpo} M€ avec le seuil actuel de 152 500 € (Conseil des prélèvements obligatoires, 1er décembre 2025, recommandation n° 6) ; seuil relevé à 250 000 € : ≈ {assuranceVieBareme} M€ (hypothèse, voir `assuranceVieBareme`)"
    leviers := [.prelevementSur .droitsMutation assuranceVieBareme]
    variantes := [
      { nom := "seuil actuel de 152 500 € (proposition du CPO)", leviers := [.prelevementSur .droitsMutation assuranceVieBaremeCpo] }] },

  { id := "O-71"
    titre := "Contribution kilométrique des poids lourds sur le réseau national non concédé"
    source := s!"Texte Orientation D, mesure 71 ; écotaxe de 2014 : 1 129 M€ bruts à 0,13 €/km (Cour des comptes, 2017), {ecotaxePoidsLourds} M€ actualisés ; émissions visées {emissionsPoidsLourdsVisees} kt, coût +11 % ; élasticité-prix du modèle commun"
    leviers := [.taxeEnvironnementale .poidsLourds .autres emissionsPoidsLourdsVisees 110 ecotaxePoidsLourds] },

  { id := "O-72"
    titre := "Accise sur le kérosène des vols intérieurs métropolitains"
    source := s!"Texte Orientation D, mesure 72 ; 1,5 Mt de CO₂ (DGAC, 2024), taux du gazole : ≈ {kerosene} M€ avant comportements, billets +10 % ; élasticité-prix du modèle commun"
    leviers := [.taxeEnvironnementale .aerienInterieur .accisesEnergie 1500 100 kerosene] },

  { id := "O-73"
    titre := "Défiscalisation des heures supplémentaires réduite de moitié (impôt sur le revenu et cotisations salariales)"
    source := s!"Texte Orientation D, mesure 73 ; exonération d'IR ≈ {heuresSupIr} M€ (Voies et moyens) et réduction de cotisations salariales {heuresSupCotisations} M€ (PLFSS 2026), réduites de {partDefiscalisationSupprimeePm / 10} %"
    leviers := [.prelevementSur .ir (heuresSupIr * partDefiscalisationSupprimeePm / 1000),
                .prelevementSur .cotisations (heuresSupCotisations * partDefiscalisationSupprimeePm / 1000)]
    variantes := [
      { nom := "suppression totale (comme en 2012)", leviers := [.prelevementSur .ir heuresSupIr, .prelevementSur .cotisations heuresSupCotisations] }] },

  { id := "O-74"
    titre := "Dettes cachées : paiement immédiat des heures supplémentaires non payées des hôpitaux publics"
    source := "Texte Orientation D, mesure 74 ; 18,5 millions d'heures, 463 M€ fin 2018 (Cour des comptes, 2020) ; ≈ 720 M€ d'après le bilan social des hôpitaux 2022 (ATIH) et les effectifs DREES 2024 : payés en 2027 (passif implicite du modèle commun)"
    leviers := [.apurementPassifs .heuresSupHopital .sante 1000] },

  { id := "O-75"
    titre := "100 000 places de prison en cellule individuelle : construction, surveillants et fonctionnement"
    source := s!"Texte Orientation D, mesure 75 ; 63 303 places pour 89 668 détenus au 1er août 2026 (ministère de la Justice) ; plan 15 000 en cours ({placesPlan15000Restantes} places restantes, dans la tendance) ; {placesPrisonNouvelles} places de plus à {coutPlacePrisonKEuros} k€ la place nette (Cour des comptes, décembre 2025), ouvertes de 2030 à 2035 ; {coutAnnuelPlaceEuros} € par place ouverte et par an (0,48 surveillant par place, voir `placesPrisonNouvelles`) ; emprise : 17 ha pour 700 places (voir `surfacesPrisons`)"
    leviers := [.investissementEcheancier .securiteJustice (constructionPrisons coutPlacePrisonKEuros),
                .depenseEcheancier .securiteJustice fonctionnementPrisons,
                .artificialisation .autres surfacesPrisons]
    variantes := [
      { nom := "coût des centres pénitentiaires (450 k€ la place)", leviers :=
          [.investissementEcheancier .securiteJustice (constructionPrisons coutPlacePrisonCpKEuros),
           .depenseEcheancier .securiteJustice fonctionnementPrisons,
           .artificialisation .autres surfacesPrisons] }] },

  { id := "O-76"
    titre := "Allègements recentrés : sortie à 2 SMIC au lieu de 3, économie reversée aux salaires de 1 à 1,6 SMIC, à coût constant"
    source := s!"Texte Orientation D, mesure 76 ; CAE, note n° 49 (2019) ; Bozio et Wasmer (2024) : suppression des bandeaux avec recyclage, +50 000 emplois ; part des allègements de 1,6 à 2,5 SMIC au-delà de 2 SMIC : {partAllegementsAuDela2Smic} ‰ (calcul, barème de 2026) ; élasticités de l'emploi par tranche du modèle commun"
    leviers := [.recentrageAllegements partAllegementsAuDela2Smic 1000]
    variantes := [
      { nom := "sortie à 1,6 SMIC (tout reversé sous 1,6 SMIC)", leviers := [.recentrageAllegements 1000 1000] }] },

  { id := "O-77"
    titre := "Accompagnement renforcé des demandeurs d'emploi : 10 000 conseillers de plus à France Travail"
    source := s!"Texte Orientation D, mesure 77 ; expériences aléatoires : Behaghel, Crépon et Gurgand (2014), Böheim, Eppel et Mahringer (WIFO, 2022), Hainmueller et al. (2016) ; {conseillersFranceTravail} conseillers à {coutConseillerEuros} € par an (hypothèse) ; chômage d'équilibre du modèle commun (5 chômeurs de moins par conseiller, éviction comprise)"
    leviers := [.accompagnementDemandeurs conseillersFranceTravail coutConseillerEuros]
    variantes := [
      { nom := "5 000 conseillers", leviers := [.accompagnementDemandeurs (conseillersFranceTravail / 2) coutConseillerEuros] },
      { nom := "15 000 conseillers", leviers := [.accompagnementDemandeurs (conseillersFranceTravail * 3 / 2) coutConseillerEuros] }] },

  { id := "O-78"
    titre := "Prix minimum de l'alcool : 0,50 € par verre standard"
    source := s!"Texte Orientation D, mesure 78 ; Etilé et al., INCa-MILDECA (2022) : −22 % de décès par cancers liés à l'alcool pour {prixMinimumAlcoolCentimes} centimes ; Écosse : −13,4 % des décès entièrement dus à l'alcool (Lancet, 2023) ; décès et délais d'effet du modèle commun"
    leviers := [.prixMinimumAlcool prixMinimumAlcoolCentimes] },

  { id := "O-79"
    titre := "Prix du tabac +20 % par les accises (paquet ≈ 15 €)"
    source := s!"Texte Orientation D, mesure 79 ; élasticité-prix −0,4 (Santé publique France), 68 000 décès attribuables en 2023 ; hausse de {hausseprixTabacPm / 10} % ; recettes et décès évités calculés par le modèle commun"
    leviers := [.prixTabac hausseprixTabacPm] },

  { id := "O-80"
    titre := "Dépistage organisé du cancer colorectal : 65 % de participation"
    source := s!"Texte Orientation D, mesure 80 ; participation de 30,7 % en 2024-2025 ; Barré et al. (2020) : −22 % de mortalité de 34 % à 65 % ; coût par dépistage du modèle commun (hypothèse)"
    leviers := [.depistageColorectal participationDepistageCible] },

  { id := "O-81"
    titre := "Scolarisation des 18-24 ans : +1 point par an pendant trois ans (places, bourses)"
    source := s!"Texte Orientation D, mesure 81 ; +{hausseScolarisationParAn / 10} point de scolarisation à chaque âge de 18 à 24 ans par an, 13 300 € par étudiant (DEPP 2024) ; durée attendue de scolarisation de l'IDH"
    leviers := [.scolarisationJeunes hausseScolarisationParAn]
    repetitions := 3
    variantes := [
      { nom := "+5 points (250 000 places)", leviers := [.scolarisationJeunes 17] }] },

  { id := "O-82"
    titre := "Loi intégrale contre les violences sexistes et sexuelles : 2,6 Md€ par an"
    source := s!"Texte Orientation D, mesure 82 ; Fondation des femmes : besoin de 2,6 à 5,4 Md€ par an ; crédits existants < 200 M€ (dont 95,6 M€ au programme 137 en 2026, amendement CF1398 au PLF 2026) : {besoinViolencesSexistes - creditsViolencesExistants} M€ de dépense nouvelle"
    leviers := [.depenseSur .securiteJustice (besoinViolencesSexistes - creditsViolencesExistants)]
    variantes := [
      { nom := "haut de la fourchette (5,4 Md€)", leviers := [.depenseSur .securiteJustice (5400 - creditsViolencesExistants)] }] },

  { id := "O-83"
    titre := "Allocations familiales dès le premier enfant : 70 € par mois"
    source := s!"Texte Orientation D, mesure 83 ; proposition de loi adoptée en première lecture le 5 juin 2025 ; direction de la Sécurité sociale (rapport AN n° 1473, p. 19-20) : {allocationsPremierEnfantBrut} M€ bruts, {allocationsPremierEnfantNet} M€ nets des moindres versements de RSA et de prime d'activité"
    leviers := [.depenseSur .famille allocationsPremierEnfantBrut,
                .economieSur .famille (allocationsPremierEnfantBrut - allocationsPremierEnfantNet)]
    variantes := [
      { nom := "75 € par mois, modulés selon le revenu (LexImpact : 3,58 Md€ bruts)",
        leviers := [.depenseSur .famille 3580,
                    .economieSur .famille (3580 * (allocationsPremierEnfantBrut - allocationsPremierEnfantNet) / allocationsPremierEnfantBrut)] }] },

  { id := "O-84"
    titre := "Deuxième journée de solidarité : sept heures de plus par an, contribution des employeurs affectée à l'autonomie"
    source := s!"Contribution de solidarité par le travail votée par le Sénat le 20 novembre 2024 (PLFSS 2025, 216 voix contre 119) : ≈ 2,5 Md€ par an ; 7 heures sur 1 607 = +{heuresSolidaritePm} ‰ de durée du travail ; CSA de 0,3 % à 0,6 % : {contributionSolidariteAutonomie} M€ de cotisations, dépensés pour l'autonomie"
    leviers := [.dureeTravail heuresSolidaritePm, .prelevementSur .cotisations contributionSolidariteAutonomie,
                .depenseSur .sante contributionSolidariteAutonomie] },

  { id := "O-85"
    titre := "Santé mentale : 100 M€ de moyens supplémentaires par an"
    source := s!"Texte Orientation D, mesure 85 ; +{santeMentale} M€ par an, ≈ 0,4 % des 23 Md€ remboursés pour les troubles psychiques (voir `santeMentale`)"
    leviers := [.depenseSur .sante santeMentale] },

  { id := "O-86"
    titre := "Liberté fiscale des collectivités : taux de taxe foncière sans plafond ni lien, taxe d'habitation rétablissable"
    source := s!"Texte Orientation D, mesure 86 ; plafond actuel du taux de taxe foncière : 2,5 fois le taux moyen (CGI, art. 1636 B septies) ; taxe d'habitation des résidences principales : {produitTaxeHabitation} M€ avant sa suppression, compensés (DGCL) ; sans effet sur le solde à taux inchangés (voir `produitTaxeHabitation`)"
    leviers := []
    variantes := [
      { nom := "taxe d'habitation rétablie par des collectivités pesant 10 % de l'ancien produit (2,3 Md€), compensations maintenues",
        leviers := [.prelevementSur .autres (produitTaxeHabitation / 10)] }] },

  { id := "O-87"
    titre := "Référendum d'initiative citoyenne"
    source := s!"Texte Orientation D, mesure 87 ; révision constitutionnelle ; {coutReferendum} M€ par scrutin non dématérialisé (ministre de l'Intérieur, 11 mai 2025) ; hypothèse : un scrutin par an, non couplé à une élection (voir `coutReferendum`)"
    leviers := [.depenseSur .fonctionnement coutReferendum]
    variantes := [
      { nom := "scrutins dématérialisés (100 M€)", leviers := [.depenseSur .fonctionnement (coutReferendum / 2)] },
      { nom := "scrutins couplés aux élections (sans coût d'organisation propre)", leviers := [] }] },

  { id := "O-88"
    titre := "Médecins scolaires : effectif doublé, 800 de plus en quatre ans"
    source := s!"Texte Orientation D, mesure 88 ; 818 médecins en 2022, un pour 13 300 élèves, 44 % de postes vacants ; +{medecinsScolairesNouveaux} médecins à {coutMedecinScolaireEuros / 1000} k€ par an, revalorisation comprise (hypothèse) : {medecinsScolairesNouveaux * coutMedecinScolaireEuros / 1000000} M€ par an une fois tous recrutés, par quarts (voir `medecinsScolairesNouveaux`)"
    leviers := [.depenseSur .enseignement (medecinsScolairesNouveaux * coutMedecinScolaireEuros / 1000000 / 4)]
    repetitions := 4
    variantes := [
      { nom := "retour au niveau de 2013 (1 143 médecins, 325 de plus)",
        leviers := [.depenseSur .enseignement (325 * coutMedecinScolaireEuros / 1000000 / 4)] }] },

  { id := "O-89"
    titre := "Fin de l'octroi de mer, compensée aux collectivités par l'État"
    source := s!"Texte Orientation D, mesure 89 ; 1,644 Md€ en 2022 (Cour des comptes, 5 mars 2024), {octroiDeMer2025} M€ en 2025 (calcul, voir `octroiDeMer2025`) ; effet sur la demande d'un impôt national (la part importée de la consommation des outre-mer n'est pas isolée)"
    leviers := [.prelevementSur .autres (-octroiDeMer2025)]
    variantes := [
      { nom := "remplacé par une TVA régionale de même rendement (scénario de rupture de la Cour des comptes)", leviers := [] }] },

  { id := "O-90"
    titre := "Pompes à chaleur gratuites dans les zones rurales, 100 000 par an, financées en partie par les coûts de réseau de gaz évités"
    source := s!"Texte Orientation D, mesure 90 ; {pacRuralesParAn} PAC par an (hypothèse) à {coutPacEuros} €, coût moyen d'une PAC air/eau ; chaleur de 12 MWh, coefficient de performance 2,9 (ADEME), 75 % de chaudières au fioul ou au GPL en zone rurale (SDES) ; coûts de réseau de gaz évités de 67 € par an et par logement (CRE) ; effet d'aubaine des aides à la rénovation (voir `pacRuralesParAn`)"
    leviers := [.pompesAChaleur .rural pacRuralesParAn coutPacEuros]
    variantes := [
      { nom := "50 000 PAC par an", leviers := [.pompesAChaleur .rural (pacRuralesParAn / 2) coutPacEuros] },
      { nom := "200 000 PAC par an", leviers := [.pompesAChaleur .rural (2 * pacRuralesParAn) coutPacEuros] }] },

  { id := "O-91"
    titre := "Zones d'électrification industrielle : tarif d'électricité négocié, hors ZAN"
    source := s!"Texte Orientation D, mesure 91 ; consommation industrielle de la trajectoire « rapide » de RTE au lieu de la « lente » : +{zonesGwh} GWh par an en cinq ans ({zonesMw} MW) ; {zonesEmplois} emplois (ratio de Dunkerque) ; {zonesHa} ha hors ZAN (ratio des sites clés en main) ; tarif de long terme d'EDF sur une électricité sinon modulée, sans coût budgétaire (voir `zonesGwh`)"
    leviers := [.consommationElectrique (zonesGwh / 5), .implantations .industrie (zonesEmplois / 5),
                .annonceEmplois (zonesEmplois / 5), .artificialisationHorsZan .activites [zonesHa / 5]]
    repetitions := 5
    variantes := [
      { nom := "foncier dans l'enveloppe du ZAN",
        leviers := [.consommationElectrique (zonesGwh / 5), .implantations .industrie (zonesEmplois / 5),
                    .annonceEmplois (zonesEmplois / 5), .artificialisation .activites [zonesHa / 5]] }] },

  { id := "O-92"
    titre := "Déserts médicaux : 50 000 € à l'installation en zone prioritaire, puis 5 000 € par an pendant cinq ans"
    source := s!"Texte Orientation D, mesure 92 ; {installationsZip} premières installations de généralistes en zone prioritaire en 2025 (Cnam) ; aide portée de 10 000 à 50 000 € (ancienne CAIM) : {installationsZip * aideInstallationZip / 1000000} M€ par an ; 5 000 € par an pendant cinq ans (ancien COSCOM) : jusqu'à {primesZip.getLastD 0} M€ par an (voir `installationsZip`)"
    leviers := [.depenseSur .sante (installationsZip * aideInstallationZip / 1000000),
                .depenseEcheancier .sante primesZip]
    variantes := [
      { nom := "aide de 100 000 € à l'installation",
        leviers := [.depenseSur .sante (installationsZip * (100000 - 10000) / 1000000),
                    .depenseEcheancier .sante primesZip] }] },

  { id := "O-93"
    titre := "Minimum de pension des retraités agricoles porté à 100 % du SMIC net"
    source := s!"Texte Orientation D, mesure 93 ; garantie des chefs d'exploitation à carrière complète de 85 % à 100 % du SMIC net agricole (+214,30 € par mois) ; 224 681 bénéficiaires du complément différentiel (MSA, fin 2025) : {minimumAgricole} M€ par an (calcul, voir `minimumAgricole`)"
    leviers := [.depenseSur .retraites minimumAgricole]
    variantes := [
      { nom := "extrapolation de la loi Chassaigne de 2020 (283 M€ pour 10 points de SMIC) : 425 M€",
        leviers := [.depenseSur .retraites 425] }] },

  { id := "O-94"
    titre := "Emplois aidés ciblés sur l'industrie : 20 000 contrats initiative emploi"
    source := s!"Texte Orientation D, mesure 94 ; {contratsIndustrie} contrats en cours (hypothèse), aide de 47 % du SMIC brut (plafond du CIE) : {aideCieEuros} € par contrat et par an ; 0,16 emploi net par contrat (Dares) (voir `contratsIndustrie`)"
    leviers := [.emploisAides .industrie contratsIndustrie aideCieEuros 840]
    variantes := [
      { nom := "0,25 emploi net par contrat (emplois d'avenir du secteur marchand)",
        leviers := [.emploisAides .industrie contratsIndustrie aideCieEuros 750] }] },

  { id := "O-98"
    titre := "Accompagnement des entreprises en cybersécurité : chèque cyber pour 50 000 TPE et PME par an, Cybermalveillance.gouv.fr et CSIRT régionaux"
    source := s!"Texte Orientation D, mesure 98 ; chèque de 50 % des dépenses, au plus 2 500 € (TPE) ou 10 000 € (PME), modèle de l'Île-de-France ; 40 000 TPE et 10 000 PME par an (hypothèse) : {chequesCyber} M€ ; Cybermalveillance.gouv.fr à 3 M€ et CSIRT régionaux : {cyberGipCsirt} M€ (voir `chequesCyber`)"
    leviers := [.depenseSur .affairesEconomiques (chequesCyber + cyberGipCsirt)]
    variantes := [
      { nom := "chèque pour 25 000 entreprises par an", leviers := [.depenseSur .affairesEconomiques (chequesCyber / 2 + cyberGipCsirt)] }] },

  { id := "O-99"
    titre := "Amendes renforcées en cas de fuite de données : jusqu'à 4 % du chiffre d'affaires mondial"
    source := s!"Texte Orientation D, mesure 99 ; plafonds NIS2 (au moins 2 % et 1,4 % du CA) et amendes pénales des personnes morales portés à 4 % et 2,8 % du CA mondial ; RGPD (2 % pour la sécurité) à relever au niveau européen ; amendes pour défaut de sécurité doublées : +{amendesFuitesSupplementaires} M€ par an (calcul, voir `amendesFuitesSupplementaires`)"
    leviers := [.recetteEcheancier none [amendesFuitesSupplementaires]] }
]

def programme : Programme where
  id := "TexteOrientationD"
  nom := "Texte Orientation D"
  description := "Texte Orientation D : remplacement des voitures les plus polluantes, amendes SRU proportionnelles, attributions HLM vérifiables par preuve ZK, six EPR2, prime à l'électrique et bornes, retraite à la durée cotisée sans âge légal, IS à 15 %, démission indemnisée, moyens pour la justice, lignes nouvelles ferroviaires, qualité d'accueil touristique, conduite autonome avec indemnisation des taxis par cohorte d'âge, prévention des accidents du travail, logiciel libre, universités (dette, reconstruction, Parcoursup, places), économies et recettes (apprentissage, commande publique, médicament, fraude), dette numérique en stablecoin exonérée de PFU, enseignants (+2 %/an), automatisation des contrôles administratifs, simplification pour les généralistes, désindexation des très hautes retraites, TVA à 22 %, taxe sur les jets privés, agriculture électrique, DPE et climatisation dans les quartiers historiques, urbanisme des quartiers de gare, TER 24 h sur 24, redressement compatible PS (CSG sur les gros héritages, taxe numérique, cotisations, fraude, niches, patrimoine, norme de dépense), défense −1 Md€, 174 trimestres, lutte contre la fraude fiscale, CSG progressive pour les hauts revenus, participations dans les entreprises stratégiques, fin des concessions autoroutières, hauts fonctionnaires −5 %, revenus des élus, fin du PFU, rachats d'actions, cabinets de conseil, trajectoire de baisse continue du déficit (CRDS prolongée, norme renforcée, aides aux entreprises, niches, durée de cotisation), CVAE maintenue et contribution des grandes entreprises pérennisée, rénovation majorée en zone rurale, eau potable et électricité pour tous dans les outre-mer, remboursement des dettes cachées (heures supplémentaires des policiers, RIFSEEP des enseignants), CIR recentré, assurance-vie au barème, contribution des poids lourds, kérosène des vols intérieurs, défiscalisation des heures supplémentaires réduite de moitié, heures supplémentaires non payées des hôpitaux, 100 000 places de prison en cellule individuelle, allègements recentrés sous 2 SMIC, accompagnement renforcé des demandeurs d'emploi, prix minimum de l'alcool, prix du tabac, dépistage du cancer colorectal, scolarisation des 18-24 ans, loi intégrale contre les violences sexistes et sexuelles, allocations familiales dès le premier enfant, deuxième journée de solidarité pour l'autonomie, santé mentale, liberté fiscale des collectivités (taxe foncière, taxe d'habitation), référendum d'initiative citoyenne, médecins scolaires, fin de l'octroi de mer, pompes à chaleur gratuites en zone rurale, zones d'électrification industrielle hors ZAN, aides à l'installation dans les déserts médicaux, minimum de pension agricole, emplois aidés dans l'industrie, accompagnement des entreprises en cybersécurité, amendes renforcées en cas de fuite de données."
  mainteneurs := ["@orientationd"]
  source := "Programme de orientation_d (texte en cours de rédaction)"
  mesures := mesures
  entreeEnVigueur := 2

end Programmes.TexteOrientationD
