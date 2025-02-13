using UnityEngine;

public class Effect_RendererEnabler : MonoBehaviour
{
    public bool DoNotRegisterToRoom = false;
    public bool MustBeCameraVisible = false;
    [Tooltip("Characters as well as anything in the Debris and Obstacle layers will also block this object from the camera.")]
    public bool BlockedBySmall = false;
    [Tooltip("Check camera obstruction by Raytracing a line from me-to-camera, rather than camera-to-me.")]
    public bool InvertCamViewCheck = false;     // Check from me to cam instead of cam to me. Used by Cloning Tank to see outward from glass tube.
    [Tooltip("Starts at Scale 0,0,0 when reenabling.")]
    public bool AppearsScaledDown = false;      // When Enabled, does this Renderer start scaled down from zero?
    [Tooltip("Buffer to begin checking if a collider is blocking the camera.")]
    public float startCheckDistance = 0;        // How far from my position toward camera are we checking for light block/collision?  (ex: Cloning Tanks)   !!** Only useful when MustBeCameraVisible is ON **!!
    [Tooltip("Increase the distance from camera before RendererEnabler vanishes.")]
    public float distanceDisableMultiplier = 1; // NOTE: Nope, this doesn't seem to do this anymore --> Distance at which this effect switches off entirely.
    private void Update() { } // EMPTY: This is so you can disable the script if desired.
}
