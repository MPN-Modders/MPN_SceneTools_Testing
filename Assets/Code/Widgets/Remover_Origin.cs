using UnityEngine;
using System.Collections.Generic;


public class Remover_Origin : MonoBehaviour
{
    // CONVERT
    public List<string> Required = new List<string>();
    public List<string> Forbidden = new List<string>();

    [Space(5)]
    [Tooltip("Wizard Origin uses this to have certain things only happen the FIRST time you play them.")]
    [Space(-8)]
    [Header("    ...Required WILL delete if you PLAYED it before.")]
    [Space(-8)]
    [Header("    ...Forbidden WON'T delete if you PLAYED it before.")]
    [Space(-8)]
    [Header("If TRUE:")]
    [Space(10)]
    public bool InvertOnSecondPlay = false;

}