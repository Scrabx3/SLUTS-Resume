ScriptName SlutsMissionHaulHUD extends SKI_WidgetBase

SlutsMissionHaul Property MissionHaul Auto
SlutsMCM Property MCM Auto

String Function GetWidgetSource()
  return "SLUTS/SlutsMissionHaulHUD.swf"
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
  SetupPilferage("", "", 0.0, none)
  UpdateLocation("", "", 0.0, none)

  If (MissionHaul.IsActiveMission())
    MissionHaul.UpdatePilferage(MissionHaul.Pilferage)
  EndIf
EndEvent

Event SetupPilferage(string asEventName, string asStringArg, float afNumArg, form akSender)
  Debug.Trace("[SLUTS] Invoking HUD Function: SetupPilferage")
  float[] args = new float[5]
  args[0] = MissionHaul.PilferageThresh00.GetValue()
  args[1] = MissionHaul.PilferageThresh01.GetValue()
  args[2] = MissionHaul.PilferageThresh02.GetValue()
  args[3] = MissionHaul.PilferageThresh03.GetValue()
  args[4] = MissionHaul.PilferageReinforcement.GetValue()
  UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".buildMeter", args)
EndEvent

Event UpdateLocation(string asEventName, string asStringArg, float afNumArg, form akSender)
  Debug.Trace("[SLUTS] Invoking HUD Function: UpdateLocation")
  float[] args = new float[4]
  ; xpos_prc: Number, ypos_prc: Number, rot: Number, scale: Number
  args[0] = MCM.fHUDPosX
  args[1] = MCM.fHUDPosY
  args[2] = 0.0
  args[3] = MCM.fHUDPosS
  UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".setLocation", args)
EndEvent

;/
.setPct(pct)
.show(dur)
.hide(force)
.toggleVisibility()
/;
Event InvokeFloat(string asEventName, string asStringArg, float afNumArg, form akSender)
  Debug.Trace("[SLUTS] Invoking HUD Function: " + asStringArg + " | NumArg: " + afNumArg)
  UI.InvokeFloat(HUD_MENU, WidgetRoot + asStringArg, afNumArg)
EndEvent

