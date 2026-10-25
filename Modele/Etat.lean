import Modele.Unites

/-!
# État macro suivi par le modèle

Un `Etat` est la photographie d'une année. Le modèle compare toujours deux
états à l'horizon du scénario : le **tendanciel** (sans programme) et
l'état **avec programme**.

Les recettes publiques sont décomposées par grand impôt (`ParImpot`),
l'emploi par grand secteur (`ParSecteur`). Les recettes totales, l'emploi
total et le taux de chômage sont calculés, jamais stockés : ils ne peuvent
pas se désynchroniser de leur décomposition. L'emploi et la population
active sont comptés en personnes, pour que même une petite mesure ait un
effet visible sur l'emploi.

Ajouter un champ ici est une modification du modèle commun : elle doit être
discutée en issue avant toute PR (voir CONTRIBUTING.md).
-/

namespace Modele

/-! ## Secteurs d'activité -/

/-- Grands secteurs de la nomenclature agrégée de l'INSEE. -/
inductive Secteur where
  | agriculture | industrie | construction | tertiaireMarchand | tertiaireNonMarchand
  deriving Repr, DecidableEq, Inhabited

namespace Secteur

def tous : List Secteur :=
  [.agriculture, .industrie, .construction, .tertiaireMarchand, .tertiaireNonMarchand]

def nom : Secteur → String
  | .agriculture => "Agriculture"
  | .industrie => "Industrie"
  | .construction => "Construction"
  | .tertiaireMarchand => "Tertiaire marchand"
  | .tertiaireNonMarchand => "Tertiaire non marchand"

def id : Secteur → String
  | .agriculture => "agriculture"
  | .industrie => "industrie"
  | .construction => "construction"
  | .tertiaireMarchand => "tertiaireMarchand"
  | .tertiaireNonMarchand => "tertiaireNonMarchand"

end Secteur

/-- Une valeur par secteur. -/
structure ParSecteur where
  agriculture : Int
  industrie : Int
  construction : Int
  tertiaireMarchand : Int
  tertiaireNonMarchand : Int
  deriving Repr, DecidableEq, Inhabited

namespace ParSecteur

def get (v : ParSecteur) : Secteur → Int
  | .agriculture => v.agriculture
  | .industrie => v.industrie
  | .construction => v.construction
  | .tertiaireMarchand => v.tertiaireMarchand
  | .tertiaireNonMarchand => v.tertiaireNonMarchand

def ajouter (v : ParSecteur) (s : Secteur) (d : Int) : ParSecteur :=
  match s with
  | .agriculture => { v with agriculture := v.agriculture + d }
  | .industrie => { v with industrie := v.industrie + d }
  | .construction => { v with construction := v.construction + d }
  | .tertiaireMarchand => { v with tertiaireMarchand := v.tertiaireMarchand + d }
  | .tertiaireNonMarchand => { v with tertiaireNonMarchand := v.tertiaireNonMarchand + d }

def total (v : ParSecteur) : Int :=
  v.agriculture + v.industrie + v.construction + v.tertiaireMarchand + v.tertiaireNonMarchand

/-- Tous les secteurs sont positifs ou nuls. -/
abbrev Positif (v : ParSecteur) : Prop :=
  0 ≤ v.agriculture ∧ 0 ≤ v.industrie ∧ 0 ≤ v.construction ∧
  0 ≤ v.tertiaireMarchand ∧ 0 ≤ v.tertiaireNonMarchand

/-- Répartit `d` : entièrement sur `cible` si elle est donnée, sinon au
prorata, parts arrondies vers zéro (le reste va au tertiaire marchand). Le
total augmente exactement de `d`. -/
def repartir (v : ParSecteur) (d : Int) : Option Secteur → ParSecteur
  | some s => v.ajouter s d
  | none =>
    let t := v.total
    if t = 0 then v.ajouter .tertiaireMarchand d else
    let part (x : Int) := if d < 0 then -((-d) * x / t) else d * x / t
    let a := part v.agriculture
    let i := part v.industrie
    let c := part v.construction
    let n := part v.tertiaireNonMarchand
    { agriculture := v.agriculture + a, industrie := v.industrie + i
      construction := v.construction + c
      tertiaireMarchand := v.tertiaireMarchand + (d - a - i - c - n)
      tertiaireNonMarchand := v.tertiaireNonMarchand + n }

end ParSecteur

/-! ## Tranches de salaire -/

/-- Tranches de salaire du secteur privé, en multiples du SMIC (allègements
généraux de cotisations patronales, coût du travail). -/
inductive TrancheSalaire where
  /-- De 1 à 1,6 SMIC. -/
  | bas
  /-- De 1,6 à 2,5 SMIC. -/
  | intermediaire
  /-- Au-delà de 2,5 SMIC. -/
  | haut
  deriving Repr, DecidableEq, Inhabited

namespace TrancheSalaire

def tous : List TrancheSalaire := [.bas, .intermediaire, .haut]

def id : TrancheSalaire → String
  | .bas => "bas"
  | .intermediaire => "intermediaire"
  | .haut => "haut"

def nom : TrancheSalaire → String
  | .bas => "1 à 1,6 SMIC"
  | .intermediaire => "1,6 à 2,5 SMIC"
  | .haut => "Au-delà de 2,5 SMIC"

end TrancheSalaire

