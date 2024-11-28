Scriptname SlutsPlayer extends ReferenceAlias

Event OnInit()
	(GetOwningQuest() as SlutsMain).Maintenance()
EndEvent

Event OnPlayerLoadGame()
	(GetOwningQuest() as SlutsMain).Maintenance()
endevent
