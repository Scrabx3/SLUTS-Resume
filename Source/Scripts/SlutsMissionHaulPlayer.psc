Scriptname SlutsMissionHaulPlayer extends ReferenceAlias  

SlutsMissionHaul Property Haul
  SlutsMissionHaul Function Get()
    return GetOwningQuest() as SlutsMissionHaul
  EndFunction
EndProperty

Faction Property CrimeFaction Auto
MiscObject Property Gold001 Auto

Message Property ArrearsClear Auto
Message Property ArrearsPay Auto

Event OnInit()
  AddInventoryEventFilter(Gold001)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  int debt = CrimeFaction.GetCrimeGold()
  If (debt > 0)
    debt = SlutsData.GetGoldFromCoin(debt)
    If(debt < aiItemCount)
      GetReference().RemoveItem(akBaseItem, debt, true)
      CrimeFaction.SetCrimeGold(0)
      ArrearsClear.Show()
    Else
      int paid = SlutsData.GetCoinFromGold(aiItemCount)
      GetReference().RemoveItem(akBaseItem, aiItemCount, true)
      CrimeFaction.ModCrimeGold(-paid)
      ArrearsPay.Show(paid)
    EndIf
  EndIf
EndEvent

Event OnPlayerLoadGame()
  If(Haul.MissionType.Value == 0)
    Haul.OnLoadTether()
  EndIf
EndEvent