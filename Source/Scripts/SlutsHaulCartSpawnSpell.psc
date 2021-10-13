Scriptname SlutsHaulCartSpawnSpell extends ActiveMagicEffect
{Script to place Default Haul Cart}

SlutsMissionHaul Property Haul Auto

; V2.5 - can only fire on the Player
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Debug.Trace("SLUTS: Placing Wagon")
	Haul.PlaceWagon()
EndEvent
