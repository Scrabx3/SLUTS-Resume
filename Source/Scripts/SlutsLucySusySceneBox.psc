Scriptname SlutsLucySusySceneBox extends ObjectReference

Scene Property myScene Auto

Actor Property LucyREF Auto
Actor Property SusyREF Auto

GlobalVariable Property GameHour Auto
ObjectReference Property zadChair Auto
ObjectReference Property Haybed Auto

Auto State Waiting
	Event OnTriggerEnter(ObjectReference akActionRef)
		If(akActionRef == LucyREF && SusyREF.GetDistance(zadChair) > 500 && (GameHour.Value > 23 || GameHour.Value <= 2))
			myScene.Start()
			GoToState("Cooldown")
			RegisterForSingleUpdateGameTime(10)
		ElseIf(akActionRef == SusyREF && GameHour.Value < 6 && GameHour.Value > 2)
			SusyREF.MoveTo(Haybed)
		EndIf
	EndEvent
EndState

State Cooldown
	Event OnUpdateGameTime()
		GoToState("Waiting")
	EndEvent
EndState
