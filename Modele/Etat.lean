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
santé) croissent de `robotisationPb` de moins. -/
def croitrePrimaires (v : ParFonction) (tauxPb robotisationPb : Int) : ParFonction :=
  let g (x : Int) := x + appliquerPb x tauxPb
  let r (x : Int) := x + appliquerPb x (tauxPb - robotisationPb)
  { retraites := g v.retraites, sante := r v.sante, famille := g v.famille
    enseignement := g v.enseignement, affairesEconomiques := r v.affairesEconomiques
    defense := g v.defense, securiteJustice := g v.securiteJustice
    logementEnvironnement := g v.logementEnvironnement, culture := g v.culture
    interets := v.interets, fonctionnement := r v.fonctionnement, nonVentile := g v.nonVentile }

end ParFonction

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
