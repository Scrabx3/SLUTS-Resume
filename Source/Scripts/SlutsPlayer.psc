Scriptname SlutsPlayer extends ReferenceAlias

SlutsMain property kq auto

Event OnPlayerLoadGame()
	;debug.trace("sluts: kicker checking for CFTO (accursed be its name)")
	kq.Maintenance()
endevent

Event OnInit()
	kq.Maintenance(true)
EndEvent
