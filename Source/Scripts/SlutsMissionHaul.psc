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

GlobalVariable Property MissionType Auto  ; Currently active Mission Type
GlobalVariable Property Payment Auto      ; Base Pay of the current Haul
MiscObject Property FillyCoin Auto
MiscObject Property Gold001 Auto
Message Property DebitMsg Auto
Message Property AttemptUntetherMsg Auto
Message Property DetachKartSureMsg Auto
Message Property ScenePilferageMsg Auto
Message Property PackageDestroyedMsg Auto
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
int Property Streak Auto Hidden Conditional     ; Number of Hauls the player did this series
float Property TotalPay Auto Hidden Conditional ; Total amount of payment in this series. May be negative for loss making serieses
float PerfectStreak                             ; Number of Perfect Hauls in a row, to calculate final overtime bonus
float OvertimePay                               ; Accumulated payments over a series of perfect hauls. Will reset on non perfect haul

; Haul Info
GlobalVariable Property PilferageThresh00 Auto          ; Threshholds which divide Pilferage damage into 4 segments:
GlobalVariable Property PilferageThresh01 Auto          ; [...0] -> [1..T1] -> ... -> [(T3 + 1)...]
GlobalVariable Property PilferageThresh02 Auto
GlobalVariable Property PilferageThresh03 Auto
GlobalVariable Property PilferageReinforcement Auto     ; State of the Seal (Bonus Hp) (May be increased through license buffs)
float Property GoodsTotal = 1000.0 AutoReadOnly Hidden  ; Amount of goods total (Base Hp)
float Property KartHealth = 100.0 AutoReadOnly Hidden   ; Additional damage on failure (Overkill Hp)
float Property Pilferage Auto Hidden Conditional        ; Amount of damage to goods/seal (Damaged Hp)

int Property PremiumDelivery_EARLY  = 0 AutoReadOnly Hidden
int Property PremiumDelivery_INTIME = 1 AutoReadOnly Hidden
int Property PremiumDelivery_LATE   = 2 AutoReadOnly Hidden
int Property PremiumDeliveryDelay Auto Hidden Conditional

int Property MissionComplete Auto Hidden Conditional    ; To keep track of mission progress for multi objective missions
int Property JobStage Auto Hidden                       ; The current Job Stage, for objective management
int Property JOBSTAGE_BASE = 21 AutoReadOnly Hidden
int Property MISSIONID_CART = 0 AutoReadOnly Hidden
int Property MISSIONID_PACKAGE = 1 AutoReadOnly Hidden

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
  missions[MISSIONID_CART] = JobCart
  missions[MISSIONID_PACKAGE] = JobDelivery
  If (missionID < 0)
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
  Keyword SLSLicense = Keyword.GetKeyword("_SLS_LicenceDocument")
  Form[] items = PlayerRef.GetContainerForms()
  int i = 0
  While(i < items.Length)
    Keyword[] kw = items[i].GetKeywords()
    If (!kw.Length || kw.Find(bd.SlutsRestraints) == -1 && kw.Find(SLSLicense) == -1)
      PlayerRef.RemoveItem(items[i], INT_MAX, true, Escrow)
    EndIf
    i += 1
  EndWhile
EndFunction

Function SetupHaul()  ; Called during first setup only
  HumilPick = Utility.RandomInt(0, 8)
  DispatcherREF.GetReference().MoveTo(SceneSpell.GetReference())
  PlayerRef.MoveTo(ScenePlayer.GetReference())
  PlayerRef.PlaceAtMe(SummonFX)
  StripPlayer()
  SetupHaulImpl()
  
  MissionComplete = 1 ; To not have HandleStage() fail on first call
  Pilferage = 0.0 - PilferageReinforcement.Value
  PerfectStreak = 0
  Streak = 0
  OvertimePay = 0.0
  TotalPay = 0.0
EndFunction
Function SetupHaulImpl()  ; Called every time BEFORE a new job starts
  Debug.TraceStack("[SLUTS] Function call 'SetupHaulImpl' outside a valid State = " + GetState(), 2)
