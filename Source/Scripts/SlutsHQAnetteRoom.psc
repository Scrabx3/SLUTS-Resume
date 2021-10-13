Scriptname SlutsHQAnetteRoom extends ObjectReference

Actor Property PortiaREF  Auto
Actor Property AnetteREF Auto

zadclibs Property Lib3  Auto

bool bLock = false

Event OnTriggerEnter(ObjectReference akActionRef)
  If(bLock == true || akActionRef != AnetteREF)
    return
  EndIf
  bLock = true
  If(lib3.GetDevice(PortiaREF).GetBaseObject() == lib3.zadc_ShackleWallIron)
    If(PortiaREF.GetActorValuePercentage("Health") > 0.95)
      ; Locked into the wall-Shackles, release and put in the Wooden horse
      lib3.UnlockActor(PortiaREF)
      Utility.WaitMenuMode(0.5)
      PortiaREF.EvaluatePackage()
    EndIf
  else
    If(PortiaREF.GetActorValuePercentage("Health") < 0.1)
      ; Locked on the Wooden Horse with no Hp
      lib3.UnlockActor(PortiaREF)
      Utility.WaitMenuMode(0.5)
      PortiaREF.EvaluatePackage()
    EndIf
  EndIf
  Utility.Wait(3)
  bLock = false
EndEvent
