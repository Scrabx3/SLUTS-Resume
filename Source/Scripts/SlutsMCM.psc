Scriptname SlutsMCM extends SKI_ConfigBase Conditional

; ---------------------------------- Properties
SlutsMain Property main Auto
SlutsData Property data Auto
SlutsMissionHaul Property missionSc Auto
SlutsTats property tatlib auto
SlutsBondage Property bd Auto

Actor Property PlayerRef Auto
; ---------------------------------- Variables
string[] difficulty
; Settings
int Property iHaulType01 = 50 Auto Hidden
{Default Haul, with the buggy cart}
int Property iHaulType02 = 0 Auto Hidden
{Premium Haul, special Delivery to a random NPC}
int[] Property HaulWeights
	{All Haul Types wrapped together in a single array}
	int[] Function Get()
		int[] ret = new int[2]
		ret[0] = iHaulType01
		ret[1] = iHaulType02
		return ret
	EndFunction
EndProperty
bool Property bNoTalking = true Auto Hidden Conditional
{Custom Gag Talk during Hauls}
int Property iSpontFail = 0 Auto Hidden
{Chance to randomly fail a perfect run}
bool Property bSpontFailRandom = true Auto Hidden
bool property tag_cart = false auto Hidden Conditional
{When set the sluts cart will have a quest marker on it - unused}
int Property iRehabtRate = 1 Auto Hidden
{Difficulty Scale for Rehab System}
float property fBaseCredit = 2.0 auto Hidden Conditional
float Property fOvertimeGrowth = 2.0 Auto Hidden
bool Property bAllDebtToArrears = false Auto Hidden
{Should the mod rob your Escrow before stacking Debt?}
int Property iMinGold = 50 Auto Hidden
{If above option = false, this much Gold will stay in your Escrow}
int Property iChancePilf = 50 Auto Hidden
bool Property bPilfChanceIncr = true Auto Hidden
int Property iMaxPilferage = 750 Auto Hidden
int Property iSSminDebt = 2 Auto Hidden
; Customisation
; string[] Property costumeList Auto Hidden
; int Property costumeIndex = 0 Auto Hidden
; string[] Property tailList Auto Hidden
; int Property tailsIndex = 2 Auto Hidden
; string[] Property yokesList Auto Hidden
; int Property yokesIndex = 0 Auto Hidden
bool property bUseThermal = false auto Hidden
bool property bThermalColor = true Auto Hidden
bool bPonyAnims = true
bool bBoundCombat = false
;SlaveTats
bool property bUseSlutsLivery = true auto Hidden Conditional
bool property bUseSlutsColors = true auto Hidden Conditional
int property iCustomLiveryColor = 0 auto Hidden
bool Property bUseDirt = true Auto Hidden Conditional
;Debug
bool Property bLargeMsg = false Auto Hidden
bool Property bNoRemoveItems = false Auto Hidden
bool Property bStruggle = true Auto Hidden
string sTatRemove = "Click"
string sUnponify = "Click"
string sReturnCart = "Click"
string sReinitMod = "Click"
; bool property bSetEssential = false auto Hidden
bool Property bShowDist = false Auto Hidden

bool property bUseUNPLivery = false auto Hidden Conditional ; Unused
; ---------------------------------- Code
bool Property bCooldown = false Auto Hidden Conditional
Function Cooldown()
	bCooldown = true
	Utility.Wait(30)
	bCooldown = false
EndFunction

int Function GetVersion()
	return 1
endFunction

Function Initialize()
	Pages = new string[3]
	Pages[0] = "$SLUTS_pSettings"
	Pages[1] = "$SLUTS_pCustomisation"
	Pages[2] = "$SLUTS_pDebug"

	difficulty = new string[4]
	difficulty[0] = "$SLUTS_difficulty0"
	difficulty[1] = "$SLUTS_difficulty1"
	difficulty[2] = "$SLUTS_difficulty2"
	difficulty[3] = "$SLUTS_difficulty3"
endFunction

; ==================================
; 							MENU
; ==================================
Event OnConfigInit()
	Initialize()
endEvent

