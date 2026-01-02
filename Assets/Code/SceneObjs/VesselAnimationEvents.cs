using UnityEngine;
public class VesselAnimationEvents: MonoBehaviour
{
    // Placed on the main animator or any sub-animators within a Vessel or Automaton.
    // Links back to the Vessel/Automaton, so when an animation event is called
    // from here, it will be called from the attached Automaton or Vessel instead.

    public void WaypointTick(int i)
    {
        // Cycles the current Waypoint (from the Vessel's PathPoints array).
        // "i" is how many steps the current Waypoint will advance (a value of 0 is interpreted as +1). Thus, if the current Waypoint is element 0 in the list, and i is 2, then Waypoint will advance to element 2.
        // Current Waypoint value wraps back to top or bottom of list if it goes too high or low.
    }
    public void WaypointSet(int i)
    {
        // Sets the current Waypoint to this specific element in the PathPoints array (REMEMBER: Arrays begin from element 0!)
        // If number is negative, then randomize.
        // Invalid values ignored.
    }
    public void RunEvent(string inFilename)
    {
        // Find and run an Event Card's Actions, by Filename.
    }
    public void FindTarget(int inEnum)  
    {
        // Determine a new Target for this Vessel. The values are:
        // [0] Player One, [1] Closest, [2] Furthest, [3] Healthiest, [4] Hurtest, [5] LastHitBy, [6] Random
    }
    public void FindTarget_PlayerSquad(int inPosition)
    {
        // Position is Player squad roster position, starting from 0.
        // This event action skips over dead characters, meaning it picks from the *current* list of characters.
        // Position wraps around: If inPosition is 3 and squad has 2 members, then member 1 will be returned.
    }
    public void ForgetTarget()
    {
        // Clear the Vessel's current target.
    }
    public void Teleport()
    {
        // Move instantly to the position + rotation of the Vessel's current Waypoint (see WaypointTick and WaypointSet above)
    }
    public void TeleportTo(int inWP)
    {
        // Move instantly to the position + rotation of the specific Waypoint in the Vessel's PathPoints array.
        // If number is negative, then randomize.
    }
    public void EjectSeat(int inRagdoll)  
    {
        // Linked Seat gets its occupant kicked out.
        // 0 runs their exit animation. 1 ragdolls them. 2 kills them. 3 gibs them.
    }
    public void DestroyMe()
    {
        // First, ragdoll user in Vessel's linked Seat (if any).
        // Then, Despawn this Vessel -OR- destroy the Vessel's linked Destructible (if any)
    }
    public void HealMe(int inAmount)
    {
        // Heal a linked Vessel's Destructible (if any) by this amount.
    }
    public void ClearTriggers()
    {
        // Resets all Mecanim Trigger parameters on all Linked Animators.
    }

}