Scriptname SlutsBondage extends Quest
{Stores DD specific Functions & Devices (minus DDC)}
; -------------------------- Properties
SlutsMCM Property mcm Auto
SlutsData Property data Auto
Actor Property PlayerRef Auto
; -------------------------- Devious Devices
zadLibs Property Lib0 Auto
zadxLibs Property Lib1 Auto
zadxLibs2 Property Lib2 Auto
Keyword Property SlutsRestraints Auto
{Quest Item Token}
Keyword[] Property Dev_Key Auto
{zad_Devious -keywords}
; -------------------------- PonyGear
Armor[] Property storedGear Auto
{Gear the Player will wear on Hauls}
int Property colorIndex = 0 Auto Hidden
{Black = 0 // Blue = 1 // Pink = 2 // Red = 3 // White = 4}
; -------- Leveled Base Gear
Formlist Property fillyGag Auto
{reinforceLv * 5 + Color}
Formlist Property fillyMittens Auto
{reinforceLv * 5 + Color}
Formlist Property fillyBoots Auto
{reinforceLv * 5 + Color}
; -------- Misc Base
FormList Property fillyYokes Auto
{STATIC ||| Default = 0 // Breast Yoke = 1 // Default (Chained) = 2 //
Armbinder(Black) = 3 // Armbinder(Red) = 4 // Armbinder(White) = 5 //
Hand-Cuffs = 6}
Formlist Property fillyTails Auto
{STATIC ||| None = 0 // Basic = 1 // Lush = 2 // Braided = 3 //
Braided Bow = 4 // Chain(Bell) = 5 // Chain(Sign) = 6}
Formlist Property fillyArmCuff Auto
{STATIC ||| 0 = No Combat, 1 = Combat}
Formlist Property fillyLegCuff Auto
{STATIC ||| 0 = No Pony Anim, 1 = Pony Anim}
Formlist Property fillyCollar Auto
{STATIC ||| 0 = Steel}
; -------- Addiotional Gear
Formlist Property fillyBlindfold Auto
{reinforceLv * 5 + Color}
Formlist Property fillyChastity Auto
{0 - Generic // 1 - BlockGeneric // 2 - Quest Item}
; -------- NON-DD's
Armor[] Property ThermalHarness Auto
{STATIC ||| colorIndex}
; -------- Humil Gear
Armor[] Property BalletBoots_I Auto
Armor[] Property BalletBoots_R Auto
Armor[] Property HobbleDresses_I Auto
Armor[] Property HobbleDresses_R Auto
Armor[] Property Piercings_I Auto
Armor[] Property Piercings_R Auto
; -------- ArmorReg
FormList[] Property ArmorReg Auto
{Gags = 0 // Boots = 1 // Mittens = 2 // Blindfold = 3}
; -------------------------- Variables
;Device Index:
int	property gagIDX = 0 AutoReadOnly Hidden
int	property collarIDX = 1 AutoReadOnly Hidden
int	property yokeIDX = 2 AutoReadOnly Hidden
int	property glovesIDX = 3 AutoReadOnly Hidden
int	property armCuffIDX = 4 AutoReadOnly Hidden
int	property legCuffIDX = 5 AutoReadOnly Hidden
int	property bootsIDX = 6 AutoReadOnly Hidden
int	property tailIDX = 7 AutoReadOnly Hidden
int	property harnessIDX = 8 AutoReadOnly Hidden
int	property blindfoldIDX = 9 AutoReadOnly Hidden
int	property chastityIDX = 10 AutoReadOnly Hidden
; Stored Armor Pieces
Armor[] Property Dev_Backup_I Auto
; -------------------------- Code

Function equip(actor target, armor toEq)
	Lib0.LockDevice(target, toEq)
EndFunction
; ================================= GENERIC, PLAYER ONLY ===========
function EquipIdx(int idx, bool force = false)
	armor device = storedGear[idx]
	If(!device)
		Debug.MessageBox("There was an Error equipping a device on the Player; Device Code: " + idx)
	EndIf
	Keyword kw = Dev_Key[idx]
	;Reserve costume to prevent removal errors if the player decides to alter their MCM custom costume mid delivery.
  Dev_Backup_I[idx] = device
	bool swap = false
	If(Force && PlayerRef.WornHasKeyword(kw))
		armor devI = Lib0.GetWornDevice(PlayerRef, kw)
		If(!devI.HasKeyword(SlutsRestraints))
			; Only unequip if its not already a Slut Item
			; armor devR = Lib0.GetRenderedDevice(devI)
			; Lib0.RemoveDevice(target, devI, devR, kw)
			swap = true
		EndIf
	EndIf
	Lib0.LockDevice(PlayerRef, device, swap)
endfunction

function RemoveIdx(int idx, bool QuestItm = false)
	;Remove the reserved version, not the one set in sluts_mission_scenes_data
	Armor dev_i = Dev_Backup_I[idx]
	If(!dev_i)
		Debug.Trace("dev_i on Slot " + idx + " is empty.")
		return
	ElseIf(!PlayerRef.IsEquipped(dev_i))
		Debug.Trace("Call for Removal of Slot " + idx + " but Item isnt worn.")
		return
	EndIf
	Keyword kw = Dev_Key[idx]
	If(QuestItm)
		; This should ideally only be called by UndressPony() after a Haul
		armor dev_r = Lib0.GetRenderedDevice(dev_I)
		Lib0.RemoveQuestDevice(PlayerRef, dev_i, dev_r, kw, SlutsRestraints)
		Utility.Wait(0.1)
		PlayerRef.RemoveItem(dev_i, 1, true)
	else
		Lib0.UnlockDevice(PlayerRef, dev_i, none, kw, true) ; dev_r, kw, true)
	EndIf
endfunction
; /;

; ================================= SET GEAR ===========
Function setLeveledGear()
	storedGear[gagIDX] = fillyGag.GetAt(data.uniformReinforceLvGag * 5 + colorIndex) as Armor
	storedGear[glovesIDX] = fillyMittens.GetAt(data.uniformReinforceLvGloves * 5 + colorIndex) as Armor
	storedGear[bootsIDX] = fillyBoots.GetAt(data.uniformReinforceLvBoots * 5 + colorIndex) as Armor
	storedGear[blindfoldIDX] = fillyBlindfold.GetAt(data.uniformReinforceLvBlindfold * 5 + colorIndex) as Armor
	storedGear[chastityIDX] = fillyChastity.GetAt(data.uniformReinforceLvChastity) as Armor
EndFunction

Function setColor(int color)
	colorIndex = color
	setLeveledGear()
	setThermal(color)
EndFunction

Function setYoke(int index)
	storedGear[yokeIDX] = fillyYokes.GetAt(index) as Armor
EndFunction

Function setTail(int index)
	storedGear[tailIDX] = fillyTails.GetAt(index - 1) as Armor
EndFunction

Function setCuffsLeg(int index)
	storedGear[legCuffIDX] = fillyLegCuff.GetAt(index) as Armor
EndFunction

Function setCuffsArm(int index)
	storedGear[armCuffIDX] = fillyArmCuff.GetAt(index) as Armor
EndFunction

Function setThermal(int index)
	If(MCM.bThermalColor)
		storedGear[harnessIDX] = ThermalHarness[index]
	else
		storedGear[harnessIDX] = ThermalHarness[0]
	EndIf
EndFunction

; /;

; ============================== FIT + REMOVE GILLY GEAR ===========
Function DressUpPony(Actor target, bool yoke = true)
	If(target == PlayerRef)
		If(MCM.bUseThermal)
			equipIdx(harnessIDX, true)
			Utility.Wait(0.05)
		EndIf
		EquipIdx(collarIDX, true)
		Utility.Wait(0.05)
		EquipIdx(legCuffIDX, true)
		Utility.Wait(0.05)
		EquipIdx(glovesIDX, true)
		Utility.Wait(0.05)
		EquipIdx(bootsIDX, true)
		Utility.Wait(0.05)
		EquipIdx(tailIDX, true)
		Utility.Wait(0.05)
		EquipIdx(armCuffIDX, true)
		Utility.Wait(0.05)
		If(yoke == true)
			EquipIdx(yokeIDX, true)
			Utility.Wait(0.05)
		EndIf
		If(data.useBlindfold)
			EquipIdx(blindfoldIDX, true)
			Utility.Wait(0.05)
		EndIf
		If(data.useChastity)
			EquipIdx(chastityIDX, true)
			Utility.Wait(0.05)
		EndIf
	Else
		; TODO: NPC Dressup
	EndIf
	mcm.tatLib.ApplyTats(PlayerRef)
EndFunction

Function UndressPony(Actor target, bool removeTats = false)
	If(target == PlayerRef)
		RemoveIdx(gagIDX, true)
		Utility.Wait(0.2)
		RemoveIdx(collarIDX, true)
		Utility.Wait(0.2)
		RemoveIdx(legCuffIDX, true)
		Utility.Wait(0.2)
		RemoveIdx(armCuffIDX, true)
		Utility.Wait(0.2)
		RemoveIdx(yokeIDX, true)
		Utility.Wait(0.2)
		RemoveIdx(glovesIDX, true)
		Utility.Wait(0.2)
		RemoveIdx(bootsIDX, true)
		Utility.Wait(0.2)
		RemoveIdx(tailIDX, true)
		Utility.Wait(0.2)
		If(Dev_Backup_I[harnessIDX])
			RemoveIdx(harnessIDX, true)
			Utility.Wait(0.05)
		EndIf
		If(Dev_Backup_I[blindfoldIDX])
			RemoveIdx(blindfoldIDX, true)
			Utility.Wait(0.2)
		EndIf
		If(Dev_Backup_I[chastityIDX])
			RemoveIdx(chastityIDX, true)
			Utility.Wait(0.2)
		EndIf
		Dev_Backup_I = new Armor[11]
	else
		; TODO: NPC unequip Function here
	EndIf
	If(removeTats)
		mcm.tatLib.scrub(target)
	EndIf
endFunction

; -------------------------- HumiliationScene
Function DDModel(int humilPick)
	;1 - Boots, 2 - NOPE (Hobble), 3 - Piercings
	If(humilPick == 1)
		; If(PlayerRef.WornHasKeyword(Dev_Key[6]))
		; 	armor devI = Lib0.GetWornDevice(PlayerRef, Dev_Key[6])
		; 	armor devR = Lib0.GetRenderedDevice(devI)
		; 	Lib0.RemoveDevice(PlayerRef, devI, devR, Dev_Key[6])
		; EndIf
		int Colour = Utility.RandomInt(0, 1)
		Lib0.LockDevice(PlayerRef, BalletBoots_I[Colour], true) ; BalletBoots_R[Colour], Dev_Key[6])
	ElseIf(humilPick == 2)
		; If(PlayerRef.WornHasKeyword(Lib0.zad_DeviousSuit))
		; 	armor devI = Lib0.GetWornDevice(PlayerRef, Lib0.zad_DeviousSuit)
		; 	armor devR = Lib0.GetRenderedDevice(devI)
		; 	Lib0.RemoveDevice(PlayerRef, devI, devR, Lib0.zad_DeviousSuit)
		; EndIf
		int Model = Utility.RandomInt(0, 3)
		Lib0.LockDevice(PlayerRef, HobbleDresses_I[Model], true) ; HobbleDresses_R[Model], Lib0.zad_DeviousPiercingsNipple)
	ElseIf(humilPick == 3)
		; If(PlayerRef.WornHasKeyword(Lib0.zad_DeviousPiercingsNipple))
		; 	armor devI = Lib0.GetWornDevice(PlayerRef, Lib0.zad_DeviousPiercingsNipple)
		; 	armor devR = Lib0.GetRenderedDevice(devI)
		; 	Lib0.RemoveDevice(PlayerRef, devI, devR, Lib0.zad_DeviousPiercingsNipple)
		; EndIf
		int Model = Utility.RandomInt(0, 2)
		Lib0.LockDevice(PlayerRef, Piercings_I[Model], true) ; Piercings_R[Model], Lib0.zad_DeviousPiercingsNipple)
	EndIf
