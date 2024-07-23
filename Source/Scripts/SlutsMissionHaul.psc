Scriptname SlutsMissionHaul extends Quest Conditional
{Main Script for Hauling Quests}

SlutsMain Property Main Auto
SlutsMCM Property MCM Auto
SlutsData Property data Auto
SlutsBondage Property Bd Auto
SlutsEscrow Property Escrow Auto

Actor Property PlayerRef Auto
SlutsMissionHaulPlayer Property PlayerAlias Auto

ReferenceAlias Property DispatcherREF Auto
ReferenceAlias property RecipientREF Auto
ReferenceAlias Property TargetREF Auto
ReferenceAlias Property Manifest Auto
ReferenceAlias Property ScenePlayer Auto      ; Where the Player stands in Intro
ReferenceAlias Property SceneSpell Auto       ; From where the Carter casts his Spell
ReferenceAlias Property SceneRecipient Auto   ; Where the Recipient Waits
ReferenceAlias Property SceneHumilChest Auto  ; Recipient Escrow Position

LocationAlias Property RecipientLOC Auto
LocationAlias Property RecipientLOCHold Auto

Keyword Property EscrowLink Auto          ; Root to Escrow
Keyword Property PlayerWaitLoc Auto       ; Root to Player Marker
Keyword Property KartSpawnLoc Auto        ; Root to Kart Marker
Keyword Property SpellCastLoc Auto        ; Root to Spellcast Marker
Keyword Property CarriageDriver Auto      ; Root to Driver Wait Marker
; ===
ReferenceAlias Property PackageREF Auto   ; Prem Delivery Package
ReferenceAlias Property KartREF Auto      ; Used for Dialogue Conditions
Activator Property Kart_Form Auto         ; Carts Base Object

MiscObject Property FillyCoin Auto
MiscObject Property Gold001 Auto
Message Property DebitMsg Auto
Message Property AttemptUntetherMsg Auto
Message Property DetachKartSureMsg Auto
Message Property ScenePilferageMsg Auto
Message Property PackageDestroyedMsg Auto
Message Property CargoTetherFailure Auto
Message Property CartTooFarAway Auto
Message Property PremPackageDestroyed Auto
Keyword Property ActorTypeNPC Auto

Activator Property SummonFX Auto
Race Property DefaultRace Auto

Quest Property DeliverySelectorQst Auto ; Pick a random NPC from the current Hold
Scene Property moveChestScene Auto      ; Post Humiliation reward

Faction Property SlutsCrime Auto        ; Sluts Crime Faction
Faction Property DriverFaction Auto     ; All Drivers
Faction Property DirtyFaction Auto      ; For Dirt Tats
Faction Property PlayerFollowerFaction Auto
Faction Property BanditFaction Auto
Faction property ForswornFaction Auto
Faction[] Property FriendFactions Auto
GlobalVariable Property TimeScale Auto

; Worldspaces
Worldspace Property Tamriel Auto
Worldspace Property Solstheim Auto
ObjectReference Property windhelmPort Auto
ObjectReference Property ravenRockPort Auto
; Holds
Location Property EastmarchHoldLocation auto
Location Property HaafingarHoldLocation auto
Location Property ReachHoldLocation auto
Location Property RiftHoldLocation auto
Location Property WhiterunHoldLocation auto
Location Property FalkreathHoldLocation auto
Location Property PaleHoldLocation auto
Location Property HjaalmarchHoldLocation auto
Location Property WinterholdHoldLocation auto

ImageSpaceModifier Property FadeToBlackImod Auto
ImageSpaceModifier Property FadeToBlackBackImod Auto
ImageSpaceModifier Property FadeToBlackHoldImod Auto

; ---------------------------------- Variables
String Property JobCart = "CartHaul" AutoReadOnly Hidden
String Property JobDelivery = "SpecialDelivery" AutoReadOnly Hidden
float Property SkyrimDiameter = 311231.0 AutoReadOnly Hidden

; Keybinds
int ActivateKey

; Series Info
GlobalVariable Property Payment Auto            ; Base Pay of the current Haul
int Property Streak Auto Hidden Conditional     ; Number of Hauls the player did this series
float Property TotalPay Auto Hidden Conditional ; Total amount of payment in this series. May be negative for loss making serieses
float PerfectStreak                             ; Number of Perfect Hauls in a row, to calculate final overtime bonus

; Haul Info
GlobalVariable Property PilferageThresh00 Auto          ; Threshholds which divide Pilferage damage into 4 segments:
GlobalVariable Property PilferageThresh01 Auto          ; [...0] -> [1..T1] -> ... -> [(T3 + 1)...]
GlobalVariable Property PilferageThresh02 Auto          ; Thresh 3 evaluates to total cargo Health, exceeding means the cargo is lost entirely
GlobalVariable Property PilferageThresh03 Auto
GlobalVariable Property PilferageReinforcement Auto     ; State of the Seal (Bonus Hp) (May be increased through license buffs)
float Property Reinforcement Auto Hidden Conditional 
float Property Pilferage Auto Hidden Conditional        ; Amount of damage to goods/seal (Damaged Hp)
float PilferageMax

