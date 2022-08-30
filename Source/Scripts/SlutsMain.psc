Scriptname SlutsMain extends Quest

SlutsData property data auto
SlutsMCM Property MCM Auto

ObjectReference[] Property myRoots Auto
Location[] Property myDestLocs Auto
Actor[] Property myDrivers Auto
{0 - Windhelm, 1 - Whiterun, 2 - Solitude, 3 - Markarth, 4 - Riften,
5 - Morthal, 6 - Falkreath, 7 - Winterhold, 8 - Dawnstar, 9 - HQ}

Faction Property SlutsCrime Auto
Faction Property slut_drivers_fac Auto
Faction Property HQStaff Auto
Keyword Property sluts_mission_Kw Auto
Keyword Property sluts_slavery_kw Auto
Keyword Property rehab_kw Auto

; ---------------------------------- Hauls
;/If were already using SendStoryEvent, why not using it properly
Going to shred this function and get all necessary data here to send it together with the Event. Should spare some Script work when filling Aliases in the actual Haul Quest and give me significantly more control over whats happening/;
Function StartHaul(Actor Dispatcher, int RecipientID = -1, int forced = 0)
	int customLoc = 1
	Actor Recipient
	Location destLoc
	If(RecipientID >= 0)
		Recipient = myDrivers[RecipientID]
		destLoc = myDestLocs[RecipientID]
	else
		Recipient = GetDestination(Dispatcher)
		destLoc = myDestLocs[myDrivers.Find(Recipient)]
		customLoc = 0
	EndIf
	If(!Recipient || !destLoc)
		Debug.Trace("[SLUTS] No valid Recipient or Destination, abandon; Recipient: " + Recipient + " | Loc = " + destLoc)
		Debug.MessageBox("[SLUTS] Unable to find a valid Recipient or Destination, abandon")
		return
	EndIf
	Debug.Trace("[SLUTS] Sending story event with " + Dispatcher + " to " + Recipient + " | Loc = " + destLoc)
	;Loc => Destination
	;Ref1 => Dispatcher (Starting Hold)
	;Ref2 => Recipent (Destination Hold)
	;aiValue1 => Desination: 1 => Custom, 0 => random
	;aiValue2 => Forced: 1 => True, 0 => False
	sluts_mission_Kw.SendStoryEvent(destLoc, Dispatcher, Recipient, customLoc, forced)
EndFunction

Actor Function GetDestination(Actor akExclude, Actor akExclude2 = none)
	Actor[] potentials = StrippedCopyCat(myDrivers, akExclude)
	If(akExclude2)
		potentials = StrippedCopyCat(potentials, akExclude2)
	EndIf
	int where = myDrivers.Find(akExclude)
	If(where == 4)
		potentials = StrippedCopyCat(potentials, myDrivers[9])
	ElseIf(where == 9)
		potentials = StrippedCopyCat(potentials, myDrivers[4])
	EndIf
	return potentials[Utility.RandomInt(0, (potentials.Length - 1))]
EndFunction
Actor Function GetDestinationEx(Actor[] akExclude)
	Actor[] potentials = StrippedCopyCat(myDrivers, akExclude[0])
	int i = 1
	While(i < akExclude.Length)
		potentials = StrippedCopyCat(potentials, akExclude[i])
		i += 1
	EndWhile
	return potentials[Utility.RandomInt(0, (potentials.Length - 1))]
EndFunction
Actor[] Function StrippedCopyCat(Actor[] arr, Actor akExclude)
	int i = myDrivers.find(akExclude)
	If(i < 0)
		return arr
	EndIf
	return PapyrusUtil.RemoveActor(arr, arr[i])
EndFunction

; ---------------------------------- SS Integration
Event On_Enslavement(string asEventName, string asStringArg, float afNumArg, form akSender)
	Debug.Trace("[SLUTS] Main: Simple Slavery Event Call")
	;Skipping the Intro
	If(GetStage() != 30)
		Debug.Trace("[SLUTS] SimpleSlavery: Skipping Intro")
		SetStage(30)
	EndIf
	; Get players current hold and send them to the specific Driver..
	Keyword LocTypeHold = Keyword.GetKeyword("LocTypeHold")
	Location pLoc = Game.GetPlayer().GetCurrentLocation()
	int i = 0
	While(i < myDestLocs.Length)
		If(pLoc.HasCommonParent(myDestLocs[i], LocTypeHold))
			If(sluts_slavery_kw.SendStoryEventAndWait(none, myDrivers[i]))
				Debug.Trace("[SLUTS] Created Enslavement Call in Location with ID = " + i)
				return
			EndIf
		EndIf
		i += 1
	EndWhile
	; If none of the valid common Locations is loaded send the Player to Riften..
	If(sluts_slavery_kw.SendStoryEventAndWait(none, myDrivers[4]))
		Debug.Trace("[SLUTS] Created default Enslavement Call in Riften")
	Else
		Debug.TraceStack("[SLUTS] Failed to create Enslavement")
		Debug.MessageBox("[SLUTS]\nFailed to create Enslavement")
	EndIf
