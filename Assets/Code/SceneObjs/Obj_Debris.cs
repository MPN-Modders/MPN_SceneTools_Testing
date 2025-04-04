using UnityEngine;

[RequireComponent(typeof(Rigidbody), typeof(Collider))]
public class Obj_Debris : MonoBehaviour
{
    // Debris are a way to add physics objects to your scene that can auto-remove
    // themselves once they come to rest.

    public bool DecayOnRest = true;
    public bool ErraticBounce = false;
}
