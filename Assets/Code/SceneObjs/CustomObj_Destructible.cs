using UnityEngine;
using System.Collections.Generic;

public class CustomObj_Destructible : ProxyObj_Base
{
	[Space(5)]
	[Header(" == CUSTOM OBJECT == ")]
	[Space(20)]


	// BASE 

	[Tooltip("Recalculate the room's nodes. Suggested for Destructibles that alter the walkable area of a room.")]
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


	[Header("    INTERACTIVE  [TARGET]  ")]
	[Space(20)]
	[Tooltip("Where the character will aim when targeting this object. Empty defaults to the center of this object.")]
	public GameObject AimTarget;
	[Tooltip("Location for quest markers and Icon to appear, if any.")]
	public GameObject IconPoint;
	[Space(10)]

	[Tooltip("Any colliders that count as a valid hit location for this Destructible.")]
	public List<Collider> HitLocations = new List<Collider>();
	[Tooltip("(OPTIONAL) The gameobjects to enable/disable, one at a time, as the Destructible takes damage. If there are 2+ gameobjects in the list, the final gameobject is reserved for full damage. \n\nIMPORTANT: Do not include the Destructible itself in its own list!")]
	public List<GameObject> DestructionStates = new List<GameObject>();

	// Sound //
	public string HitSound;
	public string AdvanceStateSound;
	public string DestroySound;


	// Icon //
	[Space(10)]
	public Sprite Icon;

	// Targetting //
	[Space(10)]
	[Tooltip("If true, elements in DamageSources will be allowed. If false, elements NOT in DamageSources will be allowed.")]
	public bool AllowSources = false;
	public List<DamageSource> DamageSources = new List<DamageSource>();
	[Tooltip(" If true, elements in DamageTypes will be allowed. If false, elements NOT in DamageTypes will be allowed.")]
	public bool AllowTypes = false;
	public List<DamageType> DamageTypes = new List<DamageType>();
	[Tooltip("If true, elements in FactionsList will be allowed. If false, elements NOT in FactionsList will be allowed.")]
	public bool AllowFactions = false;
	public List<Factions> FactionsList = new List<Factions>();
	[Tooltip("The SerialNumber of the weapon(s) that deal us damage. Leave empty for any weapon.")]
	public string WeaponSerialNumber;       // Does a specific weapon have to do the shooting?

	// Destruction //
	[Space(10)]
	[Tooltip(" Either the health that must be reduced by damage, or the number of hits if DamageIrrelevant is true.")]
	public int Health = 10;
	[Tooltip("")]
	public float ArmorValue = 0;
	[Tooltip("A multiplier to adjust the damage dealt by ranged weapons.")]
	public float RangedDamageMult = 1;
	[Tooltip("If true, Armor is ignored and a hit just counts as a single hit, dealing 1 damage.")]
	public bool DamageIrrelevant = false;
	[Tooltip("Are we displaying a progress bar for this object's destruction?")]
	public bool ShowDamageBar = true;           //
	[Tooltip(" Does the damage bar force itself on screen so you always see it?")]
	public bool BarAlwaysOnScreen = false;
	[Tooltip("")]
	public bool FlashColorOnHit = false;
	[Tooltip("If the hit fails to qualify, does the hit (including melee/unarmed) continue through the object as if it's not there?")]
	public bool failedShotsPassThrough = false;
	[Tooltip("All bullets (but not melee or thrown) will pass through, even on a hit. MUST be a bullet, not a throwing weapon!")]
	public bool AllBulletsPassThrough = false;
	[Tooltip("When assigned a new Task, remove all damage.")]
	public bool ResetOnNewTask = false;      // 
	[Tooltip(" If I cannot break this, what do I say? Works like Keycard/Restriction line on Interactives.")]
	[TextArea(1, 3)] public string FailSayLine = "";

	// Splode //
	[Space(10)]
	[Tooltip("On hit contact, create this at ExplodePoint.")]
	public GameObject HitEffect;
	[Tooltip("On completion, create this at ExplodePoint.")]
	public GameObject CompletionEffect;         // On completion, create this.
	[Tooltip("Name of the Explosion MadCard to detonate at ExplodePoint.")]
	public string Explosion;     // MOD CONVERT //   // Do we blow?!
	[Tooltip("Where hit effects go.")]
	public Transform ExplodePoint;              // Where do we splode?


	// Arming & Tasks //
	[Space(20)]
	[Header("     =============    ")]
	[Space(20)]
	[Tooltip("The Filename of the EventCard activated by a completed Task (if RunTaskEvent is set to true). NOTE: Conditions are SKIPPED!")]
	public string TaskEvent;
	[Header("     =============    ")]
	[Space(20)]
	[Tooltip("The info that regulates usage of this Interactive. Each Interactive requires at least one Task to be usable.")]
	public DestroyTask[] Tasks;


	[System.Serializable]
	public class DestroyTask : ProxyObj_Interact.TaskBase
	{

		[Space(10)]
		[Tooltip("Keep false if this Destructible does not heal damage.")]
		public bool Heal = false;

		[Tooltip("Seconds until this Destructible begins healing damage.")]
		[Range(0, 60)] public float Heal_Wait = 0f;    // Seconds til this thing begins healing damage.

		[Tooltip("Seconds until this Destructible would heal a fully empty bar. Value of 0 is instant.")]
		[Range(0, 60)] public float Heal_Speed = 0f;  // Seconds until a full bar would empty again. Rembember, a value of 0 means instant!

	}
}

