Scriptname SlutsSSIntegration extends Quest Conditional

; ---------------------------------- Property
SlutsMCM property MCM auto
SlutsMain Property Main Auto

Actor Property PlayerRef Auto
Static Property RootMark Auto
ReferenceAlias Property SceneRoot Auto
referencealias Property CarterRef Auto
Keyword Property RootKW Auto
keyword Property PlayerCarriageWait Auto
Keyword Property DriverCarriageWait Auto
Faction Property slutsCrime Auto

; ---------------------------------- Variables
;int property boughtAsASlave auto conditional ;This is set to change some of the dialogue conditions if your first S.L.U.T.S. mission was as a slave
bool Property bRemainedSilent = true Auto Hidden Conditional
ObjectReference playerWaitLoc
ObjectReference driverWaitLoc
; ---------------------------------- Code
Function PlaceActors()
	;Need Player & Carter Positions for Scene:
	Debug.Trace("SLUTS SS: Scene Started")
	; SceneRoot.ForceRefTo(Game.FindClosestReferenceOfTypeFromRef(RootMark, CarterRef.GetReference(), 2500))
	ObjectReference myRoot = CarterRef.GetReference().GetLinkedRef(RootKW)
	playerWaitLoc = myRoot.GetLinkedRef(PlayerCarriageWait)
	driverWaitLoc = myRoot.GetLinkedRef(DriverCarriageWait)
	Utility.Wait(1)
	PlayerRef.MoveTo(playerWaitLoc)
	CarterRef.GetReference().MoveTo(driverWaitLoc)
	Utility.Wait(0.5)
	Debug.MessageBox("With the transaction on the ownership of your very life completed you are escorted from the auction house and outside the gates of Riften. Your escort leaves you with the local carriage driver. You expect to be loaded up and shipped off to some living hell, but instead the driver begins speaking to you in a joval tone...")
endFunction

Function StartHaul()
	SetStage(10)
	Main.StartHaul(CarterRef.GetReference() as Actor, forced = 1)
endFunction

Function calcDebt()
	int debt = Math.Floor(50000 * Math.Pow((MCM.iSSminDebt + 1), 2))
	int curCrime = slutsCrime.GetCrimeGold() + Utility.RandomInt((debt/3), debt)
	slutsCrime.SetCrimeGold(curCrime)

	Debug.Messagebox("You are indentered to work off an arrears of " + curCrime + " Coins for S.L.U.T.S.")
EndFunction

;/ --------------- Redundant
Ill just write this all from Scratch since I redo the way Scene Information is gathered

keyword property sluts_scene_root_mark auto
keyword property sluts_scene_driver_bj_mark auto
keyword property sluts_scene_pc_bj_mark auto
globalvariable property sluts_arrears_amount auto

scene property ss_bridge auto
actor property d1 auto ;Riften
; ---------------------------------- Pre Scene Start
Event OnInit()
	Debug.Trace("SLUTS: SS-Bridge: Init")
	;actor pc_ref = pc.getreference() as actor
	;Actor carter_ref = d1 ;random_driver()	;Replacing all "carter_ref"s with d1, as carter ref isnt random anyway
	Debug.Trace("SLUTS: SS-Bridge: Carter: " + d1.getdisplayname())
	;Carter.ForceRefTo(d1)
	;Get Scene Location
	objectreference root_marker = d1.getlinkedref(sluts_scene_root_mark)
	;Define Driver Standing Location
	Driver_MarkRef = root_marker.getlinkedref(sluts_scene_driver_bj_mark)
	Debug.Trace("SLUTS: SS-Bridge: Carter Mark: " + Driver_MarkRef)
	;carter_mark.forcerefto(Driver_MarkRef) < Not needed, just use a Variable to define the Location directly. We only need it in this Script to move the Carter once. Analogue for Player
	;Define Player Standing Location
	Pc_MarkRef = root_marker.getlinkedref(sluts_scene_pc_bj_mark)
	Debug.Trace("SLUTS: SS-Bridge: Player Mark: " + Pc_MarkRef)
	;pc_mark.forcerefto(Pc_MarkRef) < See Carter.ForceRefTo Comment
	SceneStarter.StartScene(ss_bridge)
EndEvent

