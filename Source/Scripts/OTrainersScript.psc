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
ReferenceAlias Property TrainerFollower Auto        ; A trainer who follows the player
GlobalVariable Property TrainingCooldown Auto       ; Cooldown expiration time
GlobalVariable Property CooldownBase Auto           ; Cooldown time (configurable in MCM)
GlobalVariable Property MinRelationshipRank Auto    ; Minimum relationship rank (configurable)

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

Function StartCooldown()

    Float time = CooldownBase.GetValue() / 24
    TrainingCooldown.SetValue(Utility.GetCurrentGameTime() + time)

endFunction

Function StartTrainingSession(Actor trainer)
	
    Int relationshipRank = trainer.GetRelationshipRank(PlayerRef)
    isTraining = True

    if (relationshipRank >= MinRelationshipRank.GetValueInt())
        ; Relationship bonus - by default: friend rank or above
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