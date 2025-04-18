using UnityEngine;
using System.Collections.Generic;

public class Zone_GetOut : MonoBehaviour
{
    public Collider myCollider;
    public ExitTypes AffectedTypes = ExitTypes.Bots;

    public bool Unskippable = false;
    public bool LeapForSafety = false;
    [Tooltip("After using this Zone, the user will lose their attack target.")]
    public bool ForgetMyTarget = false;
    [Tooltip("(OPTIONAL) Area to flee to after entering myCollider.")]
    public Collider SafeZone;
    [Tooltip("If SafeZone is undefined, send user this far away from myCollider.")]
    public float DangerRange = 6;
    public bool SprintLeave = true;
    [Tooltip("Override all state restrictions, such as dodging or being ragdolled.")]
    public bool AffectAllStates = false;
    [Tooltip("Ignore if the user already has an order from elsewhere that will lead them out of myCollider's area.")]
    public bool IgnoreHasOrdersToLeave = false;
    [Tooltip("Only Combat-aware enemies are affected. Note that NPCs with a Bot-type AI are always aware already.")]
    public bool NPCsMustBeAware = false;
    [Tooltip("User will forget any move orders they've been assigned.")]
    public bool ClearOrdersInMe = false;
}