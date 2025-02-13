using UnityEngine;
using System.Collections.Generic;


public class Remover_Random : MonoBehaviour
{
    [Range(0, 1)]
    [Header("Chance of Removal")]
    public float RandomChance = 0.5f;
}