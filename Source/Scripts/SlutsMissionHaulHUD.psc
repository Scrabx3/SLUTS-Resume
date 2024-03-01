ScriptName SlutsMissionHaulHUD extends SKI_WidgetBase

SlutsMissionHaul Property MissionHaul Auto
SlutsMCM Property MCM Auto

String Function GetWidgetSource()
  return "SLUTS/MissionHaul.swf"
EndFunction
string Function GetWidgetType()
	return "SlutsMissionHaulHUD"
EndFunction

Event OnWidgetInit()
	{Handles any custom widget initialization}
  WidgetName = "SLUTS Mission Haul Pilferage Meter"
EndEvent

Event OnWidgetReset()
  {After each game load}
  Parent.OnWidgetReset()

  RegisterForModEvent("SLUTS_SetupPilferage", "SetupPilferage")
  RegisterForModEvent("SLUTS_UpdateLocation", "UpdateLocation")
  RegisterForModEvent("SLUTS_InvokeFloat", "InvokeFloat")
EndEvent

Event SetupPilferage(string asEventName, string asStringArg, float afNumArg, form akSender)
  float[] args = new float[5]
  args[0] = MissionHaul.PilferageThresh00.GetValue()
  args[1] = MissionHaul.PilferageThresh01.GetValue()
  args[2] = MissionHaul.PilferageThresh02.GetValue()
  args[3] = MissionHaul.PilferageThresh03.GetValue()
  args[4] = MissionHaul.PilferageReinforcement.GetValue()
  UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".main.buildMeter", args)
EndEvent

Event UpdateLocation(string asEventName, string asStringArg, float afNumArg, form akSender)
  float[] args = new float[4]
  ; xpos_prc: Number, ypos_prc: Number, rot: Number, scale: Number
  args[0] = MissionHaul.PilferageThresh00.GetValue()
  args[1] = MissionHaul.PilferageThresh01.GetValue()
  args[2] = MissionHaul.PilferageThresh02.GetValue()
  args[3] = MissionHaul.PilferageThresh03.GetValue()
  UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".main.setLocation", args)
EndEvent

;/
.main.setPct(pct)
.main.show(dur)
.main.hide(force)
/;
Event InvokeFloat(string asEventName, string asStringArg, float afNumArg, form akSender)
  UI.InvokeFloat(HUD_MENU, WidgetRoot + asStringArg, afNumArg)
EndEvent

