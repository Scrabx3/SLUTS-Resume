Scriptname SlutsEscrow extends ObjectReference

; ---------------------------------- Property
Actor Property PlayerRef Auto
Activator Property summonFX Auto
ObjectReference myMarker ; Where we are currently standing & facing
; ---------------------------------- Code
Function MoveTo(ObjectReference akTarget, float afXOffset = 0.0, float afYOffset = 0.0, float afZOffset = 0.0, bool abMatchRotation = true)
  akTarget.PlaceAtMe(summonFX)
  Parent.MoveTo(akTarget, afXOffset, afYOffset, afZOffset, abMatchRotation)
  Enable()
  myMarker = akTarget
EndFunction

Function LockEscrow()
  Lock()
  SetLockLevel(255)
  If (!Is3DLoaded() && IsEnabled())
    Disable()
  EndIf
EndFunction

Function Despawn()
  PlaceAtMe(summonFX)
  Disable()
EndFUnction

Event OnOpen(ObjectReference akActionRef)
  If(akActionRef != PlayerRef)
    return
  EndIf
  Utility.Wait(0.5) ; Wait for Container to close
  SendModEvent("Sluts_EscrowChestOpened")
EndEvent

Event OnCellAttach()
  Parent.MoveTo(myMarker)
EndEvent

Event OnCellDetach()
  If(GetLockLevel() == 255)
    Disable()
  EndIf
EndEvent
