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
	[Tooltip("If TRUE, adds force to the Rigidbody rather than directly setting it. Useful for when multiple DriverActions will affect the same Rigidbody. Just don't forget the drag values on your Rigidbody or you're gonna have a bad time.")]
	public bool AdditiveForce = false; 
}
public class DriverAction_AXIS : DriverAction_DIVERSE
{
	[Tooltip("The axis to rotate around (RotateAxis) or the direction to move (MoveAxis).")]
	public Vector3 Axis = Vector3.forward;
	[Tooltip("Axis will count as normalized no matter what.")]
	public bool NormalizeAxis = false;
	[Tooltip("Is the Axis relative to world space, local parent space, or the Vessel itself?")]
	public AxisTypes UseAxis = AxisTypes.Global; // If TRUE, we use the axis of the parent instead of our own right/up/forward.
}
public class DriverAction_TARGETED : DriverAction_DIVERSE
{
	[Tooltip("The thing to move or rotate towards.")]
	public TargetTypes TargetType = TargetTypes.Target;
	[Tooltip("Only used when TargetType is set to VesselAxis. This is the direction relative to the Vessel's current rotation (so, a VesselAxis of (0,0,1) would effectively be the Vessel's current forward).")]
	public Vector3 VesselAxis = Vector3.forward; // The local direction of our linked Vessel.
}