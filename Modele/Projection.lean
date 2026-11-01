import Modele.Leviers

/-!
# Projection à l'horizon

Le même moteur projette le tendanciel et chaque programme :

* `tendanciel H = projeter H (situation de départ)`
* `avecProgramme H = projeter H (situation de départ + mesures)`

Les mesures sont appliquées l'année de leur entrée en vigueur (`Mesure.debut`,
0 par défaut) puis portées par la projection : leurs effets sur le solde
s'accumulent dans la dette, dont la charge d'intérêts suit.
-/

namespace Modele

/-- Croissances de l'année des assiettes et de leurs déterminants, pb. -/
structure CroissanceAssiettes where
  /-- Masse salariale, pensions, consommation des ménages. -/
  masse : Int
  pensions : Int
  consommation : Int
  /-- Excédent des entreprises de l'année ; bénéfice fiscal des deux
  exercices précédents. -/
  excedent : Int
  beneficePrecedent : Int
  beneficeAvant : Int
  /-- Revenus des indépendants et du capital. -/
  independants : Int
  capital : Int
  /-- Part cyclique de la croissance de la masse salariale (élasticité au
  cycle × variation de l'écart de production). -/
  masseCycle : Int
  /-- PIB en valeur, PIB en valeur à la croissance potentielle (tendance),
  PIB en volume, variation de l'écart de production. -/
  pibNominal : Int
  pibTendance : Int
  volume : Int
  cycle : Int
  /-- Inflation de l'année précédente (revalorisation du barème de l'IR). -/
  inflationPrecedente : Int
  /-- Revalorisation des valeurs locatives ; valeur des transactions
  immobilières. -/
  revalorisationFonciere : Int
  immobilier : Int
  deriving Repr

/-- Croissance du bénéfice fiscal de l'exercice pour une croissance `g` de
l'excédent des entreprises, pb : celle de la tendance (`tendance`, PIB en
valeur à la croissance potentielle), plus `elasticiteIsPm` fois l'écart de
l'excédent à cette tendance (amortissements et intérêts suivent la
tendance, pas le cycle ni les marges : le bénéfice amplifie leurs
variations, pas la croissance de long terme). -/
def Assiettes.beneficeFiscal (A : Assiettes) (tendance g : Int) : Int :=
  tendance + (g - tendance) * A.elasticiteIsPm / 1000

/-- Croissance de l'IS encaissé, pb, pour une croissance du bénéfice fiscal
`g0` de l'exercice de l'année, `g1` de l'exercice précédent et `g2` de
celui d'avant (règles de paiement, art. 1668 du CGI) :

