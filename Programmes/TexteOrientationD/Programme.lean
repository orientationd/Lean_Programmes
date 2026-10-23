import Modele
import Hypotheses
import Proprietes

/-!
# Programme « Texte Orientation D »

Programme de orientation_d. Seuls les comptes listés dans `PROPRIETAIRES`
peuvent modifier ce dossier : la CI refuse toute autre PR (contrôle d'accès
aux programmes).

Mesures (extrait) :

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
* **O-35** à **O-42** — redressement compatible avec les positions du PS :
  taxe Zucman, CSG sur les gros héritages, taxe numérique à 15 %,
  exonérations de cotisations, fraude fiscale et train de vie de l'État,
  niches fiscales, Pacte Dutreil et holdings, norme de dépense.

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

/-- Redressement compatible avec les positions du PS (O-35 à O-42). Base :
propositions du groupe socialiste à l'Assemblée (16 septembre 2026 : taxe
Zucman 15 Md€, CSG sur les gros héritages 10 Md€, taxe sur les géants du
numérique 10 Md€, reconfiguration des exonérations de cotisations 4 Md€,
12,1 Md€ d'économies par la lutte contre la fraude fiscale et le train de
vie de l'État), complétées par la note de la Cour des comptes sur la
fiscalité du patrimoine (septembre 2026) et une revue des niches fiscales.
Les rendements sont statiques ; le modèle retire sa fuite fiscale (20 % au
scénario central) et calcule l'effet d'activité.

* `taxeZucman` = 6,5 Md€ : 15 à 25 Md€ selon ses promoteurs, ≈ 5 Md€
  selon sept économistes (Le Monde, septembre 2025) et 4,6 à 5,5 Md€ avec
  imputation de l'IS (Institut de l'entreprise, 2026). Retenu : 6,5 Md€
  statiques, ≈ 5,2 Md€ nets de la fuite fiscale. Variante : chiffrage PS.
* `csgHeritages` = 10 Md€ : chiffrage du groupe PS, sans contre-expertise
  connue (droits de succession et donations ≈ 17 Md€ par an).
* `taxeNumerique` = 3,1 Md€ : taxe sur les services numériques de 3 % à
  15 %, 0,89 → ≈ 4 Md€ (commission des finances, octobre 2026). Le PS
  annonce 10 Md€ (variante). Risque de représailles commerciales.
* `exonerationsCotisations` = 4 Md€ : reconfiguration des allègements
  généraux (chiffrage PS).
* `fraudeFiscale` = 3 Md€ et `trainDeVieEtat` = 3,1 Md€ : les 12,1 Md€
  du PS, moins ce que comptent déjà O-21 (commande publique, 3 Md€) et
  O-23 (fraude sociale et TVA, 3 Md€).
* `nichesFiscales` = 8 Md€ : 465 niches pour 88,3 Md€ en 2026 (PLF 2026) ;
  −10 % hors Pacte Dutreil (traité à part) et hors dispositifs pour les
  ménages modestes, réparti entre IR (4), IS (2) et TVA (2).
* `pacteDutreil` = 1,3 Md€ (abattement de 75 % à 50 %) et `holdings` =
  1,0 Md€ (taxe sur les holdings élargie) : Cour des comptes, note du
  21 septembre 2026, à comportements inchangés.
* `normeDepense` = 50 pb : les dépenses pilotables (santé, affaires
  économiques, sécurité-justice, logement-environnement, culture, services
  généraux ; ≈ 739 Md€ en 2025) croissent de 2,3 % au lieu de 2,8 % par an,
  soit +0,5 % en volume pour 1,8 % d'inflation. Retraites, famille,
  enseignement et défense sont hors norme. Variante : zéro volume (100 pb).
