using UnityEngine;
using System.Collections.Generic;

public class CustomAddon_Locker : SceneObj
{
    [Header("    (Can also go on ProxyObj_Locker)")]
    [Header("   !! PLACE ON CUSTOM INTERACTIVE !!")]
    [Space(20)]

    [Tooltip("Start the attached Interactive as Used.")]
    public bool StartOpen = false;
    [Tooltip("Spawn my contents immediately, even if Closed/Unused. NOTE: The items still cannot be taken until the Locker is Open/Used.")]
    public bool StartSpawned = false;

    [Space(10)]
    [Tooltip("In Story Mode, these weapons come with extra ammo.")]
    public bool ExtraMags = true;
    [Tooltip("If you took all my stuff, close me.")]
    public bool CloseOnEmpty = false;
    [Tooltip("If this locker closes (or loses its inventory if it CANT close), should we respawn our weapons from Memory?")]
    public bool RespawnOnClose = false;
    [Tooltip("If this locker creates new items, destroy all previous ones.")]
    public bool DespawnPreviousOnRespawn = false;
    [Tooltip("Set contents to Quest.")]
    public bool WeaponsAreQuest = false;

    [Space(10)]
    [Tooltip("Locations for items to be placed, in order. NOTE: Proxy Lockers ignore this.")]
    public Transform[] ItemStickPoints;
    [Tooltip("Where excess items spawn from if there aren't enough Stick Points. NOTE: Proxy Lockers ignore this.")]
    public Transform DropPoint;
    [Tooltip("Force applied to items spawned from DropPoint.")]
    public float ExpelForce = 12f;

    [Space(10)]
    [Tooltip("Powerups spawned into lockers begin with this value (such as amount of Cash).")]
    public int PowerupValue;

    [Space(10)]
    [Tooltip("The MadCards of the items in this locker. Empty values are valid (for spacing among Stick Points). ")]
    public List<string> Contents = new List<string>();
    [Tooltip("SerialNumbers assigned to the spawned items, in order.")]
    public string[] AssignedSerialNumbers = new string[0]; // Give these serial numbers to weapons created.
    public void Event_LockerIsClosed()
    { } // For SceneTools Animator access: Clears contents of Locker, and respawns weapons if appropriate. NOTE: Event may sometimes be skipped if it happens at the VERY end of the animation, so avoid that!
}
