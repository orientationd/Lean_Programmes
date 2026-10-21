# Programmes vérifiés

[![CI](https://github.com/orientationd/Lean_Programmes/actions/workflows/ci.yml/badge.svg)](https://github.com/orientationd/Lean_Programmes/actions/workflows/ci.yml)

Des programmes politiques formalisés en Lean 4, évalués sous un jeu
d'hypothèses partagées, avec une CI qui vérifie à chaque PR :

* que chaque programme tient les **engagements** qu'il revendique (preuves
  vérifiées par le noyau Lean) ;
* ce que devient **chaque propriété partagée**, pour **chaque programme**,
  sous **chaque scénario** (matrice d'évaluation, diff commenté sur la PR).

> ⚠️ **État actuel : squelette.** Le modèle économique est un modèle jouet,
> les données de départ sont des ordres de grandeur non sourcés et les deux
> programmes sont fictifs. L'architecture est en place ; le contenu est à
> construire.

## Principe

```
                 Hypotheses/                     Proprietes/
   démographie × économie × droit         déficit, dette, chômage, émissions…
           │  (produit cartésien)                     │
           ▼                                          ▼
   ┌───────────────┐    Modele/ (commun)    ┌───────────────────┐
   │  scénarios    │──► projection ◄── leviers ◄── Programmes/X │
   └───────────────┘         │                └───────────────────┘
                             ▼
     matrice  programme × scénario × propriété   (lake exe rapport)
     engagements prouvés                          (Engagements.lean)
```

Trois choix structurants :

1. **Les programmes sont de la donnée.** Une mesure est une liste de
   `Levier` (dépense, prélèvement, revalorisation du SMIC, âge légal…) avec
   des montants. Leur effet est calculé par le modèle commun, sous les
   hypothèses du scénario. Un programme ne peut donc pas apporter ses propres
   élasticités : tous sont évalués avec les mêmes règles.
2. **Les hypothèses sont des axes croisés.** Ajouter une valeur sur un axe
   (une nouvelle projection démographique, un nouveau cadre juridique) ajoute
   automatiquement les scénarios correspondants pour tous les programmes.
3. **Tout est entier et décidable.** Montants en M€, taux en points de base,
   coefficients en pour mille (`Modele/Unites.lean`). Chaque propriété se
   décide par `decide +kernel` : pas de Mathlib, pas de flottants. La CI
   complète, rejeu des preuves compris, tient en deux minutes environ.

## Engagements et évaluation

| | Engagements | Évaluation |
|---|---|---|
| Qui les définit | chaque programme (`engagements := …`) | le dépôt (`Proprietes.toutes` × `Hypotheses.tous`) |
| Nature | revendication : « sous tel scénario, telle propriété tient » | constat, sur toute la matrice |
| Vérification | théorème `Engagements.tous_tenus`, noyau Lean | `lake exe rapport` |
| Si c'est faux | **la CI échoue** | la cellule passe à ❌ dans le rapport |

Un engagement peut porter sur **tous** les scénarios
(`tous.map fun H => ⟨H, propriété⟩`) : il est alors vérifié contre toute
hypothèse ajoutée plus tard par n'importe qui.

## Arborescence

| Chemin | Rôle |
|---|---|
| `Modele/` | état, unités, axes d'hypothèses, leviers, projection, propriétés, programmes (types) |
| `Hypotheses/` | valeurs des axes et produit cartésien `Hypotheses.tous` |
| `Proprietes/` | propriétés partagées, registre `Proprietes.toutes` |
| `Programmes/<Nom>/` | un dossier par programme : `Programme.lean` + `README.md` |
| `Programmes.lean` | registre `Programmes.tous` |
| `Engagements.lean` | preuve que tous les engagements sont tenus |
| `Rapport.lean` | exécutable `rapport` : JSON + Markdown |
| `Audit.lean` | refuse `sorry`, `native_decide` et tout `axiom` |
| `scripts/` | garde-fou syntaxique, diff de rapports, contrôle du registre |
| `.github/` | CI, commentaire de PR, CODEOWNERS, modèles d'issue et de PR |

## En local

```sh
# elan installe automatiquement la version de Lean fixée dans lean-toolchain
curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh

scripts/ci_locale.sh                     # toutes les étapes ci-dessous, dans l'ordre de la CI

python3 -I scripts/garde_fou.py          # avant de compiler du code non relu
python3 -I scripts/verifier_registre.py
lake build                               # tout compiler, engagements compris
lake env lean Audit.lean                 # audit des axiomes
lake env lean --run Rapport.lean         # écrit rapport.json et rapport.md
                                         # (ou `lake exe rapport`, compilé, même sortie)
```

## CI

`ci.yml`, sur chaque push et chaque PR (forks compris, jeton en lecture
seule) :

1. **garde-fou syntaxique**, bloquant, avant toute compilation ;
2. contrôle du registre (dossiers, imports, CODEOWNERS) ;
3. matrice d'évaluation sur la branche de base, **puis** sur la PR, et diff ;
4. preuve des engagements ;
5. rejeu indépendant des preuves par `leanchecker` ;
6. audit des axiomes ;
7. résumé dans le job, artefact `rapport-pr`.

`commentaire-pr.yml` (déclenché par `workflow_run`) publie ce résumé en
commentaire de la PR. Il dispose des droits d'écriture, donc il n'exécute
jamais le code de la PR et revérifie que le numéro de PR lu dans l'artefact
correspond bien au commit du run.

## Modèle de confiance

Une PR externe fait exécuter son code par la CI : `lake build` élabore les
fichiers Lean de la PR, et l'élaboration peut exécuter du code (`#eval`,
`run_cmd`, `elab`…). Sans précaution, une PR pourrait remplacer le binaire
`lean`, désactiver le noyau (`set_option debug.skipKernelTC true`) ou
réécrire le rapport, et afficher des engagements verts alors qu'ils sont
faux. Les défenses, dans l'ordre :

| Défense | Contre |
|---|---|
| `scripts/garde_fou.py` **de la branche de base**, avant toute compilation | `#eval`, `run_cmd`, `elab`, `macro`, `initialize`, `set_option`, `import Lean`, `unsafe`, `implemented_by`, `native_decide`, `sorry`, `axiom` ; `lakefile.lean`, options Lean et dépendances dans la configuration, toolchain non officielle |
| Scripts Python pris sur la base | une PR qui modifie l'outil qui la juge |
| Base évaluée avant la PR | une PR qui altère le rapport de référence |
| `leanchecker` sur tous les modules compilés du dépôt | une preuve acceptée par l'élaborateur mais pas par le noyau (testé : une « preuve » de `1 = 2` injectée en contournant le noyau passe `lake build` et l'audit des axiomes, `leanchecker` la rejette). La bibliothèque standard n'est pas rejouée (`--fresh`, ~80 s de plus) : elle vient de la toolchain officielle imposée par le garde-fou, et une toolchain compromise compromettrait `leanchecker` lui-même |
| `Audit.lean` | `sorryAx`, `Lean.ofReduceBool`, tout axiome hors `propext`, `Classical.choice`, `Quot.sound` |
| En-tête du commentaire calculé via l'API | un artefact falsifié qui afficherait « ✅ » |
| Contrôle d'accès en `pull_request_target` | la modification d'un programme par un autre que ses propriétaires (voir « Propriété des programmes ») |

