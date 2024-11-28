Scriptname SlutsMain extends Quest

SlutsData property data auto
SlutsMCM Property MCM Auto

SlutsDriver[] Property Drivers Auto Hidden
SlutsDriver[] Property DefaultDrivers Auto
{0 - Windhelm, 1 - Whiterun, 2 - Solitude, 3 - Markarth, 4 - Riften,
5 - Morthal, 6 - Falkreath, 7 - Winterhold, 8 - Dawnstar, 9 - HQ}

Keyword Property LocTypeHold Auto

Faction Property SlutsCrime Auto
Keyword Property sluts_mission_Kw Auto
Keyword Property sluts_slavery_kw Auto
Keyword Property rehab_kw Auto
Keyword Property blackmail_kw Auto

; ------------------------------------------------------------------------------------------------
; Drivers

SlutsDriver Function DriverFromActor(ObjectReference akDriver)
	int i = 0
	While(i < Drivers.Length && Drivers[i])
		If (Drivers[i].GetReference() == akDriver)
			return Drivers[i] as SlutsDriver
		EndIf
		i += 1
	EndWhile
	return none
EndFunction

Function RegisterDriver(SlutsDriver akDriver)
	If (!Drivers.Length)
		Drivers = new SlutsDriver[128]
	ElseIf (Drivers[127] != none)
		String msg = "Unable to register Driver " + akDriver + ". Maximum number of dispatches reached"
		Debug.MessageBox("[Sluts]\n\n" + msg)
		Debug.Trace("[Sluts] " + msg)
		return
	ElseIf (akDriver.GetReference() == none)
		String msg = "Unable to register Driver " + akDriver + ". Reference is empty"
		Debug.MessageBox("[Sluts]\n\n" + msg)
		Debug.Trace("[Sluts] " + msg)
		return
	ElseIf (Drivers.Find(akDriver) > -1)
		Debug.Trace("[Sluts] Driver " + akDriver + " has already been initialized.")
		return
	EndIf
	int where = Drivers.Find(none)
	Drivers[where] = akDriver
	Debug.Trace("[Sluts] Registered Driver " + akDriver + " | Underlying Actor: " + akDriver.GetReference())
EndFunction

; ------------------------------------------------------------------------------------------------
; Hauls

bool Function StartHaul(Actor Dispatcher, int RecipientID = -1, int forced = 0)
	SlutsDriver driver = DriverFromActor(Dispatcher)
	If (!driver)
		Debug.MessageBox("[Sluts]\n\nThe actor " + Dispatcher.GetName() + " is not a valid SLUTS Driver")
		Debug.Trace("[Sluts] Actor " + Dispatcher + " is not a valid driver but has been chosen as dispatch")
		return false
	EndIf
	SlutsDriver target
	int customLoc
	If(RecipientID >= 0  && RecipientID < DefaultDrivers.Length)
		target = DefaultDrivers[RecipientID]
		customLoc = 1
	Else
		target = GetDispatchTarget(driver)
		customLoc = 0
	EndIf
	If (!target)
		Debug.MessageBox("[Sluts]\n\nUnable to choose a destination. No valid driver found for dispatcher " + Dispatcher.GetName())
		Debug.Trace("[Sluts] Unable to find valid destination from " + Dispatcher)
		return false
	EndIf
	Debug.Trace("[SLUTS] Sending story event with " + Dispatcher + " to " + target.GetRef() + " | Loc = " + target.DriverLoc)
	; Loc => Destination
	; Ref1 => Dispatcher (Starting Hold)
	; Ref2 => Recipent (Destination Hold)
	; aiValue1 => Desination: 1 => Custom, 0 => random
	; aiValue2 => Forced: 1 => True, 0 => False
	return sluts_mission_Kw.SendStoryEventAndWait(target.DriverLoc, Dispatcher, target.GetActorRef(), customLoc, forced)
EndFunction

SlutsDriver Function GetDispatchTarget(SlutsDriver akExclude, SlutsDriver akExclude2 = none)
	int[] idx = Utility.CreateIntArray(Drivers.Length, -1)
	int i = 0
	While(i < Drivers.Length && Drivers[i])
		SlutsDriver it = Drivers[i]
		bool sameHold = it.DriverLoc.HasCommonParent(akExclude.DriverLoc, LocTypeHold)
		bool sameHold2 = it.DriverLoc.HasCommonParent(akExclude2.DriverLoc, LocTypeHold)
		If (!it.Disabled && !sameHold && !sameHold2)
			idx[i] = i
		EndIf
		i += 1
	EndWhile
	idx = PapyrusUtil.RemoveInt(idx, -1)
	If (!idx.Length)
		return none
	EndIf
	return Drivers[idx[Utility.RandomInt(0, idx.Length - 1)]]
EndFunction

; ---------------------------------- Simple Slavery

