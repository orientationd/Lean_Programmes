import Modele

/-!
# Situation de départ

Comptes publics et données démographiques observés pour 2025, point de
départ des projections (année 0). Chaque valeur cite sa source ; les
valeurs marquées « dérivé » sont calculées à partir des évolutions publiées
par l'INSEE (niveau 2025 = hausse publiée × (1 + 1 / taux de hausse)).

Valeurs encore provisoires : SMIC (repère), émissions.

## Lois en vigueur

La projection à législation constante applique les textes votés dont les
effets ne sont pas proportionnels au PIB :

* **Âge légal** (loi n° 2023-270, suspendue par l'article 45 de la LFSS
  pour 2026, loi n° 2025-1403) : 62 ans et 9 mois en 2025, gelé jusqu'en
  janvier 2028, puis +3 mois par génération ; 64 ans atteints par la
  génération 1969, en 2033. Calendrier par année : `calendrierAgeLegal`.
  La tendance des dépenses de retraite et de la population active est
  supposée intégrer la réforme de 2023 sans suspension (projections du COR
  de juin 2025), soit 64 ans dès 2032 : `calendrierAgeTendanciel`. La
  suspension coûte donc 3 mois de départs (≈ 1,9 Md€) de 2027 à 2032,
  conformément au chiffrage du Gouvernement (1,9 Md€ en 2027).
* **Loi de programmation militaire actualisée** (loi n° 2026-791) : crédits
  de la mission Défense hors pensions de 57,1, 63,3, 68,3, 72,8 et 76,3 Md€
  de 2026 à 2030, contre 50,5 Md€ en 2025. Échéancier de dépense :
  écart à la reconduction tendancielle, en euros 2025 (voir
  `echeancesDepart`) ; le niveau de 2030 est ensuite reconduit.
* **ETS2** (directive 2003/87/CE modifiée par la directive 2023/959 ; début
  reporté à 2028 par la loi européenne sur le climat 2040, JO de l'UE du
  18 mars 2026) : quotas sur les carburants routiers et le chauffage. Recette
  de ≈ 6,5 Md€ en 2028 (≈ 160 Mt à ≈ 50 €/t, moins la part du Fonds social
  pour le climat), soit 5 950 M€ en euros 2025 ; la directive affecte le
  produit au climat et au social : la moitié est supposée redistribuée en
  dépense nouvelle (rénovation, chèques), l'autre moitié finançant des
  dépenses existantes. Effet sur les émissions : déjà dans la tendance.
* **Contribution exceptionnelle sur les bénéfices des grandes entreprises**
  (loi n° 2025-127 ; reconduite une année par la loi de finances
  pour 2026, loi n° 2026-103) : ≈ 8 Md€ en 2025, 7,5 Md€ en 2026 (acompte du
  15 décembre 2026), puis rien à législation constante. Le PLF 2027 (article
  15) propose une troisième année à taux réduits (5 Md€) : non retenu tant
  qu'il n'est pas voté.
* **CVAE** (loi n° 2025-127, art. 62, trajectoire confirmée par la loi de
  finances pour 2026) : taux maximal de 0,28 % en 2026 et 2027, 0,19 % en
  2028, 0,09 % en 2029, suppression en 2030. Rendement à 0,28 % ≈ 3,4 Md€
  (le passage à 0,19 % coûtait ≈ 1,1 Md€ : Sénat, amendement I-31 au PLF
  2026).
* **Contribution différentielle sur les hauts revenus** (loi n° 2025-127) :
  20 % d'imposition minimale au-delà de 250 000 € de revenu, due
  jusqu'à ce que le déficit public passe sous 3 % du PIB ; ≈ 0,4 Md€
  encaissés en 2025 (prévision initiale 1,9 Md€ ; Les Échos, La Tribune,
  début 2026). Suivie dans l'état (`cdhrMeur`) : la projection l'éteint
  l'année qui suit un déficit inférieur à 3 %.
