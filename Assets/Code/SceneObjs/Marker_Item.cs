using UnityEngine;

public class Marker_Item : Marker
{
    [Tooltip("The weapon/item's MadCard.")]
    public string MadCard;
    public bool PhysicsOn = false;
    public bool SpawnIntoParent = false;
    public int BonusMags = 0;
    public Vector3 SpawnForce = Vector3.zero;   // in World Space

}