Event OnPageReset(string Page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	if(Page == "")
		LoadCustomContent("sluts/logo.dds", 186, 33)
		return
	else
		UnloadCustomContent()
	endIf
	If(Page == "$SLUTS_pSettings")
		; AddHeaderOption("$SLUTS_sHaulTypes")
		; AddSliderOptionST("defaultHaul", "$SLUTS_defHaul", iHaulType01)
		; AddSliderOptionST("premiumHaul", "$SLUTS_premHaul", iHaulType02)
		AddHeaderOption("$SLUTS_shHauls")
		AddToggleOptionST("NoTalking", "$SLUTS_sNoTalk", bNoTalking)
		AddSliderOptionST("SpontFail", "$SLUTS_sSpontFail", iSpontFail, "{0}%")
		AddToggleOptionST("SpontFailRandom", "$SLUTS_sSpontFailRnd", bSpontFailRandom)
		AddEmptyOption()
		AddSliderOptionST("PilfChance", "$SLUTS_sPilfChance", iChancePilf)
		AddToggleOptionST("PilfChanceIncr", "$SLUTS_sPilfChanceIncr", bPilfChanceIncr)
		AddSliderOptionST("MaxPilferage", "$SLUTS_sMaxPilferage", iMaxPilferage)
		AddEmptyOption()
		; ============================
		SetCursorPosition(1)
		; ============================
		AddHeaderOption("$SLUTS_shPayment")
		AddSliderOptionST("BaseCredit", "$SLUTS_sBaseCredit", fBaseCredit, "{0}")
		AddSliderOptionST("overtimeGrowth", "$SLUTS_sOvertimeGrowth", fOvertimeGrowth, "{1}")
		AddToggleOptionST("AllDebtToArrears", "$SLUTS_sAllDebtToArrears", bAllDebtToArrears)
		AddSliderOptionST("MinGoldKept", "$SLUTS_sMinGoldKept", iMinGold, getFlag(!bAllDebtToArrears))

		AddHeaderOption("$SLUTS_shCrime")
		AddMenuOptionST("RehabRate", "$SLUTS_sRehabRate", difficulty[iRehabtRate])

		AddHeaderOption(" Simple Slavery")
		AddMenuOptionST("SSdebtScale", "$SLUTS_sSSdebtScale", difficulty[iSSminDebt])
	ElseIf(Page == "$SLUTS_pCustomisation")
		AddHeaderOption("$SLUTS_chLivery")
		; AddMenuOptionST("CostumeChoice", "Costume Color", costumeList[costumeIndex])
		; AddMenuOptionST("TailChoice", "Pony Tail", tailList[tailsIndex])
		; AddMenuOptionST("YokeChoice", "Yoke", yokesList[yokesIndex])
		AddToggleOptionST("UseThermal", "$SLUTS_cUseThermal", bUseThermal)
		AddToggleOptionST("ThermalColor", "$SLUTS_cThermalColor", bThermalColor, getFlag(bUseThermal))
		AddEmptyOption()
		AddToggleOptionST("PonyAnims", "$SLUTS_cPonyAnims", bPonyAnims)
		AddToggleOptionST("BoundCombat", "$SLUTS_cBoundCombat", bBoundCombat)
		SetCursorPosition(1)
		AddHeaderOption(" SlaveTats")
		AddToggleOptionST("UseSlutsLivery", "$SLUTS_cUseSlutsLivery", bUseSlutsLivery)
		; AddToggleOptionST("UseUNPLivery",	"$SLUTS_cUseUNPLivery", bUseUNPLivery)
		AddToggleOptionST("UseSlutsColors", "$SLUTS_cUseSlutsColors", bUseSlutsColors)
		AddColorOptionST("CustomLiveryColor", "$SLUTS_cCustomLiveryColor", iCustomLiveryColor)
		AddEmptyOption()
		AddToggleOptionST("UseDirt", "$SLUTS_cUseDirt", bUseDirt)
	ElseIf(Page == "$SLUTS_pDebug")
		AddHeaderOption("$SLUTS_dhHauls")
		AddToggleOptionST("LargeMsg", "$SLUTS_dLargeMsg", bLargeMsg)
		AddToggleOptionST("NoRemoveItems", "$SLUTS_dNoRemoveItems", bNoRemoveItems)
		AddToggleOptionST("DDStruggle", "$SLUTS_dDDStruggle", bStruggle)
		AddEmptyOption()
		AddHeaderOption(" Debug")
		AddTextOptionST("EmergencyTatRemove", "$SLUTS_dEmergencyTatRemove", sTatRemove)
		AddTextOptionST("RemoveDD", "$SLUTS_removeDD", sUnponify)
		AddTextOptionST("ReturnCart", "$SLUTS_dReturnCart", sReturnCart)
		; AddToggleOptionST("SetEssential", "$SLUTS_dSetEssential", bSetEssential)
		AddEmptyOption()
		; AddToggleOptionST("ShowDistance", "$SLUTS_dShowDistance", bShowDist)
		SetCursorPosition(1)
		AddHeaderOption("$SLUTS_dhHOTKEYS")
		AddTextOptionST("ResetCart", "$SLUTS_dResetCart", "")
		AddTextOptionST("TogglePhysics", "$SLUTS_dTogglePhysics", "")
		; AddTextOptionST("SpawnCart", "CTRL + SHIFT + 8 = Spawn new Cart","")
	EndIf
EndEvent

Event OnConfigClose()
	If(sTatRemove == "Working")
		if(tatlib.scrub(PlayerRef))
			debug.notification("Tattoos Scrubbed")
			sTatRemove = "Click"
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "EmergencyTatRemove")
		endif
	EndIf
	If(sUnponify == "Working")
		Debug.Notification("Removing DD Items..")
		sUnponify = "Click"
		Bd.UndressPony(PlayerRef, true)
		SetOptionFlagsST(OPTION_FLAG_NONE, false, "RemoveDD")
	EndIf
	If(sReturnCart == "Working")
		missionSc.Tether()
		sReturnCart = "Click"
		SetOptionFlagsST(OPTION_FLAG_NONE, false, "ReturnCart")
	EndIf

