import Modele
import Hypotheses
import Proprietes

/-!
# La France insoumise — Mélenchon 2027 (extraits)

Transcription **partielle et non officielle** de melenchon2027.fr
(consulté le 21 octobre 2026) et du « budget rectificatif » 2027 présenté
par J.-L. Mélenchon et É. Coquerel le 14 octobre 2026 (Public Sénat,
France Épargne) : le plan d'investissement productif « Automobile »
(L-01 à L-09), deux mesures phares de *L'Avenir en commun* 2025 (L-10
retraite à 60 ans, L-11 SMIC à 1 600 € net) et les recettes et dépenses
chiffrées du budget rectificatif (L-12 à L-25 : 83,5 Md€ de recettes et
54,6 Md€ de dépenses détaillées, sur 106,4 et 81,7 annoncés). Les mesures
automobiles reprennent chacune une ligne du tableau « Les investissements
supplémentaires », en millions d'euros par an.

Le budget rectificatif 2027 retient le retour à 62 ans (9 Md€) ; le
programme vise 60 ans : c'est l'objectif du programme qui est modélisé
(L-10), sa première étape étant comprise dedans.

Seule la colonne **État** est imputée aux dépenses publiques. La colonne
« pôle public bancaire et autres » relève d'acteurs hors administrations
publiques dans le modèle (prêts, prises de participation) ; elle est citée
dans le champ `source` de chaque mesure.

