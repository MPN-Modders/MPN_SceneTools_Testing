using UnityEngine;
using System.Collections.Generic;

public class Object_Randomizer : MonoBehaviour
{
    [Tooltip("The pool of objects that will be randomly enabled or disabled.")]
    public List<GameObject> RandomizedObjects = new List<GameObject>();
    [Tooltip("How many objects from your list to leave enabled.")]
    public int EnableCount = 1;
    [Tooltip("If TRUE, we randomize only once when this script's object loads. If FALSE, the objects will be re-randomized every time this script's object becomes enabled (including on load).")]
    public bool RandomizeOnce = true;
}