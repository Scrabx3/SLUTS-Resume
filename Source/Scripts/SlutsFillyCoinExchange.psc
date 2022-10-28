Scriptname SlutsFillyCoinExchange extends Quest  

; Invoked when the player buys an item from the shop, after payment has been fully processed
; The shop never restocks on its own, so this event can be useful to handle a restock manually if needed
String Function GetCallbackEvent() global
  return "Sluts_OnExchangeCompleted"
EndFunction
Event OnExchangeCompleted(String asEventName, String asStringArg, float afPurchasedAmount, Form akPurchasedItem)
EndEvent

; Add a new item to the Filly Coin Exchange shop
; --- Params
; akItem            - The item to be added
; aiValue           - The price of the item, in Gold/Septims
; aiType            - The items category; 0 - Unspecified | 1 - Gear | 2 - Licenses | 3 - Upgrades | 4 - Customizations/Extras
; aiAvailableStock  - The amount of items that can be sold. -1 implies infinite stock
; aiRequiredRank    - The required filly rank to purchase this item. Recommended to leave at 0
bool Function AddItem(Form akItem, int aiValue, int aiType = 0, int aiAvailableStock = -1, int aiRequiredRank = 0) global
  If(!akItem)
    Debug.TraceStack("Cannot add a 'none' object")
    return false
  ElseIf(StorageUtil.FormListHas(none, ShopStorageKey(), akItem))
    return false
  EndIf
  StorageUtil.FormListAdd(none, ShopStorageKey(), akItem)

  StorageUtil.SetIntValue(akItem, ShopStorageKey() + "t", aiType)
  StorageUtil.SetIntValue(akItem, ShopStorageKey() + "v", aiValue)
  StorageUtil.SetIntValue(akItem, ShopStorageKey() + "s", aiAvailableStock)
  StorageUtil.SetIntValue(akItem, ShopStorageKey() + "r", aiRequiredRank)
  return true
EndFunction

int Function GetPrice(Form akItem) global
  return StorageUtil.GetIntValue(akItem, ShopStorageKey() + "v")
EndFunction
int Function GetStock(Form akItem) global
  return StorageUtil.GetIntValue(akItem, ShopStorageKey() + "s")
EndFunction

Function ModPrice(Form akItem, int aiAmount) global
  SetPrice(akItem, GetPrice(akItem) + aiAmount)
EndFunction
Function ModStock(Form akItem, int aiAmount) global
  SetStock(akItem, GetStock(akItem) + aiAmount)
EndFunction

Function SetPrice(Form akItem, int aiNewPrice) global
  If(StorageUtil.FormListHas(none, ShopStorageKey(), akItem))
    return
  EndIf
  StorageUtil.SetIntValue(akItem, ShopStorageKey() + "v", aiNewPrice)
EndFunction
Function SetStock(Form akItem, int aiNewStock) global
  If(StorageUtil.FormListHas(none, ShopStorageKey(), akItem))
    return
  EndIf
  StorageUtil.SetIntValue(akItem, ShopStorageKey() + "s", aiNewStock)
EndFunction

Function RemoveItem(Form akItem) global
  If(!akItem)
    return
  EndIf
  int i = StorageUtil.FormListFind(none, ShopStorageKey(), akItem)
  If(i > -1)
    StorageUtil.ClearObjIntValuePrefix(akItem, ShopStorageKey())
    StorageUtil.FormListRemoveAt(none, ShopStorageKey(), i)
  EndIf
EndFunction

; ---------- INTERNAL -------------------------------------------------------------------------------------

;/
  struct ShopData
  {
    int ownedcoins
    int fillyrank

    vector<entry>
    {
      string ID
      Form item

      string name
      int price
      int req_fillyrank
      int stock
    }

  }
/;

GlobalVariable Property FillyRank Auto
GlobalVariable Property PriceMult Auto
MiscObject Property FillyCoins Auto
FormList Property DummyList Auto

bool _Initialized = false

float[] Function BuildUpdateData()
  Actor Player = Game.GetPlayer()
  float[] data = new float[3]
  data[0] = 42.0  ; Player.GetActorValue("Encumberance")    ; TODO: find correct AV names for these
  data[1] = 300.0 ; Player.GetActorValue("EncumberanceMax") ; TODO: find correct AV names for these
  data[2] = Player.GetItemCount(FillyCoins)
  return data