Les mesures sans montant dans la source (sanctions des flottes
d'entreprises, critères de production française, moratoire sur les
fermetures, prix national de l'électricité…) ne sont pas traduites en
leviers : voir README.md. Aucun engagement n'est déclaré, la source n'en
formulant pas dans les termes des propriétés du dépôt.

Secteur bénéficiaire des emplois (levier `depenseSecteur`, nomenclature
agrégée de l'INSEE) : industrie pour les lignes de production, les aides à
l'achat conditionnées à la production locale, la sous-traitance, les
batteries et le recyclage (la gestion des déchets relève de l'industrie
dans cette nomenclature, la réparation automobile du tertiaire : la ligne
L-06 est classée en industrie, part majoritaire supposée) ; tertiaire
marchand pour la location (activité de location, NAF 77) et la recherche
et développement (NAF 72). Ce classement est une interprétation, ouverte
à la discussion par issue.
-/

namespace Programmes.LFI
open Modele

/-- Référence commune des mesures. -/
def budget : String :=
  "Budget rectificatif 2027 de LFI, 14 octobre 2026 (Public Sénat, France Épargne)"

def page : String :=
  "melenchon2027.fr/programme/plans-investissement/automobile, tableau « Les investissements supplémentaires »"

def mesures : List Mesure := [
  { id := "L-01", titre := "Nouvelles lignes de production"
    source := s!"{page} : État 100 M€/an, pôle public bancaire et autres 200 M€/an"
    leviers := [.depenseSecteur .industrie 100, .annonceEmplois 40000] },
  { id := "L-02", titre := "Service public de la location abordable"
    source := s!"{page} : État 300 M€/an, pôle public bancaire et autres 700 M€/an ; parc public de 1,4 million de véhicules d'ici 2032"
    leviers := [.depenseSecteur .tertiaireMarchand 300] },
  { id := "L-03", titre := "Aides à l'achat électrique et local"
    source := s!"{page} : État 200 M€/an, pôle public bancaire et autres 200 M€/an ; conversion : 50 000 véhicules aidés par an à 4 000 € (hypothèse de prime unitaire)"
    leviers := [.aideAchatElectrique 50000 4000] },
  { id := "L-04", titre := "Sous-traitance et équipementiers (Fonds Avenir Automobile)"
    source := s!"{page} : État 200 M€/an, pôle public bancaire et autres 800 M€/an"
    leviers := [.depenseSecteur .industrie 200] },
  { id := "L-05", titre := "Batteries"
    source := s!"{page} : État 500 M€/an, pôle public bancaire et autres 900 M€/an ; cible d'au moins 100 GWh de capacité annuelle"
    leviers := [.depenseSecteur .industrie 500] },
  { id := "L-06", titre := "Réparation, recyclage, réemploi"
    source := s!"{page} : État 50 M€/an, pôle public bancaire et autres 240 M€/an"
    leviers := [.depenseSecteur .industrie 50] },
  { id := "L-07", titre := "Bornes de recharge"
    source := s!"{page} : État 0, pôle public bancaire et autres 20 M€/an"
    leviers := [] },
  { id := "L-08", titre := "Formation"
    source := s!"{page} : État 0, pôle public bancaire et autres 10 M€/an"
    leviers := [] },
  { id := "L-09", titre := "Recherche et développement : minibus autonomes"
    source := s!"{page} : État 20 M€/an, pôle public bancaire et autres 30 M€/an"
    leviers := [.depenseSecteur .tertiaireMarchand 20] },
  { id := "L-10", titre := "Retraite à 60 ans après 40 annuités"
    source := "L'Avenir en commun 2025, chap. 8 « Travailler tous, travailler moins, travailler mieux », § 8 (melenchon2027.fr/programme2025/livre/chapitre8/s8) ; −48 mois par rapport au repère de 64 ans du modèle, 40 annuités non modélisées ; le coût suit l'hypothèse économique du scénario"
    leviers := [.ageLegal (-48)] },
  { id := "L-11", titre := "SMIC porté à 1 600 € net"
    source := "L'Avenir en commun 2025 (melenchon2027.fr, « SMIC à 1600 € net »). Conversion : la référence du modèle (1 820 € brut) vaut ≈ 1 441 € net au ratio net/brut du SMIC (1 426,30 / 1 801,80 en novembre 2024), d'où +11,0 %"
    leviers := [.revalorisationSmic 1100] },
  { id := "L-12", titre := "ISF climatique"
    source := s!"{budget} : 10 Md€/an"
    leviers := [.prelevementSur .autres 10000] },
  { id := "L-13", titre := "Suppression de la flat tax (PFU)"
    source := s!"{budget} : 9 Md€/an, imputés à l'impôt sur le revenu"
    leviers := [.prelevementSur .ir 9000] },
  { id := "L-14", titre := "Taxe Zucman sur les patrimoines de plus de 100 M€"
    source := s!"{budget} : 15 Md€/an"
    leviers := [.prelevementSur .autres 15000] },
  { id := "L-15", titre := "Réforme des droits de succession (exonération sous 150 000 €, barème sur l'ensemble des transmissions reçues)"
    source := s!"{budget} : 20 Md€/an"
    leviers := [.prelevementSur .autres 20000] },
  { id := "L-16", titre := "Rabot des niches fiscales (pacte Dutreil, crédit d'impôt recherche…)"
    source := s!"{budget} : 22 Md€/an, imputés pour moitié à l'IS et pour moitié aux autres impôts (répartition : hypothèse)"
    leviers := [.prelevementSur .impotSocietes 11000, .prelevementSur .autres 11000] },
  { id := "L-17", titre := "Taxes sur les rachats d'actions et les transactions financières"
    source := s!"{budget} : 7,5 Md€/an"
    leviers := [.prelevementSur .autres 7500] },
  { id := "L-18", titre := "Rémunération des agents publics"
    source := s!"{budget} : 17 Md€/an"
    leviers := [.depenseSur .fonctionnement 17000] },
  { id := "L-19", titre := "Garantie d'autonomie de 1 337 €/mois pour les jeunes"
    source := s!"{budget} : 9,5 Md€/an"
    leviers := [.depenseSur .famille 9500] },
  { id := "L-20", titre := "Action climatique"
    source := s!"{budget} : 10 Md€/an ; réduction d'émissions non chiffrée par la source, emplois dans la construction (hypothèse)"
    leviers := [.depenseSur .logementEnvironnement 10000] },
  { id := "L-21", titre := "Indexation des pensions et prestations, APL +10 %"
    source := s!"{budget} : 8 Md€/an"
    leviers := [.depenseSur .famille 8000] },
  { id := "L-22", titre := "Gratuité des cantines"
    source := s!"{budget} : 3,6 Md€/an"
    leviers := [.depenseSur .enseignement 3600] },
  { id := "L-23", titre := "Plan d'urgence hospitalier, 10 000 postes"
    source := s!"{budget} : 3 Md€/an"
    leviers := [.depenseSur .sante 3000, .annonceEmplois 10000] },
  { id := "L-24", titre := "Assurance chômage"
    source := s!"{budget} : 3 Md€/an"
    leviers := [.depenseSur .famille 3000] },
  { id := "L-25", titre := "10 000 postes d'enseignants"
    source := s!"{budget} : 0,5 Md€/an"
    leviers := [.depenseSur .enseignement 500, .annonceEmplois 10000] }
]

def programme : Programme where
  id := "LFI"
  nom := "La France insoumise — Mélenchon 2027 (extraits)"
  description := "Transcription partielle et non officielle : plan « Automobile » (1,37 Md€/an), retraite à 60 ans et SMIC à 1 600 € net (L'Avenir en commun 2025), recettes (83,5 Md€ détaillées sur 106,4) et dépenses (54,6 sur 81,7) du budget rectificatif 2027 du 14 octobre 2026."
  mainteneurs := ["@orientationd"]
  source := "https://melenchon2027.fr/programme/plans-investissement/automobile/ (consulté le 21 octobre 2026)"
  mesures := mesures

end Programmes.LFI
