using UnityEngine;
using System.Collections.Generic;


public class Remover_WaveCheckpoint : MonoBehaviour
{
    [Range(-1, 100)]
    [Tooltip("Leave at -1 for no min value.")]
    public int Imprint_Min = -1;
    [Range(-1, 100)]
    [Tooltip("Leave at -1 for no max value.")]
    public int Imprint_Max = -1;

    [Range(-1, 10)]
    [Tooltip("Leave at -1 for no min value.")]
    public int Checkpoint_Min = -1;
    [Range(-1, 10)]
    [Tooltip("Leave at -1 for no max value.")]
    public int Checkpoint_Max = -1;
    [Space(10)]
    [Tooltip("If TRUE, we remove the attached object if the above conditions are met. Otherwise on FALSE, we leave the attached object alone.")]
    public bool RemoveIfTrue = true;
}
