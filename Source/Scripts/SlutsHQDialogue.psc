Scriptname SlutsHQDialogue extends Quest

import StringUtil
; ----------------------------- Properties
SlutsMCM Property MCM Auto
SlutsBondage Property Bd Auto
SlutsData Property data Auto
SlutsHQBusinessLedger Property ledger Auto
Actor Property PlayerRef Auto
MiscObject Property FillyCoin Auto
MiscObject Property Gold001 Auto
; --- Upgrade Choice = Slot in this Array
Book[] Property upgradeCertificate Auto
Book Property purchaseCertificateBlindfold Auto
Book Property purchaseCertificateChastity Auto
; --- Messages
Message[] Property GoldMessages Auto
{0 -> (You dont have Coin), 1 -> (Trade X Coin into Y Gold)}
Message[] Property upgradeMsg Auto
{Your current RLv is X, Upgrade costs Y, you have Z coins
0 -> Briddle, 1 -> Boots, 2 -> Mittens, 3 -> Blindfold}
Message[] Property purchaseMsg Auto
{even: Do not own, purchase for X? You have Y coins
uneven: You own, want to sell for X coins?
0/1 -> Blindfold, 2/3 -> Chastity}
; --- General Goods Stuff
MiscObject Property titanium Auto
Message[] Property TitaniumMsg Auto
Key[] Property DeviceKeys Auto
Message[] Property keyMsg Auto
; --- Misc
SlutsHQFactionCheck Property sceneTrigger Auto
{Used in Door Guard Dialogue to call the Trigger Script}
; ----------------------------- Variables
UILIB_1 uilib
int[] upgradeBuffer
; ----------------------------- Code
; ==============================================
;                 SETUP FUNCTIONS
; ==============================================
Event OnInit()
  uilib = (Self as Form) as UILIB_1
  upgradeBuffer = new int[5]
EndEvent

; ==============================================
;               MERCHANT FUNCTIONS
; ==============================================
Function barter(Actor speaker)
  string[] barterMenu = new string[5]
  barterMenu[0] = " Exchange Gold\t\t(75)"
  barterMenu[1] = " General Goods\t\t[->]"
  barterMenu[2] = " Upgrade Service\t[->]"
  barterMenu[3] = " Filly Gear\t\t[->]"
  barterMenu[4] = " Cancel"

  int choice = uilib.ShowList("Filly Coin Exchange", barterMenu, 0, 0)
  If(choice == barterMenu.Length - 1)
    return
  ElseIf(choice == 0) ; Gold
    goldExchange()
  ElseIf(choice == 1) ; General Goods
    openStore()
  ElseIf(choice == 2) ; Upgrades
    upgradeStore()
  ElseIf(choice == 3) ; Filly Gear
    costumeStore()
  EndIf
EndFunction
; ============================= UTILITY ==========
bool Function checkDigit(string myString)
  int msgLength = GetLength(myString)
  int count = 0
  While(count < msgLength)
    If(!IsDigit(GetNthChar(myString, count)))
      Debug.Notification("Invalid character. Only digits are allowed")
      return false
    EndIf
    count += 1
  EndWhile
  return true
EndFunction

bool Function payCoins(int amount)
  If(PlayerRef.GetItemCount(FillyCoin) < amount)
    Debug.MessageBox("You don't have enough Filly Coins to pay for this.")
    return false
  EndIf
  PlayerRef.RemoveItem(FillyCoin, amount)
  return true
EndFunction
; ============================= GOLD ==========
Function goldExchange()
  int coinNum = PlayerRef.GetItemCount(FillyCoin)

  string tmpStr = "ABC"
  While(checkDigit(tmpStr) == false)
    tmpStr = uilib.ShowTextInput("Enter the amount of Gold you want to receive.\nCurrent Balance: " + coinNum + " (Allowing for " + coinNum/75 + " Gold)", "")
    If(tmpStr == "")
      return
    EndIf
  EndWhile

  int goldNum = tmpStr as int
  If(goldNum == 0)
    return
  EndIf
  int price = goldNum * 75
  If(price > coinNum)
    coinNum -= coinNum % 75
    goldNum = coinNum / 75
    If(GoldMessages[0].Show(goldNum) == 1)
      return
    EndIf
  ElseIf(GoldMessages[1].Show(price, goldNum) == 1)
    return
  EndIf

  PlayerRef.RemoveItem(FillyCoin, price)
  PlayerRef.AddItem(Gold001, goldNum)
