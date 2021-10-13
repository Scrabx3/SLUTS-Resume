Scriptname SlutsLucyFreeSusyCage extends ObjectReference

Scene Property myScene Auto

Actor Property LucyREF Auto
Actor Property SusyREF Auto

GlobalVariable Property GameHour Auto
ObjectReference Property CageCenter Auto

Auto State Waiting
	Event OnTriggerEnter(ObjectReference akActionRef)
		If(akActionRef == LucyREF && CageCenter.GetDistance(SusyREF) < 150 && GameHour.Value >= 7 && GameHour.Value <= 12)
			Debug.Notification("Start myScene")
			myScene.Start()
			GoToState("Cooldown")
			RegisterForSingleUpdateGameTime(10)
		EndIf
	EndEvent
EndState

State Cooldown
	Event OnUpdateGameTime()
		GoToState("Waiting")
	EndEvent
EndState
