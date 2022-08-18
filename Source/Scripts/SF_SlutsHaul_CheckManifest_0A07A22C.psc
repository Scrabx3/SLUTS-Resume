;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname SF_SlutsHaul_CheckManifest_0A07A22C Extends Scene Hidden

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; Haul.PayChest()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SendModEvent("dhlp-Suspend")
Haul.Befriend()
Game.GetPlayer().StopCombatAlarm()
game.SetPlayerAIDriven(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
Haul.spontaneousFailure()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
SendModEvent("dhlp-Resume")
Haul.Unfriend()
game.setplayeraidriven(false)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsMissionHaul Property Haul  Auto  
