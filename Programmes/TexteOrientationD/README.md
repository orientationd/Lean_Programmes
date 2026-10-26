# Texte Orientation D

Programme de orientation_d. Seuls les comptes listés dans `PROPRIETAIRES`
peuvent modifier ce dossier.

## Mesures

### O-01 — Remplacement gratuit de 10 000 voitures parmi les plus polluantes chaque année

10 000 citadines électriques à 25 000 € (hypothèse) chaque année de 2027 à
2035, soit 250 M€ par an et 90 000 voitures, prises parmi les 1,2 million
de voitures Crit'Air 5 ou non classées (SDES, 1er janvier 2026).

Le modèle commun traite désormais :

* l'**achat** comme une dépense de l'année, inscrite dans le déficit (elle
  ne passait auparavant que par la dette), dont la part importée (73 %)
  va aux importations ;
* les **particules** selon la vignette des voitures retirées : une
  Crit'Air 5 (diesel Euro 2, 80 mg/km) émet ≈ 7,5 fois la moyenne du parc
  thermique (limites des normes Euro pondérées par le parc) : 54 décès
  évités par an en 2035, contre ≈ 8 pour des voitures moyennes ;
* le **CO₂** : 1,7 t évitée par voiture et par an, soit 0,15 Mt en 2035.

Coût : +0,01 point de déficit en 2035. Effet sur la balance commerciale
d'une vague (sous-modèle `Modele/Automobile.lean`, détail dans le
rapport) :

| Version | Hypothèse pétrole | Solde à 5 ans | Solde à 10 ans | Équilibre |
|---|---|---|---|---|
| achat sans critère d'origine (73 % importé) | modéré, 0,56 €/L | −166,6 M€ | −150,6 M€ | 58 ans |
| achat sans critère d'origine | cher, 0,78 €/L | −160,0 M€ | −137,4 M€ | 41 ans |
| véhicules fabriqués en France (35 % importé) | modéré | −71,6 M€ | −55,6 M€ | 28 ans |
| véhicules fabriqués en France | cher | −65,0 M€ | −42,4 M€ | 20 ans |

À 10 ans, la mesure **creuse** le déficit commercial : les importations de
véhicules l'année de l'achat pèsent plus que le carburant importé évité
ensuite, net de l'électricité qui n'est plus exportée. L'ordre de grandeur
reste marginal (0,2 à 0,9 % d'une année de déficit automobile, ≈ 20 Md€ en
2025). Le critère d'origine pèse plus que le prix du pétrole.

Contrats prouvés : le déficit induit se résorbe chaque année dès que le
carburant évité vaut plus que l'électricité consommée ; l'année d'équilibre
affichée est exacte.

### O-02 — Amendes SRU proportionnelles

Coefficient ×1 à ×5 selon la part de l'objectif non atteinte, plafond porté
à 10 % des dépenses réelles de fonctionnement. Le rapport compare la version
retenue à trois variantes (plafond actuel de 5 %, modérée ×3, sévère ×10
plafond 15 %) et au droit actuel, commune par commune (panel fictif).

Budget de l'État : effet direct nul. Le prélèvement net va à l'EPCI
délégataire ou à l'établissement public foncier, la majoration au FNAP.

Contrats prouvés pour toute commune : nulle si l'objectif est atteint ;
au plus 10 % des DRF ; construire ne fait jamais payer plus ; jamais moins
que le prélèvement actuel. Avec ce plafond, l'amende peut dépasser le
maximum qu'un préfet peut infliger aujourd'hui (commune E du panel).

### O-03 — Attributions HLM vérifiables par preuve ZK

La commission publie un engagement sur la liste des candidats et, pour
chaque attribution, une preuve que l'attributaire est le candidat conforme
à la grille de cotation publiée, sans révéler les données des demandeurs
(394 000 attributions en 2025, Ancols).

Contrats prouvés (sous-modèle `Modele/Attribution.lean`) : la règle désigne
toujours un attributaire s'il existe un éligible ; il est conforme et
unique ; deux preuves acceptées pour un même engagement désignent la même
personne ; la preuve existe toujours pour l'attributaire légitime.

**Effet sur l'immobilier : non modélisé.** Aucune élasticité sourcée ne
relie la transparence des attributions aux prix ou aux loyers. Canaux
plausibles, à documenter avant toute quantification : moins d'attributions
contestées, rotation plus rapide, confiance des demandeurs.

Chiffrage provisoire (hypothèses) : 20 M€ de développement, 5 M€/an
d'exploitation.

### O-04 — Six EPR2, au niveau du programme gouvernemental

Même programme que celui engagé par le gouvernement : six EPR2 (Penly,
Gravelines, Bugey), devis EDF du 18 décembre 2025 de 72,8 Md€ (euros
2020), décision finale d'investissement fin 2026, première mise en service
visée en 2038. Financement repris de l'accord État-EDF du 19 juin 2025 :
prêt bonifié de l'État couvrant au moins la moitié des coûts de
construction, contrat pour différence à 100 €/MWh (euros 2024) sur 40 ans.

Modélisation : prêt de l'État de 36,4 Md€ versé linéairement de 2027 à
2038, soit 3,0 Md€/an (levier `pretEtat`). C'est une opération financière
au sens de Maastricht : la dette augmente, pas le déficit. Variante : prêt
couvrant la totalité du coût (6,1 Md€/an). Non modélisés, car hors
horizon ou hors administrations publiques : production (2038 et au-delà),
flux du contrat pour différence, remboursements, activité des chantiers
et emplois d'EDF et de ses fournisseurs, réduction d'émissions.

