# La France insoumise — Mélenchon 2027 (extraits)

> **Transcription partielle et non officielle** du plan d'investissement
> productif « Automobile » de [melenchon2027.fr](https://melenchon2027.fr/programme/plans-investissement/automobile/),
> consulté le 21 octobre 2026. Elle doit reproduire fidèlement la source :
> toute erreur se signale par une issue. Le mouvement peut demander la
> propriété de ce dossier.

## Ce qui est modélisé

Le tableau « Les investissements supplémentaires » de la source, colonne
État, comme dépenses annuelles (`Programme.lean`, mesures L-01 à L-09) :
1,37 Md€/an au total. La source annonce « 1,4 milliard d'euros de dépenses
supplémentaires de l'État » et 4,5 Md€/an d'investissements tous acteurs
confondus. La colonne « pôle public bancaire et autres » (3,1 Md€/an) est
citée mais n'est pas imputée aux administrations publiques.

Chaque dépense est rattachée au secteur qui en reçoit les emplois
(industrie : L-01, L-03 à L-06 ; tertiaire marchand : L-02 location,
L-09 recherche). Ce classement est une interprétation détaillée dans
`Programme.lean`.

Deux mesures phares de *L'Avenir en commun* 2025 (melenchon2027.fr, pages
non lisibles automatiquement ; libellés repris de la présentation du site
et du chap. 8 § 8) :

| Mesure | Levier |
|---|---|
| L-10 Retraite à 60 ans après 40 annuités | −48 mois d'âge légal (coût selon l'hypothèse du scénario ; les 40 annuités ne sont pas modélisées) |
| L-11 SMIC à 1 600 € net | cible de 2 021 € bruts (ratio net/brut de 2026), ≈ +7,8 % sur le SMIC projeté de 2027 |

