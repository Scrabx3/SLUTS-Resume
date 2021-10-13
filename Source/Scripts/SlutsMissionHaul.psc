Scriptname SlutsMissionHaul extends Quest Conditional
{Main Script for Hauling Quests}

;/ V2.5 - I redo majority of this Script to support more than a Single Haul, this Script will store most/all of the Utility Required for any Haul. I will shred this Script from previous iterations to avoid the confusion with the incredible amount of commented code, with this, Sluts Redux will be forgotten by Resume entirely. Goodbye dear predacasor

Escrow will be only 1 Chest going forward and have all of its Logic stored in its own Script

Payment will be managed properly in a centralized Area rather than splitted across this Script
/;
; ---------------------------------- Generic Properties
SlutsMCM Property MCM Auto
SlutsData Property data Auto
SlutsBondage Property Bd Auto
SexLabFramework Property SL Auto
SlutsMain Property Main Auto
SlutsEscrow Property Escrow Auto

Actor Property PlayerRef Auto
; Picked by Story Manager:
ReferenceAlias Property DispatcherREF Auto
ReferenceAlias property RecipientREF Auto
ReferenceAlias Property Manifest Auto
; Through Script:
ReferenceAlias Property ScenePlayer Auto ; Where the Player stands in Intro
ReferenceAlias Property SceneKart Auto ; Where the cart Spawns in Intro
ReferenceAlias Property SceneSpell Auto ; From where the Carter casts his Spell
ReferenceAlias Property SceneRecipient Auto ; Where the Recipient Waits

Keyword Property RootLink Auto ; Driver to Root
Keyword Property EscrowLink Auto ; Root to Escrow
Keyword Property PlayerWaitLoc Auto ; Root to Player Marker
Keyword Property KartSpawnLoc Auto ; Root to Kart Marker
Keyword Property SpellCastLoc Auto ; Root to Spellcast Marker
Keyword Property CarriageDriver Auto ; Root to Escrow
; ===
ReferenceAlias Property KartREF Auto ; Used for Dialogue Conditions
Activator Property Kart_Form Auto ; Carts Base Object

ObjectReference Property escrowSpawn Auto Hidden
{The Escrows Default Position for the current Haul}

GlobalVariable Property pay Auto
{Payment for this Haul only, stored in a Global cause Manifest Text}
GlobalVariable Property totalPay Auto
{Stores Payment for the entire Hauling Session}
MiscObject Property FillyCoin Auto
MiscObject Property Gold001 Auto
Message Property continue Auto
Book Property HandBook Auto
Keyword Property ActorTypeNPC Auto
Spell Property debtCollectSpell Auto ; While active, picked up gold pays Crimegold

; Quest[] Property haulingTypes Auto
Scene Property moveChestScene Auto ; Post Humiliation reward

Faction Property crimeFaction Auto ; Sluts Crime Faction
Faction Property DriverFaction Auto ; All Drivers
Faction Property DirtyFaction Auto ; For Dirt Tats
Faction Property PlayerFollowerFaction Auto
Faction Property BanditFaction Auto
Faction property ForswornFaction Auto
Faction[] Property FriendFactions Auto

; Faction Property PredatorFriendFaction Auto
; Faction Property CreatureFriendFaction Auto
; Faction Property BanditFriendFaction Auto

; Worldspaces
Worldspace Property Tamriel Auto
Worldspace Property Solstheim Auto
ObjectReference Property windhelmPort Auto
ObjectReference Property ravenRockPort Auto
; Holds
location property EastmarchHoldLocation auto
location property HaafingarHoldLocation auto
location property ReachHoldLocation auto
location property RiftHoldLocation auto
location property WhiterunHoldLocation auto
location property FalkreathHoldLocation auto
location property PaleHoldLocation auto
location property HjaalmarchHoldLocation auto
location property WinterholdHoldLocation auto
; Capitals
location property WindhelmLocation auto
location property SolitudeLocation auto
location property MarkarthLocation auto
location property RiftenLocation auto
location property WhiterunLocation auto
location property FalkreathLocation auto
location property DawnstarLocation auto
location property MorthalLocation auto
location property WinterholdLocation auto
; ---------------------------------- Variables
int Property haulType Auto Hidden Conditional
{Used identify the currently running Haul;
Conditional -> which spell to cast in startScene01}

