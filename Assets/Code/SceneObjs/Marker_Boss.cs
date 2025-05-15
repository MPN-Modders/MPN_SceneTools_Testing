using System.Collections.Generic;
using UnityEngine;

public class Marker_Boss : Marker_Character
{

	[Space(15)]
	[Header("\tBOSS PATTERNS")]
	[Space(15)]
	[Header("_____________________________________________")]
	public List<BossPatternData_STP> AllPatterns = new List<BossPatternData_STP>();

	[Space(10)]
	[Header("\tDETAILS")]
	public string BossDefeatSpeech;
	[Tooltip("If I would die, don't. Stagger me.")]
	public bool StaggerDeath;
}


[System.Serializable]
public class BossPatternData_STP
{
	[TextArea(1, 10)]
	public string BossSays;

	[Header("\tMODULES")]
	public bool WipeModulesEachPattern = false;
	[Tooltip("These modules will be added when we enter this Pattern. They won't be removed automatically when advancing Patterns.")]
	public List<string> ConstantModules = new List<string>();
	[Tooltip("Modules that will be removed when we enter this Pattern.")]
	public List<string> RemoveModules = new List<string>();
	[Tooltip("As I cycle through phases of this Pattern, these modules will be added and subtracted.")]
	public List<string> PhaseModules = new List<string>();
	[Tooltip("Give me these OneShots when I hit this Phase")]
	public List<string> OneShots = new List<string>();

	public List<BehaviorList> BehaviorAdd = new List<BehaviorList>();
	public List<BehaviorList> BehaviorRemove = new List<BehaviorList>();
	public List<TraitList> TraitAdd = new List<TraitList>();
	public List<TraitList> TraitRemove = new List<TraitList>();

	[Header("\tNODES")]
	[Tooltip("Currently only used by Gil's AI module. More versatile modules will be added for modders at a future date that use these waypoints.")]
	public Marker_Waypoint[] PhaseWaypoints = new Marker_Waypoint[0];

	[Header("\tBONUSES")]
	public List<BonusStats> PatternBonuses = new List<BonusStats>();

	[Header("\tEVENTS")]
	[Tooltip("")]
	public string CompletionEvent;
}


[System.Serializable]
public class BonusStats
{
	public string Name, Description;
	public BonusType Type;
	public float Amount;
	public bool AmPercent, ShowAsGood = true;
}


