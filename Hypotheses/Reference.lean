import Modele

/-!
# Situation de départ

Comptes publics et données démographiques observés pour 2025, point de
départ des projections (année 0). Chaque valeur cite sa source ; les
valeurs marquées « dérivé » sont calculées à partir des évolutions publiées
par l'INSEE (niveau 2025 = hausse publiée × (1 + 1 / taux de hausse)).

Valeurs encore provisoires : SMIC (repère), émissions, âge légal (repère de
64 ans, à rapprocher du calendrier en vigueur).
-/

namespace Hypotheses
open Modele

/-- Emploi BIT 2025, personnes : 31 834 000 actifs × (1 − 7,9 %) = 29 319 000,
réparti selon
la structure de l'emploi 2024 par secteur (INSEE, estimations d'emploi) :
agriculture 2,2 %, industrie 11,2 %, construction 6,4 %, tertiaire marchand
49,8 %, tertiaire non marchand 30,4 %. -/
def emploi2025 : ParSecteur where
  agriculture := 645000
  industrie := 3284000
  construction := 1876000
  tertiaireMarchand := 14601000
  tertiaireNonMarchand := 8913000

/-- Prélèvements 2025, M€. -/
def impots2025 : ParImpot where
  tva := 221100            -- dérivé : +1,1 Md€ soit +0,5 % (INSEE, IR n°78, 27/03/2026)
  ir := 103800             -- dérivé : +7,6 Md€ soit +7,9 % (idem)
  csgCrds := 167200        -- dérivé : +3,6 Md€ soit +2,2 % (idem)
  cotisations := 446300    -- cotisations sociales effectives (idem)
  impotSocietes := 58900   -- dérivé : +2,1 Md€ soit +3,7 % (idem)
  accisesEnergie := 30500  -- TICPE, 30,5 Md€ en 2022, dernier chiffre publié (MTE, via Journal de l'Automobile)
  taxeFonciere := 44100    -- dérivé : TFPB +1,2 Md€ soit +2,8 % (DGCL, note REI 2025)
  autres := 256400         -- solde : impôts 882,0 + cotisations 446,3 − postes ci-dessus

def reference2026 : Reference where
  id := "ref-2025"
  description := "Situation observée en 2025 (INSEE), départ des projections"
  annee := 2025
  etat := {
    pib := 2992000                 -- déficit 152,5 Md€ = 5,1 % et dette 3 460,5 Md€ = 115,6 % (INSEE)
    impots := impots2025
    autresRecettes := 233300       -- recettes totales 1 561,6 Md€ − impôts et cotisations 1 328,3 Md€
    depenses := 1714100            -- dépenses des APU 2025 (INSEE)
    chargeInterets := 64700        -- intérêts versés 2025, +11,2 % (INSEE, IR n°78)
    tauxApparentPb := 187          -- 64,7 / 3 460,5
    dette := 3460500               -- dette de Maastricht fin 2025 (INSEE)
    operationsFinancieres := 0     -- flux nets tendanciels supposés nuls (à sourcer)
    smicMensuel := 1820            -- repère provisoire, brut
    emissionsMt := 370             -- à sourcer (inventaire national, Citepa)
    ageLegalMois := 768            -- repère provisoire : 64 ans
    populationMilliers := 69100    -- population au 1er janvier 2026 (INSEE, bilan démographique 2025)
    actifs := 31834000             -- population active BIT 2025 (INSEE)
    emploi := emploi2025 }         -- chômage BIT 7,9 % fin 2025 (INSEE)
  populationMilliers := 69100
  partPlus65Pb := 2220             -- 22,2 % au 1er janvier 2026 (INSEE)
  sources := [
    "INSEE, Informations rapides n°78, comptes des APU 2025 (27 mars 2026)",
    "INSEE, Bilan démographique 2025, Insee Première n°2087 (13 janvier 2026)",
    "INSEE, population active 2025 ; emploi salarié et non salarié par activité 2024",
    "DGCL, note sur les taux de fiscalité directe locale 2025",
    "Ministère de la Transition écologique : TICPE 2022 (via Journal de l'Automobile, mars 2024)"]

end Hypotheses
