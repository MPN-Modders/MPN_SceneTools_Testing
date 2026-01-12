using UnityEngine;

public class CustomObj_Vessel : MonoBehaviour
{

    [Tooltip("The Filename of the DriverCard to use here.")]
    public string DriverCard;
    public ProxyObj_Seat LinkedSeat;
    [Tooltip("Optional Destructible to represent the \"Health\" of this Vessel.")]
    public CustomObj_Destructible LinkedDestructible;
    [Tooltip("Cycle current Waypoint with WaypointTick() and WaypointSet() Animation Events in the VesselAnimationEvents script. Used by DriverCard for some Driver Checks.")]
    public Marker_Waypoint[] PathPoints = new Marker_Waypoint[0];

    [Tooltip("For determining valid targets with the FindTarget() Animation Event on the VesselAnimationEvents script.")]
    public Factions Faction = Factions.Enemy;
    [Tooltip("All Animators that will accept parameter changes from attached DriverCard.")]
    public Animator[] LinkedAnimators = new Animator[0];

    [Tooltip("(Player only): The aim reticle will be visible while occupying this Seat.")]
    public bool AimReticleOn = false;
    [Tooltip("If Player One is occupying LinkedSeat, this will be where the game camera focuses.")]
    public Transform PlayerUserFocalPoint;  
    [Tooltip("If assigned, the Y position of this Vessel will always be the same as FloorReference.")]
    public Transform FloorReference;        
    [Tooltip("If assigned, the Y position of this Vessel will always snap to the closest point above FloorCollider.")]
    public Collider FloorCollider;          
    [Tooltip("Force this Vessel to always remain upright.")]
    public bool EnforceUpY = false;
    [Tooltip("These colliders will ignore collisions with the user of a linked Seat.")]
    public Collider[] CollidersIgnoreUser = new Collider[0];
    [Tooltip("Rigidbody collisions with terrain will multiply the speed of impact by this multiplier, and then apply as damage to a linked Destructible.")]
    public float CollisionDamageMult = 1;
    [Tooltip("Collision strength with terrain must be at or above this value for the hit to count as damage, or trigger the Collision check.")]
    public float ImpactThreshold = 5;
}