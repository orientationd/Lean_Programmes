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

/-- Une année de projection sous un moteur. -/
def anneeSuivante (M : Moteur) (H : Scenario) (s : Etat) : Etat :=
  -- effet d'offre (moteur) : prélèvements obligatoires au-dessus du niveau
  -- de départ → croissance amputée ; en dessous → croissance accrue
  let croissance := H.eco.croissancePb
    - appliquerPm (s.prelevementsPb - H.reference.etat.prelevementsPb) M.elasticiteCroissancePoPm
  let pib := s.pib + appliquerPb s.pib croissance
  -- charge d'intérêts : taux apparent qui converge vers le taux marginal,
  -- appliqué à la dette de fin d'année précédente (effet boule de neige)
  -- prime de risque : le taux marginal monte (baisse) de `primeDeficitPb` par
  -- point de déficit au-dessus (au-dessous) du déficit de départ ; le taux
  -- apparent s'en rapproche d'au plus `deriveTauxPb` par an, dans les deux sens
  let tauxCible := max 0 (H.eco.tauxMarginalPb
    + H.eco.primeDeficitPb * (s.deficitPb - H.reference.etat.deficitPb) / 100)
  let taux := if s.tauxApparentPb ≤ tauxCible
    then min tauxCible (s.tauxApparentPb + H.eco.deriveTauxPb)
    else max tauxCible (s.tauxApparentPb - H.eco.deriveTauxPb)
  -- OAT numériques : la tranche `part` de la dette est servie au taux
  -- apparent diminué de la décote ; ses intérêts, pour la part défiscalisée,
  -- échappent au PFU (perte de recettes de l'année)
  let tranche := s.dette * s.partDetteNumeriquePm / 1000
  let economieNum := tranche * taux * s.decoteDetteNumeriquePm / 10000000
  let interetsTranche := tranche * taux / 10000 - economieNum
  let tPfu := H.eco.tauxPfuIrPm + H.eco.tauxPfuCsgCrdsPm + H.eco.tauxPfuSolidaritePm
  let pertePfu := interetsTranche * s.partDefiscaliseePm * tPfu / 1000000
  let interets := s.dette * taux / 10000 - economieNum
  -- assiettes supposées proportionnelles au PIB nominal (élasticité unitaire)
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
  let dParc := max elecTendance (min ventes (elecTendance + s.electrificationAnnuelleMilliers))
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
  let impots := ((((s.impots.croitre croissance).ajouter .ir (-dIr)
    |>.ajouter .csgCrds (-dCsg)) |>.ajouter .autres (-(dPerte - dIr - dCsg))
    |>.ajouter .accisesEnergie (-pertesAccises)) |>.ajouter .tva (-pertesTva))
    |>.ajouter .autres (-pertesAcciseGaz)
    |>.ajouter .ir (cdhr - cdhrReconduite)
    |>.ajouter .droitsMutation (appliquerPb s.impots.droitsMutation (tauxDroits - croissance))
  -- participations de l'État : valorisation au rythme du PIB nominal, plus les
  -- prises de participation ; dividendes au rendement du portefeuille de départ
  let participations := s.participationsEtat + appliquerPb s.participationsEtat croissance
    + s.investissementsParticipations
  let ref := H.reference.etat
  let dividendes := if ref.participationsEtat = 0 then s.dividendesEtat
    else participations * ref.dividendesEtat / ref.participationsEtat
  let horsDividendes := s.autresRecettes - s.dividendesEtat
  let autresRecettes := horsDividendes + appliquerPb horsDividendes croissance + dividendes
  let recettes := impots.total + autresRecettes
  -- vieillissement : le surcoût total à l'horizon est réparti sur les années
  let surcoutVieillissement :=
    (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * H.eco.coutParPbPlus65
      / (H.horizon : Int)
  let surcoutSante :=
    (H.demo.partPlus65Pb - H.reference.partPlus65Pb) * H.eco.coutSanteParPbPlus65
      / (H.horizon : Int)
  -- norme de dépense : économie de l'année sur les fonctions pilotables
  let sansNorme := s.depensesF.croitrePrimaires H.eco.croissanceDepensesPb s.robotisationPb
  let avecNorme := s.depensesF.croitrePrimaires H.eco.croissanceDepensesPb s.robotisationPb
    s.moderationDepensesPb
  let economieNorme := sansNorme.total - avecNorme.total
  -- stabilisateur automatique : l'indemnisation suit le nombre de chômeurs
  -- (écart à ceux que les dépenses inscrites couvrent déjà)
  let chomeurs := s.actifs - s.emploiTotal
  let indemnisation := if H.reference.etat.pib = 0 then 0
    else (chomeurs - s.chomeursComptes) * H.eco.coutParChomeurEuros * s.pib
      / (H.reference.etat.pib * 1000000)
  let depensesF := (((avecNorme
    |>.ajouter .retraites surcoutVieillissement)
    |>.ajouter .sante surcoutSante)
    |>.ajouter .interets (interets - s.depensesF.interets))
    |>.ajouter .famille indemnisation
  let depenses := depensesF.total
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
  -- loi d'Okun : le chômage baisse de `okun × (croissance − seuil)` ; emplois
  -- et actifs supplémentaires s'en déduisent par l'effet de flexion
  let actifs := s.actifs + actifsTendance + actifsMesures
  let dChomeursOkun := actifs * (croissance - H.eco.seuilOkunPb) * H.eco.okunPm / 10000000
  let emploisOkun := emploisPourChomeurs H dChomeursOkun
  -- transports : bornes ouvertes au rythme des ventes tendancielles
  -- d'électriques (plus celles des mesures), décès évités par la baisse des
  -- particules, carburant importé évité
  let elec0 := H.energie.electrificationTendancielleMilliers
  let dBornes := (if elec0 = 0 then H.energie.bornesTendanciellesMilliers
    else H.energie.bornesTendanciellesMilliers * elecTendance / elec0) + s.bornesAnnuellesMilliers
  let importsBase := s.importations
  let s' : Etat := { s with
    pib := pib
    impots := impots
    autresRecettes := autresRecettes
    depensesF := depensesF
    tauxApparentPb := taux
    tauxMarginalCourantPb := tauxCible
    partDetteNumeriquePm := min s.cibleDetteNumeriquePm (s.partDetteNumeriquePm + s.rythmeDetteNumeriquePm)
    economieInteretsNumeriqueMeur := economieNum
    pertePfuMeur := pertePfu
    cdhrMeur := cdhr
    chomeursComptes := chomeurs
    -- passifs implicites : le stock s'accroît du flux, qui suit les salaires
    passifsImplicites := s.passifsImplicites + s.fluxPassifsImplicites
    fluxPassifsImplicites := s.fluxPassifsImplicites + appliquerPb s.fluxPassifsImplicites croissance
    dette := s.dette + (depenses - recettes) + s.operationsFinancieres + s.investissementsParticipations
    participationsEtat := participations
    dividendesEtat := dividendes
    emissionsKt := s.emissionsKt.baisser H.eco.baisseEmissionsSecteurPm
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
      - dParc * H.energie.decesEvitesParMillionVehicules / 1000) }
  -- émissions : les voitures électriques ajoutées par les mesures (au-delà
  -- des ventes tendancielles, déjà dans la baisse tendancielle des
  -- émissions) et les rénovations des mesures
  let ktVoitures := (dParc - elecTendance) * H.energie.co2EviteParVehiculeKg / 1000
  let ktRenovation := (fioul * R.co2FioulKgMWh + gaz * R.co2GazKgMWh) / 1000000
  let s' := (s'.reduireEmissions .transports ktVoitures).reduireEmissions .batiments ktRenovation
  let s₁ := ajouterEmploi H none (emploiTendance + emploisOkun) s'
  -- l'emploi dû aux mesures (entrants, résorption) produit : PIB à l'élasticité
  -- du scénario (la tendance est déjà dans la croissance)
  let dEmploiMesures := emploiEntrants + absorption
  let s₂ := effetDemande H none (appliquerPm indemnisation M.multiplicateurPrelevementsPm
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
    let t := ParFonction.tauxCroissance e.fonction H.eco.croissanceDepensesPb s.robotisationPb
    let tNorme := ParFonction.tauxCroissance e.fonction H.eco.croissanceDepensesPb s.robotisationPb
      s.moderationDepensesPb
    let indice := e.indice + appliquerPb e.indice t
    let reconduit := e.niveau + appliquerPb e.niveau tNorme
    match e.restants with
    | [] => ({ e with indice := indice, niveau := reconduit }, 0, 0)
    | x :: r =>
      let prevu := x * indice / 10000
      ({ e with restants := r, indice := indice, niveau := prevu }, prevu - reconduit,
        poids prevu - poids reconduit)
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
      -- une dépense qui baisse ou s'arrête détruit les emplois du secteur
      -- qu'elle avait créés (intensité en emplois symétrique) ; une économie
      -- (niveau négatif) n'a pas de secteur
      let secteur := if e.niveau < 0 then none else (e.secteur <|> e.fonction.secteur)
      effetDemande H secteur (impulsion * e.partInterieurePm / 1000)
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
      | some i => effetDemande H none (-(appliquerPm d M.multiplicateurPrelevementsPm))
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
  if pasEffectif = pasTendanciel then s₅ else reculDepart H ((pasEffectif - pasTendanciel) * 1000) s₅

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
                    chomeursComptes := s.actifs - s.emploiTotal }
  chocPib H none dPib s

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
