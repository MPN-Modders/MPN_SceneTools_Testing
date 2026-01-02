using UnityEngine;

public class DriverAction_Stabilizer : DriverAction_DIVERSE
{
	// Attempt to keep the up direction of the Vessel/Automaton pointing upward.
	private void Reset() { AmActiveWhen = ActiveWhen.Always; } // Set to ALWAYS when component is added.

	public AxisTypes UseAxis = AxisTypes.Global; // If TRUE, we use the axis of the parent instead of our own right/up/forward.
}