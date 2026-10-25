import Modele

/-!
# Axe démographique

Ajouter une hypothèse : définir une valeur ci-dessous **et** l'ajouter à
`toutes`. Elle sera automatiquement croisée avec tous les autres axes.
-/

namespace Hypotheses.Demo
open Modele

/-- Décès attribuables (année de départ) : tabac 68 000 en 2023, 11 % des
décès (Santé publique France, février 2026) ; alcool 41 000 en 2015, dont
16 000 cancers (Santé publique France, BEH 2019 ; pas de mise à jour) ;
cancer colorectal ≈ 17 000 (Barré et al., Revue d'épidémiologie et de santé
publique, 2020). -/
def decesAttribuables2025 : ParCause := { tabac := 68000, alcool := 41000, cancerColorectal := 17000 }

/-- Années de vie perdues par décès, dixièmes d'année (hypothèses : âge moyen
au décès par cause non publié) : 15 ans pour le tabac et l'alcool, 12 pour
le cancer colorectal. Pollution de l'air : 11 ans, calés sur l'estimation de
Santé publique France (40 000 décès attribuables aux PM2,5, ≈ 8 mois
d'espérance de vie : 0,67 an × 651 000 décès / 40 000). Accidents du
travail mortels : 30 ans (hypothèse). -/
def anneesVieParDeces : ParCause := { tabac := 150, alcool := 150, cancerColorectal := 120 }

/-- Délai pour que l'effet d'une mesure sur la mortalité soit complet, années
(hypothèses : les cancers dus au tabac répondent en 10 à 30 ans, ceux de
l'alcool plus vite, le dépistage en quelques années). -/
def delaisEffet : ParCause := { tabac := 20, alcool := 10, cancerColorectal := 8 }

def centrale : Demographie where
  id := "demo-centrale"
  description := "Mortalité et migrations de 2025 prolongées, population active quasi stable"
  partPlus65Pb := 2350
  decesMilliers := 651
  hausseDecesMilliers := 9
  soldeMigratoireMilliers := 176
  croissanceActifsPb := -23        -- hors migrations : +0,1 %/an au total − 176 000 × 60 % ≈ −73 000/an
  partActiveMigrantsPm := 600
  gainEsperanceVieCentiemes := 12   -- INSEE, projections 2021 : 80,3 → 87,5 ans (hommes), 85,9 → 90,0 (femmes) de 2025 à 2070
  decesAttribuables := decesAttribuables2025
  anneesVieParDecesDixiemes := anneesVieParDeces
  delaiEffetMortaliteAns := delaisEffet
  anneesVieParDecesPollutionDixiemes := 110
  anneesVieParDecesAccidentDixiemes := 300
  sources := [
    "Décès 651 000 et solde migratoire +176 000 en 2025 (INSEE, bilan démographique 2025)",
    "Hausse des décès : 651 000 en 2025, 690 752 en 2030, 738 019 en 2035 (INSEE, projections de population à l'horizon 2070, scénario central, Insee Première n° 2108, 8 juin 2026), soit ≈ +9 000 par an",
    "Population active : +0,1 %/an au total, ordre de grandeur de la projection INSEE 2022 hors réforme (30 194 milliers en 2030) ; l'effet de l'âge légal passe par les mesures",
    "Part active des migrants : ≈ 60 % du solde migratoire en âge de travailler et actif (INSEE, immigrés et descendants d'immigrés, 2023 : taux d'activité des immigrés 15-64 ans ≈ 68 %, part des 15-64 ans dans les entrées ≈ 85 %)",
    "Part des 65 ans et plus à l'horizon : hypothèse (22,2 % au 1er janvier 2026)"]

def vieillissementRapide : Demographie where
  id := "demo-vieillissement"
  description := "Vieillissement plus rapide : plus de décès, moins de migrations, population active stable"
  partPlus65Pb := 2450
  decesMilliers := 670
  hausseDecesMilliers := 9
  soldeMigratoireMilliers := 140
  croissanceActifsPb := -26        -- hors migrations : population active stable − 140 000 × 60 %
  partActiveMigrantsPm := 600
  gainEsperanceVieCentiemes := 8    -- hypothèse : gains plus lents
  decesAttribuables := decesAttribuables2025
  anneesVieParDecesDixiemes := anneesVieParDeces
  delaiEffetMortaliteAns := delaisEffet
  anneesVieParDecesPollutionDixiemes := 110
  anneesVieParDecesAccidentDixiemes := 300
  sources := ["Variante : hypothèses à sourcer (projections de population INSEE 2021-2070) ; hausse des décès du scénario central de l'INSEE (2026)"]

def toutes : List Demographie := [centrale, vieillissementRapide]

end Hypotheses.Demo
