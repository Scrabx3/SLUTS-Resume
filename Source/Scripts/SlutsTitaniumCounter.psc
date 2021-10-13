Scriptname SlutsTitaniumCounter extends ReferenceAlias
{Sets the parent quest to a specific stage when collecting the specified amount of Titanium}

GlobalVariable Property SLUTS_TitaniumCount  Auto
MiscObject Property SLUTS_IngotTitanium Auto

int Property ingotNeeded Auto
{Amount of Ingot to complete the Quest}
int Property stageToSet Auto
{Stage to set the Quest}
int Property myStage Auto
{Quest Stage showing the num Ingots to the Player}

Event OnInit()
  checkProgress()
  AddInventoryEventFilter(SLUTS_IngotTitanium)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  checkProgress()
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
  checkProgress()
EndEvent

Function checkProgress()
  Quest owningQ = GetOwningQuest()
  If(owningQ.GetStage() >= stageToSet)
    return
  else
    int numIngot = Game.GetPlayer().GetItemCount(SLUTS_IngotTitanium)
    SLUTS_TitaniumCount.Value = numIngot
    owningQ.UpdateCurrentInstanceGlobal(SLUTS_TitaniumCount)
    owningQ.SetObjectiveDisplayed(myStage, true, true)
    If(numIngot >= ingotNeeded)
        owningQ.SetStage(stageToSet)
    EndIf
  EndIf
EndFunction
