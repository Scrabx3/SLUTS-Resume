;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF__Sluts_RehabEntry Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;Moved content into <- (Fragment0)

RehabScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
SendModEvent("dhlp-Suspend")
game.SetPlayerAIDriven(true)

If(PlayerRef.WornHasKeyword(Bd.Dev_Key[0]))
	Bd.RemoveConflictingDevice(0)
endIf

Faction crimeFac = akSpeaker.GetCrimeFaction()
int cGV = crimeFac.GetCrimeGoldViolent()
int cGN = crimeFac.GetCrimeGoldNonviolent()

crimeFac.ModCrimeGold(-cGN, abViolent = False)
crimeFac.ModCrimeGold(-cGV, abViolent = true)
crimeGold.SetValue(cGV + cGN)
int myHold
if(crimeFac == CrimeFactions[0])
	myHold = 0
ElseIf(crimeFac == CrimeFactions[1] || crimeFac == CrimeFactions[9])
	myHold = 1
ElseIf(crimeFac == crimefactions[2])
	myHold = 2
ElseIf(crimeFac == crimefactions[3])
	myHold = 3
ElseIf(crimeFac == crimefactions[4])
	myHold = 4
ElseIf(crimeFac == crimefactions[5])
	myHold = 5
ElseIf(crimeFac == crimefactions[6])
	myHold = 6
ElseIf(crimeFac == crimefactions[7])
	myHold = 7
ElseIf(crimeFac == crimefactions[8])
	myHold = 8
endIf

RehabGuard.ForceRefTo(akSpeaker)
RehabCarriage.ForceRefTo((GetOwningQuest() as SlutsMain).myDrivers[myHold])
ScenePlayer.ForceRefTo(playerPositions[myHold])

;PlayerRef.MoveTo(playerPositions[myHold])
;Utility.Wait(2)
;(GetOwningQuest() as SlutsMain).myDrivers[myHold].Activate(PlayerRef)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsBondage Property bd  Auto

Actor Property PlayerRef  Auto

Faction[] Property CrimeFactions  Auto

ObjectReference[] Property playerPositions  Auto

GlobalVariable Property crimeGold  Auto

ReferenceAlias Property ScenePlayer  Auto

ReferenceAlias Property RehabGuard  Auto

ReferenceAlias Property RehabCarriage  Auto

Scene Property RehabScene  Auto
