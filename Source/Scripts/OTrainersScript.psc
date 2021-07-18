Scriptname OTrainersScript extends Quest

; 
;     ██████╗ ████████╗██████╗  █████╗ ██╗███╗   ██╗███████╗██████╗ ███████╗
;    ██╔═══██╗╚══██╔══╝██╔══██╗██╔══██╗██║████╗  ██║██╔════╝██╔══██╗██╔════╝
;    ██║   ██║   ██║   ██████╔╝███████║██║██╔██╗ ██║█████╗  ██████╔╝███████╗
;    ██║   ██║   ██║   ██╔══██╗██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗╚════██║
;    ╚██████╔╝   ██║   ██║  ██║██║  ██║██║██║ ╚████║███████╗██║  ██║███████║
;     ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚══════╝


; ====|| Properties ||====
OSexIntegrationMain Property ostim Auto
Actor Property PlayerRef Auto
ReferenceAlias Property TrainerFollower Auto

; ====|| Variables ||====
String skill          ; A skill that should be trained
Int skillPoints       ; The number of skill points
Bool isTraining       ; Training session flag
Bool trainerOrgasmed  ; Obligatory

; ====|| Functions ||====
Function FollowPlayer(Actor trainer, String skillToLearn)
    
    TrainerFollower.ForceRefTo(trainer)
    trainer.EvaluatePackage()

    skill = skillToLearn

endFunction

Function UnfollowPlayer(Actor trainer)
    
    TrainerFollower.Clear()
    trainer.EvaluatePackage()

endFunction

Function StartTrainingSession(Actor trainer)
	
    Int relationshipRank = trainer.GetRelationshipRank(PlayerRef)
    isTraining = True

    if relationshipRank >= 1
        ; Bonus - friends rank or above
        skillPoints += 1
    endif

    ; The fun part
    ostim.StartScene(PlayerRef, trainer)

endFunction

Function GetRewards()
	
    if (trainerOrgasmed)
        ; Advance the skill
        Game.IncrementSkillBy(skill, skillPoints)
    endif

endFunction

Function Reset()

    ; Cleaning
    skillPoints = 0
    isTraining = False
    trainerOrgasmed = False

endFunction


; ====|| Events ||====
Event OnInit()
    RegisterForModEvent("ostim_orgasm", "OnOstimOrgasm")
    RegisterForModEvent("ostim_end", "OnOstimEnd")
endEvent

Event OnOStimOrgasm(string eventName, string strArg, float numArg, Form sender)

    if (isTraining) && (!trainerOrgasmed) && (ostim.GetMostRecentOrgasmedActor() != PlayerRef)

        trainerOrgasmed = True

        if (ostim.GetTimesOrgasm(PlayerRef) < 1)
            ; Bonus - the trainer orgasmed before the player
            skillPoints += 1
        endif

        skillPoints += 1 ; base reward

    endif

endEvent

Event OnOStimEnd(string eventName, string strArg, float numArg, Form sender)

    if (isTraining)
        Utility.Wait(1.5)

        GetRewards()
        Reset()
    endif

endEvent