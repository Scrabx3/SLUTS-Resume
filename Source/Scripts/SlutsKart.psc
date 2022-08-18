Scriptname SlutsKart extends ObjectReference

;SlutsBondage property Bd auto
;zbfBondageShell property zbf auto
SlutsMissionHaul property mission auto
keyword property slut_yoke auto
Actor Property PlayerRef Auto

event onactivate(objectreference akActionRef)
	If(akActionRef == none)
		debug.trace("sluts cart: not an actor")
		return
	EndIf
	Actor myActor = akActionRef as Actor
	if myActor != PlayerRef
		Debug.Notification(myActor.GetLeveledActorBase().GetName() + " examines the Cart")
		return
	endif
	if !mission.isrunning()
		debug.notification("The cart is currently unloaded")
		return
	endif
	float p = mission.pilferage
	if p <= 0
		debug.notification("The cart is loaded and the seal is intact")
	elseif p < 450
		debug.notification("The seal has been broken. Most of the cargo is intact.")
	elseif p < 900
		debug.notification("Several choice items are missing from the cargo.")
	elseif p < 1500
		debug.notification("Your compartment has been well and truly pillaged.")
	elseif p >= 1500
		debug.notification("Your cargo has been stolen and the cart has been damaged")
	endif
endevent