/-- Une valeur par tranche de salaire. -/
structure ParTranche where
  bas : Int := 0
  intermediaire : Int := 0
  haut : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace ParTranche

def get (v : ParTranche) : TrancheSalaire → Int
  | .bas => v.bas
  | .intermediaire => v.intermediaire
  | .haut => v.haut

def ajouter (v : ParTranche) (t : TrancheSalaire) (d : Int) : ParTranche :=
  match t with
  | .bas => { v with bas := v.bas + d }
  | .intermediaire => { v with intermediaire := v.intermediaire + d }
  | .haut => { v with haut := v.haut + d }

def total (v : ParTranche) : Int := v.bas + v.intermediaire + v.haut

/-- Chaque tranche croît du même taux (pb). -/
def croitre (v : ParTranche) (tauxPb : Int) : ParTranche :=
  { bas := v.bas + appliquerPb v.bas tauxPb
    intermediaire := v.intermediaire + appliquerPb v.intermediaire tauxPb
    haut := v.haut + appliquerPb v.haut tauxPb }

/-- Toutes les composantes sont dans `[lo, hi]`. -/
def toutEntre (v : ParTranche) (lo hi : Int) : Bool :=
  TrancheSalaire.tous.all fun t => decide (lo ≤ v.get t ∧ v.get t ≤ hi)

theorem total_ajouter (v : ParTranche) (t : TrancheSalaire) (d : Int) :
    (v.ajouter t d).total = v.total + d := by
  cases t <;> simp [ajouter, total] <;> omega

end ParTranche

/-! ## Émissions de gaz à effet de serre par secteur -/

/-- Secteurs d'émission (inventaire national, format SECTEN du Citepa). -/
inductive SecteurGes where
  | transports | batiments | agriculture | industrie | energie | dechets
  deriving Repr, DecidableEq, Inhabited

namespace SecteurGes

def tous : List SecteurGes := [.transports, .batiments, .agriculture, .industrie, .energie, .dechets]

def nom : SecteurGes → String
  | .transports => "Transports"
  | .batiments => "Bâtiments"
  | .agriculture => "Agriculture"
  | .industrie => "Industrie"
  | .energie => "Production d'énergie"
  | .dechets => "Déchets"

def id : SecteurGes → String
  | .transports => "transports"
  | .batiments => "batiments"
  | .agriculture => "agriculture"
  | .industrie => "industrie"
  | .energie => "energie"
  | .dechets => "dechets"

end SecteurGes

/-- Une valeur par secteur d'émission (kt CO₂e, ou pm pour des taux). -/
structure ParSecteurGes where
  transports : Int
  batiments : Int
  agriculture : Int
  industrie : Int
  energie : Int
  dechets : Int
  deriving Repr, DecidableEq, Inhabited

namespace ParSecteurGes

def get (v : ParSecteurGes) : SecteurGes → Int
  | .transports => v.transports
  | .batiments => v.batiments
  | .agriculture => v.agriculture
  | .industrie => v.industrie
  | .energie => v.energie
  | .dechets => v.dechets

def ajouter (v : ParSecteurGes) (s : SecteurGes) (d : Int) : ParSecteurGes :=
  match s with
  | .transports => { v with transports := v.transports + d }
  | .batiments => { v with batiments := v.batiments + d }
  | .agriculture => { v with agriculture := v.agriculture + d }
  | .industrie => { v with industrie := v.industrie + d }
  | .energie => { v with energie := v.energie + d }
  | .dechets => { v with dechets := v.dechets + d }

def total (v : ParSecteurGes) : Int :=
  v.transports + v.batiments + v.agriculture + v.industrie + v.energie + v.dechets

/-- Baisse de chaque secteur à son taux (pm du niveau). -/
def baisser (v : ParSecteurGes) (taux : ParSecteurGes) : ParSecteurGes :=
  { transports := v.transports - appliquerPm v.transports taux.transports
    batiments := v.batiments - appliquerPm v.batiments taux.batiments
    agriculture := v.agriculture - appliquerPm v.agriculture taux.agriculture
    industrie := v.industrie - appliquerPm v.industrie taux.industrie
    energie := v.energie - appliquerPm v.energie taux.energie
    dechets := v.dechets - appliquerPm v.dechets taux.dechets }

theorem total_ajouter (v : ParSecteurGes) (s : SecteurGes) (d : Int) :
    (v.ajouter s d).total = v.total + d := by
  cases s <;> simp [ajouter, total] <;> omega

end ParSecteurGes

/-! ## Impôts et cotisations -/

/-- Grands prélèvements obligatoires. -/
inductive Impot where
  | tva | ir | csgCrds | cotisations | impotSocietes | accisesEnergie | taxeFonciere
  | droitsMutation
  /-- Impôts sur le stock de patrimoine (IFI, taxes sur la fortune ou sur les
  holdings) : payés par les ménages les plus aisés, d'où un faible effet sur
  la demande (voir `Economie.incidencePrelevementPm`). -/
  | patrimoine
  | autres
  deriving Repr, DecidableEq, Inhabited

namespace Impot

def tous : List Impot :=
  [.tva, .ir, .csgCrds, .cotisations, .impotSocietes, .accisesEnergie, .taxeFonciere,
   .droitsMutation, .patrimoine, .autres]

