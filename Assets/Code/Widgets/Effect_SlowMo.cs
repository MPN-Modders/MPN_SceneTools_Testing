using System;
using UnityEngine;

public class Effect_SlowMo : MonoBehaviour
{
    [Tooltip("Multiplier for TimeScale (0.5 is 50% speed, etc.)")]
    [Range(0.001f, 1)]
    public float TimeScaleChange = 0.25f;
    [Tooltip("Rate that TimeScale returns to normal (higher is faster).")]
    [Range(0.001f, 1)]
    public float TimeCatchup = 0.05f;
}