EndEvent

; ==================================
; 				States // Settings
; ==================================
;Haul Types
State defaultHaul
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iHaulType01)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iHaulType01 = value as int
		SetSliderOptionValueST(iHaulType01)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_defHaul_info")
	EndEvent
EndState

State premiumHaul
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iHaulType02)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iHaulType02 = value as int
		SetSliderOptionValueST(iHaulType02)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_premHaul_info")
	EndEvent
EndState
;Hauls
state NoTalking
	event onselectst()
		bNoTalking = !bNoTalking
		SetToggleOptionValueST(bNoTalking)
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_NoTalking_Info")
	endevent
endstate

State SpontFail
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iSpontFail)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iSpontFail = value as int
		SetSliderOptionValueST(iSpontFail)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_SpontFail_Info")
	EndEvent
EndState

state SpontFailRandom
	event onselectst()
		bSpontFailRandom = !bSpontFailRandom
		SetToggleOptionValueST(bSpontFailRandom)
	endevent
	event ondefaultst()
		bNoTalking = true
		SetToggleOptionValueST(bSpontFailRandom)
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_SpontFailRandom_Info")
	endevent
endstate

state TagCart
	event onselectst()
		tag_cart = !tag_cart
		SetToggleOptionValueST(tag_cart)
	endevent
	event ondefaultst()
		tag_cart = false
		SetToggleOptionValueST(tag_cart)
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_TagCart_Info")
	endevent
endstate

State RehabRate
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(iRehabtRate)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(difficulty)
	EndEvent

	Event OnMenuAcceptST(Int aiIndex)
		iRehabtRate = aiIndex
		SetMenuOptionValueST(difficulty[iRehabtRate])
	EndEvent

	Event OnDefaultST()
		iRehabtRate = 1
		SetMenuOptionValueST(difficulty[iRehabtRate])
	EndEvent

	Event OnHighlightST()
		SetInfoText("$SLUTS_sRehabRate_Highlight")
	EndEvent
EndState
;Payment
State BaseCredit
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fBaseCredit)
		SetSliderDialogDefaultValue(2)
		SetSliderDialogRange(1, 10)
		SetSliderDialogInterval(0.5)
	EndEvent
	Event OnSliderAcceptST(float value)
		fBaseCredit = value
		SetSliderOptionValueST(fBaseCredit, "{0}")
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_BaseCredit_Info")
	EndEvent
EndState

State overtimeGrowth
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fOvertimeGrowth)
		SetSliderDialogDefaultValue(2)
		SetSliderDialogRange(0, 3)
		SetSliderDialogInterval(0.5)
	EndEvent
	Event OnSliderAcceptST(float value)
		fOvertimeGrowth = value
		SetSliderOptionValueST(fOvertimeGrowth)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_overtimeGrowth_Info")
	EndEvent
EndState