def nom : Impot → String
  | .tva => "TVA"
  | .ir => "Impôt sur le revenu"
  | .csgCrds => "CSG et CRDS"
  | .cotisations => "Cotisations sociales"
  | .impotSocietes => "Impôt sur les sociétés"
  | .accisesEnergie => "Accise sur les énergies (TICPE)"
  | .taxeFonciere => "Taxe foncière"
  | .droitsMutation => "Droits de succession et de donation"
  | .patrimoine => "Impôts sur le patrimoine (IFI, fortune)"
  | .autres => "Autres impôts"

def id : Impot → String
  | .tva => "tva"
  | .ir => "ir"
  | .csgCrds => "csgCrds"
  | .cotisations => "cotisations"
  | .impotSocietes => "impotSocietes"
  | .accisesEnergie => "accisesEnergie"
  | .taxeFonciere => "taxeFonciere"
  | .droitsMutation => "droitsMutation"
  | .patrimoine => "patrimoine"
  | .autres => "autres"

end Impot

/-- Un montant par prélèvement, M€. -/
structure ParImpot where
  tva : Int
  ir : Int
  csgCrds : Int
  cotisations : Int
  impotSocietes : Int
  accisesEnergie : Int
  taxeFonciere : Int
  /-- Droits de mutation à titre gratuit (successions et donations). Leur
  assiette suit le flux successoral, pas le PIB (voir la projection). -/
  droitsMutation : Int
  /-- Impôts sur le stock de patrimoine (IFI…). -/
  patrimoine : Int
  autres : Int
  deriving Repr, DecidableEq, Inhabited

namespace ParImpot

def get (v : ParImpot) : Impot → Int
  | .tva => v.tva
  | .ir => v.ir
  | .csgCrds => v.csgCrds
  | .cotisations => v.cotisations
  | .impotSocietes => v.impotSocietes
  | .accisesEnergie => v.accisesEnergie
  | .taxeFonciere => v.taxeFonciere
  | .droitsMutation => v.droitsMutation
  | .patrimoine => v.patrimoine
  | .autres => v.autres

def ajouter (v : ParImpot) (i : Impot) (d : Int) : ParImpot :=
  match i with
  | .tva => { v with tva := v.tva + d }
  | .ir => { v with ir := v.ir + d }
  | .csgCrds => { v with csgCrds := v.csgCrds + d }
  | .cotisations => { v with cotisations := v.cotisations + d }
  | .impotSocietes => { v with impotSocietes := v.impotSocietes + d }
  | .accisesEnergie => { v with accisesEnergie := v.accisesEnergie + d }
  | .taxeFonciere => { v with taxeFonciere := v.taxeFonciere + d }
  | .droitsMutation => { v with droitsMutation := v.droitsMutation + d }
  | .patrimoine => { v with patrimoine := v.patrimoine + d }
  | .autres => { v with autres := v.autres + d }

def total (v : ParImpot) : Int :=
  v.tva + v.ir + v.csgCrds + v.cotisations + v.impotSocietes + v.accisesEnergie
    + v.taxeFonciere + v.droitsMutation + v.patrimoine + v.autres

/-- Toutes les composantes sont dans `[lo, hi]`. -/
def toutEntre (v : ParImpot) (lo hi : Int) : Bool :=
  Impot.tous.all fun i => decide (lo ≤ v.get i ∧ v.get i ≤ hi)

/-- Chaque prélèvement croît du même taux (pb), assiettes supposées
proportionnelles au PIB nominal. -/
def croitre (v : ParImpot) (tauxPb : Int) : ParImpot :=
  { tva := v.tva + appliquerPb v.tva tauxPb, ir := v.ir + appliquerPb v.ir tauxPb
    csgCrds := v.csgCrds + appliquerPb v.csgCrds tauxPb
    cotisations := v.cotisations + appliquerPb v.cotisations tauxPb
    impotSocietes := v.impotSocietes + appliquerPb v.impotSocietes tauxPb
    accisesEnergie := v.accisesEnergie + appliquerPb v.accisesEnergie tauxPb
    taxeFonciere := v.taxeFonciere + appliquerPb v.taxeFonciere tauxPb
    droitsMutation := v.droitsMutation + appliquerPb v.droitsMutation tauxPb
    patrimoine := v.patrimoine + appliquerPb v.patrimoine tauxPb
    autres := v.autres + appliquerPb v.autres tauxPb }

/-- Répartit `d` au prorata des prélèvements, parts arrondies vers zéro (reste
sur « autres »). -/
def repartir (v : ParImpot) (d : Int) : ParImpot :=
  let t := v.total
  if t = 0 then v.ajouter .autres d else
  let part (x : Int) := if d < 0 then -((-d) * x / t) else d * x / t
  let a := part v.tva
  let b := part v.ir
  let c := part v.csgCrds
  let e := part v.cotisations
  let f := part v.impotSocietes
  let g := part v.accisesEnergie
  let h := part v.taxeFonciere
  let m := part v.droitsMutation
  let p := part v.patrimoine
  { tva := v.tva + a, ir := v.ir + b, csgCrds := v.csgCrds + c
    cotisations := v.cotisations + e, impotSocietes := v.impotSocietes + f
    accisesEnergie := v.accisesEnergie + g, taxeFonciere := v.taxeFonciere + h
    droitsMutation := v.droitsMutation + m, patrimoine := v.patrimoine + p
    autres := v.autres + (d - a - b - c - e - f - g - h - m - p) }

end ParImpot

