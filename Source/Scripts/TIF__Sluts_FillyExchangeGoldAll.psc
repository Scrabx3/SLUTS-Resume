;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__Sluts_FillyExchangeGoldAll Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
float myCoins = PlayerRef.GetItemCount(FillyCoins) as float
int goldGain = Math.Floor(myCoins/100.0)

PlayerRef.AddItem(Gold001, goldGain)
PlayerRef.RemoveItem(FillyCoins, (goldGain*37), true)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property FillyCoins  Auto  

MiscObject Property Gold001  Auto  

Actor Property PlayerRef  Auto  
