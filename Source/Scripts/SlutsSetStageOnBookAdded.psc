Scriptname SlutsSetStageOnBookAdded extends ReferenceAlias  


Book Property BookToLookFor Auto

int Property StageToSet Auto
int Property preReqStage = -1 Auto

Event OnInit()
	AddInventoryEventFilter(BookToLookFor)
EndEvent

Auto State working
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		Quest q = GetOwningQuest()
		if preReqStage == -1 || q.GetStageDone(preReqStage)
			q.SetStage(StageToSet)
			gotostate("done")
		endif
	EndEvent
EndState

State done
EndState
