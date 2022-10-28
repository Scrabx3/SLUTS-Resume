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
ReferenceAlias Property StatisticsPlace Auto
ReferenceAlias Property StatisticsBook Auto
Book Property StatisticsBook_Form Auto
; ---------------------------------- Progression Data
GlobalVariable Property SeriesCompleted Auto
{Times the Player completed a Series (opened Escrow Chest)}
GlobalVariable Property HaulsCompleted Auto
{Amout of single Hauls the Player completed}
GlobalVariable Property HaulsPerfect Auto
{Amount of perfect Hauls the Player completed total}

; NOTE: BELOW GLOBALS ARE UNUSED AS OF YET
; GlobalVariable Property HaulsCompletedStreak Auto
; {Highest amount of Hauls completed in a single Streak, forced and voluntary}
; GlobalVariable Property HaulsPerfectStreak Auto
; {Highest amount of perfect Hauls in a row}
; GlobalVariable Property HaulsPerfectStreakAllTime Auto
; {Amount of perfect Hauls in a row across multiple Runs}
; GlobalVariable Property voluntaryHaulsCompleted Auto
; {Amount of voluntary Hauls the Player has completed}
; GlobalVariable Property voluntaryHaulsCompletedStreak Auto
; {Highest amount of voluntary Hauls the Plyer has completed in a row}
; GlobalVariable Property ForcedHaulsCompleted Auto
; {Amountfs of forced Hauls the Player completed}
; GlobalVariable Property ForcedHaulsCompletedStreak Auto
; {Highest amount of forced Hauls the Player has completed in a row}
; GlobalVariable Property CargoLost Auto
; {The amount of times the Player failed to get the Cargo to the Recipient}

; int Property streak = 0 Auto Hidden Conditional
; {The current Haul-Streak, positive = voluntary - negative = forced}
; int Property streakTotal = 0 Auto Hidden Conditional
; {The current Haul Streak, forced and voluntary combined}
; int Property streakPerfect = 0 Auto Hidden Conditional
; {The current perfect haul streak. Missionhaul stacks this for every haul it considers "perfect"}

Function UpdateGlobals()
  UpdateCurrentInstanceGlobal(SeriesCompleted)
  UpdateCurrentInstanceGlobal(HaulsCompleted)
  UpdateCurrentInstanceGlobal(HaulsPerfect)
EndFunction

Function NewBook()
  StatisticsBook.ForceRefTo(StatisticsPlace.GetReference().PlaceAtMe(StatisticsBook_Form))
EndFunction

Function RunCompleted(bool abPerfect)
  HaulsCompleted.Value += 1
  If(abPerfect)
    HaulsPerfect.Value += 1
  EndIf
EndFunction

Function SeriesCompleted()
  SeriesCompleted.Value += 1
EndFunction

; ======================================================
; =============================== UTILITY
; ======================================================
int Function GetCoinRatio() global
  return 50
EndFunction

int Function GetCoinFromGold(int aiGoldValue) global
  return aiGoldValue * GetCoinRatio()
EndFunction

int Function GetGoldFromCoin(int aiCoinValue) global
  return aiCoinValue / GetCoinRatio()
EndFunction

int Function Distribute(int[] weights) global
  int all = 0
  int i = 0
  While(i < weights.length)
    all += weights[i]
    i += 1
  EndWhile
  int this = Utility.RandomInt(1, all)
  int limit = 0
  int n = 0
  While(limit < this)
    limit += weights[n]
    n += 1
  EndWhile
  return n
EndFunction
