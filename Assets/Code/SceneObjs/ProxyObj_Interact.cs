using UnityEngine;
using System.Collections.Generic;


public class ProxyObj_Interact : ProxyObj_Base
{
    public ProxyType Type;

    [Space(20)]
    [Tooltip("Start off appearing as if already used once.")]
    public bool StartUsed;

    // MODIFIABLE VALUES
    [Tooltip("Set to -1 to use default value. (The default value is usually 3.)")]
    public float InteractRange = -1;
    [Tooltip("Ignores the orientation point on the floor for characters using this Interactive, if it has one.")]
    public bool IgnoreUserSnap;

    // ANIMS
    [Space(5)]
    [Tooltip("For instantaneous Tasks. Leave empty to use default.")]
    public string UseAnimSingle;
    [Tooltip("For continuous Tasks. Leave empty to use default.")]
    public string UseAnimLoop;

    // SFX
    [Space(5)]
    public string UseSound;    
    public string DoneSound;   
    public string CancelSound; 

    // RESTRICTIONS
    [Header("   RESTRICTIONS")]
    [Space(20)]
    [Tooltip("Only the Player can interact.")]
    public bool PlayerOnly = false;
    [Tooltip("Locked Tasks normally keep an Interactive unusable.")]
    public bool UseableIfLocked = false;
    [Tooltip("Clears default Taks from Ammo boxes, medical cabinets, etc.")]
    public bool ClearDefaultTasks = false; 
    [Tooltip("If TRUE, this object isn't even usable if you don't qualify.")]
    public bool CannotUseIfUnqualified = false;
    [Tooltip("If TRUE, the Task will not complete until the animation tells it to (it MUST have the GrabInteractive_AnimEvent event on the animation!")]
    public bool WaitForUserAnim = false;
    [Space(5)]
    [Tooltip("The Filename of Characters allowed to interact.")]
    public List<string> AllowedCharacters = new List<string>();
    [Tooltip("Must have this Vocation to use this Interactive.")]
    public VocationList VocationRequired = VocationList.NONE; 
    [Tooltip("If TRUE, then Vocations and Character requirements are only checked if SOMEONE in the squad meets them. If no one does, then anyone can use it.")]
    public bool AntiSoftlock = false;
    [Space(5)]
    [Tooltip("The Filename of a Keycard or carried Weapon needed to use this.")]
    public string Keycard;                    
    [Tooltip("Weapons are not removed.")]
    public bool RemoveKeycard = true;                          
    [Space(5)]
    [Tooltip("Text warning that appears when you cannot interact due to Keycard or Character.")]
    public string RestrictionMessage = ""; 	                       
    [Tooltip("Text warning that appears when you cannot interact due to Vocation.")]
    public string RequirementMessage = "";                         
    public string FailSound = "";

    // EVENTS
    [Space(20)][Header("     =============    ")][Space(20)]
    [Tooltip("The Filename of the EventCard activated by a completed Task (if RunTaskEvent is set to true). NOTE: Conditions are SKIPPED!")]
    public string TaskEvent;
    [Header("     =============    ")][Space(20)]
    [Tooltip("The info that regulates usage of this Interactive. Each Interactive requires at least one Task to be usable.")]
    public InteractiveTask[] Tasks;

    public enum ProxyType
    {
        EMPTY = -1,
        
        BoxLift = 20, Button, Buttons, Elevator,
        Monitor = 60, Laptop, Console1, Console2, Console2_Blue, Console3, Console3_Blue, Console4, Console5, Console5_Blue, ConsoleAsylum, ConsoleOffice,

        Switch = 100, LeverBig, Phone, Ticket, Viewfinder, BombsMany, Keycard_Blue, Keycard_Gold, Valve, PaperStack, Shelf, Trash, FilingCabinet,

        Ammo = 150, AmmoGrenade, AmmoNega,

        MedCabinet = 500, BombSingle,
    }


    public class TaskBase
    {
        public string SerialNumber;
        [Tooltip("When completed, the EventSystem will increase the value of your TrackedEvent by 1 (starting at 0). The Event System can track this value as a Condition.")]
        public string TrackedEvent;
        public bool Repeating;
        [Tooltip("On completion of this Task, the Interactive will run all Actions on its TaskEvent. ")]
        public bool RunTaskEvent;

        [Tooltip("Randomly displayed popup text when the Task is completed.")][TextArea(2,5)]
        public string[] PopupComplete;
    }
    [System.Serializable]
    public class InteractiveTask : TaskBase
    {
        [Tooltip("This will display as the player's Use-prompt.")]
        [Space(15)]
        public string HighlightText;
        [Tooltip("For Interactives with a TimeGoal, this displays while interacting. The game adds a \"...\" to the end of this automatically.")]
        public string UseText;
        public SelectionColors UseColor;
        [Tooltip("The sprite that appears over the Interactive when this Task is top Priority. ")]
        public string Icon;

        [Space(5)]
        [Tooltip("Seconds of holding the USE button before this Task is complete. Set to 0 or lower to make it \"instantaneous\". Higher, and this Task is \"continuous\".")]
        public float TimeGoal;
        [Tooltip("Seconds a full bar would take to empty when not being used. Set negative to never run down once filled. Continuous Tasks only.")]
        public float TimeDisuse;
        [Tooltip("Seconds before TimeDisuse kicks in.")]
        public float TimeDelay;
        [Tooltip("Second bonus to usage bar when first starting this Task from empty.")]
        public float TimeStartBonus;

        [Space(5)]

        [Tooltip("Creates this GameObject on completion. Recommended to make this a Particle System, but can be any GameObject.")]
        public string SuccessEffect;
        [Tooltip("For ordering Tasks, from lowest to highest Priority.")]
        public int Priority;

        [Tooltip("CAUTION: Many of these hard-coded events will NOT work excpet under specific circumstances (such as \"Arena\" Events only working during a Arena campaign).")]
        public InteractiveEvents AutoEvent;

        [Tooltip("Locked Tasks are skipped when checking for available Tasks on this Interactive. The Event System can alter this value.")]
        public bool Locked;
    }
   
 
}