/-! ## Fonctions de dépense (nomenclature COFOG agrégée) -/

inductive Fonction where
  | retraites | sante | famille | enseignement | affairesEconomiques | defense
  | securiteJustice | logementEnvironnement | culture | interets | fonctionnement | nonVentile
  deriving Repr, DecidableEq, Inhabited

namespace Fonction

def tous : List Fonction :=
  [.retraites, .sante, .famille, .enseignement, .affairesEconomiques, .defense,
   .securiteJustice, .logementEnvironnement, .culture, .interets, .fonctionnement, .nonVentile]

def nom : Fonction → String
  | .retraites => "Retraites"
  | .sante => "Santé"
  | .famille => "Famille, chômage, exclusion, handicap"
  | .enseignement => "Enseignement et recherche"
  | .affairesEconomiques => "Affaires économiques, transports"
  | .defense => "Défense"
  | .securiteJustice => "Sécurité et justice"
  | .logementEnvironnement => "Logement, environnement, transition"
  | .culture => "Culture, sport, loisirs"
  | .interets => "Charge d'intérêts"
  | .fonctionnement => "Services généraux, collectivités, UE"
  | .nonVentile => "Non ventilé"

def id : Fonction → String
  | .retraites => "retraites"
  | .sante => "sante"
  | .famille => "famille"
  | .enseignement => "enseignement"
  | .affairesEconomiques => "affairesEconomiques"
  | .defense => "defense"
  | .securiteJustice => "securiteJustice"
  | .logementEnvironnement => "logementEnvironnement"
  | .culture => "culture"
  | .interets => "interets"
  | .fonctionnement => "fonctionnement"
  | .nonVentile => "nonVentile"

/-- Fonctions soumises à une norme de dépense : toutes sauf les transferts
sociaux (retraites, famille-chômage), les priorités (enseignement, défense)
et la charge d'intérêts. -/
def pilotable : Fonction → Bool
  | .sante | .affairesEconomiques | .securiteJustice | .logementEnvironnement | .culture
  | .fonctionnement | .nonVentile => true
  | _ => false

/-- Secteur qui reçoit les emplois d'une dépense de cette fonction (sinon :
au prorata des secteurs). -/
def secteur : Fonction → Option Secteur
  | .sante | .enseignement | .defense | .securiteJustice | .culture => some .tertiaireNonMarchand
  | .logementEnvironnement => some .construction
  | _ => none

end Fonction

/-- Un montant par fonction, M€. -/
structure ParFonction where
  retraites : Int
  sante : Int
  famille : Int
  enseignement : Int
  affairesEconomiques : Int
  defense : Int
  securiteJustice : Int
  logementEnvironnement : Int
  culture : Int
  interets : Int
  fonctionnement : Int
  nonVentile : Int
  deriving Repr, DecidableEq, Inhabited

namespace ParFonction

def get (v : ParFonction) : Fonction → Int
  | .retraites => v.retraites
  | .sante => v.sante
  | .famille => v.famille
  | .enseignement => v.enseignement
  | .affairesEconomiques => v.affairesEconomiques
  | .defense => v.defense
  | .securiteJustice => v.securiteJustice
  | .logementEnvironnement => v.logementEnvironnement
  | .culture => v.culture
  | .interets => v.interets
  | .fonctionnement => v.fonctionnement
  | .nonVentile => v.nonVentile

def ajouter (v : ParFonction) (f : Fonction) (d : Int) : ParFonction :=
  match f with
  | .retraites => { v with retraites := v.retraites + d }
  | .sante => { v with sante := v.sante + d }
  | .famille => { v with famille := v.famille + d }
  | .enseignement => { v with enseignement := v.enseignement + d }
  | .affairesEconomiques => { v with affairesEconomiques := v.affairesEconomiques + d }
  | .defense => { v with defense := v.defense + d }
  | .securiteJustice => { v with securiteJustice := v.securiteJustice + d }
  | .logementEnvironnement => { v with logementEnvironnement := v.logementEnvironnement + d }
  | .culture => { v with culture := v.culture + d }
  | .interets => { v with interets := v.interets + d }
  | .fonctionnement => { v with fonctionnement := v.fonctionnement + d }
  | .nonVentile => { v with nonVentile := v.nonVentile + d }

def total (v : ParFonction) : Int :=
  v.retraites + v.sante + v.famille + v.enseignement + v.affairesEconomiques + v.defense
    + v.securiteJustice + v.logementEnvironnement + v.culture + v.interets + v.fonctionnement
    + v.nonVentile

/-- Toutes les fonctions sauf la charge d'intérêts croissent du taux `tauxPb` ;
les fonctions automatisables (services généraux, affaires économiques,
santé) croissent de `robotisationPb` de moins ; les fonctions soumises à une
norme de dépense (`Fonction.pilotable`) de `moderationPb` de moins. -/
def croitrePrimaires (v : ParFonction) (tauxPb robotisationPb : Int) (moderationPb : Int := 0) :
    ParFonction :=
  let g (x : Int) := x + appliquerPb x tauxPb
  let n (x : Int) := x + appliquerPb x (tauxPb - moderationPb)
  let r (x : Int) := x + appliquerPb x (tauxPb - robotisationPb - moderationPb)
  { retraites := g v.retraites, sante := r v.sante, famille := g v.famille
    enseignement := g v.enseignement, affairesEconomiques := r v.affairesEconomiques
    defense := g v.defense, securiteJustice := n v.securiteJustice
    logementEnvironnement := n v.logementEnvironnement, culture := n v.culture
    interets := v.interets, fonctionnement := r v.fonctionnement, nonVentile := n v.nonVentile }