**Budget rectificatif 2027** (14 octobre 2026, [Public Sénat](https://www.publicsenat.fr/actualites/politique/presidentielle-2027-jean-luc-melenchon-table-sur-106-milliards-de-recettes-supplementaires-et-82-milliards-de-depenses-nouvelles-pour-2027),
[France Épargne](https://www.france-epargne.fr/news/melenchon-presente-un-contre-budget-2027-1064-milliards-de-recettes-25-milliards-pour-la-dette)) :
106,4 Md€ de recettes, 81,7 Md€ de dépenses, 25 Md€ de réduction du
déficit la première année. Postes détaillés par les sources :

| Mesure | Levier |
|---|---|
| L-12 ISF climatique | +10 Md€ |
| L-13 Suppression de la flat tax | +9 Md€ d'IR |
| L-14 Taxe Zucman | +15 Md€ |
| L-15 Droits de succession | +20 Md€ |
| L-16 Rabot des niches fiscales | +22 Md€ (moitié IS, moitié autres : hypothèse) |
| L-17 Rachats d'actions, transactions financières | +7,5 Md€ |
| L-18 Rémunération des agents publics | +17 Md€, tertiaire non marchand |
| L-19 Garantie d'autonomie (1 337 €/mois) | +9,5 Md€ |
| L-20 Action climatique | +10 Md€, construction |
| L-21 Indexation des pensions et prestations, APL +10 % | +8 Md€ |
| L-22 Cantines gratuites | +3,6 Md€ |
| L-23 Hôpital, 10 000 postes | +3 Md€ |
| L-24 Assurance chômage | +3 Md€ |
| L-25 10 000 enseignants | +0,5 Md€ (50 000 € par poste), emplois publics comptés un pour un |

Non détaillés par les sources : taxe sur les cryptoactifs, réforme de
l'IS, taxe à 15 % sur les géants du numérique (≈ 22,9 Md€ de recettes) et
≈ 18 Md€ de dépenses. Le budget rectificatif chiffre le retour à 62 ans
(9 Md€) ; le programme vise 60 ans et c'est cet objectif qui est modélisé.

Les mesures de *L'Avenir en commun* sans montant dans le budget
rectificatif sont ajoutées plus bas (L-34 à L-50) avec le chiffrage
retenu ; le plan de 200 Md€ passe par le pôle public bancaire, hors
administrations publiques.

Objectifs d'emplois annoncés (levier déclaratif `annonceEmplois`, vérifié
par la propriété « emplois annoncés réalisables ») : plus de 40 000 emplois
pour le plan automobile, 10 000 soignants, 10 000 enseignants.

## Ajouts : brochure budgétaire du 14 octobre 2026 (chiffres du parti)

| Mesure | Levier |
|---|---|
| L-26 Logement d'urgence et réquisitions | +3 Md€/an (logement) |
| L-27 Université : 250 000 places | +4,5 points de scolarisation de 18 à 24 ans : ≈ 3,4 Md€ calculés par le modèle (3,5 Md€ selon le parti), durée attendue de scolarisation de l'IDH |
| L-28 Violences sexistes et sexuelles, violences faites aux enfants | +2,6 et +2 Md€/an |
| L-29 Réindexation des budgets ministériels coupés en 2026 | +7 Md€/an, non ventilés |
| L-30 Superprofits, multinationales, CVAE, IS | +13 Md€ d'IS, +3 Md€ d'impôts de production |
| L-31 Taxe numérique de 3 % à 15 % | +3,9 Md€ |
| L-32 Fraude fiscale et crypto-actifs | +3 Md€ |
| L-33 Fin des exonérations au-delà de 2 SMIC | allègements de 2 à 2,5 SMIC et au-delà supprimés (≈ 4,2 Md€, calcul du modèle ; non chiffré par le parti) |

Recettes de la brochure désormais toutes transcrites (106,4 Md€) ; dépenses :
72,7 Md€ sur 81,7. Non transcrit : blocage du carburant à 1,70 €/l (non
chiffré ; la remise de 2022 avait coûté ≈ 8 Md€), impôt sur le revenu à
14 tranches. Recalibrages publiés depuis, non appliqués : SMIC à 1 700 €
net, retraite d'abord à 62 ans (9 Md€).

## Ajouts du 28 octobre 2026 : plans thématiques et *L'Avenir en commun* 2025

Le programme complet (5e édition de *L'Avenir en commun*) paraît le
6 novembre 2026. En attendant, les mesures viennent des plans publiés sur
melenchon2027.fr (colonne État seulement), du chiffrage du parti en 2022
pour les mesures reprises dans l'édition 2025, ou d'un chiffrage
indépendant ou d'un calcul sur données officielles (détail dans
`Programme.lean`).

| Mesure | Levier |
|---|---|
| L-34 200 000 logements publics par an | +3,1 Md€/an d'investissement (plan « BTP et logement », État ; ≈ 16 Md€ du pôle public non imputés) |
| L-35 Rénovation (700 000 isolations par an, bâtiments publics, fioul, patrimoine) | +8,3 Md€/an de logement-environnement et +0,6 Md€/an de patrimoine (même plan) ; recoupement possible avec L-20 |
| L-36 « 100 % Sécu » | +17,1 Md€/an (Institut Montaigne, 2022 ; le parti la dit compensée) |
| L-37 Conscription citoyenne de neuf mois au SMIC | +7,4 Md€/an (parti, 2022) ; variante 18,5 Md€ (Institut Montaigne) |
| L-38 210 000 professionnels du grand âge | jusqu'à +8,0 Md€/an en cinq ans (37 931 € par ETP, Institut Montaigne) |
| L-39 10 000 places par an en Ehpad publics | 1,08 Md€/an de construction pendant cinq ans, puis 0,84 Md€/an de soins et d'APA |
| L-40 AAH au niveau du SMIC | +7,0 Md€/an (DREES, calcul) |
| L-41 Minimum vieillesse au seuil de pauvreté | +1,2 Md€/an (DREES, Insee, calcul) |
| L-42 500 000 places en crèche | 3,5 Md€/an d'investissement pendant cinq ans, fonctionnement jusqu'à 9,5 Md€/an (parti, 2022) |
| L-43 Gratuité réelle de l'école | +4,3 Md€/an (parti, 2022, hors cantines) |
| L-44 40 000 personnels de l'ESR en cinq ans | jusqu'à +2,8 Md€/an (coût moyen d'un enseignant, hypothèse), emplois publics comptés un pour un |
| L-45 Gratuité du supérieur | +0,38 Md€/an (Institut Montaigne) |
| L-46 Police de proximité, BAC démantelées | +0,35 Md€/an (parti, 2022) |
| L-47 IR à 14 tranches | −5 Md€/an d'IR (parti, 2022) |
| L-48 Cotisation vieillesse +0,25 point par an | jusqu'à +14,5 Md€/an en 2031 (calcul sur les salaires bruts) |
| L-49 Sixième semaine de congés payés | −2,2 % de durée du travail |
| L-50 Aide au développement à 0,7 % du RNB | jusqu'à +8,6 Md€/an en cinq ans (0,42 % en 2025) |

Non chiffrés, faute de montant ou de donnée de base : R&D publique à 1,5 %
du PIB, culture à 1 % du PIB (périmètre non défini), garantie d'emploi,
8 000 contrats doctoraux de plus par an, 32 heures dans les métiers
pénibles, blocage des prix, pôle public bancaire (hors administrations
publiques).

## Ce qui ne l'est pas, faute de montant dans la source

* Sanctions des flottes d'entreprises : seuil d'achat électrique porté à
  90 % en 2030, amende de 10 000 € par véhicule plafonnée à 10 % du chiffre
  d'affaires, pour les 3 500 plus grandes entreprises.
* Fin des incitations fiscales pour les véhicules de fonction thermiques.
* Protection du marché et critères de production française ; éco-score
  fondé sur le cycle de vie ; au moins 85 % de contenu européen pour les
  véhicules aidés.
* Moratoire sur les fermetures de site ; conventions pluriannuelles avec
  remboursement en cas de non-respect.
* Prix national de l'électricité ; réforme de la catégorie européenne M1E ;
  limitation de la taille et du poids des SUV.

## Objectifs déclarés (non vérifiés par le modèle)

20 millions de voitures électriques en circulation en 2040 ; 2 millions de
véhicules électriques produits en France par an ; une électrique légère
fabriquée en France à partir de 10 000 € ; parc public de 1,4 million de
véhicules loués d'ici 2032 ; au moins 100 GWh de capacité de batteries ;
plus de 40 000 emplois (estimation s'appuyant sur France Nature
Environnement, selon la source).

Ces objectifs ne correspondent à aucune propriété partagée du dépôt. Les
vérifier demanderait des indicateurs de production et de parc automobile
dans le modèle commun : issue « Faire évoluer le modèle commun ».
