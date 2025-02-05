using UnityEngine;
using System.Collections.Generic;

public class ProxyObj_Locker : ProxyObj
{
    public ProxyType Type;

    public enum ProxyType
    {
        Standard = 0,
        Foot,
        Short,
        Wide,

        Pegboard = 100,
    }

    [Tooltip("The MadCards of the items in this locker.")]
    public List<string> Contents = new List<string>();

    // EVENTS
    [Space(20)][Header("     =============    ")][Space(20)]
    [Tooltip("The Filename of the EventCard activated by opening this Locker. NOTE: Conditions are SKIPPED!")]
    public string LockerEvent;
}
