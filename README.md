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
   démographie × économie × pétrole × droit   déficit, dette, chômage, émissions…
           │  (produit cartésien)                     │
           ▼                                          ▼
   ┌───────────────┐    Modele/ (commun)    ┌───────────────────┐
   │  scénarios    │──► projection ◄── leviers ◄── Programmes/X │
   └───────────────┘         │                └───────────────────┘
                             ▼
     matrice  programme × moteur × scénario × propriété   (lake exe rapport)
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
   complète, rejeu des preuves compris, tient en un quart d'heure environ.

Un **moteur** (`Hypotheses/Moteurs.lean`) est un jeu de règles
d'interprétation des leviers : « demande » (effets de demande permanents
et symétriques) et « offre » (économies à demi-multiplicateur, effet des
prélèvements obligatoires sur la croissance). Le moteur fixe l'effet moyen
d'un prélèvement sur la demande ; l'axe économique le répartit selon l'impôt
(TVA, IR, CSG au-dessus de la moyenne ; IS, successions, patrimoine bien
en dessous). Les allègements de cotisations patronales passent par le coût
du travail, tranche de salaire par tranche de salaire. L'effet d'une
dépense dépend de sa nature (transferts moins, investissement plus que la
consommation publique). Le modèle calcule chaque année l'indice de
développement humain (formule du PNUD). Tous les programmes sont
évalués sous tous les moteurs ; un engagement précise le sien. Toute
personne autorisée peut **ajouter son moteur** dans `Moteurs/<Nom>/`
(même contrôle d'accès que les programmes : fichier `PROPRIETAIRES`),
l'enregistrer dans `Moteurs.lean`, et obtenir une **synthèse
personnalisée** centrée dessus (`scripts/synthese_pdf.py --moteur <Nom>
[--programmes A,B]`, ou le workflow « Synthèse PDF » avec ses paramètres ;
une PR qui touche `Moteurs/` produit l'artefact automatiquement). Une
propriété peut viser une année précise (« déficit sous 3 % en 2035 ») ou
l'horizon du scénario.

## Engagements, contrats et évaluation

| | Engagements | Contrats de mesure | Évaluation |
|---|---|---|---|
| Qui les définit | chaque programme (`engagements := …`) | chaque mesure (`contrats := …`) | le dépôt (`Proprietes.toutes` × `Hypotheses.tous`) |
| Nature | « sous tel scénario, telle propriété macro tient » | énoncé universel sur le dispositif : « pour toute commune… » | constat, sur toute la matrice |
| Vérification | calcul dans le noyau (`decide +kernel`) | preuve Lean, fournie avec le contrat | `lake exe rapport` |
| Si c'est faux | **la CI échoue** | **la CI échoue**, Lean désigne le contrat | la cellule passe à ❌ dans le rapport |

Exemple de contrats : la mesure R-07 d'`ExempleRelance` (amende SRU
automatique selon la part de logements sociaux manquants) prouve, pour
toute commune, que l'amende est nulle si l'objectif est atteint, plafonnée,
jamais augmentée par la construction d'un logement social, jamais
inférieure au prélèvement actuel et jamais supérieure au maximum qu'un
préfet peut infliger aujourd'hui. Le sous-modèle communal est dans
`Modele/Logement.lean`, le panel de communes (fictives) dans
`Hypotheses/Communes.lean`.

Un engagement peut porter sur **tous** les scénarios
(`tous.map fun H => ⟨H, propriété⟩`) : il est alors vérifié contre toute
hypothèse ajoutée plus tard par n'importe qui.

## Arborescence

| Chemin | Rôle |
|---|---|
| `Modele/` | état, unités, axes d'hypothèses, moteurs, leviers, projection, propriétés, programmes (types), sous-modèles SRU, automobile, attribution |
| `Hypotheses/` | valeurs des axes et produit cartésien `Hypotheses.tous`, panel de communes |
| `Proprietes/` | propriétés partagées, registre `Proprietes.toutes` |
| `Programmes/<Nom>/` | un dossier par programme : `Programme.lean` + `README.md` + `PROPRIETAIRES` |
| `Moteurs/<Nom>/`, `Moteurs.lean` | moteurs contribués (`Moteur.lean` + `PROPRIETAIRES`) et leur registre |
| `Programmes.lean` | registre `Programmes.tous` |
| `Engagements.lean` | preuve que tous les engagements sont tenus |
| `Rapport.lean` | exécutable `rapport` : JSON + Markdown, export `--synthese` |
| `Audit.lean` | refuse `sorry`, `native_decide` et tout `axiom` |
| `scripts/` | garde-fou syntaxique, diff de rapports, contrôle du registre, synthèse PDF, programme complet en PDF |
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

## Synthèse PDF

`scripts/synthese_pdf.py` met en page, sur dix ans et pour chaque
programme, les trajectoires calculées par le modèle commun : PIB, déficit
et dette publics, chômage, population active, emploi par secteur, impôts
et taxes majeurs (TVA, IR, CSG-CRDS, cotisations, IS, accise sur les
énergies, taxe foncière, autres), taux de prélèvements obligatoires,
sensibilité au prix du pétrole (50, 63, 100 $) et à la natalité (1,40,
1,56, 1,80 enfant par femme), propriétés et engagements, hypothèses et
sources.

```sh
lake env lean --run Rapport.lean --synthese out/synthese.json
pip install matplotlib reportlab
python3 scripts/synthese_pdf.py out/synthese.json out/synthese.pdf
```

`scripts/programme_pdf.py` produit le **programme complet** d'un seul
programme : chiffres clés et courbes (déficit, dette, chômage, IDH),
déficit sous chaque moteur, propriétés vérifiées, sections « Points à
arbitrer » et « Pistes pour compléter » du README s'il en a, chaque mesure
avec sa source, son chiffrage, ses variantes et son effet isolé (déficit,
chômage, emplois, IDH), puis le reste du README.

```sh
python3 scripts/programme_pdf.py out/synthese.json TexteOrientationD out/programme-TexteOrientationD.pdf
```

Le workflow `synthese.yml` régénère la synthèse et les programmes complets
à chaque fusion dans `main` (et à la demande, onglet Actions) et les publie
en artefact `synthese`. Les scripts ne calculent rien : tous les chiffres
sortent de `Rapport.lean`, donc du même code que la matrice d'évaluation.

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

* **Rules → Rulesets → New ruleset → Import a ruleset** :
  [`.github/rulesets/main.json`](.github/rulesets/main.json). Sur la
  branche par défaut : suppression et force-push interdits, PR obligatoire
  (0 approbation), branche à jour avant fusion, statuts « Vérifier et
  évaluer » et « Contrôle d'accès aux programmes » obligatoires et
  épinglés sur l'app GitHub Actions (id 15368), si bien qu'aucun autre
  émetteur de statut ne peut les satisfaire. Aucun contournement déclaré.
* **Actions → General** : *Allow orientationd, and select non-orientationd,
  actions* avec seulement *Allow actions created by GitHub* (le dépôt
  n'utilise que des actions `actions/*`) ; *Workflow permissions* : *Read
  repository contents and packages permissions*, et *Allow GitHub Actions
  to create and approve pull requests* décoché ; *Approval for running fork
  pull request workflows* : au minimum *Require approval for first-time
  contributors*.
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