GlobalVariable Property ExpectedDelay Auto Hidden
int Property DelayCounter Auto Hidden Conditional

GlobalVariable Property MissionType Auto                ; Currently active Mission Type
GlobalVariable Property MissionTypeCart Auto
GlobalVariable Property MissionTypePremium Auto
int Property MissionComplete Auto Hidden Conditional    ; If the player is currently transporting a package (and what type of package it is)
int Property JobStage Auto Hidden                       ; The current Job Stage, for objective management
int Property JOBSTAGE_BASE = 21 AutoReadOnly Hidden

; Humiliation System
bool Property HumiliatedOnce = false Auto Hidden Conditional    ; Set after 1st Humiliation. Dialogue flag for future missions
bool Property Humiliated = false Auto Hidden Conditional        ; If humiliation is done for this haul
int Property HumilPick Auto Hidden Conditional
; 0 - Nothing, free to go
; 1 - DD Boots
; 2 - Hobbledress
; 3 - Piercings
; 4 - Give up part of your payment
; 5 - Unused
; 6 - Unused
; 7 - Unused
; 8 - Fallback - Sell yourself to the Driver

; Tether System
bool Property bIsThethered Auto Hidden Conditional
SlutsKart Property Kart Auto Hidden

int Property Response_Flawless      = 0 AutoReadOnly Hidden   ; 0 Pilferage + No Debt
int Property Response_Deduction     = 1 AutoReadOnly Hidden   ; X Pilferage + No Debt
int Property Response_Endebted      = 2 AutoReadOnly Hidden   ; No Pay + Init Debt
int Property Response_ReduceDebt1   = 3 AutoReadOnly Hidden   ; 0 Pilferage + Debt
int Property Response_ReduceDebt2   = 4 AutoReadOnly Hidden   ; X Pilferage + Debt
int Property Response_DebtStacking  = 5 AutoReadOnly Hidden   ; No Pay + Stacking Debt
int Property Response_DebtDone      = 6 AutoReadOnly Hidden   ; Debt fully payed off
int Property EvalResponse Auto Hidden Conditional

; misc
int Property INT_MAX = 2147483647 AutoReadOnly Hidden
bool OnHitLock = false
bool forced   ; Unused, idk what I should use this for tbh

; ======================================================
; =============================== NEW HAUL
; ======================================================

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akDispatcher, ObjectReference akRecipient, int aiCustomLoc, int aiForced)
  Debug.Trace("[SLUTS] Started new Haul")
  Escrow.lockEscrow()
  SetMissionState()
  forced = aiForced
  If (!SetLinks(akDispatcher, akRecipient))
    Stop()
    return
  ElseIf(!RecipientLocHOLD.GetLocation())
    RecipientLOCHold.ForceLocationTo(GetHold(RecipientLOC))
  EndIf
  PilferageMax = PilferageThresh03.Value * 1.1
  MissionComplete = 1
  OnHitLock = false

  float p = 1 - (aiCustomLoc * 0.15) ; 15% Payment Deduction for Custom Loc Hauls
  Payment.SetValue(GetBasePay(akDispatcher, akRecipient, p))
  UpdateCurrentInstanceGlobal(Payment)
  Debug.Trace("[SLUTS] Payment = " + Payment.GetValueInt())

  ActivateKey = Input.GetMappedKey("Activate")
  RegisterEvents()

  Debug.Trace("[SLUTS] Haul Preparations done, SetStage 5")
  SetStage(5)
EndEvent
bool Function SetLinks(ObjectReference akDispatcher, ObjectReference akRecipient)
  ObjectReference root0 = StorageUtil.GetFormValue(akDispatcher, "SLUTS_ROOT") as ObjectReference
  ObjectReference root1 = StorageUtil.GetFormValue(akRecipient, "SLUTS_ROOT") as ObjectReference
  If(!root0 || !root1)
    Debug.TraceStack("[SLUTS] Missing Root | " + root0 + " | " + root1, 2)
    Debug.MessageBox("Unable to create Haul. Root Object is missing.")
    return false
  EndIf
  ScenePlayer.ForceRefTo(root0.GetLinkedRef(PlayerWaitLoc))
  SceneSpell.ForceRefTo(root0.GetLinkedRef(SpellCastLoc))
  SceneRecipient.ForceRefTo(root1.GetLinkedRef(CarriageDriver))
  SceneHumilChest.ForceRefTo(root1.GetLinkedRef(EscrowLink))
  return true
EndFunction

Function SetMissionState(int missionID = -1)
  String[] missions = new String[2]
  missions[MissionTypeCart.GetValueInt()] = JobCart
  missions[MissionTypePremium.GetValueInt()] = JobDelivery
  If (missionID < 0 || missionID >= missions.Length)
    missionID = SlutsData.Distribute(MCM.HaulWeights) - 1
  EndIf
  If(missions[missionID] != GetState())
    GoToState(missions[missionID])
    MissionType.SetValueInt(missionID)
  EndIf
