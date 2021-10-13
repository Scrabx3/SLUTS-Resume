Scriptname SlutsData extends Quest Conditional
{Utility script for Storage, Payment, Escrowchest Monitoring & Filly Rewards}
; ---------------------------------- Generic Properties
SlutsMCM property MCM auto

MiscObject Property Gold001 Auto
MiscObject Property FillyCoin Auto
Faction Property SlutsCrimeFaction Auto
Actor Property PlayerRef Auto
; ======================================================
; =============================== LICENSES
; ======================================================
int Property licenseEscrowPort = 0 Auto Hidden Conditional
{For this many Runs, the Default Escrows Location will be near the Recipient rather than the Dispatcher}
; ======================================================
; =============================== FILLY GEAR
; ======================================================
; Reinforcement Level
int Property uniformReinforceLvBoots = 0 Auto Hidden Conditional
int Property uniformReinforceLvGloves = 0 Auto Hidden Conditional
int Property uniformReinforceLvGag = 0 Auto Hidden Conditional
int Property uniformReinforceLvBlindfold = 0 Auto Hidden Conditional
int Property uniformReinforceLvChastity = 0 Auto Hidden Conditional
; Accessoires
bool Property useBlindfold = false Auto Hidden Conditional
bool Property useChastity = false Auto Hidden Conditional
; ======================================================
; =============================== HAUL STATISTICS
; ======================================================
; ---------------------------------- Progression Data
GlobalVariable Property RunsCompleted Auto
{Times the Player completed a Series (opened Escrow Chest)}
GlobalVariable Property HaulsCompleted Auto
{Amout of single Hauls the Player completed}
GlobalVariable Property HaulsCompletedStreak Auto
{Highest amount of Hauls completed in a single Streak, forced and voluntary}
GlobalVariable Property HaulsPerfect Auto
{Amount of perfect Hauls the Player completed total}
GlobalVariable Property HaulsPerfectStreak Auto
{Highest amount of perfect Hauls in a row}
GlobalVariable Property HaulsPerfectStreakAllTime Auto
{Amount of perfect Hauls in a row across multiple Runs}
GlobalVariable Property voluntaryHaulsCompleted Auto
{Amount of voluntary Hauls the Player has completed}
GlobalVariable Property voluntaryHaulsCompletedStreak Auto
{Highest amount of voluntary Hauls the Plyer has completed in a row}
GlobalVariable Property ForcedHaulsCompleted Auto
{Amountfs of forced Hauls the Player completed}
GlobalVariable Property ForcedHaulsCompletedStreak Auto
{Highest amount of forced Hauls the Player has completed in a row}
int Property streak = 0 Auto Hidden Conditional
{The current Haul-Streak, positive = voluntary - negative = forced}
int Property streakTotal = 0 Auto Hidden Conditional
{The current Haul Streak, forced and voluntary combined}
int Property streakPerfect = 0 Auto Hidden Conditional
{The current perfect haul streak. Missionhaul stacks this for every haul it considers "perfect"}

; Called at the end of each Haul
Function UpdateStatistics(bool forced)
  HaulsCompleted.Value += 1
  streakTotal += 1
  If(HaulsCompletedStreak.Value < streakTotal)
    HaulsCompletedStreak.Value = streakTotal
  EndIf

  If(forced)
    ForcedHaulsCompleted.Value += 1
    If(streak >= 0)
      streak = -1
    else
      streak -= 1
      If(ForcedHaulsCompletedStreak.Value < -streak)
        ForcedHaulsCompletedStreak.Value = -streak
      EndIf
    EndIf
  else
    voluntaryHaulsCompleted.Value += 1
    If(streak <= 0)
      streak = 1
    else
      streak += 1
      If(voluntaryHaulsCompletedStreak.Value < streak)
        voluntaryHaulsCompletedStreak.Value = streak
      EndIf
    EndIf
  EndIf
EndFunction

; Called on payOut
Function endRun()
  RunsCompleted.value += 1
  streak = 0
  streakTotal = 0
  streakPerfect = 0
EndFunction

; Called at the end of a perfect Haul
Function addStreakPerfect()
  streakPerfect += 1
  HaulsPerfect.Value += 1
  HaulsPerfectStreakAllTime.Value += 1
  If(HaulsPerfectStreak.Value < streakPerfect)
    HaulsPerfectStreak.Value = streakPerfect
  EndIf
EndFunction

; Called at the end of a non-purrfect haul
Function clearStreakPerfect()
  If(HaulsPerfectStreak.Value < streakPerfect)
    HaulsPerfectStreak.Value = streakPerfect
  EndIf
  streakPerfect = 0
  HaulsPerfectStreakAllTime.Value = 0
