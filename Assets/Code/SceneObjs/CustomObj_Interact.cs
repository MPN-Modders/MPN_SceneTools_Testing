using UnityEngine;
using System.Collections.Generic;

public class CustomObj_Interact : ProxyObj_Interact
{
    [Space(5)]
    [Header(" == CUSTOM OBJECT == ")]
    [Space(20)]


    [Tooltip("For animating the Interactive. Create an AnimationOverrideController to extend from Interact_Base AnimationController.")]
    public Animator LinkedAnimator; 

    // BASE (Including Destructible)

    [Space(10)]
    [Tooltip("Recalculate the room's nodes. Suggested for Interactives that alter the walkable area of a room.")]
    public bool ResetPathNodes = false;
    [Tooltip("Progress Bar can never go off-screen.")]
    public bool BarVisibleEverywhere = false;  
    [Tooltip("Progress Bar is red.")]
    public bool BarFillIsBad = false;           


    // EVENTOBJ

    [Space(10)]
    [Tooltip("Objects that are on when the Interactive is armed with a Task.")]
    public List<GameObject> EnabledWhileTask = new List<GameObject>();
    [Tooltip("Objects that are off when the Interactive has no Task.")]
    public List<GameObject> DisabledWhileTask = new List<GameObject>();
    [Tooltip("Objects that are ON if a Task is unlocked, and OFF if locked.")]
    public List<GameObject> EnabledWhileLocked = new List<GameObject>();
    [Tooltip("Objects that are OFF if a Task is unlocked, and ON if locked.")]
    public List<GameObject> EnabledWhileUnlocked = new List<GameObject>();
    [Tooltip("While my Task is Locked, my EnabledWhileTask objects will never be enabled.")]
    public bool LockedTaskIgnoresEnabled = false;


    // INTERACTIVE

    [Space(10)]
    [Tooltip("IK point for usage, if applicable. This is also the point the user faces if we're not aligning to Point_Sync.")]
    public GameObject Point_Grab;
    [Tooltip("The point InteractRange is measured from. If IgnoreUserSnap is disabled, the user will snap to this point.")]
    public GameObject Point_Sync;
    [Tooltip("The point where the Progress Bar or Quest Marker will go.")]
    public Transform Point_UI;
    [Tooltip("Where a Task's PopupComplete strings will display.")]
    public Transform Point_Read;

    [Space(10)]
    [Tooltip("Objects that are enabled when the Interactive is in an Unused/Closed state, and are disabled when not.")]
    public List<GameObject> EnabledIfUnused = new List<GameObject>();
    [Tooltip("Objects that are enabled when the Interactive is in a Used/Open state, and are disabled when not.")]
    public List<GameObject> EnabledIfUsed = new List<GameObject>();
    [Tooltip("These objects are enabled only while this Interactive is being highlighted for use.")]
    public List<GameObject> EnableWhileSelected = new List<GameObject>();
    [Tooltip("Like EnableWhileSelected above, but when usage requirements have not been met.")]
    public List<GameObject> EnableWhileSelectedFail = new List<GameObject>();
    [Tooltip("These objects are enabled only if this Interactive is NOT being highlighted for use.")]
    public List<GameObject> DisableWhileSelected = new List<GameObject>();


    [Space(10)]
    [Tooltip("If FALSE, my Task will fire off the moment the character commands it to (either press E, or from their Animation). If TRUE, my animation will dictate when to proceed instead.")]
    public bool WaitForMyAnimation = false;
    [Tooltip("If TRUE, hand IK will start immediately on use of interactive, rather than wait for an event to occur in the animation (if any at all).")]
    public bool StartIKonUse;
    [Tooltip("If TRUE, hand will keep snapped to contact point until released elsewhere (end of animation, for example)")]
    public bool LingerIK;
    [Tooltip("If FALSE, interactive turns OPEN and CLOSED as normal. If TRUE, stay CLOSED until out of Tasks, and only OPEN then.")]
    public bool StayClosedWhileTask = false;
    [Tooltip("If FALSE, Animator is on all the time. If TRUE, Animator turns off when there are no more useable Tasks, and on again when there are.")]
    public bool AnimatorDisabledWhenNotArmed = false;


    [Header("\tCONTINUOUS-USE ONLY")]
    [Space(10)]
    [Tooltip("On Continuous Tasks (TimeGoal > 0), these GameObjects will each turn on/off, in order, depending on the % of the Progress Bar that is filled.")]
    public List<GameObject> UseStates = new List<GameObject>();
    [Tooltip("On Continuous Tasks (TimeGoal > 0), these Animators will automatically set their position in the animation to the same % as the Progress Bar.")]
    public List<Animator> UseAnimators = new List<Animator>();
    [Space(5)]
    [Tooltip("Objects enabled while this object is being used.")]
    public List<GameObject> EnabledWhileUsed = new List<GameObject>();
    [Tooltip("Objects disabled while this object is being used.")]
    public List<GameObject> DisabledWhileUsed = new List<GameObject>();
    [Tooltip("Particles enabled while this object is being used.")]
    public List<ParticleSystem> ParticlesWhileUsed = new List<ParticleSystem>();


    [Header("\tON COMPLETION")]
    [Space(10)]
    [Tooltip("Create duplicates of these objects every time the Interactive is used. These objects will have their GameObjects set to Active automatically.")]
    public List<GameObject> CreateOnDone = new List<GameObject>();
}
