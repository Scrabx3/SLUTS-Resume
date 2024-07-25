Scriptname SlutsSSIntegration extends Quest Conditional

SlutsMCM property MCM auto
SlutsMain Property Main Auto
SlutsMissionHaul Property Haul Auto

ReferenceAlias Property CarterRef Auto ; Filled as akRef1 in Script Event
Keyword Property PlayerCarriageWait Auto
Keyword Property DriverCarriageWait Auto
Faction Property slutsCrime Auto
Message Property IntroMsg Auto
Message Property DebtMsg Auto
GlobalVariable Property TimesEnslaved Auto

; ---

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
	Debug.Trace("[SLUTS] Simple Slavery Start")
	ObjectReference playerWaitLoc = SlutsMain.GetLink(akRef1, PlayerCarriageWait)
	ObjectReference driverWaitLoc = SlutsMain.GetLink(akRef1, DriverCarriageWait)
	Game.GetPlayer().MoveTo(playerWaitLoc)
	akRef1.MoveTo(driverWaitLoc)
	Utility.Wait(0.5)	; Wait for loading Screen
	IntroMsg.Show()
	SetStage(5)	; Allow scene to progress to forcegreet

	int debt = Math.Floor(20000 * Math.Pow((MCM.iSSminDebt + 1), 2))
	int mod = Utility.RandomInt((debt/3), debt)
	Debug.Trace("[SLUTS] Simple Slavery Bounty Mod = " + mod)
	slutsCrime.ModCrimeGold(mod)
	TimesEnslaved.Value += 1
EndEvent

Function StartHaul()
	If(!Main.GetStageDone(30))
		Main.SetStage(30)
	EndIf
	SetStage(10)
	DebtMsg.Show(slutsCrime.GetCrimeGold())
	If (Haul.IsRunning())
		Haul.SetStage(297)
		Haul.CreateChainMission(true, -1, CarterRef.GetActorReference())
	Else
		If(!Main.StartHaul(CarterRef.GetActorReference(), forced = 1))
			Game.SetPlayerAIDriven(false)
		EndIf
	EndIf
	Stop()
EndFunction
