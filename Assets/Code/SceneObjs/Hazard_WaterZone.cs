using UnityEngine;

public class Hazard_WaterZone : MonoBehaviour
{
    public GameObject SplashEffect;
    public GameObject ExitSplashEffect;
    [Tooltip("Color of footprints characters will leave after exiting.")]
    public Color Footprints = new Color(2 / 5f, 1 / 5f, 1 / 8f, 0.75f);
    [Tooltip("Physical resistance to sinking. Lower leads to faster sinking.")]
    public float Buoyancy = 40;
    public bool Ragdoll = true;
    [Tooltip("After ~3 seconds, this Hazard will send a character to this Zone_Dead as if they had fallen into it.")]
    public Zone_Dead LinkedDeadZone;
}