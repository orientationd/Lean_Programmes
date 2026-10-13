import Modele

/-!
# Axe économique

C'est l'axe le plus disputé : multiplicateur, élasticités et fuite fiscale
déterminent l'essentiel des écarts entre programmes. D'où trois variantes
dès le départ, plutôt qu'une valeur « officielle ».
-/

namespace Hypotheses.Eco
open Modele

def centrale : Economie where
  id := "eco-centrale"
  description := "Croissance nominale 3 %, paramètres médians"
  croissancePb := 300
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 800
  fuiteFiscalePm := 200
  elasticiteChomageSmicPm := 100
  economieParMoisRetraite := 1500
  coutParPbPlus65 := 180
  baisseEmissionsPm := 30
  sources := ["À COMPLÉTER"]

def croissanceBasse : Economie where
  id := "eco-basse"
  description := "Croissance nominale 2 %, multiplicateur faible, fuite fiscale forte"
  croissancePb := 200
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 500
  fuiteFiscalePm := 350
  elasticiteChomageSmicPm := 150
  economieParMoisRetraite := 1500
  coutParPbPlus65 := 180
  baisseEmissionsPm := 20
  sources := ["À COMPLÉTER"]

def croissanceHaute : Economie where
  id := "eco-haute"
  description := "Croissance nominale 4 %, multiplicateur élevé, fuite fiscale faible"
  croissancePb := 400
  croissanceDepensesPb := 280
  seuilOkunPb := 300
  okunPm := 400
  chomageFrictionnelPb := 450
  multiplicateurPm := 1100
  fuiteFiscalePm := 100
  elasticiteChomageSmicPm := 50
  economieParMoisRetraite := 1500
  coutParPbPlus65 := 180
  baisseEmissionsPm := 40
  sources := ["À COMPLÉTER"]

def toutes : List Economie := [centrale, croissanceBasse, croissanceHaute]

end Hypotheses.Eco
