Scriptname SlutsKart extends ObjectReference

SlutsMissionHaul Property mission Auto
Actor Property PlayerRef Auto

Message Property NoPilferageMsg Auto					; The cart is loaded and the seal is intact
Message Property LittlePilferageMsg Auto			; The seal has been broken. Most of the cargo is intact.
Message Property NotablePilferageMsg Auto			; Several choice items are missing from the cargo.
Message Property SignificantPilferageMsg Auto	; Your compartment has been well and truly pillaged.
Message Property SeverePilferageMsg Auto			; Your cargo has been stolen and the cart has been damaged

float Property Pilferage
	float Function Get()
		return mission.Pilferage
	EndFunction
	Function Set(float afValue)
		mission.UpdatePilferage(afValue)
	EndFunction
EndProperty

; Called when the cart is first spawned in
Function SetUp()
	GoToState("Active")
EndFunction

; Called when the cart is about to be deleted
Function ShutDown()
	GoToState("")
EndFunction

float argUnload
State Active
	Event OnBeginState()
		Debug.Trace("[SLUTS] Kart Entering Active State")
		argUnload = 0.0
	EndEvent

	Event OnActivate(ObjectReference akActionRef)
		If(akActionRef != PlayerRef || !mission.IsActiveCartMission())
			return
		ElseIf (Pilferage <= mission.PilferageThresh00.Value)
			NoPilferageMsg.Show()
		ElseIf (Pilferage <= mission.PilferageThresh01.Value)
			LittlePilferageMsg.Show()
		ElseIf (Pilferage <= mission.PilferageThresh02.Value)
			NotablePilferageMsg.Show()
		ElseIf (Pilferage <= mission.PilferageThresh03.Value)
			SignificantPilferageMsg.Show()
		Else
			SeverePilferageMsg.Show()
		EndIf
	Endevent

	Event OnCellDetach()
		If (Pilferage > mission.PilferageThresh03.GetValue())
			Disable()
		Else
			mission.Untether()
		EndIf
	EndEvent
	
	Event OnUnload()
		If(IsDisabled())
			return
		EndIf
		RegisterForSingleUpdateGameTime(0.5)
	EndEvent

	Event OnUpdateGameTime()
		If (Is3DLoaded())
			argUnload = 0.0
			return
		ElseIf (!mission.IsActiveCartMission())
			return
		EndIf
		argUnload += 1
		Pilferage += 0.003 * Math.pow(argUnload, 2)
		RegisterForSingleUpdateGameTime(0.5)
	EndEvent

	Event OnEndState()
		Debug.Trace("[SLUTS] Kart Leaving Active State")
		argUnload = 0.0
	EndEvent
EndState
