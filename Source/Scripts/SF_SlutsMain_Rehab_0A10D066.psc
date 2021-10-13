;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SF_SlutsMain_Rehab_0A10D066 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
RehabGuard.GetReference().MoveTo(ScenePlayer.GetReference(), afYOffset = -100.0)
PlayerRef.MoveTo(ScenePlayer.GetReference())
;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SendModEvent("dhlp-Resume")
game.setplayeraidriven(false)
RehabGuard.GetReference().Reset()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef  Auto

ReferenceAlias Property RehabGuard  Auto

ReferenceAlias Property ScenePlayer  Auto