* **Droits de succession et de donation** (CGI, art. 777 à 800) : 20,7 Md€
  en 2025 (successions 16,2, donations 4,5). Barème en ligne directe de 5 %
  à 45 % après un abattement de 100 000 € par enfant, renouvelable tous les
  15 ans (loi n° 2012-958 du 16 août 2012) ; abattements et tranches non
  indexés : la projection fait croître les droits avec le flux successoral
  (décès de l'axe démographique, patrimoine par décès) et une élasticité
  supérieure à 1 (axe économique). Lois associées, dont l'effet est dans le
  niveau de 2025 :
  - exonération du conjoint survivant et du partenaire de PACS (loi
    n° 2007-1223 du 21 août 2007, dite TEPA) ;
  - Pacte Dutreil (art. 787 B) : 75 % de la valeur des titres exonérés,
    ≈ 5,5 Md€ de moindres recettes en 2024 (Cour des comptes) ; la loi de
    finances pour 2026 en exclut les actifs non professionnels (logements,
    véhicules, objets d'art…) et porte l'engagement individuel de 4 à
    6 ans, pour les transmissions depuis le 21 février 2026 (rendement non
    publié, non chiffré) ;
  - assurance-vie (art. 990 I et 757 B) : 152 500 € d'abattement par
    bénéficiaire pour les primes versées avant 70 ans, puis 20 % et
    31,25 % ; hors barème des successions ;
  - dons familiaux de sommes d'argent (art. 790 G) : 31 865 € tous les
    15 ans ; exonération temporaire de 100 000 € pour l'achat d'un logement
    neuf ou une rénovation énergétique (art. 790 A bis), du 15 février 2025
    au 31 décembre 2026 : sa fin relèvera un peu les droits sur les
    donations à partir de 2027 (coût non publié, non chiffré).
  Non retenus tant qu'ils ne sont pas votés : le PLF 2027 (taux de 6 % sur
  les dons d'argent jusqu'à 100 000 €, don exonéré porté à 100 000 € en
  2027, 790 A bis prolongé jusqu'en 2030, votés en première lecture le
  16 octobre 2026) et les propositions de la Cour des comptes (note du
  21 septembre 2026 : barème −5 points, −2,1 Md€ ; Dutreil à 50 %,
  +1,3 Md€ ; assurance-vie au barème dès la tranche à 20 %, +1,25 Md€).
* **Loi de programmation pour la refondation de Mayotte** (n° 2025-797 du
  11 août 2025) : 730 M€ d'autorisations d'engagement pour l'eau
  (350 M€ en 2025-2027, 380 M€ en 2028-2031), ≈ 0,1 Md€ par an, jugés
  inclus dans la tendance.
* **Fin des ventes de voitures thermiques neuves en 2035** (règlement (UE)
  2023/851) : voir l'axe énergie ; érosion des accises et de la TVA sur les
  carburants calculée dans la projection.
* **AFIR** (règlement (UE) 2023/1804) : propriété `ue-afir-2030`.

Lois dont les effets sont jugés inclus dans la tendance : loi de
programmation de la recherche (marches d'≈ 0,5 Md€ par an, financées pour
un quart dans le PLF 2026), LOPMI et loi de programmation de la justice
(échéance 2027).
-/

namespace Hypotheses
open Modele

/-- Emploi BIT 2025, personnes : 31 834 000 actifs × (1 − 7,9 %) = 29 319 000,
réparti selon
la structure de l'emploi 2024 par secteur (INSEE, estimations d'emploi) :
agriculture 2,2 %, industrie 11,2 %, construction 6,4 %, tertiaire marchand
49,8 %, tertiaire non marchand 30,4 %. -/
def emploi2025 : ParSecteur where
  agriculture := 645000
  industrie := 3284000
  construction := 1876000
  tertiaireMarchand := 14601000
  tertiaireNonMarchand := 8913000

