Scriptname SlutsBlackmailBaseScr extends Quest  

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  RegisterForModEvent("SLUTS_BlackmailCancel", "OnBlackmailCancel")
EndEvent

Event OnBlackmailCancel(string asEventName, string asStringArg, float afNumArg, form akSender)
  Stop()
EndEvent
