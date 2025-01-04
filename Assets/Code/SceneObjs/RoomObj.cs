using UnityEngine;

public class RoomObj : ProxyObj
{
    // RoomObj is "ProxyObj_Room" but renamed for modder disambiguation.

    [Space(10)]
    public bool ForceStartingRoom = false;

    [Space(5)]
    [Header("  == LOCKOUT == ")]
    [Tooltip("This room won't be closed off forever when you leave it.")]
    public bool DisableLockout_OnLeave = false;     
    [Tooltip("The previous room won't be closed off forever when you leave to enter this room.")]
    public bool DisableLockout_PrevRoom = false;   
    [Tooltip("Close the previous room forever regardless of its Lockout rules.")]
    public bool ForceLockout_PrevRoom = false;    
    [Tooltip("When closing out of this room, it will only disable, not be fully destroyed.\n\nAvoid setting this true where it can be helped.")]
    public bool SoftDeactivate = false;
    [Tooltip("This room won't be considered for a new wave of enemies in ANY stage.\nMeant for Arena Infiltration stage hallways.")]
    public bool ArenaSafeRoom = false;

    public enum LeaveLock
    {
        Default,    // Stages lock the doors, Overworld Hubs do not.
        Ignored,    // Enemies do not lock the doors when present (as per Overworld Hubs)
        Forced,     // Enemies always lock the doors when present.
    }
    [Space(5)]
    public LeaveLock LeaveLockRules = LeaveLock.Default;

    [Header("  == LAYOUT == ")]
    public Camera CameraPoint;
    public GameObject CameraTarget;
    public GameObject BorderLeft;
    public GameObject BorderRight;
    public GameObject BorderBack;
    public GameObject BorderForward;
    public Vector3 Leeway_Pos = new Vector3(1, 1, 0);
    public Vector3 Leeway_Look = new Vector3(1, 1, 0);
    public Vector2 Leeway_Mouse = Vector2.one;


    [Header("  == ENVIRONMENT == ")]
    public Material Skybox;
    public Color AmbientColor = new Color(0.3f, 0.3f, 0.3f);
    public string AmbientSound = "event:/Ambience/Hollow Ambient 4";
    [Range(0,2)]
    public float AmbientVolume = 0.4f;
    public Color FogColor = new Color(0, 0, 0, 1);
    public FogMode FogMode = FogMode.Linear;
    public float FogDensity = 0;
    public Vector2 FogLinearStartEnd = new Vector2(0, 300);

    [Space(15)]
    [Header("  == FOLDERS == ")]
    public GameObject CharacterFolder;
    public GameObject WaypointFolder;
    public GameObject BackgroundFolder;

}