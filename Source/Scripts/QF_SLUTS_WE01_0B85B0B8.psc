;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 16
Scriptname QF_SLUTS_WE01_0B85B0B8 Extends Quest Hidden

;BEGIN ALIAS PROPERTY myHoldSons
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_myHoldSons Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MissionKart
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MissionKart Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TravelMarker2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TravelMarker2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_myHoldLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BanditCamp
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_BanditCamp Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneMarker1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneMarker1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bandit1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bandit1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Boss
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Boss Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneMarker2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneMarker2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TravelMarker1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TravelMarker1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SceneMarker3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneMarker3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TRIGGER
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TRIGGER Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bandit2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bandit2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldImperial
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_myHoldImperial Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldContested
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_myHoldContested Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE WEScript
Quest __temp = self as Quest
WEScript kmyQuest = __temp as WEScript
;END AUTOCAST
;BEGIN CODE
; debug.trace(self + "stage 0")
kmyQuest.Num1 = 0
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN AUTOCAST TYPE WEScript
Quest __temp = self as Quest
WEScript kmyQuest = __temp as WEScript
;END AUTOCAST
;BEGIN CODE
; player moved
kmyQuest.SceneA.Stop()
SceneHelperA.ForceStart()

SetStage(200)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
; Seductive Scene
Actor pl = Game.GetPlayer()
int r = Utility.RandomInt(0, 2)
Actor a = Alias_Boss.GetActorRef()
Actor b = none
Actor c = none
If (r > 0)
b = Alias_Bandit1.GetActorRef()
EndIf
If (r > 1)
c = Alias_Bandit2.GetActorRef()
EndIf

SlutsAnimation.StartQuick(pl, a, b, c, asHook = "SlutsWE01")
RegisterForModEvent("HookAnimationEnd_SlutsWE01", "AnimationEnd")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN AUTOCAST TYPE WEScript
Quest __temp = self as Quest
WEScript kmyQuest = __temp as WEScript
;END AUTOCAST
;BEGIN CODE
; Combat
kmyQuest.makeAliasAggressiveAndAttackPlayer(Alias_Boss)
kmyQuest.makeAliasAggressiveAndAttackPlayer(Alias_Bandit1)
kmyQuest.makeAliasAggressiveAndAttackPlayer(Alias_Bandit2)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN AUTOCAST TYPE WEScript
Quest __temp = self as Quest
WEScript kmyQuest = __temp as WEScript
;END AUTOCAST
;BEGIN CODE
; debug.trace(self + "stage 255, calling ReArmTrigger() on trigger" + Alias_Trigger.GetReference())
(Alias_Trigger.GetReference() as WETriggerScript).ReArmTrigger()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN AUTOCAST TYPE WEScript
Quest __temp = self as Quest
WEScript kmyQuest = __temp as WEScript
;END AUTOCAST
;BEGIN CODE
; Event done, let the bandits continue pathing or w/e
kmyQuest.SceneB.ForceStart()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN AUTOCAST TYPE WEScript
Quest __temp = self as Quest
WEScript kmyQuest = __temp as WEScript
;END AUTOCAST
;BEGIN CODE
; Robbing scene, player shall not move whilst being robbed
kmyQuest.SceneA.ForceStart()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
; Nonconsent Scene
Actor pl = Game.GetPlayer()
int r = Utility.RandomInt(0, 2)
Actor a = Alias_Boss.GetActorRef()
Actor b = none
Actor c = none
If (r > 0)
b = Alias_Bandit1.GetActorRef()
EndIf
If (r > 1)
c = Alias_Bandit2.GetActorRef()
EndIf

RegisterForModEvent("HookAnimationEnd_SlutsWE01", "AnimationEnd")
If (!SlutsAnimation.StartQuick(pl, a, b, c, akV = pl, asHook = "SlutsWE01"))
  Debug.Notification("Failed to start scene")
  SetStage(250)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
; Select bad end outcome here..
Actor bossref = Alias_Boss.GetActorRef()
bossref.EvaluatePackage()

FadeToBlackImod.Apply()
Utility.Wait(2.0)
FadeToBlackImod.PopTo(FadeToBlackHoldImod)
Utility.Wait(0.4)
int max = 1
If (Game.GetModByName("SimpleSlavery.esp") != 255)
  max += 1
EndIf
int r = Utility.RandomInt(0, max)
If (r == 0)
  MsgPlunder.Show()
  float FLT_MAX = 3.4 * Math.pow(10, 38)
  mission.UpdatePilferage(FLT_MAX)
  Alias_Boss.TryToDisableNoWait()
  Alias_Bandit2.TryToDisableNoWait()
  Alias_Bandit1.TryToDisableNoWait()
  Stop()
  Utility.Wait(1.0)
ElseIf (r == 1)
  MsgAssault.Show()
  Actor pl = Game.GetPlayer()
  int s = Utility.RandomInt(0, 2)
  Actor a = bossref
  Actor b = none
  Actor c = none
  If (s > 0)
  b = Alias_Bandit1.GetActorRef()
  EndIf
  If (s > 1)
  c = Alias_Bandit2.GetActorRef()
  EndIf
  mission.UpdatePilferage(mission.Pilferage + mission.PilferageThresh02.Value)

  RegisterForModEvent("HookAnimationEnd_SlutsWE01Alt", "AnimationEndAlt")
  If (!SlutsAnimation.StartQuick(pl, a, b, c, akV = pl, asHook = "SlutsWE01Alt"))
    Debug.Notification("Failed to start scene")
    SetStage(250)
  EndIf
  Utility.Wait(0.1)
Else
  MsgKidnap.Show()
  SendModEvent("SSLV Entry")
  Stop()
EndIf
FadeToBlackHoldImod.PopTo(FadeToBlackbackImod)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event AnimationEnd(int tid, bool HasPlayer)
SetStage(250)
EndEvent

Event AnimationEndAlt(int tid, bool HasPlayer)
SetStage(60)
EndEvent

Scene Property SceneHelperA  Auto  

Message Property MsgPlunder  Auto  

Message Property MsgAssault  Auto  

Message Property MsgKidnap  Auto  

ImageSpaceModifier Property FadeToBlackImod  Auto  

ImageSpaceModifier Property FadeToBlackHoldImod  Auto  

ImageSpaceModifier Property FadeToBlackBackImod  Auto  

SlutsMissionHaul Property mission  Auto  
