using UnityEngine;
public class DriverAction_Jump : DriverAction_PHYSICS
{
    [Tooltip("While enabled, Lift will continue to be applied as an upward force. Note that this force will continue to apply even if the AmActiveWhen check fails.")]
    public Vector3 Lift = Vector3.zero;
}