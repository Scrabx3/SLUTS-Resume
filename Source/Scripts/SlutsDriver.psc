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

bool Property CartHaulAllowed = true Auto
{If this driver can start Cart type hauling quests}

bool Property PackageDeliveryAllowed = true Auto
{If this driver can start Package/Premium Delivery type hauling quests}

; ------------------------------------------------------------------------------------------------
; Disabled Status

bool Property Disabled = false Auto Hidden

bool Function IsHaulTypeAllowed(int aiHaulType)
  bool[] haulTypes = new bool[2]
  haulTypes[0] = CartHaulAllowed
  haulTypes[1] = PackageDeliveryAllowed
  return haulTypes[aiHaulType]
EndFunction

; ------------------------------------------------------------------------------------------------
; OnInit

bool registered = false
ObjectReference originalRef = none

Event OnInit()
  RegisterForModEvent("Sluts_RegistrationOpen", "OnRegister")
EndEvent

Event OnRegister(string asEventName, string asStringArg, float afNumArg, form akSender)
  ObjectReference ref = GetReference()
  If (AlternateSourceMod != "" && Game.GetModByName(AlternateSourceMod) != 255)
    ObjectReference obj = Game.GetFormFromFile(AlternateSourceID, AlternateSourceMod) as ObjectReference
    If (obj)
      Debug.Trace("[Sluts] Found alternate reference for " + self + " using underlying driver: " + obj)
      If (ref)
        originalRef = ref
        ref.Disable()
      EndIf
      ref = obj
      ForceRefTo(obj)
    EndIf
  EndIf
  If (ref && Main.RegisterDriver(self))
    UnregisterForModEvent("Sluts_RegistrationOpen")
  EndIf
EndEvent

; Called on every load to ensure the driver is properly set up
Function Maintenance()
  If (AlternateSourceMod != "" && Game.GetModByName(AlternateSourceMod) == 255)
    ObjectReference obj = Game.GetFormFromFile(AlternateSourceID, AlternateSourceMod) as ObjectReference
    If (!obj && originalRef)
      ForceRefTo(originalRef)
      originalRef = none
    EndIf
  EndIf
EndFunction