EndFunction

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
    PlayerAlias.GoToState(JobCart)
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
      SetMissionState(MISSIONID_CART)
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
    PlayerAlias.GoToState(JobDelivery)
    DeliverySelectorQst.Stop()
    ; Expecting an average speed of 10k distance every minute
    PremiumDeliveryDelay = PremiumDelivery_EARLY
    float d = DispatcherREF.GetReference().GetDistance(RecipientREF.GetReference())
    int segments = Math.Ceiling(d / 10000)
    RegisterForUpdate(segments * 40)
  EndFunction

  Event OnUpdate()
    PremiumDeliveryDelay += 1
  EndEvent

  ; Wrapper to remove package before doing payment (or leave it in inventory if not received)
  Function TakePackage(bool abRemovePackage = true)
    If(abRemovePackage)
      PlayerRef.RemoveItem(PackageREF.GetReference())
    EndIf
    If (MCM.iPilferageLevel > MCM.DIFFICULTY_NORM)
      If (PremiumDeliveryDelay == PremiumDelivery_LATE)
        Pilferage += PilferageThresh01.Value
      ElseIf (PremiumDeliveryDelay == PremiumDelivery_LATE + 1)
        Pilferage += PilferageThresh02.Value
      ElseIf (PremiumDeliveryDelay >= PremiumDelivery_LATE + 2)
        Pilferage += PilferageThresh03.Value
      EndIf
    EndIf
    DoPayment()
  EndFunction

  Event OnEndState()
    ; TODO: Once bag implemented, remove it here again
  EndEvent
EndState
Function TakePackage(bool abRemovePackage = true)
  Debug.TraceStack("[SLUTS] Function call 'TakePackage' outside a valid State = " + GetState(), 2)
EndFunction

; ======================================================
; =============================== EVALUATION
; ======================================================

Function HandleStage()
  If(MissionComplete < 1)
    return
  EndIf
  MissionComplete = 0 - MissionType.GetValueInt()
  int stage = JOBSTAGE_BASE + MissionType.GetValueInt()
  If(stage != JobStage) ; Switching haul type, hide the previous objective
    SetObjectiveDisplayed(stage, false)
    If(stage == JOBSTAGE_BASE + MISSIONID_PACKAGE) ; Prem Delivery also has Stage 100
      SetObjectiveDisplayed(100, false)
    EndIf
  EndIf
  JobStage = stage
  If(IsObjectiveCompleted(JobStage))
    SetObjectiveCompleted(JobStage, false)
  EndIf
  SetObjectiveDisplayed(JobStage, true, true)
EndFunction

Function CompleteJobStages()
  SetObjectiveCompleted(JobStage)
  If(JobStage == 22)
    SetObjectiveCompleted(100)
  EndIf
EndFunction

Function Fail()
  MissionComplete = 1
  Pilferage = GoodsTotal + KartHealth
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
    TakePackage(false)
  EndIf
EndFunction

Function CreateChainMission(bool abForced, int aiMissionID = -1)
  Actor recip = RecipientREF.GetReference() as Actor
  Actor next = Main.GetDestination(recip, DispatcherREF.GetActorReference())
  Debug.Trace("[SLUTS] Attempting Chain Mission with new Dispatcher = " + recip + " | Recipient = " + next)
  If (!SetLinks(recip, next))
    Quit()
    return
  EndIf
  forced = abForced
  DispatcherREF.ForceRefTo(recip)
  RecipientREF.ForceRefTo(next)
  RecipientLOC.ForceLocationTo(Main.myDestLocs[Main.myDrivers.Find(next)])
  RecipientLOCHold.ForceLocationTo(GetHold(RecipientLOC))
  SetMissionState(aiMissionID)
  SetupHaulImpl()
  Payment.SetValue(GetBasePay(recip, next, 1.0))
  UpdateCurrentInstanceGlobal(Payment)
  Debug.Trace("[SLUTS] ChainMission; Payment = " + Payment.GetValueInt())
  Pilferage = 0.0 - PilferageReinforcement.Value
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
  If (overtimepay > 0)
    int coins = Math.Floor(overtimepay * GetOvertimeBonus())
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
  float ret = Math.sqrt(distance * SkyrimDiameter * MCM.fPaymentArg) / 10
  ; float ret = (Math.pow(Math.sqrt((Math.pow(MCM.fPaymentArg, -1.0) * distance) / SkyrimDiameter), -1.0) * distance) / 10
  return ret * mult
EndFunction

float Function GetOvertimeBonus()
  If(SlutsCrime.GetCrimeGold() > 0 || PerfectStreak == 0)
    return 0
  else
    ; Explanation: https://www.loverslab.com/topic/146751-sluts-resume/page/15/#comment-3360719
    float ret
    If(PerfectStreak < 15)
      ret = MCM.fOvertimeArg * Math.pow(1.4, (0.3 * PerfectStreak)) - MCM.fOvertimeArg
    else
      ret = MCM.fOvertimeArg * 5
    EndIf
    ; notify("Having agreed to " + streakPerfect + " hauls in a row your overtime bonus is now " + bonusPerCent + "%")
    Debug.Trace("Overtime Bonus: " + (ret * 100) + "%")
    return ret
  EndIf
