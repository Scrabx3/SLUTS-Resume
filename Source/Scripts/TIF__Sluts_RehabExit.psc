;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF__Sluts_RehabExit Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If(Main.GetStage() < 30)
	Main.SetStage(30)
EndIf

;/
SlutsMCM MCM = GetOwningQuest() as SlutsMCM
slutsCrime.SetCrimeGold(Math.Floor(tmpCrimeGold.Value * ((MCM.iRehabtRate + 1) * 30)))
int crimeG = slutsCrime.GetCrimeGold()
If(MCM.bLargeMsg)
	Debug.MessageBox("S.L.U.T.S. Pony Rehabilitation Program has determined that your " + tmpCrimeGold.Value as int + " fine calculates into a " + crimeG + " Arrear.")
else
	Debug.Notification("S.L.U.T.S. Pony Rehabilitation Program has determined that your " + tmpCrimeGold.Value as int + " fine calculates into a " + crimeG + " Arrear.")
endif
tmpCrimeGold.SetValue(0)
/;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
RehabMsg.Show(Main.SlutsCrime.GetCrimeGold())
Main.StartHaul(akSpeaker, forced = 1)
GetOwningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsMain Property main  Auto  

Message Property RehabMsg  Auto  
