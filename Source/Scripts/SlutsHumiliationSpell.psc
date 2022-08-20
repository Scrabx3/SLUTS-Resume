Scriptname SlutsHumiliationSpell extends ActiveMagicEffect

SlutsMissionHaul Property Haul auto
Spell Property AdSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  AdSpell.Cast(akTarget)
  Haul.HumilChest()
EndEvent
