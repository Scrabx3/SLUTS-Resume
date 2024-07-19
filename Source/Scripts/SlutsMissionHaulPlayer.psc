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
Message Property PackageDestroyed Auto

float Property Pilferage
	float Function Get()
		return Haul.Pilferage
	EndFunction
	Function Set(float afValue)
		Haul.UpdatePilferage(afValue)
	EndFunction
EndProperty

Event OnInit()
  AddInventoryEventFilter(Gold001)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  int debt = CrimeFaction.GetCrimeGold()
  If (debt <= 0)
    return
  EndIf
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
EndEvent

Event OnPlayerLoadGame()
  Haul.Maintenance()
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	Haul.HandleOnHit(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
EndEvent