;Keycodes:
int ActivateKey
int JumpKey
int ResetKey
bool handbrake = false

; OnHaul
float Property Pilferage = 0.0 Auto Hidden Conditional ;Lost goods
float baseValue = 1500.0 ;Amount of Goods total

; Humiliation System
bool Property HumilSex = false Auto Hidden
{Is the next SL Event we get with the Driver part of this Event?}
bool Property Humiliated = false Auto Hidden Conditional
{Humiliation done?}
int Property HumilPick = 0 Auto Hidden Conditional
; 0 - Nothing, free to go
; 1 - DD Boots
; 2 - BURN ALL HOBBLEDRESSES
; 3 - Piercings
; 4 - Give up part of your payment
; 5 - Unused
; 6 - Unused
; 7 - Unused
; 8 - Fallback - Sell yourself to the Driver

; Tether System
bool Property bIsThethered Auto Hidden Conditional
ObjectReference Property Kart Auto Hidden

; misc
bool forced
bool wasEssential
; ======================================================
; =============================== NEW HAUL
; ======================================================
;/ A new Haul always starts with this Quest. This Quest is active from beginning of a Haul to end and store the Objectives as well as generic Dialogue
/;
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  Debug.Trace("SLUTS: Started new Haul")
  ; Updating Statistics (..after the Haul)
  forced = aiValue2 == 1
  ; data.UpdateStatistics(aiValue2 == 1)
  ; Collect References
  ObjectReference root0 = akRef1.GetLinkedRef(RootLink)
  ScenePlayer.ForceRefTo(root0.GetLinkedRef(PlayerWaitLoc))
  SceneKart.ForceRefTo(root0.GetLinkedRef(KartSpawnLoc))
  SceneSpell.ForceRefTo(root0.GetLinkedRef(SpellCastLoc))

  ObjectReference root1 = akRef2.GetLinkedRef(RootLink)
  SceneRecipient.ForceRefTo(root1.GetLinkedRef(CarriageDriver))

  If(data.licenseEscrowPort > 0)
    escrowSpawn = root1.GetLinkedRef(EscrowLink)
  else
    escrowSpawn = root0.GetLinkedRef(EscrowLink)
  EndIf
  ; Payment for this Haul:
  ObjectReference Recipient = RecipientREF.GetReference()
  ObjectReference Dispatcher = DispatcherRef.GetReference()
  Worldspace ref2Space = Recipient.GetWorldSpace()
  float p = 1 - (aiValue1 * 0.15)
  float dist
  float tmpPay = 0
  If(Dispatcher.GetWorldSpace() == ref2Space)
    dist = (Dispatcher.GetDistance(Recipient))
  else ; Not same Worldspace, give a 40k Basepay and check Distance from a Port
    If(ref2Space == Tamriel)
      dist = (windhelmPort.GetDistance(Recipient))
      tmpPay = 40.000
    ElseIf(ref2Space == Solstheim)
      dist = (ravenRockPort.GetDistance(Recipient))
      tmpPay = 40.000
    Else
      ; Destination not in Solstheim or Skyrim. Shouldnt ever happen but meh
      dist = 0
      tmpPay = Math.Ceiling(Utility.RandomFloat(27500, 45000))
    EndIf
  EndIf
  tmpPay += Math.Ceiling(((Math.pow(Math.sqrt((Math.pow(MCM.fBaseCredit, -1.0) * dist) / 311231.0), -1.0) * dist) / 10) * p)
  pay.SetValue(tmpPay)
  UpdateCurrentInstanceGlobal(pay)
  ; Start the Haul
  Game.EnableFastTravel(false)
  SetStage(5)
  Debug.Trace("SLUTS: Haul Preparations done, SetStage 5")
  ; Get the actual Hauling Quest
  int fusedWeight = MCM.iHaulType01 + MCM.iHaulType02
  int solution = Utility.RandomInt(1, fusedWeight)
  int walker = 0
  haulType = 0
  While(walker < solution)
    If(haulType == 0)
      walker += MCM.iHaulType01
    ElseIf(haulType == 1)
      walker += MCM.iHaulType02
    else
      walker = solution
    EndIf
    haulType += 1
  EndWhile
  ; Set Hotkeys & Register Events
  ActivateKey = Input.GetMappedKey("Activate")
  JumpKey = Input.GetMappedKey("Jump")
  ResetKey = Input.GetMappedKey("Hotkey8")
  RegisterEvents()
  ; Misc Stuff
  humilPick = Utility.RandomInt(0, 7)
