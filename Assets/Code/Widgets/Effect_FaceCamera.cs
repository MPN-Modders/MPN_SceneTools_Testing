using UnityEngine;

public class Effect_FaceCamera : MonoBehaviour
{
    [Tooltip("Use the Y value of our parent object when determining \"Up\". Ignores MyUp below.")]
    public bool UseLocalUp = false;
    [Tooltip("The back of this object will face the camera instead.")]
    public bool InvertForward = false;
    [Tooltip("Which direction is \"Up\" for your effect.")]
    public Vector3 MyUp = Vector3.up;
    private void Update() { } // EMPTY: This is so you can disable the script if desired.
}
