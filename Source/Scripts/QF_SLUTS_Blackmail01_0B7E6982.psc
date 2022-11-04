;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname QF_SLUTS_Blackmail01_0B7E6982 Extends Quest Hidden

;BEGIN ALIAS PROPERTY BlackmailerLoc
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_BlackmailerLoc Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Blackmailer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Blackmailer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Recipient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Recipient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Package
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Package Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Quest fails with Stage10+ enabled

FailAllObjectives()

SetStage(200)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SetObjectiveCompleted(10)
SetObjectiveDisplayed(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
CompleteAllObjectives()
Stop()

Haul.GambleBlackmailFailure(Alias_Blackmailer.GetActorReference(), 2)
Haul.SetStage(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
if GetStage() < 100  ; if quest not completed yet
if GetStage() > 0  ; if any objective displayed
SetStage(199)
else
SetStage(200)
endif
endif

Game.GetPlayer().RemoveItem(Alias_Package.GetReference())
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; quest fails
Haul.Fail()
Haul.SetStage(100)

Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Game.SetPlayerAIDriven(0)

SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsMissionHaul Property Haul  Auto  
