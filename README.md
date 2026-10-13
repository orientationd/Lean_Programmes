# Programmes vérifiés

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
   décide par `decide +kernel` : pas de Mathlib, pas de flottants, build en
   quelques secondes.

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
| `scripts/` | diff de rapports, contrôle du registre |
| `.github/` | CI, commentaire de PR, CODEOWNERS, modèles d'issue et de PR |

## En local

```sh
# elan installe automatiquement la version de Lean fixée dans lean-toolchain
curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh

lake build                       # tout compiler, engagements compris
lake env lean Audit.lean         # audit des axiomes
lake exe rapport                 # écrit rapport.json et rapport.md
python3 scripts/verifier_registre.py
```

## CI

`ci.yml`, sur chaque push et chaque PR (forks compris, jeton en lecture
seule) :

1. contrôle du registre (dossiers, imports, CODEOWNERS) ;
2. compilation du socle et des programmes ;
3. matrice d'évaluation sur la PR **et** sur la branche de base, puis diff ;
4. preuve des engagements ;
5. audit des axiomes ;
6. résumé dans le job, artefact `rapport-pr`.

`commentaire-pr.yml` (déclenché par `workflow_run`) publie ce résumé en
commentaire de la PR. Il dispose des droits d'écriture, donc il n'exécute
jamais le code de la PR et revérifie que le numéro de PR lu dans l'artefact
correspond bien au commit du run.

## Gouvernance des contributions externes

À configurer dans les réglages GitHub du dépôt :

* **Branch protection** sur `main` : PR obligatoire, statut
  « Vérifier et évaluer » requis, *Require review from Code Owners*,
  *Dismiss stale approvals*.
* **Actions → Fork pull request workflows** : exiger une approbation pour
  les contributeurs externes.
* **CODEOWNERS** : remplacer `@VOTRE-ORG/...` et les comptes d'exemple.

Le socle commun (`Modele/`, `Hypotheses/`, `Proprietes/`) est relu par
l'équipe `socle` ; chaque dossier de programme par ses propres mainteneurs.
Voir [CONTRIBUTING.md](CONTRIBUTING.md).

## Limites

* Une preuve ne dit jamais qu'un programme est bon, seulement qu'il est
  cohérent **sous des hypothèses explicites**. L'intérêt est de déplacer le
  débat vers ces hypothèses, versionnées et contestables par PR.
* Le modèle jouet doit être remplacé. Piste naturelle : une microsimulation
  (OpenFisca) lancée en CI qui émet des agrégats, que Lean vérifie contre les
  propriétés ; et Catala pour la sémantique juridique fine.

## Licence

À définir (code et données peuvent relever de licences différentes).
