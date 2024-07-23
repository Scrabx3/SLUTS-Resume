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

Event OnInit()
  AddInventoryEventFilter(Gold001)
  OnHitLock = false
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

bool OnHitLock = false
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
  If (OnHitLock || abBashAttack || abHitBlocked || !haul.ShouldProcessOnHit())
    return
  EndIf
  OnHitLock = true
  Weapon srcW = akSource as Weapon
  Spell srcS = akSource as Spell
  float dmg = 0.0
  If (srcW)
    dmg = srcW.GetBaseDamage() * haul.MCM.iPilferageLevel as float
    If (!abPowerAttack)
      dmg /= 2
    EndIf
  ElseIf (srcS && srcS.IsHostile())
    int i = srcS.GetNumEffects()
    While(i > 0)
      i -= 1
      MagicEffect effect = srcS.GetNthEffectMagicEffect(i)
      If (effect.IsEffectFlagSet(0x1 + 0x4) && !effect.IsEffectFlagSet(0x2))
        dmg += srcS.GetNthEffectMagnitude(i)
      EndIf
    EndWhile
    dmg = (dmg * haul.MCM.iPilferageLevel as float) / 4
  EndIf
  haul.UpdatePilferage(haul.Pilferage + dmg)
  OnHitLock = false
EndEvent
