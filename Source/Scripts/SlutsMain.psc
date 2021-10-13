Scriptname SlutsMain extends Quest

; ---------------------------------- Property
SlutsData property data auto
SlutsMissionHaul property missionsc auto
SlutsMCM Property MCM Auto
actor property PlayerRef auto
Actor[] Property myDrivers Auto
{0 - Windhelm, 1 - Whiterun, 2 - Solitude, 3 - Markarth, 4 - Riften,
5 - Morthal, 6 - Falkreath, 7 - Winterhold, 8 - Dawnstar, 9 - HQ}
Location[] Property myDestLocs Auto
faction property slut_drivers_fac auto ;Carriage Drivers
Faction Property HQStaff Auto
keyword property sluts_mission_Kw auto
keyword property sluts_slavery_kw auto
; ---------------------------------- Variables
; ---------------------------------- Code
; Hey, I know! Let's delete all the vanilla NPlayerRefS and replace them with clones!
; That way no one else can work with the trasport system uin any way. Grrr....
; Fixed :)
Function Maintenance(bool OnInit = false)
	If(OnInit)
		int Count = myDrivers.Length
		While(Count)
			Count -= 1
			myDrivers[Count].AddToFaction(slut_drivers_fac)
			myDrivers[Count].SetFactionRank(HQStaff, 3)
		EndWhile
	EndIf
	RegisterForModEvent("S.L.U.T.S. Enslavement", "On_Enslavement")
	;	I reallly should change the name of this thing since patching for CFTO is about the least of what it does
	; Done n dusted :)
	If(MissionSc.IsRunning())
		missionsc.OnLoadTether()
	EndIf
EndFunction

Function PatchCFTO()
	If(Game.GetModByName("CTFO.esp") == 255)
		return
	EndIf
	CFTO_Patch(0xbbf6e, 0)		; windhelm
	CFTO_Patch(0xbbf6d, 1)		; whiterun
	CFTO_Patch(0xbbf76, 2)		; solitude
	CFTO_Patch(0x9d8bf, 3)		; markarth
	CFTO_Patch(0xbbf7f, 4)		; riften
	CFTO_Patch(0xBBF8E, 5)		; Morthal
	CFTO_Patch(0xBBF90, 6)		; Falkreath
	CFTO_Patch(0xBBF91, 8)		; Dawnstar
EndFunction

function CFTO_Patch(int formid, int slot)
	Actor myDriver = Game.GetFormFromFile(formid, "CFTO.esp") as Actor
	if myDriver == none
		Debug.Trace("sluts: CFTO detected but can't load form at " + formid)
		return
	endif
	myDrivers[slot] = myDriver
	myDriver.AddToFaction(slut_drivers_fac)
	myDriver.SetFactionRank(HQStaff, 3)
endfunction

; ---------------------------------- Start Haul
;/If were already using SendStoryEvent, why not using it properly
Going to shred this function and get all necessary data here to send it together with the Event. Should spare some Script work when filling Aliases in the actual Haul Quest and give me significantly more control over whats happening/;
function StartHaul(actor Dispatcher, int RecipientID = -1, int forced = 0)
	int customLoc = 1
	Actor Recipient
	Location destLoc
	If(RecipientID >= 0) ; Defined in Function Call
		Recipient = myDrivers[RecipientID]
		destLoc = myDestLocs[RecipientID]
	else ; Random
		customLoc = 0
		int id = myDrivers.Find(Dispatcher) ;GetDispatcherID(Dispatcher)
		If(id < 0)
			Debug.Trace("SLUTS: No valid Dispatcher ID, abandon")
			Debug.MessageBox("Invalid Dispatcher, abandon")
			return
		EndIf
		Debug.Trace("SLUTS: Dipatcher ID: " + id)
		; Recipient = GetDestination(DispatcherID)
		Actor[] posRecips = PapyrusUtil.RemoveActor(myDrivers, myDrivers[id])
		Recipient = posRecips[Utility.RandomInt(0, (posRecips.Length - 1))]
		destLoc = myDestLocs[myDrivers.Find(Recipient)]
	EndIf
	;data.customLocation = myCustom
	;location loc = PlayerRef.GetCurrentLocation()
	If(!Recipient || !destLoc)
		Debug.Trace("SLUTS: No valid Recipient or Destination, abandon; Recipient: " + Recipient.GetActorBase().GetName() + " Location: " + destLoc.GetName())
		Debug.MessageBox("Invalid Recipient or Destination, abandon")
		return
	EndIf
	Debug.Trace("SLUTS: sending story event with " + Dispatcher.GetActorBase().GetName() + " to " + Recipient.GetActorBase().GetName() + " to " + destLoc.GetName())
	;Loc => Destination
	;Ref1 => Dispatcher (Starting Hold)
	;Ref2 => Recipent (Destination Hold)
	;aiValue1 => Desination: 1 => Custom, 0 => random
	;aiValue2 => Forced: 1 => True, 0 => False
	sluts_mission_Kw.SendStoryEvent(destLoc, Dispatcher, Recipient, customLoc, forced)