EndFunction
; ======================================================
; =============================== OVERTIME
; ======================================================
float Function getOvertimebonus()
  If(SlutsCrimeFaction.GetCrimeGold() > 0 || streakPerfect == 1)
    ; last haul wasnt perfect or indepted, no bonus
    return 1.0
  else
    float toRet
    int hauls = streakPerfect - 1
    If(hauls > 15)
      toRet = Math.Floor(MCM.fOvertimeGrowth * 5)
    else
      toRet = (MCM.fOvertimeGrowth * (Math.pow(1.4, (0.3 * hauls))) - (MCM.fOvertimeGrowth) + 1)
    EndIf
    ;Setvalue(data.overtimeBonus.getvalue() + 1)
    int bonusPerCent = Math.Ceiling(toRet * 100)
    ; notify("Having agreed to " + streakPerfect + " hauls in a row your overtime bonus is now " + bonusPerCent + "%")
    Debug.Trace("Overtime Bonus: " + bonusPerCent + "%")
    return toRet
  EndIf
EndFunction
; ======================================================
; =============================== UTILITY
; ======================================================
Function notify(string msg)
  If(MCM.bLargeMsg)
    Debug.MessageBox(msg)
  else
    Debug.Notification(msg)
  EndIf
EndFunction

Function RemoveAllNonDDItems(Actor me, ObjectReference chest)
  int numItems = me.GetNumItems()
  Keyword SLSLicense = Keyword.GetKeyword("_SLS_LicenceDocument")
  bool SLS = SLSLicense != none
  While(numItems)
    numItems -= 1
    Form item = PlayerRef.GetNthForm(numItems)
    bool skip = false
    If(SLS)
      skip = !item.HasKeyword(SLSLicense)
    EndIf
    If(!item.HasKeyword(MCM.bd.SlutsRestraints) && !skip)
      PlayerRef.RemoveItem(item, PlayerRef.GetItemCount(item), true, chest)
    EndIf
  EndWhile
EndFunction


;/ Updating tmpPay with current runs basePay (which may or may not have been manipulated at this point)
Function updatePayment(int basePay)
  tmpPay += basePay