EndFunction

Function RegisterEvents()
  RegisterForKey(ActivateKey)
  RegisterForModEvent("HookAnimationStart", "OnAnimStart")
	RegisterForModEvent("HookAnimationEnd", "OnAnimEnd")
endFunction

Function Blackout()
  FadeToBlackImod.Apply()
  Utility.Wait(2)
  FadeToBlackImod.PopTo(FadeToBlackHoldImod)
EndFunction

Function StripPlayer()
  Form[] inventory = PlayerRef.GetContainerForms()
  int i = 0
  While(i < inventory.Length)
    Form it = inventory[i]
    If (it.IsPlayable())
      bool nostrip = PlayerRef.IsEquipped(it) && SexLabUtil.HasKeywordSub(it, "NoStrip")
      If (!nostrip && !SexLabUtil.HasKeywordSub(it, "Licence"))
        PlayerRef.RemoveItem(it, INT_MAX, true, Escrow)
      EndIf
    EndIf
    i += 1
  EndWhile
  PlayerRef.QueueNiNodeUpdate()
EndFunction

Function SetupHaul()  ; Called during first setup only
  HumilPick = Utility.RandomInt(0, 8)
  DispatcherREF.GetReference().MoveTo(SceneSpell.GetReference())
  PlayerRef.MoveTo(ScenePlayer.GetReference())
  PlayerRef.PlaceAtMe(SummonFX)
  StripPlayer()
  SetupHaulImpl()
  SendModEvent("SLUTS_SetupPilferage")

  PerfectStreak = 0
  Streak = 0
  TotalPay = 0.0
EndFunction
Function SetupHaulImpl()  ; Called every time BEFORE a new job starts
  Debug.TraceStack("[SLUTS] Function call 'SetupHaulImpl' outside a valid State = " + GetState(), 2)
EndFunction

; ======================================================
; =============================== ON HAUL
; ======================================================

Function Maintenance()
  Debug.Trace("[SLuts] Mission Haul Reload Maintenance")
  If (IsActiveCartMission())
    OnLoadTether()
  EndIf
  RegisterEvents()
EndFunction

bool Function ShouldProcessOnHit()
  return MCM.iPilferageLevel > MCM.DIFFICULTY_EASY && IsActiveMissionAny() && (bIsThethered || !IsActiveCartMission())
EndIf

State CartHaul
  Function SetupHaulImpl()
    Debug.Trace("[SLUTS] Setting up CartHaul")
    TargetREF.ForceRefTo(RecipientREF.GetReference())
    If(!Kart)
      Kart = SlutsMain.GetLink(DispatcherREF.GetReference(), KartSpawnLoc).PlaceAtMe(Kart_Form) as SlutsKart
      KartRef.ForceRefTo(Kart)
      Utility.Wait(0.5)
    Else ; Chain Haul, make sure the Kart can actually be moved
      Kart.SetMotionType(Kart.Motion_Dynamic)
      If(Kart.GetDistance(PlayerRef) > 750)
        bIsThethered = false
      EndIf
    EndIf
    Tether()
    Kart.SetUp()
    Bd.DressUpPony(PlayerRef)
    CreateTimer()
  EndFunction

  Event OnEndState()
    If(Kart)
      Untether()
      Kart.ShutDown()
      KartRef.Clear()
      Kart.Disable()
      Kart.Delete()
      Kart = none
    EndIf
  EndEvent
EndState

State SpecialDelivery
  Function SetupHaulImpl()
    Debug.Trace("[SLUTS] Setting up SpecialDelivery")
    If(Main.myDrivers.Find(RecipientREF.GetActorReference()) == 9)
      RecipientREF.ForceRefTo(Main.myDrivers[4])
    EndIf
    If(!DeliverySelectorQst.Start())
      Debug.Trace("[SLUTS] Failed to find Target. Fallback to " + JobCart)
      SetMissionState(MissionTypeCart.GetValueInt())
      return
    EndIf
    ReferenceAlias target = DeliverySelectorQst.GetAliasById(3) as ReferenceAlias
    ObjectReference tref = target.GetReference()
    Debug.Trace("[SLUTS] Found Target = " + tref)
    TargetREF.ForceRefTo(tref)
    RecipientLOC.ForceLocationTo(tref.GetCurrentLocation())
    ; TODO: Look for artist for some kinda bag equipping
    Bd.DressUpPony(PlayerRef, false)
    PlayerRef.AddItem(PackageREF.GetReference())
    DeliverySelectorQst.Stop()
    CreateTimer()
  EndFunction
  ; Wrapper to remove package before doing payment (or leave it in inventory if not received)
  Function TakePackage()
    If(PlayerRef.GetItemCount(PackageREF.GetReference()) > 0)
      PlayerRef.RemoveItem(PackageREF.GetReference())
    EndIf
    DoPayment()
  EndFunction

  Event OnEndState()
    ; TODO: Once bag implemented, remove it here again
  EndEvent
