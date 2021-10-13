;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF__Sluts_NeedsFood Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
int Count = 3
While(Count)
	Count -= 1
	Utility.Wait(0.7) ; To not add everything at once... immersion things
	Potion myFood = FoodStuff[Utility.RandomInt(0,3)]
	PlayerRef.AddItem(myFood, abSilent = true)
	PlayerRef.EquipItem(myFood, abSilent = true)
endWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Potion[] Property FoodStuff  Auto  

Actor Property PlayerRef  Auto  