* les entreprises au cinquième acompte (part `partIsAnneeCourantePm` de
  l'IS) paient dans l'année l'IS de l'exercice ;
* les autres paient des acomptes égaux à l'IS de l'exercice précédent, ou à
  celui de l'exercice si leur bénéfice baisse (modulation des acomptes), et
  le solde de l'exercice précédent : IS dû moins acomptes versés.

Calcul exact en niveaux relatifs (IS dû de l'exercice précédent = 10 000). -/
def Assiettes.croissanceIs (A : Assiettes) (g0 g1 g2 : Int) : Int :=
  let u : Int := 10000
  let l0 := u + g0
  let l1 := u
  let l2 := if u + g1 ≤ 0 then u else u * u / (u + g1)
  let l3 := if u + g2 ≤ 0 then l2 else l2 * u / (u + g2)
  let a0 := min l1 l0
  let a1 := min l2 l1
  let a2 := min l3 l2
  let c0 := a0 + l1 - a1
  let c1 := a1 + l2 - a2
  let p := A.partIsAnneeCourantePm
  let encaisse := p * l0 + (1000 - p) * c0
  let encaissePrec := p * l1 + (1000 - p) * c1
  if encaissePrec ≤ 0 then g0 else (encaisse - encaissePrec) * u / encaissePrec

/-- Croissance de chaque prélèvement selon son assiette, pb (`eAutres` :
élasticité au cycle des autres impôts).

* **IR** : assiette pondérée (salaires, pensions, revenus des indépendants
  et du capital) ; barème revalorisé de l'inflation de l'année précédente, la
  progressivité ne jouant que sur la hausse de l'assiette au-delà.
* **CSG-CRDS** : taux proportionnels sur les revenus d'activité, de
  remplacement et du capital.
* **Cotisations** : masse salariale ; l'élasticité `elasticiteCotisationsPm`
  (plafond, allègements) ne joue que sur sa part cyclique.
* **TVA** : consommation des ménages.
* **IS** : le bénéfice fiscal de l'exercice suit l'excédent des entreprises
  (`Assiettes.beneficeFiscal`) ; l'IS encaissé suit les règles d'acomptes et
  de solde (`Assiettes.croissanceIs`).
* **Accises sur l'énergie** : tarifs par unité, assiette en volume.
* **Taxe foncière** : valeurs locatives revalorisées du coefficient légal
  (inflation de novembre à novembre), plus la croissance physique des bases.
* **Droits de mutation à titre onéreux** : valeur des transactions
  immobilières.
* **Droits de succession, patrimoine** : PIB nominal (les droits sont
  corrigés du flux successoral dans `anneeSuivante`).
* **Autres impôts** : PIB nominal et cycle. -/
def Assiettes.taux (A : Assiettes) (eAutres : Int) (c : CroissanceAssiettes) : ParImpot :=
  let gAssietteIr := (A.irSalairesPm * c.masse + A.irPensionsPm * c.pensions
    + A.irIndependantsPm * c.independants
    + (1000 - A.irSalairesPm - A.irPensionsPm - A.irIndependantsPm) * c.capital) / 1000
  let gIr := gAssietteIr + (A.progressiviteIrPm - 1000) * (gAssietteIr - c.inflationPrecedente) / 1000
  let gCsg := (A.csgActivitePm * c.masse + A.csgRemplacementPm * c.pensions
    + (1000 - A.csgActivitePm - A.csgRemplacementPm) * c.capital) / 1000
  let gIs := A.croissanceIs (A.beneficeFiscal c.pibTendance c.excedent) c.beneficePrecedent c.beneficeAvant
  { tva := c.consommation, ir := gIr, csgCrds := gCsg
    cotisations := c.masse + (A.elasticiteCotisationsPm - 1000) * c.masseCycle / 1000, impotSocietes := gIs
    accisesEnergie := c.volume * A.elasticiteCarburantsPm / 1000
    taxeFonciere := c.revalorisationFonciere + A.croissancePhysiqueFoncierPb
    droitsMutation := c.pibNominal, mutationsOnereuses := c.immobilier, patrimoine := c.pibNominal
    autres := c.pibNominal + (eAutres - 1000) * c.cycle / 1000 }

/-- Effet de long terme du prix du pétrole sur les émissions d'un usage, ppm
du niveau du secteur : élasticité-prix de long terme × élasticité du prix
TTC au Brent × écart du Brent au prix de référence × part de l'usage dans
les émissions du secteur (négatif quand le Brent est plus cher). -/
def effetPrixCiblePpm (E : Energie) (elasticitePrix elasticiteBrent part : Int) : Int :=
  if E.prixReferenceDollars = 0 then 0 else
  let ecartBrentPm := (E.prixBrentDollars - E.prixReferenceDollars) * 1000 / E.prixReferenceDollars
  -- borné à −90 % (relation linéaire, Brent extrême)
  max (-900000) (0 - elasticitePrix * elasticiteBrent * ecartBrentPm * part / 1000000)

/-- Émissions de l'année suivante avant les mesures, et effets du prix du
pétrole appliqués aux transports et aux bâtiments (ppm) :
* baisse tendancielle de chaque secteur (`baisseEmissionsSecteurPm`) ;
* écart d'activité : `élasticité × (croissance en volume du scénario −
  croissance de calage)` (`elasticitesEmissionsActivitePm`), nul au
  scénario central et indépendant des mesures et du moteur ;
* prix du pétrole : l'effet sur les carburants des voitures et utilitaires
  légers et sur le fioul des bâtiments rejoint chaque année une part
  (`ajustementPrixEmissionsPm`) de son niveau de long terme
  (`effetPrixCiblePpm`), nul au prix de référence. -/
def emissionsSuivantes (H : Scenario) (k : Nat) (s : Etat) :
    ParSecteurGes × Int × Int :=
  let E := H.energie
  let el := H.eco.elasticitesEmissionsActivitePm
  -- croissance du scénario, hors effets des mesures et du moteur
  let ecart := H.eco.croissanceVolumeA k - H.eco.croissanceCalageEmissionsA k
  let activite : ParSecteurGes :=
    { transports := el.transports * ecart / 10, batiments := el.batiments * ecart / 10
      agriculture := el.agriculture * ecart / 10, industrie := el.industrie * ecart / 10
      energie := el.energie * ecart / 10, dechets := el.dechets * ecart / 10 }
  let e := (s.emissionsKt.baisser H.eco.baisseEmissionsSecteurPm).ajusterPpm activite
  let cibleT := effetPrixCiblePpm E E.elasticitesPrix.carburantsRoutiers
    E.elasticitePrixCarburantsBrentPm E.partTransportsVoituresPm
  let cibleB := effetPrixCiblePpm E E.elasticitesPrix.chauffageFossile
    E.elasticitePrixFioulBrentPm E.partBatimentsFioulPm
  let nT := s.effetPrixTransportsPpm + (cibleT - s.effetPrixTransportsPpm) * E.ajustementPrixEmissionsPm / 1000
  let nB := s.effetPrixBatimentsPpm + (cibleB - s.effetPrixBatimentsPpm) * E.ajustementPrixEmissionsPm / 1000
  ({ e with
      transports := e.transports * (1000000 + nT) / (1000000 + s.effetPrixTransportsPpm)
      batiments := e.batiments * (1000000 + nB) / (1000000 + s.effetPrixBatimentsPpm) }, nT, nB)

/-- Canal du capital, une année (moteurs où `canalCapitalPm` > 0 ; sans
effet sinon). L'investissement public de l'année écoulée s'ajoute au capital
public des mesures (`investissementAnnee`, M€), réévalué aux prix (`prix`,
pb, déflateur du PIB) et déprécié. Le PIB potentiel augmente
de `élasticité × capital des mesures / capital public total`, le capital
public total valant `stockCapitalPublicPibPm` du PIB. Le capital des
entreprises rejoint progressivement le niveau que fixe le taux effectif
d'IS des mesures. Chocs d'offre : recettes au prorata, sans effet d'Okun
(comme le volume d'heures). -/
def canalCapital (M : Moteur) (H : Scenario) (prix investissementAnnee : Int) (s : Etat) : Etat :=
  let E := H.eco
  let k := s.capitalPublicMesures - appliquerPm s.capitalPublicMesures E.depreciationCapitalPublicPm
    + investissementAnnee
  let k := k + appliquerPb k prix
  let publicPpm := if s.pib = 0 then 0
    else k * E.elasticitePibCapitalPublicPm * 1000000 / (E.stockCapitalPublicPibPm * s.pib)
  let ciblePrivePpm := -(s.ecartTauxISPb * E.effetPibLongTermePointISPpm / 100)
  let privePpm := s.effetCapitalPrivePpm
    + (ciblePrivePpm - s.effetCapitalPrivePpm) * E.ajustementCapitalPrivePm / 1000
  let dPpm := (publicPpm - s.effetCapitalPublicPpm) + (privePpm - s.effetCapitalPrivePpm)
  let dPib := s.pib * dPpm * M.canalCapitalPm / 1000000000
  let dRecettes := if s.pib = 0 then 0 else dPib * s.recettes / s.pib
  { s.ajouterRecettesProrata dRecettes with
    pib := s.pib + dPib
    capitalPublicMesures := k
    effetCapitalPublicPpm := publicPpm
    effetCapitalPrivePpm := privePpm }

/-- Une année de projection sous un moteur. -/
def anneeSuivante (M : Moteur) (H : Scenario) (s : Etat) : Etat :=
  let k := s.rang
  let ref := H.reference.etat
  -- croissance de l'année : trajectoire du scénario (prévisions, puis
  -- croissance potentielle), amputée de l'effet d'offre du moteur
  -- (prélèvements obligatoires au-dessus de leur niveau de départ →
  -- croissance amputée ; en dessous → croissance accrue)
  -- la variation d'IS due au taux fixé par les mesures passe, pour la part
  -- `canalCapitalPm`, par le canal du capital (coût du capital des
  -- entreprises) plutôt que par cet effet générique ; les surtaxes et les
  -- variations cycliques de l'IS y restent
  let poGeneriquePb (e : Etat) : Int :=
    ratioPb (e.impots.total - appliquerPm e.isTauxMeur M.canalCapitalPm - e.smicPrelevementsMeur) e.pib
  let volume := H.eco.croissanceVolumeA k
    - appliquerPm (poGeneriquePb s - poGeneriquePb ref) M.elasticiteCroissancePoPm
  -- courbe de Phillips : l'écart de production de l'année précédente
  -- (trajectoire du scénario et effets de demande des mesures) tire les prix
  let phillips := appliquerPm (s.ecartProductionPb H) H.eco.pentePhillipsPm
  let prix := H.eco.inflationA k + phillips
  let croissance := volume + prix + volume * prix / 10000
  -- variation de l'écart de production : croissance en volume au-delà de la
  -- croissance potentielle (loi d'Okun, élasticités des prélèvements)
  let cycle := volume - H.eco.croissancePotentielleA k
  let pib := s.pib + appliquerPb s.pib croissance
  -- charge d'intérêts sur la dette de fin d'année précédente (effet boule de
  -- neige). Taux du stock : l'ancien stock à son taux, la dette nouvelle de
  -- l'année écoulée au taux d'émission de cette année-là ; puis la part
  -- `renouvellementDettePm` du stock arrive à échéance et est réémise au taux
  -- d'émission de l'année (nominale au taux marginal, indexée au taux réel).
  -- Prime de risque : le taux marginal monte (baisse) de `primeDeficitPb` par
  -- point de déficit au-dessus (au-dessous) du déficit de départ.
  -- en ppm (1 pb = 100 ppm), sur le déficit exact (non arrondi au pb) :
  -- 0,25 pb de taux par pb de déficit
  let deficitPpm (e : Etat) : Int := if e.pib = 0 then 0 else e.deficit * 1000000 / e.pib
  let tauxCiblePpm := max 0 (H.eco.tauxMarginalA k * 100
    + H.eco.primeDeficitPb * (deficitPpm s - deficitPpm ref) / 100)
  let emissionPpm := tauxCiblePpm - H.eco.inflationPb * H.eco.partDetteIndexeePm / 10
  let tauxCible := tauxCiblePpm / 100
  let emission := emissionPpm / 100
  let dette := s.dette
  -- dette à court terme : renouvelée dans l'année au taux court ; dette à
  -- moyen et long terme : taux du stock, puis refinancement d'une part
  let court := dette * H.eco.partDetteCourtTermePm / 1000
  let long := dette - court
  let longDebut := s.detteDebut - s.detteDebut * H.eco.partDetteCourtTermePm / 1000
  -- taux en ppm (1 pb = 100 ppm) : un arrondi au pb sur le stock ferait
  -- sauter la charge d'intérêts de ≈ 470 M€
  let tauxPrecedentPpm := if s.tauxApparentPpm = 0 then s.tauxApparentPb * 100 else s.tauxApparentPpm
  let emissionPrecedentePpm := if s.tauxEmissionPpm = 0 then s.tauxEmissionPb * 100 else s.tauxEmissionPpm
  let tauxStockPpm := if long = 0 then tauxPrecedentPpm
    else (longDebut * tauxPrecedentPpm + (long - longDebut) * emissionPrecedentePpm) / long
  let tauxPpm := tauxStockPpm + (emissionPpm - tauxStockPpm) * H.eco.renouvellementDettePm / 1000
  let taux := tauxPpm / 100
  -- indexation du capital des titres indexés sur l'inflation de l'année,
  -- enregistrée en intérêts (comptabilité nationale)
  let indexation := dette * H.eco.partDetteIndexeePm * H.eco.inflationIndexationA k / 10000000
  -- OAT numériques : la tranche `part` de la dette est servie au taux
  -- apparent diminué de la décote ; ses intérêts, pour la part défiscalisée,
  -- échappent au PFU (perte de recettes de l'année)
  let tranche := dette * s.partDetteNumeriquePm / 1000
  let economieNum := tranche * tauxPpm * s.decoteDetteNumeriquePm / 1000000000
  let interetsTranche := tranche * tauxPpm / 1000000 - economieNum
  let tPfu := H.eco.tauxPfuIrPm + H.eco.tauxPfuCsgCrdsPm + H.eco.tauxPfuSolidaritePm
  let pertePfu := interetsTranche * s.partDefiscaliseePm * tPfu / 1000000
  let interets := long * tauxPpm / 1000000 + court * H.eco.tauxCourtA k / 10000 + indexation - economieNum
  -- la perte de PFU de l'an dernier est déjà dans l'assiette et croît avec
  -- elle : on n'ajoute que l'écart, réparti selon l'affectation du PFU
  let dPerte := pertePfu - (s.pertePfuMeur + appliquerPb s.pertePfuMeur croissance)
  let dIr := if tPfu = 0 then 0 else dPerte * H.eco.tauxPfuIrPm / tPfu
  let dCsg := if tPfu = 0 then 0 else dPerte * H.eco.tauxPfuCsgCrdsPm / tPfu
  -- électrification du parc (règlement (UE) 2023/851) : les ventes
  -- tendancielles de voitures électriques montent jusqu'aux ventes neuves ;
  -- les mesures s'y ajoutent dans la même limite
  let ventes := H.energie.ventesNeuvesMilliers
  let elecTendance := min ventes (s.electrificationTendanceMilliers + H.energie.hausseElectrificationMilliers)
  -- aides : seule la part des ventes qui n'est pas déjà électrique peut
  -- basculer (aubaine) ; obligations : chaque voiture visée
  let aideesAdditionnelles := if ventes = 0 then 0
    else s.electrificationAideePondereeMilliers
      * max 0 (ventes - elecTendance - s.electrificationAnnuelleMilliers) / ventes
  let dParc := max elecTendance
    (min ventes (elecTendance + s.electrificationAnnuelleMilliers + aideesAdditionnelles))
  -- chaque voiture thermique remplacée retire son carburant de l'assiette des
  -- accises et de la TVA (nets des taxes sur l'électricité consommée)
  -- rénovations des mesures : les économies de fioul et de gaz acquises
  -- s'accroissent chaque année du flux porté ; elles retirent l'assiette des
  -- accises et de la TVA sur ces énergies
  let R := H.energie.renovation
  let fioul := s.economiesFioulMWhAnnuelles
  let gaz := s.economiesGazMWhAnnuelles
  -- accise sur le fioul : avec la TICPE (accises sur les énergies) ; accise
  -- sur le gaz naturel : avec les autres impôts
  let pertesAccises := dParc * H.energie.accisesParVehiculeEuros / 1000
    + fioul * R.accisesFioulEurosMWh / 1000000
  let pertesAcciseGaz := gaz * R.accisesGazEurosMWh / 1000000
  let pertesTva := dParc * H.energie.tvaParVehiculeEuros / 1000
    + (fioul * R.tvaFioulEurosMWh + gaz * R.tvaGazEurosMWh) / 1000000
  -- contribution différentielle sur les hauts revenus : elle suit l'IR tant
  -- que le déficit de l'année écoulée atteint 3 % du PIB, puis s'éteint
  let cdhrReconduite := s.cdhrMeur + appliquerPb s.cdhrMeur croissance
  let cdhr := if s.deficitPb < 300 then 0 else cdhrReconduite
  -- droits de succession et de donation : leur assiette suit le flux
  -- successoral (décès × patrimoine transmis par décès), et le rendement
  -- monte plus vite que lui (abattements et barème non indexés)
  let deces := s.decesMilliers + H.demo.hausseDecesMilliers
  let dDecesPb := if s.decesMilliers = 0 then 0
    else H.demo.hausseDecesMilliers * 10000 / s.decesMilliers
  let tauxDroits := dDecesPb
    + (croissance + H.eco.excesPatrimoineParDecesPb) * H.eco.elasticiteDroitsSuccessionPm / 1000
  -- participations de l'État : valorisation au rythme du PIB nominal, plus les
  -- prises de participation ; dividendes au rendement du portefeuille de départ
  let participations := s.participationsEtat + appliquerPb s.participationsEtat croissance
    + s.investissementsParticipations
  let dividendes := if ref.participationsEtat = 0 then s.dividendesEtat
    else participations * ref.dividendesEtat / ref.participationsEtat
  -- recettes non fiscales hors dividendes : acycliques, elles suivent le PIB
  -- nominal potentiel
  let horsDividendes := s.autresRecettes - s.dividendesEtat
  let autresRecettes := horsDividendes + appliquerPb horsDividendes (croissance - cycle) + dividendes
  -- vieillissement : les tendances de dépenses (retraites, santé) intègrent
  -- la démographie de leur projection ; un vieillissement différent ajoute
  -- (ou retire) un surcoût, réparti sur les années de l'horizon
  let surcoutVieillissement :=
    (H.demo.partPlus65Pb - H.reference.partPlus65TendancePb) * H.eco.coutParPbPlus65
      / (H.horizon : Int)
  let surcoutSante :=
    (H.demo.partPlus65Pb - H.reference.partPlus65TendancePb) * H.eco.coutSanteParPbPlus65
      / (H.horizon : Int)
  -- dépenses primaires à législation constante : volume propre à chaque
  -- fonction, prix (pensions et prestations revalorisées sur l'inflation de
  -- l'année écoulée) ; norme de dépense : économie de l'année sur les
  -- fonctions pilotables
  let tauxDep := H.eco.tauxDepenses k s.inflationConsoPb
  -- frein automatique au déficit : norme durcie l'année qui suit un déficit
  -- au-dessus du seuil du levier `freinDeficit`
  let moderation := s.moderationDepensesPb
    + (if s.freinDeficitPb ≠ 0 ∧ s.deficitPb > s.freinDeficitSeuilPb then s.freinDeficitPb else 0)
  let sansNorme := s.depensesF.croitrePrimaires tauxDep s.robotisationPb
  let avecNorme := s.depensesF.croitrePrimaires tauxDep s.robotisationPb
    moderation
  let economieNorme := sansNorme.total - avecNorme.total
  -- règles contracycliques de l'assurance chômage : au-dessus du seuil de
  -- chômage, la durée réduite est complétée (complément de fin de droits) ;
  -- seul l'écart au complément reconduit de l'année passée est une dépense
  -- nouvelle
  let complement := if s.chomagePb < H.reference.seuilChomageContracyclePb ∨ H.reference.etat.pib = 0 then 0
    else H.reference.surcoutComplementChomageMeur * s.pib / H.reference.etat.pib
  let dComplement := complement
    - (s.complementChomageMeur + appliquerPb s.complementChomageMeur (tauxDep.get .famille))
  let depensesF := (((avecNorme
    |>.ajouter .retraites surcoutVieillissement)
    |>.ajouter .sante surcoutSante)
    |>.ajouter .interets (interets - s.depensesF.interets))
    |>.ajouter .famille dComplement
  -- population active : tendance démographique et migrations du scénario
  -- d'une part, migrations dues aux mesures d'autre part
  let solde := H.demo.soldeMigratoireMilliers + s.migrationAnnuelleMilliers
  let actifsTendance := appliquerPb s.actifs H.demo.croissanceActifsPb
    + appliquerPm (H.demo.soldeMigratoireMilliers * 1000) H.demo.partActiveMigrantsPm
  let actifsMesures := appliquerPm (s.migrationAnnuelleMilliers * 1000) H.demo.partActiveMigrantsPm
  -- emploi : la tendance est absorbée au taux d'emploi courant (chômage
  -- tendanciel inchangé) ; les migrants dus aux mesures entrent au taux
  -- d'emploi des immigrés ; l'écart à l'emploi d'équilibre se résorbe
  let emploiTendance := if s.actifs = 0 then 0 else actifsTendance * s.emploiTotal / s.actifs
  let emploiEntrants := appliquerPm actifsMesures H.eco.tauxEmploiMigrantsPm
  let equilibreEntrants := if s.actifs = 0 then 0 else actifsMesures * s.emploiTotal / s.actifs
  let absorption := appliquerPm s.chomeursExcedentaires H.eco.absorptionChomagePm
  -- loi d'Okun : le chômage baisse de `okun × (croissance en volume −
  -- croissance potentielle)` ; emplois et actifs supplémentaires s'en
  -- déduisent par l'effet de flexion
  let actifs := s.actifs + actifsTendance + actifsMesures
  let dChomeursOkun := actifs * cycle * H.eco.okunPm / 10000000
  let emploisOkun := emploisPourChomeurs H dChomeursOkun
  -- **prélèvements sur leur assiette naturelle**
  let A := H.eco.assiettes
  -- rémunération par emploi tendancielle : productivité tendancielle
  -- (croissance potentielle moins croissance tendancielle de l'emploi) et prix
  -- (une part `retardSalairesPm` de l'inflation de l'année précédente, le
  -- reste de celle de l'année)
  let emploi0 := s.emploi.total
  let emploi1 := emploi0 + emploiTendance + emploisOkun
  let productivite := H.eco.croissancePotentielleA k - (if emploi0 = 0 then 0 else emploiTendance * 10000 / emploi0)

  let pc := H.eco.inflationConsoA k + phillips
  let prixSalaires := (A.retardSalairesPm * s.inflationConsoPb + (1000 - A.retardSalairesPm) * pc) / 1000
  let tauxRemuneration := productivite + prixSalaires + productivite * prixSalaires / 10000
  -- masse salariale : tendance (emploi tendanciel, rémunération par emploi)
  -- et cycle, à son élasticité ; l'emploi suit la loi d'Okun, la
  -- rémunération par emploi (heures, primes) le reste
  let croissanceEmploiTendance := if emploi0 = 0 then 0 else emploiTendance * 10000 / emploi0
  let gMasse := croissanceEmploiTendance + tauxRemuneration + croissanceEmploiTendance * tauxRemuneration / 10000
    + A.elasticiteMasseSalarialeCyclePm * cycle / 1000
  let masse0 := s.masseSalariale
  let masse1 := masse0 + appliquerPb masse0 gMasse
  let remuneration := if emploi1 = 0 then s.remunerationParEmploiEuros else masse1 * 1000000 / emploi1
  -- pensions : évolution des dépenses de retraite à législation constante
  let gPensions := ParFonction.tauxCroissance .retraites tauxDep s.robotisationPb
  -- consommation des ménages : volume de l'activité, prix à la consommation
  let gConso := volume + pc + volume * pc / 10000
  -- excédent des entreprises : leur valeur ajoutée (part du PIB) moins leurs
  -- rémunérations (part de la masse salariale) ; taux de chaque prélèvement :
  -- `Assiettes.taux`
  let excedent0 := s.pib * A.partValeurAjouteePm / 1000 - masse0 * A.partSalairesPm / 1000
  let excedent1 := pib * A.partValeurAjouteePm / 1000 - masse1 * A.partSalairesPm / 1000
  let gExcedent := ratioPb (excedent1 - excedent0) excedent0
  let tauxAssiettes := A.taux H.eco.elasticiteCycliquePm.autres
    { masse := gMasse, pensions := gPensions, consommation := gConso, excedent := gExcedent
      beneficePrecedent := s.croissanceBeneficePb, beneficeAvant := s.croissanceBeneficeAvantPb
      independants := croissance + (A.elasticiteIndependantsCyclePm - 1000) * cycle / 1000
      capital := croissance + (A.elasticiteCapitalCyclePm - 1000) * cycle / 1000
      masseCycle := A.elasticiteMasseSalarialeCyclePm * cycle / 1000
      pibNominal := croissance, pibTendance := croissance - cycle
      volume := volume, cycle := cycle, inflationPrecedente := s.inflationConsoPb
      revalorisationFonciere := H.eco.revalorisationFoncierA k s.inflationConsoPb
      immobilier := H.eco.croissanceImmobilierA k croissance }
  -- pompes à chaleur des mesures : taxes sur l'électricité consommée en plus
  -- (flux de l'année, comme les pertes sur le fioul et le gaz) ; coûts de
  -- réseau de gaz évités par les logements qui le quittent, reversés au
  -- financement de la mesure (avec les autres impôts)
  let Pac := H.energie.pac
  let gainsAcciseElec := s.consommationPacHausseGwh * Pac.accisesElecEurosMWh / 1000
  let gainsTvaElec := s.consommationPacHausseGwh * Pac.tvaElecEurosMWh / 1000
  let gainsReseauGaz := s.deraccordementsGazParAn * Pac.reseauGazEvitesEuros / 1000000
  let impots := ((((s.impots.croitreTaux tauxAssiettes).ajouter .ir (-dIr)
    |>.ajouter .csgCrds (-dCsg)) |>.ajouter .autres (-(dPerte - dIr - dCsg))
    |>.ajouter .accisesEnergie (-pertesAccises)) |>.ajouter .tva (-pertesTva))
    |>.ajouter .autres (gainsAcciseElec + gainsReseauGaz - pertesAcciseGaz)
    |>.ajouter .tva gainsTvaElec
    |>.ajouter .ir (cdhr - cdhrReconduite)
    |>.ajouter .droitsMutation (appliquerPb s.impots.droitsMutation (tauxDroits - croissance))
  -- transports : bornes ouvertes au rythme des ventes tendancielles
  -- d'électriques (plus celles des mesures), décès évités par la baisse des
  -- particules, carburant importé évité
  let elec0 := H.energie.electrificationTendancielleMilliers
  let dBornes := (if elec0 = 0 then H.energie.bornesTendanciellesMilliers
    else H.energie.bornesTendanciellesMilliers * elecTendance / elec0) + s.bornesAnnuellesMilliers
  let importsBase := s.importations
  -- électricité : capacités (installations tendancielles et des mesures,
  -- jamais négatives), production aux facteurs de charge sur la capacité
  -- moyenne de l'année, consommation (tendance, voitures électriques du parc
  -- de fin d'année, mesures) ; la production que ni la consommation ni le
  -- solde exportateur maximal n'absorbent est retirée au nucléaire
  let El := H.energie.electricite
  let capacites := s.capacitesMw.plusPositif ((El.ajoutsA k).plus s.ajoutsCapaciteMw).plancherNul
  let consoBase := s.consommationBaseGwh + appliquerPb s.consommationBaseGwh El.croissanceConsommationBasePb
  let consoMesures := s.consommationMesuresGwh + s.consommationPacHausseGwh
  let consoElec := consoBase + (s.parcElectriqueMilliers + dParc) * El.consommationVoitureKwh / 1000
    + consoMesures
  -- stockages des mesures : leur restitution remplace la production
  -- thermique fossile
  let potentiel := ((s.capacitesMw.moyenne capacites).production El.facteurChargePm).ajouter
    .thermique (0 - min s.dechargeStockageGwh ((s.capacitesMw.moyenne capacites).production El.facteurChargePm).thermique)
  let modulation := min potentiel.nucleaire (max 0 (potentiel.total - consoElec - El.ecartProductionMaxGwh))
  -- sols : consommation d'espaces (enveloppe du ZAN où s'imputent les
  -- surfaces des mesures, ou rythme d'avant la loi selon l'écart choisi par
  -- les mesures) ; emprise des installations nouvelles de solaire au sol et
  -- d'éolien terrestre
  -- le solaire des mesures posé sur des toitures n'a pas d'emprise au sol
  let dSolaire := max 0 (capacites.solaire - s.capacitesMw.solaire - s.ajoutsToitureMw)
  let dEolien := max 0 (capacites.eolienTerrestre - s.capacitesMw.eolienTerrestre)
  let haEnergie := dSolaire * El.partSolaireSolPm * El.haParMwSolaireCentiemes / 100000
    + dEolien * El.haParMwEolienCentiemes / 100
  let horsZan := s.surfacesHorsZanMesuresHa.headD {}
  let surfacesAnnee := ((H.sols.surfacesAnnee s.ecartZanPm (s.surfacesMesuresHa.headD {})).plus horsZan).ajouter
    .energie haEnergie
  let emissions := emissionsSuivantes H k s
  let s' : Etat := { s with
    capacitesMw := capacites
    productionGwh := potentiel.ajouter .nucleaire (-modulation)
    modulationGwh := modulation
    consommationBaseGwh := consoBase
    consommationGwh := consoElec
    surfacesAnneeHa := surfacesAnnee
    surfacesHa := s.surfacesHa.plus surfacesAnnee
    surfacesMesuresHa := s.surfacesMesuresHa.tail
    surfacesHorsZanMesuresHa := s.surfacesHorsZanMesuresHa.tail
    surfacesHorsZanHa := s.surfacesHorsZanHa + horsZan.totalEnaf
    consommationMesuresGwh := consoMesures
    -- SMIC : revalorisé chaque année comme les prix à la consommation de
    -- l'année (la revalorisation légale suit l'inflation des ménages modestes
    -- sur les douze mois précédents, plus la moitié du gain de pouvoir
    -- d'achat du salaire horaire des ouvriers et employés, non modélisée ;
    -- 2026 : 1 843 € projetés pour 1 848,69 € en moyenne, deux
    -- revalorisations ayant eu lieu, au 1er janvier et au 1er juin)
    smicMensuel := s.smicMensuel + appliquerPb s.smicMensuel pc
    smicPrelevementsMeur := s.smicPrelevementsMeur + appliquerPb s.smicPrelevementsMeur croissance
    -- investissement public du levier `investissement`, reconduit comme la
    -- dépense de sa fonction (norme comprise)
    investissementPublicMesures := s.investissementPublicMesures.croitrePrimaires tauxDep
      s.robotisationPb moderation
    -- recettes d'IS dues au taux des mesures : elles croissent comme l'IS
    isTauxMeur := if s.impots.impotSocietes = 0 then 0
      else s.isTauxMeur * impots.impotSocietes / s.impots.impotSocietes
    pib := pib
    -- les écarts de demande suivent le PIB nominal
    ecartDemandeMeur := s.ecartDemandeMeur + appliquerPb s.ecartDemandeMeur croissance
    demandeCumuleeMeur := s.demandeCumuleeMeur + appliquerPb s.demandeCumuleeMeur croissance
    impots := impots
    remunerationParEmploiEuros := remuneration
    consommationMenages := s.consommationMenages + appliquerPb s.consommationMenages gConso
    croissanceBeneficePb := A.beneficeFiscal (croissance - cycle) gExcedent
    croissanceBeneficeAvantPb := s.croissanceBeneficePb
    autresRecettes := autresRecettes
    depensesF := depensesF
    tauxApparentPb := taux
    tauxApparentPpm := tauxPpm
    tauxEmissionPpm := emissionPpm
    tauxMarginalCourantPb := tauxCible
    tauxEmissionPb := emission
    chargeIndexationMeur := indexation
    inflationConsoPb := H.eco.inflationConsoA k + phillips
    ecartCycleScenarioPb := s.ecartCycleScenarioPb + (H.eco.croissanceVolumeA k - H.eco.croissancePotentielleA k)
    rang := k + 1
    partDetteNumeriquePm := min s.cibleDetteNumeriquePm (s.partDetteNumeriquePm + s.rythmeDetteNumeriquePm)
    economieInteretsNumeriqueMeur := economieNum
    pertePfuMeur := pertePfu
    cdhrMeur := cdhr
    complementChomageMeur := complement
    allegementsTranche := s.allegementsTranche.croitre croissance
    -- passifs implicites : le stock s'accroît du flux, qui suit les salaires
    passifs := { police := s.passifs.police + s.fluxPassifs.police
                 hopital := s.passifs.hopital + s.fluxPassifs.hopital
                 infrastructures := s.passifs.infrastructures + s.fluxPassifs.infrastructures }
    -- le retard d'entretien suit les prix des travaux (déflateur) ; les
    -- heures suivent les salaires
    fluxPassifs := { police := s.fluxPassifs.police + appliquerPb s.fluxPassifs.police croissance
                     hopital := s.fluxPassifs.hopital + appliquerPb s.fluxPassifs.hopital croissance
                     infrastructures := s.fluxPassifs.infrastructures + appliquerPb s.fluxPassifs.infrastructures prix }
    -- dette de fin d'année : `Etat.dette` (déficit final de l'année, mesures
    -- comprises)
    detteDebut := dette
    ajustementDetteAnnee := 0
    participationsEtat := participations
    dividendesEtat := dividendes
    emissionsKt := emissions.1
    effetPrixTransportsPpm := emissions.2.1
    effetPrixBatimentsPpm := emissions.2.2
    populationMilliers := s.populationMilliers + H.natalite.naissancesMilliers
      - deces + solde
    decesMilliers := deces
    actifs := actifs + (emploisOkun - dChomeursOkun)
    chomeursExcedentaires := s.chomeursExcedentaires - absorption + (equilibreEntrants - emploiEntrants)
    depenseParTouriste := s.depenseParTouriste + appliquerPb s.depenseParTouriste croissance
    -- commerce extérieur : exportations et importations suivent le PIB nominal,
    -- plus les flux d'importations dus aux mesures
    exportations := s.exportations + appliquerPb s.exportations croissance
    importations := importsBase + appliquerPb importsBase croissance + s.variationImportsAnnuelle
      - dParc * H.energie.gainCommercialParVehiculeEuros / 1000
      - (fioul * R.importFioulEurosMWh * H.energie.prixBrentDollars / H.energie.prixReferenceDollars
          + gaz * R.importGazEurosMWh) / 1000000
    electrificationTendanceMilliers := elecTendance
    parcElectriqueMilliers := s.parcElectriqueMilliers + dParc
    bornesMilliers := s.bornesMilliers + dBornes
    decesPollutionAir := max 0 (s.decesPollutionAir
      - dParc * H.energie.decesEvitesParMillionVehicules / 1000)
    -- années de vie gagnées : décès évités par les voitures électriques
    -- ajoutées par les mesures (au-delà des ventes tendancielles)
    anneesVieGagneesParAn := s.anneesVieGagneesParAn
      + (dParc - elecTendance) * H.energie.decesEvitesParMillionVehicules / 1000
        * H.demo.anneesVieParDecesPollutionDixiemes / 10 }
  -- émissions : les voitures électriques ajoutées par les mesures (au-delà
  -- des ventes tendancielles, déjà dans la baisse tendancielle des
  -- émissions) et les rénovations des mesures
  let ktVoitures := (dParc - elecTendance) * H.energie.co2EviteParVehiculeKg / 1000
  let ktRenovation := (fioul * R.co2FioulKgMWh + gaz * R.co2GazKgMWh) / 1000000
  let s' := (s'.reduireEmissions .transports ktVoitures).reduireEmissions .batiments ktRenovation
  let s₁ := ajouterEmploi H none (emploiTendance + emploisOkun) s'
  -- coût du travail : la demande de travail rejoint progressivement l'emploi
  -- visé par les variations d'allègements (emplois des entreprises, qui
  -- produisent : volume d'heures)
  let ajustCout := appliquerPm s.emploisCoutTravailRestants H.eco.ajustementCoutTravailPm
  let ajustPonderes := appliquerPm s.emploisPonderesCoutTravailRestants H.eco.ajustementCoutTravailPm
  let s₁ := chocEmploi H ajustPonderes (chocDemandeTravail H (some .tertiaireMarchand) ajustCout
    { s₁ with emploisCoutTravailRestants := s.emploisCoutTravailRestants - ajustCout
              emploisPonderesCoutTravailRestants := s.emploisPonderesCoutTravailRestants - ajustPonderes })
  -- l'emploi dû aux mesures (entrants, résorption) produit : PIB à l'élasticité
  -- du scénario (la tendance est déjà dans la croissance)
  let dEmploiMesures := emploiEntrants + absorption
  let s₂ := effetDemande H none (appliquerPm dComplement M.multiplicateurPrelevementsPm
      - appliquerPm economieNorme M.multiplicateurEconomiesPm)
    (chocEmploi H dEmploiMesures (ajouterEmploi H none dEmploiMesures s₁))
  -- dépenses à échéancier : niveau prévu (indexé) moins niveau reconduit. Effet
  -- de demande cohérent avec les leviers ponctuels : un niveau positif est une
  -- dépense (multiplicateur plein), un niveau négatif une économie (pondérée
  -- par le moteur) ; l'impulsion de l'année est la variation du niveau pondéré,
  -- si bien que la fin d'une dépense temporaire annule exactement son effet
  let poids (x : Int) : Int := if x < 0 then appliquerPm x M.multiplicateurEconomiesPm else x
  let pas (e : Echeance) : Echeance × Int × Int :=
    -- le niveau inscrit dans la fonction a crû comme elle (norme comprise) ; le
    -- niveau prévu est indexé hors norme (l'échéancier est une décision explicite)
    let t := ParFonction.tauxCroissance e.fonction tauxDep s.robotisationPb
    let tNorme := ParFonction.tauxCroissance e.fonction tauxDep s.robotisationPb
      moderation
    let indice := e.indice + appliquerPb e.indice t
    let reconduit := e.niveau + appliquerPb e.niveau tNorme
    match e.restants with
    | [] => ({ e with indice := indice, niveau := reconduit }, 0, 0)
    | x :: r =>
      let prevu := x * indice / 10000
      -- postes publics : la troisième composante est la variation des effectifs
      -- (prévus moins ceux de l'année précédente), pas l'impulsion
      let troisieme := match e.coutParPosteEuros with
        | some c => if c * e.indice = 0 then 0
            else x * 1000000 / c - e.niveau * 10000000000 / (c * e.indice)
        | none => poids prevu - poids reconduit
      ({ e with restants := r, indice := indice, niveau := prevu }, prevu - reconduit, troisieme)
  let pasEcheances := s.echeances.map pas
  -- la part importée de la dépense (investissement outre-mer) ne soutient
  -- pas l'activité intérieure et suit les importations
  let s₃ : Etat := pasEcheances.foldl
    (fun (st : Etat) ((e, d, impulsion) : Echeance × Int × Int) =>
      match e.remuneration with
      | some nat =>
          -- rémunération d'agents en poste : prélèvements en retour et effet
          -- de demande d'un transfert, sans secteur ni importations
          effetRemuneration M H nat d { st with depensesF := st.depensesF.ajouter e.fonction d }
      | none =>
      match e.coutParPosteEuros with
      | some _ =>
          -- postes publics : la variation de l'échéancier crée (ou supprime) les
          -- emplois publics prévus ; la dépense suit le niveau indexé
          effetCreationPostes H e.fonction d impulsion st
      | none =>
      -- une dépense qui baisse ou s'arrête détruit les emplois du secteur
      -- qu'elle avait créés (intensité en emplois symétrique) ; une économie
      -- (niveau négatif) n'a pas de secteur
      let secteur := if e.niveau < 0 then none else (e.secteur <|> e.fonction.secteur)
      -- investissement privé entraîné : demande et importations, sans dépense
      -- publique
      if e.privee then
        effetDemande H secteur (appliquerPm (impulsion * (e.partInterieurePm - e.substitutionPm) / 1000) H.eco.incidenceInvestissementPm)
          { st with importations := st.importations + d * (1000 - e.partInterieurePm) / 1000 }
      else
      effetDemande H secteur (appliquerPm (impulsion * (e.partInterieurePm - e.substitutionPm) / 1000) (poidsEcheance H e))
        { st with depensesF := st.depensesF.ajouter e.fonction d
                  importations := st.importations + d * (1000 - e.partInterieurePm) / 1000 })
    ({ s₂ with echeances := pasEcheances.map (·.1) } : Etat)
  -- recettes à échéancier : indexées sur le PIB nominal (comme les assiettes) ;
  -- un impôt a l'effet de demande d'un prélèvement, une recette non fiscale aucun
  let pasR (e : EcheanceRecette) : EcheanceRecette × Int :=
    let indice := e.indice + appliquerPb e.indice croissance
    let reconduit := e.niveau + appliquerPb e.niveau croissance
    match e.restants with
    | [] => ({ e with indice := indice, niveau := reconduit }, 0)
    | x :: r =>
      let prevu := x * indice / 10000
      ({ e with restants := r, indice := indice, niveau := prevu }, prevu - reconduit)
  let pasRecettes := s.echeancesRecettes.map pasR
  let s₄ := pasRecettes.foldl
    (fun (st : Etat) ((e, d) : EcheanceRecette × Int) =>
      match e.impot with
      | some i => effetDemande H none (-(appliquerPm d (poidsPrelevement M H i)))
          { st with impots := st.impots.ajouter i d }
      | none => { st with autresRecettes := st.autresRecettes + d })
    ({ s₃ with echeancesRecettes := pasRecettes.map (·.1) } : Etat)
  -- âge légal : le pas du calendrier tendanciel est déjà dans la tendance
  -- (dépenses, population active) ; seul l'écart du calendrier effectif a
  -- les effets d'un recul (ou d'une avance) du départ
  let pasEffectif := s.calendrierAgeLegal.headD 0
  let pasTendanciel := s.calendrierAgeTendanciel.headD 0
  let s₅ : Etat := { s₄ with
    ageLegalMois := s₄.ageLegalMois + pasTendanciel
    calendrierAgeLegal := s.calendrierAgeLegal.tail
    calendrierAgeTendanciel := s.calendrierAgeTendanciel.tail }
  let s₆ := if pasEffectif = pasTendanciel then s₅ else reculDepart H ((pasEffectif - pasTendanciel) * 1000) s₅
  -- IDH : prix, tendances de l'espérance de vie et de la scolarisation, puis
  -- calcul de l'indice
  -- santé publique : la baisse atteinte des décès de chaque cause rejoint la
  -- cible d'un pas égal à cible / délai par an
  let avancer (c : CauseDeces) (v : ParCause) : ParCause :=
    let cible := s₆.baisseMortaliteCiblePm.get c
    let atteinte := s₆.baisseMortaliteAtteintePm.get c
    let delai := max 1 (H.demo.delaiEffetMortaliteAns.get c)
    let pasAn := max 1 (cible / delai)
    v.ajouter c (if atteinte < cible then min pasAn (cible - atteinte)
                 else if atteinte > cible then -(min pasAn (atteinte - cible)) else 0)
  let atteinte := CauseDeces.tous.foldl (fun v c => avancer c v) s₆.baisseMortaliteAtteintePm
  let s₇ : Etat := { s₆ with
    baisseMortaliteAtteintePm := atteinte
    indicePrix := s.indicePrix + appliquerPb s.indicePrix H.eco.inflationPb
    esperanceVieTendanceCentiemes := s.esperanceVieTendanceCentiemes + H.demo.gainEsperanceVieCentiemes
    dureeMoyenneCentiemes := s.dureeMoyenneCentiemes + H.reference.hausseDureeMoyenneCentiemes }
  -- investissement public de l'année écoulée : levier `investissement` et
  -- échéanciers de construction (niveaux de l'année)
  let investissementAnnee := s.investissementPublicMesures.total
    + (s.echeances.filter (fun e => e.secteur = some .construction ∧ !e.privee ∧ e.capitalPublic)).foldl (fun a e => a + e.niveau) 0
  let s₇ := canalCapital M H prix investissementAnnee s₇
  -- résorption des effets de demande des mesures : l'activité revient vers
  -- son potentiel ; une part de l'écart au-delà de sa part durable se
  -- referme (emploi et recettes suivent), sans être suivie comme impulsion
  let resorption := (s₇.ecartDemandeMeur - appliquerPm s₇.demandeCumuleeMeur M.partDemandeDurablePm)
    * M.resorptionDemandePm / 1000
  let s₇ := if resorption = 0 then s₇
    else { chocPib H none (0 - resorption) s₇ with ecartDemandeMeur := s₇.ecartDemandeMeur - resorption }
  -- stabilisateur automatique : l'indemnisation suit les chômeurs de fin
  -- d'année (cycle, tendance et mesures de l'année)
  let s₈ := stabilisateurChomage M H s₇
  { s₈ with idhMillioniemes := calculerIdh H s₈ }

/-- Situation de départ du scénario : la référence observée, après le choc
de niveau dû au prix du pétrole (nul au prix de référence). -/
def etatDepart (H : Scenario) : Etat :=
  let s := H.reference.etat
  -- effet (pb du PIB par tranche de 10 $) × écart de prix / 10 $, sans arrondi intermédiaire
  let dPib := s.pib * H.energie.effetPibPar10DollarsPb
    * (H.energie.prixBrentDollars - H.energie.prixReferenceDollars) / 100000
  -- facture énergétique importée proportionnelle au prix du Brent
  let dImports := H.energie.factureEnergetiqueMeur
    * (H.energie.prixBrentDollars - H.energie.prixReferenceDollars) / H.energie.prixReferenceDollars
  let s := { s with importations := s.importations + dImports, robotisationPb := H.eco.robotisationTendanciellePb
                    tauxMarginalCourantPb := H.eco.tauxMarginalPb
                    electrificationTendanceMilliers := H.energie.electrificationTendancielleMilliers
                    decesMilliers := H.demo.decesMilliers
  }
  let s := chocPib H none dPib s
  -- les chômeurs de départ (choc pétrolier compris) sont ceux que couvrent les
  -- dépenses d'indemnisation de départ
  { s with idhMillioniemes := calculerIdh H s, chomeursComptes := s.actifs - s.emploiTotal }

/-- `f` appliquée `n` fois. -/
def iterer (f : Etat → Etat) : Nat → Etat → Etat
  | 0, s => s
  | n + 1, s => iterer f n (f s)

/-- Projette un état de départ sur `n` années. -/
def projeterN (M : Moteur) (H : Scenario) (n : Nat) (s : Etat) : Etat :=
  iterer (anneeSuivante M H) n s

/-- Projette un état de départ jusqu'à l'horizon du scénario. -/
def projeter (M : Moteur) (H : Scenario) (s : Etat) : Etat :=
  projeterN M H H.horizon s

/-- États successifs sur `n` années, état de départ compris (`n + 1` états). -/
def trajectoire (M : Moteur) (H : Scenario) : Nat → Etat → List Etat
  | 0, s => [s]
  | n + 1, s => s :: trajectoire M H n (anneeSuivante M H s)

/-- Situation sans programme après `n` années. -/
def tendancielA (M : Moteur) (H : Scenario) (n : Nat) : Etat :=
  projeterN M H n (etatDepart H)

/-- Situation à l'horizon sans aucun programme. -/
def tendanciel (M : Moteur) (H : Scenario) : Etat :=
  tendancielA M H H.horizon

end Modele
