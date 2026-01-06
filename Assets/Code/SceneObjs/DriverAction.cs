using UnityEngine;

public abstract class DriverAction : MonoBehaviour
{
	public enum MuteAxes { NONE, X, Y, Z }
	public enum AxisTypes { Mine, Parent, Global }
	public enum TargetTypes
	{
		// Global Targets
		Target, Player, WaypointPos, UserAim,
		// FaceTowards ONLY
		WaypointDir = 100, VesselAxis
	}

	private void Update() {} // Only here so the component can be enabled/disabled via Animator!
}
public class DriverAction_PHYSICS : DriverAction
{
	[Tooltip("The linked Transform that will be affected by these operations. Will default to attached object if not specified.")]
	public Transform MyTransform;
	[Tooltip("The linked Rigidbody that will be affected by these operations. Skipped if not assigned.")]
	public Rigidbody MyRigidbody;
	[Tooltip("General force multiplier.")]
	public float Speed = 5;
	public enum ActiveWhen { TouchingFloor, NotTouchingFloor, Always, Never }

	[Tooltip("This DriverAction will have no influence if the Vessel doesn't match the current Floor-contact status.")]
	public ActiveWhen AmActiveWhen = ActiveWhen.TouchingFloor;
}
public class DriverAction_DIVERSE : DriverAction_PHYSICS
{
	[Tooltip("Applies this DriverAction as physics forces if it has a Rigidbody that isn *not* set to Kinematic.")]
	public bool ForcesAsPhysics = true;
}
public class DriverAction_AXIS : DriverAction_DIVERSE
{
	public Vector3 Axis = Vector3.forward;
	public bool NormalizeAxis = false;
	public AxisTypes UseAxis = AxisTypes.Global; // If TRUE, we use the axis of the parent instead of our own right/up/forward.
}
public class DriverAction_TARGETED : DriverAction_DIVERSE
{
	public TargetTypes TargetType = TargetTypes.Target;
	public Vector3 VesselAxis = Vector3.forward; // The local direction of our linked Vessel.
}