/-- Taux de croissance tendanciel d'une fonction, pb : celui que lui applique
`croitrePrimaires` (nul pour la charge d'intérêts, calculée à part). -/
def tauxCroissance (f : Fonction) (tauxPb robotisationPb : Int) (moderationPb : Int := 0) : Int :=
  match f with
  | .sante | .affairesEconomiques | .fonctionnement => tauxPb - robotisationPb - moderationPb
  | .securiteJustice | .logementEnvironnement | .culture | .nonVentile => tauxPb - moderationPb
  | .interets => 0
  | _ => tauxPb

/-- Toutes les composantes sont dans `[lo, hi]`. -/
def toutEntre (v : ParFonction) (lo hi : Int) : Bool :=
  Fonction.tous.all fun f => decide (lo ≤ v.get f ∧ v.get f ≤ hi)

/-- Cohérence : hors intérêts, `croitrePrimaires` fait croître chaque fonction
exactement de son `tauxCroissance` (utilisé pour indexer les échéanciers). -/
theorem croitrePrimaires_get (v : ParFonction) (t r m : Int) (f : Fonction) (h : f ≠ .interets) :
    (v.croitrePrimaires t r m).get f = v.get f + appliquerPb (v.get f) (tauxCroissance f t r m) := by
  cases f <;> first | exact absurd rfl h | rfl

/-- Cohérence : la norme de dépense retire exactement `m` au taux de
croissance des fonctions pilotables, et rien aux autres. -/
theorem tauxCroissance_norme (f : Fonction) (t r m : Int) (h : f ≠ .interets) :
    tauxCroissance f t r m = tauxCroissance f t r 0 - (if f.pilotable then m else 0) := by
  cases f <;> simp_all [tauxCroissance, Fonction.pilotable] <;> omega

end ParFonction

/-- Types de passifs implicites (« dettes cachées ») suivis par le modèle. -/
inductive TypePassif where
  /-- Heures supplémentaires non payées ni récupérées des policiers. -/
  | heuresSupPolice
  /-- Heures supplémentaires non payées ni récupérées à l'hôpital public. -/
  | heuresSupHopital
  deriving Repr, DecidableEq, Inhabited

/-- Un montant par type de passif implicite, M€. -/
structure ParPassif where
  police : Int := 0
  hopital : Int := 0
  deriving Repr, DecidableEq, Inhabited

namespace ParPassif

def get (v : ParPassif) : TypePassif → Int
  | .heuresSupPolice => v.police
  | .heuresSupHopital => v.hopital

def ajouter (v : ParPassif) (t : TypePassif) (d : Int) : ParPassif :=
  match t with
  | .heuresSupPolice => { v with police := v.police + d }
  | .heuresSupHopital => { v with hopital := v.hopital + d }

def total (v : ParPassif) : Int := v.police + v.hopital

theorem total_ajouter (v : ParPassif) (t : TypePassif) (d : Int) :
    (v.ajouter t d).total = v.total + d := by
  cases t <;> simp [ajouter, total] <;> omega

end ParPassif

/-- Nature d'une rémunération publique supplémentaire : elle fixe les
prélèvements qui en reviennent aussitôt aux administrations publiques. -/
inductive NatureRemuneration where
  /-- Traitement indiciaire : CSG-CRDS, retenue pour pension, impôt sur le revenu. -/
  | traitement
  /-- Primes et indemnités : CSG-CRDS, RAFP, impôt sur le revenu. -/
  | primes
  /-- Heures supplémentaires : CSG-CRDS ; exonérées d'impôt sur le revenu
  (dans la limite de 7 500 € par an) et de la plupart des cotisations. -/
  | heuresSup
  deriving Repr, DecidableEq, Inhabited

/-- Échéancier d'une dépense : niveaux annuels fixés à l'avance (indemnités
versées jusqu'à la retraite, revalorisations cumulées…), exprimés en euros de
l'année d'entrée en vigueur et indexés sur la croissance tendancielle de leur
fonction. Une fois la liste épuisée, le dernier niveau est conservé. -/
structure Echeance where
  fonction : Fonction
  /-- Secteur qui reçoit l'effet de demande (par défaut : celui de la
  fonction ; la construction pour un investissement). -/
  secteur : Option Secteur := none
  /-- Part de la dépense adressée à la production intérieure, pm ; le reste
  est importé (investissement outre-mer). -/
  partInterieurePm : Int := 1000
  /-- Rémunération d'agents publics déjà en poste : pas de production ni
  d'emplois en plus ; une part revient en prélèvements, le reste soutient la
  consommation des ménages (effet de demande d'un transfert). -/
  remuneration : Option NatureRemuneration := none
  /-- Niveaux des années suivantes, M€ de l'année d'entrée en vigueur. -/
  restants : List Int
  /-- Niveau de l'année, M€ courants. -/
  niveau : Int
  /-- Indice de croissance de la fonction depuis l'entrée en vigueur, base 10 000. -/
  indice : Int
  deriving Repr, DecidableEq, Inhabited

/-- Échéancier d'une recette : impôt (`some i`) ou recette non fiscale
(`none`), niveaux annuels fixés à l'avance (fin de la CRDS avec la CADES,
péages d'autoroutes revenus à l'État…), en euros de l'année d'entrée en
vigueur, indexés sur le PIB nominal comme les assiettes. Le dernier niveau
est conservé une fois la liste épuisée. -/
structure EcheanceRecette where
  impot : Option Impot
  restants : List Int
  niveau : Int
  indice : Int
  deriving Repr, DecidableEq, Inhabited

/-! ## État -/

structure Etat where
  /-- PIB, M€ courants. -/
  pib : Int
  /-- Impôts et cotisations sociales, par prélèvement, M€. -/
  impots : ParImpot
  /-- Recettes non fiscales (ventes, revenus de la propriété…), M€. -/
  autresRecettes : Int
  /-- Dépenses des administrations publiques par fonction, M€, charge
  d'intérêts comprise (fonction `interets`). -/
  depensesF : ParFonction
  /-- Taux d'intérêt apparent de la dette (intérêts / dette de l'année
  précédente), pb. Il converge vers le taux marginal du scénario au rythme
  du refinancement. -/
  tauxApparentPb : Int
  /-- Dette publique, M€. -/
  dette : Int
  /-- Opérations financières annuelles des administrations publiques (prêts,
  prises de participation), M€/an : elles accroissent la dette sans entrer
  dans le déficit (traitement de Maastricht). -/
  operationsFinancieres : Int
  /-- SMIC mensuel brut, €. -/
  smicMensuel : Int
  /-- Émissions territoriales de gaz à effet de serre par secteur, kt CO₂e
  (hors puits). Le total en Mt : `Etat.emissionsMt`. -/
  emissionsKt : ParSecteurGes
  /-- Âge légal de départ à la retraite, mois. -/
  ageLegalMois : Int
  /-- Population, milliers. -/
  populationMilliers : Int
  /-- Population active au sens du BIT, personnes. -/
  actifs : Int
  /-- Personnes en emploi, par secteur. -/
  emploi : ParSecteur
  /-- Durée annuelle effective du travail par personne en emploi, heures. -/
  heuresParEmploi : Int
  /-- Écart de solde migratoire dû aux mesures, milliers par an (flux porté
  par la projection, positif = plus d'entrées nettes). -/
  migrationAnnuelleMilliers : Int
  /-- Emplois que le programme annonce créer (objectif déclaré, cumulé),
  personnes. Sans effet sur le modèle : sert à vérifier que l'objectif
  tient dans la population active. -/
  emploisAnnonces : Int
  /-- Touristes internationaux accueillis dans l'année, milliers. -/
  touristesMilliers : Int
  /-- Dépense moyenne d'un touriste international pendant son séjour, €. -/
  depenseParTouriste : Int
  /-- Exportations de biens et services, M€ (recettes touristiques comprises). -/
  exportations : Int
  /-- Importations de biens et services, M€. -/
  importations : Int
  /-- Revenus primaires et secondaires nets reçus du reste du monde, M€. -/
  revenusNets : Int
  /-- Variation d'importations due aux mesures, M€ par an (flux porté par la
  projection ; négatif = carburant évité…). -/
  variationImportsAnnuelle : Int
  /-- Accidents du travail avec arrêt pour 10 000 personnes en emploi, par an. -/
  tauxAccidentsPdm : Int
  /-- Gains de productivité par robotisation et automatisation des services,
  pb par an : réduisent la croissance des dépenses de fonctionnement, des
  affaires économiques et de santé (tendance du scénario + mesures). -/
  robotisationPb : Int
  /-- Décès annuels attribuables à la pollution de l'air (particules fines). -/
  decesPollutionAir : Int
  /-- Parc de voitures électriques, milliers. -/
  parcElectriqueMilliers : Int
  /-- Points de recharge ouverts au public, milliers. -/
  bornesMilliers : Int
  /-- Électrification supplémentaire du parc due aux mesures, milliers de
  véhicules par an (flux porté par la projection). -/
  electrificationAnnuelleMilliers : Int
  /-- Bornes supplémentaires dues aux mesures, milliers par an. -/
  bornesAnnuellesMilliers : Int
  /-- Part de la dette émise en OAT numériques (titres tokenisés réglés en
  jetons de monnaie électronique), pm de la dette. Nulle sans mesure. -/
  partDetteNumeriquePm : Int := 0
  /-- Part cible des OAT numériques, pm de la dette (flux porté). -/
  cibleDetteNumeriquePm : Int := 0
  /-- Hausse annuelle de la part des OAT numériques, pm (flux porté). -/
  rythmeDetteNumeriquePm : Int := 0
  /-- Décote du taux servi sur la tranche numérique, pm du taux apparent :
  part de l'exonération fiscale capitalisée dans le prix des titres. -/
  decoteDetteNumeriquePm : Int := 0
  /-- Part des intérêts de la tranche numérique qui, sans exonération,
  auraient été imposés au prélèvement forfaitaire unique, pm. -/
  partDefiscaliseePm : Int := 0
  /-- Économie d'intérêts de l'année due à la décote, M€ (suivi). -/
  economieInteretsNumeriqueMeur : Int := 0
  /-- Recettes de PFU perdues dans l'année du fait de l'exonération, M€
  (déjà retranchées des impôts ; mémorisées pour la projection). -/
  pertePfuMeur : Int := 0
  /-- Écart entre l'emploi d'équilibre et l'emploi effectif dû aux chocs
  d'offre de travail des mesures (migrations, âge de départ, réallocations
  par automatisation), personnes : emploi d'équilibre = taux d'emploi
  d'avant le choc × variation de la population active. Résorbé chaque année
  au taux `absorptionChomagePm` du scénario. -/
  chomeursExcedentaires : Int := 0
  /-- Emplois encore à venir des variations du coût du travail dues aux
  mesures (allègements de cotisations par tranche), personnes : la demande
  de travail s'ajuste progressivement (`ajustementCoutTravailPm`). -/
  emploisCoutTravailRestants : Int := 0
  /-- Les mêmes, pondérés par le coût du travail par emploi de leur tranche
  rapporté à la moyenne (un emploi au voisinage du SMIC produit moins qu'un
  emploi moyen) : base de l'effet sur le PIB, personnes. -/
  emploisPonderesCoutTravailRestants : Int := 0
  /-- Allègements généraux de cotisations patronales en vigueur, par tranche
  de salaire, M€ (indexés sur le PIB nominal ; déjà retranchés des
  cotisations). -/
  allegementsTranche : ParTranche := {}
  /-- Dépense d'assurance chômage due au franchissement du seuil de chômage
  des règles contracycliques (complément de fin de droits), M€ (suivi). -/
  complementChomageMeur : Int := 0
  /-- Norme de dépense : moindre croissance annuelle des fonctions pilotables