state AllDebtToArrears
	event onselectst()
		bAllDebtToArrears = !bAllDebtToArrears
		SetToggleOptionValueST(bAllDebtToArrears)
		If(!bAllDebtToArrears)
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "MinGoldKept")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "MinGoldKept")
		EndIf
	endevent
	event ondefaultst()
		bAllDebtToArrears = false
		SetToggleOptionValueST(bAllDebtToArrears)
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_AllDebtToArrears_Info")
	endevent
endstate

State MinGoldKept
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iMinGold)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 500)
		SetSliderDialogInterval(5)
	EndEvent
	Event OnSliderAcceptST(float value)
		iMinGold = value as int
		SetSliderOptionValueST(iMinGold)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_MinGoldKept_Info")
	EndEvent
EndState

State PilfChance
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iChancePilf)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iChancePilf = value as int
		SetSliderOptionValueST(iChancePilf)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_PilfChance_Info")
	EndEvent
EndState

State PilfChanceIncr
	Event OnSelectST()
		bPilfChanceIncr = !bPilfChanceIncr
		SetToggleOptionValueST(bPilfChanceIncr)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_PilfChanceIncrease_Info")
	EndEvent
EndState

State MaxPilferage
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iMaxPilferage)
		SetSliderDialogDefaultValue(750)
		SetSliderDialogRange(50, 1500)
		SetSliderDialogInterval(50)
	EndEvent
	Event OnSliderAcceptST(float value)
		iMaxPilferage = value as int
		SetSliderOptionValueST(iMaxPilferage)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_MaxPilferage_Info")
	EndEvent
EndState
;Simple Slavery
State SSdebtScale
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(iSSminDebt)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(difficulty)
	EndEvent

	Event OnMenuAcceptST(Int aiIndex)
		iSSminDebt = aiIndex
		SetMenuOptionValueST(difficulty[iSSminDebt])
	EndEvent

	Event OnDefaultST()
		iSSminDebt = 2
		SetMenuOptionValueST(difficulty[iSSminDebt])
	EndEvent

	Event OnHighlightST()
		SetInfoText("$SLUTS_sSSdebtScale_Highlight")
	EndEvent
EndState


; ==================================
; 			States // Customisation
; ==================================
; Livery

; State CostumeChoice
; 	Event OnMenuOpenST()
; 		SetMenuDialogStartIndex(costumeIndex)
; 		SetMenuDialogDefaultIndex(0)
; 		SetMenuDialogOptions(costumeList)
; 	EndEvent
; 	Event OnMenuAcceptST(int index)
; 		costumeIndex = index
; 		SetMenuOptionValueST(costumeList[costumeIndex])
; 		; Bd.SetColor(index*2)
; 	EndEvent
; 	Event OnDefaultST()
; 		costumeIndex = 0
; 		SetMenuOptionValueST(costumeList[costumeIndex])
; 		; Bd.SetColor(0)
; 	EndEvent
; 	Event OnHighlightST()
; 		SetInfoText("Customize your base color theme.")
; 	endEvent
; EndState

; State TailChoice
; 	Event OnMenuOpenST()
; 		SetMenuDialogStartIndex(tailsIndex)
; 		SetMenuDialogDefaultIndex(2)
; 		SetMenuDialogOptions(tailList)
; 	EndEvent
; 	Event OnMenuAcceptST(int index)
; 		tailsIndex = index
; 		SetMenuOptionValueST(tailList[tailsIndex])
; 		Bd.Dev_Inv[7] = form_tails_i.GetAt(tailsIndex) As Armor
; 		; Bd.Dev_Ren[7] = form_tails_s.GetAt(tailsIndex) as Armor
; 	EndEvent
; 	Event OnDefaultST()
; 		tailsIndex = 2
; 		SetMenuOptionValueST(tailList[tailsIndex])
; 		Bd.Dev_Inv[7] = form_tails_i.GetAt(tailsIndex) As Armor
; 		; Bd.Dev_Ren[7] = form_tails_s.GetAt(tailsIndex) as Armor
; 	EndEvent
; 	Event OnHighlightST()
; 		SetInfoText("Customize your ponytail. No not that type of ponytail...")
; 	endEvent
; EndState

