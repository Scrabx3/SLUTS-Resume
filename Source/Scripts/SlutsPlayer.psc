Scriptname SlutsPlayer extends ReferenceAlias

Event OnInit()
	Debug.Trace("[Sluts] This is never called :)")
EndEvent

Auto State Startup
	Event OnInit()
		Utility.Wait(0.5)
		RegisterForSingleUpdate(1.5)
	EndEvent

	Event OnUpdate()
		(GetOwningQuest() as SlutsMain).Maintenance()
		GoToState("")
	EndEvent
EndState

Event OnPlayerLoadGame()
	(GetOwningQuest() as SlutsMain).Maintenance()
Endevent
