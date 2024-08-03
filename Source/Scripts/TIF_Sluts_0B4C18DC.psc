;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF_Sluts_0B4C18DC Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If (!Barrel.IsContainerEmpty())
  Barrel.RemoveAllItems()
EndIf
Barrel.AddItem(Rations, 1, true)
Form[] itms = Barrel.GetContainerForms()
int i = 0
While(i < itms.Length)
  int n = Barrel.GetItemCount(itms[i])
  int j = 0
  While(j < n)
    PlayerRef.EquipItem(itms[i], abSilent = (j > 0))
    j += 1
  EndWhile
  i += 1
EndWhile
Barrel.RemoveAllItems()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Potion[] Property FoodStuff  Auto  

Actor Property PlayerRef  Auto  

LeveledItem Property Rations  Auto  

ObjectReference Property Barrel  Auto  