EndFunction
; ============================= GENERAL GOODS ==========
Function openStore()
  string[] goods = new string[3]
  goods[0] = " Titanium\t(100 000)"
  goods[1] = " Device Keys\t[->]"
  goods[2] = " Cancel"

  int ware = uilib.ShowList("General Goods", goods, 0, 0)
  If(ware == goods.Length - 1)
    return
  ElseIf(ware == 0) ; Titanium
    storeTitanium()
  ElseIf(ware == 1) ; Keys
    string[] keys = new string[6]
    keys[0] = " S.L.U.T.S. Device Key\t\t(20 000)"
    keys[1] = " S.L.U.T.S. Furniture Key\t\t(25 000)"
    keys[2] = " Devious Restraints Key\t\t(17 500)"
    keys[3] = " Devious Chastity Key\t\t(22 500)"
    keys[4] = " Piercing Removal Tool\t\t(20 000)"
    keys[5] = " Cancel"

    ware = uilib.ShowList("Which Key do you want to buy?", keys, 0, 0)
    If(ware != keys.Length - 1)
      storeKeys(ware)
    EndIf
  EndIf
EndFunction

Function storeTitanium()
  int titaniumPrice = 100000
  int coinNum = PlayerRef.GetItemCount(FillyCoin)

  string tmpStr = "ABC"
  While(checkDigit(tmpStr) == false)
    tmpStr = uilib.ShowTextInput("How much Titanium do you want to buy?.\nCurrent Balance: " + coinNum + " (Allowing for " + coinNum/titaniumPrice + " Titanium Ingots)", "")
    If(tmpStr == "")
      return
    EndIf
  EndWhile

  int titaniumNum = tmpStr as int
  If(titaniumNum == 0)
    return
  EndIf
  int price = titaniumNum * titaniumPrice
  If(price > coinNum)
    coinNum -= coinNum % titaniumPrice
    titaniumNum = coinNum / titaniumPrice
    If(TitaniumMsg[0].Show(titaniumNum) == 1)
      return
    EndIf
  ElseIf(TitaniumMsg[1].Show(price, titaniumNum) == 1)
    return
  EndIf

  PlayerRef.RemoveItem(FillyCoin, price)
  PlayerRef.AddItem(titanium, titaniumNum)
EndFunction

Function storeKeys(int keyChoice)
  int coinNum = PlayerRef.GetItemCount(FillyCoin)
  string[] keys = new string[5]
  keys[0] = " S.L.U.T.S. D. Key"
  keys[1] = " S.L.U.T.S. F. Key"
  keys[2] = " Devious Rest. Key"
  keys[3] = " Devious Chas. Key"
  keys[4] = " Pierc. Remov. Tool"
  int[] keyPrice = new int[5]
  keyPrice[0] = 20000
  keyPrice[1] = 25000
  keyPrice[2] = 17500
  keyPrice[3] = 22500
  keyPrice[4] = 20000

  string tmpStr = "ABC"
  While(checkDigit(tmpStr) == false)
    tmpStr = uilib.ShowTextInput("How many " + keys[keyChoice] + " do you want to buy?.\nCurrent Balance: " + coinNum + " (Allowing for " + coinNum/keyPrice[keyChoice] + " Keys)", "")
    If(tmpStr == "")
      return
    EndIf
  EndWhile

  int keyNum = tmpStr as int
  int price = keyNum * keyPrice[keyChoice]
  If(keyNum == 0)
    return
  ElseIf(price > coinNum)
    coinNum -= coinNum % keyPrice[keyChoice]
    keyNum = coinNum / keyPrice[keyChoice]
    If(keyMsg[0].Show(keyNum) == 1)
      return
    EndIf
  ElseIf(keyMsg[1].Show(price, keyNum) == 1)
    return
  EndIf

  PlayerRef.RemoveItem(FillyCoin, price)
  PlayerRef.AddItem(deviceKeys[keyChoice], keyNum)
EndFunction
; ============================= FILLY GEAR UPGRADE ==========
int Function getPay(int x)
  return Math.Ceiling(1150 * Math.pow(x, 3))
EndFunction

