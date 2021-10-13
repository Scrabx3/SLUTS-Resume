;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF__Sluts_RehabExit Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;/The player could run away while this dialogue
was finishing. While the effect still worked it
would be a bit odd having them run to the
other side of town only to stop and obediently
walk back :P
/;
Game.DisablePlayerControls()

Utility.Wait(2)
If(GetOwningQuest().GetStage() < 30)
	GetOwningQuest().SetStage(30)
endIf

SlutsMCM MCM = GetOwningQuest() as SlutsMCM
slutsCrime.SetCrimeGold(Math.Floor(tmpCrimeGold.Value * ((MCM.iRehabtRate + 1) * 30)))
int crimeG = slutsCrime.GetCrimeGold()
If(MCM.bLargeMsg)
	Debug.MessageBox("S.L.U.T.S. Pony Rehabilitation Program has determined that your " + tmpCrimeGold.Value as int + " fine calculates into a " + crimeG + " Arrear.")
else
	Debug.Notification("S.L.U.T.S. Pony Rehabilitation Program has determined that your " + tmpCrimeGold.Value as int + " fine calculates into a " + crimeG + " Arrear.")
endif
tmpCrimeGold.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;If there currently exists an Escrow Chest, move its contents into the Tmp Chest
; ObjectReference Escrow = Haul.EscrowChestRef.GetReference()
; If (Haul.Escrow)
; 	haul.data.handleChest(Escrow)
; endIf
;Give the player control back when the rehabber is done talking.
Game.EnablePlayerControls()

If(Haul.GetStage() == 40)
	Haul.ChainMission(1,1)
else
	(GetOwningQuest() as SlutsMain).StartHaul(akSpeaker, forced = 1)
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsMissionHaul Property Haul  Auto

; SlutsEscrow Property Escrow Auto

GlobalVariable Property tmpCrimeGold  Auto

Faction Property slutsCrime Auto
