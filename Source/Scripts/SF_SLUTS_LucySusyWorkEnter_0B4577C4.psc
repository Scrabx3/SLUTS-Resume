;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname SF_SLUTS_LucySusyWorkEnter_0B4577C4 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
If((zadCs.Find(LibC.GetDevice(SusyREF))) < 0)
 (zadCs[Utility.RandomInt(0, zadCs.Length - 1)] as zadcFurnitureScript).LockActor(SusyREF)
EndIf
LucyREF.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference[] Property zadCs  Auto

Actor Property LucyREF  Auto

Actor Property SusyREF  Auto

zadclibs Property LibC  Auto
