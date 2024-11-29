Scriptname SlutsEscrowHeadquarters extends ObjectReference  

ObjectReference Property EscrowChest  Auto  


Event OnCellAttach()
  Debug.Trace("[Sluts] Moving Escrow Contents into HQ Chest")
  EscrowChest.RemoveAllItems(self, true)
EndEvent

Event OnCellDettach()
  Debug.Trace("[Sluts] Moving Escrow Contents into HQ Chest")
  If (!EscrowChest)
    Debug.Trace("[Sluts] Error -> Default Escrow not defined")
    return
  EndIf
  RemoveAllItems(EscrowChest, true)
EndEvent