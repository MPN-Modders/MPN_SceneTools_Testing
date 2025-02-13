using System;
using UnityEngine;

public class Effect_SoundEmitter : MonoBehaviour
{
    public System.String Event = "";
    [Space(5)]
    public EmitterGameEvent PlayEvent = EmitterGameEvent.ObjectEnable;
    public EmitterGameEvent StopEvent = EmitterGameEvent.ObjectDisable;
    [Space(5)]
    public bool AllowFadeout = true;
    public bool TriggerOnce = false;
    public bool Preload = false;
    [Tooltip("Alter the Parameters of your FMOD audio event here. Most default sounds do not use Parameters.")]
    [Space(5)]
    public ParamRef[] Params = new ParamRef[0];
    [Tooltip("Override the distance min/max cutoff for this audio. Leave negative for default values.")]
    [Space(5)]
    public float[] OverrideAttenuation = new float[] { -1, -1 };
    //
    public AudioTypes mySoundType = AudioTypes.Ambient;
    public bool EarsRelativeToViewTarget = false;
    public float rangeMult = 1;
    public float volumeMult = 1;
    public bool RestartSoundOnDisable = false;
    public bool DestroyOnDisable = false;
    [Tooltip("Force one-shot sounds to replay.")]
    public bool ForceLoop = false;
    public bool DisableOnStopped = false;
    public bool RandomizeStart = false;
    private void Update()
    {
        // EMPTY: This is so you can disable the script if desired.
    }
}
public enum AudioTypes { SFX, Music, Ambient, Any = 100 };
public enum EmitterGameEvent { None, ObjectStart, ObjectDestroy, TriggerEnter, TriggerExit, TriggerEnter2D, TriggerExit2D, CollisionEnter, CollisionExit, CollisionEnter2D, CollisionExit2D, ObjectEnable, ObjectDisable }
[System.Serializable]
public class ParamRef
{
    public string Name;
    public float Value;
}