EndEvent

; ---------------------------------- Startup
Event On_Rehab(string asEventName, string asStringArg, float afNumArg, form akSender)
	If(akSender as Faction)
		StartRehabImpl(akSender as Faction, none)
	ElseIf(akSender as Actor)
		StartRehab(akSender as Actor)
	Else
		Debug.TraceStack("[SLUTS] On_Rehab received invalid Sender Parameter. Sender must be of Type Actor or Faction", 2)
		Debug.Messagebox("[SLUTS]\nFailed to start Rehab")
	EndIf
EndEvent

Function StartRehab(Actor akInitiator)
	Faction crime = akInitiator.GetCrimeFaction()
	If(!crime)
		Debug.TraceStack("[SLUTS] Given Actor = " + akInitiator + " has no associated Crime Faction")
		Debug.MessageBox("[SLUTS]\nFailed to create Rehabilitation Event\nMissing an associated Crime Faction")
		return
	EndIf
	StartRehabImpl(akInitiator.GetCrimeFaction(), akInitiator)
EndFunction
Function StartRehabImpl(Faction akCrimeFaction, Actor akInitiator)
	int crime = akCrimeFaction.GetCrimeGoldViolent() + akCrimeFaction.GetCrimeGoldNonviolent()
	akCrimeFaction.SetCrimeGold(0)
	akCrimeFaction.SetCrimeGoldViolent(0)
	SlutsCrime.ModCrimeGold(SlutsData.GetCoinFromGold(crime))

	If(!rehab_kw.SendStoryEventAndWait(akRef1 = akInitiator))
		Debug.Trace("[SLUTS] Failed to start Rehab Quest")
		Debug.MessageBox("[SLUTS]\nFailed to create Rehabilitation Event")
	EndIf
EndFunction

; ---------------------------------- Startup
; Copy of the vanilla drivers so they dont get lost when the player uninstalls CTFO zzz
; srsly curse this mod though
Actor[] myDrivers_og

; Hey, I know! Let's delete all the vanilla NPlayerRefS and replace them with clones!
; That way no one else can work with the trasport system in any way. Grrr....
Event OnInit()
	If(!IsRunning())
		return
	EndIf
	myDrivers_og = PapyrusUtil.RemoveActor(myDrivers, none)
	Maintenance()
EndEvent

; Called OnInit() and every game load
Function Maintenance()
	If(Game.GetModByName("CTFO.esp") != 255)
		int i = 0
		While(i < myDrivers.Length)
			myDrivers_og[i].DisableNoWait()
			i += 1
		EndWhile
		PatchCFTO()
	Else
		myDrivers = myDrivers_og
	EndIf
	int i = 0
	While(i < myDrivers.Length)
		myDrivers[i].EnableNoWait()
		RegisterDriver(myDrivers[i], myRoots[i])
		i += 1
	EndWhile
	RegisterForModEvent("S.L.U.T.S. Enslavement", "On_Enslavement")
	RegisterForModEvent("S.L.U.T.S. Rehab", "On_Rehab")
EndFunction

Function PatchCFTO()
	CFTO_Patch(0xbbf6e, 0)	; windhelm
	CFTO_Patch(0xbbf6d, 1)	; whiterun
	CFTO_Patch(0xbbf76, 2)	; solitude
	CFTO_Patch(0x9d8bf, 3)	; markarth
	CFTO_Patch(0xbbf7f, 4)	; riften
	CFTO_Patch(0xBBF8E, 5)	; Morthal
	CFTO_Patch(0xBBF90, 6)	; Falkreath
	CFTO_Patch(0xBBF91, 8)	; Dawnstar
EndFunction
function CFTO_Patch(int formid, int slot)
	Actor myDriver = Game.GetFormFromFile(formid, "CFTO.esp") as Actor
	if myDriver == none
		Debug.Trace("[SLUTS] CFTO | Can't load form = " + formid)
		return
	endif
	myDrivers[slot] = myDriver
endfunction
Function RegisterDriver(Actor akDriver, ObjectReference akRootForm)
	StorageUtil.SetFormValue(akDriver, "SLUTS_ROOT", akRootForm)
	akDriver.AddToFaction(slut_drivers_fac)
	akDriver.SetFactionRank(HQStaff, 3)
EndFunction
