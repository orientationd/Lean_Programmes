# Programmes vérifiés

[![CI](https://github.com/orientationd/Lean_Programmes/actions/workflows/ci.yml/badge.svg)](https://github.com/orientationd/Lean_Programmes/actions/workflows/ci.yml)

Des programmes politiques formalisés en Lean 4, évalués sous un jeu
d'hypothèses partagées, avec une CI qui vérifie à chaque PR :

* que chaque programme tient les **engagements** qu'il revendique (preuves
  vérifiées par le noyau Lean) ;
* ce que devient **chaque propriété partagée**, pour **chaque programme**,
  sous **chaque scénario** (matrice d'évaluation, diff commenté sur la PR).

> ⚠️ **État actuel.** Le modèle économique est un modèle agrégé, en
> entiers : chaque paramètre cite sa source ou est marqué « hypothèse », et
> le rétro-test le confronte aux comptes de 2018 à 2025. Quinze programmes y
> sont transcrits, dont deux exemples fictifs. Ce n'est pas une
> microsimulation : les barèmes et les ménages types n'y figurent pas.

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
   complète, rejeu des preuves et tests compris, tient en un quart d'heure environ.

Un **moteur** (`Hypotheses/Moteurs.lean`) est un jeu de règles
d'interprétation des leviers : « demande » (effets de demande permanents
et symétriques) et « offre » (économies à demi-multiplicateur, effet des
prélèvements obligatoires sur la croissance, canal du capital). Le canal du
capital relie le PIB potentiel à l'investissement public des mesures (stock
de capital public déprécié de 5 % par an, élasticité de la production de
0,12 : un point de PIB d'investissement durable ajoute ≈ 1,5 % de PIB en dix
ans) et au taux d'IS (coût du capital des entreprises : +0,10 % de PIB à long
terme par point de taux en moins, atteint à 61 % en dix ans) ; il joue
entièrement au moteur d'offre, pour moitié au moteur « Exemple équilibre »,
pas au moteur de demande. Le moteur fixe l'effet moyen
d'un prélèvement sur la demande ; l'axe économique le répartit selon l'impôt
(TVA, IR, CSG au-dessus de la moyenne ; IS, successions, patrimoine bien
en dessous). Les allègements de cotisations patronales passent par le coût
du travail, tranche de salaire par tranche de salaire. Le SMIC est indexé
sur les prix ; une hausse au-delà renchérit le travail à son voisinage
(13 800 emplois de moins à terme par point, OFCE), accroît les allègements
(≈ 1,5 Md€ par point avec la réduction générale actuelle), la rémunération
des agents publics et les prélèvements sur les salaires du privé, et
soutient la consommation. L'effet d'une
dépense dépend de sa nature (transferts moins, investissement plus que la
consommation publique). Les postes publics créés ou supprimés, quand un
programme les chiffre en postes (leviers `creationPostes` et
`suppressionPostes`), comptent un pour un dans l'emploi ; l'emploi privé ne
répond qu'à l'écart entre la variation du PIB et la production publique
ajoutée ou retirée. Le modèle calcule chaque année l'indice de
développement humain (formule du PNUD).