; State YokeChoice
; 	Event OnMenuOpenST()
; 		SetMenuDialogStartIndex(yokesIndex)
; 		SetMenuDialogDefaultIndex(0)
; 		SetMenuDialogOptions(yokesList)
; 	EndEvent
; 	Event OnMenuAcceptST(int index)
; 		yokesIndex = index
; 		SetMenuOptionValueST(yokesList[yokesIndex])
; 		Bd.Dev_Inv[2] = form_yoke_i.GetAt(yokesIndex) As Armor
; 		; Bd.Dev_Ren[2] = form_yoke_s.GetAt(yokesIndex) as armor
; 	EndEvent
; 	Event OnDefaultST()
; 		yokesIndex = 0
; 		SetMenuOptionValueST(yokesList[yokesIndex])
; 		Bd.Dev_Inv[2] = form_yoke_i.GetAt(0) As Armor
; 		; Bd.Dev_Ren[2] = form_yoke_s.GetAt(0) as armor
; 	EndEvent
; 	Event OnHighlightST()
; 		SetInfoText("Customize your yoke style.\nIF YOU ARE EXPERENCING CRASHES AFTER THE CART SPELL IS CAST ON YOU TRY THE BREAST OR CHAINLESS DESIGN")
; 	endEvent
; EndState

state UseThermal
	event onselectst()
		bUseThermal = !bUseThermal
		SetToggleOptionValueST(bUseThermal)
	endevent
	event ondefaultst()
		bUseThermal = false
		SetToggleOptionValueST(bUseThermal)
	endevent
	event Onhighlightst()
		SetInfoText("$SLUTS_UseThermal_Info")
	endevent
endstate

State ThermalColor
	Event OnSelectST()
		bThermalColor = !bThermalColor
		SetToggleOptionValueST(bThermalColor)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_ThermalFitColor_Info")
	EndEvent
EndState

state PonyAnims
	event onselectst()
		bPonyAnims = !bPonyAnims
		SetToggleOptionValueST(bPonyAnims)
		Bd.setCuffsLeg(bPonyAnims as int)
	endevent
	event ondefaultst()
		bPonyAnims = true
		SetToggleOptionValueST(bPonyAnims)
		Bd.setCuffsLeg(1)
		; Bd.Dev_Inv[5] = form_misc.GetAt(2) As Armor
		; Bd.Dev_Ren[5] = form_misc.GetAt(3) as armor
	endevent
	event OnHighlightST()
		SetInfoText("$SLUTS_PonyAnims_Info")
	endevent
endstate

state BoundCombat
	event onselectst()
		bBoundCombat = !bBoundCombat
		SetToggleOptionValueST(bBoundCombat)
		Bd.setCuffsArm(bBoundCombat as int)
		; if (!bBoundCombat)
		; 	Bd.Dev_Inv[4] = form_misc.GetAt(0) As Armor
		; 	; Bd.Dev_Ren[4] = form_misc.GetAt(1) As Armor
		; else
		; 	Bd.Dev_Inv[4] = form_misc.GetAt(4) As Armor
		; 	; Bd.Dev_Ren[4] = form_misc.GetAt(5) As Armor
		; endif
	endevent
	event ondefaultst()
		bBoundCombat = false
		SetToggleOptionValueST(bBoundCombat)
		Bd.setCuffsArm(0)
		; Bd.Dev_Inv[4] = form_misc.GetAt(0) As Armor
		; Bd.Dev_Ren[4] = form_misc.GetAt(1) As Armor
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_BoundCombat_Info")
	endevent
endstate
;SlaveTats
state UseSlutsLivery
	event onselectst()
		bUseSlutsLivery = !bUseSlutsLivery
		SetToggleOptionValueST(bUseSlutsLivery)
	endevent
	event ondefaultst()
		bUseSlutsLivery = true
		SetToggleOptionValueST(bUseSlutsLivery)
	endevent
	event onhighlightst()
		SetInfoText("I$SLUTS_UseSlutsLivery_Info")
	endevent
endstate

state UseUNPLivery
	event onselectst()
		bUseUNPLivery = !bUseUNPLivery
		SetToggleOptionValueST(bUseUNPLivery)
	endevent
	event ondefaultst()
		bUseUNPLivery = false
		SetToggleOptionValueST(bUseUNPLivery)
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_UseUNPLivery_Info")
	endevent
endstate

state UseSlutsColors
	event onselectst()
		bUseSlutsColors = !bUseSlutsColors
		SetToggleOptionValueST(bUseSlutsColors)
	endevent
	event ondefaultst()
		bUseSlutsColors = true
		SetToggleOptionValueST(bUseSlutsColors)
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_UseSlutsColors_Info")
	endevent
endstate

