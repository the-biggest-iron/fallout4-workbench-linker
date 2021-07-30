Scriptname WorkbenchLinker:Quest_WorkbenchLinker extends Quest

Group RuntimeProperties Collapsed
    ObjectReference Property OriginalWorkbenchRef Auto
    ObjectReference Property NewWorkbenchRef Auto

    Location Property LastLocation Auto
EndGroup

Group AutoFillThese
    Keyword Property WorkshopKeyword Auto Const
    Keyword Property WorkshopItemKeyword Auto Const

    WorkshopParentScript Property WorkshopParent Auto Const

    Message Property LocationConfirmationMessage Auto Const
EndGroup

Function CreateWorkbench(ObjectReference OriginalWorkbench)
    ; 1: Keyword, 2: Confirm Message, 3: Loc to highlight 4: Include keywords, 5: Exclude keywords, 6: Exclude zero population, 7: Only owned, 8: Turn off header 9: only potential vassals, 10: check for quests
    Location WorkbenchLinkLocation = Game.GetPlayer().OpenWorkshopSettlementMenuEx(WorkshopKeyword, LocationConfirmationMessage, LastLocation, None, None, False, True, True, False, False)

    If (!WorkbenchLinkLocation)
        Return
    EndIf

    LastLocation = WorkbenchLinkLocation

    RestoreWorkbench() ; Run just in case

    OriginalWorkbenchRef = OriginalWorkbench ; Save the ref to the original workbench so we can re-enable it

    NewWorkbenchRef = OriginalWorkbenchRef.PlaceAtMe(OriginalWorkbenchRef.GetBaseObject(), 1, True, False, False) ; Create the "new" workbench which to link
    Utility.Wait(0.1)
    OriginalWorkbench.Disable() ; Disable the original bench, and wait before doing it to prevent the pop in pop out effect

    WorkshopScript WorkshopToLinkTo = WorkshopParent.GetWorkshopFromLocation(WorkbenchLinkLocation) ; Get the object ref to the workshop

    NewWorkbenchRef.SetLinkedRef(WorkshopToLinkTo, WorkshopItemKeyword)

    NewWorkbenchRef.Activate(Game.GetPlayer())
EndFunction

Function RestoreWorkbench()
    If (NewWorkbenchRef)
        NewWorkbenchRef.SetLinkedRef(None, WorkshopItemKeyword)
        NewWorkbenchRef.Disable()
        NewWorkbenchRef.Delete()

        NewWorkbenchRef = None
    EndIf

    If (OriginalWorkbenchRef)
        OriginalWorkbenchRef.Enable()

        OriginalWorkbenchRef = None
    EndIf
EndFunction
