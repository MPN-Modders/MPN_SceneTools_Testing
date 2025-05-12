using UnityEngine;

public class Effect_RendererEnabler : MonoBehaviour
{
    [Tooltip("If FALSE, disables renderer when this Room is not the focus. Set TRUE to ignore Room.")]
    public bool DoNotRegisterToRoom = false;
    [Tooltip("Disable whden the camera's not viewing the attached renderer.")]
    public bool MustBeCameraVisible = false;
    [Tooltip("Characters as well as anything in the Debris and Obstacle layers will also block this object from the camera.")]
    public bool BlockedBySmall = false;
    [Tooltip("Check camera obstruction by Raytracing a line from me-to-camera, rather than camera-to-me.")]
    public bool InvertCamViewCheck = false;   
    [Tooltip("Starts at Scale 0,0,0 when reenabling.")]
    public bool AppearsScaledDown = false;     
    [Tooltip("Buffer to begin checking if a collider is blocking the camera.")]
    public float startCheckDistance = 0;        
    [Tooltip("Increase the distance from camera before RendererEnabler vanishes.")]
    public float distanceDisableMultiplier = 1;
    private void Update() { } // EMPTY: This is so you can disable the script if desired.
}
