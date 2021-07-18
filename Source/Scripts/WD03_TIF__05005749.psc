;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname WD03_TIF__05005749 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(self.GetOwningQuest() as OTrainersScript).UnfollowPlayer(akSpeaker)
(self.GetOwningQuest() as OTrainersScript).StartTrainingSession(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

