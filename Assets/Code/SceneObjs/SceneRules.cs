using UnityEngine;
using System.Collections.Generic;

public class SceneRules : MonoBehaviour
{
    [Header(" == EVENTS ==")]
    [Tooltip("The EventCards to automatically load into the scene, by Filename.")]
    public List<string> EventCards = new List<string>();

    [Header(" == ARENA ==")][Space(20)]
    [Tooltip("Optional: Waves will not automatically start unless this interactive has been used.")]
    public ProxyObj_Interact ArenaStartButton;
    [Tooltip("Lock/Unlock these Interactives automatically during/after waves.")]
    public List<ProxyObj_Interact> LockedDuringWaves = new List<ProxyObj_Interact>();
    [Tooltip("The Interactives and/or Destructibles the player should protect during Siege stages. Only targets that are CURRENTLY ACTIVE will be assigned to the current attackers.")]
    public List<ProxyObj_Base> SiegeTargets = new List<ProxyObj_Base>();
    [Tooltip("How many siege targets can be destroyed until the player loses.")]
    public int SiegeTargetsTilFail = 3;
    [Tooltip("The warnings for if a siege target was destroyed, used, or is being used now.")]
    public string[] SiegeTargetWarnings = new string[] { "has been lost!", "was activated!", "is being disabled!" };
    public string SFX_SiegeTarget;
    public string SFX_StartWave;
    public string SFX_EndWave;
    [Tooltip("Volume Multiplier for Start/End Wave SFX")]
    public Vector2 WaveSound_Volume = new Vector2(0.6f, 0.6f); // Wave Start/End
    [Tooltip("On Arena victory, the first cutscene the game finds in this list will play. Use object removers to destroy any cutscenes you don't want to play.")]
    public List<Marker_Cutscene> EndCutscenes = new List<Marker_Cutscene>();

    private void OnValidate()
    {
        for (int i = 0; i < SiegeTargets.Count; i++)
            if (SiegeTargets[i] != null && !(SiegeTargets[i] is ProxyObj_Interact) && !(SiegeTargets[i] is CustomObj_Destructible))
            {
                SiegeTargets[i] = null;
                Debug.LogWarning("SiegeTargets list may only contain Destructibles and Interactives!");
            }
    }
}