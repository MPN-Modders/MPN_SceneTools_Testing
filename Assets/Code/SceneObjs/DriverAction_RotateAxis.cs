using UnityEngine;
public class DriverAction_RotateAxis : DriverAction_AXIS
{
	// Rotate around the specified axis.
	private void Reset() { Axis = Vector3.up; } // Set to UP instead of FORWARD when component is added.

}