state CustomLiveryColor
	event OnColorOpenST()
		SetColorDialogStartColor(iCustomLiveryColor)
	  SetColorDialogDefaultColor(iCustomLiveryColor)
	endEvent
	event OnColorAcceptST(int color)
		iCustomLiveryColor = color
		SetColorOptionValueST(iCustomLiveryColor)
	endEvent
	event OnDefaultST()
		iCustomLiveryColor = 0x0
		SetColorOptionValueST(iCustomLiveryColor)
	endEvent
	event OnHighlightST()
		SetInfoText("$SLUTS_CustomLiveryColor_Info")
	endEvent
endState

State UseDirt
	Event OnSelectST()
		bUseDirt = !bUseDirt
		SetToggleOptionValueST(bUseDirt)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_UseDirt_Info")
	EndEvent
EndState
; ==================================
; 				States // Debug
; ==================================
state LargeMsg
	event onselectst()
		bLargeMsg = !bLargeMsg
		SetToggleOptionValueST(bLargeMsg)
	endevent
	event ondefaultst()
		bLargeMsg = false
		SetToggleOptionValueST(bLargeMsg)
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_LargeMsg_Info")
	endevent

endstate

State NoRemoveItems
	event onselectst()
		bNoRemoveItems = !bNoRemoveItems
		SetToggleOptionValueST(bNoRemoveItems)
	endevent
	event ondefaultst()
		bNoRemoveItems = false
		SetToggleOptionValueST(bNoRemoveItems)
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_NoRemoveItems_Info")
	endevent
endState

State DDStruggle
	Event OnSelectST()
		bStruggle = !bStruggle
		SetToggleOptionValueST(bStruggle)
	EndEvent
	Event OnHighlightST()
		SetInfoText("$SLUTS_DDStruggle_Info")
	EndEvent
EndState
;Debug
state EmergencyTatRemove
	event onselectst()
		sTatRemove = "Working"
		Debug.trace("SLUTS MCM: Attempting to remove SlaveTats")
		SetTextoptionValueST(sTatRemove)
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		Debug.MessageBox("$SLUTS_dEmergencyTatRemove_Msg")
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_dEmergencyTatRemove_Highlight")
	endevent
endstate

State RemoveDD
	Event OnSelectST()
		sUnponify = "Working"
		Debug.trace("SLUTS MCM: Attempting to remove SlaveTats")
		SetTextoptionValueST(sUnponify)
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		Debug.MessageBox("$SLUTS_removeDD_Msg")
	EndEvent

	Event OnHighlightST()
		SetInfoText("$SLUTS_removeDD_Highlight")
	EndEvent
EndState

state ReturnCart
	event onselectst()
		sReturnCart = "Working"
		Debug.Trace("SLUTS MCM: Attempting to force return Cart")
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextoptionValueST(sReturnCart)
		Debug.MessageBox("$SLUTS_dReturnCart_Msg")
	endevent
	event onhighlightst()
		SetInfoText("$SLUTS_dReturnCart_Info")
	endevent
endstate

; state SetEssential
; 	event onselectst()
; 		bSetEssential = !bSetEssential
; 		SetToggleOptionValueST(bSetEssential)
; 	endevent
; 	event ondefaultst()
; 		bSetEssential = false
; 		SetToggleOptionValueST(bSetEssential)
; 	endevent
; 	event onhighlightst()
; 		SetInfoText("$SLUTS_SetEssential_Info")
; 	endevent
; endstate

; State ShowDistance
; 	Event OnSelectST()
; 		bShowDist = !bShowDist
; 		SetToggleOptionValueST(bShowDist)
; 	EndEvent
; 	Event OnHighlightST()
; 		SetInfoText("Get a notification telling you the Distance between your Dispatch & Destination Root. This is number is meaningless for regular play")
; 	EndEvent
; EndState

State ResetCart
	Event OnHighlightST()
		SetInfoText("$SLUTS_ResetCart_Info")
	endEvent
EndState

State TogglePhysics
	Event OnHighlightST()
		SetInfoText("$SLUTS_TogglePhysics_Info")
	endEvent
EndState

State SpawnCart
	Event OnHighlightST()
		SetInfoText("$SLUTS_SpawnCart_Info")
	endEvent
EndState

; ---------------------------------- Utility
int Function getFlag(bool option)
	If(option)
		return OPTION_FLAG_NONE
	else
		return OPTION_FLAG_DISABLED
	EndIf
endFunction
