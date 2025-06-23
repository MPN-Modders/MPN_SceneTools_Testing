using UnityEngine;
using System.Collections.Generic;

public class CustomObj_Door : ProxyObj_Door
{
    [Space(5)]
    [Header(" == CUSTOM OBJECT == ")]
    [Space(20)]

    [Tooltip("Use the ToggleOpen(int) AnimationEvent to set the door to Open (0), Closed (1), Opening (2), or Closing (3)")]
    public Animator LinkedAnimator;
    [Tooltip("Used by doors that stick to the wall behind them, so that they know the surface of the door that should rest flush against the wall. If your door is using a mask to cut a hole out of the wall, this should be that object to assure it lines up.")]
    public Transform Mask;

    [Tooltip("Plays when entering the door. [Use the EnterComplete event in custom animation clips to tell the door the character is done arriving.]")]
    public string EnterAnim;
    [Tooltip("(Optional) The name of the animation clip for each character that will be standing and waiting on each of this door's spawn points. If not enough Idle animations included, will default to the final one.")]
    public List<string> IdleLoops = new List<string>();
    [Tooltip("(Optional) The name of the animation clip for each character as they leave from one of this door's spawn points. If not enough Exit animations included, will default to the final one." +
             " [Use the SpawningComplete event in custom animation clips to tell the door the character is done leaving. Set the event's int to 1 to end the character in a freefall state.]")]
    public List<string> ExitAnims = new List<string>();

    [Tooltip("Where a user will line up to enter this door. IMPORTANT: This is only used by doors that require pressing E to use. For doors you walk into, use the CustomAddon_DoorGrabber.")]
    public Transform EnterPoint;
    [Range(-1, 15)] public int EnterRange = -1;
    [Tooltip("The usage text for entering this door.")]
    public string EnterText = "Enter";

    // [ALREADY MOVED] ProxyObj_REPOSITORY has Vocation Requirement/Prohbited and AmLocked

    [Header("       SFX")]    [Space(10)]
    public string SoundEnter; // NOTE: These are used by Repository/Vehicle and thus must be remade in those CustomObj scripts too. This is because of how inherritance works with CustomObj and Proxies.
    public string SoundLeave; // NOTE: "
    public string SoundLock;  // NOTE: "
    //
    public string SoundOpen;
    public string SoundClose;

    // [MOVED] UserInv/Untarget/Intangi all moved to ProxyObj_Door

    [Tooltip("Where quest indicators will go.")]
    public Transform Point_UI;

    // [MOVED] DisableSpawn/NoReturn/IgnoreLockdown on ProxyObj_Door

    [Header("       BOOLEANS")]    [Space(10)]
    [Tooltip("Snap the 0,0,0 point of this door to the floor when the scene is loaded.")]
    public bool SnapToFloor;
    [Tooltip("Only place characters into this entrance when it's been set to Closed. Ignored if no animator controller assigned to LinkedAnimator.")]
    public bool SpawnWhenClosed;
    [Tooltip("Characters only exit when the entrance is Closed, instead of Open.")]
    public bool ExitWhenClosed;
    [Tooltip("Skip the Closing and Opening transition-states when toggling Open/Closed.")]
    public bool NoClosingOrOpening;
    [Tooltip("Exit path will be pathlocked. Requires assigned ExitPoints to work. Including a Grabber on this door will automatically turn this on.")]
    public bool ForcePathLockExit;
    public enum ExitSpeed { Walk, Run, Sprint }
    public ExitSpeed ExitType = ExitSpeed.Run;
    [Tooltip("")]
    public int UseSpeedMult = 2;

    [Header("       ACCESS")]    [Space(10)]
    [Tooltip("Time (frames) between when the last group of characters finished leaving this Door, and when the next group is allowed to go.")]
    public float SpawnBufferTime;
    [Tooltip("Time (frames) the door will stay open after the Door is vacated.")]
    public float DoorOpenTime = 20;
    [Tooltip("How long to wait (frames) after receiving a character before allowing them to leave. Any value of 0 or less is instant.")]
    public float StartupWaitTime = -1;
    [Tooltip("StartupWaitTime will reset to -1 after the first character.")]
    public bool ClearStartupWaitAfterFirst;
    public enum DoorStatus { Open, Closed, Opening, Closing };      
    [Tooltip("Doors need to be Closed to place characters within, and Open to release them. Opening/Closing are transitional states that can be controlled with Animation Events via this Door's LinkedAnimator (disable their use with NoClosingOrOpening above).")]
    public DoorStatus StartingStatus = DoorStatus.Closed;
    [Tooltip("Special objects with animation controllers that display a Door's open/closed/locked/occupied status.")]
    public Animator[] AccessLights = new Animator[0];
    [Tooltip("If this Door is not linked to any other Door, then outright disable/remove all AccessLights.")]
    public bool DisableLightIfNoLink = false;

    [Header("       POINTS")]
    [Space(10)]
    [Tooltip("Where exiting characters will start from. The number of SpawnPoints dictates how many characters can leave from a Door at a time.")]
    [UnityEngine.Serialization.FormerlySerializedAs("SpawnPoints")]
    public Transform[] StartPoints = new Transform[0];
    [Tooltip("Where exiting characters will head. If the number of Spawn and Exit points match, each character will head to the ExitPoint that matches the index of their SpawnPoint.")]
    public Transform[] ExitPoints = new Transform[0];

    [Header("       OTHER")]
    [Space(10)]
    [Tooltip("Do not place characters into the room until these doors are unoccupied.")]
    public ProxyObj_Door[] MutuallyExclusiveDoors = new ProxyObj_Door[0];



    public void ToggleOpen(int inOpenClosed)
    {
        // ANIMATION EVENT: Set the door to Open (0), Closed (1), Opening (2), or Closing (3)
    }

 
}