/-- Dépenses 2025 par fonction, M€ : total 1 714,1 Md€ (INSEE) ventilé selon
les parts de la nomenclature COFOG 2023 (INSEE, dépenses des APU par
fonction) ; intérêts 2025 observés. Ordres de grandeur, à préciser avec la
ventilation 2025 dès publication. -/
def depenses2025 : ParFonction where
  retraites := 410000              -- vieillesse-survie ≈ 24 % des dépenses
  sante := 247000                  -- santé ≈ 14,4 %
  famille := 293000                -- famille, chômage, exclusion, invalidité ≈ 17 %
  enseignement := 154000           -- enseignement ≈ 9 %
  affairesEconomiques := 178000    -- affaires économiques ≈ 10,4 %
  defense := 53000                 -- défense ≈ 3,1 %
  securiteJustice := 46000         -- ordre et sécurité publics ≈ 2,7 %
  logementEnvironnement := 82000   -- logement, équipements collectifs, environnement ≈ 4,8 %
  culture := 39000                 -- loisirs, culture, culte ≈ 2,3 %
  interets := 64700                -- intérêts versés 2025, +11,2 % (INSEE, IR n°78)
  fonctionnement := 147400         -- services généraux hors intérêts (solde : 1 714,1 − autres postes)
  nonVentile := 0

/-- Prélèvements 2025, M€. -/
def impots2025 : ParImpot where
  tva := 221100            -- dérivé : +1,1 Md€ soit +0,5 % (INSEE, IR n°78, 27/03/2026)
  ir := 103800             -- dérivé : +7,6 Md€ soit +7,9 % (idem)
  csgCrds := 167200        -- dérivé : +3,6 Md€ soit +2,2 % (idem)
  cotisations := 446300    -- cotisations sociales effectives (idem)
  impotSocietes := 58900   -- dérivé : +2,1 Md€ soit +3,7 % (idem)
  accisesEnergie := 30500  -- TICPE, 30,5 Md€ en 2022, dernier chiffre publié (MTE, via Journal de l'Automobile)
  taxeFonciere := 44100    -- dérivé : TFPB +1,2 Md€ soit +2,8 % (DGCL, note REI 2025)
  droitsMutation := 20700  -- successions 16,2 + donations 4,5 Md€ en 2025 (Legifiscal, 23/09/2026)
  autres := 235700         -- solde : impôts 882,0 + cotisations 446,3 − postes ci-dessus

/-- Éléments temporaires de la situation de départ : dépenses et recettes de
2025 dont la fin est prévue par les textes ou les calendriers en vigueur.
Sans eux, la projection les reconduirait indéfiniment.

* **Grand Paris Express** (Société des grands projets, administration
  publique) : ≈ 3,6 Md€ de dépenses par an en 2020-2022, 5,4 Md€ prévus en
  2023 (Sénat, rapport sur le PLF 2024) ; coût 36,1 Md€ ; mises en service
  de 2026 à 2031 (lignes 15 Ouest et Est en 2031). Retenu : 4,0 Md€ en
  2025, décroissant avec les ouvertures, nul à partir de 2032. La dette
  (remboursée jusqu'en 2071 par des taxes affectées, ≈ 0,85 Md€ par an)
  reste dans la dette publique ; les futurs RER métropolitains (SERM, 20 à
  30 Md€) ne sont pas financés à ce jour et ne sont pas reconduits.
* **France 2030** : 54 Md€, ≈ 40 Md€ attribués et 14 Md€ décaissés au
  30 juin 2025, 6,9 Md€ de décaissements prévus en 2026 (Sénat, rapport sur
  le PLF 2026). Retenu : 6,5 Md€ en 2025, 6,7 Md€ en 2026 (euros 2025),
  puis extinction des décaissements jusqu'en 2031 (≈ 26 Md€ restant à
  verser) ; pas de programme successeur à législation constante.
* **CRDS** : 0,5 %, 9,22 Md€ en 2026 ; due jusqu'à l'extinction de la CADES,
  fin 2033 (loi organique). La fraction de CSG affectée à la CADES (0,45 %,
  7,95 Md€) revient alors à la Sécurité sociale (neutre pour les
  administrations publiques) ; la CRDS disparaît : −9 Md€ (euros 2025) à
  partir de 2034. La dette de l'ACOSS (65 Md€ fin 2026) n'étant pas reprise,
  une prolongation reste possible : elle demanderait une loi organique.

Non retenus, faute d'échéance avant 2035 : les loyers des contrats de
partenariat de l'État (9,8 Md€ d'investissements, signés surtout en
2011-2012 pour 27 ans en moyenne : Balard, tribunal de Paris, LGV
Bretagne-Pays de la Loire jusqu'en 2036, contournement Nîmes-Montpellier
jusqu'en 2037) ; les lignes à grande vitesse en service (financement
public versé pendant les travaux), alors que les projets en cours
(Bordeaux-Toulouse, Montpellier-Perpignan, Lyon-Turin) font au contraire
monter la dépense. -/
def echeancesDepart : List Echeance := [
  { fonction := .affairesEconomiques, niveau := 4000, indice := 10000,
    restants := [3600, 3000, 2400, 1800, 1200, 600, 0] },        -- Grand Paris Express
  { fonction := .affairesEconomiques, niveau := 6500, indice := 10000,
    restants := [6700, 6000, 5000, 3800, 2400, 1000, 0] },       -- France 2030
  { fonction := .defense, niveau := 0, indice := 10000,
    restants := [5295, 9865, 12982, 15414, 16748] },             -- LPM actualisée (2026-2030)
  { fonction := .logementEnvironnement, niveau := 0, indice := 10000,
    restants := [0, 0, 2975] } ]                                 -- ETS2 : moitié redistribuée dès 2028

