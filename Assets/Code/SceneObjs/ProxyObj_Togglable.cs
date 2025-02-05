using UnityEngine;
using System.Collections.Generic;


public class ProxyObj_Togglable : ProxyObj_Base
{
    public ProxyType Type;

    [Space(5)]
    [Tooltip("On TRUE, this Togglable will begin in its UP state.")]
    public bool StartUp = false;
    [Tooltip("If TRUE, play the Up/Down animation when the scene loads rather than starting at its final position.")]
    public bool PlayFirstAnim = false;
    [Tooltip("Recalculate the room's nodes. Suggested for Togglables that block the walkable area of the room.")]
    public bool ResetPathNodes = false;
    [Tooltip("If the named WorldChange is TRUE (via the Event System), invert the StartUp value above.")]
    public string WorldChangeInvert = "";

    [Tooltip("These GameObjects are active when this Togglable is Up, and are inactive when Down.")]
    public List<GameObject> UpObjs;
    [Tooltip("These GameObjects are active when this Togglable is Down, and are inactive when Up.")]
    public List<GameObject> DownObjs;

    public enum ProxyType
    {
        INVIS = 0,

        Spikes = 20, Slab, Cage, Glass,

        Bridge = 50,

        Fanblade = 100,
    }
}