Function upgradeStore()
  int[] tmpData = new int[5]
  tmpData[0] = data.uniformReinforceLvGag
  tmpData[1] = data.uniformReinforceLvBoots
  tmpData[2] = data.uniformReinforceLvGloves
  tmpData[3] = data.uniformReinforceLvBlindfold
  tmpData[4] = data.uniformReinforceLvChastity
  string[] toUp = new string[6]
  toUp[0] = " Briddle\t\t(Lv. " + tmpData[0] + "/10)"
  toUp[1] = " Boots\t\t(Lv. " + tmpData[1] + "/10)"
  toUp[2] = " Mittens\t\t(Lv. " + tmpData[2] + "/10)"
  toUp[3] = " Blindfold\t(Lv. " + tmpData[3] + "/10)"
  toUp[4] = " Chastity\t(Lv. " + tmpData[4] + "/3)"
  toUp[5] = " Cancel"

  bool breakLoop = false
  int upgrade
  While(breakLoop == false)
    upgrade = uilib.ShowList("Upgrades", toUp, 0, 0)
    If(upgrade == toUp.Length - 1)
      return
    Else
      If((tmpData[upgrade] == 3 && upgrade == toUp.Length - 2) || (tmpData[upgrade] == 10))
        Debug.Notification("This Item is already fully upgraded.")
      ElseIf(PlayerRef.GetItemCount(upgradeCertificate[upgrade]) >= 1)
        Debug.Notification("You already own an Upgrade Certifikate for that Armor type.")
        return
      else
        breakLoop = true
      EndIf
    EndIf
  EndWhile

  int pay
  If(upgrade != toUp.Length - 2)
    pay = getPay(tmpData[upgrade] + 1 + upgradeBuffer[upgrade])
  else
    pay = getPay((data.uniformReinforceLvChastity + 1) * 3 + upgradeBuffer[upgrade])
  EndIf
  If(upgradeMsg[upgrade].Show(tmpData[upgrade], pay, PlayerRef.GetItemCount(FillyCoin)) == 1)
    return
  ElseIf(pay > PlayerRef.GetItemCount(FillyCoin))
    Debug.MessageBox("You don't have enough Filly Coins to upgrade this Item.")
    return
  EndIf
  PlayerRef.RemoveItem(FillyCoin, pay)
  PlayerRef.AddItem(upgradeCertificate[upgrade])
  upgradeBuffer[upgrade] = upgradeBuffer[upgrade] + 1
EndFunction
; ============================= FILLY GEAR CUSTOMISATION ==========
Function costumeStore()
  string[] gearCostume = new string[6]
  gearCostume[0] = " Unlock Uniform-Dyes\t\t[->]"
  gearCostume[1] = " Purchase/Sell Blindfold\t\t(50 000)"
  gearCostume[2] = " Purchase/Sell Chastity\t\t(50 000)"
  gearCostume[3] = " Unlock Yokes\t\t\t[->]"
  gearCostume[4] = " Unlock Tails\t\t\t[->]"
  gearCostume[5] = " Cancel"

  int option = uilib.ShowList("Filly Gear", gearCostume, 0, 0)
  If(option == gearCostume.Length - 1)
    return
  ElseIf(option == 0)
    unlockDyes()
  ElseIf(option == 1)
    If(data.useBlindfold == false)
      unlockAccessoire(0)
    else
      lockAccessoire(1)
    EndIf
  ElseIf(option == 2)
    If(data.useChastity == false)
      unlockAccessoire(2)
    else
      lockAccessoire(3)
    EndIf
  ElseIf(option == 3)
    unlockYokes()
  ElseIf(option == 4)
    unlockTails()
  EndIf
EndFunction

