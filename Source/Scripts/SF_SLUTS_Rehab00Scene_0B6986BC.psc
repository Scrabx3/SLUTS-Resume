;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SF_SLUTS_Rehab00Scene_0B6986BC Extends Scene Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
ObjectReference where = PlayerLoc.GetReference()
FadeToBlackImod.Apply()
Utility.Wait(2)
FadeToBlackImod.PopTo(FadeToBlackHoldImod)
Utility.Wait(3)
Game.GetPlayer().MoveTo(where)
Guard.GetReference().MoveTo(where, afYOffset = -100.0)
Utility.Wait(0.5)
FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SendModEvent("dhlp-Resume")
game.setplayeraidriven(false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SendModEvent("dhlp-Suspend")
game.SetPlayerAIDriven(true)
Game.GetPlayer().StopCombatAlarm()

ObjectReference root = StorageUtil.GetFormValue(Driver.GetReference(), "SLUTS_ROOT") as ObjectReference
PlayerLoc.ForceRefTo(root.GetLinkedRef(PlayerCarriage))
GetOwningQuest().SetStage(5)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property Guard  Auto  

ReferenceAlias Property Driver  Auto  

ReferenceAlias Property PlayerLoc  Auto  

Keyword Property PlayerCarriage  Auto  

ImageSpaceModifier Property FadeToBlackImod  Auto  

ImageSpaceModifier Property FadeToBlackBackImod  Auto  

ImageSpaceModifier Property FadeToBlackHoldImod  Auto  