EndFunction
; Managing debt and/or deposition of Gold in Chest; should be called at the end of each Run
Function PayOut()
  ; This is always called at the end of a haul session, so make sure to reset counters
  If(tmpPay == 0)
    ; anything * 0 is nothing, so we can go home here
    ResetOvertimeBonus()
    return
  EndIf
  If(EscrowChest == none)
    Debug.MessageBox("Escrow Chest not found, abandon")
    ResetOvertimeBonus()
    return
  EndIf
  ; Applying overtime Bonus
  tmpPay = Math.Ceiling((1 + overtimeBonus) * tmpPay)
  ; Manage Debt and/or Payment
  If(tmpPay > 0)
    ;If you made profit, first check that you can keep it and dont have any Arrears to pay
    If(SlutsArrears.Value > 0)
      int myDebt = SlutsArrears.Value as int
      int afterPayedDebt = tmpPay - myDebt
      SlutsArrears.Value = myDebt - tmpPay
      If(SlutsArrears.Value < 0)
        SlutsArrears.Value = 0
      EndIf
      ;Cleared (part) of debt, now check if theres anything left to be payed - or if debt is only paid partially how much debt is left
      If(afterPayedDebt > 0)
        ;Debt fully cleared and theres a leftover to be added to your Account
        EscrowChest.AddItem(Sluts_FillyCoin, afterPayedDebt, true)
        If(MCM.bLargeMsg)
          Debug.MessageBox("After finally paying off your Arrears, you are now Debt free!\nAdditionally " + afterPayedDebt + " Filly Coins have been added to your Escrow Chest!")
        else
          Debug.Notification("After finally paying off your Arrears, you are now Debt free!\nAdditionally " + afterPayedDebt + " Filly Coins have been added to your Escrow Chest!")
        EndIf
      Else
        ;Debt isnt cleared yet (or you just barely made it)
        If(MCM.bLargeMsg)
          Debug.MessageBox((tmpPay/37) + "g has been deducted from your debt, bringing your Arrears down to " + (SlutsArrears.Value/37) as int)
        else
          Debug.Notification((tmpPay/37) + "g has been deducted from your debt, bringing your Arrears down to " + (SlutsArrears.Value/37) as int)
        EndIf
      EndIf
    else
      ;You are debt free, profit is fully converted to Filly Coins!
      EscrowChest.AddItem(Sluts_FillyCoin, tmpPay, true)
      If(MCM.bLargeMsg)
        Debug.MessageBox(tmpPay + " Filly Coins have been added to your Escrow Chest!")
      else
        Debug.Notification(tmpPay + " Filly Coins have been added to your Escrow Chest!")
      EndIf
    EndIf
  else
    ;You increased your debt, bad pony!
    If(!MCM.bAllDebtToArrears)
      If(EscrowChest.GetItemCount(Gold001) + (tmpPay/37) >= 0)
        ;Gold inside your (tmp) Escrow Chest is used to pay for the damage
        EscrowChest.RemoveItem(Gold001, (-tmpPay/37))
        If(MCM.bLargeMsg)
          Debug.MessageBox((-tmpPay/37) + "g has been removed from your Escrow Chest to pay for the damage you caused. You now have " + EscrowChest.GetItemCount(Gold001) + "gold in your Escrow Chest.")
        else
          Debug.Notification((-tmpPay/37) + "g has been removed from your Escrow Chest to pay for the damage you caused. You now have " + EscrowChest.GetItemCount(Gold001) + "gold in your Escrow Chest.")
        EndIf
      else
        ;You dont have enough money to pay for the damage you caused
        int myGold = EscrowChest.GetItemCount(Gold001)
        EscrowChest.RemoveItem(Gold001, (myGold - MCM.iMinGold))
        SlutsArrears.Value += (-tmpPay/37) - (myGold - MCM.iMinGold)
        If(mcm.bLargeMsg)
          Debug.MessageBox("Your " + (-tmpPay/37) + " fine is more than you can cover. You're left with merely " + MCM.iMinGold + " gold in your Escrow Chest and have Arrears of " + SlutsArrears.Value as int + "g to pay off.")
        else
          Debug.Notification("Your " + (-tmpPay/37) + " fine is more than you can cover. You're left with merely " + MCM.iMinGold + " gold in your Escrow Chest and have Arrears of " + SlutsArrears.Value as int + "g to pay off.")
        EndIf
      endIf
    else
      SlutsArrears.Value += (-tmpPay/37)
      If(mcm.bLargeMsg)
        Debug.MessageBox("Your debt increased by " + (-tmpPay/37) + "g. Your Arrears is now " + SlutsArrears.Value as int + "g.")
      else
        Debug.Notification("Your debt increased by " + (-tmpPay/37) + "g. Your Arrears is now " + SlutsArrears.Value as int + "g.")
      EndIf
    EndIf
  EndIf
  ResetOvertimeBonus()
  tmpPay = 0
endFunction
; Should be called at the start of each individual run
; Calculates Overtime Multiplikator or resets it
Function ManageOvertime()
  If(SlutsArrears.Value > 0 || chainedHauls == 0)
    ;First run or indepted, no overtime Bonus
    overtimeBonus = 0
  else
    int hauls = chainedHauls
    If(hauls > 15)
      hauls = 15
    EndIf
    overtimeBonus = (MCM.fOvertimeGrowth * (Math.pow(1.5, (0.3 * hauls))) - MCM.fOvertimeGrowth)
    ;Setvalue(data.overtimeBonus.getvalue() + 1)
    int bonusPerCent = Math.Ceiling((overtimeBonus + 1) * 100)
    If(MCM.bLargeMsg)
      Debug.MessageBox("Having agreed to " + chainedHauls + " hauls in a row your overtime bonus is now " + bonusPerCent + "%")
    else
      Debug.Notification("Having agreed to " + chainedHauls + " hauls in a row your overtime bonus is now " + bonusPerCent + "%")
    EndIf
    Debug.Trace("Overtime Bonus: " + bonusPerCent + "%")
  EndIf
  chainedHauls += 1
EndFunction
; Should always be called after a failed Run or Quitting a series of hauls
Function resetOvertimeBonus()
	If(!hasFillyReward)
    check_fillyreward()
  EndIf
  overtimeBonus = 0
	chainedHauls = 0
EndFunction
; ---------------------------------- Escrow Chest & Chest Loc
; This is always called when the Player properly completes a run (opens the Chest & gets their stuff back)
Function escrowCleared()
  currentQuest.CompleteAllObjectives()
	currentQuest.SetStage(500)
  currentQuest.Stop()
  Utility.Wait(1)
  currentQuest = none
  EscrowChest.RemoveAllItems(PlayerRef)
	EscrowChest = none
  startingLocID = -1
  CurrentCart = none
  runsCompleted += 1
EndFunction