-/
def taxeZucman : Int := 6500
def csgHeritages : Int := 10000
def taxeNumerique : Int := 3100
def exonerationsCotisations : Int := 4000
def fraudeFiscale : Int := 3000
def trainDeVieEtat : Int := 3100
def nichesFiscales : Int := 8000
def pacteDutreil : Int := 1300
def holdings : Int := 1000
def normeDepensePb : Int := 50

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
    source := s!"Texte Orientation D, mesure 13 ; {titulairesTaxi} titulaires (hypothèse sur 62 800 ADS, Observatoire T3P 2024), pyramide des âges INSEE 2016 (moyenne 49 ans), {indemniteTaxi} € par an jusqu'à {ageRetraiteTaxi} ans : {indemnitesAnnee titulairesTaxi 0 0 0} M€ la première année, {indemnitesAnnee titulairesTaxi 0 0 8} M€ au bout de huit ans ; {sortiesTaxis titulairesTaxi} titulaires de {ageSortieTaxi} ans et plus quittent la population active, les autres se reclassent ; +0,05 % de PIB (voir `titulairesTaxi`)"
    leviers := leviersTaxis titulairesTaxi 0 0
    debut := 2
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
    debut := 2 },

  { id := "O-25"
    titre := "Rémunération des enseignants : +2 % par an"
    source := s!"Texte Orientation D, mesure 25 ; masse salariale hors CAS Pensions 59,23 Md€ en 2026 (PLF 2026), base 2027 {masseEnseignants2027} M€ ; +2 %/an au-delà de la tendance de 2027 à 2035 : {revalorisationsEnseignants.head!} M€ la première année, {revalorisationsEnseignants[8]!} M€ (euros 2027) la neuvième (2035)"
    leviers := [.depenseEcheancier .enseignement revalorisationsEnseignants]
    debut := 2 },

  { id := "O-26"
    titre := "Automatisation des tâches administratives : 10 000 postes de contrôle supprimés par an pendant cinq ans"
    source := s!"Texte Orientation D, mesure 26 ; {postesControleParAn} postes par an × 5, non remplacés, à {coutPosteControle} € (hypothèse, DGAFP 2024) ; outil : {investissementParPoste} € par poste la même année puis {maintenanceParPoste} €/an (hypothèses)"
    leviers := [.suppressionPostes .fonctionnement postesControleParAn coutPosteControle,
                .depenseEcheancier .fonctionnement [postesControleParAn * investissementParPoste / 1000000, 0],
                .depenseSur .fonctionnement (postesControleParAn * maintenanceParPoste / 1000000)]
    debut := 2
    repetitions := 5 },

  { id := "O-27"
    titre := "Médecins généralistes : simplification des tâches administratives ; enquêteurs humains sur les cas anormaux à la place des contrôles systématiques"
    source := s!"Texte Orientation D, mesure 27 ; DREES 2019 : 5 h 30 de gestion par semaine sur 54 h ; moitié supprimée pour {generalistesLiberaux} généralistes libéraux : {heuresLibereesMilliers} milliers d'heures de soin libérées par an, ≈ {etpGeneralistesLiberes} généralistes à temps plein, {consultationsMilliers} milliers de consultations possibles ; {enqueteurs} enquêteurs à {coutEnqueteur} € (hypothèses)"
    leviers := [.depenseSur .sante (enqueteurs * coutEnqueteur / 1000000)]
    debut := 2
    variantes := [
      { nom := s!"temps libéré converti en consultations remboursées (+{coutConsultations} M€/an)",
        leviers := [.depenseSur .sante (enqueteurs * coutEnqueteur / 1000000), .depenseSur .sante coutConsultations] }] },

  { id := "O-24"
    titre := "Dette numérique : achat d'OAT tokenisées en stablecoin euro (mécanisme USDC), intérêts exonérés de PFU"
    source := s!"Texte Orientation D, mesure 24 ; OAT numériques réglées en jetons de monnaie électronique (MiCA, règlement (UE) 2023/1114, art. 50 : pas d'intérêt sur le jeton), régime pilote DLT (règlement (UE) 2022/858, à réviser) ; exonération du PFU de 31,4 % (LFSS 2026) pour les particuliers résidents ; tranche cible {cibleDetteNumerique} ‰ de la dette (+{rythmeDetteNumerique} ‰/an, première tranche fin 2028), capitalisation fiscale {capitalisationFiscale} ‰ (obligations municipales américaines), part des résidents {partResidents} ‰, part imposée auparavant {partImposeeAvant} ‰"
    leviers := [.detteNumerique cibleDetteNumerique rythmeDetteNumerique capitalisationFiscale
                  partResidents partImposeeAvant]
    debut := 2 },

  { id := "O-28"
    titre := "Désindexation des très hautes retraites : revalorisation limitée à la part sous 5 150 € par mois"
    source := s!"Texte Orientation D, mesure 28 ; 1 % des retraités au-delà de 5 150 € bruts, 6 470 € en moyenne (DREES) ; part au-delà du seuil {masseAuDelaSeuil} M€ (2027), revalorisation évitée {inflationPb} pb/an : {(desindexation masseAuDelaSeuil).head!} M€ la première année, {(desindexation masseAuDelaSeuil)[8]!} M€ en 2035 (euros 2027)"
    leviers := [.depenseEcheancier .retraites (desindexation masseAuDelaSeuil)]
    debut := 2
    variantes := [
      { nom := s!"gel de toute la pension au-delà du seuil ({masseTresHautes} M€ concernés)",
        leviers := [.depenseEcheancier .retraites (desindexation masseTresHautes)] }] },

  { id := "O-29"
    titre := "TVA : taux normal porté de 20 % à 22 %"
    source := s!"Texte Orientation D, mesure 29 ; un point de taux normal ≈ 8 Md€ (FIPECO, IPP, Sénat) : {tvaDeuxPoints} M€ de rendement statique, net de la fuite fiscale du modèle"
    leviers := [.prelevementSur .tva tvaDeuxPoints]
    debut := 2 },

  { id := "O-30"
    titre := "Taxe forfaitaire à l'atterrissage des jets privés"
    source := s!"Texte Orientation D, mesure 30 ; {atterrissagesJets} atterrissages par an (84 885 départs en 2022, Greenpeace) × {taxeAtterrissage} € (hypothèse) ; fuite fiscale du modèle pour le report et la baisse des vols"
    leviers := [.prelevementSur .autres (atterrissagesJets * taxeAtterrissage / 1000000)]
    debut := 2
    variantes := [
      { nom := "taxe de 1 000 € par atterrissage", leviers := [.prelevementSur .autres (atterrissagesJets * 1000 / 1000000)] }] },

  { id := "O-31"
    titre := "Plan de conversion à l'électrique de l'ensemble des exploitations agricoles (dix ans)"
    source := s!"Texte Orientation D, mesure 31 ; {exploitationsAgricoles} exploitations (RA 2020) × {aideConversion} € sur dix ans (hypothèse) ; énergie agricole ≈ 37 TWh de produits pétroliers, {emissionsEnergieAgricole} Mt de CO₂ ; importations nettes −{(carburantAgricoleImporte - electriciteNonExportee) / 10} M€ par an"
    leviers := [.depenseEcheancier .affairesEconomiques [exploitationsAgricoles * aideConversion / 10 / 1000000, 0],
                .transition (emissionsEnergieAgricole / 10) 0,
                .importationsNiveau (-((carburantAgricoleImporte - electriciteNonExportee) / 10))]
    debut := 2
    repetitions := 10 },

  { id := "O-32"
    titre := "Suppression du DPE pour les immeubles de Paris et des quartiers historiques ; climatisation réversible aidée par l'État"
    source := s!"Texte Orientation D, mesure 32 ; DPE : sans effet budgétaire ; {logementsClimatisation} logements par an × {aideClimatisation} € pendant dix ans (hypothèses) ; effet sur les émissions inférieur à la résolution du modèle (1 Mt)"
    leviers := [.depenseEcheancier .logementEnvironnement [logementsClimatisation * aideClimatisation / 1000000, 0]]
    debut := 2
    repetitions := 10 },

  { id := "O-33"
    titre := "Pas d'immeubles de grande hauteur dans les quartiers historiques ; quartiers nouveaux autour des pôles très desservis (Val de Fontenay)"
    source := s!"Texte Orientation D, mesure 33 ; interdiction sans effet budgétaire ; {logementsQuartiersGare} logements par an × {aideLogementQuartierGare} € d'équipements publics (hypothèses)"
    leviers := [.investissement .logementEnvironnement (logementsQuartiersGare * aideLogementQuartierGare / 1000000)]
    debut := 2 },

  { id := "O-34"
    titre := "TER 24 h sur 24 entre métropoles et villes moyennes (Orléans…), agents de sécurité à bord, en gare et aux parkings"
    source := s!"Texte Orientation D, mesure 34 ; {liaisonsTerNuit} liaisons de {distanceTerKm} km, {trainsParNuit} trains par nuit, 23,40 € par train-km (IFRAP 2024), {heuresAgentsParNuit} heures d'agents par nuit à {coutHeureAgent} €, {couvertureRecettesPm / 10} % couverts par les recettes : {coutTerNuit} M€ par an"
    leviers := [.depenseSur .affairesEconomiques coutTerNuit]
    debut := 2 },

  { id := "O-35"
    titre := "Impôt plancher sur les très hauts patrimoines (taxe Zucman)"
    source := s!"Texte Orientation D, mesure 35 ; proposition du groupe PS (15 Md€) ; retenu {taxeZucman} M€ statiques (≈ 5 Md€ selon sept économistes, 4,6 à 5,5 Md€ avec imputation de l'IS)"
    leviers := [.prelevementSur .autres taxeZucman]
    debut := 2
    variantes := [{ nom := "chiffrage du groupe PS (15 Md€)", leviers := [.prelevementSur .autres 15000] }] },

  { id := "O-36"
    titre := "CSG sur les gros héritages"
    source := s!"Texte Orientation D, mesure 36 ; chiffrage du groupe PS : {csgHeritages} M€ (sans contre-expertise connue)"
    leviers := [.prelevementSur .csgCrds csgHeritages]
    debut := 2 },

  { id := "O-37"
    titre := "Taxe sur les services numériques portée de 3 % à 15 %"
    source := s!"Texte Orientation D, mesure 37 ; 0,89 Md€ à 3 %, ≈ 4 Md€ à 15 % (commission des finances, octobre 2026) : +{taxeNumerique} M€ ; le PS annonce 10 Md€"
    leviers := [.prelevementSur .autres taxeNumerique]
    debut := 2
    variantes := [{ nom := "chiffrage du groupe PS (10 Md€)", leviers := [.prelevementSur .autres 10000] }] },

  { id := "O-38"
    titre := "Reconfiguration des exonérations de cotisations patronales"
    source := s!"Texte Orientation D, mesure 38 ; chiffrage du groupe PS : {exonerationsCotisations} M€"
    leviers := [.prelevementSur .cotisations exonerationsCotisations]
    debut := 2 },

  { id := "O-39"
    titre := "Lutte contre la fraude fiscale ; train de vie de l'État"
    source := s!"Texte Orientation D, mesure 39 ; 12,1 Md€ du groupe PS, moins O-21 et O-23 déjà comptés : {fraudeFiscale} M€ de fraude fiscale (TVA) et {trainDeVieEtat} M€ d'économies de fonctionnement"
    leviers := [.prelevementSur .tva fraudeFiscale, .economieSur .fonctionnement trainDeVieEtat]
    debut := 2 },

  { id := "O-40"
    titre := "Revue des niches fiscales : −10 % hors Pacte Dutreil et hors dispositifs pour les ménages modestes"
    source := s!"Texte Orientation D, mesure 40 ; 465 niches, 88,3 Md€ en 2026 (PLF 2026) ; {nichesFiscales} M€ (IR 4, IS 2, TVA 2)"
    leviers := [.prelevementSur .ir 4000, .prelevementSur .impotSocietes 2000, .prelevementSur .tva 2000]
    debut := 2 },

  { id := "O-41"
    titre := "Fiscalité du patrimoine (Cour des comptes) : Pacte Dutreil ramené à 50 %, taxe sur les holdings élargie"
    source := s!"Texte Orientation D, mesure 41 ; Cour des comptes, note du 21 septembre 2026 : {pacteDutreil} M€ (Dutreil, 5,5 Md€ de coût en 2024) et {holdings} M€ (holdings)"
    leviers := [.prelevementSur .autres (pacteDutreil + holdings)]
    debut := 2 },

  { id := "O-42"
    titre := "Norme de dépense : +0,5 % en volume pour les dépenses pilotables (hors retraites, famille, enseignement, défense)"
    source := s!"Texte Orientation D, mesure 42 ; {normeDepensePb} pb de moins par an sur ≈ 739 Md€ de dépenses pilotables (2025) : 2,3 % au lieu de 2,8 %"
    leviers := [.normeDepense normeDepensePb]
    debut := 2
    variantes := [{ nom := "zéro volume (100 pb)", leviers := [.normeDepense 100] }] }
]

