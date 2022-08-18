Scriptname SlutsEscrow extends ObjectReference

; ---------------------------------- Property
SlutsData Property data Auto
SlutsMissionHaul Property Haul Auto
SlutsTats Property TatLib Auto
Actor Property playerRef Auto
MagicEffect Property AdSpell Auto
Activator Property summonFX Auto
ObjectReference myMarker ; Where we are currently standing & facing
; ---------------------------------- Code
Function MoveTo(ObjectReference akTarget, float afXOffset = 0.0, float afYOffset = 0.0, float afZOffset = 0.0, bool abMatchRotation = true)
  If(myMarker == akTarget)
    ; Dont move when were already here
    return
  EndIf
  akTarget.PlaceAtMe(summonFX)
  Parent.MoveTo(akTarget, afXOffset, afYOffset, afZOffset, abMatchRotation)
  Self.Enable()
  myMarker = akTarget
EndFunction

Function LockEscrow()
  Lock()
  SetLockLevel(255)
EndFunction

Event OnActivate(ObjectReference akActionRef)
  If(Haul.GetStage() < 40)
    ; <=> Not at the end of a Haul Series
    return
  EndIf
  ;/If(data.hasFillyReward)
    ;set of restraints, along with a <- TODO: Add this to v when Filly Reward reworked!!
    Debug.MessageBox("While reclaiming your stuff you also find a pay bonus of " + data.FillyGold + " and a letter of commendation inside the escrow chest. (To qualify for this reward again, complete " + data.fillyrank + " voluntary, flawless runs in a row.)")
    ;Debug.Notification("To collect another Filly Wear bonus you must now complete " + q.data.fillyrank + " willing runs in a row.")
    data.hasFillyReward = false
  EndIf/;
  Utility.Wait(0.5) ; Wait for Container to close
  If(!PlayerRef.HasMagicEffect(AdSpell))
    TatLib.Scrub(PlayerRef)
  EndIf
  Lock()
  SetLockLevel(255)
  Haul.SetStage(500)
  Utility.Wait(15)
  PlaceAtMe(summonFX)
  Disable()
EndEvent

Event OnCellAttach()
  Parent.MoveTo(myMarker)
EndEvent

; event OnMenuClose(String menu)
;   If(!meOpened)
;     return
;   EndIf
;   UnregisterForMenu("ContainerMenu")
;   meOpened = false
;   Haul.gear_reclaimed()
;   If(!PlayerRef.HasMagicEffect(AdSpell))
;     haul.TatLib.Scrub(PlayerRef)
;   EndIf
;   Utility.Wait(15)
;   Lock()
;   SetLockLevel(255)
;   Disable()
; endEvent