Function unlockDyes()
  string[] unlocks = new string[5]
  If(ledger.colorValid[3] == false)
    unlocks[0] = " White"
  EndIf
  If(ledger.colorValid[2] == false)
    unlocks[1] = " Red"
  EndIf
  If(ledger.colorValid[0] == false)
    unlocks[2] = " Blue"
  EndIf
  If(ledger.colorValid[1] == false)
    unlocks[3] = " Pink"
  EndIf
  unlocks[4] = " Cancel"
  unlocks = PapyrusUtil.RemoveString(unlocks, "")

  int toUnlock = uilib.ShowList("What color do you want to unlock? (250 000)", unlocks, 0, 0)
  If(toUnlock == unlocks.Length - 1)
    return
  ElseIf(payCoins(250000) == true)
    If(unlocks[toUnlock] == " Blue")
      ledger.colorValid[0] = true
    ElseIf(unlocks[toUnlock] == " Pink")
      ledger.colorValid[1] = true
    ElseIf(unlocks[toUnlock] == " Red")
      ledger.colorValid[2] = true
    ElseIf(unlocks[toUnlock] == " White")
      ledger.colorValid[3] = true
    EndIf
    Debug.MessageBox("Unlocked Dye:" + unlocks[toUnlock] + "!")
  EndIf
EndFunction

Function unlockAccessoire(int type)
  ; "You currently dont own <type>. Buy costs X Coins, you have Y Coins"
  If(purchaseMsg[type].Show(50000, PlayerRef.GetItemCount(FillyCoin)) == 1)
    return
  ElseIf(payCoins(50000) == false)
    Debug.MessageBox("You don't have enough Filly Coins.")
    return
  else
    ; Add Book
    If(type == 0) ; Blindfold
      PlayerRef.AddItem(purchaseCertificateBlindfold)
    elseIf(type == 2) ; Chastity
      PlayerRef.AddItem(purchaseCertificateChastity)
    EndIf
  EndIf
EndFunction

Function lockAccessoire(int type)
  ; "You already own <type>. Do you want to sell for Y. Upgrades stay"
  If(purchaseMsg[type].Show(10000) == 1)
    return
  else
    PlayerRef.RemoveItem(FillyCoin, 10000)
    ;Set Flag
    If(type == 1)
      data.useBlindfold = false
    ElseIf(type == 3)
      data.useChastity = false
    EndIf
  EndIf
EndFunction

Function unlockYokes()
  string[] unlocks = new string[7]
  If(ledger.yokeValid[0] == false)
    unlocks[0] = " Breast\t\t\t(500 000)"
  EndIf
  If(ledger.yokeValid[1] == false)
    unlocks[1] = " Chained\t\t(425 000)"
  EndIf
  If(ledger.yokeValid[2] == false)
    unlocks[2] = " Armbinder (Black)\t(350 000)"
  EndIf
  If(ledger.yokeValid[3] == false)
    unlocks[3] = " Armbinder (Red)\t(350 000)"
  EndIf
  If(ledger.yokeValid[4] == false)
    unlocks[4] = " Armbinder (White)\t(350 000)"
  EndIf
  If(ledger.yokeValid[5] == false)
    unlocks[5] = " Hand-Cuffs\t\t(500 000)"
  EndIf
  unlocks[6] = " Cancel"
  unlocks = PapyrusUtil.RemoveString(unlocks, "")

  int toUnlock = uilib.ShowList("What Yoke do you want to unlock?", unlocks, 0, 0)
  If(unlocks[toUnlock] == " Breast\t\t\t(500 000)")
    If(payCoins(500000) == true)
      ledger.yokeValid[0] = true
      Debug.MessageBox("Unlocked Breast Yoke!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Chained\t\t(425 000)")
    If(payCoins(425000) == true)
      ledger.yokeValid[1] = true
      Debug.MessageBox("Unlocked Yoke (Chained)!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Armbinder (Black)\t(350 000)")
    If(payCoins(350000) == true)
      ledger.yokeValid[2] = true
      Debug.MessageBox("Unlocked Armbinder (Black)!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Armbinder (Red)\t(350 000)")
    If(payCoins(350000) == true)
      ledger.yokeValid[3] = true
      Debug.MessageBox("Unlocked Armbinder (Red)!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Armbinder (White)\t(350 000)")
    If(payCoins(350000) == true)
      ledger.yokeValid[4] = true
      Debug.MessageBox("Unlocked Armbinder (White)!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Hand-Cuffs\t\t(500 000)")
    If(payCoins(500000) == true)
      ledger.yokeValid[5] = true
      Debug.MessageBox("Unlocked Hand-Cuffs!")
    EndIf
  EndIf
EndFunction

