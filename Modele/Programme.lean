import Modele.Propriete

/-!
# Mesures, programmes, engagements

* Une `Mesure` est une liste de leviers, avec la référence de la page du
  programme d'où elle est tirée (traçabilité), et d'éventuels **contrats** :
  des propriétés du dispositif prouvées pour tous les cas (toute commune,
  tout ménage…).
* Un `Programme` est une liste de mesures, plus des **engagements** : les
  couples (scénario, propriété) que ses auteurs revendiquent.

Deux niveaux de vérification :

1. **Engagements** — chaque programme prouve `EngagementsTenus` dans son
   fichier `Engagements.lean`. Si une PR (même sur les hypothèses communes)
   casse un engagement, la compilation échoue : le programme doit retirer
   l'engagement ou modifier ses mesures.
2. **Évaluation** — la matrice complète programme × scénario × propriété est
   calculée par le rapport. Elle est informative : un programme n'est pas
   tenu de satisfaire toutes les propriétés sous tous les scénarios.
-/

namespace Modele

/-- Propriété d'une mesure prouvée une fois pour toutes, typiquement « pour
toute commune » ou « pour tout ménage ». Un contrat ne peut pas exister sans
sa preuve : s'il devient faux (changement de la mesure ou du modèle
commun), la compilation échoue et Lean désigne le contrat cassé.

Différence avec un engagement : un engagement porte sur l'état macro sous
un scénario et se décide par calcul ; un contrat est un énoncé universel
sur le dispositif lui-même et se prouve. -/
structure Contrat where
  titre : String
  enonce : Prop
  preuve : enonce

/-- Variante d'une mesure : même intention, autres paramètres (taux,
origine des véhicules…). Le rapport la compare à la version retenue ; elle
n'entre pas dans l'évaluation du programme. -/
structure Variante where
  nom : String
  leviers : List Levier

structure Mesure where
  /-- Identifiant unique dans le programme, ex. `"R-03"`. -/
  id : String
  titre : String
  /-- Référence dans le document source (page, section, URL). -/
  source : String
  leviers : List Levier
  /-- Propriétés prouvées du dispositif (voir `Contrat`). -/
  contrats : List Contrat := []
  /-- Variantes comparées dans le rapport (voir `Variante`). -/
  variantes : List Variante := []
  /-- Année d'entrée en vigueur, comptée depuis l'année de départ (0 =
  immédiate). Une mesure dont le début dépasse l'horizon n'a aucun effet. -/
  debut : Nat := 0

def Mesure.appliquer (M : Moteur) (H : Scenario) (m : Mesure) (s : Etat) : Etat :=
  m.leviers.foldl (fun s l => l.appliquer M H s) s

structure Engagement where
  scenario : Scenario
  propriete : Propriete
  /-- Moteur sous lequel l'engagement est revendiqué. -/
  moteur : Moteur

/-- Engagement sous le moteur donné. -/
def Engagement.sous (M : Moteur) (H : Scenario) (q : Propriete) : Engagement :=
  ⟨H, q, M⟩

structure Programme where
  /-- Identifiant = nom du dossier dans `Programmes/`. -/
  id : String
  nom : String
  description : String
  /-- Comptes GitHub responsables (repris dans CODEOWNERS). -/
  mainteneurs : List String
  /-- Document source du programme. -/
  source : String
  mesures : List Mesure
  engagements : List Engagement := []

namespace Programme

/-- Applique les mesures qui entrent en vigueur l'année `t`. -/
def appliquerAnnee (p : Programme) (M : Moteur) (H : Scenario) (t : Nat) (s : Etat) : Etat :=
  (p.mesures.filter (·.debut == t)).foldl (fun s m => m.appliquer M H s) s

/-- Situation de départ après application des mesures immédiates. -/
def etatInitial (p : Programme) (M : Moteur) (H : Scenario) : Etat :=
  p.appliquerAnnee M H 0 (etatDepart H)

/-- Projection sur `n` années à partir de l'année `t` : mesures de l'année,
puis une année de projection. -/
def projeterDepuis (p : Programme) (M : Moteur) (H : Scenario) : Nat → Nat → Etat → Etat
  | 0, t, s => p.appliquerAnnee M H t s
  | n + 1, t, s =>
    p.projeterDepuis M H n (t + 1) (anneeSuivante M H (p.appliquerAnnee M H t s))

/-- États successifs sur `n` années (`n + 1` états), mesures appliquées à
leur année d'entrée en vigueur. -/
def trajectoire (p : Programme) (M : Moteur) (H : Scenario) : Nat → Nat → Etat → List Etat
  | 0, t, s => [p.appliquerAnnee M H t s]
  | n + 1, t, s =>
    let s' := p.appliquerAnnee M H t s
    s' :: p.trajectoire M H n (t + 1) (anneeSuivante M H s')

/-- Situation avec le programme après `n` années. -/
def resultatA (p : Programme) (M : Moteur) (H : Scenario) (n : Nat) : Etat :=
  p.projeterDepuis M H n 0 (etatDepart H)

/-- Situation à l'horizon avec le programme. -/
def resultat (p : Programme) (M : Moteur) (H : Scenario) : Etat :=
  p.resultatA M H H.horizon

/-- La propriété `q` tient pour le programme sous le moteur et le scénario,
à l'année propre à la propriété (horizon du scénario par défaut). -/
def Verifie (p : Programme) (M : Moteur) (H : Scenario) (q : Propriete) : Prop :=
  q.tient H (tendancielA M H (q.horizon H)) (p.resultatA M H (q.horizon H))

instance (p : Programme) (M : Moteur) (H : Scenario) (q : Propriete) :
    Decidable (p.Verifie M H q) :=
  inferInstanceAs (Decidable (q.tient H _ _))

/-- Tous les engagements revendiqués sont tenus. -/
def EngagementsTenus (p : Programme) : Prop :=
  ∀ e ∈ p.engagements, p.Verifie e.moteur e.scenario e.propriete

instance (p : Programme) : Decidable p.EngagementsTenus :=
  inferInstanceAs (Decidable (∀ e ∈ p.engagements, _))

end Programme

end Modele
