Scriptname SlutsHQFactionCheck extends ObjectReference

Faction Property SlutFac Auto

Actor Property PlayerRef Auto
Actor Property WarrickREF Auto

Scene Property doorScene Auto

Auto State Sharp
  Event OnTriggerEnter(ObjectReference akActionRef)
    If(akActionRef != PlayerRef)
      return
    EndIf
    doorScene.Start()
  EndEvent
EndState

State Slut
  Event OnTriggerEnter(ObjectReference akActionRef)
    If(akActionRef != PlayerRef)
      return
    EndIf
    If(Utility.RandomInt(0, 99) < 20)
      doorScene.Start()
    EndIf
  EndEvent
EndState

State Cooldown
  Event OnUpdateGameTime()
    GoToState("Slut")
  EndEvent

  Event OnTriggerEnter(ObjectReference akActionRef)
  EndEvent
EndState

Function startCooldown()
  GotoState("Cooldown")
  RegisterForSingleUpdateGameTime(18)
EndFunction
