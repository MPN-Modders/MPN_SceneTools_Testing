using UnityEngine;
using System.Collections.Generic;

public class Hazard_Core : MonoBehaviour
{
    
    [Header("           to FREEZE POSITION: ALL!")]
    [Header("           It won't collide w/ Character!  INSTEAD, set it")]
    [Header("IMPORTANT: Don't set rigidbody to Kinematic unless its a Trigger!")]
    public float contactDmg = 10;
    [Tooltip("NoKill: Character only hurt, never killed. Standard: Normal damage and death. IgnoreThreshold: Corpus doesn't need to be fully damaged before breaking it. NoKillPlayer: NoKill, but only for the player.")]
    public DamageEffect damageEffect = DamageEffect.IgnoreThreshold;
    [Range(0, 1)]
    [Tooltip("Works like armor piercing on weapon MadCards.")]
    public float armorPierce = 1;
    [Tooltip("Ragdoll to apply on contact. Useful to keep a hazard from applying to someone over and over again.")]
    public float bounceAway = 10;
    [Tooltip("Bounce the character back in a fixed direction, instead of directly away from the point of contact.")]
    public bool UseBounceDir; public Vector3 BounceDir = Vector3.zero;


    [Tooltip("Filename of the Damage-over-Time MadCard to apply to victims.")]
    public string DoT = "";
    [Tooltip("What kind of attack the hazard simulates. Note that dodging normally has a window where you're truly invincible, but the [FullDodgeOverride] Effect will ignore HitAvoid and just look at whether or not you're in the animation.")]
    public AttackQuality HitAvoid = AttackQuality.Undodgable;


    public DamageType dmgType = DamageType.Blunt;
    [Tooltip("Always: Every hit counts. OncePerFrame: All extra hits to a character ignored after the first in a single frame. OnceTilReset: This script or the object must be disabled + reenabled before a character can be dealt another hit.")]
    public List<Effects> myEffects = new List<Effects>();

    [Tooltip("Always: Every hit counts. OncePerFrame: All extra hits to a character ignored after the first in a single frame. OnceTilReset: This script or the object must be disabled + reenabled before a character can be dealt another hit.")]
    public HitFrequency myHitFrequency = HitFrequency.OncePerFrame;
    [Tooltip("Characters from these factions won't be hit.")]
    public Factions[] IgnoreFactions = new Factions[0];

    public string hitSound;
    [Tooltip("A gameobject (normally a Particle System) created in the world on each hit.")]
    public GameObject HitEffect;
}