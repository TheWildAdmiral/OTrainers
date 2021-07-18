;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname WD03_TIF__03004343 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(self.GetOwningQuest() as OTrainersScript).FollowPlayer(akSpeaker, skill)
TrainingCooldown.SetValue(Utility.GetCurrentGameTime() + 0.25)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

String Property skill Auto  

GlobalVariable Property TrainingCooldown  Auto  
