using UnityEngine;
using System.Collections.Generic;

public class CustomObj_Seat : ProxyObj_Seat
{
    [Space(5)]
    [Header(" == CUSTOM OBJECT == ")]
    [Space(20)]

    [Tooltip("If this Seat has an Open/Closed state, link its animator here.")]
    public Animator LinkedAnimator;

    [Tooltip("Plays when entering the Seat. [Use the EnterComplete event in custom animation clips to tell the Seat the character is done arriving.]")]
    public string EnterAnim;
    [Tooltip("The name of the animation to play when the character arrives.")]
    public string IdleLoop;
    [Tooltip("The name of the animation clip to play on exit. Will be randomly picked from this list." +
             " [Use the SpawningComplete event in custom animation clips to tell the Seat the character is done leaving (or SpawnEndUpdateRoot if their root node changes position). Set the event's int to 1 to end the character in a freefall state.]")]
    public List<string> ExitAnims = new List<string>();

    [Tooltip("Where a user will line up to enter this Seat.")]
    public Transform EnterPoint;
    [Tooltip("Must be greater than 0 to be enterable.")]
    [Range(-1, 15)] public int EnterRange = -1;
    [Tooltip("The usage text for entering this Seat.")]
    public string EnterText = "Enter";
    [Tooltip("The usage text for entering this Seat.")]
    public string ExitText = "Exit";

    [Header("       SFX")]
    [Space(10)]
    public string SoundEnter; // NOTE: These are used by Repository/Door and thus must be remade in those CustomObj scripts too. This is because of how inherritance works with CustomObj and Proxies.
    public string SoundLeave; // NOTE: "
    public string SoundLock;  // NOTE: "

    [Tooltip("Where quest indicators will go.")]
    public Transform Point_UI;


    [Tooltip("(Player only): Set TRUE if you want any movement or action at all to release the occupant.")]
    public bool LeaveOnAnyAction = false;
    [Tooltip("Where the occupant will snap to while held by the Seat.")]
    public Transform SitPoint;
    [Tooltip("Allow the occupant to look around.")]
    public bool LookAtPeople = false;
    [Tooltip("Forces the exiting occupant to take a few steps away when they leave.")]
    public bool WalkAwayOnExit = true;
    [Tooltip("Entirely prevent occupant from exiting manually.")]
    public bool AmExitLocked = false;
    [Tooltip("If any SerialNumbers are contained in this list, then only those characters may use this Seat. If empty, anyone can use it.")]
    public List<string> AllowedSerials = new List<string>();
    [Tooltip("These GameObjects will be set to active when Seat is occupied, and disabled when not.")]
    public GameObject[] EnabledOnOccupied = new GameObject[0];

    [Space(5)]
    [Header(" == VESSELS == ")]
    [Space(20)]
    [Tooltip("The name of the DriverCard that will override any attached Vessel's DriverCard when this Seat is occupied by an NPC. Overrides DriverCard on the attached Vessel.")]
    public string DriverCard;
    [Tooltip("The name of the DriverCard that will override any attached Vessel's DriverCard when this Seat is occupied by Player 1. Overrides DriverCard on this Seat.")]
    public string DriverCard_Player;


}