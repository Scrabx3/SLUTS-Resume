Scriptname SlutsAdSpell extends ActiveMagicEffect

SlutsTats Property Tats Auto
SlutsMissionHaul Property Haul Auto
Message Property TryEquip Auto
Message Property DutyEnd Auto

Keyword nostrip

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Haul.HumilChest()
  akTarget.UnequipAll()
  nostrip = Keyword.GetKeyword("SexLabNoStrip")
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  Armor gear = akBaseObject as Armor
  If(gear && !gear.HasKeyword(nostrip) && gear.GetName() != "")
    GetTargetActor().UnequipItem(akBaseObject, abSilent = true)
    TryEquip.Show()
  EndIf
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Tats.Scrub(akTarget)
  DutyEnd.Show()
EndEvent
