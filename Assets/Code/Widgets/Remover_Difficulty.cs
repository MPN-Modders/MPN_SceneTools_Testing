using UnityEngine;
using System.Collections.Generic;


public class Remover_Difficulty : MonoBehaviour
{
    public List<GameDifficulty> RemoveObjectOnTheseDifficulties = new List<GameDifficulty>();
    [Tooltip("Remove the objects in this list instead of the object with the Remover script on it.")]
    public List<GameObject> AffectTheseInstead = new List<GameObject>(); 
}