(`Fonction.pilotable`), pb. -/
  moderationDepensesPb : Int := 0
  /-- Taux marginal de l'année (taux du scénario corrigé de la prime de risque
  liée au déficit), pb (suivi). -/
  tauxMarginalCourantPb : Int := 0
  /-- Dépenses à échéancier en cours (voir `Echeance`). -/
  echeances : List Echeance := []
  /-- Recettes à échéancier en cours (voir `EcheanceRecette`). -/
  echeancesRecettes : List EcheanceRecette := []
  /-- Valeur des participations de l'État dans les entreprises, M€. Elle suit
  le PIB nominal, plus les prises de participation. -/
  participationsEtat : Int := 0
  /-- Dividendes reçus par l'État, M€ : compris dans `autresRecettes`. Ils
  valent `participationsEtat` × rendement du portefeuille de départ. -/
  dividendesEtat : Int := 0
  /-- Prises de participation annuelles dues aux mesures, M€/an (flux porté) :
  elles accroissent la dette sans entrer dans le déficit (opérations
  financières) et augmentent le portefeuille. -/
  investissementsParticipations : Int := 0
  /-- Calendrier légal de l'âge de départ : hausses des années suivantes,
  mois par an (tête = année prochaine). -/
  calendrierAgeLegal : List Int := []
  /-- Hausses d'âge dont les effets (dépenses de retraite, population active)
  sont déjà dans la tendance du scénario, mois par an. La projection
  n'applique les effets que de l'écart entre les deux calendriers. -/
  calendrierAgeTendanciel : List Int := []
  /-- Ventes tendancielles de voitures électriques neuves de l'année,
  milliers (flux porté par la projection). -/
  electrificationTendanceMilliers : Int := 0
  /-- Contribution différentielle sur les hauts revenus, M€ (comprise dans
  `impots.ir`) : due jusqu'à ce que le déficit public passe sous 3 % du PIB
  (loi n° 2025-127) ; la projection la supprime l'année qui suit. -/
  cdhrMeur : Int := 0
  /-- Décès de l'année, milliers (montent de `hausseDecesMilliers` par an). -/
  decesMilliers : Int := 0
  /-- Économies annuelles de fioul et de gaz dues aux rénovations
  supplémentaires des mesures, MWh par an (flux porté par la projection :
  chaque année ajoute ce volume aux économies déjà acquises). -/
  economiesFioulMWhAnnuelles : Int := 0
  economiesGazMWhAnnuelles : Int := 0
  /-- Chômeurs déjà couverts par les dépenses d'indemnisation inscrites
  (stabilisateur automatique : la projection ajuste ces dépenses à l'écart
  avec le nombre courant de chômeurs). -/
  chomeursComptes : Int := 0
  /-- Passifs implicites des administrations publiques (« dettes cachées ») :
  obligations nées mais non payées ni inscrites dans la dette de
  Maastricht, par type, M€. -/
  passifs : ParPassif := {}
  /-- Nouveaux passifs implicites accumulés chaque année, par type, M€/an
  (flux porté, indexé sur le PIB nominal). -/
  fluxPassifs : ParPassif := {}
  deriving Repr, DecidableEq, Inhabited

