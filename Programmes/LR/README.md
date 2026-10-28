# Les Républicains — plan Retailleau du 12 octobre 2026

> **Transcription partielle et non officielle** du plan de redressement
> présenté par Bruno Retailleau le 12 octobre 2026, d'après
> [Public Sénat](https://www.publicsenat.fr/actualites/economie/presidentielle-2027-bruno-retailleau-sengage-sur-un-plan-deconomies-de-pres-de-200-milliards-deuros-sil-est-elu),
> [Europe 1](https://www.europe1.fr/politique/presidentielle-2027-bruno-retailleau-promet-des-economies-de-pres-de-200-milliards-deuros-jusquen-2032-1141661)
> et l'AFP, consultés le 21 octobre 2026. Aucun document programme n'est
> cité par ces sources. Toute erreur se signale par une issue. Le parti
> peut demander la propriété de ce dossier.

Le plan annonce 197 Md€ d'économies « jusqu'en 2032 » (État 96, protection
sociale 91, collectivités 10), 51 à 56 Md€ d'allègements fiscaux (les deux
chiffres figurent dans la source), un excédent primaire en 2030, un
déficit sous 3 % du PIB en 2031 et de 2,2 % en fin de quinquennat.

## Modélisé (`Programme.lean`)

| Mesure | Levier |
|---|---|
| LR-01 400 000 agents non remplacés | −25 Md€ |
| LR-02 Opérateurs de l'État | −12,5 Md€ |
| LR-03 Base zéro, délégation au privé, formation pro aux régions | −22,5 Md€ |
| LR-04 Fin de soutiens (ENR, APD, culture, contrats aidés, SNU, MaPrimeRénov') | −23 Md€ |
| LR-05 Immigration | −10 Md€ (dont 4,5 sous condition constitutionnelle) |
| LR-06 Fraude fiscale et sociale | +5 Md€ de recettes |
| LR-07 Subventions aux associations | −3 Md€ |
| LR-08 Retraites (décote 63-65 ans et autres) | −42 Md€ forfaitaires, âge légal inchangé |
| LR-09 Chômage et prestations plafonnées à 70 % du SMIC | −30 Md€ |
| LR-10 Jour de carence d'ordre public | −4 Md€ |
| LR-11 Collectivités de plus de 10 M€ de budget | −10 Md€ |
| LR-12 Impôts de production | −15 Md€ d'autres impôts (voir ci-dessous) |
| LR-13 Heures supplémentaires et allègements des ménages | −21 Md€ de cotisations |

Les montants sont lus comme des économies annuelles en régime de
croisière (2032) et appliqués dès l'année 0. Les économies transcrites
totalisent 182 Md€ et 5 Md€ de recettes, pour 197 Md€ annoncés : la
différence n'est pas détaillée dans les sources.

## Ajouts et correction (octobre 2026)

| Mesure | Levier |
|---|---|
| LR-12 (corrigée) Impôts de production | −15 Md€ : les 30 Md€ pour les entreprises se répartissent entre impôts de production et cotisations patronales (comparateur IFRAP) |
| LR-14 Cotisations patronales | +15 Md€ d'allègements, au prorata des tranches |
| LR-15 Revenu familial dès le premier enfant ; congé de naissance de six mois | −1,4 Md€ nets (calcul : 40,3 Md€ financés par 41 Md€ d'aides et 0,7 Md€ de gestion) ; +0,7 Md€ |
| LR-16 Réduction d'impôt sur les intérêts d'emprunt des familles | −0,27 Md€ par génération de prêts, cumulés (hypothèse) |
| LR-17 Fin des 35 heures (1 623 heures au lieu de 1 607) | +1,0 % de durée du travail |

## Électricité et sols (octobre 2026)

| Mesure | Levier |
|---|---|
| LR-04 (complétée) Fin des soutiens aux nouvelles installations solaires et éoliennes | −2,9 GW/an de solaire et −1,6 GW/an d'éolien terrestre : les volumes des appels d'offres de la PPE3 (Maire-info, TaiyangNews, février 2026) ; parcs en mer déjà attribués maintenus |
| LR-18 Suppression du ZAN | consommation d'espaces ramenée au rythme 2011-2021 (22 672 ha/an) ; hors du plan du 12 octobre : PPL n° 3332 (13 octobre 2026), amendements Boucard et Wauquiez ; variante : assouplissement TRACE (Sénat), non chiffré |

Effets en 2035 (scénario central) : 44,3 GW de solaire et 26,7 GW
d'éolien terrestre au lieu de 67,5 et 37,5 GW ; la production reste de
69,3 GW moyens, le nucléaire modulant moins (1,1 GW au lieu de 6,4) ;
191 606 ha d'espaces naturels, agricoles et forestiers consommés de 2026
à 2035 au lieu de 51 150 sous le ZAN, et 12 210 ha d'emprise énergétique
au lieu de 33 370.

## Ajouts du 28 octobre 2026

| Mesure | Levier |
|---|---|
| LR-19 Suppression des doublons État-collectivités | −4 Md€/an (Acteurs publics, 12 octobre 2026) |
| LR-20 Fonds France Production | +0,6 Md€/an (livret « Travail gagnant ») |
| LR-21 Huit EPR2 supplémentaires | prêt de l'État à EDF de 2,0 Md€/an (hypothèse de financement du PCF, PC-08), sans production avant 2035 |

Déjà comprises dans les agrégats du plan : assurance chômage (13 Md€ du
livret) et revenu d'incitation à l'activité (2 Md€) dans LR-09, arrêts
maladie dans LR-10, immigration hors révision constitutionnelle dans LR-05,
délégation au privé dans LR-03, volet des retraites hors décote dans LR-08.
Non chiffrés : taux plein à 65 ans « quelles que soient les annuités »
(LCI, 22 octobre 2026), exonération des seniors avant l'âge légal,
transmission d'entreprises payée à la cession, défense, prisons.

## Non modélisé

* Mécanisme des 42 Md€ de retraites (âge, durée, décote) : non détaillé.
* Référendum sur la règle d'or (projet de loi de 2011) et révision
  constitutionnelle : hors modèle.
* Dépenses de santé (280 Md€) : aucun engagement chiffré dans la source.
