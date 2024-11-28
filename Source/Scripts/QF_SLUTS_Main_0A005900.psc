;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_SLUTS_Main_0A005900 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Velasco
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Velasco Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Windhelm
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Windhelm Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Falkreath
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Falkreath Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Morthal
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Morthal Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Solitude
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Solitude Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Markarth
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Markarth Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Riften
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Riften Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Dawnstar
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Dawnstar Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Winterhold
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Winterhold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Whiterun
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Whiterun Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
;Player read Flyer, talk to the Driver (again)
SetObjectiveCompleted(10)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

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
