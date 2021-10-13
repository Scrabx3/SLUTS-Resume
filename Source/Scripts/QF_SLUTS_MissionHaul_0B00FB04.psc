;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 9
Scriptname QF_SLUTS_MissionHaul_0B00FB04 Extends Quest Hidden

;BEGIN ALIAS PROPERTY RecipientRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RecipientRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DestHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_DestHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Manifest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Manifest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneRecipient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneRecipient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DispRoot
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DispRoot Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY KartRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_KartRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY HumiliChestRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_HumiliChestRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY EscrowChestRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_EscrowChestRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ScenePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ScenePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneKart
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneKart Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RecipRoot
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RecipRoot Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DispatcherRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DispatcherRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY StartHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_StartHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DestHoldCap
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_DestHoldCap Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneSpell
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneSpell Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
; Run successfully completed and forced into another haul
Game.GetPlayer().RemoveItem(Alias_Manifest.GetReference(), 1, true)
CompleteAllObjectives()
kmyQuest.ChainMission(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Called when a Haul is considered completed to interrupt the Haul Sequence
recipIntro.Stop()
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
; Called when the Scene to remove all filly gear is finished
SetObjectiveCompleted(20)
SetObjectiveCompleted(20 + kmyQuest.haulType)
SetObjectiveDisplayed(60)
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

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
; Fail Haul
Game.GetPlayer().RemoveItem(Alias_Manifest.GetReference(), 1, true)
FailAllObjectives()
kmyQuest.FailHaul() ; This also start a chainhaul
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Called when talking to the Recipient zz
recipIntro.Start()
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
; Run successfully completed and doing another haul
Game.GetPlayer().RemoveItem(Alias_Manifest.GetReference(), 1, true)
CompleteAllObjectives()
kmyQuest.ChainMission(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE SlutsMissionHaul
Quest __temp = self as Quest
SlutsMissionHaul kmyQuest = __temp as SlutsMissionHaul
;END AUTOCAST
;BEGIN CODE
; Called when a Haul properly starts
SetObjectiveDisplayed(20)
SetObjectiveDisplayed(20 + kmyQuest.haulType)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property recipIntro  Auto  
