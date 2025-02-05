using UnityEngine;


public class CustomObj_Togglable : ProxyObj_Togglable
{
    [Space(5)]
    [Header(" == CUSTOM OBJECT == ")]
    [Space(20)]

    [Tooltip("")]
    public Animator LinkedAnimator;
    //      ANIM EVENTS:
    // PlaySound(string)

    [Tooltip("Sound played when the Togglable is up/active.")]
    public string UpSound;      
    [Tooltip("Sound played when the Togglable is down/inactive.")]
    public string DownSound;
}
