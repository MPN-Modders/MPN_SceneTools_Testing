using UnityEngine;
using System.Collections.Generic;

public class Marker_Waypoint : Marker
{
    public MarkerType Type;

    [Tooltip("Disable floor snapping.")]
    public bool Floating;

    public List<Marker_Waypoint> ForceConnect = new List<Marker_Waypoint>();

    public enum MarkerType
    {
        Standard = 0,
        Sniper,
        Spawn,
    }

}