Function fetchChestLoc(ObjectReference driver0)
  startingLocID = ((MCM as Quest) as SlutsMain).myDrivers.Find(driver0 as Actor)
EndFunction

Function handleChest(ObjectReference chest)
	If(EscrowChest == none)
		; If theres currently no Escrow Chest, set the current chest as Escrow
		EscrowChest = chest
	EndIf
	If(!MCM.bNoRemoveItems)
    RemoveAllNonDDItems(PlayerRef, chest)
  Else
    PlayerRef.removeitem(Gold001, 9999999, true, chest)
  EndIf
EndFunction
;/ ---------------------------------- Filly Reward System
Additional reward if you do (3) or more consecutive perfect runs
The reward contains some restraints and additional Gold (*cough, cough, I meant Filly Coins) ;
; - Amount of runs to Qualify for a Reward
int property fillyrank = 3 auto Hidden
; - Bool to let the Escrow Chest know that you have earned a Filly Reward
bool property hasFillyReward = false auto Hidden
; - Additional Items added to the Escrow Chest
int property FillyGold auto hidden ;Used in Escrow Chest
book property fillyLetter auto
armor[] property fillyWear_X auto
armor[] property fillyWear_T auto
armor[] property fillyWear_0 auto
armor[] property fillyWear_1 auto
armor[] property fillyWear_2 auto
armor[] property fillyWear_3 auto
armor[] property fillyWear_4 auto


function check_fillyreward()
	If(chainedHauls == fillyrank)
		EscrowChest.additem(fillyLetter,1)
	EndIf
	if chainedHauls >= fillyrank
		hasFillyReward = true
		FillyGold = ((fillyrank * (fillyrank - 1) * 200) + 50) * 37
		;Debug.MessageBox("While reclaiming your stuff you also find a set of restraints, along with a pay bonus of " + paybonus + " and a letter of commendation inside the escrow chest...")
		;Debug.Notification("To collect another Filly Wear bonus you must now complete " + fillyrank + " willing runs in a row.")
		;referencealias FL
		;FL.ForceRefTo(fillyLetter)
		;objectreference LetterRef = a.additem(fillyLetter,1)
		;LetterRef.activate(PC.getreference())
		;/ TODO Reworking this
		Escrow.additem(Sluts_FillyCoin, FillyGold)
		Escrow.additem(fillyWear_X[0],1)
		Escrow.additem(fillyWear_X[1],1)
		Escrow.additem(fillyWear_X[2],1)
		Escrow.additem(fillyWear_X[3],1)
		Escrow.additem(fillyWear_T[mcm.tailsIndex],1)
		give_fillycoloredgear(mcm.costumeIndex, Escrow);
		;objectreference ref = fillyletter.getreference()
		fillyrank += 1
	endif
endfunction

function give_fillycoloredgear(int i, objectreference Escrow)
	if i == 1 ;red
		Escrow.additem(fillyWear_1[0],1)
		Escrow.additem(fillyWear_1[1],1)
		Escrow.additem(fillyWear_1[2],1)
	elseif i == 2 ;white
		Escrow.additem(fillyWear_2[0],1)
		Escrow.additem(fillyWear_2[1],1)
		Escrow.additem(fillyWear_2[2],1)
	elseif i == 3 ;blue
		Escrow.additem(fillyWear_3[0],1)
		Escrow.additem(fillyWear_3[1],1)
		Escrow.additem(fillyWear_3[2],1)
	elseif i == 4 ;pink
		Escrow.additem(fillyWear_4[0],1)
		Escrow.additem(fillyWear_4[1],1)
		Escrow.additem(fillyWear_4[2],1)
	else ;black
		Escrow.additem(fillyWear_0[0],1)
		Escrow.additem(fillyWear_0[1],1)
		Escrow.additem(fillyWear_0[2],1)
	endif
;costumeIndex
endfunction

; ---------------------------------- Utility
Function RemoveAllNonDDItems(actor me, ObjectReference chest)
  int numItems = me.GetNumItems()
  int i = 0
  While(i < numItems)
    Form item = PlayerRef.GetNthForm(i)
    If(item.HasKeyword(MCM.bd.SlutsRestraints) == false)
      PlayerRef.RemoveItem(item, PlayerRef.GetItemCount(item), true, chest)
    EndIf
    i += 1
  EndWhile
EndFunction
;/ ---------------------------------- Redundant
int property release_count auto conditional
int property advance_count auto conditional
int property gold_in_escrow auto conditional
int property customLocation = -1 auto conditional

Armor[] Property Harn  Auto

