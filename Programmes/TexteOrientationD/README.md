# Texte Orientation D

Programme de orientation_d. Seuls les comptes listés dans `PROPRIETAIRES`
peuvent modifier ce dossier.

## Mesures

### O-01 — Remplacement gratuit des 10 000 voitures les plus polluantes

10 000 citadines électriques à 25 000 € (hypothèse), soit 250 M€ versés
une fois. Effet sur la balance commerciale (sous-modèle
`Modele/Automobile.lean`, détail dans le rapport) :

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
remplacés, hypothèse documentée dans `Hypotheses/Energie.lean`) et vérifie
la propriété « un point de recharge public pour dix véhicules en 2035 ».
Montants : hypothèses à arbitrer.

### O-07 — Retraite à la durée cotisée, sans âge légal

La notion d'âge légal disparaît : on part dès que la durée cotisée atteint
le seuil actuel (172 trimestres), réduit selon la pénibilité. Le modèle
commun ne connaît qu'un âge moyen de départ : la mesure est traduite en un
avancement moyen de 6 mois (variante : 12 mois), dont le coût et l'effet
sur la population active suivent l'hypothèse économique du scénario.
Hypothèse à étayer avec les données du COR (distribution des âges de
début de carrière, part des métiers exposés).

### O-08 — Impôt sur les sociétés à deux points au-dessus du taux le plus bas de l'UE

11 % : taux hongrois de 9 %, le plus bas de l'Union, plus deux points.

**Minimum mondial de 15 % (pilier 2).** Les groupes de plus de 750 M€ de
chiffre d'affaires restent imposés à 15 % effectifs au moins : sous ce
taux, la France perçoit elle-même le complément (impôt complémentaire
national, loi de finances pour 2024). Avec 45 % de l'IS acquitté par ces
groupes (hypothèse), le taux effectif moyen est de 12,8 % et la perte
statique de ≈ 28,7 Md€ par an sur 58,9 Md€ d'IS (contre 37,7 Md€ à 9 %
sans tenir compte du pilier 2).

