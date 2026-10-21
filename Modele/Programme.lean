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

structure Mesure where
  /-- Identifiant unique dans le programme, ex. `"R-03"`. -/
  id : String
  titre : String
  /-- Référence dans le document source (page, section, URL). -/
  source : String
  leviers : List Levier
  /-- Propriétés prouvées du dispositif (voir `Contrat`). -/
  contrats : List Contrat := []

def Mesure.appliquer (H : Scenario) (m : Mesure) (s : Etat) : Etat :=
  m.leviers.foldl (fun s l => l.appliquer H s) s

structure Engagement where
  scenario : Scenario
  propriete : Propriete

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

/-- Situation de départ après application des mesures. -/
def etatInitial (p : Programme) (H : Scenario) : Etat :=
  p.mesures.foldl (fun s m => m.appliquer H s) H.reference.etat

/-- Situation à l'horizon avec le programme. -/
def resultat (p : Programme) (H : Scenario) : Etat :=
  projeter H (p.etatInitial H)

/-- Tous les engagements revendiqués sont tenus. -/
def EngagementsTenus (p : Programme) : Prop :=
  ∀ e ∈ p.engagements,
    e.propriete.tient e.scenario (tendanciel e.scenario) (p.resultat e.scenario)

instance (p : Programme) : Decidable p.EngagementsTenus :=
  inferInstanceAs (Decidable (∀ e ∈ p.engagements, _))

end Programme

end Modele
