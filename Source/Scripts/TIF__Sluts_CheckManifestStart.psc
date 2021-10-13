;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname TIF__Sluts_CheckManifestStart Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_3
Function Fragment_3(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
GetOwningQuest().SetStage(55)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(GetOwningQuest() as SlutsMissionHaul).CompleteHaul(checkManifest)

;/ Moved content into CheckManifest Scene
if Haul.pilferage == 0
	;;Let's check for Spontaneous Failure
	if (Utility.RandomInt(1,100) <= mcm.iSpontFail)
		if mcm.bSpontFailRandom
			;Deliberately set the chance above the 120 maximum. Overwise max would only have a 1 in 120 chance of happening.
			Haul.pilferage = (Utility.RandomInt(825,2400))
			if Haul.pilferage > 1800
				Haul.pilferage = 1800
			endif
		else
			Haul.pilferage = 1800
		endif

		string X = ""
		if Haul.pilferage < 1500
			X = "some of your cargo appears to be missing"
		elseif Haul.pilferage < 1800
			X = "much of your cargo is missing"
		else
			X = "your cargo is completely gone"
		endif
		Debug.Messagebox("In a moment of absent mindedness you glance behind you, only to notice to your horror that " + X + "! You have no idea what happened and can only shudder in a cold sweat knowing you will still have to answer for it...")
	endif
endif

Haul.calcWages()

Haul.HumilPick = utility.randomint(0,7))/;
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsMCM Property MCM  Auto  

Scene Property CheckManifest  Auto  

SlutsMissionHaul Property Haul  Auto  
