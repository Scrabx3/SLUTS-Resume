Scriptname SlutsPreviewFillyGear extends zadcFurnitureScript

SlutsBondage Property bd Auto

bool mutex = false

Event OnActivate(ObjectReference akActionRef)
	; set a mutex in case the device gets activated multiple times in short order
	If mutex
		return
	EndIf
	mutex = true
	Actor act = akActionRef As Actor
	If !user
		; lock somebody in the device when it's not occupied.
		If act == libs.PlayerRef
      ; Skip the entire lock menu stuff since this is just a "yep or nope" kinda thing
      If(zadc_DeviceMsgPlayerNotLocked.Show() == 0)
        Game.ForceThirdPerson()
        parent.LockActor(act)
        bd.DressUpPony(Game.GetPlayer())
        bd.equipIdx(bd.gagIDX, true)
      else
        return
      EndIf
		Else
      ; No NPC allowed here, thank you very much and goodbye
			If act == clib.SelectedUser
				Debug.Notification("You can't lock a NPC into this Device.")
      EndIf
      return
		EndIf
	Elseif user
		; device is occupied
		If Game.GetPlayer() != act
      ; No one but the Player can be locked up in this and only the Player is allowed to interact with this so.. Thank you very much and goodbye!
      return
		Else
			; attempt by the person locked in the device to open it
      DeviceMenuUnlock()
		EndIf
	EndIf
	mutex = false
EndEvent

Function UnlockActor()
  ; Only the player can be locked into this, so only the player can be freed from it
  bd.UndressPony(Game.GetPlayer(), true)
  Utility.WaitMenuMode(0.5)
  parent.UnlockActor()
EndFunction
