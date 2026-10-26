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
  let k := s.rang
  let ref := H.reference.etat
  -- croissance de l'année : trajectoire du scénario (prévisions, puis
  -- croissance potentielle), amputée de l'effet d'offre du moteur
  -- (prélèvements obligatoires au-dessus de leur niveau de départ →
  -- croissance amputée ; en dessous → croissance accrue)
  let volume := H.eco.croissanceVolumeA k
    - appliquerPm (s.prelevementsPb - ref.prelevementsPb) M.elasticiteCroissancePoPm
  let prix := H.eco.inflationA k
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
  let tauxCible := max 0 (H.eco.tauxMarginalA k
    + H.eco.primeDeficitPb * (s.deficitPb - ref.deficitPb) / 100)
  let emission := tauxCible - appliquerPm H.eco.inflationPb H.eco.partDetteIndexeePm
  let dette := s.dette
  -- dette à court terme : renouvelée dans l'année au taux court ; dette à
  -- moyen et long terme : taux du stock, puis refinancement d'une part
  let court := dette * H.eco.partDetteCourtTermePm / 1000
  let long := dette - court
  let longDebut := s.detteDebut - s.detteDebut * H.eco.partDetteCourtTermePm / 1000
  let tauxStock := if long = 0 then s.tauxApparentPb
    else (longDebut * s.tauxApparentPb + (long - longDebut) * s.tauxEmissionPb) / long
  let taux := tauxStock + (emission - tauxStock) * H.eco.renouvellementDettePm / 1000
  -- indexation du capital des titres indexés sur l'inflation de l'année,
  -- enregistrée en intérêts (comptabilité nationale)
  let indexation := dette * H.eco.partDetteIndexeePm * H.eco.inflationIndexationA k / 10000000
  -- OAT numériques : la tranche `part` de la dette est servie au taux
  -- apparent diminué de la décote ; ses intérêts, pour la part défiscalisée,
  -- échappent au PFU (perte de recettes de l'année)
  let tranche := dette * s.partDetteNumeriquePm / 1000
  let economieNum := tranche * taux * s.decoteDetteNumeriquePm / 10000000
  let interetsTranche := tranche * taux / 10000 - economieNum
  let tPfu := H.eco.tauxPfuIrPm + H.eco.tauxPfuCsgCrdsPm + H.eco.tauxPfuSolidaritePm
  let pertePfu := interetsTranche * s.partDefiscaliseePm * tPfu / 1000000
  let interets := long * taux / 10000 + court * H.eco.tauxCourtA k / 10000 + indexation - economieNum
  -- assiettes : PIB nominal, plus l'effet du cycle selon l'élasticité de
  -- chaque prélèvement (`ParImpot.croitreCycle`)
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
  let impots := ((((s.impots.croitreCycle croissance cycle H.eco.elasticiteCycliquePm).ajouter .ir (-dIr)
    |>.ajouter .csgCrds (-dCsg)) |>.ajouter .autres (-(dPerte - dIr - dCsg))
    |>.ajouter .accisesEnergie (-pertesAccises)) |>.ajouter .tva (-pertesTva))
    |>.ajouter .autres (-pertesAcciseGaz)
    |>.ajouter .ir (cdhr - cdhrReconduite)
    |>.ajouter .droitsMutation (appliquerPb s.impots.droitsMutation (tauxDroits - croissance))
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
  let sansNorme := s.depensesF.croitrePrimaires tauxDep s.robotisationPb
  let avecNorme := s.depensesF.croitrePrimaires tauxDep s.robotisationPb
    s.moderationDepensesPb
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
    tauxEmissionPb := emission
    chargeIndexationMeur := indexation
    inflationConsoPb := H.eco.inflationConsoA k
    rang := k + 1
    partDetteNumeriquePm := min s.cibleDetteNumeriquePm (s.partDetteNumeriquePm + s.rythmeDetteNumeriquePm)
    economieInteretsNumeriqueMeur := economieNum
    pertePfuMeur := pertePfu
    cdhrMeur := cdhr
    complementChomageMeur := complement
    allegementsTranche := s.allegementsTranche.croitre croissance
    -- passifs implicites : le stock s'accroît du flux, qui suit les salaires
    passifs := { police := s.passifs.police + s.fluxPassifs.police
                 hopital := s.passifs.hopital + s.fluxPassifs.hopital }
    fluxPassifs := { police := s.fluxPassifs.police + appliquerPb s.fluxPassifs.police croissance
                     hopital := s.fluxPassifs.hopital + appliquerPb s.fluxPassifs.hopital croissance }
    -- dette de fin d'année : `Etat.dette` (déficit final de l'année, mesures
    -- comprises)
    detteDebut := dette
    ajustementDetteAnnee := 0
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
      effetDemande H secteur (appliquerPm (impulsion * e.partInterieurePm / 1000) (poidsEcheance H e))
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
