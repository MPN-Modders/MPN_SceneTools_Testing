using System;
using UnityEngine;

public class Effect_CamShake : MonoBehaviour
{
    public float ShakeAmount = 10f;
    [Tooltip("Does distance from camera affect the amount of shake?")]
    public bool RelativeToCamera = true;
    [Tooltip("If TRUE, camera will shake every time this script (or the GameObject it's attached to) is reactivated.")]
    public bool StayEnabled = false;
}