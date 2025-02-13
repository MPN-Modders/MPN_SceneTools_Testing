using UnityEngine;
using System.Collections.Generic;

public class Marker_Dummy : Marker
{
    [Space(10)]
    public string MadCard;
    public CharacterTypes Character;
    [Space(10)]
    [Tooltip("MadCards of armor pieces to wear.")]
    public string[] AdditionalArmor = new string[0];
    public List<UniformWearable_JSON> Uniforms = new List<UniformWearable_JSON>();
    [Tooltip("MadCards of weapons to hold.")]
    public string[] HeldInHands = new string[0];
    [Space(10)]
    public RuntimeAnimatorController Controller;
    [Tooltip("List of your blank/placeholder AnimationClips used in your Controller that you want replaced with animations of the same name from the game.")]
    public List<AnimationClip> ReplaceAnims = new List<AnimationClip>();
    [Tooltip("All AnimationClips will count as being in the ReplaceAnims list above, to be swapped out in the game.")]
    public bool ReplaceAll = false;
    [Space(5)]
    [Tooltip("Sets the \"PlayState\" integer in Mecanim to one of these values randomly. Add \"PlayState\" to your Dummy's controller to customize how they advance through the state machine.")]
    public int[] PlayStates = new int[0];
    [Tooltip("Start playing this Dummy's animation from one of these randomly selected states.")]
    public string[] StartStates = new string[0];
    [Tooltip("The states in your controller that your dummy will randomly pick from when responding to a hit.")]
    public string[] WinceStates = new string[0];
    public bool RandomizeStartTime = false;
    public bool PlaySounds;
    [Space(10)]
    public bool RemoveColliders = false;
    public bool AmHittable = true;

    [System.Serializable]
    public class UniformWearable_JSON
    {
        public List<string> ArmorPicks;
        public Color TintPrimary, TintSecondary, TintGlass;
        public int AltMaterial, AltMesh;
    }
}