EndState
Function TakePackage()
  Debug.TraceStack("[SLUTS] Function call 'TakePackage' outside a valid State = " + GetState(), 2)
EndFunction

Function CreateTimer()
  DelayCounter = 0
  ; https://en.uesp.net/wiki/Skyrim:Transport
  float d = DispatcherREF.GetReference().GetDistance(RecipientREF.GetReference()) 
  float interval_seconds = (d / 370.0) + 0.5
  RegisterForUpdate(interval_seconds)
  float expected_delivery_time = interval_seconds * 2
  float edt_game = expected_delivery_time * TimeScale.Value
  float edt_gamedays = Math.Ceiling(edt_game / (60 * 60 * 24)) + 1
  RegisterForUpdateGameTime(edt_gamedays)
EndFunction
Event OnUpdate()
  DelayCounter += 1
  If (!IsActiveMissionAny())
    UnregisterForUpdate()
  EndIf
EndEvent
Event OnUpdateGameTime()
  If (!IsActiveMissionAny())
    return
  EndIf
  ; IDEA: mark haul as failed and disable the quest. Some custom dialogue for sluts
  ; workers to get the player out of gear when they wear job equipment while this quest is not running
EndEvent

bool Function IsActiveMissionAny()
  return MissionComplete < 1
EndFunction
int Function GetActiveMissionID()
  If (!IsActiveMissionAny())
    return -1
  EndIf
  return Math.Abs(MissionComplete) as int
EndFunction
bool Function IsActiveMission(int aiMissionID)
  return MissionComplete == (0 - aiMissionID)
EndFunction
bool Function IsActiveCartMission()
  return IsActiveMission(MissionTypeCart.GetValueInt())
EndFunction

; ======================================================
; =============================== PILFERAGE & EVALUATION
; ======================================================

Function UpdatePilferage(float afValue)
  int mission_id = GetActiveMissionID()
  Debug.Trace("[Sluts] Update pilferage; Mission id: " + mission_id + " // MissionComplete: " + MissionComplete)
  If (afValue < 0)
    Reinforcement = Math.abs(afValue)
    afValue = 0
  EndIf
  If (mission_id > -1)
    If (Reinforcement > 0 && afValue > Pilferage)
      float damage = afValue - Pilferage
      Reinforcement -= damage
      If (Reinforcement < 0)
        Reinforcement = 0
      EndIf
      float pctArmor = Reinforcement / PilferageReinforcement.GetValue()
      SendModEvent("SLUTS_InvokeFloat", ".setArmor", pctArmor)
      return
    EndIf
    Debug.TraceConditional("[SLUTS] Ivalid Argument in UpdatePilferage, afValue: " + afValue, afValue < 0)
    float t3 = PilferageThresh03.GetValue()
    If (afValue > t3) ; Cargo destroyed
      afValue = t3
      If (mission_id == MissionTypeCart.Value)
        Untether()
      ElseIf (mission_id == MissionTypePremium.Value)
        ObjectReference ref = PackageREF.GetReference()
        If (PlayerRef.GetItemCount(ref) > 0)
          PlayerRef.RemoveItem(PackageREF.GetReference())
          PremPackageDestroyed.Show()
        EndIf
      EndIf
    EndIf
    float pct = afValue / t3
    SendModEvent("SLUTS_InvokeFloat", ".setPct", 1 - pct)
  EndIf
  Pilferage = afValue
EndFunction

Function HandleStage()
  MissionComplete = 0 - MissionType.GetValueInt()
  int stage = JOBSTAGE_BASE + MissionType.GetValueInt()
  If(stage != JobStage) ; Switching haul type, hide the previous objective(s)
    SetObjectiveDisplayed(stage, false)
    SetObjectiveDisplayed(100, false) ; Prem Delivery secondary objective
  EndIf
  JobStage = stage
  If (IsObjectiveCompleted(JobStage))
    SetObjectiveCompleted(JobStage, false)
    SetObjectiveCompleted(100, false)
  EndIf
  If (IsObjectiveFailed(JobStage))
    SetObjectiveFailed(JobStage, false)
    SetObjectiveFailed(100, false)
  EndIf
  SetObjectiveDisplayed(JobStage, true, true)
EndFunction

Function CompleteJobStages()
  SetObjectiveCompleted(JobStage)
  If(JobStage == JOBSTAGE_BASE + MissionTypePremium.Value)
    SetObjectiveCompleted(100)
  EndIf
EndFunction

Function FailJobStages()
  SetObjectiveFailed(JobStage)
  If(JobStage == JOBSTAGE_BASE + MissionTypePremium.Value)
    SetObjectiveFailed(100)
  EndIf
EndFunction

