;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname QF_Sluts_YagdolBookSearch_0B4481A8 Extends Quest Hidden

;BEGIN ALIAS PROPERTY UncommonTaste
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_UncommonTaste Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Yagdo
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Yagdo Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveCompleted(10)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Game.GetPlayer().AddItem(QuestReward)
CommonTaste.Enable()
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

LeveledItem Property QuestReward  Auto  

ObjectReference Property CommonTaste  Auto  
