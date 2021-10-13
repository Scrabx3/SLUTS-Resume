Scriptname SlutsTats extends Quest

; ---------------------------------- Import
import debug
import SlaveTats
; ---------------------------------- Property
SlutsMCM property mcm auto
actor property PlayerRef auto
; ---------------------------------- Variables
string property pool = "SLUTS Tat Pool" autoreadonly hidden
string tat_name = ""
int tat_color = 0
; ---------------------------------- Code
int Function ApplyTats(Actor me)
	Trace("SLUTS: Applying Tats")
	If(!MCM.bUseSlutsLivery)
		return 0
	EndIf
	If(!me)
		me = PlayerRef
	EndIf
	;	get some retained objects to hold the template and result list
	int template = JValue.addToPool(JMap.object(), pool)
	int matches = JValue.addToPool(JArray.object(), pool)
	; Check to ensure that Tats dont get mixed up with each other if the player is currently worn some SLUTS Tats(?)
	remove_livery(me)
	JMap.setStr(template, "section", "SLUTS")
	JMap.setStr(template, "name", GetTatName())
	;	query
	if SlaveTats.query_available_tattoos(template, matches)
		trace("sluts: Error looking up livery tattoo")
		JValue.cleanPool(pool)
		return 1
	endif
	int num = JArray.count(matches)
	if num == 0
		trace("sluts: no matching tats found")
		JValue.cleanPool(pool)
		return 1
	endif
	trace("sluts_tats: " + num + " matching tats found")
	int tattoo = JValue.addtopool(JArray.getObj(matches, 0), pool)
	JMap.SetInt(tattoo, "locked", 1)
	JMap.setStr(tattoo, "subsystem", "livery")
	JMap.SetInt(tattoo, "color", tat_color)
	if SlaveTats.add_tattoo(me, tattoo)
		trace("sluts: failed for livery")
		return 1
	endif
	if SlaveTats.synchronize_tattoos(me)
		messagebox("Synchronization failed")
		JValue.cleanPool(pool)
		return 1
	endif
	JValue.cleanPool(pool)
	return 0
EndFunction

string Function GetTatName()
	if !mcm.bUseSlutsLivery
		return ""
	endif
	trace("SLUTS: mcm.bUseSlutsColors = " + mcm.bUseSlutsColors)
	trace("SLUTS: mcm.iCustomLiveryColor = " + mcm.iCustomLiveryColor)
	if mcm.bUseUNPLivery && mcm.bUseSlutsColors
		tat_color = 0
		return "Livery, Green (UNP)"
	elseif mcm.bUseSlutsColors
		tat_color = 0
		return "Livery, Green (CBBE)"
	elseif mcm.bUseUNPLivery
		tat_color = mcm.iCustomLiveryColor
		return "Livery, Colorable (UNP)"
	else
		tat_color = mcm.iCustomLiveryColor
		return "Livery, Colorable (CBBE)"
	endif
EndFunction

; -------------------------------- Old Code
function get_name_and_color()
	;	right - we should be livery free. If the player has opted out of the livery system
	;	this becomes a good place to go home
		if !mcm.bUseSlutsLivery
		return
	endif
	;	next is the UNP variant - we only have one of these at the moment and that half done
	;	so choosing UNP effectively locks out the remaining options.
	trace("sluts_tats: mcm.bUseSlutsColors = " + mcm.bUseSlutsColors)
	trace("sluts_tats: mcm.iCustomLiveryColor = " + mcm.iCustomLiveryColor)
	if mcm.bUseUNPLivery && mcm.bUseSlutsColors
		tat_name = "Livery, Green (UNP)"
	elseif mcm.bUseSlutsColors
		tat_name = "Livery, Green (CBBE)"
	elseif mcm.bUseUNPLivery
		tat_name = "Livery, Colorable (UNP)"
		tat_color = mcm.iCustomLiveryColor
	else
		tat_name = "Livery, Colorable (CBBE)"
		tat_color = mcm.iCustomLiveryColor
	endif
endfunction

int function livery_on(actor target=none)
	;	default to tatting the player
	if target == none
		target = PlayerRef
	endif
	get_name_and_color()
	livery_on_x(target)
	if SlaveTats.synchronize_tattoos(target)
		messagebox("Synchronization failed")
		return 1
	endif
	JValue.cleanPool(pool)
	return 0
endfunction

int function get_applied_livery_items(actor whom)
	int tmpl_clear = JValue.addToPool(JMap.object(), pool)
	int v_clear = JValue.addToPool(JArray.object(), pool)
	;	before we can apply the new tat, we need to scrub the old one
	;	we can template that on the "subsystem" keyword we're going to add
	;	this way we can have variant livery designs and get them all with one query
	;	and if someone changes their body model or mcm settings, we can adapt
	JMap.setStr(tmpl_clear, "section", "SLUTS")
	JMap.setStr(tmpl_clear, "subsystem", "livery")
	;	now query the applied tats
	if SlaveTats.query_applied_tattoos(whom, tmpl_clear, v_clear)
		trace("sluts: Error looking for subsystem tattoos")
		return 1
	endif
	return tmpl_clear
endfunction

