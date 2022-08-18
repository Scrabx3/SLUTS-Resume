Scriptname SlutsYoke extends zadequipscript

Message Property Unhitch Auto
SlutsMissionHaul Property Mission Auto

Function DeviceMenu(int MsgChoice = 0)
  If(mission.bIsThethered)
    Mission.Unhitch()
  EndIf
  return Parent.DeviceMenu(MsgChoice)
endFunction
