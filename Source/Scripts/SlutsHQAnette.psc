Scriptname SlutsHQAnette extends Actor

zadlibs Property Lib0 Auto

Armor Property AnettesGloves Auto

Event OnCellAttach()
  If(WornHasKeyword(Lib0.zad_DeviousGloves) == false)
    Lib0.LockDevice(Self, AnettesGloves, true)
  EndIf
EndEvent
