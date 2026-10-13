# Contribuer

Toute contribution passe par une PR, depuis un fork ou une branche. Une PR
= un seul type de changement : cela rend le commentaire d'impact lisible et
la revue attribuable aux bonnes personnes.

## Quatre types de contribution

### 1. Ajouter ou modifier un programme

Périmètre : `Programmes/<Nom>/` (+ une ligne dans `Programmes.lean` et
`.github/CODEOWNERS` pour un nouveau programme).

1. Copier `Programmes/ExempleRelance/` vers `Programmes/<Nom>/`
   (CamelCase, ASCII).
2. Dans `Programme.lean` : remplacer le namespace et `id := "<Nom>"`,
   renseigner les mesures. Chaque mesure cite sa source (`source := "p. 12"`).
3. Déclarer les engagements que le programme revendique, s'il en revendique.
4. Enregistrer le programme dans `Programmes.lean` (import + `tous`) et ses
   mainteneurs dans `.github/CODEOWNERS`.

Une mesure ne s'exprime qu'avec les leviers de `Modele/Leviers.lean`. Si
aucun ne convient, ouvrir une issue « Faire évoluer le modèle commun »
plutôt que de forcer un levier inadapté.

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
