;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname SF_Sluts_SS_Scene_0A014C39 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
If(Main.GetStage() != 30)
	Main.SetStage(30)
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SendModEvent("dhlp-Resume")
Game.SetPlayerAIDriven(true)
SS.PlaceActors()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SendModEvent("dhlp-Suspend")
SS.StartHaul()
Game.SetPlayerAIDriven(false)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsSSIntegration Property SS  Auto  

Quest Property Main  Auto  
