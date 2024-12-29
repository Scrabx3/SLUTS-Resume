Scriptname SlutsPlanningMenu extends ObjectReference  

SlutsMain Property Main Auto
GlobalVariable Property CargoId Auto
GlobalVariable Property PackageId Auto

String Property MENUPATH = "SlutsPlanningRoom" AutoReadOnly Hidden
String Property EVENTNAME = "SLUTS_PlanningRoomUpdateTypes" AutoReadOnly Hidden

String[] types

Event OnActivate(ObjectReference akActionRef)
  If (akActionRef != Game.GetPlayer())
    return
  EndIf
  UI.OpenCustomMenu(MENUPATH)
  types = new String[2]
  types[CargoId.GetValueInt()] = "$SLUTS_HaulCargo"
  types[PackageId.GetValueInt()] = "$SLUTS_HaulDelivery"

  String[] args = Utility.CreateStringArray(Main.Drivers.Length)
  int i = 0
  While (i < Main.Drivers.Length && Main.Drivers[i])
    SlutsDriver it = Main.Drivers[i]
    Actor driver = it.GetReference() as Actor
    String[] arg = new String[5]
    arg[0] = driver.GetActorBase().GetName()
    arg[1] = driver.GetFormID()
    arg[2] = it.DriverLoc.GetName()
    int n = 0
    While (n < it.AllowedHauls.Length)
      If (it.AllowedCustom[n] && it.AllowedHauls[n])
        arg[3] = arg[3] + types[n] + "/"
      EndIf
      If (it.AllowedHauls[n])
        arg[4] = arg[4] + types[n] + "/"
      EndIf
      n += 1
    EndWhile
    args[i] = PapyrusUtil.StringJoin(arg, ";")
    i += 1
  EndWhile
  args = PapyrusUtil.ClearEmpty(args)
  RegisterForModEvent(EVENTNAME, "OnUpdateTypes")
  ; String[] categories: type
  UI.InvokeStringA("CustomMenu", "_root.main.setSuboptions", types)
  ; String[] hauls: name;id;location;type1/type2/...;accepted1/accepted2/...
  UI.InvokeStringA("CustomMenu", "_root.main.openMenu", args)
EndEvent

Event OnUpdateTypes(string asEventName, string asAllowedTypes, float afNumArg, form akDriver)
  SlutsDriver drv = Main.DriverFromActor(akDriver as ObjectReference)
  String[] allowedTypes = PapyrusUtil.StringSplit(asAllowedTypes, "/")
  Debug.Trace("[Sluts] Allowed Hauls for Driver " + akDriver + ": " + allowedTypes)
  int i = 0
  While (i < types.Length)
    int n = allowedTypes.Find(types[i])
    drv.AllowedCustom[i] = n > -1
    i += 1
  EndWhile
EndEvent
