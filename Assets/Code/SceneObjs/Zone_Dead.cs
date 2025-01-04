using UnityEngine;

public class Zone_Dead : RestrictedZone
{
    // RULES:
    // -You can freely resize and rotate this object.
    // -Add additional collider components to this Zone to customzie the area it affects.

    [Space(10)]
    public AffectCharacters SendToEntrance = AffectCharacters.Everyone;
    [Tooltip("Player characters killed by this zone do not climb back out to perform a death animation.")]
    public bool NoDoorsForDeadMen = false; // Used by Arena to keep characters from coming back in Murder Room after falling to death.

    [Space(10)]
    public AffectCharacters AutoKill = AffectCharacters.None;
    public bool RemoveFromGameOnDeath = false;

    [Space(10)]
    public AffectCharacters DealDamage = AffectCharacters.Everyone;
    public float TraumaDamage = 0;
    public int CorpusDamage = 1;
    [Tooltip("MadCard of the DoT effect to apply.")]
    public string ApplyDoT;
}

