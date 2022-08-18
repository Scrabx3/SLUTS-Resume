;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 17
Scriptname QF_SLUTS_MissionHaul_0B00FB04 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY StartHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_StartHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DestHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_DestHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY KartRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_KartRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY HumiliChestRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_HumiliChestRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneRecipient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneRecipient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DestHoldCap
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_DestHoldCap Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY EscrowChestRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_EscrowChestRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RecipientRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RecipientRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DispatcherRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DispatcherRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ScenePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ScenePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneSpell
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneSpell Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Manifest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Manifest Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
; Voluntarely doing another haul
SetObjectiveCompleted(kmyQuest.qstage)

kmyQuest.Blackout()
kmyQuest.CreateChainMission(false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
; Haul Series is done. Enable Escrow n all that
SendModEvent("SLUTS_MissionQuit")
CompleteAllObjectives()

kmyQuest.Blackout()
kmyQuest.Quit()

SetObjectiveDisplayed(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
;/ This is unused V3+

 Run successfully completed and doing another haul
Game.GetPlayer().RemoveItem(Alias_Manifest.GetReference(), 1, true)
CompleteAllObjectives()
kmyQuest.ChainMission(0)
/;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
; Setup completed
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
kmyQuest.data.UpdateGlobals()

SendModEvent("SLUTS_MissionEnd")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
SendModEvent("SLUTS_MissionStart")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
;/ This is unused V3+

; Fail Haul
Game.GetPlayer().RemoveItem(Alias_Manifest.GetReference(), 1, true)
FailAllObjectives()
kmyQuest.FailHaul() ; This also start a chainhaul
/;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
; Setup Scene completed, Quest started properly here
SendModEvent("SLUTS_MissionHaul", kmyQuest.GetState())
SetObjectiveDisplayed(20)

kmyQuest.HandleStage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Run successfully completed with picking up a chest
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
;/ This is unused V3+

Run successfully completed and forced into another haul
Game.GetPlayer().RemoveItem(Alias_Manifest.GetReference(), 1, true)
CompleteAllObjectives()
kmyQuest.ChainMission(1)
/;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
; Forced into another Haul
SetObjectiveCompleted(kmyQuest.qstage)

kmyQuest.Blackout()
kmyQuest.CreateChainMission(true)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property recipIntro  Auto  
