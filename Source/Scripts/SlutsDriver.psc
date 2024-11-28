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

ObjectReference originalRef = none

Event OnInit()
  Debug.MessageBox("Driver Registration")
  ObjectReference ref = GetReference()
  If (!ref)
    return
  EndIf
  If (AlternateSourceMod != "" && Game.GetModByName(AlternateSourceMod) != 255)
    ObjectReference obj = Game.GetFormFromFile(AlternateSourceID, AlternateSourceMod) as ObjectReference
    If (obj)
      If (ref)
        originalRef = ref
        ref.Disable()
      EndIf
      ref = obj
      ForceRefTo(obj)
    EndIf
  EndIf
  Main.RegisterDriver(self)
EndEvent

Function Maintenance()
  If (AlternateSourceMod != "" && Game.GetModByName(AlternateSourceMod) == 255)
    ObjectReference obj = Game.GetFormFromFile(AlternateSourceID, AlternateSourceMod) as ObjectReference
    If (!obj && originalRef)
      ForceRefTo(originalRef)
      originalRef = none
    EndIf
  EndIf
EndFunction
