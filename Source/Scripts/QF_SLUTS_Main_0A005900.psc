;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_SLUTS_Main_0A005900 Extends Quest Hidden

;BEGIN ALIAS PROPERTY RehabGuard
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RehabGuard Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RehabDriver
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RehabDriver Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Vaslaco
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Vaslaco Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_SceneLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ScenePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ScenePlayer Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
;Player talked to the Driver and accepted
SetObjectiveCompleted(20)
Actor pl = Game.GetPLayer()
pl.AddToFaction(SlutFac)
pl.AddItem(memberKey)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
;Player read Flyer, talk to the Driver (again)
SetObjectiveCompleted(10)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE SlutsMain
Quest __temp = self as Quest
SlutsMain kmyQuest = __temp as SlutsMain
;END AUTOCAST
;BEGIN CODE
;Player talked to a Steward/Innkeeper/Driver
;Hand them over the Flyer
Alias_Player.GetReference().AddItem(Flyer)
SetObjectiveCompleted(5)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Book Property Flyer  Auto  

Faction Property SlutFac  Auto  

Key Property memberKey  Auto  