def echeancesRecettesDepart : List EcheanceRecette := [
  { impot := some .csgCrds, niveau := 9000, indice := 10000,
    restants := [9000, 9000, 9000, 9000, 9000, 9000, 9000, 9000, 0] },  -- CRDS, fin de la CADES en 2033
  { impot := some .autres, niveau := 0, indice := 10000,
    restants := [0, 0, 5950] },                                          -- ETS2, enchères dès 2028
  { impot := some .impotSocietes, niveau := 8000, indice := 10000,
    restants := [7280, 0] },                                             -- contribution exceptionnelle des grandes entreprises (7,5 Md€ courants en 2026)
  { impot := some .autres, niveau := 3400, indice := 10000,
    restants := [3400, 3400, 2310, 1090, 0] } ]                          -- CVAE : 0,28 % → 0,19 % → 0,09 % → 0

/-- Hausses de l'âge légal, mois, de 2026 à 2033 : suspension jusqu'en
janvier 2028 (LFSS pour 2026), puis +3 mois par génération (générations
1965 à 1969). -/
def calendrierAgeLegal : List Int := [0, 0, 3, 0, 3, 3, 3, 3]

/-- Calendrier de la loi n° 2023-270 sans suspension (64 ans en 2032),
supposé intégré à la tendance des dépenses et de la population active. -/
def calendrierAgeReforme2023 : List Int := [0, 3, 3, 0, 3, 3, 3, 0]

theorem calendriers_meme_cible : calendrierAgeLegal.sum = calendrierAgeReforme2023.sum := by decide

