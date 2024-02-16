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

State CartHaul
	Event OnPlayerLoadGame()
    Haul.OnLoadTether()
  EndEvent
EndState

State SpecialDelivery
  Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    Weapon wep = akSource as Weapon
    If(!wep)
      Spell spll = akSource as Spell
      If(!spll || !spll.IsHostile())
        return
      EndIf
      int i = spll.GetCostliestEffectIndex()
      MagicEffect effect = spll.GetNthEffectMagicEffect(i)
      If(effect.GetAssociatedSkill() == "Destruction")
        Haul.Pilferage += Haul.GoodsTotal * 0.01
      EndIf
    Else
      If(abPowerAttack)
        Haul.Pilferage += Haul.GoodsTotal * 0.03
      Else
        Haul.Pilferage += Haul.GoodsTotal * 0.01
      EndIf
    EndIf
  EndEvent
EndState