EndFunction

String[] Function BuildExtraData(Form[] akForms)
  String[] ret = Utility.CreateStringArray(akForms.Length)
  int i = 0
  While (i < akForms.Length)
    ret[i] = StorageUtil.GetIntValue(akForms[i], ShopStorageKey() + "t") + ";" + \
            StorageUtil.GetIntValue(akForms[i], ShopStorageKey() + "s") + ";" + \
            StorageUtil.GetIntValue(akForms[i], ShopStorageKey() + "r") + ";" + \
            StorageUtil.GetIntValue(akForms[i], ShopStorageKey() + "v") + ";" + \
            akForms[i].GetName()
    i += 1
  EndWhile
  return ret
EndFunction

Function OpenShop()
  ; If(!_Initialized)
  ;   _Initialized = true
    BuildShop()
  ; EndIf

  float[] playerdata = Utility.ResizeFloatArray(BuildUpdateData(), 6)
  playerdata[3] = FillyRank.GetValue()
  playerdata[4] = SlutsData.GetCoinRatio()
  playerdata[5] = PriceMult.GetValue()

  Form[] entries = StorageUtil.FormListToArray(none, ShopStorageKey())
  String[] extra = BuildExtraData(entries)
  DummyList.Revert()
  DummyList.AddForms(entries)
  Debug.Trace("[SLUTS] Opening Coin Exchange with " + DummyList.GetSize() + " items | Size Extra = " + extra.Length)

  RegisterForModEvent("Sluts_OnExchange", "OnExchange")
  RegisterForModEvent("Sluts_PrintInfo", "PrintInfo")

  bool visible = UI.GetBool("HUD Menu", "_root.HUDMovieBaseInstance._visible")

  UI.OpenCustomMenu("SlutsExchange")
  UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance._visible", false)

  UI.InvokeFloatA("CustomMenu", "_root.main.SetData", playerdata)
  UI.InvokeForm("CustomMenu", "_root.main.AddItems", DummyList)
  UI.InvokeStringA("CustomMenu", "_root.main.AddExtraData", extra)
  UI.Invoke("CustomMenu", "_root.main.PopulateShop")

  Utility.Wait(0.1)
  UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance._visible", visible)
EndFunction

Event PrintInfo(String asEventName, String asStringArg, float afPurchasedAmount, Form akPurchasedItem)
  Debug.Notification(asStringArg)
EndEvent

Event OnExchange(String asEventName, String asStringArg, float afPurchasedAmount, Form akPurchasedItem)
  int purchased = afPurchasedAmount as int

  Actor Player = Game.GetPlayer()
  int price = GetPrice(akPurchasedItem)
  If(price > 0)
    price = SlutsData.GetCoinFromGold(price) * purchased
    Player.RemoveItem(FillyCoins, price)
  EndIf
  Player.AddItem(akPurchasedItem, purchased, true)

  UI.InvokeFloatA("CustomMenu", "_root.main.UpdatePlayerInfo", BuildUpdateData())
  ModStock(akPurchasedItem, -purchased)

  akPurchasedItem.SendModEvent(GetCallbackEvent(), "", afPurchasedAmount)
  Debug.Trace("[SLUTS] Purchased " + akPurchasedItem + " x" + purchased + " | Total Price = " + price)
EndEvent

String Function ShopStorageKey() global
  return "SLUTS_ShopEntryData"
EndFunction

MiscObject Property Gold001 Auto
MiscObject Property SLUTS_Titanium Auto

Key Property zadRestraintsKey Auto
Key Property zadChastityKey Auto
Key Property zadPiercingRemovalKey Auto
Key Property SLUTS_FurnitureKey Auto
Key Property SLUTS_RestraintsKey Auto

Function BuildShop()
  AddItem(Gold001, 1)
  AddItem(SLUTS_Titanium, 1000, aiRequiredRank = 3)

  AddItem(zadRestraintsKey, 200)
  AddItem(zadChastityKey, 300)
  AddItem(zadPiercingRemovalKey, 250)
  AddItem(SLUTS_FurnitureKey, 300)
  AddItem(SLUTS_RestraintsKey, 225)
EndFunction
