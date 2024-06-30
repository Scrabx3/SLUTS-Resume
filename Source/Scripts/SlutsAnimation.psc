ScriptName SlutsAnimation Hidden

bool Function StartQuick(Actor ak1, Actor ak2, Actor ak3 = none, Actor ak4 = none, Actor ak5 = none, Actor akV = none, String asTags = "", String asHook = "") global
  return SexLabUtil.QuickStart(ak1, ak2, ak3, ak4, ak5, akV, asHook, asTags)
EndFunction

; returns -1 if all Actors are valid for animating or 0+, reporting the first invalid Actor
int Function ValidateArray(Actor[] akPositions) global
  SexLabFramework SL = SexLabUtil.GetAPI()
  Keyword ActorTypeNPC = Keyword.GetKeyword("ActorTypeNPC")
  String racetag = ""
  int i = 0
  While(i < akPositions.Length)
    If(!SL.IsValidActor(akPositions[i]))
      return i
    ElseIf(!akPositions[i].HasKeyword(ActorTypeNPC))
      String raceID = MiscUtil.GetActorRaceEditorID(akPositions[i])
      If(racetag == "")
        racetag = sslCreatureAnimationSlots.GetRaceKeyByID(raceID)
      ElseIf(sslCreatureAnimationSlots.GetRaceKeyByID(raceID) != racetag)
        return i
      EndIf
    EndIf
    i += 1
  EndWhile
  return -1
EndFunction

; returns -1 on failure, 0+ when a SL Scene started
int Function StartScene(Actor[] akPositions, String tags = "", String tagsexclude = "", bool requirealltags = true, Actor akVictim = none, String hook = "") global
  Debug.Trace("[Sluts] Scene called with Actors " + akPositions + " >> hook = " + hook)
  int v = ValidateArray(akPositions)
  If(v > -1)
    Debug.Trace("[Sluts] Actor at " + v + "(" + akPositions[v] + ") is invalid, aborting")
    return -1
  EndIf
  SexLabFramework SL = SexLabUtil.GetAPI()
  If(!SL.Enabled)
    Debug.Trace("[Sluts] Cannot start Animation. SexLab is currently disabled")
    return -1
  EndIf
  If(akPositions.Length == 2 && akVictim == none && SL.GetGender(akPositions[0]) == 1 && SL.GetGender(akPositions[1]) == 1)
    ; add ff tag if a consent lesbian animation
    If(StringUtil.Find(tags, "ff") == -1)
      tags += "ff"
    EndIf
  EndIf
  sslBaseAnimation[] anims = SL.GetAnimationsByTags(akPositions.Length, tags, tagsexclude, requirealltags)
  return SL.StartSex(akPositions, anims, akVictim, akVictim, true, hook)
EndFunction

int Function StartSceneByActors(Actor[] akPositions, Actor akVictim = none, String hook = "") global
  Debug.Trace("[Sluts] Scene called with Actors " + akPositions + " >> hook = " + hook)
  int v = ValidateArray(akPositions)
  If(v > -1)
    Debug.Trace("[Sluts] Actor " + akPositions[v] + " is invalid, aborting")
    return -1
  EndIf
  SexLabFramework SL = SexLabUtil.GetAPI()
  If(!SL.Enabled)
    Debug.Trace("[Sluts] Cannot start Animation. SexLab is currently disabled")
    return -1
  EndIf
  sslBaseAnimation[] anims = SL.PickAnimationsByActors(akPositions, 64, akVictim == none)
  return SL.StartSex(akPositions, anims, akVictim, akVictim, true, hook)
EndFunction

bool Function QuickStartAnimation(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, Actor akVictim = none, string asHook = "", string asTags = "") global
  return SexLabUtil.QuickStart(Actor1, Actor2, Actor3, Actor4, Actor5, akVictim, asHook, asTags)
EndFunction

Actor[] Function GetSceneActors(int tid) global
  SexLabFramework SL = SexLabUtil.GetAPI()
	sslThreadController Thread = SL.GetController(tid)
  return Thread.Positions
EndFunction

Actor Function GetSceneVictim(int tid) global
  SexLabFramework SL = SexLabUtil.GetAPI()
	sslThreadController Thread = SL.GetController(tid)
  return Thread.VictimRef
EndFunction

String[] Function GetSceneHooks(int tid) global
  SexLabFramework SL = SexLabUtil.GetAPI()
	sslThreadController Thread = SL.GetController(tid)
  return Thread.GetHooks()
EndFunction

; 0 - Male | 1 - Female | -1 Clear Gender
Function ManipulateGender(Actor akActor, int aiGender) global
  SexLabFramework SL = SexLabUtil.GetAPI()
  If(aiGender == -1)
    SL.ClearForcedGender(akActor)
  Else
    SL.TreatAsGender(akActor, aiGender)
  EndIf
EndFunction

bool Function IsActorAnimating(Actor akRef) global
  SexLabFramework SL = SexLabUtil.GetAPI()
  return SL.IsActorActive(akRef)
EndFunction

bool Function StopScene(Actor akRef) global
  SexLabFramework SL = SexLabUtil.GetAPI()
  int tid = SL.FindActorController(akRef)
  if (tid == -1)
    Debug.Trace("[Sluts] Actor = " + akRef + " is not part of any SL Animation.")
    return false
  endif
  sslThreadController controller = SL.GetController(tid)
  if (!controller)
    Debug.Trace("[Sluts] Actor = " + akRef + " is not part of any SL Animation.")
    return false
  endif
  controller.EndAnimation()
  return true
EndFunction

float Function GetArousal(Actor that) global
  return (Quest.GetQuest("sla_Framework") as slaFrameworkScr).GetActorArousal(that)
EndFunction
