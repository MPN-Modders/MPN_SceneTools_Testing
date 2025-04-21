using UnityEngine;
using System.Collections.Generic;

public class Hazard_AutoShooter : MonoBehaviour
{
    [Tooltip("The Filename of a weapon MadCard to fire.")]
    public string RangedWeapon;
    [Tooltip("In case this Shooter was meant to deal damage, you can give it a Faction so it won't tag friendlies.")]
    public Factions myFaction = Factions.None;
    public bool PlayFireSound = false;
    public bool FireOnStart = true;
    public bool FireOnEnable = false;
    public bool MuzzleFlare = false;
    public bool AutomaticFire = false;
    public bool CosmeticOnly = false;
}