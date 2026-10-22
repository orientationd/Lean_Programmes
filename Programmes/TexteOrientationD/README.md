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

### O-08 — Impôt sur les sociétés au taux le plus bas de l'UE

Taux hongrois de 9 %. Le levier `impotSocietes` calcule la perte statique
au prorata des taux (−37,7 Md€/an sur 58,9 Md€ d'IS 2025) puis applique
un **coefficient de retour d'assiette** : la part de cette perte récupérée
grâce aux bénéfices rapatriés et aux sociétés qui reviennent ou
s'implantent. Valeur centrale 30 % (hypothèse fondée sur une élasticité
de l'assiette au taux de l'ordre de 1) ; variantes 0 %, 60 % et taux
irlandais de 12,5 %. Sous le moteur « offre », la baisse des prélèvements
relève en outre la croissance.

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

### O-13 — Conduite autonome et indemnisation des taxis

Autorisation de la conduite autonome (FSD). Les ≈ 60 000 titulaires d'une
licence de taxi sont indemnisés jusqu'à leur retraite : 25 000 €/an en
moyenne, soit 1,5 Md€/an au départ (montant gardé constant, par prudence,
alors qu'il décroît avec les départs). L'automatisation du transport de
personnes est traduite en +0,05 % de PIB et −20 000 emplois de chauffeurs
(levier `automatisation` ; variante large +0,15 %, −60 000). Hypothèses à
étayer : nombre de licences actives (préfectures), revenu moyen des
chauffeurs (Insee, Observatoire du T3P), part du transport de personnes
dans le PIB.

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
