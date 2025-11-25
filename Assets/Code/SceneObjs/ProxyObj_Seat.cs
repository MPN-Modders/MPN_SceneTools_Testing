using UnityEngine;
using System.Collections.Generic;

public class ProxyObj_Seat : ProxyObj_REPOSITORY
{
    public ProxyType Type;
    public enum ProxyType
    {
        HoldingCell, // [Sleeper]
        MagChamber,
        SleeperBed, // [FloorTank]
        CloneVat,
        MedBed,
        Stretcher1, Stretcher2,
        Cage1, Cage2a, Cage2b,
    }

    [Tooltip("AI Module that determines when an NPC occupant will decide to bail out. They are: V_Exit_EnemyNear, V_Exit_Awake, V_Exit_ASAP, V_Exit_EnemiesGone, and V_Exit_HaveWaypoints.")]
    public List<string> NPC_ExitModules = new List<string>() { "V_Exit_EnemyNear" };
    // V_Exit_EnemyNear
    // V_Exit_Awake
    // V_Exit_ASAP
    // V_Exit_EnemiesGone
    // V_Exit_HaveWaypoints
}
