using UnityEngine;

public class Effect_ExplosionGenerator : MonoBehaviour
{
    [Tooltip("The MadCard of the Explosion that occurs.")]
    public string Explosion = "PropaneTank";
    [Tooltip("Invincible characters take full damage and can die.")]
    public bool ignoreInvincible = false;
}
