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

Taux hongrois de 9 % (variante : taux irlandais de 12,5 %). Rendement
statique −37,7 Md€/an sur 58,9 Md€ d'IS 2025 ; le modèle applique sa
fuite fiscale (retour d'assiette) et, sous le moteur « offre », un
surcroît de croissance lié à la baisse des prélèvements. L'effet
d'attractivité (relocalisation de bases fiscales) n'est pas modélisé
au-delà de cela.

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
