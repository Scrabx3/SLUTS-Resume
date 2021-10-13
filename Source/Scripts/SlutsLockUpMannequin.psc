Scriptname SlutsLockUpMannequin extends ObjectReference

Actor Property PlayerRef  Auto

Actor[] Property Mannequins  Auto

ObjectReference[] Property poles  Auto

Event OnTriggerEnter(ObjectReference akActionRef)
  If(akActionRef == PlayerRef)
    int count = Mannequins.Length
    While(count)
      count -= 1
      (poles[count] as zadcFurnitureScript).LockActor(Mannequins[count])
	Utility.Wait(0.1)
    EndWhile
  EndIf
EndEvent