EndEvent

Function RegisterEvents()
  RegisterForKey(ActivateKey)
  RegisterForKey(JumpKey)
  ;RegisterForKey(ResetKey)
  RegisterForModEvent("HookAnimationStart", "OnAnimStart")
	RegisterForModEvent("HookAnimationEnd", "OnAnimEnd")
endFunction

; ======================================================
; =============================== HAUL START0
; ======================================================
Function TransferManifest()
  ObjectReference Paper = Manifest.GetReference()
  DispatcherRef.GetReference().RemoveItem(Paper, 1, true, PlayerRef)
EndFunction

Function ShowManifest()
  ObjectReference Paper = Manifest.GetReference()
  Paper.Activate(PlayerRef)
  Bd.EquipIdx(Bd.gagIDX)
endFunction

Function dressPlayer()
  data.removeAllNonDDItems(PlayerRef, Escrow as ObjectReference)
  Escrow.moveEscrow(escrowSpawn)
  Bd.DressUpPony()
  PlayerRef.AddItem(HandBook)
  If(crimeFaction.GetCrimeGold() > 0)
    PlayerRef.AddSpell(debtCollectSpell)
  EndIf
  If(MCM.bSetEssential)
    ActorBase playerBase = PlayerRef.GetActorBase()
    If(playerBase.IsEssential() == true)
      wasEssential = true
    else
      playerBase.SetEssential(true)
    EndIf
  EndIf
  Escrow.lockEscrow()
EndFunction

; ======================================================
; =============================== DEFAULT HAUL
; ======================================================

; Called from Spell
Function PlaceWagon()
  ObjectReference CartMark = SceneKart.GetReference()
  Kart = CartMark.PlaceAtMe(Kart_Form, abForcePersist = true)
  KartRef.ForceRefTo(Kart)
  dressPlayer()
  Tether(Kart, PlayerRef)
  ; haulingTypes[0].Start()
endFunction

; Called when the Player quits a Series with the last Haul being a Default
Function clearWagon()
  Debug.Trace("SLUTS: Cleaning Player from PonyGear")
  DeleteCart(Kart)
  RestorePony()
EndFunction

; ======================================================
; =============================== END HAUL
; ======================================================

Function ChainMission(int isForced, bool toStart = false)
  If(Kart != none)
    ;Delete Cart. There may be other missions which dont use the cart and looking for them backwards would be fairly undynamic
    DeleteCart(Kart)
  EndIf
  ; Remove Manifest n stuff
  PlayerRef.RemoveItem(HandBook, 1, true)
  Escrow.lockEscrow()
  ; Remove Tats // why? Were doing another Haul right after
  ; tatlib.Scrub(PlayerRef)
  Actor Dispatcher = RecipientRef.GetReference() as Actor
  ; Stop the Quest.. never do this before calling this function you stupid..
  Stop()
  ;Let Main Quest start the new Quest
  If(!toStart)
    Main.ChainMission(Dispatcher, forced = isForced)
  Else
    Main.ChainMission(Dispatcher, Main.myDrivers.find(DispatcherREF.GetActorRef()), isForced)
  EndIf
