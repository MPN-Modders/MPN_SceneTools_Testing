using UnityEngine;
using System.Collections.Generic;

public class Effect_DebrisGenerator : MonoBehaviour
{
    [Tooltip("Create copies of the objects rather than enabling them directly.")]
    public bool CloneDebris = true; // On by DEFAULT if it's a prefab.
    [Tooltip("The objects to convert or copy as Debris.")]
    public List<GameObject> CreateList = new List<GameObject>();
    public Vector3 Force;
    [Range(0, 1)] public float RandForce = 1f;
    public float SpawnDistance;
    public float RandomDir;
    public float Spin;
    [Tooltip("If true, the Debris will despawn when they come to rest.")]
    public bool DecayDebrisOnRest = false;
    [Tooltip("Start each Debris with a randomized rotation.")]
    public bool RandomizeRotation = false;
    [Tooltip("Additional force applied to each Debris away from the center of the Generator.")]
    public float ExplosiveForceFromMe;
    public bool DestroyMeOnComplete = false;
    [Tooltip("Debris will take the current local scale of the Generator. Useful for Prefab GameObjects whose scale you don't want to alter.")]
    public bool ScaleDebrisToLocalScale = false;
    [Tooltip("Debris will be set to the Debris layer once created.")]
    public bool ConvertToDebrisLayer = false;
    public string PlaySound;
}