using UnityEngine;

public class Marker_Character : Marker_DataAssigner
{
    [Space(6)]
    [Header("\tCHARACTER ASSIGNMENT")]
    [Space(20)]
    [Tooltip("The character's MadCard. Overrides the Character chosen below.")]
    public string MadCard;
    public CharacterTypes Character;
    public ControllerType Controller;
    public string CustomName;
    public string AssignSerialNumber;

    [Header("  == GEAR == ")][Space(10)]
    public bool ClearDefaultWeapons = false;
    [Tooltip("The MadCard of the weapon to equip.")]
    public string Held_R, Held_L, Stow_R, Stow_L, Thrown;
    [Tooltip("The MadCards of the armor to equip.")]
    public string[] Worn = new string[0];
    [Tooltip("The MadCard of a Keycard (C4, Blue Key, etc.) to carry.")]
    public string Keycard;

    [Header("  == TRAITS / BEHAVIORS == ")][Space(10)]
    public TraitList[] AddTraits = new TraitList[0];
    public BehaviorList[] AddBehaviors = new BehaviorList[0];
    public TraitList[] RemoveTraits = new TraitList[0];
    public BehaviorList[] RemoveBehaviors = new BehaviorList[0];
    public SkillsList[] RemoveSkills = new SkillsList[0];
    public string[] AddModules = new string[0];

    [Space(10)]
    [Tooltip("Essential characters take less damage in Executions, their fully damaged corpus won't auto-break from a fall, and they don't decay when bodies on screen exceed player settings. They're also a condition for checks done by Zone_Dead.")]
    public bool AmEssential = false;
    [Tooltip("This character cannot be moved for any reason.")]
    public bool FixedInPlace = false;
    [Tooltip("If set to the appropriate Faction, this character will be added to the Player's squad (NOTE: This 'unsupported' feature will only find the Player's squad if they are the only Player faction squad in the room)")]
    public bool ToPlayerSquad;
    [Tooltip("Do I get removed from my squad after death or not?")]
    public bool PermanentSquadmate;
    public bool AmInvincible = false;

    [Space(10)]
    public ProxyObj_REPOSITORY SpawnFromDoor; }

public class Marker_DataAssigner : Marker
{
    [Tooltip("Character won't spawn until a Zone_Spawn or the Event System tells it to.")]
    public bool SpawnEnabled = true;
    [Tooltip("\"Any\" uses the default faction of the character(s).")]
    public Factions Faction;
    [Tooltip("Squads Only: Use the highest alert status for this faction in this room.")]
    public AlertStatus Alertness;

    [SerializeField]
    [Space(10)]
    public SpawnChatter_STP Chatter;

    [Space(10)]
    public PatrolParameters_STP PatrolParams = new PatrolParameters_STP();
}

[System.Serializable]
public class SpawnChatter_STP
{
    [TextArea(0, 2)]
    [Tooltip("This character (or the first character to run into the room in a Wave) will spit this line out.")]
    public string SpeakLine;
    public string AnimClip;
    public float SecondsDelay;
    public bool Narrative = false;
    public bool PlayInCombat = true;
}


[System.Serializable]
public class PatrolParameters_STP
{
    public bool NeverWander = false;
    public bool FollowLeader = true;
    public PatrolPath_STP[] PatrolPaths = new PatrolPath_STP[0];
}
[System.Serializable]
public class PatrolPath_STP
{
	[HideInInspector] public string name = "Patrol Path";
    [Tooltip("Leave blank/empty elements in this list to set the previous waypoint as a \"wait here!\" order.")]
    public Marker_Waypoint[] PathPoints = new Marker_Waypoint[0];
    [Tooltip("If TRUE, the exact path used to get from the first to the last Point will be duplicated and reversed, allowing the Squad to return the way they came.")]
    public bool GenerateReturnPath = true;
    public bool LoopPath = true;
}