endFunction

; Complete the current Haul with max pilferage and start a new Haul
Function failHaul()
  ; haulingTypes[0].Stop()
  pilferage = 1800
  payChest()
  ChainMission(1)
EndFunction

; Complete the current Haul and start payment evaluation Scene
Function completeHaul(Scene evalScene)
  ; haulingTypes[0].Stop()
  evalScene.Start()
EndFunction

Function RestorePony()
  MCM.tatLib.livery_off()
  PlayerRef.SetFactionRank(DirtyFaction, 0)
  MCM.tatlib.set_dirty_level(PlayerRef, 0)
  ; Bd.RemoveIdx(Bd.gagIDX)
  Bd.UndressPony(PlayerRef)
  Game.EnableFastTravel(true)
  SetStage(60)
  ;data.customLocation = -1
  ;scrub_tats()
  If(MCM.bSetEssential && wasEssential == false)
    PlayerRef.GetActorBase().SetEssential(false);.QueueNiNodeUpdate()
  EndIf
  ; Escrow.Enable()
  Escrow.Lock(false)
  payOut()
EndFunction

; ======================================================
; =============================== PAYMENT
; ======================================================

; This is called at the end of each Haul, finalizing payment
Function payChest()
  ; Remove Manifest & Handbook
  PlayerRef.RemoveItem(Manifest.GetReference(), 1, true)
  PlayerRef.RemoveItem(HandBook, 1,  true)
  ; purrfect Streak or nah?
  If(pilferage > 0)
    data.clearStreakPerfect()
  else
    data.addStreakPerfect()
  EndIf
  ; finalize pay
  pay.value -= (Pilferage/baseValue) * 1.5 * pay.value
  totalPay.value += pay.value
  data.UpdateStatistics(forced)
  Debug.Trace("SLUTS: Pay this run: " + pay.value + " Pay Total: " + totalPay.value)
EndFunction

Function spontaneousFailure()
  if pilferage == 0
  	;Let's check for Spontaneous Failure
  	if (Utility.RandomInt(1,100) <= mcm.iSpontFail)
  		if mcm.bSpontFailRandom
  			;Deliberately set the chance above the 120 maximum. Overwise max would only have a 1 in 120 chance of happening.
  			pilferage = (Utility.RandomInt(825,2400))
  			if pilferage > 1800
  				pilferage = 1800
  			endif
  		else
  			pilferage = 1800
  		endif

      string X = ""
      if pilferage < 1500
    		X = "some of your cargo appears to be missing"
    	elseif pilferage < 1800
    		X = "much of your cargo is missing"
    	else
    		X = "your cargo is completely gone"
    	endif
    	Debug.Messagebox("In a moment of absent mindedness you glance behind you, only to notice to your horror that " + X + "! You have no idea what happened and can only shudder in a cold sweat knowing you will still have to answer for it...")
  	endif
  endif
EndFunction

