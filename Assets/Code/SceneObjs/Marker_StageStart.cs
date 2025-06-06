using UnityEngine;
using System.Collections.Generic;

public class Marker_StageStart : Marker
{
    [Space(10)]
    [Tooltip("The Filename of the Custom Stage MadCard to use.")]
    public string Stage;

    [Space(10)]
    [Tooltip("All of these WorldChanges (Event System) must be TRUE for the StageStart to appear.")]
    public List<string> WorldChanges_PrerReq = new List<string>();
    [Tooltip("All of these WorldChanges (Event System) must be FALSE for the StageStart to appear.")]
    public List<string> WorldChanges_Forbid = new List<string>();

    [Space(10)]
    [Tooltip("Place a quest marker on this StageStart if the player has not beaten it yet.")]
    public bool AmQuestIfUnbeaten = true;
}