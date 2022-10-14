;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname SF_Sluts_SS_Scene_0A014C39 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; SS made some weird choice which removes the AI driven flag mid scene here...
; Player could run off now, which we obvsly dont want
Game.SetPlayerAIDriven(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SendModEvent("dhlp-Suspend")
game.SetPlayerAIDriven(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SendModEvent("dhlp-Resume")
SS.StartHaul()
; Game.SetPlayerAIDriven(false) ; Done by Haul Q
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsSSIntegration Property SS  Auto  

