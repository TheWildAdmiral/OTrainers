Scriptname OTrainersMCM extends SKI_ConfigBase  
{OTrainers Mod Configuration Menu}

GlobalVariable Property ToggleMaleDialogue Auto     ; Male dialogue toggle
GlobalVariable Property ToggleFemaleDialogue Auto   ; Female dialogue toggle
GlobalVariable Property CooldownSlider Auto         ; Cooldown time
GlobalVariable Property SuccessChance Auto          ; Persuasion success chance (default: 100%)
GlobalVariable Property MinRelationshipRank Auto    ; Minimum relationship rank required to start
GlobalVariable Property BonusRelationshipRank Auto  ; Minimum relationship rank required for additional skill point
String[] Property Ranks Auto                        ; Available relationship ranks

Event OnPageReset(String page)

    if (page == "") 
        ; Cover
        LoadCustomContent("OTrainers/logo.dds", 56, 32)
    elseif (page == "Settings")
        UnloadCustomContent()
        SetCursorFillMode(TOP_TO_BOTTOM)
        SetCursorPosition(0)

        ; =======> Dialogue
        AddHeaderOption("Dialogue")
        AddToggleOptionST("MCM_ToggleMaleDialogue", "Show the dialogue for males", ToggleMaleDialogue.GetValueInt())
        AddToggleOptionST("MCM_ToggleFemaleDialogue", "Show the dialogue for females", ToggleFemaleDialogue.GetValueInt())

        ; =======> Gameplay
        SetCursorPosition(1)
        AddHeaderOption("Gameplay")
        AddSliderOptionST("MCM_CooldownSlider", "Training cooldown", CooldownSlider.GetValue(), "{0} hours")
        AddSliderOptionST("MCM_SuccessChanceSlider", "Success chance", SuccessChance.GetValue(), "{0}%")
        AddMenuOptionST("MCM_RelationshipRankMenu", "Minimum relationship rank", Ranks[MinRelationshipRank.GetValueInt()])
        AddMenuOptionST("MCM_BonusRelationshipRankMenu", "Minimum bonus relationship rank", Ranks[BonusRelationshipRank.GetValueInt()])
    endif

endEvent

State MCM_ToggleMaleDialogue
    ; Show male dialogue

    Event OnHighlightST()
        SetInfoText("Enable or disable the dialogue for male NPCs")
    endEvent
    
    Event OnSelectST()

        if (ToggleMaleDialogue.GetValue() == 1)
            ToggleMaleDialogue.SetValue(0) 
            SetToggleOptionValueST(0) 
        else
            ToggleMaleDialogue.SetValue(1) 
            SetToggleOptionValueST(1)
        endif

    endEvent

endState

State MCM_ToggleFemaleDialogue
    ; Show female dialogue

    Event OnHighlightST()
        SetInfoText("Enable or disable the dialogue for female NPCs")
    endEvent
    
    Event OnSelectST()

        if (ToggleFemaleDialogue.GetValue() == 1)
            ToggleFemaleDialogue.SetValue(0) 
            SetToggleOptionValueST(0) 
        else
            ToggleFemaleDialogue.SetValue(1) 
            SetToggleOptionValueST(1)
        endif

    endEvent

endState

State MCM_CooldownSlider
    ; Set cooldown time

    Event OnHighlightST()
        SetInfoText("Time between training sessions, 6-8 hours are recommended")
    endEvent
    
    Event OnSliderOpenST()
        SetSliderDialogStartValue(CooldownSlider.GetValue()) 
        SetSliderDialogDefaultValue(6) 
        SetSliderDialogRange(1, 24)
        SetSliderDialogInterval(1)
    endEvent
    
    Event OnSliderAcceptST(Float value) 
        CooldownSlider.SetValue(value)
        SetSliderOptionValueST(value, "{0} hours")
    endEvent

endState

State MCM_SuccessChanceSlider
    ; Set success chance

    Event OnHighlightST()
        SetInfoText("Persuasion success chance")
    endEvent
    
    Event OnSliderOpenST()
        SetSliderDialogStartValue(SuccessChance.GetValue()) 
        SetSliderDialogDefaultValue(100) 
        SetSliderDialogRange(1, 100)
        SetSliderDialogInterval(1)
    endEvent
    
    Event OnSliderAcceptST(Float value) 
        SuccessChance.SetValue(value)
        SetSliderOptionValueST(value, "{0}%")
    endEvent

endState

State MCM_RelationshipRankMenu
    ; Minimum relationship rank required to start

	Event OnHighlightST()
		SetInfoText("Minimum relationship rank required to start OTrainers")
	endEvent

	Event OnMenuOpenST()
		SetMenuDialogStartIndex(MinRelationshipRank.GetValueInt())
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(Ranks)
	endEvent

	Event OnMenuAcceptST(Int index)
		MinRelationshipRank.SetValue(index)
		SetMenuOptionValueST(Ranks[index])
	endEvent
endState

State MCM_BonusRelationshipRankMenu
    ; Minimum relationship rank required for additional skill point

	Event OnHighlightST()
		SetInfoText("Minimum relationship rank required for additional skill point")
	endEvent

	Event OnMenuOpenST()
		SetMenuDialogStartIndex(BonusRelationshipRank.GetValueInt())
		SetMenuDialogDefaultIndex(3)
		SetMenuDialogOptions(Ranks)
	endEvent

	Event OnMenuAcceptST(Int index)
		BonusRelationshipRank.SetValue(index)
		SetMenuOptionValueST(Ranks[index])
	endEvent
endState