; Add total pay to escrow & reset numbers
float Function payOut()
  ; Neither of those should ever happen but just in case..
  If(totalPay.value == 0.0)
    data.endRun()
    return 0.0
  EndIf
  Actor Player = Game.GetPlayer()
  ; Dont apply Overtime Bonnus if we didnt make profit
  int actualPay = Math.Floor(totalPay.value)
  If(actualPay > 0)
    actualPay = Math.Ceiling(data.getOvertimebonus() * actualPay)
    int crimeGold = crimeFaction.GetCrimeGold()
    If(crimeGold > 0)
      ; Indepted
      If(crimeGold > actualPay)
        ; Your gain cant cover your debt, no pay for you
        crimeFaction.ModCrimeGold(-actualPay)
        actualPay = 0
        data.notify("Due to your excessive Debt, you didn't receive any pay for this Series. You did however reduce your debt by " + actualPay + " Coins, bringing your total debt down to " + crimeFaction.GetCrimeGold() + "!")
      Else
        actualPay -= crimeGold
        crimeFaction.SetCrimeGold(0)
        data.notify("You managed to fully pay off your Debt and can call yourself a proper Slut again!\nYour remaning pay (" + actualPay + " Filly Coins) have been added to your Escrow Chest!")
      EndIf
    else
      ; No Debt, just add the full Payment to the Escrow Chest
      data.notify("You earned " + actualPay + " Filly Coins during your last Haul Series; Stored in your Escrow Chest and ready to be taken!")
    EndIf
    Escrow.AddItem(FillyCoin, actualPay, true)
  else
    ; Made a Loss
    If(MCM.bAllDebtToArrears == false) ; Take from Escrow first
      ; 1 Gold = 50 Coins (Yes we Scan the Player, pshhh)
      int goldNum = Player.GetItemCount(Gold001) - MCM.iMinGold
      int coinNum = Player.GetItemCount(FillyCoin)
      ; Take Coins first, then Gold
      If(coinNum > -actualPay)
        ; Got enough Coins to actualPay the Debt entirely
        Player.RemoveItem(FillyCoin, -actualPay, true)
        actualPay = 0
      else
        Player.RemoveItem(FillyCoin, coinNum, true)
        actualPay += coinNum ; actualPay is negative rn
        ; Now take Gold
        If(goldNum * 50 > -actualPay)
          ; got enough Gold to negate the Debt
          Player.RemoveItem(Gold001, -(actualPay/50), true)
          actualPay = 0
        else
          Player.RemoveItem(Gold001, goldNum, true)
          actualPay += goldNum * 50
        EndIf
      EndIf
      ; Check if payment got zero'ed above
      If(actualPay == 0)
        data.notify("S.L.U.T.S. deducted Gold from your Escrow to make up for the Damage you caused. You don't get payed for this Series.")
      else
        If(crimeFaction.GetCrimeGold() > 0)
          ; You already had debt
          crimeFaction.ModCrimeGold(-actualPay) ; Increase Debt by whats left
          data.notify("The finances in your Escrow can't handle the damage you caused. Your debt to S.L.U.T.S. increases by " + -actualPay + " and is now " + crimeFaction.GetCrimeGold())
        else
          crimeFaction.ModCrimeGold(-actualPay)
          data.notify("The Damage you caused is more than you can cover. You are left with mere " + MCM.iMinGold + " gold in your Escrow and are indebted so S.L.U.T.S. with " + -actualPay + " Coins.")
        EndIf
      EndIf
    else
      crimeFaction.ModCrimeGold(-actualPay) ; Increase Debt by whats left
      If(crimeFaction.GetCrimeGold() == 0) ; You already had debt
        data.notify("You are indepted to S.L.U.T.S. with " + crimeFaction.GetCrimeGold() + " Coins.")
      else
        data.notify("The amount of Money you owe S.L.U.T.S. increases by " + -actualPay + " Coins. Your new debt is " + crimeFaction.GetCrimeGold())
      EndIf
    EndIf
  EndIf
  data.endRun()
  totalPay.value = 0.0
EndFunction

