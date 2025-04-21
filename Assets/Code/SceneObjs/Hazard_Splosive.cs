using UnityEngine;
using System.Collections.Generic;

public class Hazard_Splosive : MonoBehaviour
{
    public bool ResetPathNodesAfterDestroy = false;
    public float Health = 10;
    [Tooltip("This object will react to hits but cannot die.")]
    public bool Unbreakable = false;
    public bool FlashOnHit = true;

    [Space(10)]
    public List<Collider> HitLocations = new List<Collider>();
    [Tooltip("What's left behind in place of this Splosive when it's detonated. This object will not decay like Debris.")]
    public GameObject myRemains;

    [Tooltip("Debris objects (either prefabs or inactive within your scene) that will be blasted from the object on detonation.")]
    [Space(10)]
    public List<Obj_Debris> Debris = new List<Obj_Debris>();
    public float DebrisForce = 5;
    public Vector3 DebrisWorldDirection = Vector3.zero;

    public string HitSFX;
    public string DestroySFX;

    [Tooltip("Object created where object has been hit. We recommend a particle system.")]
    public GameObject HitRicochet;

    [Tooltip("The MadCard of the Explosion that occurs.")]
    public string Explosion;
    [Space(10)]
    [Tooltip("A Prefab from your SceneTools library that will be created when it explodes. We recommend a particle system.")]
    public GameObject SplodeEffect;
    [Tooltip("For Splosives with rigidbodies: how fast must I go to explode on impact?")]
    public float VelocityExplosion = 9999;
    [Tooltip("At 60fps, how long after \"death\" until the explosion occurs.")]
    public float FramesBeforeSplode = 0;
    [Tooltip("What turns ON (particles, etc) when I am about to splode? (example: the flame on top of a primed propane tank).")]
    public List<GameObject> BoutToExplodeObjects = new List<GameObject>();
    public Transform SplodeFromPoint;

    [Tooltip("Ignore invincibility on a character (example: Dropping crates on the Sheriff's head)")]
    public bool ignoreInvincible = false;
    [Tooltip("Strobing warning effect if this Splosive has been primed.")]
    public bool flashOnTrigger = true;

}