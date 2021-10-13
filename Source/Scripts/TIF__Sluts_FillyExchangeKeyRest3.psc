;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__Sluts_FillyExchangeKeyRest3 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor PlayerRef = Game.GetPlayer()

PlayerRef.RemoveItem(FillyCoins, 60000, true)
PlayerRef.AddItem(RestKey, 3)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property FillyCoins  Auto  

Key Property Restkey  Auto  