; ======================================================
; =============================== KEYCODES
; ======================================================
Event OnKeyDown(int KeyCode)
  bool Ctrl = Input.IsKeyPressed(29) || Input.IsKeyPressed(157)
  If(!Ctrl || !Kart)
    return
  EndIf
  bool shifted = Input.IsKeyPressed(42) || Input.IsKeyPressed(54)
  If(KeyCode == ActivateKey)
    If(!bIsThethered && Kart.GetDistance(PlayerRef) < 450)
      Tether(Kart, PlayerRef)
    ElseIf(!bIsThethered)
      ForceTether(Kart, PlayerRef)
    Else
      If(continue.Show() == 0)
        Unhitch(PlayerRef)
      endIf
    EndIf
  ElseIf(KeyCode == JumpKey)
    ToggleHandbreak()
  ElseIf(keyCode == ResetKey && shifted)
    DeleteCart(Kart)
    Debug.MessageBox("Attempting to Spawn new cart in 3 Seconds..\nDO NOT MOVE.")
    Utility.Wait(1.5)
    ObjectReference myMarker = PlayerRef.PlaceAtMe(FillyCoin, abInitiallyDisabled = true)
    myMarker.SetPosition((myMarker.X - 50.0), (myMarker.Y - 50.0), (myMarker.Z + 10.0))
    Utility.Wait(1)
    Kart = myMarker.PlaceAtMe(Kart_Form, abForcePersist = true)
    Utility.Wait(0.1)
    Tether(Kart, PlayerRef)
    ;/Crashes Game:
    Game.SaveGame("SlutsTmpSave")
    PlayerRef.Reset()
    Utility.Wait(1)
    Game.LoadGame("SlutsTmpSave")/;
  EndIf
EndEvent

Function ToggleHandbreak()
  handbrake = !handbrake
  If(handbrake)
    Kart.SetMotionType(4)
  else
    Kart.SetMotionType(1)
  EndIf
endFunction

; ----------------------------------
Function HumilChest()
  Escrow.moveEscrow(RecipientREF.GetReference().GetLinkedRef(RootLink).GetLinkedRef(EscrowLink))
endFunction

; ======================================================
; =============================== TETHER
; ======================================================
Function Tether(ObjectReference LeCart, Actor myActor)
  Debug.Trace("SLUTS: Attempting to Tether")
  LeCart.TetherToHorse(myActor)
  bIsThethered = true
  Game.EnableFastTravel(false)
  Debug.Trace("SLUTS: Tethered Actor to cart")
endFunction

Function ForceTether(ObjectReference myCart, Actor myActor)
  If(myCart == none)
    Debug.MessageBox("SLUTS ForceTether: No cart found, abandon")
    return
  endif
  Game.DisablePlayerControls()
  ObjectReference Tmp = PlayerRef.PlaceAtMe(FillyCoin, aiCount = 1, abInitiallyDisabled = true)
  Tmp.SetPosition((PlayerRef.X), (PlayerRef.Y - 150), (PlayerRef.Z + 50))
  Utility.Wait(0.05)
  myCart.MoveTo(Tmp)
  Utility.Wait(0.3)
  Tether(myCart, myActor)
  Utility.Wait(0.1)
  Game.EnablePlayerControls()
endFunction

Function OnLoadTether()
  RegisterEvents()
  If(!bIsThethered)
    return
  EndIf
  If(Kart == none)
    bIsThethered = false
  EndIf
  ForceTether(Kart, PlayerRef)
endFunction

Function Untether(ObjectReference myKart, Actor myActor)
  ;myKart.Reset(myActor)
  ;Kart.ApplyHavokImpulse(-1.0, 0.0, 0.5, 0.1)
  ;Utility.Wait(0.2)
  Kart.disable()
  Utility.Wait(0.1)
  Kart.Enable()
  bIsThethered = false
  Debug.Trace("SLUTS: Untethered Kart")
  Game.EnableFastTravel()
endFunction

Function Unhitch(Actor myActor)
  If(!bIsThethered)
    return
  EndIf
  Debug.Trace("SLUTS: Attempting to Unhitch")
  Debug.Notification("Attempting to untether..")
  If(MCM.bStruggle)
    Bd.Lib0.abq.StruggleScene(myActor)
  EndIf
  Untether(Kart, myActor)
  Debug.Notification("You successfully free yourself from the cart")
