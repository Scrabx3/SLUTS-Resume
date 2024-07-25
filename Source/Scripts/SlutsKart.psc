Scriptname SlutsKart extends ReferenceAlias

SlutsMissionHaul Property Haul Hidden
	SlutsMissionHaul Function Get()
		return GetOwningQuest() as SlutsMissionHaul
	EndFunction
EndProperty
Message Property NoPilferageMsg Auto					; The cart is loaded and the seal is intact
Message Property LittlePilferageMsg Auto			; The seal has been broken. Most of the cargo is intact.
Message Property NotablePilferageMsg Auto			; Several choice items are missing from the cargo.
Message Property SignificantPilferageMsg Auto	; Your compartment has been well and truly pillaged.
Message Property SeverePilferageMsg Auto			; Your cargo has been stolen and the cart has been damaged

Function Clear()
	ObjectReference me = GetReference()
	me.Disable(true)
	me.Delete()
	Parent.Clear()
EndFunction

Event OnActivate(ObjectReference akActionRef)
	If(akActionRef != Game.GetPlayer())
		return
	EndIf
	float p = Haul.Pilferage
	If (p <= Haul.PilferageThresh00.Value)
		NoPilferageMsg.Show()
	ElseIf (p <= Haul.PilferageThresh01.Value)
		LittlePilferageMsg.Show()
	ElseIf (p <= Haul.PilferageThresh02.Value)
		NotablePilferageMsg.Show()
	ElseIf (p <= Haul.PilferageThresh03.Value)
		SignificantPilferageMsg.Show()
	Else
		SeverePilferageMsg.Show()
	EndIf
Endevent

Event OnCellDetach()
	If (Haul.Pilferage > Haul.PilferageThresh03.GetValue())
		GetReference().Disable()
	Else
		Haul.Untether()
	EndIf
EndEvent

float argUnload
Event OnUnload()
	If(GetReference().IsDisabled())
		return
	EndIf
	argUnload = 0.0
	RegisterForSingleUpdateGameTime(0.5)
EndEvent

Event OnUpdateGameTime()
	If (GetReference().Is3DLoaded())
		return
	ElseIf (!Haul.IsActiveCartMission())
		return
	EndIf
	argUnload += 1
	float arg = 0.003 * Math.pow(argUnload, 2)
	Haul.UpdatePilferage(Haul.Pilferage + arg)
	RegisterForSingleUpdateGameTime(0.5)
EndEvent
