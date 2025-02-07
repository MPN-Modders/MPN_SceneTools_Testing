using UnityEngine;

public class CustomAddon_ToggleAutomator : SceneObj
{
    [Header("   !! PLACE ON CUSTOM TOGGLABLE !!")]
    [Space(20)]

    public bool AutomatorEnabled = true;
    [Space(10)]
    public bool OnlyRunDuringWaves;
    public bool RunInActiveRoomOnly = true;
    [Space(10)]
    [Tooltip("Time (in Frames) for the Togglable to stay in its Down state.")]
    public float TimeStayDown = 60;
    [Tooltip("Time (in Frames) for the Togglable to stay in its Up state.")]
    public float TimeStayUp = 60;
    [Tooltip("Time (in Frames) before the Togglable will begin to automate.")]
    public float StartTime = 0;
}