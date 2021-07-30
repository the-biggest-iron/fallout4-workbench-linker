Scriptname WorkbenchLinker:Perk_ActivatorPerk extends Perk Const

WorkbenchLinker:Quest_WorkbenchLinker Property WorkbenchLinkerQuest Auto Const
{The main workshop linker quest that handles all the logic.}

Message Property PlayerInPowerArmorMessage Auto Const

Group AutofillTheseProperties
    Keyword Property WorkshopItemKeyword Auto Const
    Keyword Property Workbench_General Auto Const
    Keyword Property WorkshopLinkContainer Auto Const
    Keyword Property FurnitureTypePowerArmor Auto Const
    Keyword Property PowerArmorWorkbenchKeyword Auto Const
    Quest Property Tutorial Auto Const
EndGroup

Event OnEntryRun(int auiEntryID, ObjectReference akTarget, Actor akOwner)
    Actor PlayerRef = Game.GetPlayer()

    If (akOwner != PlayerRef || akTarget.HasKeyword(WorkshopItemKeyword) || akTarget.HasKeyword(WorkshopLinkContainer) || !akTarget.HasKeyword(Workbench_General) || !(akTarget.GetBaseObject() is Furniture))
        Return ; Double check so that we allow the player to activate only viable workbenches
    EndIf

    If (PlayerRef.IsInPowerArmor())
        PlayerInPowerArmorMessage.Show()

        Return
    EndIf

    If (akTarget.HasKeyword(PowerArmorWorkbenchKeyword) && akTarget.FindAllReferencesWithKeyword(FurnitureTypePowerArmor, 500.0).Length <= 0)
        If (Tutorial as TutorialScript).bPABenchFindMessageActive == 0
				Tutorial.SetStage(1760)
		EndIf

        Return
    EndIf

    WorkbenchLinkerQuest.CreateWorkbench(akTarget)
EndEvent
