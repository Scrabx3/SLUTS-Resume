;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__Sluts_FillyExchangeGold100 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor PlayerRef = Game.GetPLayer()

PlayerRef.AddItem(Gold001, 100)
PlayerRef.RemoveItem(FillyCoin, 10000, true)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property FillyCoin  Auto  

MiscObject Property Gold001  Auto  
