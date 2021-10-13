Scriptname SlutsArDebitSpell extends ActiveMagicEffect

; ---------------------------------- Property
MiscObject Property Gold001 Auto
Faction Property crime Auto
Actor Property PlayerRef Auto
; ---------------------------------- Code
Event OnEffectStart(Actor akTarget, Actor akCaster)
  AddInventoryEventFilter(Gold001)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If(GetTargetActor() == PlayerRef)
    int crimeG = Math.Ceiling(crime.GetCrimeGold() / 50)
    If(crimeG < aiItemCount)
      PlayerRef.RemoveItem(akBaseItem, crimeG, true)
      crime.SetCrimeGold(0)
      Debug.notification("By picking up those Septims you managed to completely pay off your arrears!")
    else
      PlayerRef.RemoveItem(akBaseItem, aiItemCount, true)
      crime.ModCrimeGold(-aiItemCount * 50)
      debug.notification("The " + aiItemCount + " septims you collected have reduced your arrears to " + crime.GetCrimeGold())
    EndIf
  else
    GetTargetActor().RemoveItem(akBaseItem, aiItemCount, true)
  EndIf
EndEvent