Sources : [communiqué EDF du 18 décembre 2025](https://www.edf.fr/en/the-edf-group/dedicated-sections/journalists/all-press-releases/edf-shares-its-forecasted-cost-estimate-of-the-epr2-programme-for-eu728bn),
[accord État-EDF, AFP, 19 juin 2025](https://www.connaissancedesenergies.org/afp/edf-et-letat-francais-parviennent-un-accord-pour-financer-la-relance-du-nucleaire-250619).

### O-05 et O-06 — Prime à l'électrique et points de recharge

O-05 : prime de 4 000 € pour 300 000 achats de voitures électriques par
an (1,2 Md€/an ; variante 6 000 € × 400 000). O-06 : 50 000 points de
recharge publics par an à 8 000 € (0,4 Md€/an, emplois dans la
construction). Le modèle commun en déduit le parc électrique, les décès
évités par la baisse des particules fines (90 par million de véhicules
remplacés, hypothèse documentée dans `Hypotheses/Energie.lean`), le
carburant importé évité et les accises et la TVA perdues sur les
carburants (354 € et 155 € par voiture et par an), et vérifie les
propriétés « un point de recharge public pour dix véhicules en 2035 » et
AFIR (1,3 kW de puissance publique par voiture électrique en 2030).
Montants : hypothèses à arbitrer.

Le règlement (UE) 2023/851 porte déjà les ventes d'électriques de 19,9 %
des ventes neuves en 2025 à 100 % en 2035 : dans la référence, elles
montent de 133 000 par an. Les 300 000 voitures aidées s'y ajoutent dans
la limite des ventes neuves (1,665 million) : à partir de 2034, la prime
ne finance plus que des achats que le règlement impose déjà (effet
d'aubaine) ; la dépense, elle, continue.

### O-07 — Retraite à la durée cotisée, sans âge légal

La notion d'âge légal disparaît : on part dès que la durée cotisée atteint
le seuil actuel (172 trimestres), réduit selon la pénibilité. Le modèle
commun ne connaît qu'un âge moyen de départ : la mesure est traduite en un
âge moyen plafonné à 63 ans et 6 mois, 6 mois sous les 64 ans du
calendrier légal (variante : 63 ans). Le calendrier en vigueur (62 ans et
9 mois jusqu'en 2027, suspension de la LFSS pour 2026, puis +3 mois par
génération) est suivi jusqu'à 63 ans et 6 mois en 2031 ; l'écart à la
référence est de 3 mois en 2032 et de 6 mois à partir de 2033 (variante :
écart de 6 mois dès 2027). Coût et effet sur la population active suivent
l'hypothèse économique du scénario.
Hypothèse à étayer avec les données du COR (distribution des âges de
début de carrière, part des métiers exposés).

### O-08 — Impôt sur les sociétés à 15 %

15 % : le taux minimal du pilier 2 (directive (UE) 2022/2523), au lieu de
25 % (12 % dans la version précédente : taux hongrois de 9 %, le plus bas
de l'Union, plus trois points ; variante). À 15 %, le plancher du pilier 2
ne joue plus : tous les groupes paient le même taux.

Le modèle commun calcule la **réponse de l'assiette** : un point de taux
effectif en moins accroît les bénéfices déclarés de 1 % (valeur de
consensus de la littérature sur le transfert de bénéfices, Beer, de Mooij
et Liu, 2020).

Coût en 2035 : +0,61 point de déficit (mesure seule, moteur de demande),
22 000 emplois. Variantes : 12 % (version précédente), 17 %, IS maintenu à
25 %. Les effets réels sur l'investissement relèvent du moteur d'offre.

### O-09 — Démission indemnisée

Six mois d'indemnités, une fois tous les cinq ans. Coût estimé 3 Md€/an
(recours de 20 % sur 1,9 million de démissions de CDI, 1 300 €/mois) ;
variante 6 Md€. Effets sur la mobilité professionnelle et le chômage non
modélisés.

### O-10 et O-11 — Justice, lignes nouvelles

+300 M€/an pour la justice (prud'hommes en priorité) ; 2,4 Md€/an pour
les lignes nouvelles Lyon-Turin (accès français), Bordeaux-Toulouse et
Montpellier-Perpignan (≈ 30 Md€ sur dix ans, 80 % d'argent public
français). Emplois dans la construction ; les gains de temps de parcours
et les délais de justice ne sont pas modélisés.

### O-12 — Qualité d'accueil des touristes

Six zones de rénovation de qualité, dont Le Grau-du-Roi : 150 M€/an par
zone pendant dix ans (0,9 Md€/an, emplois dans la construction). Le
sous-modèle touristique suit le nombre de visiteurs internationaux (100 M
en 2024) et la dépense par touriste (710 €, soit 71 Md€ de recettes) ;
la mesure les relève de +2 % et +3 % (variantes faible et forte), soit
≈ 3,6 Md€/an de recettes supplémentaires, entrant dans le PIB à 80 %
(contenu en valeur ajoutée nationale). Ces élasticités sont des
hypothèses à étayer avec Atout France ; le nombre de nuitées n'est pas
distingué du nombre de visiteurs.

### O-13 — Conduite autonome et indemnisation des taxis, par âge

Autorisation de la conduite autonome (FSD) en 2027 ; les titulaires d'une
licence de taxi cèdent leur licence contre une indemnité versée **jusqu'à
leur retraite**. Le coût et l'effet sur l'emploi sont calculés cohorte par
cohorte d'âge (`indemnitesTaxis`, `sortiesTaxis`).

* **Effectif** : 62 800 taxis (ADS) en 2024 ; 40 000 titulaires exploitant
  eux-mêmes leur licence (hypothèse, deux tiers des ADS).
* **Âges** : pyramide reconstituée sur les repères INSEE (taxis non
  salariés, 2016) : 49 ans en moyenne, 2,4 % de moins de 30 ans, 12,8 % de
  60 ans ou plus.

  | Âge | 25-29 | 30-39 | 40-49 | 50-59 | 60-64 | 65-69 |
  |---|---|---|---|---|---|---|
  | Part | 2,4 % | 15,0 % | 31,0 % | 38,8 % | 9,8 % | 3,0 % |

* **Indemnité** : 25 000 € par an jusqu'à 64 ans (durée cotisée de O-07) ;
  rien pour ceux qui ont déjà 64 ans.

| Année après l'entrée en vigueur | 1 | 3 | 5 | 9 | 11 | Total jusqu'à extinction |
|---|---|---|---|---|---|---|
| 40 000 titulaires (retenu) | 950 M€ | 911 M€ | 872 M€ | 716 M€ | 639 M€ | 15,2 Md€ |
| 62 800 ADS (variante) | 1 491 M€ | 1 430 M€ | 1 368 M€ | 1 125 M€ | — | — |
| Moins de 50 ans : 2 ans + 15 000 € de formation (variante) | 1 240 M€ | 427 M€ | 388 M€ | 232 M€ | — | 5,1 Md€ |

(Euros de 2027, indexés ensuite sur les dépenses de la fonction.)

* **Emploi** : 40 000 emplois de chauffeurs disparaissent. Les 12 880
  titulaires de 55 ans et plus quittent la population active (moins de dix
  ans d'indemnité) ; les 27 120 plus jeunes restent actifs et se reclassent
  à 20 % de l'écart par an. Effet net en 2035 : ≈ −14 000 emplois.
* **PIB** : +0,05 % par l'automatisation. *Correction* : le levier
  recevait 5 ‰ au lieu de 0,5 ‰, soit dix fois l'effet documenté ;
  l'unité est désormais le point de base.

Résultat (mesure seule, 2035, scénario central) : PIB +0,11 % (automatisation
et reclassement des plus jeunes), déficit −0,06 point.

### O-14 — Accidents du travail : rejoindre la moyenne européenne

Des partenaires d'accompagnement (application des normes, prévention),
financés par 500 M€/an de fonds dédiés de l'État, pour ramener le taux
d'accidents du travail avec arrêt de 190 à 110 pour 10 000 emplois, la
moyenne de l'Union (Eurostat). Le sous-modèle chiffre les accidents
évités (≈ 235 000 par an à terme), leur coût pour les finances publiques
(24 000 € chacun, branche AT-MP), les journées de travail rendues au PIB
(70 par accident) et les décès évités (13 pour 10 000 accidents).
Propriété « accidents du travail à la norme UE ». Variantes : fonds
doublés ; objectif à moitié atteint.

### O-15 — Logiciel libre dans l'État

Migration de tous les logiciels et postes de l'État vers le libre :
900 M€ de migration (comptés en une fois) puis 400 M€/an d'économies de
licences à partir de la quatrième année (mesure en deux temps, O-15 et
O-15b). Montants : hypothèses à documenter avec la DINUM (accords-cadres
en cours) ; les gains de souveraineté et de sécurité ne sont pas chiffrés.

### O-16 à O-19 — Universités

* **O-16** Reprise de la dette et apurement des déficits : les universités
  sont déjà dans le périmètre des administrations publiques, la reprise de
  leur dette est donc neutre sur la dette et le solde consolidés ;
  l'apurement de leurs déficits de fonctionnement coûte ≈ 500 M€/an
  (hypothèse, Cour des comptes 2025).
* **O-17** Reconstruction aux normes (démolition puis construction) des
  campus de Nanterre, Toulouse, Montpellier et Grenoble : 4 × 1 Md€ sur
  huit ans à partir de 2027, soit 500 M€/an d'investissement (emplois dans
  la construction), montant gardé constant au-delà par prudence.
* **O-18** Parcoursup ouvert aux étudiants étrangers à nombre d'admis
  constant : sans effet budgétaire, pour mémoire.
* **O-19** Places pour les bacheliers sans affectation : ≈ 10 000 par an,
  trois années de licence, 10 500 € par étudiant : 315 M€/an et 2 000
  postes d'enseignants-chercheurs annoncés (vérifiés par la propriété
  « emplois annoncés réalisables »).

### O-20 à O-23 — Économies et recettes

* **O-20** Aide à l'apprentissage réservée à l'infra-bac et aux PME. La
  référence éteint désormais l'aide exceptionnelle pour les contrats
  conclus à partir de 2027 (décret n° 2026-168, législation constante) :
  l'aide ciblée que maintient le programme coûte ≈ 1 Md€/an (3,9 Md€ en
  2024 moins les 2,94 Md€ d'économies que la Cour des comptes attend du
  recentrage), au lieu de l'économie de 2 Md€ comptée tant que l'aide de
  2025 était reconduite.
* **O-21** Commande publique (centrales d'achat, standardisation,
  ententes) : −3 Md€/an sur les services généraux (hypothèse médiane).
* **O-22** Médicaments et dispositifs : −2 Md€/an (génériques,
  biosimilaires, prix, pertinence ; Assurance maladie 2025) ; création
  d'une agence française du médicament qui produit les références en
  rupture : 500 M€ d'investissement puis 300 M€/an, 1 500 emplois
  annoncés (hypothèses).
* **O-23** Fraude et travail dissimulé (BTP, restauration, services à la
  personne) : +2 Md€ de cotisations et +1 Md€ de TVA par an à partir de la
  troisième année (HCFiPS 2024 : 6 à 8 Md€ éludés), nets de la fuite
  fiscale du modèle.

Ensemble : ≈ 9,7 Md€/an d'amélioration brute du solde en régime de
croisière.

### O-25 — Enseignants : +2 % par an

Masse salariale des enseignants hors CAS Pensions : 59,23 Md€ en 2026
(852 752 enseignants, PLF 2026), soit ≈ 60,9 Md€ en 2027. Hausse de 2 % par
an **en plus** de l'évolution tendancielle des dépenses, de 2027 à 2035 :
1,2 Md€ la première année, 11,9 Md€ (euros 2027) la neuvième, niveau
calculé exactement (masse × (1,02^k − 1)) par l'échéancier. Mesure seule en
2035 : +15,6 Md€ de dépenses, +0,29 % de PIB, +44 000 emplois (effet de
demande), déficit +0,21 point après les recettes induites.

Comme pour tous les programmes, le modèle ne nette pas explicitement les
cotisations et l'impôt prélevés sur la paie publique : ils reviennent par
le multiplicateur (≈ 42 % de la dépense), ce qui approche le retour réel
(≈ la moitié du coût complet).

### O-26 — Automatisation des contrôles administratifs

10 000 postes de contrôle supprimés par an pendant cinq ans (50 000), non
remplacés au départ en retraite (levier `suppressionPostes`, mesure répétée
cinq fois). Coût complet d'un poste : 55 000 € (hypothèse, catégories B
et C) ; outil : 30 000 € par poste la même année, puis 3 000 €/an de
maintenance. Effets en 2035 : −3,3 Md€ de dépenses nettes, −47 000
emplois (l'emploi public baisse directement ; l'emploi privé ne répond qu'à
la part de la baisse du PIB qui n'est pas la production publique
supprimée), PIB −0,07 %, déficit −0,05 point (−0,07 sous le moteur
d'offre).

### O-27 — Médecins généralistes : simplification, enquêteurs sur cas anormaux

Les généralistes libéraux consacrent ≈ 5 h 30 par semaine à la gestion
sur 54 h (DREES, 2019). En supprimer la moitié libère ≈ 6,5 millions
d'heures de soin par an, soit ≈ 3 200 généralistes à temps plein ou ≈ 21,8
millions de consultations possibles. Les contrôles systématiques sont
remplacés par 500 enquêteurs humains sur les cas anormaux (32,5 M€/an,
hypothèse). Retenu : le seul coût des enquêteurs (le temps libéré sert
l'accès aux soins sans hypothèse de volume). Variante : le temps libéré
devient des consultations remboursées, +458 M€/an pour l'assurance maladie.

### O-28 à O-34 — Fiscalité, agriculture, logement, territoires

Effets de chaque mesure seule en 2035, scénario central (moteur de
demande ; moteur d'offre entre parenthèses quand il diffère).

| Mesure | Chiffrage | Déficit | PIB | Emplois |
|---|---|---|---|---|
| **O-28** Désindexation des très hautes retraites : revalorisation limitée à la part sous 5 150 € bruts par mois | 1 % des retraités, 6 470 € en moyenne (DREES) ; part au-delà du seuil 2,85 Md€ ; 1,8 % d'inflation évitée par an : −50 M€ en 2027, −422 M€ (euros 2027) en 2035 | −0,01 pt | −0,02 % | −1 500 |
| **O-29** TVA : taux normal 20 % → 22 % | 1 point ≈ 8 Md€ (FIPECO, IPP, Sénat) : 16 Md€ statiques, 12,8 Md€ après fuite fiscale | −0,34 pt (−0,12) | −0,22 % (−0,53 %) | −32 000 (−78 500) |
| **O-30** Taxe forfaitaire de 3 000 € par atterrissage de jet privé | 85 000 atterrissages (84 885 départs en 2022, Greenpeace) : 255 M€ statiques | −0,01 pt | −0,01 % | −400 |
| **O-31** Conversion électrique de toutes les exploitations agricoles en dix ans | 389 000 exploitations × 30 000 € : 1,17 Md€ par an ; −1 Mt de CO₂ par an (10 Mt au total, énergie agricole) ; importations nettes −116 M€ par an | +0,02 pt | +0,02 % | +3 400 |
| **O-32** Suppression du DPE dans les quartiers historiques ; climatisation réversible aidée | 50 000 logements × 2 000 € par an pendant dix ans : 100 M€ par an | ≈ 0 | ≈ 0 | +300 |
| **O-33** Pas de tours dans les quartiers historiques ; quartiers nouveaux autour des pôles très desservis (Val de Fontenay) | 20 000 logements × 10 000 € d'équipements publics : 200 M€ par an | ≈ 0 | ≈ 0 | +900 |
| **O-34** TER 24 h sur 24 avec agents de sécurité (train, gare, parking) | 20 liaisons de 100 km, 10 trains par nuit, 23,40 € par train-km, 46 heures d'agents par nuit, 25 % de recettes : 136 M€ par an | ≈ 0 | ≈ 0 | +500 |

Points d'attention :

* **O-28** : la mesure suppose une loi qui s'impose aussi aux régimes
  complémentaires (Agirc-Arrco). Variante : gel de toute la pension
  au-delà du seuil (13,95 Md€ concernés, −2,07 Md€ en 2035), au prix
  d'effets de seuil (une pension juste au-dessus finit sous une pension
  juste en dessous).
* **O-29** : le moteur d'offre pénalise la hausse des prélèvements
  obligatoires (PIB −0,5 %) ; c'est la mesure la plus lourde du bloc.
* **O-31** : les engins lourds électriques restent rares ; l'effet sur la
  balance commerciale est compté, pas celui sur le PIB (même convention que
  le sous-modèle automobile).
* **O-32** : l'effet climatique (remplacement du chauffage fossile, moindre
  rénovation sans DPE) est inférieur à la résolution du modèle (1 Mt) ; les
  unités extérieures restent soumises à l'avis des Architectes des
  bâtiments de France.
* **O-34** : la nuit est la plage des travaux d'entretien du réseau, ce qui
  limite le nombre de lignes exploitables 24 h sur 24.

### O-36 à O-42 — Redressement compatible avec les positions du PS

Base : propositions du groupe socialiste à l'Assemblée (16 septembre 2026),
note de la Cour des comptes sur la fiscalité du patrimoine (septembre
2026), revue des niches fiscales. Quand un chiffrage indépendant existe et
diffère de celui du PS, il est retenu et le chiffrage PS devient une
variante.

| Mesure | Rendement statique | Déficit 2035 | PIB 2035 |
|---|---|---|---|
| **O-36** CSG sur les gros héritages, imputée aux droits de succession dont elle suit l'assiette | 10 Md€ (chiffrage PS) | −0,36 pt | −0,03 % |
| **O-37** Taxe sur les services numériques de 3 % à 15 % | 3,1 Md€ (PS : 10) | −0,08 pt | −0,04 % |
| **O-38** Reconfiguration des exonérations de cotisations, au prorata des allègements en vigueur (voir O-76) | 4 Md€ (PS) ; −51 000 emplois | −0,09 pt | −0,08 % |
| **O-39** Train de vie de l'État | 3,1 Md€ (part du PS, moins O-21) | −0,06 pt | −0,08 % |
| **O-40** Niches fiscales −10 % (hors Dutreil et ménages modestes) | 8 Md€ sur 88,3 | −0,18 pt | −0,10 % |
| **O-41** Pacte Dutreil divisé par deux (75 % → 37,5 %), taxe sur les holdings élargie | 2,95 Md€ (Cour des comptes, proportionnel) | −0,10 pt | −0,01 % |
| **O-42** Norme de dépense : +0,5 % en volume sur les dépenses pilotables | 50 pb par an sur ≈ 739 Md€ | −0,53 pt | −0,73 % |
| **O-43** Défense : −1 Md€ par an, par rapport à la LPM actualisée que la référence applique (76,3 Md€ en 2030) | 1 Md€ sur 53 | −0,02 pt | −0,03 % |
| **O-44** Durée de cotisation : 174 trimestres au lieu de 172 | âge moyen de départ +5 mois (80 % des départs liés à la durée, hypothèse) : ≈ 3,3 Md€ de pensions, 150 000 actifs | −0,32 pt | +0,28 % |
| **O-45** Lutte contre la fraude fiscale : facturation électronique (2,5 Md€ de TVA dès 2028 ; 2 à 3 Md€ attendus par l'administration), 1 500 agents de contrôle (105 M€) pour 1,5 Md€ d'encaissements | 4 Md€ | −0,08 pt | −0,05 % |
| **O-46** CSG progressive : +2 points au-delà de 100 000 € par an et par personne | 2,0 Md€ (1 point = 17 Md€ ; 6 % de l'assiette au-delà du seuil, hypothèse) | −0,04 pt | −0,03 % |

(Scénario central, moteur de demande, mesures prises isolément.)

La taxe Zucman (ancienne O-35, 6,5 Md€ statiques) a été retirée du
programme.

**Résultat (avec O-54 à O-62 et O-76 à O-81 ci-dessous) : le déficit du
Texte Orientation D passe de 5,0 % en 2027 à 4,05 % en 2035** (dette 130 %
du PIB, chômage 9,2 %), contre 9,1 % sans programme (référence complétée des
lois en vigueur : voir O-59 à O-62 et O-76 ; IS à 15 % : voir O-08). **Il
ne baisse plus chaque année au moteur de demande : il stagne en 2032**
(voir O-78 à O-81). Le programme entre en vigueur en
2027 (aucune mesure avant).

Distance à l'équilibre (2035, scénario central, moteur de demande) :

| En plus des mesures du programme | Déficit 2035 | Chômage 2035 |
|---|---|---|
| Rien | 4,05 % | 9,2 % |
| Abandon de O-08 (IS maintenu à 25 %) | 3,2 % | 9,25 % |
| … et norme renforcée de 100 pb supplémentaires | 1,9 % | 9,8 % |
| … et de 200 pb supplémentaires | 0,7 % | 10,3 % |

Ces trois pistes sont enregistrées comme variantes de O-08 et de O-55 :
la synthèse les évalue une à une (section « Variantes des mesures »). (Avec l'IS maintenu à 25 %, O-60
rapporterait 7,7 Md€ au lieu de 4,6 ; la variante ne le recalcule pas.)

### O-49 à O-53 — Hauts fonctionnaires, élus, capital, conseil

| Mesure | Chiffrage | Déficit 2035 |
|---|---|---|
| **O-49** Hauts fonctionnaires −5 % | 21 500 agents de l'encadrement supérieur et dirigeant (DGAFP), coût complet ≈ 2,9 Md€ : 147 M€ | ≈ 0 |
| **O-50** Revenus des élus plafonnés à 10 000 € par mois | Le plafond de cumul en vigueur est déjà de 8 897,93 € bruts (CGCT, art. L. 2123-20 II) : sans effet, sauf à l'étendre aux rémunérations qui y échappent | 0 (pour mémoire) |
| **O-51** Fin du PFU, revenus du capital au barème | +3,2 à 3,6 Md€ à comportements inchangés (Institut Montaigne) ; variante −0,7 Md€ si l'assiette revient à 2017 | −0,07 pt |
| **O-52** Taxe sur les rachats d'actions de 8 % à 20 % | 3 Md€ mécaniques, 1,5 Md€ retenus (report vers les dividendes) | −0,04 pt |
| **O-53** Cabinets de conseil divisés par deux | 893,9 M€ en 2021 (Sénat) : 400 M€ | −0,01 pt |

Pour O-50, un plafond à 10 000 € est moins strict que le droit actuel. Pour
limiter réellement le cumul, il faudrait abaisser le plafond (par exemple à
une indemnité parlementaire de base, 5 932 €) ou l'étendre aux fonctions
dans les organismes extérieurs ; leur montant n'étant pas publié, le gain
n'est pas chiffré.

### O-54 à O-58 — Trajectoire de baisse continue du déficit

Sans ces mesures, le déficit baisse en 2027 puis remonte d'environ
0,2 point par an : la charge d'intérêts passe de 2,6 % à 4,6 % du PIB, le
taux apparent de la dette (1,9 % en 2025) rejoignant le taux de marché. Il
faut donc des mesures dont le rendement croît chaque année plus vite que
les intérêts.

| Mesure | Chiffrage | Déficit 2035 | PIB 2035 |
|---|---|---|---|
| **O-54** CRDS prolongée au-delà de 2033 pour amortir la dette de l'ACOSS (≈ 65 Md€ fin 2026) | 9,55 Md€ (euros 2027) dès 2034 ; loi organique | −0,22 pt | −0,13 % |
| **O-55** Norme de dépense renforcée : 150 pb avec O-42, dépenses pilotables à +1,3 % par an en valeur (≈ −0,5 % en volume) | | −1,04 pt | −1,44 % |
| **O-56** Aides aux entreprises (211 Md€, Sénat 2025) : exonérations de cotisations −1,5 Md€ de plus chaque année pendant six ans, sous conditions | 9 Md€ en 2032 ; −99 000 emplois | −0,18 pt | −0,16 % |
| **O-57** Niches fiscales : −2 % de plus chaque année pendant cinq ans | ≈ 2 Md€ par an, 10 Md€ en 2031 | −0,20 pt | −0,12 % |
| **O-58** Durée de cotisation : +1 trimestre tous les trois ans dès 2028 (logique de la réforme de 2014) | +1 mois de durée requise par an, 80 % des départs | −0,34 pt | +0,34 % |

### O-59 à O-62 — Lois en vigueur et deuxième étape

La référence applique désormais les lois votées dont les effets ne suivent
pas le PIB (détail et sources : `Hypotheses/Reference.lean`, section
« Lois en vigueur ») :

| Loi | Effet sur la référence |
|---|---|
| Âge légal : réforme de 2023 suspendue par la LFSS pour 2026 | 62 ans et 9 mois jusqu'en 2027, +3 mois par génération, 64 ans en 2033 ; la suspension coûte ≈ 1,9 Md€ par an de 2027 à 2032 |
| LPM actualisée (loi n° 2026-791) | défense hors pensions de 50,5 Md€ (2025) à 76,3 Md€ (2030) |
| ETS2 (à partir de 2028) | ≈ 6,5 Md€ de recettes, dont la moitié redistribuée |
| Contribution exceptionnelle des grandes entreprises (lois n° 2025-127 et 2026-103) | 8 Md€ en 2025, 7,5 Md€ en 2026, rien ensuite |
| CVAE (loi n° 2025-127, art. 62) | 3,4 Md€, ramenés à 2,3 en 2028, 1,1 en 2029, 0 en 2030 |
| Contribution différentielle sur les hauts revenus | ≈ 0,4 Md€, éteinte l'année qui suit un déficit sous 3 % |
| Droits de succession et de donation (barème et abattements non indexés, Pacte Dutreil, assurance-vie, exonération du conjoint) | 20,7 Md€ en 2025 ; assiette portée par la hausse des décès (651 000 → 738 000 en 2035) et le patrimoine transmis : 35,1 Md€ en 2035 (0,69 % → 0,86 % du PIB) |
| Règlement (UE) 2023/851 (100 % de voitures neuves électriques en 2035) | 12,2 millions de voitures électriques en 2035 ; accises et TVA sur les carburants −5,4 Md€ (euros 2025) |

Le déficit tendanciel 2035 passe de 8,4 % à 9,0 % du PIB. Avec O-54 à
O-58 seulement (et avant l'ajout des droits de succession), celui du Texte Orientation D stagnait vers 4,6 % de 2028 à
2032 : la LPM monte jusqu'en 2030, la charge d'intérêts continue de croître
et l'âge moyen de départ cesse de suivre le calendrier légal en 2032
(O-07). Quatre mesures rétablissent la baisse :

| Mesure | Chiffrage | Déficit 2035 | PIB 2035 |
|---|---|---|---|
| **O-59** Maintien de la CVAE à 0,28 % | 1,2 puis 2,5 puis 3,6 Md€ (euros 2027) de 2028 à 2030 | −0,11 pt | −0,04 % |
| **O-60** Pérennisation de la contribution exceptionnelle sur les grandes entreprises, aux taux de 2026 | 7,5 Md€ × 15 % / 25 % (IS des grands groupes avec O-08) : 4,6 Md€ | −0,16 pt | −0,04 % |
| **O-61** Aides aux entreprises, deuxième étape : exonérations de cotisations −1,5 Md€ de plus chaque année de 2029 à 2034 | 9 Md€ en 2034 ; 22 Md€ avec O-38 et O-56 ; −78 000 emplois | −0,17 pt | −0,14 % |
| **O-62** Niches fiscales : −1 Md€ de plus chaque année de 2029 à 2035 | 7 Md€ en 2035 ; 25 Md€ sur 88,3 avec O-40 et O-57 | −0,12 pt | −0,08 % |

Trajectoire du déficit (scénario central) :

| Moteur | 2026 | 2027 | 2028 | 2029 | 2030 | 2031 | 2032 | 2033 | 2034 | 2035 |
|---|---|---|---|---|---|---|---|---|---|---|
| Demande | 5,39 | 4,98 | 4,82 | 4,78 | 4,73 | 4,67 | 4,67 | 4,46 | 4,20 | 4,05 |
| Offre | 5,39 | 4,90 | 4,69 | 4,64 | 4,59 | 4,55 | 4,54 | 4,37 | 4,17 | 4,09 |

Depuis le retrait de la taxe Zucman et l'IS à 15 %, la propriété « Déficit
en baisse chaque année » n'est plus tenue au scénario central au moteur de
demande (14 scénarios sur 36) : le déficit stagne en 2032 (4,67 %). Elle
l'est encore sous les moteurs d'offre et d'équilibre (16 scénarios sur
36), de 0,01 point en 2032. En 2032, l'âge moyen de départ cesse de suivre
le calendrier légal (O-07), la LPM et les intérêts montent ; en 2035, le
complément de fin de droits de l'assurance chômage (chômage de 9,05 % en
2034) coûte 5,5 Md€. Option pour rétablir la baisse : voir O-78 à O-81.

Coût : la norme renforcée (O-55) pèse sur l'activité (PIB −1,44 %,
≈ 210 000 emplois en 2035 au moteur de demande) ; le chômage du Texte
Orientation D atteint 9,2 % en 2035.

### O-63 — Aide à la rénovation majorée de 25 % dans les territoires ruraux

+3 250 € par rénovation aidée (13 000 € en moyenne en 2026) dans les
communes rurales, où se trouvent 48 % des rénovations aidées (Anah, 2021)
et où le fioul chauffe 16,7 % des logements, contre 8,5 % en moyenne
(INSEE, 2026).

Nouveau sous-modèle `Renovation` (axe énergie) : 270 000 rénovations aidées
par an, effet d'aubaine de 50 % (hypothèse : 80 % pour l'ancien crédit
d'impôt CITE selon le CAE), économies réelles de 5,4 MWh par an et par
rénovation (moitié des économies conventionnelles), CO₂, valeur importée,
accises et TVA du fioul et du gaz.

| Effet par an | Valeur |
|---|---|
| Rénovations rurales déjà aidées (bonus versé sans effet) | 129 600 |
| Rénovations suscitées | 16 200 |
| Coût (euros 2027) | 684 M€, dont 421 M€ d'aubaine |
| Économies de fioul et de gaz ajoutées chaque année | 32 000 MWh |
| CO₂ évité en 2035 | 64 kt |

Effets en 2035 (mesure seule, moteur de demande) : +0,01 point de déficit,
3 000 emplois, dont 2 400 dans le bâtiment : le modèle compte désormais les
travaux entiers des rénovations suscitées (33 000 € en moyenne, aide et part
des ménages), et l'intensité en main-d'œuvre de la construction (1,17 fois
la moyenne). La majoration profite d'abord aux
ménages qui rénovaient déjà : la moitié du coût est un effet d'aubaine.
Variante à 50 % : le double du coût, +0,02 point de plus.

### O-64 à O-66 — Eau potable et électricité dans les outre-mer

| Mesure | Chiffrage |
|---|---|
| **O-64** Eau potable et assainissement | Besoins de 2,36 Md€ dans les DROM et à Saint-Martin (Cour des comptes, mars 2025), moins les 730 M€ déjà programmés pour Mayotte (loi n° 2025-797) : 1,63 Md€, 326 M€ par an de 2027 à 2031 |
| **O-65** Électrification de tous les foyers | ≈ 15 400 ménages sans électricité à Mayotte (19 %) et ≈ 6 700 en Guyane (7 %), INSEE 2026 ; 5 000 € par raccordement et 20 000 € par site isolé (hypothèses) : 211 M€ de 2027 à 2029 |
| **O-66** Électricité des foyers raccordés | 2 500 kWh par foyer et par an produits au coût des zones non interconnectées, 360 €/MWh de surcoût de péréquation (CRE) : 7 M€ de plus chaque année, 20 M€ par an à partir de 2029 |

Situation : 25 % des ménages de Mayotte sans eau courante et des coupures
quotidiennes pour 63 % des raccordés (INSEE, juin 2026) ; 15 % de la
population de Guyane sans eau potable du réseau public ; 25 % des
Guadeloupéens soumis aux tours d'eau, 58 % de pertes sur le réseau. Le
choléra (221 cas, 7 décès en 2024) et la typhoïde touchent Mayotte ;
l'effet sanitaire n'est pas chiffré.

Le modèle commun traite ces investissements avec un contenu en
importations de 50 % (contre 30 % en métropole ; hypothèse : canalisations,
membranes, panneaux et batteries importés) : chaque euro soutient moins
l'activité. En 2029, O-64 dépense 342 M€ et crée ≈ 980 emplois, presque tous dans la
construction ; l'effet s'éteint à la fin des travaux. Le chômage atteint
25 % à Mayotte et 17 % en Guyane (INSEE, 2025) : ces emplois y trouvent sans
peine des candidats, ce que le marché du travail unique du modèle ne
distingue pas. Coût en
déficit : +0,01 point pendant le programme. Les collectivités du
Pacifique (Polynésie : 62 % de la population desservie en eau conforme ;
Nouvelle-Calédonie, Wallis-et-Futuna) ne sont pas chiffrées.

### Emplois, chômage et objectifs écologiques

Le modèle commun distingue désormais :

* **l'intensité en emplois des secteurs** (valeur ajoutée par emploi de
  l'INSEE, 2025) : une dépense dans la construction ou les services
  publics crée plus d'emplois par euro qu'une dépense industrielle ;
* **l'indemnisation du chômage**, ajustée chaque année au nombre de
  chômeurs (≈ 10 000 € par chômeur supplémentaire) : la norme de dépense,
  qui relève le chômage, coûte ainsi une partie de ce qu'elle économise ;
* **les émissions par secteur**, comparées aux objectifs 2030 de la SNBC-3
  (décret n° 2026-636).

| 2030, Mt CO₂e | Transports | Bâtiments | Agriculture | Industrie | Énergie | Déchets | Total |
|---|---|---|---|---|---|---|---|
| Tendanciel | 111,7 | 49,4 | 72,8 | 50,2 | 28,4 | 13,7 | 326 |
| Texte Orientation D | 110,1 | 49,4 | 68,9 | 50,2 | 28,4 | 13,7 | 321 |
| Objectif SNBC-3 | 92 | 37 | 68 | 42 | 25 | 12 | 276 |

Le Texte Orientation D tient l'objectif de 15 % de voitures électriques
dans le parc en 2030 (6,2 millions, grâce à O-05), mais aucun objectif
sectoriel de la SNBC-3, ni le budget carbone 2029-2033 : comme tous les
programmes du dépôt. L'agriculture s'en approche (68,9 Mt pour 68, grâce à
O-31). Combler l'écart demanderait une baisse de 5,1 % par an des
émissions, contre 2,1 % observés en 2025.

### O-67 à O-73 — Dettes cachées et troisième étape du redressement

**Nouveaux mécanismes du modèle commun.**

* **Passifs implicites** : l'état suit les obligations nées mais non payées
  ni comptées dans la dette de Maastricht : les heures supplémentaires non
  payées des policiers, 14,3 millions d'heures (Sénat, fin 2022), 189 M€ à
  13,22 € l'heure, et celles des hôpitaux publics (720 M€, voir O-74). Le
  rapport calcule une « dette étendue » (dette + passifs implicites).
* **Rémunérations publiques** : une hausse de rémunération d'agents déjà en
  poste coûte le brut, dont une part revient aussitôt (CSG-CRDS 9,5 %,
  retenue pour pension 11,1 % sur le traitement, impôt sur le revenu ≈ 15 % ;
  heures supplémentaires : CSG seule). Le net soutient la consommation
  comme un transfert ; il ne crée ni production ni emplois publics. O-25
  (enseignants +2 % par an) et O-49 (hauts fonctionnaires −5 %) passent
  par ce mécanisme : O-25 ne crée plus que 14 000 emplois en 2035, contre
  58 000 quand le modèle la traitait comme des postes nouveaux.
* **Taxes environnementales** : une taxe sur une activité (vols intérieurs,
  poids lourds) en réduit le volume selon une élasticité-prix du modèle
  commun (0,9 pour l'aérien intérieur, 0,5 pour les poids lourds) ; les
  émissions et l'assiette baissent d'autant.

| Mesure | Chiffrage | Déficit 2035 (mesure seule) | Emplois 2035 |
|---|---|---|---|
| **O-67** Heures supplémentaires des policiers payées en 2027 | 189 M€ une fois (passif implicite apuré) | ≈ 0 | ≈ 0 |
| **O-68** RIFSEEP pour les enseignants : primes alignées sur la catégorie A (17,2 % → 32,9 % du brut) | ≈ 10 950 € par enseignant × 693 400 fonctionnaires : 8,0 Md€ par an, dont ≈ 24,5 % revient en CSG et impôt | +0,17 pt | +11 000 |
| **O-69** CIR plafonné à 50 M€ par groupe, fin du taux de 5 % | ≥ 960 M€ (IGF 2024 ; amendements PS) | −0,02 pt | −1 700 |
| **O-70** Assurance-vie au barème des successions au-delà de 250 000 € par bénéficiaire | ≈ 625 M€ (moitié des 1,25 Md€ chiffrés par le CPO avec le seuil actuel de 152 500 € ; hypothèse) | −0,02 pt | −1 100 |
| **O-71** Contribution kilométrique des poids lourds (réseau non concédé) | 1,35 Md€ statiques ; trafic visé −5,5 % ; −0,36 Mt de CO₂ | −0,03 pt | −2 300 |
| **O-72** Accise sur le kérosène des vols intérieurs métropolitains | 340 M€ statiques ; trafic −9 % ; −0,12 Mt de CO₂ | −0,01 pt | −600 |
| **O-73** Défiscalisation des heures supplémentaires réduite de moitié | moitié de l'exonération d'IR (≈ 2,0 Md€) et de la réduction de cotisations (2,31 Md€) : ≈ 2,2 Md€ | −0,05 pt | −3 900 |

Les mesures O-69 à O-73 financent l'essentiel de O-67 et O-68 : le déficit
2035 du Texte Orientation D passe de 3,7 % à 3,8 %, et sa baisse chaque
année est préservée, de justesse en 2032 (−0,02 point). Variantes :
suppression totale de la défiscalisation (−0,06 point en 2035) et seuil
actuel de 152 500 € pour l'assurance-vie (−0,02 point). Le RIFSEEP n'a pas de chiffrage
officiel ; une montée en charge sur cinq ans (variante) ne change presque
rien en 2035. Les heures supplémentaires de l'hôpital sont comptées depuis
O-74 ; celles de la fonction publique territoriale (6,2 millions d'heures
fin 2018) ne le sont pas, faute de chiffre récent.

### O-74 et O-75 — Heures supplémentaires des hôpitaux, 100 000 places de prison

**Modèle commun.** Les passifs implicites sont suivis par type : heures
supplémentaires des policiers (189 M€) et, nouveau, des hôpitaux publics,
**720 M€** : la Cour des comptes relevait 18,5 millions d'heures non payées
ni récupérées fin 2018 (463 M€, non provisionnées) ; le bilan social des
hôpitaux 2022 (ATIH) donne 20,8 heures stockées par agent non médical
(32 € l'heure) et 6,1 demi-journées par médecin (241 €), stables depuis
2021, que le modèle rapporte aux effectifs de la DREES (855 675 postes non
médicaux, 103 623 médicaux, fin 2024). Les comptes épargne-temps
(≈ 2,6 Md€, provisionnés au moins en partie) ne sont pas comptés. Nouveau
levier `investissementEcheancier` : un investissement public échelonné
(bâtiments), avec ses emplois dans la construction.

| Mesure | Chiffrage | Déficit 2035 (mesure seule) | Emplois |
|---|---|---|---|
| **O-74** Heures supplémentaires non payées des hôpitaux publics, payées en 2027 | 720 M€ une fois (passif implicite apuré), dont ≈ 200 M€ reviennent en prélèvements | +0,02 pt en 2027, ≈ 0 en 2035 | +1 200 en 2027 |
| **O-75** 100 000 places de prison en cellule individuelle | 27 108 places au-delà du plan 15 000, à 270 k€ : 7,3 Md€ de 2027 à 2035 ; puis 45 k€ par place ouverte et par an (0,48 surveillant à 80 800 €, entretien, énergie) : 1,22 Md€ par an et ≈ 13 000 surveillants une fois tout ouvert | +0,03 pt | +7 500 en 2035 (+8 100 en 2032) |

Pour O-75, au 1er août 2026 : 63 303 places pour 89 668 détenus (densité
141,6 %, 7 956 matelas au sol), 32,3 % des détenus seuls en cellule
(ministère de la Justice). L'encellulement individuel, principe posé en
1875 et repris par la loi pénitentiaire de 2009, est suspendu par moratoire
jusqu'au 31 décembre 2027 ; la mesure le rend effectif à mesure que les
places ouvrent. Hypothèses à arbitrer :

* le plan 15 000 en cours (5 411 places nettes livrées en septembre 2025,
  9 589 restantes, achèvement en 2031-2032 ; Cour des comptes, décembre
  2025) est supposé financé par les crédits que la tendance reconduit : la
  mesure ne paie que les places au-delà ;
* 270 k€ par place nette est le coût moyen du plan 15 000 ; pour des
  centres pénitentiaires (450 k€), la construction coûte 12,2 Md€
  (variante) ; le modulaire (≈ 200 k€) serait moins cher ;
* les premières places ouvrent en 2030 (modulaire, ≈ 18 mois), les
  établissements classiques ensuite (≈ 7 ans de la recherche foncière à la
  livraison). Livrer ≈ 36 700 places de 2030 à 2035, plan 15 000 compris,
  suppose un rythme près de sept fois celui du plan 15 000, que le rapport
  Hetzel (Assemblée nationale, 2023) juge irréalisable en moins de dix
  ans. Le calendrier est donc à risque ; le coût, compté en entier dans
  l'horizon, est prudent ;
* les détenus logés dans les places nouvelles sont déjà incarcérés : seule
  la moitié des frais hors personnel de la journée de détention (129,33 €,
  dont 95,48 € de personnel) est ajoutée, pour l'entretien et l'énergie ;
* ≈ 13 000 surveillants à recruter, en plus d'un déficit actuel de 4 000 à
  6 000 postes (Assemblée nationale et Sénat, PLF 2026).

Avec O-74 et O-75, le déficit 2035 du Texte Orientation D passe de 3,79 % à
3,83 % (moteur de demande) ; la baisse chaque année est préservée sous les
trois moteurs (toujours 16 scénarios sur 36), mais de 0,01 point seulement
en 2032, quand les places ouvertes font monter le fonctionnement alors que
la construction est à son maximum.

### O-76 et O-77 — Baisser à la fois le déficit et le chômage

**Ce que le modèle commun voit désormais.**

* *Incidence des prélèvements* : l'effet d'un impôt sur l'activité dépend de
  qui le paie. Relativement à l'effet moyen d'un prélèvement : TVA, IR, CSG
  1,1 ; IS 0,55 ; droits de succession et impôts sur le patrimoine 0,2
  (Mésange, OFCE, Commission européenne, CBO ; propension à consommer le
  patrimoine quasi nulle en haut de la distribution). La taxe sur les
  holdings (O-41) passe sur la nouvelle ligne « patrimoine » : elle pèse
  presque dix fois moins sur l'activité ; la CSG sur les gros héritages
  (O-36) aussi.
* *Coût du travail* : les allègements généraux de cotisations patronales
  (≈ 75 Md€, dont 87 % entre 1 et 1,6 SMIC avec la réduction unique de 2026)
  sont suivis par tranche de salaire, et l'emploi y répond au coût du
  travail : ≈ 14 500 emplois par Md€ sous 1,6 SMIC, ≈ 5 100 de 1,6 à
  2,5 SMIC, presque rien au-delà (CAE 2019, Bozio et Wasmer 2024, Groupe
  d'experts sur le SMIC 2025), en cinq ans environ. **Les réductions
  d'exonérations O-38, O-56 et O-61 (22 Md€ en 2034), réparties comme les
  allègements, coûtent ensemble ≈ 230 000 emplois** : c'est la première
  cause du chômage du programme. Leur rendement net reste réel (−0,4 point
  de déficit en 2035), mais plus du tiers du rendement statique est repris
  par la baisse de l'emploi.
* *Lois en vigueur* : contribution à l'Union (27,9 Md€ en 2026, puis le
  remboursement de NextGenerationEU), fin de l'aide exceptionnelle à
  l'apprentissage (voir O-20), prime d'activité revalorisée, ruptures
  conventionnelles, et le complément de fin de droits de l'assurance
  chômage, déclenché quand le chômage atteint 9 %.

**Mesures retenues** (recherche des évaluations chiffrées qui baissent les
deux à la fois ; aucune n'a de preuve causale sur le chômage d'ensemble, le
double effet documenté venant de la réallocation) :

| Mesure | Chiffrage | Déficit 2035 | Chômage 2035 | Emplois 2035 |
|---|---|---|---|---|
| **O-76** Allègements recentrés : sortie à 2 SMIC au lieu de 3, l'économie reversée aux salaires de 1 à 1,6 SMIC, à coût constant | ≈ 4,3 Md€ déplacés (2025) ; le CAE (2019) recommandait de supprimer les allègements au-delà de 2,5 SMIC ; Bozio et Wasmer : +50 000 emplois pour la suppression des bandeaux avec recyclage | −0,04 pt | −0,12 pt | +44 000 |
| **O-77** Accompagnement renforcé : 10 000 conseillers de plus à France Travail | 0,8 Md€ par an (80 000 € par conseiller, hypothèse) ; −5 chômeurs par conseiller, éviction comprise (expériences aléatoires en France, Autriche, Allemagne) | −0,06 pt | −0,14 pt | +44 000 |

(Scénario central, mesures prises isolément ; les trois moteurs donnent les
mêmes ordres de grandeur.) Après O-76, les réductions d'O-56 et d'O-61
portent sur les seuls allègements restants, au voisinage du SMIC.

**Résultat** : déficit 2035 de 3,91 % (moteur de demande), chômage de 9,2 %,
baisse du déficit chaque année préservée sous les trois moteurs (16
scénarios sur 36), avec une marge minimale de 0,02 point (2032). Sans O-76
ni O-77 : 4,06 % et 9,4 %, le seuil de 9 % franchi dès 2033.

**Effet de seuil** : le chômage atteint 9,05 % en 2034 ; le complément de
fin de droits (règles contracycliques, décret n° 2023-33) coûte alors
5,5 Md€ en 2035 (+0,14 point). Rester sous 9 % rapporte donc d'un coup
≈ 0,15 point de déficit. Deux variantes y parviennent (évaluées dans la
synthèse) :

| Variante | Déficit 2035 | Chômage 2035 |
|---|---|---|
| O-76 avec sortie à 1,6 SMIC (tout reversé sous 1,6 SMIC) | 3,76 % | 9,10 % |
| O-77 avec 15 000 conseillers | 3,76 % | 9,15 % |

La sortie à 1,6 SMIC accentue la pente du barème entre 1 et 1,6 SMIC, que
Bozio et Wasmer jugent déjà trop forte (« trappe à bas salaires ») ; l'effet
d'un accompagnement à plus grande échelle n'est pas documenté. Renoncer à
O-61 ramènerait le chômage à 9,0 %, mais le déficit 2035 à 4,05 % et
interromprait sa baisse en 2032.

Autres pistes examinées, non retenues : suppression des aides à l'embauche
à fort effet d'aubaine (emplois francs, déjà supprimés en 2026) ; formation
qualifiante (chômage en baisse, déficit en hausse) ; crèches et Territoires
zéro chômeur (coût net par emploi de 11 000 à 14 000 €) ; régularisation des
travailleurs sans papiers (≈ 4 000 € de cotisations par personne et par an
en Espagne, sans chiffrage français, effet sur le chômage mesuré ambigu) ;
TVA sociale (à budget constant ; la hausse de TVA d'O-29 finance déjà le
redressement) ; dégressivité et plafonnement des allocations chômage
élevées (+4,5 points de retour à l'emploi pour les hauts salaires,
0,5 à 1,5 Md€ ; peu compatible avec la démission indemnisée d'O-09) ; et
les mesures déjà prises par le programme (heures supplémentaires,
apprentissage, fraude).

### O-78 à O-81 — Indice de développement humain

**Modèle commun.** L'IDH est calculé chaque année selon la formule du PNUD :
espérance de vie, durée attendue et durée moyenne de scolarisation, RNB par
habitant en volume. Départ : 0,924 en 2025 (0,920 en 2023, 26e rang ;
PNUD, RDH 2025). Une année de durée attendue de scolarisation vaut ≈ 0,010
d'IDH, deux fois une année d'espérance de vie, autant que +21 % de revenu
par habitant : l'écart de la France avec les pays de tête tient à
l'éducation. Les décès évités par les mesures allongent l'espérance de vie
(décès évités × années de vie que chacun aurait perdues / décès de l'année),
au rythme du délai d'effet de chaque cause : les voitures électriques des
mesures (pollution), la prévention des accidents du travail (O-14) et les
mesures ci-dessous.

| Mesure | Chiffrage | IDH 2035 | Déficit 2035 | Autres effets |
|---|---|---|---|---|
| **O-78** Prix minimum de l'alcool : 0,50 € par verre | −22 % de décès par cancers liés à l'alcool (Etilé et al., INCa-MILDECA, 2022) ; sans effet net sur les finances publiques | +0,0002 | 0 | espérance de vie +0,05 an |
| **O-79** Prix du tabac +20 % (paquet ≈ 15 €) | élasticité −0,4 (Santé publique France) ; 68 000 décès attribuables, en baisse de 8 % à terme | +0,0002 | −0,04 pt | espérance de vie +0,04 an |
| **O-80** Dépistage du cancer colorectal à 65 % de participation (30,7 % aujourd'hui) | −22 % de mortalité (Barré et al., 2020) ; ≈ 0,26 Md€ par an (hypothèse : 70 € par dépistage) | +0,0003 | ≈ 0 | espérance de vie +0,06 an |
| **O-81** Scolarisation des 18-24 ans : +1 point par an pendant trois ans | ≈ 168 000 étudiants de plus, 13 300 € chacun (DEPP) : ≈ 2,2 Md€ par an | +0,0021 | +0,04 pt | durée attendue +0,21 an ; +10 600 emplois (dépense) |

(Scénario central, moteur de demande, mesures prises isolément, 2035.) Les
effets sur la mortalité montent lentement (délais d'effet de 8 à 20 ans) :
une partie seulement est acquise en 2035.

**Résultat** : IDH de 0,9428 en 2035, contre 0,9410 sans programme ; sans
O-78 à O-81, il serait de 0,9399, sous le tendanciel (le PIB par habitant
du programme est plus faible, la norme de dépense pesant sur l'activité).
La propriété « IDH non dégradé » est tenue au scénario central.

**Décision à prendre : baisse du déficit chaque année.** Voir « Points à
arbitrer » (point 1) pour l'état à jour, calculé avec le modèle affiné.

Autres pistes examinées : 80 km/h sur le réseau secondaire (≈ 210 vies par
an, Cerema : IDH +0,00005) ; ZFE (décès évités non chiffrés) ;
taxe soda (effet faible et transitoire) ; VigilanS contre la récidive
suicidaire (−38 %, décès non isolés). La durée moyenne de scolarisation
des adultes ne bouge qu'avec le renouvellement des générations.

### O-24 — Dette numérique en stablecoin, exonérée de PFU

Le mécanisme d'USDC appliqué à la dette française : des **OAT numériques**
(titres tokenisés inscrits sur une chaîne de blocs) que l'on achète et
revend en **jetons de monnaie électronique euro** conformes à MiCA. Les
intérêts sont **exonérés du prélèvement forfaitaire unique** (31,4 % en
2026 : 12,8 % d'IR, 10,6 % de CSG, 0,5 % de CRDS, 7,5 % de solidarité)
pour les particuliers résidents. Les non-résidents ne paient déjà pas
d'impôt français sur ces intérêts : pour eux, seul l'accès en jetons
change.

Contraintes juridiques prises en compte :

* MiCA (règlement (UE) 2023/1114), art. 50 : aucun intérêt ne peut être
  versé au détenteur d'un jeton de monnaie électronique. Le jeton sert
  donc à **régler** l'achat ; le rendement est porté par l'OAT numérique.
  Les réserves des émetteurs significatifs sont placées à 60 % en dépôts
  bancaires (30 % pour les autres), le reste en actifs liquides comme les
  titres d'État courts.
* Régime pilote DLT (règlement (UE) 2022/858) : 6 Md€ au total pour tous
  les titres tokenisés aujourd'hui ; 100 Md€ proposés par la Commission
  (décembre 2025), au moins 150 Md€ demandés par les plateformes. La
  tranche visée (≈ 57 Md€ en 2035) suppose ce relèvement, ou une émission
  par le dépositaire central hors régime pilote.

Modélisation (`detteNumerique`, calcul annuel dans la projection) :

| Paramètre | Valeur | Repère |
|---|---|---|
| Tranche cible | 1 % de la dette, +0,2 point/an, atteinte en 2032 | ménages italiens : ≈ 13 % de la dette italienne |
| Capitalisation fiscale θ | 50 % | obligations municipales américaines : 60 % à 10 ans, 22 % à 30 ans |
| Décote de taux | θ × 31,4 % = 15,7 % du taux | |
| Part des particuliers résidents ρ | 80 % | le reste : réserves d'émetteurs, non-résidents |
| Part venant de produits imposés α | 60 % | le reste : livrets exonérés |

Pour un euro de tranche au taux y : économie d'intérêts θ·t·y, perte de
PFU (1 − θt)·y·t·ρα, d'où un **gain net y·t·(θ − (1 − θt)·ρα)**. La mesure
rapporte si θ dépasse **θ\* = ρα / (1 + t·ρα) ≈ 0,42**. Avec θ = 0,5 :
≈ 10 pb sur la tranche, soit en 2035 294 M€ d'intérêts économisés contre
238 M€ de PFU perdu (+56 M€/an). Avec θ = 0,3, elle coûte ≈ 80 M€/an.
Son effet budgétaire est donc faible et son signe dépend de θ : l'intérêt
de la mesure tient surtout à l'élargissement de la base d'investisseurs
et à l'accès direct des épargnants, pas au solde.

Non modélisé : la décollecte des livrets exonérés réduit les ressources du
fonds d'épargne de la Caisse des dépôts, qui finance le logement social
(à mettre en regard de O-02 et O-03) ; l'effet de la demande des émetteurs
de jetons sur le taux des titres courts (de l'ordre du point de base par
milliard aux États-Unis, BRI 2025), négligeable aux montants en jeu.

### O-82 et O-83 — Violences sexistes et sexuelles, allocations familiales dès le premier enfant

| Mesure | Chiffrage | Déficit 2035 | Chômage 2035 | Emplois | IDH (dix-millièmes) |
|---|---|---|---|---|---|
| **O-82** Loi intégrale contre les violences sexistes et sexuelles | besoin de 2,6 à 5,4 Md€ par an (Fondation des femmes, « Où est l'argent contre les violences faites aux femmes ? ») ; crédits dédiés de moins de 200 M€, dont 95,6 M€ au programme 137 en 2026 (amendement CF1398 au PLF 2026). Retenu : bas de la fourchette moins les crédits existants, 2,4 Md€ de dépense nouvelle (justice, police, hébergement et accompagnement des victimes) | +0,07 pt | −0,03 pt | +11 900 | +0,3 |
| **O-83** Allocations familiales dès le premier enfant, 70 € par mois | proposition de loi adoptée en première lecture le 5 juin 2025 ; 2,8 Md€ bruts par an, 1,8 Md€ nets des moindres versements de RSA et de prime d'activité (direction de la Sécurité sociale, rapport AN n° 1473, p. 19-20) | +0,05 pt | −0,01 pt | +6 000 | +0,2 |

(Scénario central, moteur de demande, mesures prises isolément, 2035, modèle
affiné.) Variantes chiffrées : haut de la fourchette pour O-82 (5,4 Md€) ;
75 € par mois modulés selon le revenu pour O-83 (LexImpact : 3,58 Md€
bruts). Ensemble, les deux mesures portent le déficit 2035 de 4,69 % à
4,80 % ; elles ne sont pas financées (voir « Points à arbitrer »).

## Points à arbitrer

Chiffres calculés avec le modèle affiné (trajectoires macroéconomiques de
2026 à 2030, élasticités cycliques, intérêts par refinancement et
indexation, rétro-test sur 2017-2025 : voir le README du dépôt). Ils ne
sont pas comparables aux chiffres des sections précédentes, calculés avec
l'ancien modèle : le tendanciel y est plus dégradé (déficit 2035 de 9,98 %
au lieu de 9,08 %), surtout par la charge d'intérêts.

État du programme (scénario central, 2035, moteur de demande) : déficit de
4,80 % du PIB (9,98 % sans programme), dette de 138,5 % (161,0 %), chômage
de 9,44 % (7,90 %), IDH de 0,9410 (0,9392), émissions de 284 Mt CO₂e (296).
Non tenues au scénario central : déficit sous 3 % et sous le plafond
juridique, équilibre, dette stabilisée, règles budgétaires européennes,
chômage non dégradé, objectifs climatiques (secteurs 2030, budget carbone
2029-2033) ; baisse du déficit chaque année sous le seul moteur d'offre.

Options chiffrées (programme complet modifié, scénario central, 2035) :

| Option | Déficit | Chômage | IDH | Baisse chaque année (demande / offre / équilibre) |
|---|---|---|---|---|
| Programme actuel | 4,80 % | 9,44 % | 0,9410 | oui / non / oui |
| **A.** O-62 : niches −1,5 Md€ de plus par an de 2029 à 2035, au lieu de −1 Md€ | 4,73 % | 9,45 % | 0,9410 | oui / oui / oui |
| **B.** A, plus O-76 avec sortie à 1,6 SMIC et O-77 avec 15 000 conseillers | 4,63 % | 9,27 % | 0,9410 | oui / non / oui |
| **C.** A, plus O-81 à +5 points (250 000 places) | 4,77 % | 9,43 % | 0,9422 | oui / non / oui |
| **D.** Deuxième journée de solidarité (7 heures), CSA de 0,3 % à 0,6 %, affectée à l'autonomie | 4,55 % | 9,42 % | 0,9412 | oui / oui / oui |
| **E.** A et D | 4,47 % | 9,43 % | 0,9412 | oui / oui / oui |
| IS à 17 % au lieu de 15 % (variante d'O-08) | 4,62 % | 9,45 % | 0,9410 | oui / non / oui |
| IS maintenu à 25 % (variante d'O-08) | 4,00 % | 9,50 % | 0,9410 | oui / non / oui |
| Norme de dépense renforcée de 100 pb (variante d'O-55) | 3,56 % | 9,99 % | 0,9403 | oui / oui / oui |
| Norme de dépense renforcée de 200 pb (variante d'O-55) | 2,36 % | 10,52 % | 0,9397 | oui / oui / oui |

1. **Baisse du déficit chaque année.** Sous le moteur d'offre, le déficit
   stagne en 2034 (4,80 % en 2033 comme en 2034), avec ou sans O-82 et
   O-83 ; il baisse chaque année sous les moteurs de demande et
   d'équilibre. Il manque quelques centaines de millions d'euros cette
   année-là. Les options A, D et E rétablissent la baisse sous les trois
   moteurs (A de justesse : 4,76 % puis 4,75 % sous le moteur d'offre) ;
   les dépenses ajoutées par B et C la rompent à nouveau, et les variantes
   d'IS, appliquées sans A, ne la rétablissent pas. Toute dépense nouvelle
   (pistes ci-dessous) la rompt aussi si elle n'est pas financée : chaque
   piste de dépense est à apparier à une recette ou à une économie.
2. **Chômage.** 9,44 % en 2035 contre 7,90 % sans programme. Premières
   causes : les réductions d'exonérations O-38, O-56 et O-61 (≈ 233 000
   emplois) et la norme de dépense O-55 (≈ 220 000) ; l'IS à 15 % (O-08,
   +21 000), O-76 et O-77 (+44 000 chacune) compensent en partie. Au-delà
   de 9 %, le complément de fin de droits de l'assurance chômage se
   déclenche. L'option B le réduit (9,27 %) ; passer sous 9 % suppose
   d'alléger O-56 ou O-61, au prix d'un déficit plus élevé.
3. **Déficit sous 3 % et règles européennes.** La baisse moyenne
   (≈ 0,1 point par an de 2026 à 2035) reste loin de l'ajustement de
   0,5 point par an du cadre européen. Les leviers évalués qui mènent sous
   3 % coûtent en emploi : seule la norme renforcée de 200 pb y parvient
   (2,36 %), avec 10,52 % de chômage. Le maintien de l'IS à 25 % (4,00 %)
   défait le choix d'O-08 sans atteindre 3 %.
4. **IDH.** L'éducation est le levier le plus fort (O-81) ; l'option C
   porte l'IDH à 0,9422 pour 0,04 point de déficit, d'où l'appariement
   avec A.
5. **Climat.** Aucun programme du dépôt n'atteint les objectifs sectoriels
   2030 de la SNBC-3. Écarts du programme en 2030 (Mt CO₂e) :

| Secteur | Programme 2030 | Objectif SNBC-3 | Écart |
|---|---|---|---|
| Transports | 109,6 | 92 | +17,6 |
| Bâtiments | 49,4 | 37 | +12,4 |
| Industrie | 50,2 | 42 | +8,2 |
| Production d'énergie | 28,4 | 25 | +3,4 |
| Déchets | 13,7 | 12 | +1,7 |
| Agriculture | 68,9 | 68 | +0,9 |
| **Total** | **320** | **276** | **+44** |

   Le modèle commun ne relie aux émissions que des leviers précis
   (véhicules remplacés ou aidés, bornes, rénovation aidée, conversion
   agricole, taxes environnementales, levier `transition` : tonnes évitées
   par secteur pour un coût donné). Une dépense « climat » générique n'y
   change rien : chaque mesure climatique doit sourcer ses tonnes évitées et
   son coût.

L'option D reprend la contribution de solidarité par le travail votée par
le Sénat le 20 novembre 2024 (PLFSS 2025, 216 voix contre 119 ; ≈ 2,5 Md€
par an, gouvernement défavorable « à ce stade ») : 7 heures non rémunérées
de plus par an (+0,4 % de durée du travail, levier `dureeTravail`), et la
contribution patronale correspondante dépensée pour l'autonomie. Elle
finance un domaine absent du programme, mais revient à du travail non
rémunéré : point politique à trancher.

## Pistes pour compléter

### Domaines absents du programme

Mesures déjà chiffrées dans les autres programmes du dépôt, ajoutées une à
une au Texte Orientation D (scénario central, moteur de demande, 2035,
modèle affiné ; IDH en dix-millièmes). Non financées, elles creusent le
déficit et laissent la stagnation de 2034 sous le moteur d'offre (voir les
options A et D) ; la norme de dépense (O-55) absorbe une partie de leur
coût à terme. La loi intégrale contre les violences sexistes et sexuelles
(P-07) et les allocations familiales dès le premier enfant (PC-11) sont
désormais dans le programme (O-82 et O-83).

| Domaine | Mesure (programme d'origine, chiffrage du parti) | Déficit | Chômage | IDH |
|---|---|---|---|---|
| Santé, déserts médicaux | Hôpitaux et EHPAD publics, mutuelle gratuite des 18-25 ans, 5 Md€ (PS, P-11) | +0,15 pt | −0,07 pt | +0,6 |
| Logement | APL +10 %, allocations dès le premier enfant (Écologistes, E-14) | +0,13 pt | −0,04 pt | +0,5 |
| Jeunesse | Garantie d'autonomie de 1 337 € par mois (LFI, L-19) | +0,26 pt | −0,09 pt | +1,1 |
| École | Classes à 19 élèves en 2032, 12 en éducation prioritaire (Écologistes, E-12) | +0,16 pt | −0,10 pt | +0,9 |
| École | 90 000 enseignants, AESH, infirmières et médecins scolaires (PCF, PC-12) | +0,09 pt | −0,05 pt | +0,4 |
| Aidants, dentaire | Proches aidants, soins dentaires, 3,4 Md€ (RN, RN-19) | +0,09 pt | −0,04 pt | +0,4 |
| Adaptation au climat | Fonds unique d'adaptation, 2 Md€ par an (Horizons, H-03) | +0,04 pt | −0,02 pt | +0,2 |
| Adaptation au climat | Plan national d'adaptation, 7 Md€ par an en 2032 (Écologistes, E-03) | +0,18 pt | −0,08 pt | +0,8 |
| Rénovation | Rénovation thermique des logements privés, 10 Md€ (PCF, PC-03) | +0,25 pt | −0,11 pt | +1,1 |
| Mobilités | Réseau cyclable, 1 Md€ par an (PCF, PC-02) | +0,03 pt | −0,01 pt | +0,1 |

E-14 recoupe en partie O-83 (allocations dès le premier enfant) : son
chiffrage s'ajouterait à O-83 sans le corriger de ce recouvrement.

La rénovation (PC-03) et le vélo (PC-02) ne changent pas les émissions du
modèle tant que leurs tonnes évitées ne sont pas sourcées (levier
`transition`, ou sous-modèle rénovation comme O-63).

Autres domaines sans mesure, ni ici ni dans le modèle : grand âge et
dépendance au-delà de l'option D ; petite enfance (places de crèche) ;
biodiversité et eau ; énergies renouvelables (seul le nucléaire est chiffré,
O-04) ; culture ; immigration et intégration ; sécurité intérieure.

### Chiffrages à documenter

* 30 mesures sur 83 reposent au moins en partie sur une hypothèse ; les plus
  lourdes sur le solde : durée de cotisation (O-44, O-58 : −0,33 et
  −0,35 point), accidents du travail (O-14 : −0,34 point), fin de l'âge
  légal (O-07 : +0,30 point).
* Trois chiffrages du groupe PS sans contre-expertise connue : CSG sur les
  gros héritages (O-36, 10 Md€ : −0,36 point), exonérations (O-38, 4 Md€),
  train de vie de l'État (O-39, 3,1 Md€).

### Données à compléter

* Prix unitaire et part importée des véhicules de remplacement (O-01).
* Valeurs électriques (consommation, prix à l'export) à sourcer (RTE).
* Chiffrage de O-03 et éventuelle hypothèse d'effet sur l'immobilier.
* Distribution des âges de départ sans borne d'âge (O-07, COR) ; coût réel
  de la démission indemnisée (O-09, Unédic) ; calendrier des lignes
  nouvelles (O-11).
* Taux du prêt bonifié et calendrier réel des décaissements (O-04), dès
  la décision finale d'investissement.
* Panel SRU réel (inventaire SRU par commune) à la place des communes
  fictives.

Les chiffres cités dans les sections des mesures décrivent l'effet de chaque
étape au moment de son ajout, avec le modèle de l'époque (avant le modèle
affiné, sauf O-82 et O-83) ; les chiffres à jour sont ceux de « Points à
arbitrer », de « Pistes pour compléter » et de la synthèse.
