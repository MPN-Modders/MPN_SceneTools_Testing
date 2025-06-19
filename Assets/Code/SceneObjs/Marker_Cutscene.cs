using UnityEngine;
using System.Collections.Generic;

public class Marker_Cutscene : Marker
{
	[Space(10)]
	[Tooltip("The name of the CutsceneCard to use here.")]
	public string AttachCutsceneCard;

	[Space(5)]
	[Header("      ------------- ")]
	[Space(10)]
	[Tooltip("The cameras available (via their index) to the Steps on your CutsceneCard. NOTE: These cameras can exist elsewhere in the scene (so multiple Cutscenes can access them), but if they're parented to this Marker, they MUST be a direct child of it, or be annihilated.")]
	public Camera[] ViewCams = new Camera[0];      
	[Tooltip("The Marks that indicate where Cutscene actors will walk or teleport to, as commanded. Like with ViewCams, these are accessed by index via your attached CutsceneCard, and can either exist in the scene itself or as a direct child of this Marker.")]
	public GameObject[] Marks = new GameObject[0]; 

	[Space(10)]
	[Tooltip("On complete, mark this WorldChange as TRUE for the career. If used, this Cutscene will only run once EVER for this save (unless the WorldChange is set back to FALSE).")]
	public string WorldChange = "";           
	[Tooltip("Higher priority cutscenes will interrupt lower priority ones, and will prevent lower priority cutscenes from starting.")]
	public int CutscenePriority = 0;

	// Startup Data //
	public bool Unskippable = true;
	[Tooltip("If TRUE, conversation will be as Narration. If FALSE, it will be overhead Chatter.")]
	public bool DialogAsNarration = false;
	[Tooltip("If TRUE, Cutscene won't fire if any AssignedActors are missing or unassigned. If FALSE, it happens no matter what. Their lines will just be skipped.")]
	public bool AllActorsRequired = true;
	[Tooltip("If TRUE, Cutscene will begin as soon as Player enters Room or Area (as set by StartCondition), regardless of who the Actors are. If FALSE, all AssignedActors must be in the Area or Room.")]
	public bool PlayerOnlyActivation = false;
	[Tooltip("If TRUE, this Cutscene will sort through all Steps and run their StepActions and TrackedEvents if the scene was cancelled.")]
	public bool RunActionsOnCancel = false;
	[Tooltip("Unless you're a player, this cutscene won't start if you're in combat.")]
	public bool SkipInCombat = false;
	[Tooltip("If true, events can target this cutscene again (if it still exists)")]
	public bool AmReplayable = false;


	[Tooltip("Option to disable controls for participating actors, as well as the Player (regardless of being in the cutscene).")]
	public DisableControlsList DisableControls = DisableControlsList.None;

	[Tooltip("Time in seconds until the the cutscene will appear to start once activated.")]
	public float StartDelay = 1.5f;

	[Tooltip("How much to take over Game Cam. Some Cutscenes may only take the camera slightly.")]
	[Range(0, 1)] public float CameraWeight = 1;
	[Tooltip("The camera smoothing at the start (x value) and end (y value) of the cutscene.")]
	public Vector2 CameraChangeFrames = new Vector2(30, 30);

	[Tooltip("Room and Zone mean the enabling character must be in the same room or event zone respectively. EventOnly cutscenes will not fire until the Event System tells them to.")]
	public StartConditions StartCondition = StartConditions.Room;
	[Tooltip("Linked Event Zone that will launch this cutscene (when StartCondition is set to Zone)")]
	public Zone_Event StartZone;
	public bool ClearMoveOrdersOnComplete = true;

	[Space(20)]
	[Tooltip("The SerialNumbers of the actors involved in this cutscene. To target the player squad members, use PSQUAD0, PSQUAD1, etc.")]
	public List<string> ActorSerials = new List<string>();
	[Tooltip("Can we look up and use actors not included in our main list when they appear on a CutsceneStep?")]
	public bool AllowOutsideActors = false;
	[Tooltip("When a Step in this cutscene fires off the \"ForceActorList\" action, all Actors will be wiped and replaced with new ones (as needed). All entries must be the Filename of a Character MadCard.")]
	public List<string> ForceNewPlayerSquad = new List<string>();

	private void Update()
	{
		// Only here so we can disable the Cutscene's script!
	}
}