endFunction

Function DeleteCart(ObjectReference myKart)
  If(myKart == Kart)
    KartRef.Clear()
    Kart = none
  EndIf
  myKart.Disable()
  myKart.Delete()
endFunction

; ======================================================
; =============================== SEXLAB
; ======================================================
;/
Event OnAnimStart(int tid, bool HasPlayer)
  If(GetStage() != 20 || !HasPlayer) ;This type of stuff should only occur during a haul and only when the Player is involed
    return
  EndIf
  Debug.Trace("SLUTS: DefaultHaul: Piferage at SL Scene Start: " + Pilferage)
  ;	disengage cart by toggling enable state
  ;	moved this up here so it should always happen
  Untether(Kart, PlayerRef)
  ;I assume we assume that the player will only ever be in the 1st Position here.. cause theyre a tied up Pony.. yay!
  sslThreadController Thread = SL.GetController(tid)
	Actor[] Acteurs = Thread.Positions
  int Laenge = Acteurs.Length
  If(Laenge < 2)
    return
    ;	come to think of it, the options are a bit limited for 2-ways
    ;	but I like to see her get fucked in the traces, so I'm only doing this
    ;	some of the time ;Well yes.. but actually no
  ElseIf(Laenge == 2)
    ;	if we return here, we won't unhook the player
    ;	so we're unhooking on a 65% chance OR if the actor is a creature
    If(Utility.RandomInt(1, 100) <= 65 || Acteurs[1].getRace().isPlayable())
      return
    EndIf
  EndIf
  If(Acteurs[0] == PlayerRef)
    Untether(Kart, PlayerRef)
  EndIf
EndEvent/;

Event OnAnimEnd(int tid, bool HasPlayer)
  Debug.Trace("SLUTS Haul: Piferage at SL Scene End: " + Pilferage)
  sslThreadController Thread = SL.GetController(tid)
	Actor[] Acteurs = Thread.Positions
  If(HumilSex && Acteurs[0] == PlayerRef)
    ;Humiliation Chest Scene Start
    Utility.Wait(0.2)
    moveChestScene.Start()
    HumilSex = false
    return
  EndIf
  ;	pc in victim role?
  If(!Thread.IsVictim(PlayerRef))
    Debug.Trace("SLUTS Haul: Player isnt Victim in SL Scene. => Abandon")
    return
  EndIf
  Dirtify()
  If(!Acteurs[1].HasKeyword(ActorTypeNPC) || GetStage() != 20)
    Debug.Trace("SLUTS Haul: Creature Rape or not a Cargo Run => Abandon")
    return
  EndIf
  ;Certain other mods can make the carriage drivers, minihub dispatchers, and player followers a bit rapey so let's at least stop them from pilfering you. I guess they could be that big of assholes, but nah, let's not do that...
  bool IncrChance = false
  int i = 0
  While(i < acteurs.length)
    If(Acteurs[i].IsInFaction(DriverFaction) || Acteurs[i].IsInFaction(PlayerFollowerFaction))
      ;Stubborn script refuses to acknowledge the vanilla carriage drivers are now part of the SLUTS faction, so we need this failsafe >:(
      ; Because you only checked for the 2nd Position above :)
      return
    ElseIf((Acteurs[i].IsInFaction(BanditFaction) || Acteurs[i].IsInFaction(ForswornFaction)) && MCM.bPilfChanceIncr)
      IncrChance = true
    EndIf
    i += 1
  EndWhile
	;Also if the random pilferage failure is higher than the MCM setting then cancel pilferage.
  ;Moving this into its own Function so I can call it on multiple occasions
  Debug.Trace("SLUTS: Attempting Pilferage, current Pilferage: " + Pilferage)
  float amount = Pilfered(IncrChance)
  If amount > 0
    int numAggr = Acteurs.Length - 1
    If(numAggr == 0)
      numAggr = 1 ; I suppose it's plausible for mind control scenes...
    EndIf
    ;pilferage += 10 * (n_rapists - 1); add 10% for each additional attacker
    ;This math is wrong. or the comment outdated. I assume the math is wrong since everyone hates math, so rewriting it to do what the comment says:
    amount *= 1+0.1*(numAggr - 1)
    Pilferage += amount
    If(Pilferage > 1800)
      Pilferage = 1800
    EndIf
    Debug.Notification("Somebody has been helping themselves to your goods. Your pilferage value is now " + Pilferage + "/" + baseValue)
  EndIf
