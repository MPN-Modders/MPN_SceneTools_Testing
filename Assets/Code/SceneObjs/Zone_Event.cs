using UnityEngine;
using System.Collections.Generic;

public class Zone_Event : AreaZone
{

    [Space(10)]
    [Tooltip("Only the Player can trigger this Zone.")]
    public bool PlayerOnly;

    // EVENTS
    [Space(20)][Header("     =============    ")][Space(20)]
    [Tooltip("The Filename of the EventCard activated by a completed Task (if RunTaskEvent is set to true). NOTE: Conditions are SKIPPED!")]
    public string TaskEvent;
    [Header("     =============    ")][Space(20)]
    [Tooltip("The info that regulates usage of this Zone.")]
    public ZoneTask[] Tasks;


    [System.Serializable]
    public class ZoneTask : ProxyObj_Interact.TaskBase
    {
        [Tooltip("If True, ignore other tracking and only check if object is Player.")]
        [Space(15)]
        public bool TrackPlayer;           
        [Tooltip("The SerialNumber of the Character or Weapon. Ignored if TrackPlayer is True.")]
        public string TrackSerialNumber;
        [Tooltip("The Faction of the Character. Ignored if TrackSerialNumber is not empty.")]
        public Factions TrackFaction;         
        [Tooltip("The number of qualified entrants required before the Task is complete. Any value lower than 1 is assumed to be 1.")]
        public int Amount;
        [Space(10)]
        [Tooltip("Inverts the Task to track when a valid target leaves the area instead of enters.")]
        public bool TrackOutsideArea;

        [Tooltip("Visualize the Timer, if using.")]
        [Space(10)]
        public bool DisplayTimer;
        [Tooltip("The name to appear above the Timer, if any.")]
        public string TimerName;
        [Tooltip("Time in frames for the Timer to last.")]
        public float TimerLength;

    }
}