using UnityEngine;
using System.Collections.Generic;



public class Blocker_Base : Marker
{

    public Animator WallVisual;
    [Tooltip("Set an OffLimits Zone that enables when this this Blocker does. Used as a failsafe in case characters clip through the blocked area.")]
    public Zone_OffLimits LinkedOffLimits;
    [Tooltip("Camera will not progress past this blocker when it's active.")]
    public bool CameraStopper = true;

    public List<GameObject> EnableOnComplete = new List<GameObject>();
    public List<GameObject> DisableOnComplete = new List<GameObject>();
}

public class Blocker_Backtrack : Blocker_Base
{
    [Space(20)]
    [Tooltip("Stepping into this Trigger will activate the backtrack blocker. Add a Zone_Spawner to that collider if you want it to spawn enemies when triggering this blocker.")]
    public Collider TriggerArea;
}