Event OnEnslavement(string asEventName, string asStringArg, float afNumArg, form akSender)
	Debug.Trace("[SLUTS] Main: Simple Slavery Event Call")
	;Skipping the Intro
	If(GetStage() != 30)
		Debug.Trace("[SLUTS] SimpleSlavery: Skipping Intro")
		SetStage(30)
	EndIf
	; Get players current hold and send them to the specific Driver..
	Location pLoc = Game.GetPlayer().GetCurrentLocation()
	int[] valids = Utility.CreateIntArray(Drivers.Length, -1)
	int i = 0
	While(i < Drivers.Length && Drivers[i])
		SlutsDriver it = Drivers[i]
		If(pLoc.HasCommonParent(it.DriverLoc, LocTypeHold))
			valids[i] = i
		EndIf
		i += 1
	EndWhile
	valids = PapyrusUtil.RemoveInt(valids, -1)
	ShuffleInt(valids)
	int n = 0
	While(n < valids.Length)
		ObjectReference it = Drivers[valids[n]].GetReference()
		If (sluts_slavery_kw.SendStoryEventAndWait(none, it))
			Debug.Trace("[SLUTS] Created Enslavement Call in " + it)
			return
		EndIf
		n += 1
	EndWhile
	; If none of the valid common Locations is loaded send the Player to Riften..
	If(sluts_slavery_kw.SendStoryEventAndWait(none, DefaultDrivers[4].GetReference()))
		Debug.Trace("[SLUTS] Created default Enslavement Call in Riften")
	Else
		Debug.TraceStack("[SLUTS] Failed to create Enslavement")
		Debug.MessageBox("[SLUTS]\nFailed to create Enslavement")
	EndIf
EndEvent

Function ShuffleInt(int[] arr) global
	int i = arr.Length
	While(i > 0)
		i -= 1
		int j = Utility.RandomInt(0, arr.Length - 1)
		int tmp = arr[i]
		arr[j] = arr[i]
		arr[j] = tmp
	EndWhile
EndFunction

; ---------------------------------- Blackmail

Event OnBlackmail(string asEventName, String asStringArg, float afNumArg, Form akBlackmailer)
	If(!akBlackmailer as Actor)
		Debug.TraceStack("[SLUTS] OnBlackmail invalid parameter. Sender must be of type 'Actor' | \"Actor.SendModEvent(...)\"", 2)
		Debug.Messagebox("[SLUTS]\nFailed to start Blackmail Quest")
		return
	EndIf
	If(!blackmail_kw.SendStoryEventAndWait(akRef1 = akBlackmailer as Actor, aiValue1 = afNumArg as int))
		Debug.Trace("[SLUTS] Failed to start Blackmailing Quest")
		Debug.MessageBox("[SLUTS]\nFailed to create Blackmailing Event")
	EndIf
EndEvent

; ---------------------------------- Rehabilitation

Event OnRehab(string asEventName, string asStringArg, float afNumArg, form akSender)
	If(akSender as Actor)
		StartRehab(akSender as Actor)
	Else
		Debug.TraceStack("[SLUTS] OnRehab invalid parameter. Sender must be of type 'Actor' | \"Actor.SendModEvent(...)\"", 2)
		Debug.Messagebox("[SLUTS]\nFailed to start Rehab.")
	EndIf
EndEvent

Function StartRehab(Actor akInitiator)
	Faction crimefaction = akInitiator.GetCrimeFaction()
	If(!crimefaction)
		Debug.TraceStack("[SLUTS] Given Actor = " + akInitiator + " has no associated Crime Faction")
		Debug.MessageBox("[SLUTS]\nFailed to create Rehabilitation Event\nMissing an associated Crime Faction")
		return
	EndIf

	int crime = crimefaction.GetCrimeGoldViolent() + crimefaction.GetCrimeGoldNonviolent()
	crimefaction.SetCrimeGold(0)
	crimefaction.SetCrimeGoldViolent(0)
	SlutsCrime.ModCrimeGold(SlutsData.GetCoinFromGold(crime))

	If(!rehab_kw.SendStoryEventAndWait(akRef1 = akInitiator, aiValue1 = crime))
		Debug.Trace("[SLUTS] Failed to start Rehab Quest")
		Debug.MessageBox("[SLUTS]\nFailed to create Rehabilitation Event")
	EndIf
EndFunction

; ------------------------------------------------------------------------------------------------
; Startup & Reload

Function Maintenance()
	int i = 0
	While(i < Drivers.Length && Drivers[i])
		Drivers[i].Maintenance()
		i += 1
	EndWhile
	RegisterForModEvent("S.L.U.T.S. Enslavement", "OnEnslavement")
	RegisterForModEvent("S.L.U.T.S. Blackmail", "OnBlackmail")
	RegisterForModEvent("S.L.U.T.S. Rehab", "OnRehab")
EndFunction