namespace Etat

/-- Recettes des administrations publiques, M€. -/
def recettes (s : Etat) : Int := s.impots.total + s.autresRecettes

/-- Dépenses des administrations publiques, M€, charge d'intérêts comprise. -/
def depenses (s : Etat) : Int := s.depensesF.total

/-- Intérêts versés sur la dette, M€. -/
def chargeInterets (s : Etat) : Int := s.depensesF.interets

/-- Heures travaillées dans l'année, millions d'heures. -/
def heuresTotales (s : Etat) : Int := s.emploi.total * s.heuresParEmploi / 1000000

/-- PIB par heure travaillée, €. -/
def pibParHeure (s : Etat) : Int :=
  if s.heuresTotales ≤ 0 then 0 else s.pib * 1000000 / (s.emploi.total * s.heuresParEmploi / 1000)
    / 1000

/-- Emplois en équivalent temps plein (1 607 h), personnes. -/
def emploisEtp (s : Etat) : Int := s.emploi.total * s.heuresParEmploi / 1607

/-- Emploi maximal compatible avec le chômage frictionnel `fricPb`, personnes. -/
def emploiMaximal (s : Etat) (fricPb : Int) : Int := s.actifs * (10000 - fricPb) / 10000

/-- Recettes du tourisme international, M€ (exportations de voyages). -/
def recettesTourisme (s : Etat) : Int := s.touristesMilliers * s.depenseParTouriste / 1000

