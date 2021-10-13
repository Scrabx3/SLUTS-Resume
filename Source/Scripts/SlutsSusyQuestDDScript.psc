Scriptname SlutsSusyQuestDDScript extends ReferenceAlias

zadLibs Property Lib0 Auto

Armor[] Property SusyRestraints Auto

Event OnLoad()
  int count = SusyRestraints.Length
  While(count)
    count -= 1
    Utility.Wait(1)
    Lib0.LockDevice((GetReference() as Actor), SusyRestraints[count])
  EndWhile
EndEvent
