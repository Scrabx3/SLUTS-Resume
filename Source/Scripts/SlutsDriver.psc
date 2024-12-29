Scriptname SlutsDriver extends ReferenceAlias  
{
  Registration Script to register a SLUTS Driver into the mod as a possible dispatch for hauling missions
}

SlutsMain Property Main Auto
{Sluts main script to initialize registration}

Location Property DriverLoc Auto
{Location this Driver is responsible for}

ObjectReference Property EscrowSpawnMarker Auto
{Marker identifying the place where the Escrow Chest is being placed after the Haul}

ObjectReference Property PlayerWaitMarker Auto
{Marker identifying the place where the Player waits during setup}

ObjectReference Property PlayerSpawnMarker Auto
{Marker identifying the place where the Player is spawned for special interactions (Crime, Simple Slavery, ...)}

ObjectReference Property KartSpawnMarker Auto
{Marker identifying the place where the Player waits during setup}

ObjectReference Property DriverCastMarker Auto
{Marker identifying the place where the driver stands during setup}

ObjectReference Property DriverWaitMarker Auto
{Marker identifying the place where the driver waits for the player}

String Property AlternateSourceMod = "" Auto
{In case a different replaces this driver with another one, this is the esp of that mod}

int Property AlternateSourceID = 0 Auto
{In case a different replaces this driver with another one, this is the id of the driver in that mod. Mainly used for CFTO}

bool[] Property AllowedHauls Auto
{
  Missing values are considered false
  0: CartHaulAllowed
  1: PackageDeliveryAllowed
}

; ------------------------------------------------------------------------------------------------
; Disabled Status

bool[] Property AllowedCustom Auto Hidden

bool Function IsHaulTypeAllowed(int aiHaulType)
  If (aiHaulType < 0 || aiHaulType >= AllowedHauls.Length)
    return false
  EndIf
  return AllowedHauls[aiHaulType] && AllowedCustom[aiHaulType]
EndFunction

; ------------------------------------------------------------------------------------------------
; OnInit

ObjectReference originalRef = none

Event OnInit()
  RegisterForModEvent("Sluts_RegistrationOpen", "OnRegister")
EndEvent
Event OnRegister(string asEventName, string asStringArg, float afNumArg, form akSender)
  ObjectReference ref = GetReference()
  If (AlternateSourceMod != "" && Game.GetModByName(AlternateSourceMod) != 255)
    ObjectReference obj = Game.GetFormFromFile(AlternateSourceID, AlternateSourceMod) as ObjectReference
    ref = obj
  EndIf
  If (ref && Main.RegisterDriver(self))
    UnregisterForModEvent("Sluts_RegistrationOpen")
    AllowedCustom = Utility.CreateBoolArray(AllowedHauls.Length)
    int i = 0
    While (i < AllowedHauls.Length)
      AllowedCustom[i] = AllowedHauls[i]
      i += 1
    EndWhile
  EndIf
EndEvent

; Called on every load to ensure the driver is properly set up
Function Maintenance()
  If (AlternateSourceMod != "")
    If (Game.GetModByName(AlternateSourceMod) != 255)
      ObjectReference obj = Game.GetFormFromFile(AlternateSourceID, AlternateSourceMod) as ObjectReference
      If (obj)
        If (!originalRef)
          Debug.Trace("[Sluts] " + self + " Alternate reference " + obj)
          originalRef = GetReference()
          ForceRefTo(obj)
        EndIf
        return
      EndIf
    EndIf
    If (originalRef)
      Debug.Trace("[Sluts] " + self + " Alternate reference no longer valid, returning to original reference " + originalRef)
      ForceRefTo(originalRef)
      originalRef = none
    EndIf
  EndIf
EndFunction
