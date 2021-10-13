Scriptname SlutsHQBusinessLedger extends ObjectReference
{Handling Player customisation}

; ----------------------------- Properties
SlutsMCM Property MCM Auto
SlutsBondage Property Bd Auto
Actor Property PlayerRef Auto
; ----------------------------- Variables
UILIB_1 uilib

bool[] Property colorValid Auto
{Blue, Pink, Red, White}
bool[] Property tailValid Auto
{Lush, Braided, Braided /w Bow, Chain (Bell), Chain (Sign)}
bool[] Property yokeValid Auto
{Breast, Chained, ArmbinderBlack, ArmbinderRed, ArmbinderWhite, Cuffs}
; ----------------------------- Properties
Event OnActivate(ObjectReference akActionRef)
  If(akActionRef != PlayerRef)
    return
  EndIf
  uilib = (Self as Form) as UILIB_1

  string[] options = new string[3]
  options[0] = "Choose Color"
  options[1] = "Change Tail"
  options[2] = "Change Yoke"

  int option = uilib.ShowList("What do you want to do?", options, 0, 0)
  If(option == 0)
    string[] colorOptions = getColorOptions()
    setColorOption(colorOptions[uilib.ShowList("Which Color do you want to use?", colorOptions, 0, 0)])
  ElseIf(option == 1)
    string[] tailOptions = getTailOptions()
    setTailOption(tailOptions[uilib.ShowList("Which Tail do you want to use?", tailOptions, 0, 0)])
  ElseIf(option == 2)
    string[] yokeOptions = getYokeOptions()
    setYokeOption(yokeOptions[uilib.ShowList("Which Yoke do you want to use?", yokeOptions, 0, 0)])
  EndIf
EndEvent

; ================================= COLOR ============
string[] Function getColorOptions()
  string[] toRet = new string[6]
  toRet[0] = "Black"
  If(colorValid[3])
    toRet[1] = "White"
  EndIf
  If(colorValid[2])
    toRet[2] = "Red"
  EndIf
  If(colorValid[0])
    toRet[3] = "Blue"
  EndIf
  If(colorValid[1])
    toRet[4] = "Pink"
  EndIf
  toRet[5] = "Cancel"
  return PapyrusUtil.RemoveString(toRet, "")
EndFunction

Function setColorOption(string choice)
  If(choice == "Cancel")
    return
  EndIf
  If(choice == "Black")
    bd.setColor(0)
  ElseIf(choice == "Blue")
    bd.setColor(1)
  ElseIf(choice == "Pink")
    bd.setColor(2)
  ElseIf(choice == "Red")
    bd.setColor(3)
  ElseIf(choice == "White")
    bd.setColor(4)
  EndIf
EndFunction

; ================================= TAIL ============
string[] Function getTailOptions()
  string[] toRet = new string[8]
  toRet[0] = "No Tail"
  toRet[1] = "Basic"
  If(tailValid[0])
    toRet[2] = "Lush"
  EndIf
  If(tailValid[1])
    toRet[3] = "Braided"
  EndIf
  If(tailValid[2])
    toRet[4] = "Braided /w Bow"
  EndIf
  If(tailValid[3])
    toRet[5] = "Chain (Bell)"
  EndIf
  If(tailValid[4])
    toRet[6] = "Chain (Sign)"
  EndIf
  toRet[7] = "Cancel"
  return PapyrusUtil.RemoveString(toRet, "")
EndFunction

Function setTailOption(string choice)
  If(choice == "Cancel")
    return
  EndIf
  If(choice == "No Tail")
    bd.setTail(0)
  ElseIf(choice == "Basic")
    bd.setTail(1)
  ElseIf(choice == "Lush")
    bd.setTail(2)
  ElseIf(choice == "Braided")
    bd.setTail(3)
  ElseIf(choice == "Braided /w Bow")
    bd.setTail(4)
  ElseIf(choice == "Chain (Bell)")
    bd.setTail(5)
  ElseIf(choice == "Chain (Sign)")
    bd.setTail(6)
  EndIf
EndFunction
; ================================= YOKE ============
string[] Function getYokeOptions()
  string[] toRet = new string[8]
  toRet[0] = "Default Yoke"
  If(yokeValid[0])
    toRet[1] = "Breast"
  EndIf
  If(yokeValid[1])
    toRet[2] = "Chained"
  EndIf
  If(yokeValid[2])
    toRet[3] = "ArmbinderBlack"
  EndIf
  If(yokeValid[3])
    toRet[4] = "ArmbinderRed"
  EndIf
  If(yokeValid[4])
    toRet[5] = "ArmbinderWhite"
  EndIf
  If(yokeValid[5])
    toRet[6] = "Hand-Cuffs"
  EndIf
  toRet[7] = "Cancel"
  return PapyrusUtil.RemoveString(toRet, "")
EndFunction

Function setYokeOption(string choice)
  If(choice == "Cancel")
    return
  EndIf
  If(choice == "Default Yoke")
    bd.setYoke(0)
  ElseIf(choice == "Breast")
    bd.setYoke(1)
  ElseIf(choice == "Chained")
    bd.setYoke(2)
  ElseIf(choice == "ArmbinderBlack")
    bd.setYoke(3)
  ElseIf(choice == "ArmbinderRed")
    bd.setYoke(4)
  ElseIf(choice == "ArmbinderWhite")
    bd.setYoke(5)
  ElseIf(choice == "Hand-Cuffs")
    bd.setYoke(6)
  EndIf
EndFunction