Function Fail()
  MissionComplete = 1
  Pilferage = PilferageMax
  DoPayment()
EndFunction

Function CreateBlackmail(Actor akBlackmailer)
  akBlackmailer.SendModEvent("S.L.U.T.S. Blackmail")
EndFunction

Function GambleBlackmailFailure(Actor akBlackmailer, int aiAddChance = 0)
  int betrayalchance = 75
  int rel = akBlackmailer.GetRelationshipRank(PlayerRef) + aiAddChance
  If(rel >= 0)
    betrayalchance = 50 - (rel * 14)
  EndIf
  If(Utility.RandomInt(0, 99) < betrayalchance)
    Fail()
  Else
    TakePackage()
  EndIf
EndFunction

Function CreateChainMission(bool abForced, int aiMissionID = -1, Actor akDispatch = none)
  If (!akDispatch)
    akDispatch = RecipientREF.GetReference() as Actor
  EndIf
  Actor next = Main.GetDestination(akDispatch, DispatcherREF.GetActorReference())
  Debug.Trace("[SLUTS] Attempting Chain Mission with new Dispatcher = " + akDispatch + " | Recipient = " + next)
  If (!SetLinks(akDispatch, next))
    Quit()
    return
  EndIf
  Escrow.LockEscrow()
  forced = abForced
  DispatcherREF.ForceRefTo(akDispatch)
  RecipientREF.ForceRefTo(next)
  RecipientLOC.ForceLocationTo(Main.myDestLocs[Main.myDrivers.Find(next)])
  RecipientLOCHold.ForceLocationTo(GetHold(RecipientLOC))
  SetMissionState(aiMissionID)
  SetupHaulImpl()
  Payment.SetValue(GetBasePay(akDispatch, next, 1.0))
  UpdateCurrentInstanceGlobal(Payment)
  Debug.Trace("[SLUTS] ChainMission; Payment: " + Payment.GetValueInt())
  Manifest.GetReference().Activate(PlayerRef)
  Utility.Wait(0.1)
  FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
  Game.SetPlayerAIDriven(false) ; Unsure why this is needed, zz
  SetStage(20)
EndFunction

; Assume there to be a Blackout right here
Function Quit()
  data.SeriesCompleted()
  PlayerRef.RemoveItem(Manifest.GetReference(), abSilent = true)
  ; Clear State & get Player out of gear
  PlayerRef.PlaceAtMe(SummonFX)
  GoToState("")
  Bd.UndressPony(PlayerRef, false)
  Game.EnableFastTravel()
  FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
  ; Enable post haul Dialogue & place Escrow
  If (TotalPay > 0)
    int coins = Math.Floor(TotalPay * GetOvertimeBonus())
    Escrow.AddItem(FillyCoin, coins)
  EndIf
  ObjectReference spawn
  If (data.licenseEscrowPort > 0)
    spawn = SlutsMain.GetLink(RecipientREF.GetReference(), EscrowLink)
    data.licenseEscrowPort -= 1
  Else
    spawn = SlutsMain.GetLink(DispatcherREF.GetReference(), EscrowLink)
  EndIf
  Escrow.MoveTo(spawn)
  Escrow.Lock(false)
EndFunction


; ======================================================
; =============================== PAYMENT
; ======================================================

float Function GetBasePay(ObjectReference akDisp, ObjectReference akRecip, float mult = 1.0)
  Worldspace ref2Space = akRecip.GetWorldSpace()
  float distance
  int base = 0
  If(akDisp.GetWorldSpace() == ref2Space)
    distance = akDisp.GetDistance(akRecip)
  Else ; Not same Worldspace, give a 40k Basepay and check Distance from a Port
    If(ref2Space == Tamriel)
      distance = windhelmPort.GetDistance(akRecip)
    ElseIf(ref2Space == Solstheim)
      distance = ravenRockPort.GetDistance(akRecip)
    Else ; If in a modded Worldspace dont bother about calculus, just return some random number
      return Utility.RandomInt(27500, 45000)
    EndIf
  EndIf
  ; Explanation: https://www.loverslab.com/topic/146751-sluts-resume/page/14/#comment-3357294
  ; V3: Reduced coin gain by factor 2,5 | V3.3: simplified function
  float ret = Math.sqrt(distance * SkyrimDiameter * MCM.fPaymentArg) / 25
  return ret * mult
EndFunction

float Function GetOvertimeBonus()
  If(SlutsCrime.GetCrimeGold() > 0 || PerfectStreak <= 1)
    return 0
  Endif
  ; Explanation: https://www.loverslab.com/topic/146751-sluts-resume/page/15/#comment-3360719
  ; V3.3: Halfed Overtime Bonus
  float ret
  If(PerfectStreak < 15)
    ret = MCM.fOvertimeArg * Math.pow(1.4, (0.3 * PerfectStreak)) - MCM.fOvertimeArg
  else
    ret = MCM.fOvertimeArg * 5
  EndIf
  ret /= 2
  Debug.Trace("[SLUTS] GetOvertimeBonus(): PerfectStreak = " + PerfectStreak + " | Overtime Bonus: " + (ret * 100) + "%")
  return ret
