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

/-! ## Impôts et cotisations -/

/-- Grands prélèvements obligatoires. -/
inductive Impot where
  | tva | ir | csgCrds | cotisations | impotSocietes | accisesEnergie | taxeFonciere | autres
  deriving Repr, DecidableEq, Inhabited

namespace Impot

def tous : List Impot :=
  [.tva, .ir, .csgCrds, .cotisations, .impotSocietes, .accisesEnergie, .taxeFonciere, .autres]

def nom : Impot → String
  | .tva => "TVA"
  | .ir => "Impôt sur le revenu"
  | .csgCrds => "CSG et CRDS"
  | .cotisations => "Cotisations sociales"
  | .impotSocietes => "Impôt sur les sociétés"
  | .accisesEnergie => "Accise sur les énergies (TICPE)"
  | .taxeFonciere => "Taxe foncière"
  | .autres => "Autres impôts"

def id : Impot → String
  | .tva => "tva"
  | .ir => "ir"
  | .csgCrds => "csgCrds"
  | .cotisations => "cotisations"
  | .impotSocietes => "impotSocietes"
  | .accisesEnergie => "accisesEnergie"
  | .taxeFonciere => "taxeFonciere"
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
  | .autres => { v with autres := v.autres + d }

def total (v : ParImpot) : Int :=
  v.tva + v.ir + v.csgCrds + v.cotisations + v.impotSocietes + v.accisesEnergie
    + v.taxeFonciere + v.autres

/-- Chaque prélèvement croît du même taux (pb), assiettes supposées
proportionnelles au PIB nominal. -/
def croitre (v : ParImpot) (tauxPb : Int) : ParImpot :=
  { tva := v.tva + appliquerPb v.tva tauxPb, ir := v.ir + appliquerPb v.ir tauxPb
    csgCrds := v.csgCrds + appliquerPb v.csgCrds tauxPb
    cotisations := v.cotisations + appliquerPb v.cotisations tauxPb
    impotSocietes := v.impotSocietes + appliquerPb v.impotSocietes tauxPb
    accisesEnergie := v.accisesEnergie + appliquerPb v.accisesEnergie tauxPb
    taxeFonciere := v.taxeFonciere + appliquerPb v.taxeFonciere tauxPb
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
  { tva := v.tva + a, ir := v.ir + b, csgCrds := v.csgCrds + c
    cotisations := v.cotisations + e, impotSocietes := v.impotSocietes + f
    accisesEnergie := v.accisesEnergie + g, taxeFonciere := v.taxeFonciere + h
    autres := v.autres + (d - a - b - c - e - f - g - h) }

end ParImpot

/-! ## État -/

structure Etat where
  /-- PIB, M€ courants. -/
  pib : Int
  /-- Impôts et cotisations sociales, par prélèvement, M€. -/
  impots : ParImpot
  /-- Recettes non fiscales (ventes, revenus de la propriété…), M€. -/
  autresRecettes : Int
  /-- Dépenses des administrations publiques, M€. -/
  depenses : Int
  /-- Dette publique, M€. -/
  dette : Int
  /-- SMIC mensuel brut, €. -/
  smicMensuel : Int
  /-- Émissions territoriales de gaz à effet de serre, MtCO₂e. -/
  emissionsMt : Int
  /-- Âge légal de départ à la retraite, mois. -/
  ageLegalMois : Int
  /-- Population, milliers. -/
  populationMilliers : Int
  /-- Population active au sens du BIT, personnes. -/
  actifs : Int
  /-- Personnes en emploi, par secteur. -/
  emploi : ParSecteur
  deriving Repr, DecidableEq, Inhabited

namespace Etat

/-- Recettes des administrations publiques, M€. -/
def recettes (s : Etat) : Int := s.impots.total + s.autresRecettes

/-- Déficit public, M€ (positif = déficit). -/
def deficit (s : Etat) : Int := s.depenses - s.recettes

/-- Déficit en pb du PIB. -/
def deficitPb (s : Etat) : Int := ratioPb s.deficit s.pib

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
