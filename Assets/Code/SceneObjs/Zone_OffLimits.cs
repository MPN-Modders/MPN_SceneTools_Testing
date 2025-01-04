using UnityEngine;
using System.Collections.Generic;


public class Zone_OffLimits : RestrictedZone
{
    // RULES:
    // -You can freely resize and rotate this object.
    // -Add additional collider components to this Zone to customzie the area it affects.

    [Space(10)]
    public AffectCharacters Teleport;
    public AffectCharacters Remove;
    public GameObject DespawnEffect;
}

public class RestrictedZone : AreaZone
{
    [Space(10)]
    [Tooltip("Weapons that fall into this zone become unusable.")]
    public bool DisableWeapons = true;

    // ENTRANCES
    [Space(10)]
    [Tooltip("Go to one of these entrances.\nIf none, pick from any entrance with DisableSpawn set to false.")]
    public List<ProxyObj_Door> SendTo = new List<ProxyObj_Door>();
    [Tooltip("Pick the closest entrance. If false, pick randomly from the SendTo list.")]
    public bool SendToClosest = true;
}

public class AreaZone : Marker
{

}