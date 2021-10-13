;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname TIF__Sluts_SetDownLostKart Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Stopping the Scene..
; need to do this here even though we 
; already cancel it on dialogue end, otherwise
; the new setup scene will becanceled and
; meh...
GetOwningQuest().SetStage(55)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
GetOwningQuest().SetStage(480)
;/
Haul.Data.resetovertimeBonus()
Haul.ToBePayed = -55000
Haul.PayChest()

Haul.ChainMission(1)
/;
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsMissionHaul Property Haul  Auto  
