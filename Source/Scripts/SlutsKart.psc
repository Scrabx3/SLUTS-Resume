Scriptname SlutsKart extends ObjectReference

SlutsMissionHaul property mission auto
keyword property slut_yoke auto
Actor Property PlayerRef Auto

Message Property NoPilferageMsg Auto					; The cart is loaded and the seal is intact
Message Property LittlePilferageMsg Auto			; The seal has been broken. Most of the cargo is intact.
Message Property NotablePilferageMsg Auto			; Several choice items are missing from the cargo.
Message Property SignificantPilferageMsg Auto	; Your compartment has been well and truly pillaged.
Message Property SeverePilferageMsg Auto			; Your cargo has been stolen and the cart has been damaged

float PilferAway

Function SetUp()
	PilferAway = 25.0
EndFunction

Function ShutDown()
	If(GetState() == "Unloaded")
		GoToState("")
	EndIf
EndFunction

event onactivate(objectreference akActionRef)
	If(akActionRef == none || akActionRef != Game.GetPlayer())
		return
	ElseIf(mission.GetStage() < 20 || mission.GetStage() >= 100)
		return
	EndIf
	float p = mission.pilferage / mission.GoodsTotal
	if p == 0.0
		NoPilferageMsg.Show()
	elseif p < 0.3
		LittlePilferageMsg.Show()
	elseif p < 0.6
		NotablePilferageMsg.Show()
	elseif p < 1
		SignificantPilferageMsg.Show()
	else
		SeverePilferageMsg.Show()
	endif
endevent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	If(!mission.MCM.bCargoAttack || abBashAttack || akAggressor != Game.GetPlayer())
		return
	EndIf
	Weapon wep = akSource as Weapon
	If(!wep)
		Spell spll = akSource as Spell
		If(!spll || !spll.IsHostile())
			return
		EndIf
		int i = spll.GetCostliestEffectIndex()
		MagicEffect effect = spll.GetNthEffectMagicEffect(i)
		If(effect.GetAssociatedSkill() == "Destruction")
			mission.Pilferage += mission.GoodsTotal * 0.01
		EndIf
	Else
		If(abPowerAttack)
			mission.Pilferage += mission.GoodsTotal * 0.03
		Else
			mission.Pilferage += mission.GoodsTotal * 0.01
		EndIf
	EndIf
	If(mission.Pilferage >= mission.GoodsTotal + mission.KartHealth)
		mission.Pilferage = mission.GoodsTotal + mission.KartHealth
		Disable()
	EndIf
EndEvent

Event OnCellDetach()
	Debug.Trace("[SLUTS] Kart OnCellDetach()")
	mission.Untether()
EndEvent

Event OnUnload()
	If(IsDisabled() || !mission.MCM.bCargoAway)
		return
	EndIf
	GoToState("Unloaded")
EndEvent

State Unloaded
	Event OnBeginState()
		Debug.Trace("[SLUTS] Kart Unloaded")
		RegisterForUpdate(10)
		PilferAway()
	EndEvent

	Event OnUpdate()
		PilferAway()
	EndEvent

	Event OnCellAttach()
		GoToState("")
	EndEvent

	Event OnEndState()
		Debug.Trace("[SLUTS] Kart Loaded")
		UnregisterForUpdate()
	EndEvent
EndState

Function PilferAway()
	If(mission.GetStage() < 20 || mission.GetStage() >= 100)
		GoToState("")
		return
	EndIf
	Debug.Trace("[SLUTS] PilferAway()")
	If(Utility.RandomFloat(0, 99.5) < PilferAway)
		mission.Pilferage += mission.GoodsTotal * 0.03 + mission.Pilferage * 0.01
		If(mission.Pilferage >= mission.GoodsTotal + mission.KartHealth)
			Debug.Trace("[SLUTS] Kart Destroyed")
			mission.Pilferage = mission.GoodsTotal + mission.KartHealth
			Disable()
			GoToState("")
			return
		EndIf
	EndIf
	PilferAway += 1.5
EndFunction
