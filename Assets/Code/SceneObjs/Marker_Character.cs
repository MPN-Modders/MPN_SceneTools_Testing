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

    [Header("  == TRAITS / BEHAVIORS == ")][Space(10)]
    public TraitList[] AddTraits = new TraitList[0];
    public BehaviorList[] AddBehaviors = new BehaviorList[0];
    public TraitList[] RemoveTraits = new TraitList[0];
    public BehaviorList[] RemoveBehaviors = new BehaviorList[0];

    [Space(10)]
    public ProxyObj_REPOSITORY SpawnFromDoor;
}

public class Marker_DataAssigner : Marker
{
    [Tooltip("Character won't spawn until a Zone_Spawn or the Event System tells it to.")]
    public bool SpawnEnabled = true;
    [Tooltip("\"Any\" uses the default faction of the character(s).")]
    public Factions Faction;
    [Tooltip("Squads Only: Use the highest alert status for this faction in this room.")]
    public AlertStatus Alertness;

    [SerializeField]
    public SpawnChatter_STP Chatter;
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