import Modele
import Hypotheses
import Proprietes

/-!
# Parti communiste français — Plan climat « Empreinte 2050 »

Transcription **partielle et non officielle** du plan climat du PCF
(ecologie.pcf.fr/plan-climat, document « Empreinte 2050 » du 6 novembre
2023, consulté le 21 octobre 2026). Le plan chiffre un investissement
supplémentaire total de 186 Md€/an (7,9 % du PIB), public et privé
confondus, sans en isoler la part des administrations publiques.

Règle de transcription : une mesure devient un levier seulement si la
source donne un montant annuel d'argent public, ou un objectif que le
modèle commun représente (réduction d'émissions). Les prêts à taux zéro,
les financements du pôle public bancaire et les investissements privés
sont cités mais pas imputés aux administrations publiques. Les hypothèses
de conversion sont écrites dans le champ `source`. Aucun engagement n'est
déclaré.

Les parties C (électricité), D (financement) et E du document n'ont pas
pu être lues intégralement : les mesures du nucléaire sont reprises du
discours de présentation et de la presse (voir README.md).
-/

namespace Programmes.PCF
open Modele

def plan : String := "Empreinte 2050 (PCF, 6 novembre 2023)"

/-- Coût du programme gouvernemental de 6 EPR2 : 72,8 Md€ (euros 2020),
devis EDF du 18 décembre 2025, dont au moins la moitié financée par un prêt
de l'État (accord État-EDF, juin 2025). Hypothèse : même coût unitaire et
même schéma de financement pour les 20 EPR2 du plan, prêt versé de 2027
(année 2 de la projection) à 2050, soit 24 ans : 72 800 / 6 × 20 / 2 / 24
≈ 5 055 M€/an. Les 12 SMR ne sont
pas chiffrés. -/
def pretEPR : Int := 5055

def mesures : List Mesure := [
  { id := "PC-01", titre := "Investissement ferroviaire supplémentaire"
    source := s!"{plan}, B.1 Transports, p. 15 : « 10 milliards d'euros par an » ; trafic voyageurs × 2,6, part du rail en longue distance de 10 à 40 % d'ici 2045"
    leviers := [.depenseSecteur .construction 10000] },
  { id := "PC-02", titre := "Réseau cyclable : 100 000 km de voies"
    source := s!"{plan}, B.1 Transports, p. 14 : « 1 milliard d'euros par an » ; part modale du vélo de 1 à 6 %"
    leviers := [.depenseSecteur .construction 1000] },
  { id := "PC-03", titre := "Rénovation thermique du parc de logements privés"
    source := s!"{plan}, B.2 Logement, p. 22 : « 10 milliards d'euros d'argent public seront investis chaque année », complétés par 15 Md€/an de prêts à taux zéro (banques et Action logement, non imputés) ; 900 000 rénovations moyennes et 264 000 profondes par an dès 2032"
    leviers := [.depenseSecteur .construction 10000] },
  { id := "PC-04", titre := "Rénovation du parc de bâtiments publics"
    source := s!"{plan}, B.2 Logement, p. 22 : « 7 milliards d'euros par an »"
    leviers := [.depenseSecteur .construction 7000] },
  { id := "PC-05", titre := "Rénovation du parc social"
    source := s!"{plan}, B.2 Logement, p. 22 : « jusqu'à 8 milliards d'euros par an », financeur non précisé (bailleurs sociaux hors administrations publiques) : non imputé"
    leviers := [] },
  { id := "PC-06", titre := "Décarbonation du bâtiment : −53 % d'émissions d'ici 2030"
    source := s!"{plan}, B.2 Logement, p. 20 et 25 : « −53 % d'ici 2030 », sortie du fioul en 2030, pompes à chaleur dans 65 % des logements. Conversion : 60 Mt CO₂e d'émissions du bâtiment en 2023 (Citepa, hypothèse) × 53 % ≈ 32 Mt ; coût porté par PC-03 et PC-04"
    leviers := [.transition 32 0] },
  { id := "PC-07", titre := "Décarbonation des transports : −11 % d'émissions en 2030"
    source := s!"{plan}, B.1 Transports, p. 13 et 19 : « baisse de 11 % en 2030, 43 % en 2035 » ; fin des ventes de véhicules thermiques neufs en 2035. Conversion : 126 Mt CO₂e des transports en 2023 (Citepa, hypothèse) × 11 % ≈ 14 Mt ; coût porté par PC-01 et PC-02"
    leviers := [.transition 14 0] },
  { id := "PC-08", titre := "Programme nucléaire : 20 EPR2 et 12 SMR d'ici 2050"
    source := s!"Discours de présentation du plan (F. Roussel, 6 novembre 2023) : « 20 réacteurs EPR2 et 12 réacteurs modulaires (SMR NUWARD) d'ici 2050 », prolongation du parc au-delà de 60 ans. Financement : hypothèse du schéma gouvernemental (voir `pretEPR`), soit {pretEPR} M€/an de prêt de l'État à EDF"
    leviers := [.pretEtat pretEPR]
    debut := 2 },
  { id := "PC-10", titre := "Électrification du parc : fin des ventes thermiques en 2035, 2,5 millions de voitures par an"
    source := s!"{plan}, B.1 Transports, p. 17-18 et B.3, p. 29 : parc entièrement électrifié en 2048, capacité de 2,5 millions de voitures par an d'ici 2035 ; conversion : +500 000 électriques par an au-delà de la tendance, sans prime (interdiction), coût public nul ; bornes correspondantes non chiffrées par la source"
    leviers := [.aideAchatElectrique 500000 0] },
  { id := "PC-09", titre := "Nationalisation de BNP Paribas et de TotalEnergies"
    source := "Discours de présentation du plan (6 novembre 2023) et presse ; prise de participation sans montant dans la source : non imputée"
    leviers := [] }
]

def programme : Programme where
  id := "PCF"
  nom := "Parti communiste français — Empreinte 2050"
  description := "Transcription partielle et non officielle du plan climat « Empreinte 2050 » : 28 Md€/an de dépenses publiques chiffrées (ferroviaire, vélo, rénovation), réductions d'émissions annoncées pour 2030, programme de 20 EPR2 financé par prêt de l'État. La source annonce 186 Md€/an d'investissement total, public et privé."
  mainteneurs := ["@orientationd"]
  source := "https://ecologie.pcf.fr/plan-climat/ et document « Empreinte 2050 » (consultés le 21 octobre 2026)"
  mesures := mesures

end Programmes.PCF
