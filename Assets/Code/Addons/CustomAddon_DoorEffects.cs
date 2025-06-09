using UnityEngine;
using System.Collections.Generic;

public class CustomAddon_DoorEffects : MonoBehaviour
{
    // For things that aren't used by most Entrances, but we may want to have happen on SOME spawners.

    // For Example: Permanently destroying an object or giving it physics when starting an entrance for the first time (blasting the fan out of a vent),
    // or coloring a Projector to match a spawning character's color (Teleporter particles).

    public enum FireEventsOn { DoorOpen, SpawnUnit, AnimEvent, Locked, NEVER = 100 }
    [Tooltip("When to initiate the Effects below. The AnimEvent option requires the EffectsCheck_AnimEvent() and EffectsCheck_AnimEvent() functions to be called.")]
    public FireEventsOn myEnableOn = FireEventsOn.SpawnUnit;  // So we can disable prefab'd things like Particles if the spawner isn't supposed to have them, ex: rapel but outside (don't want glass)


    // Enable //
    [Header("    Enable")]
    [Space(10)]
    [Tooltip("These objects enable when triggered, and disable when reset.")]
    public List<GameObject> EnableObjects = new List<GameObject>();
    [Tooltip("These objects disable when triggered, and enable when reset.")]
    public List<GameObject> DisableObjects = new List<GameObject>();

    // Destroy //
    [Header("    Perma")]
    [Space(10)]
    [Tooltip("Like EnableObjects, but they never disable.")]
    public List<GameObject> EnableOnForever = new List<GameObject>();
    [Tooltip("Completely annihilate these gameobjects when triggered.")]
    public List<GameObject> DestroyObjects = new List<GameObject>();

    // Color //
    [Header("    Colorize")]
    [Space(10)]
    [Tooltip("These objects will alter their qualifying materials to use the TintEffect color of the using character's MadCard.")]
    public List<GameObject> ColorByCharacter = new List<GameObject>();
    [Tooltip("Apply the color to use if the character's MadCard does not have a valid color assigned (black and 0% alpha will be ignored on a character).")]
    public Color DefaultColor = Color.white;

    // Particles //
    [Header("    Particles")]
    [Space(10)]
    [Tooltip("The particle systems to play when triggered.")]
    public List<ParticleSystem> Particles = new List<ParticleSystem>();

    // Physics //
    [Header("    Physics")]
    [Space(10)]
    [Tooltip("When triggered, these rigidbodies will have their colliders enabled and isKinematic set to FALSE. TIP: Set your rigidbodies to isKinematic TRUE on your door.")]
    public List<Rigidbody> PhysicsObjects = new List<Rigidbody>();
    [Tooltip("This amount of force will be applied to PhysicsObjects when triggered.")]
    public Vector3 PhysicsBlast = Vector3.forward * 5f;
    [Tooltip("Additional force to apply (along with PhysicsBlast), but is a random direction generated with a magnitude matching this value.")]
    public float RandomPhysicsVariance = 0;

    // Effects //
    [Header("    Effects")]
    [Space(10)]
    [Tooltip("Sound plays when triggered.")]
    public string OneShotSFX;
    [Tooltip("Effects to apply when triggered.")]
    public List<SpecialEffects> SpawnEffects = new List<SpecialEffects>();
    public enum SpecialEffects { ColorFlash };

    public void EffectsCheck_AnimEvent()
    {
        // Step 1: Set myEnableOn to "AnimEvent".
        // Step 2: Use an Animation Event to trigger this function from your door.
    }
    public void EffectsCheck_AnimEvent_Off()
    {
        // Step 1: Set myEnableOn to "AnimEvent".
        // Step 2: Use an Animation Event to trigger this function from your door.
    }
}