def reference2026 : Reference where
  id := "ref-2025"
  description := "Situation observée en 2025 (INSEE), départ des projections"
  annee := 2025
  etat := {
    pib := 2992000                 -- déficit 152,5 Md€ = 5,1 % et dette 3 460,5 Md€ = 115,6 % (INSEE)
    impots := impots2025
    autresRecettes := 233300       -- recettes totales 1 561,6 Md€ − impôts et cotisations 1 328,3 Md€
    depensesF := depenses2025      -- 1 714,1 Md€ de dépenses des APU 2025 (INSEE)
    tauxApparentPb := 187          -- 64,7 / 3 460,5
    dette := 3460500               -- dette de Maastricht fin 2025 (INSEE)
    operationsFinancieres := 0     -- flux nets tendanciels supposés nuls (à sourcer)
    smicMensuel := 1820            -- repère provisoire, brut
    emissionsMt := 370             -- à sourcer (inventaire national, Citepa)
    ageLegalMois := 753            -- 62 ans et 9 mois, gelé par la LFSS pour 2026 (loi n° 2025-1403, art. 45)
    populationMilliers := 69100    -- population au 1er janvier 2026 (INSEE, bilan démographique 2025)
    actifs := 31834000             -- population active BIT 2025 (INSEE)
    emploi := emploi2025           -- chômage BIT 7,9 % fin 2025 (INSEE)
    heuresParEmploi := 1494        -- heures annuelles par personne en emploi, 2023 (OCDE)
    migrationAnnuelleMilliers := 0
    emploisAnnonces := 0
    touristesMilliers := 100000    -- 100 millions de visiteurs internationaux en 2024 (Atout France)
    depenseParTouriste := 710      -- 71 Md€ de recettes du tourisme international 2024 / 100 M (Banque de France)
    exportations := 980000         -- biens et services ≈ 33 % du PIB (INSEE, ordre de grandeur)
    importations := 985200         -- exportations − solde biens et services (−64,4 + 59,2 = −5,2 Md€, BdF, 12 mois à sept. 2025)
    revenusNets := -5300           -- revenus primaires et secondaires nets (BdF, 12 mois à sept. 2025) ; solde courant −10,5 Md€
    variationImportsAnnuelle := 0
    tauxAccidentsPdm := 190        -- 564 000 accidents avec arrêt / 29,3 M d'emplois (CNAM 2023)
    robotisationPb := 0
    decesPollutionAir := 40000     -- décès attribuables aux PM2,5 (Santé publique France, 2021)
    parcElectriqueMilliers := 1600 -- voitures 100 % électriques en circulation fin 2025 (Avere-France, ordre de grandeur)
    bornesMilliers := 175          -- points de recharge ouverts au public fin 2025 (Avere-France, ordre de grandeur)
    electrificationAnnuelleMilliers := 0
    bornesAnnuellesMilliers := 0
    participationsEtat := 209100   -- portefeuille de l'APE, valeur estimée au 30 juin 2025 (86 entités)
    cdhrMeur := 400                -- contribution différentielle sur les hauts revenus, encaissements 2025
    dividendesEtat := 4000         -- dividendes 2025 ≈ 6,5 Md€ (2024 et 2025) − 2,47 Md€ (2024) (APE, rapport d'activité) ; inclus dans les recettes non fiscales
    echeances := echeancesDepart
    echeancesRecettes := echeancesRecettesDepart
    calendrierAgeLegal := calendrierAgeLegal
    calendrierAgeTendanciel := calendrierAgeReforme2023 }
  populationMilliers := 69100
  partPlus65Pb := 2220             -- 22,2 % au 1er janvier 2026 (INSEE)
  sources := [
    "INSEE, Informations rapides n°78, comptes des APU 2025 (27 mars 2026)",
    "APE, rapport d'activité 2025 (portefeuille 209,1 Md€, dividendes)",
    "Sénat, rapports sur les PLF 2024 (Société du Grand Paris) et 2026 (France 2030) ; CADES et CRDS (rapport 2026)",
    "INSEE, Bilan démographique 2025, Insee Première n°2087 (13 janvier 2026)",
    "INSEE, population active 2025 ; emploi salarié et non salarié par activité 2024",
    "DGCL, note sur les taux de fiscalité directe locale 2025",
    "Ministère de la Transition écologique : TICPE 2022 (via Journal de l'Automobile, mars 2024)",
    "Santé publique France, Impact de la pollution de l'air ambiant sur la mortalité en France (2021) : 40 000 décès/an attribuables aux PM2,5",
    "Avere-France, baromètres 2025 : parc électrique et points de recharge publics (ordres de grandeur, à préciser)",
    "INSEE, dépenses des administrations publiques par fonction (COFOG), 2023 : parts appliquées au total 2025",
    "OCDE, heures annuelles travaillées par personne en emploi, France 2023 : 1 494 h",
    "Atout France, bilan 2024 : 100 millions de visiteurs internationaux ; Banque de France, balance des paiements 2024 : 71 Md€ de recettes de voyages",
    "Banque de France, balance des paiements de septembre 2025 (cumul 12 mois) : biens −64,4 Md€, services +59,2 Md€, revenus −5,3 Md€, transactions courantes −10,5 Md€"]

end Hypotheses