Le déficit se calcule année par année : la croissance suit les prévisions
publiées puis la croissance potentielle ; chaque prélèvement suit son
assiette naturelle (masse salariale pour les cotisations, la CSG et l'IR,
dont le barème est revalorisé de l'inflation passée ; consommation des
ménages pour la TVA ; bénéfice fiscal et règles d'acomptes pour l'IS ;
volume de carburants pour les accises, fixées en euros par litre ; valeurs
locatives revalorisées par la loi pour la taxe foncière ; valeur des
transactions immobilières pour les droits de mutation) ; les dépenses primaires
suivent les prix (pensions et prestations revalorisées sur l'inflation de
l'année écoulée) et une tendance en volume par fonction (COR, mission
d'experts de juillet 2026) ; l'indemnisation du chômage suit, dans
l'année, les chômeurs ; la charge d'intérêts suit la structure de la dette
(titres à court terme renouvelés au taux court, refinancement de la dette à
moyen et long terme et dette nouvelle au taux de l'OAT, indexation des
titres indexés sur l'inflation), et la synthèse la répartit entre ses
bénéficiaires (Banque de France, non-résidents, banques, assurances, fonds,
autres résidents : `Hypotheses/DetentionDette.lean`, affichage seulement) ;
la dette de fin d'année est celle de
début d'année plus le déficit de l'année, mesures comprises. Tous les programmes sont
évalués sous tous les moteurs ; un engagement précise le sien. Toute
personne autorisée peut **ajouter son moteur** dans `Moteurs/<Nom>/`
(même contrôle d'accès que les programmes : fichier `PROPRIETAIRES`),
l'enregistrer dans `Moteurs.lean`, et obtenir une **synthèse
personnalisée** centrée dessus (`scripts/synthese_pdf.py --moteur <Nom>
[--programmes A,B]`, ou le workflow « Synthèse PDF » avec ses paramètres ;
une PR qui touche `Moteurs/` produit l'artefact automatiquement). Une
propriété peut viser une année précise (« déficit sous 3 % en 2035 ») ou
l'horizon du scénario.

**Électricité et sols.** Les capacités de chaque filière croissent des
installations de la programmation pluriannuelle de l'énergie (PPE3, décret
du 12 février 2026) et de celles des mesures ; la production en découle aux
facteurs de charge observés par RTE, sur la capacité moyenne de l'année ;
la consommation suit la trajectoire « décarbonation lente » du bilan
prévisionnel 2025 de RTE, plus les voitures électriques du parc. La
production que ni la consommation ni le solde exportateur maximal
(≈ 100 TWh, RTE) n'absorbent est retirée au nucléaire (modulation). La
consommation d'espaces naturels, agricoles et forestiers (ENAF) suit
l'enveloppe du zéro artificialisation nette (ZAN : la moitié de 2011-2021
sur 2021-2031, données du Cerema) : ce qu'il en reste fin 2025 permet
5 117 ha par an, contre 15 119 ha consommés en 2024 ; un programme qui
abroge le ZAN revient au rythme de 2011-2021 (22 672 ha par an). Sous le
ZAN, les surfaces des mesures (lignes nouvelles, prisons) s'imputent sur
l'enveloppe et évincent les autres usages ; sans ZAN, elles s'ajoutent.
Une mesure peut aussi exempter des surfaces de l'enveloppe (zones
industrielles) : elles s'ajoutent alors sans éviction et sortent du
décompte. L'emprise des installations nouvelles de solaire au sol et
d'éolien terrestre est comptée à part (`Hypotheses/Electricite.lean`,
`Hypotheses/Sols.lean`). Les pompes à chaleur des mesures remplacent des
chaudières au fioul ou au gaz (chaleur, rendement et coefficient de
performance mesuré par l'ADEME) : fioul et gaz économisés, électricité
consommée, coûts de réseau de gaz évités (`Hypotheses/Energie.lean`).

**Émissions et aides à l'électrique.** Les émissions de chaque secteur
baissent à leur rythme tendanciel (scénario « avec mesures existantes » du
ministère), corrigé de deux lois économiques : l'activité (élasticité au
PIB en volume de 0,8 pour l'industrie, 0,6 pour les transports, 0,1 à 0,5
ailleurs, appliquée à l'écart de croissance au scénario central) et le prix
du pétrole (un Brent cher fait baisser les émissions des voitures et du
fioul selon les élasticités-prix de long terme, atteintes à 40 % par an).
Les propriétés climatiques peuvent donc tenir dans une partie seulement des
36 scénarios. Une aide à l'achat d'une voiture électrique de `A` k€ ne rend
électriques que `1 − e^(−β A)` des achats qui ne l'auraient pas été, moins
la part des ventes déjà électrique (aubaine) : β = 0,055 par k€ pour une
aide générale (≈ 13 % des voitures aidées par une prime de 4 000 € en 2027),
0,115 pour les ménages modestes (leasing social) ; une obligation compte
chaque voiture (`Hypotheses/Energie.lean`, `Hypotheses/Economie.lean`).

**Transition écologique : PIB et emploi.** Une tonne de CO₂ évitée n'est
pas neutre pour l'activité. Le levier `transitionEcologique` compte
l'énergie fossile qui n'est plus achetée : importations évitées (la
dépense se reporte sur des biens produits en France), accises et TVA
perdues (rendues aux ménages et aux entreprises, pondérées comme une baisse
de prélèvement), accise et TVA de l'électricité consommée à la place ; un
biocarburant à prix et taxes inchangés ne retire que la part non importée
du substitut. La production qui disparaît (raffinerie, cheptel) retire
autant de PIB et d'emplois dans son secteur, la part reprise par des
importations s'ajoutant aux importations. Les investissements sont décrits
par technologie, publics (`investissementTransition`) ou privés
déclenchés par une mesure (`investissementPriveTransition`), avec la part
importée propre à chacune (véhicules électriques 75 %, HVO 80 %, éolien
60 %, biogazole 55 %, pompes à chaleur 45 %, biogaz 35 %, solaire 34 %,
rénovation et réseaux de chaleur 20 %, bioéthanol 10 % ; ADEME, IEA-PVPS,
IRENA, FranceAgriMer, Insee) et son secteur d'emploi (construction,
industrie, agriculture). Ordres de grandeur publiés pour comparaison :
+0,2 à +0,4 % de PIB et +20 000 à +60 000 emplois nets en 2030 pour une
transition financée par la dette (DG Trésor, Banque de France, ThreeME de
l'ADEME et de l'OFCE).

