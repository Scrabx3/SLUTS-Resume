Scriptname SlutsKart extends ObjectReference

SlutsMissionHaul property mission auto
keyword property slut_yoke auto
Actor Property PlayerRef Auto

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
	float p = mission.pilferage/mission.GoodsTotal
	if p == 0.0
		debug.notification("The cart is loaded and the seal is intact")
	elseif p < 0.3
		debug.notification("The seal has been broken. Most of the cargo is intact.")
	elseif p < 0.6
		debug.notification("Several choice items are missing from the cargo.")
	elseif p < 1
		debug.notification("Your compartment has been well and truly pillaged.")
	else
		debug.notification("Your cargo has been stolen and the cart has been damaged")
	endif
endevent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	If(abBashAttack || akAggressor != Game.GetPlayer())
		return
	EndIf
	Weapon wep = akSource as Weapon
	If(wep)
		If(abPowerAttack)
			mission.Pilferage += wep.GetBaseDamage()
		Else
			mission.Pilferage += wep.GetBaseDamage() / 3.0
		EndIf
	Else
		Spell spll = akSource as Spell
		If(!spll || !spll.IsHostile())
			return
		EndIf
		int i = spll.GetCostliestEffectIndex()
		MagicEffect effect = spll.GetNthEffectMagicEffect(i)
		If(effect.GetAssociatedSkill() == "Destruction")
			mission.Pilferage += spll.GetNthEffectMagnitude(i) / 8.0
		EndIf
	EndIf
EndEvent

Event OnUnload()
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
		mission.Pilferage += 7.5
		If(mission.Pilferage > mission.GoodsTotal + 100)
			Disable()
			GoToState("")
			return
		EndIf
	EndIf
	PilferAway += 1.5
EndFunction