;Plastic latency
bool function scrub(actor whom)
	int template = JValue.addToPool(JMap.object(), pool)
	JMap.setStr(template, "section", "SLUTS")
	if remove_tattoos(whom, template, true, true)
		trace("sluts_tats: error removing 'S.L.U.T.S' tattoos")
	endif
	JMap.setStr(template, "section", "Dirty SLUTS")
	if remove_tattoos(whom, template, true, true)
		trace("sluts_tats: error removing 'S.L.U.T.S' tattoos")
	endif
	if SlaveTats.synchronize_tattoos(whom)
		trace("sluts: Synchronization failed")
	endif
	JValue.cleanPool(pool)
	return true
endfunction

function remove_livery(actor whom)
	trace("sluts: removing livery")
	;	the same tat can be applied multiple times.
	;	let's clear all the slots
	int v_clear = get_applied_livery_items(whom)
	int limit = JArray.count(v_clear)
	int idx = 0
	trace("sluts: removing "+limit+" tats")
	while idx < limit
		idx += 1
		int temp = JValue.addToPool(JArray.getObj(v_clear, idx), pool)
		if remove_tattoos(whom, temp, true, true)
			trace("sluts_tats: error removing subsystem tattoo at index " + idx)
		else
			trace("sluts: removing tat  "+ idx +" of "+limit+"")
		endif
	endwhile
endfunction

int function livery_on_x(actor target=none)
	trace("sluts: livery_on_x: non-proto version")
	int tattoo = 0
	;	default to tatting the player
	if target == none
		target = PlayerRef
	endif
	;	get some retained objects to hold the template and result list
	int template = JValue.addToPool(JMap.object(), pool)
	int matches = JValue.addToPool(JArray.object(), pool)
	remove_livery(target)
	;	right - we should be livery free. If the player has opted out of the livery system
	;	this becomes a good place to go home
	if !mcm.bUseSlutsLivery
		return 0
	endif
	;	now we can apply some tattoos
	;	get the prototype
	JMap.setStr(template, "name", tat_name)
	JMap.setStr(template, "section", "SLUTS")
	trace("sluts: searching for livery: " + tat_name)
	;	query
	if SlaveTats.query_available_tattoos(template, matches)
		trace("sluts: Error looking up livery tattoo")
		return 1
	endif
	int num = JArray.count(matches)
	if num == 0
		trace("sluts: no matching tats found")
		return 1
	endif
	trace("sluts_tats: "+num+" matching tats found")
	tattoo = JValue.addtopool(JArray.getObj(matches, 0), pool)
	JMap.SetInt(tattoo, "locked", 1)
	JMap.setStr(tattoo, "subsystem", "livery")
	JMap.SetInt(tattoo, "color", tat_color)
	if SlaveTats.add_tattoo(target, tattoo)
		trace("sluts: failed for livery")
		return 1
	endif
	return 0
endfunction

function livery_off(actor target=none)
	if target == none
		target = PlayerRef
	endif
	remove_livery(target)
	if SlaveTats.synchronize_tattoos(target)
		trace("sluts: Synchronization failed")
	endif
	JValue.cleanPool(pool)
endfunction

function set_dirty_level(Actor target, int level)
	;	change the tats
	set_dirty_inner(target, level)
	;	sync the changes
	trace("sluts_tats: syncing on " + target.getdisplayname())
	if synchronize_tattoos(target, silent=true)
		trace("sluts_tats: problem syncing tats")
	endif
	;	clean up
	JValue.cleanPool(pool)
endfunction

function set_dirty_inner(Actor target, int level)
;	clear any already applied
	trace("sluts_tats: clearing tats")
	clean_dirt(target)
;	should now be clean - zero means stay that way
	if level == 0
		trace("sluts_tats: level zero dirt - returning")
		return
	endif
;	apply new dirt level
	trace("sluts_tats: applying level "+level+" dirt to "+ target)
	apply_dirt(target, level)
endfunction

function clean_dirt(actor target)
	int template = JValue.addToPool(JMap.object(), pool)
;	get a templater for anything applied in the "dirt" subsystem
;	this will get any dirt or handprint tats from all four areas
;	better restrict it to our section as well
;	just in case someone adopts the same system (unlikely, but you know...)
	JMap.setStr(template, "section", "Dirty SLUTS")
	JMap.setStr(template, "subsystem", "dirt")
;	do the removal
	SlaveTats.remove_tattoos(target, template, ignore_lock = True, silent = True)
endfunction

function apply_dirt(actor target, int level)
	int matches = JValue.addToPool(JArray.object(), pool)
;	set up a template for all the dirt tats at this level
	int template = JValue.addToPool(JMap.object(), pool)
	JMap.setInt(template, "level", level)
	JMap.setStr(template, "section", "Dirty SLUTS")
	JMap.setStr(template, "subsystem", "dirt")
;	get all the matching tattoos
	if query_available_tattoos(template, matches)
		return
	endif
;	If we don't find any it's a problem
	int limit = JArray.count(matches)
	if limit == 0
		trace("sluts_tat: no dirt tats found!")
		return
	endif
	trace("sluts_tat: "+limit+" dirt tats found!")
;	loop over the tats we found and apply them
	int idx = 0
	while idx < limit
		int tat = JValue.addToPool(JArray.getObj(matches, idx), pool)
		idx += 1
		trace("sluts_tat: applying "+idx+" dirt tat!")
		if JMap.getInt(tat, "clear", 0)
			trace("sluts_tat: dirt tat has clear flag - skipping")
		elseif add_tattoo(target, tat, -1, false, true)
			trace("sluts_tat: problem applying tat " + idx)
		endif
	endwhile
endfunction
