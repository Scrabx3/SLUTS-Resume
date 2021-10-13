;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname SF_SlutsHaul_SetUp_0A06AEA3 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
Game.SetPlayerAIDriven(false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SendModEvent("dhlp-Resume")
game.setplayeraidriven(false)
GetOwningQuest().SetStage(22)
Haul.Unfriend()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SendModEvent("dhlp-Suspend")
game.SetPlayerAIDriven(true)
Game.GetPlayer().StopCombatAlarm()
Haul.Befriend()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Haul.TransferManifest()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsMissionHaul Property Haul  Auto  
