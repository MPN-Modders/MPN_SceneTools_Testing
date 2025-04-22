using UnityEngine;

public class Marker_Item : Marker
{
    [Tooltip("The weapon/item's MadCard.")]
    public string MadCard;
    public bool PhysicsOn = false;
    public bool SpawnIntoParent = false;
    [Tooltip("The SerialNumber to assign to your spawned weapon. NOTE: Marker_Item does not use its SerialNumber value (above) to assign *itself* a SN# like some other Marker spawners.")]
    public string AssignSerialNumber;

    [Space(10)]
    public int BonusMags = 0;
    public Vector3 SpawnForce = Vector3.zero;   // in World Space
}