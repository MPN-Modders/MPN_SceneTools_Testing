using UnityEngine;

public class ProxyObj_REPOSITORY : ProxyObj_Base
{
    [Tooltip("Door starts locked. Can be unlocked with the SetDoorLock Event Action.")]
    public bool Locked = false;
    [Tooltip("Characters must have this Vocation to use the door.")]
    public VocationList VocationRequired = VocationList.NONE;
    [Tooltip("Characters may not have this Vocation to use the door.")]
    public VocationList VocationProhibit = VocationList.NONE;
}

public class ProxyObj_Door : ProxyObj_REPOSITORY
{
    public ProxyType Type;

    [Tooltip("Won't be used to for random door selection, as per wave spawners, Arena stages, and Zone_Dead.")]
    public bool DisableSpawn = false;

    public enum ProxyType
    {
        EMPTY = -1,
        // Cat: Doors
        Standard = 0, Enemy, Side, FourthWall, Swing, Heavy,
        // CAT: Doors Big
        G03LM = 100, Elevator, Garage, Double,
        // CAT: Spawners
        Manhole = 200, FloorGrate, Fissure, FissureGlow, Ground, GroundWood, Vent, VentDrop, VentSide, VentFan, ZedFan, Rapel,
        // CAT: Automatic
        Transition = 500, Instant_x3, DropIn, DropIn_x5, Launched_x3, Ledge, Ledge_x3, Rail,
    }


    [Header("  == CONNECTIONS == ")]
    [Space(10)]
    public ProxyObj_Door LinkedDoor;
    [Tooltip("The scene the game will load when the player uses this door. \n\nNOTE: Set this to \"victory\" to let the player win when using this door in a Story stage.")]
    public string LinkedScene;
    [Tooltip("The SerialNumber of the door the player will exit from in the LinkedScene.")]
    public string LinkedSceneEntrance;
}