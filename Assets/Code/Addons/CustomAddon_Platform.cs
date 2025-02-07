using UnityEngine;

[RequireComponent(typeof(Rigidbody), typeof(Collider))]
public class CustomAddon_Platform : SceneObj
{
    [Header("   !! PLACE ON COLLIDER INSIDE TOGGLABLE!!")]
    [Space(20)]

    [Tooltip("Disable to allow Items to stick to this platform as well.")]
    public bool CharactersOnly = true;
    [Tooltip("A GameObject that will hold riders. Scale MUST be (1,1,1). Can be this same object.")]
    public Transform RiderHolder;
}