endFunction

; -------------------------- Utility
Function RemoveConflictingDevice(int idx)
	Keyword kw = Dev_Key[idx]
	armor devI = Lib0.GetWornDevice(PlayerRef, kw)
	; armor devR = Lib0.GetRenderedDevice(devI)
	Lib0.UnlockDevice(PlayerRef, devI, none, kw)
endFunction

Function Regag(Actor target = none)
	equipIdx(gagIDX)
endfunction

Function Ungag(Actor target = none)
	RemoveIdx(gagIDX, true)
endFunction

Armor Function getRandomArmorReg(Actor toCheck)
	int[] tmp = new int[4]
	bool cutCoins = false
	If(toCheck.WornHasKeyword(Lib0.zad_DeviousGag))
		tmp[0] = -1
	EndIf
	If(toCheck.WornHasKeyword(Lib0.zad_DeviousGag))
		tmp[1] = -1
	else
		tmp[1] = 1
	EndIf
	If(toCheck.WornHasKeyword(Lib0.zad_DeviousGag))
		tmp[2] = -1
	else
		tmp[2] = 2
	EndIf
	If(toCheck.WornHasKeyword(Lib0.zad_DeviousGag))
		tmp[3] = -1
	else
		tmp[3] = 3
	EndIf
	If(PapyrusUtil.CountInt(tmp, -1) == 4)
		return none
	else
		tmp = PapyrusUtil.RemoveInt(tmp, -1)
		int myList = Utility.RandomInt(0, tmp.length - 1)
		return ArmorReg[myList].GetAt(Utility.RandomInt(0, ArmorReg[myList].GetSize() - 1)) as Armor
	EndIf
EndFunction
