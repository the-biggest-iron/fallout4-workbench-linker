Scriptname WorkbenchLinker:RefAlias_LinkerQuestPlayer extends ReferenceAlias Const

Perk Property PerkToGive Auto Const

Event OnInit()
    Self.GivePerk() ; On quest start give the perk
EndEvent

Function ForceRefToPlayer()
    ; Function to force this reference alias to the player

    Actor PlayerRef = Game.GetPlayer() ; Get the player reference

    If (Self.GetRef() != PlayerRef)
        Self.ForceRefTo(PlayerRef) ; Force this ref alias to point to the player if this ref alias doesn't point to the player already
    EndIf
EndFunction

Function GivePerk()
    ; Function that gives the player the perk if they don't already have it

    ForceRefToPlayer() ; First make sure this ref alias is the player. This is important so that the correct events fire

    Actor PlayerRef = Game.GetPlayer()

    If (!PlayerRef.HasPerk(PerkToGive))
        PlayerRef.AddPerk(PerkToGive)
    EndIf
EndFunction

Event OnPlayerLoadGame()
    ; This is to make sure the perk doesn't disappear on game load

	Self.GivePerk()
EndEvent

Event OnRaceSwitchComplete()
    ; Race changing can also cause some issues so this makes sure the perk is still there

	Self.GivePerk()
EndEvent

Event OnGetUp(ObjectReference akFurniture)
    (GetOwningQuest() as WorkbenchLinker:Quest_WorkbenchLinker).RestoreWorkbench() ; When the player gets up from any furniture item (workbenches included!), reset the workbenches
EndEvent
