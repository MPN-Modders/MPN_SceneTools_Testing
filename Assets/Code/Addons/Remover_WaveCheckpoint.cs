using UnityEngine;
using System.Collections.Generic;


public class Remover_WaveCheckpoint : MonoBehaviour
{
    [Range(-1, 100)]
    public int Imprint_Min = -1;
    [Range(-1, 100)]
    public int Imprint_Max = -1;

    [Range(-1, 10)]
    public int Checkpoint_Min = -1;
    [Range(-1, 10)]
    public int Checkpoint_Max = -1;
    [Space(10)]
    public bool RemoveIfTrue = false;       // Invert the check.
}