EndFunction

Function DoPayment()
  SendModEvent("SLUTS_InvokeFloat", ".hide", 0.0)
  Streak += 1
  If (MCM.iPilferageLevel > MCM.DIFFICULTY_NORM && DelayCounter > ExpectedDelay.GetValueInt())
    float penalty = DelayCounter - ExpectedDelay.Value
    Pilferage += PilferageThresh03.Value / (0.25 * penalty)
    If (Pilferage > PilferageMax)
      Pilferage = PilferageMax
    EndIf
  EndIf
  bool perfectrun = Pilferage <= PilferageThresh00.GetValue()
  data.RunCompleted(perfectrun)
  ; Finalize Payment, payout to Escrow Chest, get response type
  int crime = SlutsCrime.GetCrimeGold()
  int pay = Payment.GetValueInt()
  If(perfectrun)
    PerfectStreak += 1
    If(crime == 0)
      EvalResponse = Response_Flawless
    ElseIf(crime <= pay)
      EvalResponse = Response_DebtDone
    Else
      EvalResponse = Response_ReduceDebt1
    EndIf
  Else
    PerfectStreak = 0
    float difficulty = MCM.iPilferageLevel as float
    float mult
    If (Pilferage <= PilferageThresh01.GetValue())
      mult = PaymentSeg1()
    ElseIf (Pilferage <= PilferageThresh02.GetValue())
      mult = PaymentSeg2(Pilferage)
    Else
      mult = PaymentSeg3(Pilferage)
    EndIf
    Debug.Trace("[SLUTS] Pilferage: " + Pilferage + " | Reducing payment by a ratio of " + mult)
    pay -= Math.Floor(mult * pay)
    If (crime == 0)
      If (mult < 1)
        EvalResponse = Response_Deduction
      Else
        EvalResponse = Response_Endebted
      EndIf
    Else
      If(crime <= pay)
        EvalResponse = Response_DebtDone
      ElseIf(mult < 1)
        EvalResponse = Response_ReduceDebt2
      Else
        EvalResponse = Response_DebtStacking
      EndIf
    EndIf
  EndIf
  If(pay > 0) ; Made profit
    If(crime > pay)
      SlutsCrime.ModCrimeGold(-pay)
      pay = 0
    ElseIf(crime > 0)
      SlutsCrime.SetCrimeGold(0)
      pay -= crime
    EndIf
    Escrow.AddItem(FillyCoin, pay, true)
  ElseIf(pay < 0) ; Made losses
    SlutsCrime.ModCrimeGold(-pay)
  EndIf
  TotalPay += pay
  Debug.Trace("[SLUTS] DoPayment(): Response = " + EvalResponse + " | Payment = " + pay + " | Debt = " + SlutsCrime.GetCrimeGold() + " | TotalPay = " + TotalPay)
EndFunction

float Function PaymentSeg1()
  return PaymentSeg2(PilferageThresh01.GetValue())
EndFunction
float Function PaymentSeg2(float x)
  float t2 = PilferageThresh02.GetValue()
  return ((x - t2) / t2) + 1
EndFunction
float Function PaymentSeg3(float x)
  return Math.pow(1.003, x - PilferageThresh02.GetValue())
EndFunction

; ======================================================
; =============================== HAUL START0
; ======================================================

Function TransferManifest()
  ObjectReference Paper = Manifest.GetReference()
  DispatcherRef.GetReference().RemoveItem(Paper, 1, true, PlayerRef)
EndFunction

Function ShowManifest(bool abEquipGag)
  Manifest.GetReference().Activate(PlayerRef)
  If(abEquipGag)
    Bd.EquipIdx(Bd.gagIDX)
  EndIf
endFunction

; ======================================================
; =============================== PAYMENT
; ======================================================

Function spontaneousFailure()
  If (Pilferage > 0 || Utility.RandomInt(0, 99) > MCM.iSpontFail)
    return
  EndIf
  If (MCM.bSpontFailRandom)
    Pilferage = Utility.RandomFloat(PilferageThresh01.GetValue(), PilferageMax)
  Else
    Pilferage = PilferageMax
  EndIf
  String X
  if Pilferage <= PilferageThresh02.GetValue()
    X = "some of your cargo appears to be missing"
  elseif Pilferage <= PilferageThresh03.GetValue()
    X = "much of your cargo is missing"
  else
    X = "your cargo is completely gone"
  endif
  Debug.Messagebox("In a moment of absent mindedness you glance behind you, only to notice to your horror that " + X + "! You have no idea what happened and can only shudder in a cold sweat knowing you will still have to answer for it...")
EndFunction


; ======================================================
; =============================== KEYCODES
; ======================================================