**Lois à respecter.** Outre les règles budgétaires françaises et
européennes et les objectifs climatiques, chaque programme est vérifié
contre la loi de programmation militaire actualisée (loi n° 2026-791 : la
dépense de défense ne passe pas sous sa trajectoire), les capacités 2030
de la programmation pluriannuelle de l'énergie (décret n° 2026-76) et
l'objectif de 40 % d'électricité renouvelable en 2030 (code de l'énergie,
art. L.100-4) (`Proprietes/Lois.lean`). Un programme peut proposer de
modifier une loi : la propriété signale alors l'écart.

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
| `Modele/` | état, unités, axes d'hypothèses, moteurs, leviers, projection, propriétés, programmes (types), sous-modèles SRU, automobile, attribution, rétro-test |
| `Hypotheses/` | valeurs des axes et produit cartésien `Hypotheses.tous`, panel de communes, comptes publics observés 2017-2025, détenteurs de la dette publique |
| `Tests/` | tests du modèle commun : comptabilité, mécanismes, assiettes des prélèvements, rétro-test, tendanciel |
| `Proprietes/` | propriétés partagées, registre `Proprietes.toutes` |
| `Programmes/<Nom>/` | un dossier par programme : `Programme.lean` + `README.md` + `PROPRIETAIRES` |
| `Moteurs/<Nom>/`, `Moteurs.lean` | moteurs contribués (`Moteur.lean` + `PROPRIETAIRES`) et leur registre |
| `Programmes.lean` | registre `Programmes.tous` |
| `Engagements.lean` | preuve que tous les engagements sont tenus (par blocs pour les programmes aux engagements nombreux, afin de tenir dans la mémoire du noyau) |
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
1,56, 1,80 enfant par femme), électricité produite et consommée (GW
moyens, capacités par filière), surfaces consommées (ENAF depuis 2021 face
à l'enveloppe du ZAN, par destination, emprise énergétique), propriétés et
engagements (avec le score global et le classement des programmes),
hypothèses et sources. Dans les tableaux de propriétés, le
fond de chaque case suit un dégradé continu selon la part des scénarios où
la propriété tient : rouge pour aucun, orange pour la moitié, vert pour
tous (le nombre reste écrit dans la case).

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

## Tests du modèle et rétro-test

`Tests/` rassemble une batterie de tests du modèle commun, décidés par le
noyau Lean comme les engagements (`lake build Tests`, étape bloquante de la
CI) :

* **comptabilité** (`Tests/Comptabilite.lean`) : la dette de fin d'année
  devient la dette de début de l'année suivante, avec et sans programme,
  sous chaque moteur ; les mesures d'une année entrent dans la dette de
  cette année ; un programme sans mesure redonne exactement le tendanciel ;
* **mécanismes** (`Tests/Mecanismes.lean`) : le PIB suit la trajectoire ;
  loi d'Okun ; semi-élasticité du solde au cycle entre 0,5 et 0,65 une fois
  l'IS encaissé (LPFP : 0,57 ; Commission : 0,6), un peu moins la première
  année (acomptes de l'IS) ; un point d'inflation coûte la part indexée de
  la dette ; un point de taux ne relève le taux apparent que de la part
  refinancée ; convergence du taux apparent ; multiplicateur ; symétrie
  dépense-économie ; rendement d'un prélèvement ; transition écologique
  (carburant évité : importations et accises en baisse, PIB en hausse ;
  biocarburant à taxes inchangées ; accise de l'électricité ; activité
  perdue ; part importée des investissements par technologie ;
  investissement privé sans dépense publique) ;
* **assiettes** (`Tests/Assiettes.lean`) : barème indexé (l'inflation seule
  ne relève pas l'IR plus que les revenus), progressivité sur la hausse
  réelle, accises insensibles aux prix, revalorisation légale des valeurs
  locatives, droits de mutation sur les transactions, accélérateur et
  modulation des acomptes de l'IS ; élasticités au cycle qui émergent des
  assiettes (cotisations 0,59, TVA 0,97, IS 1,45 la première année et 3,2 en
  régime établi ; LPFP : 0,63, 1,00, 2,76) ;
* **rétro-test** (`Tests/Retro.lean`, `Modele/Retro.lean`,
  `Hypotheses/Historique.lean`) : le modèle part des comptes publics
  observés de l'année précédente et simule l'année, avec la même fonction
  que les projections. Il reçoit ce qui n'est pas de son ressort
  (croissance, inflation, taux observés, marché immobilier, revalorisation
  des valeurs locatives ; mesures nouvelles de prélèvements, dépenses
  primaires et recettes hors prélèvements constatées) et calcule ce qui
  relève de ses mécanismes (assiettes, évolution spontanée de chaque
  prélèvement, charge d'intérêts, chômage, dette). Les seuils bornent biais
  et erreur moyenne du déficit, des prélèvements, des intérêts, de la masse
  salariale et de la consommation ;
* **électricité et sols** (`Tests/ElectriciteSols.lean`) : départ conforme
  au bilan électrique 2025 de RTE ; production de la première année à
  moins de 3 % de 2025 ; objectifs 2030 et 2035 de la PPE3 atteints ;
  consommation 2030 entre les trajectoires « stagnation » et
  « décarbonation rapide » de RTE ; solde exportateur borné ; un levier de
  capacité ne démantèle rien ; enveloppe 2021-2031 du ZAN tenue par le
  tendanciel ; abrogation ramenant au rythme 2011-2021 ; imputation des
  surfaces des mesures sur l'enveloppe ; surfaces exemptées hors du
  décompte ; emprise énergétique ; pompes à chaleur (électricité
  consommée, fioul et gaz économisés, coût net) ; emplois aidés et
  implantations ;
* **tendanciel** (`Tests/Tendanciel.lean`) : la dérive du déficit
  tendanciel 2026-2030 reste à moins d'un demi-point de celle de la
  projection « à politique inchangée » de la mission d'experts sur la
  transparence des finances publiques (juillet 2026).

Rétro-test à un an (déficit en % du PIB ; prélèvements et intérêts en
Md€ ; masse salariale : écart au montant observé) :

| Année | Déficit observé | Déficit du modèle | Écart | Prélèvements : écart | Intérêts : modèle / observé | Masse salariale |
|---|---|---|---|---|---|---|
| 2019 | 2,39 | 2,35 | −0,04 | +1,0 | 38,7 / 38,8 | −0,2 % |
| 2020 | 8,93 | 8,88 | −0,05 | +0,1 | 32,1 / 33,2 | +0,1 % |
| 2021 | 6,58 | 7,36 | +0,78 | −24,4 | 32,9 / 37,6 | −1,7 % |
| 2022 | 4,73 | 4,88 | +0,15 | −6,8 | 49,9 / 52,7 | −1,7 % |
| 2023 | 5,36 | 4,43 | −0,93 | +30,4 | 55,2 / 51,0 | +0,9 % |
| 2024 | 5,76 | 5,10 | −0,66 | +18,6 | 57,4 / 58,1 | +1,3 % |
| 2025 | 5,09 | 5,18 | +0,09 | −0,4 | 67,0 / 64,7 | +0,5 % |

Erreur moyenne sur le déficit : 0,39 point (biais −0,09), contre 0,53 quand
chaque prélèvement suivait le PIB ; erreur maximale : 0,93 point (1,44
auparavant) ; sur la charge d'intérêts : 2,2 Md€. L'élasticité des
prélèvements au PIB a été de 1,4 en 2022 et de 0,4 en 2023 (Cour des
comptes, base 2020) : le bénéfice fiscal de 2021 (+41 %) et les règles
d'acomptes de l'IS, la chute des transactions immobilières (−22 % en 2023)
et la revalorisation des valeurs locatives (+7,1 % en 2023) en expliquent
l'essentiel. Restent la déformation de la consommation vers les taux
réduits de TVA (2023-2024, IGF), le calendrier du prélèvement à la source
de l'impôt sur le revenu (la régularisation de l'année précédente) et, en
2020-2021, l'activité partielle, qui a découplé l'emploi du PIB (loi
d'Okun en défaut). Simulé depuis 2018 sans repartir des comptes observés,
le déficit 2025 est de 4,84 % (5,09 % observé) et la dette de 114,1 % du
PIB (115,7 %) : l'écart de dette vient des ajustements dette-déficit, que
le modèle ne projette pas (trésorerie de 2020).

## CI

`ci.yml`, sur chaque push et chaque PR (forks compris, jeton en lecture
seule) :

1. **garde-fou syntaxique**, bloquant, avant toute compilation ;
2. contrôle du registre (dossiers, imports, CODEOWNERS) ;
3. matrice d'évaluation sur la branche de base, **puis** sur la PR, et diff ;
4. tests du modèle commun (`Tests/`) ;
5. preuve des engagements ;
6. rejeu indépendant des preuves par `leanchecker` ;
7. audit des axiomes ;
8. résumé dans le job, artefact `rapport-pr`. Le résumé montre d'emblée
   le score global de chaque programme (somme, sur toutes les propriétés,
   du nombre de scénarios où chacune tient, par moteur, avec un
   classement) puis, pour chaque moteur, le nombre de scénarios où chaque
   propriété tient par programme, avec une pastille de couleur : 🟥 moins d'un quart,
   🟧 d'un quart à trois quarts, 🟨 trois quarts ou plus, 🟩 tous (les
   tableaux Markdown de GitHub n'acceptent pas de couleur de fond) ; le
   rapport complet est replié.

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
* Le sous-modèle électrique raisonne en énergie annuelle : pointes,
  stockage, prix et effacements n'y figurent pas, et le thermique fossile
  garde son facteur de charge de 2025. Celui des sols ne connaît que les
  rythmes nationaux (pas de territorialisation des enveloppes).
* Le modèle agrégé ne connaît ni barèmes ni ménages types. Piste
  naturelle : une microsimulation (OpenFisca) lancée en CI qui émet des
  agrégats, que Lean vérifie contre les propriétés ; et Catala pour la
  sémantique juridique fine.

## Licence

[CC0 1.0 Universel](LICENSE) : le dépôt est versé au domaine public. Code,
modèle, hypothèses et documentation peuvent être réutilisés, modifiés et
redistribués sans condition, y compris commercialement, sans obligation de
citer. En droit français, le droit moral de l'auteur est inaliénable : CC0
y renonce dans la mesure permise et prévoit une licence de repli tout aussi
large. Les sources citées dans les hypothèses (INSEE, COR…) gardent leur
propre licence.
