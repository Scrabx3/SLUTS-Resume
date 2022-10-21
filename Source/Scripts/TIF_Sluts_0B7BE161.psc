;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF_Sluts_0B7BE161 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor player = Game.GetPlayer()
string tags = ""
if (player.GetActorBase().GetSex() == 1)
  tags += "vaginal"
endif
SlutsAnimation.QuickStartAnimation(player, akSpeaker, asHook = "SLUTS_BlackMailSex", asTags = tags)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
