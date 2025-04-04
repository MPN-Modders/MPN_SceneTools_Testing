using UnityEngine;

[RequireComponent(typeof(Rigidbody), typeof(Collider))]
public class Obj_Toy : MonoBehaviour
{
    // For little objects that bounce away from the player when they run into them
    // (rather than being pushed), and play a little sound effect when they do.
    // Ex: Traffic cones, barricades, etc.

    [Tooltip("The Rigidbody of this Toy will begin at rest, even if floating.")]
    public bool StartAsleep = true;
    public string ImpactSound = "event:/Foley/Physics Objects/Big Plastic";
}
