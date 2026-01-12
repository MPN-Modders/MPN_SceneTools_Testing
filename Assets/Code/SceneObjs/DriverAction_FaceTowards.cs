using UnityEngine;
public class DriverAction_FaceTowards : DriverAction_TARGETED
{
	// Rotate toward the target type.

	[Tooltip("You can constrain your rotation to \"zero out\" an axis (usually Y). This is functionally like rotating ONLY around that axis. Only works if no Rigidbody assigned to this script.")]
	public MuteAxes MuteLocalAxis = MuteAxes.NONE;
	[Tooltip("Any value above 0 will limit how far this object can rotate away from its original local rotation, in degrees.")]
	public float MaxAngle = 0;
}