Event OnKeyDown(int KeyCode)
  If(Utility.IsInMenuMode())
		return
  EndIf
  bool Ctrl = Input.IsKeyPressed(29) || Input.IsKeyPressed(157)
  If (!Ctrl || !Kart || PlayerRef.IsInInterior())
    return
  EndIf
  If(KeyCode == ActivateKey)
    If(!bIsThethered)
      If (Kart.GetDistance(PlayerRef) >= 1000)
        CartTooFarAway.Show()
        return
      EndIf
      Tether()
      Bd.RemoveIdx(Bd.yokeIDX, true)
      Bd.EquipIdx(Bd.yokeIDX, true)
    Else
      If(DetachKartSureMsg.Show() == 0)
        Unhitch()
      EndIf
    EndIf
  EndIf
EndEvent

; ======================================================
; =============================== TETHER
; ======================================================

Function Tether()
  If(!Kart || bIsThethered)
    return
  ElseIf (Pilferage > PilferageThresh03.GetValue())
    CargoTetherFailure.Show() ; Kart is damaged and cannot retether
    return
  EndIf
  bIsThethered = true
  Debug.Trace("[SLUTS] Attempting to tether..")
  If(Kart.GetDistance(PlayerRef) > 500)
    Kart.SetMotionType(Kart.Motion_Keyframed)
    Game.DisablePlayerControls()
    Debug.SetGodMode(true)  ; To avoid the cart physics killing the player
    ObjectReference tmp = PlayerRef.PlaceAtMe(FillyCoin, aiCount = 1, abInitiallyDisabled = true)
    tmp.MoveTo(PlayerRef, -258.0 * Math.Sin(PlayerRef.GetAngleZ()), -258.0 * Math.Cos(PlayerRef.GetAngleZ()))
    Utility.Wait(0.3)
    Kart.MoveTo(tmp)
    Utility.Wait(0.2)
    Kart.SetMotionType(Kart.Motion_Dynamic)
    Debug.SetGodMode(false)
    Game.EnablePlayerControls()
  EndIf
  Race r = PlayerRef.GetRace()
  PlayerRef.SetRace(DefaultRace)
  PlayerRef.SetRace(r)
  Utility.Wait(0.5)
  Kart.TetherToHorse(PlayerRef)
  Game.EnableFastTravel(false)
EndFunction

Function OnLoadTether()
  If(!bIsThethered || !Kart || PlayerRef.IsInInterior())
    return
  EndIf
  ; Tether will always come loose when reloading
  bIsThethered = false
  Tether()
EndFunction

Function Untether()
  If(!bIsThethered)
    return
  ElseIf(Kart.Is3DLoaded())
    Kart.Disable()
    Utility.Wait(0.1)
    Kart.Enable()
  EndIf
  Debug.Trace("[SLUTS] Untethered Kart")
  bIsThethered = false
  Game.EnableFastTravel(true)
endFunction

Function Unhitch()
  If(!bIsThethered)
    return
  EndIf
  AttemptUntetherMsg.Show()
  If(MCM.bStruggle)
    Bd.Lib0.abq.StruggleScene(PlayerRef)
  EndIf
  Untether()
endFunction

; ======================================================
; =============================== SEXLAB
; ======================================================

Event OnAnimStart(int tid, bool HasPlayer)
  If(!HasPlayer || !IsActiveCartMission())
    return
  EndIf
  Untether()
EndEvent

Event OnAnimEnd(int tid, bool HasPlayer)
  If (!HasPlayer)
    return
  EndIf
  Actor[] positions = SlutsAnimation.GetSceneActors(tid)
  String[] hooks = SlutsAnimation.GetSceneHooks(tid)
  If (hooks.Find("SLUTS_NoPenalty") > -1)
    Debug.Trace("[SLUTS] Scene End on NoPenalty Scene")
    return
  ElseIf (hooks.Find("SLUTS_Humil") > -1)
    Debug.Trace("[SLUTS] Humiliation Scene End")
    Utility.Wait(0.2)
    moveChestScene.Start()
    return
  ElseIf (hooks.Find("SLUTS_BlackMailSex") > -1)
    Debug.Trace("[SLUTS] Blackmail Scene End")
    Actor[] copy = PapyrusUtil.RemoveActor(positions, PlayerRef)
    GambleBlackmailFailure(copy[0])
    SetStage(100)
    return
  ElseIf (MCM.iPilferageLevel == MCM.DIFFICULTY_EASY || !IsActiveMissionAny())
    Debug.Trace("[SLUTS] Scene End but Pilferage is disabled or not on active haul")
    return
  EndIf
  float arg = 0.0
  int i = 0
  While(i < positions.Length)
    Actor p = positions[i]
    If(p == PlayerRef || p.IsPlayerTeammate() || p.IsInFaction(DriverFaction))
      ; Continue
    Else
      float m = p.GetActorValue("Morality")
      If(p.IsInFaction(BanditFaction) || p.IsInFaction(ForswornFaction))
        m -= 1.0
      EndIf
      arg + m
    EndIf
    i += 1
  EndWhile
  arg /= positions.Length as float
  float mult = -0.03 * (arg - MCM.iPilferageLevel) + 0.05
  float penalty = PilferageThresh03.GetValue() * mult
  Debug.Trace("[SLUTS] OnAnimEnd() Radiant: Pilferage: " + Pilferage + " | Arg = " + mult + " | Penalty = " + penalty)
  UpdatePilferage(Pilferage + penalty)
  ScenePilferageMsg.Show(Pilferage, PilferageThresh03.GetValue())
