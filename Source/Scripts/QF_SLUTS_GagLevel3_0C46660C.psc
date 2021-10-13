;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_SLUTS_GagLevel3_0C46660C Extends Quest Hidden

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Anette
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Anette Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveDisplayed(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SetObjectiveCompleted(0)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Actor PlayerRef = Game.GetPlayer()

Armor toLock = dia.bd.GetRandomArmorReg(PlayerRef)
If(toLock == none)
  Debug.messagebox("You see Anette pulling out some Restraint but halfway on equipping it, she just falls asleep! Guess you're free to go away now.. and hope this doesn't come back to you.")
else
  dia.bd.equip(PlayerRef, toLock)
EndIf

Dia.upgradeGear(0)
CompleteAllObjectives()
CompleteQuest()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SlutsHQDialogue Property Dia  Auto  

MiscObject Property titanium  Auto  
