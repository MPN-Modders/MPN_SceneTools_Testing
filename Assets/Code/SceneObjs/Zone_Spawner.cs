using UnityEngine;
using System.Collections.Generic;


public class Zone_Spawner : AreaZone
{
    [Space(10)]
    [Tooltip("List of Character markers to set SpawnEnabled to true when the player enters the zone.")]
    public List<Marker_Character> EnableCharacters = new List<Marker_Character>();
    [Tooltip("List of Squad markers to set SpawnEnabled to true when the player enters the zone.")]
    public List<Marker_Squad> EnableSquads = new List<Marker_Squad>();

    [Tooltip("Frames that must pass between the previous and next character spawn.")]
    public float SpawnBuffer = 10;
}