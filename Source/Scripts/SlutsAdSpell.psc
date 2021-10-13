Scriptname SlutsAdSpell extends ActiveMagicEffect

; ---------------------------------- Properties
SlutsTats Property Tats Auto
; ---------------------------------- Variables
Actor myTarget
; ---------------------------------- Code
Event OnEffectStart(Actor akTarget, Actor akCaster)
  ;This effect is only fired shortly after a Haul. The Player shouldnt be wearing any Items other than DDs but just to be sure..
  akTarget.UnequipAll()
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  If(akBaseObject as Armor)
    myTarget.UnequipItem(akReference, abSilent = true)
    Debug.Notification("You're not allowed to wear clothing right now.")
  EndIf
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Tats.Scrub(myTarget)
  Debug.Notification("Your Advertisement Duty is over.")
EndEvent