endEvent

; ======================================================
; =============================== HUMILIATION
; ======================================================

; HumilPick = 4
Function debitRate()
  If(Payment.Value <= 0)
    Debug.Trace("[SLUTS] debitRate(): Unable to deduct rate, no payment in previous run? " + Payment.Value)
    return
  EndIf
  float pct = Utility.RandomFloat(0.05, 0.35)
  int debit = Math.Floor(Payment.Value * pct)
  Escrow.RemoveItem(FillyCoin, debit)
  TotalPay -= debit
  DebitMsg.Show(pct * 100)
  Debug.Trace("[SLUTS] debitRate(): Debit Rate = " + pct)
EndFunction

function fondle(Message msg=none, float increment=5.0)
; 	if msg == none
; 		msg = msg_stroke_flank
; 	endif
; 	msg.show()
; 	int eid = ModEvent.Create("slaUpdateExposure")
; 	ModEvent.PushForm(eid, PlayerREf)
; 	ModEvent.PushFloat(eid, increment)
; 	ModEvent.Send(eid)
endfunction

Function HumilChest()
  HumiliatedOnce = true
  Escrow.MoveTo(SceneHumilChest.GetReference())
endFunction

; ======================================================
; =============================== UTILITY
; ======================================================

; Function Dirtify()
;   If(!MCM.bUseDirt)
;     return
;   EndIf
;   int L = PapyrusUtil.ClampInt(PlayerRef.GetFactionRank(DirtyFaction) + 1, 1, 10)
; 	;slavetats.simple_add_tattoo(pc, "Dirty S.L.U.T.S.", "Dirty Head " + level, last = false, silent = true )
; 	;slavetats.simple_add_tattoo(pc, "Dirty S.L.U.T.S.", "Dirt " + level, last = true, silent = true )
; 	PlayerRef.SetFactionRank(DirtyFaction, L)
; 	mcm.TatLib.set_dirty_level(PlayerRef, L)
; endfunction

Function Befriend()
  int i = 0
  While(i < FriendFactions.length)
    PlayerRef.AddToFaction(FriendFactions[i])
    i += 1
  EndWhile
EndFunction

Function Unfriend()
  int i = 0
  While(i < FriendFactions.length)
    PlayerRef.RemoveFromFaction(FriendFactions[i])
    i += 1
  EndWhile
EndFunction

Location Function GetHold(LocationAlias myDest)
  Location myLoc = myDest.GetLocation()
  If(!myLoc)
    Debug.Trace("[SLUTS] DefaultHaul: Null Location passed, abandon \"GetHold\"")
    return none
  EndIf
  Debug.Trace("[SLUTS] DefaultHaul: Getting Hold for: " + myLoc.GetName())
  If(EastmarchHoldLocation.IsChild(myLoc))
    Debug.Trace("[SLUTS] Hold identified: Windhelm")
    return EastmarchHoldLocation
  ElseIf(HaafingarHoldLocation.IsChild(myLoc))
		Debug.Trace("[SLUTS] Hold identified: Solitude")
		return HaafingarHoldLocation
  ElseIf(ReachHoldLocation.IsChild(myLoc))
		Debug.Trace("[SLUTS] Hold identified: Markarth")
		return ReachHoldLocation
  ElseIf(RiftHoldLocation.IsChild(myLoc))
		Debug.Trace("[SLUTS] Hold identified: Riften")
		return RiftHoldLocation
  ElseIf(WhiterunHoldLocation.IsChild(myLoc))
		Debug.Trace("[SLUTS] Hold identified: Whiterun")
		return WhiterunHoldLocation
  ElseIf(FalkreathHoldLocation.IsChild(myLoc))
		Debug.Trace("[SLUTS] Hold identified: Falkreath")
		return FalkreathHoldLocation
  ElseIf(PaleHoldLocation.IsChild(myLoc))
		Debug.Trace("[SLUTS] Hold identified: Dawnstar")
		return PaleHoldLocation
  ElseIf(HjaalmarchHoldLocation.IsChild(myLoc))
		Debug.Trace("[SLUTS] Hold identified: Morthal")
		return HjaalmarchHoldLocation
  ElseIf(WinterholdHoldLocation.IsChild(myLoc))
		Debug.Trace("[SLUTS] Hold identified: Winterhold")
		return WinterholdHoldLocation
  endIf
	return none
endfunction

