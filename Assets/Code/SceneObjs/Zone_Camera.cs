using UnityEngine;

public class Zone_Camera : Marker
{
    // RULES:
    // -You can resize and move the trigger area freely, but don't rotate the Zone_Camera or any trigger areas.
    // -The trigger area can be duplicated inside the Zone_Camera as many times as needed to cover
    // -Place in the Waypoints "folder" of your room or it will not be found by the game.

    [Space(10)]
    [Space(10)]
    [Header(" area, but they may not be rotated!")]
    [Header(" RULE: You can duplicate, resize, and move the trigger")]
    [Tooltip("Inactive zones are enabled by the Event System.")]
    [Space(10)]
    public bool AmActive = true;        
    [Space(10)]
    [Tooltip("For tiebreaking when more than one zone is affecting the camera.")]
    public float Priority = 0;          // Priority given to highest first. Room sorts this based on Priority.
    public bool IgnoreWhenMultiplayer = false;
    [Tooltip("Like the CameraPoint of a room.")]
    public Camera CameraPoint;
    [Tooltip("The number of frames it takes the camera to transition into and out of this zone's control.")]
    public float TransitionFrames = 40; 

    [Range(0, 1)]
    [Space(10)]
    [Tooltip("How much the zone will move the camera.\n0 is a fully stationary camera.")]
    public float StationaryModifier = 1;    // How much to allow you to move.
    [Range(0, 1)]
    [Tooltip("How much the camera is affected by this zone.")]
    public float Influence = 1;             // How much this camera will take over for the main camera. 1 is all the way. 0 lets the normal camera do its thing.
    [Range(0, 1)]
    [Tooltip("For softly transitioning into a zone.")]
    public float InfluenceByDistance = 0;   // Distance from Camera Target will lower the influence by this %.
    [Tooltip("How far from the center of the zone do we start tracking InfluenceByDistance.")]
    public float InfluenceDistanceStart = 3;// Only useful if IndluenceByDistance is being used (aka > 0)

    [Range(0, 1)]
    [Space(10)]
    [Tooltip("Individual mulipliers to camera movement along each axis.")]
    public float AxisMult_X = 1, AxisMult_Y = 1, AxisMult_Z = 1;            // X axis affects the influence how much?

    [Space(10)]
    public bool SnapCamOnEnter = false;         // Camera will still transition, but it won't use its own natural easing. This gets rid of all that camera smoothing and makes it just HAPPEN every frame.
    public bool SnapCamOnExit = false;      
    
    [Space(10)]
    [Tooltip("TriggerZone(s) don't track the player if they're this far away from this zone's center.")]
    public float DistanceCutoff = 200;              // How far you can go before we stop tracking.
    [Tooltip("Players with narrower/wider screens get more distance out of the zone.")]
    public bool CutoffTracksAspectRatio = true;   // People with narrower screens get more distance.


}