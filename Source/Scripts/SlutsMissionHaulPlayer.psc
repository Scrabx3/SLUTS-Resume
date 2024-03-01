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
		If (afValue > Haul.PilferageThresh03.GetValue())
      If (Haul.IsActiveMission(Haul.MISSIONID_PACKAGE))
        ObjectReference packageref = Haul.PackageREF.GetReference()
        int packagecount = GetReference().GetItemCount(packageref)
        If (packagecount > 0)
          GetReference().RemoveItem(packageref)
          PackageDestroyed.Show()
        EndIf
      EndIf
		EndIf
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

State CartHaul
	Event OnPlayerLoadGame()
    Haul.OnLoadTether()
  EndEvent
EndState

State SpecialDelivery
  
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		If(abBashAttack || abHitBlocked || Haul.MCM.iPilferageLevel == Haul.MCM.DIFFICULTY_EASY)
			return
		EndIf
		Weapon srcW = akSource as Weapon
		If(srcW)
			float dmg = srcW.GetBaseDamage()
			If (abPowerAttack)
				dmg *= 2
			EndIf
			Pilferage += (dmg * Haul.MCM.iPilferageLevel as float) / 2
			return
		EndIf
		Spell srcS = akSource as Spell
		If (srcS && srcS.IsHostile())
		  float dmg = 0.0
			int i = srcS.GetNumEffects()
			While(i > 0)
				MagicEffect effect = srcS.GetNthEffectMagicEffect(i)
				If (effect.IsEffectFlagSet(0x1 + 0x4) && !effect.IsEffectFlagSet(0x2))
					dmg += srcS.GetNthEffectMagnitude(i)
				EndIf
				i += 1
			EndWhile
			Pilferage += (dmg * Haul.MCM.iPilferageLevel as float) / 4
			return
		EndIf
	EndEvent

EndState