Bool Property chaining_flag  Auto  conditional
Bool Property needs_tack_flag  Auto  conditional
Bool Property needs_cart  Auto  conditional

====================================================================
; This new function will remove most devious devices that conflict with the pony outfit
Handling this inside the DD Scripts
;===================================================================
zadlibs property zlib auto
function r_conflict_device(keyword kw)
	Armor idevice
	;Armor rdevice
	actor _pc = Game.GetPlayer()
	if _pc.wornhaskeyword(kw)
		idevice = zlib.GetWornDevice(_pc, kw)
		if idevice && !idevice.HasKeyword(zlib.zad_BlockGeneric) && !idevice.HasKeyword(zlib.zad_Questitem)
			zlib.UnlockDevice(_pc, idevice)
			;/No longer need to worry about rendered device with DD5, going straight to
			removal function - Scrab
			rDevice = zlib.GetRenderedDevice(idevice)
			if rdevice && !rdevice.HasKeyword(zlib.zad_BlockGeneric) && !rdevice.HasKeyword(zlib.zad_Questitem)
				zlib.removeDevice(_pc, idevice, rDevice, kw, destroyDevice = false, skipevents = false, skipmutex = true)
			else
				zlib.notify("One of your bondage devices is too powerful to remove...")
			endif
			/;;/
		else
			zlib.notify("One of your bondage devices is too powerful to remove...")
		endif
	endif
EndFunction

;Going to move those options to the MCM when I redo it I guess
;Gotcha :) ..but why were they here in first place?
;bool property MCM_AlwaysArrears = false auto
;bool property MCM_LargeMessages = false auto
;bool property MCM_NoRemoveItems = false auto ;Used for the MCM "no item removal" option. Added because some players where experience issues with all their items being removed.

Moved to Slutsbondage
;Dont like having Data like that sitting here but this stuff has already been filled and Im too lazy to move it
armor[] property i_devs	auto

;These are used to store the player's current pony costume in case she changes her MCM settings in the middle of a run. It needs to be stored in these to make sure the removal scripts target the right pieces.
armor[] property backup_i auto

globalvariable property chain_count auto
armor[] property s_devs auto
armor[] property backup_s auto

;sluts_standard_mission property kickoff_q auto

function force_aliases(sluts_standard_mission src)
	Debug.Trace("sluts: mission data - setting aliases")
	copy_loc("start_hold",		src.start_hold_loc,	start_hold)
	copy_ref("carter",		src.carter_ref,		carter)
	copy_loc("dest_hold",		src.dest_hold_loc,	dest_hold)
	copy_loc("dest_hold_cap",	src.dest_hold_cap_loc,	dest_hold_capital)
	copy_ref("recipient",		src.recipient_ref,	recipient)
	copy_ref("manifest",		src.manifest_ref,	manifest)
	copy_ref("pc_wait",		src.pc_wait_ref,	pc_wait)
	copy_ref("cart_spawn",		src.cart_spawn_ref,	cart_spawn)
	copy_ref("escrow_chest",	src.escrow_chest_ref,	escrow_chest)
	copy_ref("humilation_chest",	src.humilation_chest_ref, humilation_chest)
	copy_ref("carter_cast",		src.carter_cast_ref,	carter_cast)
	Debug.Trace("sluts: mission data - aliases should be set")
endfunction

function copy_ref(string name, objectreference obj, referencealias dest)
	Debug.Trace("sluts_mission_data: copying reference " + name + ": value = " + obj)
	if obj == none
		Debug.Trace("sluts_mission_data: error copying reference " + name + ": source reference is none")
	endif
	if dest == none
		Debug.Trace("sluts_mission_data: error copying reference " + name + ": destination alias is none")
	endif
	if obj == none
		Debug.Trace("sluts_mission_data: clearing alias " + name)
		dest.clear()
	else
		Debug.Trace("sluts_mission_data: forcing alias "+name+" to " + obj)
		dest.forcerefto(obj)
	endif
endfunction

function copy_loc(string name, location loc, locationalias dest)
	Debug.Trace("sluts_mission_data: copying location " + name + ": value = " + loc)
	if loc == none
		Debug.Trace("sluts_mission_data: error copying location " + name + ": source location is none")
	endif
	if dest == none
		Debug.Trace("sluts_mission_data: error copying location " + name + ": destination alias is none")
	endif
	if loc == none
		Debug.Trace("sluts_mission_data: clearing desination alias")
		dest.clear()
	else
		Debug.Trace("sluts_mission_data: forcing desination alias")
		dest.forcelocationto(loc)
	endif
endfunction
/;