endEvent

; ======================================================
; =============================== HUMILIATION
; ======================================================

; HumilPick = 4
Function debitRate()
  float dR = Utility.RandomFloat(0.05, 0.35)
  int debit = Math.Floor(totalPay.Value * dR)
  Escrow.RemoveItem(FillyCoin, debit)
  data.notify(Math.Floor(dR * 100) + "% has been debited from your last payout")
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

; ======================================================
; =============================== UTILITY
; ======================================================
float Function Pilfered(bool HighChance)
  If(!HighChance && Utility.RandomInt(1, 100) > MCM.iChancePilf)
    return 0
  ElseIf(HighChance && Utility.RandomInt(1, 100) > (MCM.iChancePilf*2))
    return 0
  EndIf
  return (Utility.RandomInt(1, MCM.iMaxPilferage))
endFunction

Function Dirtify()
  If(!MCM.bUseDirt)
    return
  EndIf
  int L = PapyrusUtil.ClampInt(PlayerRef.GetFactionRank(DirtyFaction) + 1, 1, 10)
	;slavetats.simple_add_tattoo(pc, "Dirty S.L.U.T.S.", "Dirty Head " + level, last = false, silent = true )
	;slavetats.simple_add_tattoo(pc, "Dirty S.L.U.T.S.", "Dirt " + level, last = true, silent = true )
	PlayerRef.SetFactionRank(DirtyFaction, L)
	mcm.TatLib.set_dirty_level(PlayerRef, L)
endfunction

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

Location Function GetCapital(LocationAlias myDest)
  Location myLoc = myDest.GetLocation()
  If(!myLoc)
    Debug.Trace("SLUTS DefaultHaul: Null Location passed, abandon \"GetCapital\"")
    return none
  EndIf
  Debug.Trace("SLUTS DefaultHaul: Getting Capital for: " + myLoc.GetName())
  If(myLoc == WindhelmLocation)
    Debug.Trace("SLUTS: Capital identified: Windhelm")
    return EastmarchHoldLocation
  elseIf(myLoc == SolitudeLocation)
		Debug.Trace("SLUTS: Capital identified: Solitude")
		return HaafingarHoldLocation
	elseIf(myLoc == MarkarthLocation)
		Debug.Trace("SLUTS: Capital identified: Markarth")
		return ReachHoldLocation
	elseIf(myLoc == RiftenLocation)
		Debug.Trace("SLUTS: Capital identified: Riften")
		return RiftHoldLocation
	elseIf(myLoc == WhiterunLocation)
		Debug.Trace("SLUTS: Capital identified: Whiterun")
		return WhiterunHoldLocation
	elseIf(myLoc == FalkreathLocation)
		Debug.Trace("SLUTS: Capital identified: Falkreath")
		return FalkreathHoldLocation
	elseIf(myLoc == DawnstarLocation)
		Debug.Trace("SLUTS: Capital identified: Dawnstar")
		return PaleHoldLocation
	elseIf(myLoc == MorthalLocation)
		Debug.Trace("SLUTS: Capital identified: Morthal")
		return HjaalmarchHoldLocation
	elseIf(myLoc == WinterholdLocation)
		Debug.Trace("SLUTS: Capital identified: Winterhold")
		return WinterholdHoldLocation
  endIf
	return none
endfunction