endfunction

int Function GetDispatcherID(Actor Dispatcher)
	int Count = 0
	int PossibleLocs = myDrivers.Length
	While(Count < PossibleLocs)
		If(myDrivers[Count] == Dispatcher)
			return Count
		EndIf
		Count += 1
	EndWhile
	return 777
endFunction

Actor Function GetDestination(int DispatcherID, int TimeOut = 0)
	int PossibleLocs = myDrivers.Length
	;If we dont get a random Location, falling back to forcing a Neighbour inside the Array as Destination
	If(TimeOut > 30)
		int Count = 0
		While(Count < PossibleLocs)
			If(DispatcherID != Count)
				return myDrivers[Count]
			EndIf
			Count += 1
		EndWhile
	EndIf
	;Get a random Location that isnt the Dispatcher Location
	int myDest = Utility.RandomInt(0, (PossibleLocs - 1))
	If(myDest != DispatcherID)
		return myDrivers[myDest]
	else
		GetDestination(DispatcherID, TimeOut + 1)
	EndIf
endFunction

;0 - Random, 1 - Haul
int chainMode
int chainForce
Actor chainDispatch
int chainRecipID
Function ChainMission(actor Dispatcher, int recipientID = -1, int forced = 1)
	StartHaul(Dispatcher, recipientID, forced)
	; chainDispatch = Dispatcher
	; chainRecipID = recipientID
	; chainForce = forced
	; RegisterForSingleUpdate(3)
endFunction

Event OnUpdate()
	If(chainMode == 1)
		StartHaul(chainDispatch, chainRecipID, chainForce)
	EndIf
endEvent
; ---------------------------------- SS Integration
; use the driver as the sender
Event On_Enslavement(string eventName, string arg_s, float argNum, form sender)
	;Skipping the Intro
	If(GetStage() != 30)
		Debug.Trace("SLUTS SS: Skipping Intro")
		SetStage(30)
	EndIf
	Debug.Trace("SLUTS Main: Simple Slavery Event Call")
	;/In case CFTO is installed, sending the Riften Driver stored by this
	Script. If CFTO isnt installed, this just sends the Riften Carriage
	Driver and nothing changes to the way Redux did this. However if CFTO IS
	installed, will send CFTO's Riften Driver, making this Event compatible
	with CFTO. Yes./;
	If(!sluts_slavery_kw.SendStoryEventAndWait(none, myDrivers[4]))
		Debug.MessageBox("SLUTS SS: Call failed")
	EndIf
EndEvent

;/ --------------- Redundant
Moved all of this into the QF Script
ReferenceAlias property JobFlyer auto
function Give_Flyer()
	PlayerRef.AddItem(JobFlyer.GetReference())
	SetStage(10)
	SetObjectiveDisplayed(10)
endfunction

function join_fac()
	PlayerRef.RemoveItem(JobFlyer.GetReference())
	;PlayerRef.addtofaction(SLUTS_JobFaction)
	CompleteAllObjectives()
	SetStage(30)
	CompleteQuest()
endfunction

;Unused? Renamed from slutfac to sluts_JobFaction
;faction property sluts_JobFaction auto
=> Now used in Mission Quests to identify that the Player is on a Mission
;formlist property drivers auto
sluts_dlog_sc property dlog auto

Quests dont close themselves for no reason. If the User thinks its funny force stopping Quests, shame on them! Mwahaha
this gets called when loading a save as well
so let's make sure the dialogue quest is running
if !dlog.isRunning()
	dlog.start()
endif
if !monitor.isRunning()
	monitor.start()
endif

Moving Code into OnInit. Registering for the Event is more reliable if done after each Gameload anyway. Safe the User from their own Stupidity!
function stage_00()
	debug.Debug.Trace("S.L.U.T.S: Wide Open For Business!")
	RegisterForModEvent("S.L.U.T.S. Enslavement", "On_Enslavement")
	cfto_patch()
	setstage(10)
endfunction

Integrated into start_rq
Prbly doesnt really change a lot but I dont trust OnUpdate!
event onupdate()
	cooldown = false
endevent
/;