Function unlockTails()
  string[] unlocks = new string[6]
  If(ledger.tailValid[0] == false)
    unlocks[0] = " Lush\t\t\t(200 000)"
  EndIf
  If(ledger.tailValid[1] == false)
    unlocks[1] = " Braided\t\t(200 000)"
  EndIf
  If(ledger.tailValid[2] == false)
    unlocks[2] = " Braided /w Bow\t(250 000)"
  EndIf
  If(ledger.tailValid[3] == false)
    unlocks[3] = " Chain (Bell)\t\t(300 000)"
  EndIf
  If(ledger.tailValid[4] == false)
    unlocks[4] = " Chain (Sign)\t\t(325 000)"
  EndIf
  unlocks[5] = " Cancel"
  unlocks = PapyrusUtil.RemoveString(unlocks, "")

  int toUnlock = uilib.ShowList("What Tail do you want to unlock?", unlocks, 0, 0)
  If(unlocks[toUnlock] == " Lush\t\t\t(200 000)")
    If(payCoins(200000) == true)
      ledger.tailValid[0] = true
      Debug.MessageBox("Unlocked Lush Tail!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Braided\t\t(200 000)")
    If(payCoins(200000) == true)
      ledger.tailValid[1] = true
      Debug.MessageBox("Unlocked Braided Tail!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Braided /w Bow\t(250 000)")
    If(payCoins(250000) == true)
      ledger.tailValid[2] = true
      Debug.MessageBox("Unlocked Braided Tail with Bow!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Chain (Bell)\t\t(300 000)")
    If(payCoins(300000) == true)
      ledger.tailValid[3] = true
      Debug.MessageBox("Unlocked Chain-Tail (Bell)!")
    EndIf
  ElseIf(unlocks[toUnlock] == " Chain (Sign)\t\t(325 000)")
    If(payCoins(325000) == true)
      ledger.tailValid[4] = true
      Debug.MessageBox("Unlocked Chain-Tail (Sign)!")
    EndIf
  EndIf
EndFunction

; ==============================================
;              BLACKSMITH FUNCTIONS
; ==============================================
; Gag, Boots, Mittens, Blindfold, Chastity
Function upgradeGear(int type)
  ; Reset Buffer
  upgradeBuffer[type] = 0
  ; Remove Certifikate
  PlayerRef.RemoveItem(upgradeCertificate[type], 1)
  PlayerRef.RemoveItem(upgradeCertificate[type], 99, true)
  ; Set Flag
  If(type == 0)
    data.uniformReinforceLvGag += 1
  ElseIf(type == 1)
    data.uniformReinforceLvBoots += 1
  ElseIf(type == 2)
    data.uniformReinforceLvGloves += 1
  ElseIf(type == 3)
    data.uniformReinforceLvBlindfold += 1
  ElseIf(type == 4)
    data.uniformReinforceLvChastity += 1
  EndIf
  ; Upgrade Gear
  Bd.setLeveledGear()
EndFunction

; Blindfold, Chastity
Function unlockGear(int type)
  If(type == 0)
    PlayerRef.RemoveItem(purchaseCertificateBlindfold)
    PlayerRef.RemoveItem(purchaseCertificateBlindfold, 99, true)
    data.useBlindfold = true
  ElseIf(type == 1)
    PlayerRef.RemoveItem(purchaseCertificateChastity)
    PlayerRef.RemoveItem(purchaseCertificateChastity, 99, true)
    data.useChastity = true
  EndIf
EndFunction

; ==============================================
;              DOORGUARD FUNCTIONS
; ==============================================
Function serveGuard(Actor guard)
  Actor[] actors = new Actor[2]
  actors[0] = PlayerRef
  actors[1] = guard
  SlutsAnimation.StartSceneByActors(actors)
EndFunction

Function lockRandomRestraintOnPlayer()
  Armor toLock = bd.GetRandomArmorReg(PlayerRef)
  bool cutCoins
  If(toLock == none)
    cutCoins = true
  else
    bd.equip(PlayerRef, toLock)
    If(Utility.RandomInt(0, 99) < 33)
      cutCoins = true
    EndIf
  EndIf
  If(cutCoins == true)
    PlayerRef.RemoveItem(FillyCoin, Utility.RandomInt(10000, 100000))
  EndIf
  If(Utility.RandomInt(0, 99) < 80)
    PlayerRef.RemoveItem(DeviceKeys[0], Utility.RandomInt(3, 20))
  EndIf
EndFunction