Le levier `impotSocietes` applique ensuite un **coefficient de retour
d'assiette** : la part de cette perte récupérée grâce aux bénéfices
rapatriés et aux sociétés qui reviennent ou s'implantent. Valeur centrale
30 % (hypothèse fondée sur une élasticité de l'assiette au taux de l'ordre
de 1). Variantes : 17 % (deux points au-dessus du minimum de 15 % du
pilier 2, si c'est ce minimum qui est visé), sans retour d'assiette, sans
plancher du pilier 2. Sous le moteur « offre », la baisse des prélèvements
relève en outre la croissance.

Effet en 2035 (mesure seule, central) : déficit +0,58 point (+0,76 à 9 %),
PIB +0,38 % ; moteur d'offre : +0,12 point, PIB +1,06 %.

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

* **O-20** Aide à l'apprentissage réservée à l'infra-bac et aux PME :
  −2 Md€/an (Cour des comptes 2025 : 6 Md€ dont la moitié pour des bac+3
  et plus).
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
| **O-28** Désindexation des très hautes retraites : revalorisation limitée à la part sous 5 150 € bruts par mois | 1 % des retraités, 6 470 € en moyenne (DREES) ; part au-delà du seuil 2,85 Md€ ; 1,8 % d'inflation évitée par an : −50 M€ en 2027, −422 M€ (euros 2027) en 2035 | −0,01 pt | −0,02 % | −1 600 |
| **O-29** TVA : taux normal 20 % → 22 % | 1 point ≈ 8 Md€ (FIPECO, IPP, Sénat) : 16 Md€ statiques, 12,8 Md€ après fuite fiscale | −0,35 pt (−0,15) | −0,21 % (−0,52 %) | −30 000 (−77 000) |
| **O-30** Taxe forfaitaire de 3 000 € par atterrissage de jet privé | 85 000 atterrissages (84 885 départs en 2022, Greenpeace) : 255 M€ statiques | −0,01 pt | ≈ 0 | −500 |
| **O-31** Conversion électrique de toutes les exploitations agricoles en dix ans | 389 000 exploitations × 30 000 € : 1,17 Md€ par an ; −1 Mt de CO₂ par an (10 Mt au total, énergie agricole) ; importations nettes −116 M€ par an | +0,02 pt | +0,02 % | +3 500 |
| **O-32** Suppression du DPE dans les quartiers historiques ; climatisation réversible aidée | 50 000 logements × 2 000 € par an pendant dix ans : 100 M€ par an | ≈ 0 | ≈ 0 | +300 |
| **O-33** Pas de tours dans les quartiers historiques ; quartiers nouveaux autour des pôles très desservis (Val de Fontenay) | 20 000 logements × 10 000 € d'équipements publics : 200 M€ par an | ≈ 0 | ≈ 0 | +700 |
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

### O-35 à O-42 — Redressement compatible avec les positions du PS

Base : propositions du groupe socialiste à l'Assemblée (16 septembre 2026),
note de la Cour des comptes sur la fiscalité du patrimoine (septembre
2026), revue des niches fiscales. Quand un chiffrage indépendant existe et
diffère de celui du PS, il est retenu et le chiffrage PS devient une
variante.

| Mesure | Rendement statique | Déficit 2035 | PIB 2035 |
|---|---|---|---|
| **O-35** Taxe Zucman (impôt plancher sur les très hauts patrimoines) | 6,5 Md€ (PS : 15 ; sept économistes : ≈ 5) | −0,14 pt | −0,09 % |
| **O-36** CSG sur les gros héritages | 10 Md€ (chiffrage PS) | −0,22 pt | −0,13 % |
| **O-37** Taxe sur les services numériques de 3 % à 15 % | 3,1 Md€ (PS : 10) | −0,07 pt | −0,04 % |
| **O-38** Reconfiguration des exonérations de cotisations | 4 Md€ (PS) | −0,09 pt | −0,06 % |
| **O-39** Train de vie de l'État | 3,1 Md€ (part du PS, moins O-21) | −0,06 pt | −0,08 % |
| **O-40** Niches fiscales −10 % (hors Dutreil et ménages modestes) | 8 Md€ sur 88,3 | −0,18 pt | −0,11 % |
| **O-41** Pacte Dutreil divisé par deux (75 % → 37,5 %), taxe sur les holdings élargie | 2,95 Md€ (Cour des comptes, proportionnel) | −0,07 pt | −0,04 % |
| **O-42** Norme de dépense : +0,5 % en volume sur les dépenses pilotables | 50 pb par an sur ≈ 739 Md€ | −0,55 pt | −0,75 % |
| **O-43** Défense : −1 Md€ par an | 1 Md€ sur 53 | −0,02 pt | −0,03 % |
| **O-44** Durée de cotisation : 174 trimestres au lieu de 172 | âge moyen de départ +5 mois (80 % des départs liés à la durée, hypothèse) : ≈ 3,3 Md€ de pensions, 150 000 actifs | −0,33 pt | +0,29 % |
| **O-45** Lutte contre la fraude fiscale : facturation électronique (2,5 Md€ de TVA dès 2028 ; 2 à 3 Md€ attendus par l'administration), 1 500 agents de contrôle (105 M€) pour 1,5 Md€ d'encaissements | 4 Md€ | −0,08 pt | −0,05 % |
| **O-46** CSG progressive : +2 points au-delà de 100 000 € par an et par personne | 2,0 Md€ (1 point = 17 Md€ ; 6 % de l'assiette au-delà du seuil, hypothèse) | −0,05 pt | −0,03 % |

(Scénario central, moteur de demande, mesures prises isolément.)

**Résultat : le Texte Orientation D est à 6,3 % de déficit en 2035**
(dette 137 % du PIB, chômage 8,4 %), contre 8,4 % sans programme. Depuis
l'ajout de la prime de risque (un point de déficit au-dessus de celui de
2025 relève le taux marginal de 25 pb), le tendanciel se dégrade (taux
marginal 4,0 % en 2035) et le Texte Orientation D profite d'un taux
plus bas (3,6 %). Le modèle évalue désormais la
propriété « Budget à l'équilibre en 2035 » pour tous les programmes ;
aucun ne la tient.

**L'équilibre en 2035 n'est pas atteignable avec des mesures compatibles
avec le PS.** Au tendanciel, le solde primaire est d'environ −3 % du PIB et
les intérêts montent vers 4 % : revenir à 0 % demande un effort permanent
de l'ordre de 6,5 à 7 points de PIB. Ordres de grandeur, calculés avec le
modèle (scénario central, moteur de demande) :

| En plus des mesures O-35 à O-53 | Déficit 2035 | Chômage 2035 |
|---|---|---|
| Rien | 6,3 % | 8,4 % |
| Abandon de O-08 (IS maintenu à 25 %) | 5,4 % | 8,6 % |
| … et norme à zéro volume (100 pb au lieu de 50) | 4,7 % | 8,9 % |
| … et norme de 300 pb par an | 1,9 % | 9,9 % |
| … et norme de 450 pb par an (dépenses pilotables ≈ −33 % en 2035) | ≈ 0 % | ≈ 10,7 % |

La prime de risque rend l'équilibre un peu moins lointain (450 pb de norme
au lieu de 600) : chaque point de déficit en moins fait baisser les taux.
La dernière ligne reste la mesure du problème plutôt qu'une option : par
le multiplicateur, le PIB baisse de ≈ 5,5 % et le chômage monte de plus de
deux points. Les postes du
Texte Orientation D qui pèsent le plus sur le solde en 2035 sont O-08 (IS,
+0,58 pt), O-07 (retraite à la durée cotisée, +0,43 pt) et O-25
(enseignants, +0,21 pt).

### O-47 et O-48 — Participations stratégiques, autoroutes

**O-47** — 100 M€ par an de prises de participation de l'État dans des
entreprises stratégiques. C'est une opération financière : la dette
augmente, pas le déficit. Les dividendes suivent le rendement du
portefeuille de l'APE (4,0 Md€ en 2025 pour 209,1 Md€, ≈ 1,9 %), inférieur
au taux d'intérêt de la dette (3,3 %) : chaque euro emprunté pour acheter
des parts coûte ≈ 1,4 centime par an. En 2035 : +17 M€ de dividendes,
+24 M€ d'intérêts, effet négligeable sur le solde. L'intérêt de la mesure
est stratégique, pas budgétaire.

**O-48** — Non-renouvellement des concessions autoroutières : exploitation
publique à l'échéance, péages maintenus. Le gain pour les administrations
publiques est l'EBITDA moins les investissements de renouvellement, moins
l'IS que payaient les concessionnaires (≈ 5,7 Md€ par an pour l'ensemble des
sociétés historiques hors Cofiroute, en euros 2023).