def programme : Programme where
  id := "TexteOrientationD"
  nom := "Texte Orientation D"
  description := "Texte Orientation D : remplacement des voitures les plus polluantes, amendes SRU proportionnelles, attributions HLM vérifiables par preuve ZK, six EPR2, prime à l'électrique et bornes, retraite à la durée cotisée sans âge légal, IS au taux le plus bas de l'UE, démission indemnisée, moyens pour la justice, lignes nouvelles ferroviaires, qualité d'accueil touristique, conduite autonome avec indemnisation des taxis par cohorte d'âge, prévention des accidents du travail, logiciel libre, universités (dette, reconstruction, Parcoursup, places), économies et recettes (apprentissage, commande publique, médicament, fraude), dette numérique en stablecoin exonérée de PFU, enseignants (+2 %/an), automatisation des contrôles administratifs, simplification pour les généralistes, désindexation des très hautes retraites, TVA à 22 %, taxe sur les jets privés, agriculture électrique, DPE et climatisation dans les quartiers historiques, urbanisme des quartiers de gare, TER 24 h sur 24, redressement compatible PS (taxe Zucman, CSG sur les gros héritages, taxe numérique, cotisations, fraude, niches, patrimoine, norme de dépense)."
  mainteneurs := ["@orientationd"]
  source := "Programme de orientation_d (texte en cours de rédaction)"
  mesures := mesures

end Programmes.TexteOrientationD
