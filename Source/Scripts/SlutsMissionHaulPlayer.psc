Scriptname SlutsMissionHaulPlayer extends ReferenceAlias  

SlutsMissionHaul Property Haul
  SlutsMissionHaul Function Get()
    return GetOwningQuest() as SlutsMissionHaul
  EndFunction
EndProperty

Faction Property CrimeFaction Auto
MiscObject Property Gold001 Auto

Event OnInit()
  AddInventoryEventFilter(Gold001)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  int debt = CrimeFaction.GetCrimeGold()
  If (debt > 0)
    ; TODO: Debt Reduction or so

  EndIf
EndEvent

Event OnPlayerLoadGame()
  If(Haul.MissionType.Value == 0)
    Haul.OnLoadTether()
  EndIf
EndEvent