using UnityEngine;
using System.Collections.Generic;
using System.Collections;

public class Zone_StagingGround : AreaZone
{
    public string PublicName = "Barricade";

    [Tooltip("When this zone sends in its conscripts, it'll tell these Staging Grounds to do the same if they also have enough conscripts.")]
    public List<Zone_StagingGround> CoordinatedZones = new List<Zone_StagingGround>();
    [Tooltip("Where conscripts will attempt to stand.")]
    public List<Transform> StandPoints = new List<Transform>();
    [Tooltip("Where conscripts will attempt to take cover.")]
    public List<Cover_Point> CoverPoints = new List<Cover_Point>();
    [Tooltip("How many conscripts are needed before the squad attacks.")]
    public int RequiredOccupants = 5;
    [Tooltip("Maximum number of attackers this zone will send to its SiegeWall at a time, if assigned.")]
    public int SiegeWallAttackerCap = 2;   
    [Tooltip("The number of seconds delay after a StagingGround attack before Arena wave enemies may spawn again. Leave negative to ignore.")]
    public float DelaySpawnAfterAttack_Seconds = -1;

    [Tooltip("Faction assigned to all conscripts.")]
    public Factions myFaction = Factions.Enemy;
    public List<VocationList> RequireVocations = new List<VocationList>();                          // Must have all of these to qualify.
    public List<VocationList> ProhibitVocations = new List<VocationList>() { VocationList.Zed };    // Having even one of these disqualifies you.

    [Header(" INTERACT/DESTRUCTIBLE ONLY!")][Space(20)]
    [Tooltip("This zone's conscript squad will only attack the siege targets after this Destructible/Interactive is inactive.")]
    public ProxyObj_Base SiegeWall;      // This MUST be destroyed to pass by! If this is broken, skip me!    (Bandit Trench, Haunted House Windows)
    [Tooltip("If the ShortcutWall is active, conscripts follow different walking rules (below). Ex: Hard Sell garage doors.")]
    public ProxyObj_Base ShortcutWall;   // If this is not destroyed, we might be walking.   (N51 Mall Gates)                          
    [Space(20)]

    [Tooltip("TRUE: Don't wander too far outside the Staing Ground while waiting for more conscripts.")]
    public bool DefendArea = true;
    [Tooltip("TRUE: Don't wait for more conscripts to arrive if a squad is already actively attacking.")]
    public bool JoinExistingSquad = true;   // If true, these guys will trickle in to join the existing squad.
    [Tooltip("TRUE: Place a quest marker on the siege target we're attacking.")]
    public bool MarkAttackers = false;
    [Tooltip("TRUE: Conscripts wait until the zone is full up before attacking.")]
    public bool FullAttacksOnly = false;
    [Tooltip("TRUE: Conscripts of other Staging Grounds will still react to entering this one.")]
    public bool StealOccupants = false;

    [Tooltip("Movement behavior when the Shortcut is destroyed.")]
    public WalkOrder Walk_ShortcutDown = WalkOrder.DEFAULT;
    [Tooltip("Sprinting behavior whe the Shortcut is destroyed.")]
    public bool Sprint_ShortcutDown = true;
    [Tooltip("Movement behavior when the Shortcut is still standing.")]
    public WalkOrder Walk_ShortcutUp = WalkOrder.DEFAULT;
    [Tooltip("Sprinting behavior whe the Shortcut is still standing.")]
    public bool Sprint_ShortcutUp = true;
    [Tooltip("Movement behavior when defending the zone.")]
    public WalkOrder Walk_Defense = WalkOrder.NEVER;
  
    public string WarningSound = "event:/Menu Sounds/Mission And Objectives/Objective Failure";

    [Header("PERSONELLE SPAWNER")][Space(20)]
    [Tooltip("Additional enemies to create from SiegeSquadDoor and add to the conscripted squad.")]
    public List<string> SiegeSquadList = new List<string>(); 
    [Tooltip("Loadout to pull random weapons from for the spawner.")]
    public string SiegeSquadGear; // StatCard_Loadout
    public ProxyObj_Door SiegeSquadDoor; // Entrance_Base 
    public AlertStatus SiegeSquadAwake = AlertStatus.Combat;

    private void OnValidate()
    {
        // Clear if Invalid (Must be Interactive or Destructible):
        if (SiegeWall != null && !(SiegeWall is ProxyObj_Interact || SiegeWall is CustomObj_Destructible)) // NOTE: CustomObj_Interact is not needed, because it extends from ProxyObj_Interact, and "is" works like IsAssignableFrom()
        {
            SiegeWall = null;
            Debug.LogWarning("SiegeWall must be an Interactive or Destructible!");
        }
        if (ShortcutWall != null && !(ShortcutWall is ProxyObj_Interact || ShortcutWall is CustomObj_Destructible))
        {
            ShortcutWall = null;
            Debug.LogWarning("ShortcutWall must be an Interactive or Destructible!");
        }
    }
}