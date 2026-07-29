using UnityEngine;
using System.Collections.Generic;


public class Blocker_Progress : Blocker_Base
{
    [Header("KILL THESE TO CONTINUE:")]
    [Space(20)]
    [Tooltip("These characters must all be killed before the Blocker goes down.")]
    public List<Marker_Character> LinkedCharacters = new List<Marker_Character>();
    [Tooltip("These squads must all be killed before the Blocker goes down.")]
    public List<Marker_Squad> LinkedSquads = new List<Marker_Squad>();
}