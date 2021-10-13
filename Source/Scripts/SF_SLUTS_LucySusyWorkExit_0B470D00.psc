;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SF_SLUTS_LucySusyWorkExit_0B470D00 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
If(IsActionComplete(6))
	int count = zadCs.Length
	While(count)
		count -= 1
		If(zadCs.user != none)
			zadCs[count].UnlockActor()
		EndIf
	EndWhile
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

zadcFurnitureScript[]  Property zadCs  Auto  
