# Contribuer

Toute contribution passe par une PR, depuis un fork ou une branche. Une PR
= un seul type de changement : cela rend le commentaire d'impact lisible et
la revue attribuable aux bonnes personnes.

## Quatre types de contribution

### 1. Créer ou modifier son programme

Périmètre : `Programmes/<Nom>/` (+ deux lignes dans `Programmes.lean` pour
un nouveau programme).

**Un programme n'est modifiable que par ses propriétaires**, listés dans
`Programmes/<Nom>/PROPRIETAIRES`. La CI refuse toute autre PR qui touche
le dossier (voir README, « Propriété des programmes »).

1. Copier `Programmes/ExempleRelance/` vers `Programmes/<Nom>/`. `<Nom>` est
   un identifiant Lean ASCII : lettres, chiffres et `_`, commençant par une
   lettre (ex. `TexteOrientationD`).
2. Mettre son compte GitHub dans `Programmes/<Nom>/PROPRIETAIRES`, un compte
   par ligne. La PR doit être ouverte depuis l'un de ces comptes.
3. Dans `Programme.lean` : remplacer le namespace et `id := "<Nom>"`,
   renseigner les mesures. Chaque mesure cite sa source (`source := "p. 12"`).
4. Déclarer les engagements que le programme revendique, s'il en revendique,
   et les **contrats** de chaque mesure : propriétés du dispositif prouvées
   pour tous les cas (voir la mesure R-07 d'`ExempleRelance`). Un contrat
   porte sa preuve ; les théorèmes génériques du modèle commun
   (`Modele/Logement.lean` pour le SRU) font l'essentiel du travail.
5. Enregistrer le programme dans `Programmes.lean` (import + `tous`).

Ajouter un co-propriétaire : un propriétaire actuel ajoute son compte dans
`PROPRIETAIRES`. Proposer une modification au programme de quelqu'un
d'autre : ouvrir une issue, ou soumettre la modification à l'un de ses
propriétaires, qui la reprend dans sa propre PR.

Une mesure ne s'exprime qu'avec les leviers de `Modele/Leviers.lean`. Si
aucun ne convient, ouvrir une issue « Faire évoluer le modèle commun »
plutôt que de forcer un levier inadapté.

Quand la source précise l'impôt visé ou le secteur aidé, préférer
`prelevementSur` (par exemple `.prelevementSur .impotSocietes 15000`) à
`prelevement`, et `depenseSecteur` (par exemple
`.depenseSecteur .industrie 500`) à `depense` : la synthèse PDF attribue
alors recettes et emplois au bon poste au lieu de « autres impôts » ou
d'une répartition au prorata. Un financement par prêt ou prise de
participation de l'État (EDF, nationalisation) est un `pretEtat` : il
pèse sur la dette, pas sur le déficit. Une mesure qui n'entre en vigueur
qu'après l'année de départ porte `debut := n` (années) : montée en charge
ou décaissements différés. Les mesures automobiles ont leurs leviers :
`aideAchatElectrique véhiculesParAn primeEuros` (parc électrique, décès
évités) et `deploiementBornes bornesParAn coûtParBorne`.

Préférer `depenseSur fonction montant` et `economieSur fonction montant`
(nomenclature COFOG agrégée : retraites, santé, famille, enseignement,
affaires économiques, défense, sécurité-justice, logement-environnement,
culture, fonctionnement) à `depense` / `economie`, qui vont dans « non
ventilé » : la synthèse décompose le déficit par fonction. `investissement fonction montant` : dépense d'équipement imputée à une
fonction, emplois dans la construction. Durée du
travail : `dureeTravail variationPm` (le PIB suit le volume d'heures).
Taux de l'IS : `impotSocietes tauxPb retourAssiettePm`, avec un
coefficient de retour d'assiette explicite.

Accidents du travail : `preventionAccidents fondsMeur baissePm` (fonds
publics et baisse du taux d'accidents ; le sous-modèle calcule coûts
évités, journées rendues et décès). Textes européens : les propriétés
`ue-*` (`Proprietes/Europe.lean`) traduisent les règles listées dans
`Hypotheses/Europe.lean` ; en ajouter une = un texte cité + un critère.

Objectifs d'emplois et immigration : `annonceEmplois n` enregistre un
objectif déclaré (sans effet sur le modèle ; la propriété « emplois
annoncés réalisables » vérifie qu'il tient dans la population active),
`migration deltaMilliersParAn` modifie le solde migratoire.

Tous les programmes sont évalués sous tous les **moteurs**
(`Hypotheses/Moteurs.lean` : « demande » et « offre ») ; un engagement
précise son moteur (`Engagement.sous Moteurs.standard H q`). Une propriété
peut viser une année précise (`annee := some 10` : 2035) plutôt que
l'horizon du scénario.

### 2. Proposer une hypothèse

Périmètre : `Hypotheses/`. Ajouter une valeur sur un axe et l'ajouter à la
liste `toutes` de l'axe. Toute valeur numérique est sourcée dans `sources`.

La PR fait apparaître de nouveaux scénarios pour **tous** les programmes.
Si elle casse un engagement « pour tout scénario » d'un programme, la CI
échoue : c'est voulu. La discussion porte alors sur l'hypothèse (est-elle
plausible ?) ou sur l'engagement (était-il trop large ?).

### 3. Proposer une propriété

Périmètre : `Proprietes/`. Une propriété est un `Prop` décidable sur
`(scénario, tendanciel, état avec programme)`. Elle doit être neutre :
formulée sans référence à un programme particulier.

### 4. Faire évoluer le modèle commun

Périmètre : `Modele/`. **Issue préalable obligatoire.** Le modèle s'applique
à tous les programmes ; ses évolutions sont relues par l'équipe `socle`.

## Ce que la CI vérifie

`scripts/ci_locale.sh` rejoue les mêmes étapes en local, dans le même ordre.

| Vérification | Échoue si… |
|---|---|
| Garde-fou (avant compilation) | construction interdite dans un fichier Lean (voir ci-dessous), configuration de build modifiée hors des clés autorisées |
| Registre | un dossier de programme n'est pas enregistré ou n'a pas de mainteneur |
| Compilation | le code Lean ne compile pas |
| Matrice | identifiant dupliqué ou scénario hors bornes de plausibilité |
| Engagements | un engagement revendiqué est faux |
| Rejeu (leanchecker) | une preuve est acceptée par l'élaborateur mais rejetée par le noyau |
| Audit | `sorry`, `native_decide` ou `axiom` dans le dépôt |

Le bot commente la PR avec l'impact : engagements cassés, résultats sous
les nouveaux scénarios, cellules de la matrice qui changent, indicateurs
modifiés. Si la PR touche l'outillage (`.github/`, `scripts/`,
`Rapport.lean`, `Audit.lean`, configuration de build), le commentaire
l'indique en tête : son verdict ne vaut qu'après relecture.

## Règles

* Hors outillage (`Rapport.lean`, `Audit.lean`), le Lean du dépôt est du
  Lean « pur » : pas de commande `#…`, `run_cmd`, `elab`, `macro`,
  `syntax`, `initialize`, `set_option`, `attribute`, `unsafe`,
  `implemented_by`, `opaque`, `native_decide`, `sorry`, `axiom`, et seuls
  les modules du dépôt s'importent. Un programme n'en a jamais besoin ;
  c'est ce qui rend le verdict de la CI fiable sur une PR externe.
  `python3 -I scripts/garde_fou.py` le vérifie en local.
* Les hypothèses sont des **données** (`def`), jamais des `axiom`.
* Pas de valeur numérique sans source.
* Un engagement cassé ne se supprime pas en silence : la PR qui le retire
  explique pourquoi.
* Les exemples fournis sont fictifs ; un programme réel reproduit fidèlement
  son document source, sans interprétation favorable ni défavorable.

## Licence des contributions

Le dépôt est sous [CC0 1.0](LICENSE). En ouvrant une PR, vous acceptez que
votre contribution soit publiée sous la même licence (règle « inbound =
outbound » des conditions d'utilisation de GitHub). Ne proposez que du
contenu que vous avez le droit de verser au domaine public. CC0 n'oblige pas
à citer ses sources ; ce dépôt l'exige quand même pour toute valeur
numérique.

Débats, revues et issues suivent les [règles de conduite](CODE_OF_CONDUCT.md).