/-- Accidents du travail avec arrêt dans l'année. -/
def accidentsTravail (s : Etat) : Int := s.emploi.total * s.tauxAccidentsPdm / 10000

/-- Coût annuel des accidents du travail (indemnités, soins, rentes), M€,
pour un coût unitaire donné en €. -/
def coutAccidentsTravail (s : Etat) (coutUnitaire : Int) : Int :=
  s.accidentsTravail * coutUnitaire / 1000000

/-- Journées de travail perdues par accidents, milliers. -/
def joursPerdusAccidents (s : Etat) (joursParAccident : Int) : Int :=
  s.accidentsTravail * joursParAccident / 1000

/-- Décès au travail dans l'année, pour une létalité donnée en décès pour
10 000 accidents. -/
def decesTravail (s : Etat) (letalitePdm : Int) : Int :=
  s.accidentsTravail * letalitePdm / 10000

/-- Balance commerciale (biens et services), M€. -/
def balanceCommerciale (s : Etat) : Int := s.exportations - s.importations

/-- Solde des transactions courantes (balance des paiements), M€. -/
def balanceCourante (s : Etat) : Int := s.balanceCommerciale + s.revenusNets

/-- Solde courant en pb du PIB. -/
def balanceCourantePb (s : Etat) : Int := ratioPb s.balanceCourante s.pib

/-- Heures travaillées par habitant et par an. -/
def heuresParHabitant (s : Etat) : Int :=
  if s.populationMilliers ≤ 0 then 0 else s.emploi.total * s.heuresParEmploi / (s.populationMilliers * 1000)

/-- Déficit public, M€ (positif = déficit). -/
def deficit (s : Etat) : Int := s.depenses - s.recettes

/-- Taux de prélèvements obligatoires, pb du PIB. -/
def prelevementsPb (s : Etat) : Int := ratioPb s.impots.total s.pib

/-- Dépenses hors charge d'intérêts, M€. -/
def depensesPrimaires (s : Etat) : Int := s.depenses - s.chargeInterets

/-- Solde primaire, M€ (positif = excédent). -/
def soldePrimaire (s : Etat) : Int := s.recettes - s.depensesPrimaires

/-- Déficit en pb du PIB. -/
def deficitPb (s : Etat) : Int := ratioPb s.deficit s.pib

/-- Émissions totales, Mt CO₂e (arrondi au Mt le plus proche). -/
def emissionsMt (s : Etat) : Int := (s.emissionsKt.total + 500) / 1000

/-- Émissions d'un secteur, Mt CO₂e (arrondi). -/
def emissionsSecteurMt (s : Etat) (sec : SecteurGes) : Int := (s.emissionsKt.get sec + 500) / 1000

/-- Réduit les émissions du secteur `sec` de `kt` kilotonnes (négatif : hausse). -/
def reduireEmissions (sec : SecteurGes) (kt : Int) (s : Etat) : Etat :=
  { s with emissionsKt := s.emissionsKt.ajouter sec (-kt) }

theorem reduireEmissions_total (sec : SecteurGes) (kt : Int) (s : Etat) :
    (s.reduireEmissions sec kt).emissionsKt.total = s.emissionsKt.total - kt := by
  simp [reduireEmissions, ParSecteurGes.total_ajouter]
  omega

/-- Passifs implicites, tous types, M€. -/
def passifsImplicites (s : Etat) : Int := s.passifs.total

/-- Dette y compris passifs implicites, en pb du PIB. -/
def detteEtenduePb (s : Etat) : Int := ratioPb (s.dette + s.passifsImplicites) s.pib

/-- Dette en pb du PIB. -/
def dettePb (s : Etat) : Int := ratioPb s.dette s.pib

/-- Emploi total, personnes. -/
def emploiTotal (s : Etat) : Int := s.emploi.total

/-- Taux de chômage au sens du BIT, pb (`750` = 7,5 %) : part des actifs
sans emploi. -/
def chomagePb (s : Etat) : Int :=
  if s.actifs ≤ 0 then 0 else (s.actifs - s.emploiTotal) * 10000 / s.actifs

/-- PIB par habitant, €. -/
def pibParHabitant (s : Etat) : Int :=
  if s.populationMilliers = 0 then 0 else s.pib * 1000 / s.populationMilliers

/-- Ajoute `d` aux recettes, au prorata de toutes les recettes (variation
d'assiette générale, par exemple un surcroît d'activité). -/
def ajouterRecettesProrata (s : Etat) (d : Int) : Etat :=
  let r := s.recettes
  let dImpots := if r = 0 then 0 else d * s.impots.total / r
  { s with impots := s.impots.repartir dImpots, autresRecettes := s.autresRecettes + (d - dImpots) }

end Etat

end Modele
