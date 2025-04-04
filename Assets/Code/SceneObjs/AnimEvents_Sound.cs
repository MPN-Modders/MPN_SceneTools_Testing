using UnityEngine;
using System.Collections.Generic;

public class AnimEvents_Sound : MonoBehaviour
{
    // Attach this to an Animator object so it can play sounds as registered.
    // Then PlaySound(int) can be added as an event in that animation.
    public List<string> mySounds;
    public List<float> myVolMod;
    public bool playFromMyPosition = true;
    public bool amStationary = true;
    public bool mustBeSeenByCamera = false;
    public Transform override_PlayFromThisObject;
    public float SoundEventVolMult = 1;

    public void PlaySound(int i)
    {
        // Play the sound in mySounds[i].
    }
    public void SoundEvent(string inSound)
    {
        // Play the sound event specified.
    }
    public void CreationEvent(Object inObject)
    {
        // Create an Object at moment of impact.
    }
}