EndFunction

Function DoPayment()
  Streak += 1
  bool perfectrun = Pilferage <= PilferageThresh00.GetValue()
  data.RunCompleted(perfectrun)
  ; Finalize Payment, payout to Escrow Chest, get response type
  int crime = SlutsCrime.GetCrimeGold()
  int pay = Payment.GetValueInt()
  If(perfectrun)
    overtimepay += pay
    PerfectStreak += 1
    If(crime == 0)
      EvalResponse = Response_Flawless
    ElseIf(crime <= pay)
      EvalResponse = Response_DebtDone
    Else
      EvalResponse = Response_ReduceDebt1
    EndIf
  Else
    float difficulty = MCM.iPilferageLevel as float
    float mult = (2.0 * (difficulty + 0.5) * Pilferage) / (PilferageThresh02.GetValue() * (difficulty + 1.0))
    pay -= Math.Floor(mult * pay)
    overtimepay = 0
    PerfectStreak = 0
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
  Debug.Trace("[SLUTS] Eval Response = " + EvalResponse)
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
  Debug.Trace("[SLUTS] Post Eval => Payment = " + pay + " | Debt = " + SlutsCrime.GetCrimeGold() + " | Overtime Bonus = " + overtimepay)
  TotalPay += pay
  ; Payment = {} | Debt = {} | Overtime Bonus = {}
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
    Pilferage = Utility.RandomFloat(PilferageThresh01.GetValue(), GoodsTotal + KartHealth)
  Else
    Pilferage = GoodsTotal + KartHealth
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
  If(!Ctrl || !Kart || PlayerRef.IsInInterior())
    return
  EndIf
  If(KeyCode == ActivateKey)
    If(!bIsThethered)
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
  RegisterEvents()
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
  If(!HasPlayer || MissionComplete != (0 - MISSIONID_CART))
    return
  EndIf
  Untether()
EndEvent

Event OnAnimEnd(int tid, bool HasPlayer)
  Actor[] positions = SlutsAnimation.GetSceneActors(tid)
  String[] hooks = SlutsAnimation.GetSceneHooks(tid)
  If(hooks.Find("SLUTS_Humil") > -1)
    Debug.Trace("[SLUTS] Humiliation Scene End")
    Utility.Wait(0.2)
    moveChestScene.Start()
    return
  ElseIf(hooks.Find("SLUTS_BlackMailSex") > -1)
    Actor[] copy = PapyrusUtil.RemoveActor(positions, PlayerRef)
    GambleBlackmailFailure(copy[0])
    SetStage(100)
  ElseIf(!MCM.bCargoAssault || !SlutsAnimation.GetSceneVictim(tid) != PlayerRef || GetStage() != 20)
    Debug.Trace("[SLUTS] Scene End Pilferage is disabled or Player is not Victim")
    return
  EndIf
  Debug.Trace("[SLUTS] Piferage at Scene End | Pre = " + Pilferage)
 
  int type = 0
  int i = 0
  While(i < positions.Length)
    Actor p = positions[i]
    If(p.IsPlayerTeammate() || p.IsInFaction(DriverFaction))
      return
    ElseIf(p.IsInFaction(BanditFaction) || p.IsInFaction(ForswornFaction))
      type = 1
    ElseIf(p.GetActorValue("Morality") < 2)
      type = 2 + p.GetActorValue("Morality") as int
    EndIf
    i += 1
  EndWhile
  If(type == 1 || type > 2 && Utility.RandomInt(0, 99) < 40 * (1 + Math.pow(type, -1)))
    float robbed = Utility.RandomFloat(5 + positions.length, 15 + positions.length)
    Pilferage += GoodsTotal * (robbed / 100)
    If(Pilferage > GoodsTotal * 1.1)
      Pilferage = GoodsTotal * 1.1
    EndIf
    ScenePilferageMsg.Show(Pilferage, GoodsTotal)
  EndIf
  Debug.Trace("[SLUTS] Piferage at Scene End | Post = " + Pilferage)
endEvent

; ======================================================
; =============================== HUMILIATION
; ======================================================

; HumilPick = 4
Function debitRate()
  If(TotalPay <= 0)
    return
  EndIf
  float mult = Utility.RandomFloat(0.05, 0.35)
  int debit = Math.Floor(TotalPay * mult)
  Escrow.RemoveItem(FillyCoin, debit)
  float percent = mult * 100
  DebitMsg.Show(percent)
  Debug.Trace("[SLUTS] HumilPick4; Debit Rate " + percent as int)
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

