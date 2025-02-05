using UnityEngine;
using System.Collections.Generic;


/// <summary>Place on the LinkedAnimator of a Custom Interactive so its animation clips can access these functions as animation events.</summary>
public class AnimEvents_Interact : MonoBehaviour
{
    public void CancelUsed()
    {
        // Sets Used status to false (but ONLY if it's got another Task ready to go!)
    }
    public void ForceAmInteractable()
    {
        // Override Interactive's usable state to TRUE. Resets on any state change.
    }
    public void TriggerMe()
    {
        // Complete the Interactive's current Task. Useful when WaitForMyAnimation is TRUE.
    }
}