**Limite irréductible.** Sur l'événement `pull_request`, GitHub exécute le
workflow *de la PR*. Une PR qui modifie l'outillage (`.github/`,
`scripts/`, `Rapport.lean`, `Audit.lean`, configuration de build) peut donc
neutraliser toute vérification. Le commentaire de PR le signale en tête
(calcul fait côté privilégié, à partir de la liste des fichiers donnée par
l'API) : le verdict d'une telle PR ne vaut qu'après relecture. Les PR qui ne
touchent que `Programmes/`, `Hypotheses/` ou `Proprietes/`, le cas normal
d'une contribution externe, ont un verdict fiable sans relecture du code.

## Gouvernance des contributions externes

Publication : créer un dépôt **vide** sur GitHub, puis
`scripts/publier.sh COMPTE [DEPOT]` remplace les comptes d'exemple de
CODEOWNERS par le vôtre et pousse toutes les branches. Ensuite, dans les
réglages du dépôt :

* **Rules → Rulesets → New branch ruleset**, cible : branche par défaut.
  *Restrict deletions*, *Block force pushes*, *Require a pull request
  before merging* (0 approbation requise), *Require status checks to pass*
  avec « Vérifier et évaluer » et « Contrôle d'accès aux programmes »
  (chaque statut n'est proposé qu'après son premier run).
* **Actions → General** : *Allow actions created by GitHub* (le dépôt
  n'utilise que des actions `actions/*`) ; *Workflow permissions* en
  lecture seule ; *Approval for running fork pull request workflows* au
  minimum pour les nouveaux contributeurs.
* **Security** : activer *Private vulnerability reporting*
  ([SECURITY.md](SECURITY.md)).
* **Équipes** : sur un compte personnel, CODEOWNERS ne vise que des
  comptes. Pour une équipe `socle`, créer une organisation et y transférer
  le dépôt.

### Propriété des programmes

Chaque dossier `Programmes/<X>/` appartient aux comptes listés dans
`Programmes/<X>/PROPRIETAIRES`. Le workflow « Accès aux programmes »
refuse toute PR qui ajoute, modifie, renomme ou supprime un fichier d'un
programme sans que son auteur en soit propriétaire :

* programme existant : propriétaires lus sur la branche de base, donc
  personne ne peut s'ajouter soi-même ;
* nouveau programme : son `PROPRIETAIRES` doit nommer l'auteur de la PR.

Les propriétaires n'ont pas besoin d'être collaborateurs du dépôt : ils
contribuent depuis un fork. Le workflow tourne en `pull_request_target`
(version de la branche de base, impossible à modifier par la PR) et ne lit
que des données de la PR via l'API, sans jamais exécuter son code.

Limite : un administrateur du dépôt peut toujours contourner un ruleset.
La garantie pour les autres est la transparence : le contrôle reste rouge
sur la PR et l'historique public le montre.

Le socle commun (`Modele/`, `Hypotheses/`, `Proprietes/`) et l'outillage
sont relus par les mainteneurs du socle ; chaque dossier de programme par
ses propres mainteneurs. Voir [CONTRIBUTING.md](CONTRIBUTING.md) et les
[règles de conduite](CODE_OF_CONDUCT.md).

## Limites

* Une preuve ne dit jamais qu'un programme est bon, seulement qu'il est
  cohérent **sous des hypothèses explicites**. L'intérêt est de déplacer le
  débat vers ces hypothèses, versionnées et contestables par PR.
* Le modèle jouet doit être remplacé. Piste naturelle : une microsimulation
  (OpenFisca) lancée en CI qui émet des agrégats, que Lean vérifie contre les
  propriétés ; et Catala pour la sémantique juridique fine.

## Licence

[CC0 1.0 Universel](LICENSE) : le dépôt est versé au domaine public. Code,
modèle, hypothèses et documentation peuvent être réutilisés, modifiés et
redistribués sans condition, y compris commercialement, sans obligation de
citer. En droit français, le droit moral de l'auteur est inaliénable : CC0
y renonce dans la mesure permise et prévoit une licence de repli tout aussi
large. Les sources citées dans les hypothèses (INSEE, COR…) gardent leur
propre licence.