| Concession | Échéance | Part de l'EBITDA (hypothèse) | Comptée à partir de |
|---|---|---|---|
| Sanef | 31/12/2031 | 11,8 % | 2032 |
| Escota | 29/02/2032 | 7,6 % | 2033 |
| SAPN | 31/08/2033 | 3,9 % | 2034 |
| APRR | 30/11/2035 | 19,7 % | 2036 |
| ASF | 30/04/2036 | 34,7 % | 2037 |
| AREA | 30/09/2036 | 5,6 % | 2037 |
| Cofiroute | 31/12/2086 | 16,7 % | — |

Effet en 2035 (mesure seule) : +2,0 Md€ de recettes non fiscales nettes de
l'IS perdu, déficit −0,06 point ; à partir de 2037, l'essentiel du réseau
(83 %) est repris, soit ≈ 4,7 Md€ par an (euros 2023). Variante : péages
baissés de 20 % à la reprise. Sources : Autorité de régulation des
transports (EBITDA 9,1 Md€, investissements 1,5 Md€, dividendes 4,1 Md€ en
2023), échéances Arafer 2018 ; IS estimé.

### O-49 à O-53 — Hauts fonctionnaires, élus, capital, conseil

| Mesure | Chiffrage | Déficit 2035 |
|---|---|---|
| **O-49** Hauts fonctionnaires −5 % | 21 500 agents de l'encadrement supérieur et dirigeant (DGAFP), coût complet ≈ 2,9 Md€ : 147 M€ | ≈ 0 |
| **O-50** Revenus des élus plafonnés à 10 000 € par mois | Le plafond de cumul en vigueur est déjà de 8 897,93 € bruts (CGCT, art. L. 2123-20 II) : sans effet, sauf à l'étendre aux rémunérations qui y échappent | 0 (pour mémoire) |
| **O-51** Fin du PFU, revenus du capital au barème | +3,2 à 3,6 Md€ à comportements inchangés (Institut Montaigne) ; variante −0,7 Md€ si l'assiette revient à 2017 | −0,08 pt |
| **O-52** Taxe sur les rachats d'actions de 8 % à 20 % | 3 Md€ mécaniques, 1,5 Md€ retenus (report vers les dividendes) | −0,03 pt |
| **O-53** Cabinets de conseil divisés par deux | 893,9 M€ en 2021 (Sénat) : 400 M€ | −0,01 pt |

Pour O-50, un plafond à 10 000 € est moins strict que le droit actuel. Pour
limiter réellement le cumul, il faudrait abaisser le plafond (par exemple à
une indemnité parlementaire de base, 5 932 €) ou l'étendre aux fonctions
dans les organismes extérieurs ; leur montant n'étant pas publié, le gain
n'est pas chiffré.

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

## À compléter

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
