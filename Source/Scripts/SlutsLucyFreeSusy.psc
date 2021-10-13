Scriptname SlutsLucyFreeSusy extends ObjectReference

zadcFurnitureScript[] Property zadScr  Auto

Scene Property workEndScene  Auto

Actor Property LucyREF  Auto

Event OnTriggerEnter(ObjectReference akActionRef)
  If(akActionRef == LucyREF && (zadScr[0].user != none || zadScr[1].user != none))
    workEndScene.Start()
  EndIf
EndEvent