; --------------- Post Scene Start
function ActorsToMarks()
	;actor pc_ref = pc.getreference() as actor ;Calling PlayerRef directly
	;actor driver_ref = carter.getreference() as actor ;Carter is always d1
	;objectreference pc_mark_ref = pc_mark.getreference()
	;objectreference driver_mark_ref = carter_mark.getreference()
	;^ Unneccesary, just use the ObjReference Variables we filled earlier.
	PlayerRef.moveto(Pc_MarkRef)
	d1.moveto(Driver_MarkRef)
	;	boughtAsASlave = 1
	Debug.MessageBox("With the transaction on the ownership of your very life completed you are escorted from the auction house and outside the gates of Riften. Your escort leaves you with the local carriage driver. You expect to be loaded up and shipped off to some living hell, but instead the driver begins speaking to you in a joval tone...")
	CalculateDebt()
endfunction

function CalculateDebt()
	int myDebt = Utility.RandomInt(MCM.iSSminDebt, MCM.iSSmaxDebt)
	int tmp = sluts_arrears_amount.getvalueint()
	sluts_arrears_amount.setvalueint(tmp + myDebt)
endfunction

SlutsMain property Init auto
Function CallInit()
	;/	int tmout = 0
	;	actor pc_ref = pc.getreference() as actor
	;	if (pc_ref.GetActorBase().GetSex() != 0)
	If(!Init.SetStage(30))
		Debug.Trace("Can't start SLUTS_Init Quest")
		return
	EndIf
	;	endif
	;	int tmp = sluts_arrears_amount.getvalueint()
	;	sluts_arrears_amount.setvalueint(tmp + 5000)
	;/SetStage already starts the Quest and is latent. This is an utterly 	pointless check (the Quest is supposed to always be active anyway)
	while !kicker.isRunning()
		tmout += 1
		if tmout > 30
			Debug.Trace("can't start sluts kicker quest")
			return
		endif
		utility.wait(0.1)
	endwhile
	Init.StartHaul(d1)
endfunction

;Unused Properties
;actor property d0 auto ;Markarth
;actor property d2 auto ;Solitude
;actor property d3 auto ;Whiterun
;actor property d4 auto ;Windhelm
;imagespacemodifier property light_imod auto
;imagespacemodifier property dark_imod auto
;formlist property drivers auto
;referencealias property pc auto
;referencealias property pc_mark auto
;referencealias property carter_mark auto
;ReferenceAlias property Carter auto


Driver is not random anymoar, so no need for those Functions
actor function random_driver_stupid()
	Debug.Trace("sluts bridge: driver formlist = " + drivers)
	int len = drivers.getsize()
	Debug.Trace("sluts bridge: driver formlist size = " + len)
	int lim = len - 1
	Debug.Trace("sluts bridge: driver formlist index limit = " + lim)
	int idx = utility.randomint(0, lim)
	Debug.Trace("sluts bridge: driver formlist index = " + idx)
	form f = drivers.getat(idx) as actor
	Debug.Trace("sluts bridge: driver formlist selected form = " + f)
	actor a = f as actor
	if a == none
		Debug.Trace("sluts bridge: error - selected form is not an actor")
	endif
	return a
endfunction

actor function random_driver()
	int idx = utility.randomint(0, 5)
	if idx == 0
		return d0
	elseif idx == 1
		return d1
	elseif idx == 2
		return d2
	elseif idx == 3
		return d3
	else
		return d4
	endIf
endfunction

function actors_to_marks()
	actor pc_ref = pc.getreference() as actor
	actor driver_ref = carter.getreference() as actor

	objectreference pc_mark_ref = pc_mark.getreference()
	objectreference driver_mark_ref = carter_mark.getreference()


	pc_ref.moveto(pc_mark_ref)
	driver_ref.moveto(driver_mark_ref)

	;	boughtAsASlave = 1
	messagebox("With the transaction on the ownership of your very life completed you are escorted from the auction house and outside the gates of Riften. Your escort leaves you with the local carriage driver. You expect to be loaded up and shipped off to some living hell, but instead the driver begins speaking to you in a joval tone...")
	assign_MCMdebt()
endfunction

function assign_MCMdebt()
	;	actor pc_ref = pc.getreference() as actor
	;	if (pc_ref.GetActorBase().GetSex() == 0)
	;		return
	;	endif
	int myDebt
	int Rand = utility.randomint(0, 29)
	if Rand > 19
		myDebt = MCM.SS_debtC
	elseif Rand < 10
		myDebt = MCM.SS_debtA
	else
		myDebt = MCM.SS_debtB
	endif
	int tmp = sluts_arrears_amount.getvalueint()
	sluts_arrears_amount.setvalueint(tmp + myDebt)
	;	notification("You are indentured to work off an arrears of " + sluts_arrears_amount.getvalueint() + " gold for S.L.U.T.S.")
endfunction/;
