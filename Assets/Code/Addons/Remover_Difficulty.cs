using UnityEngine;
using System.Collections.Generic;


public class Remover_Difficulty : MonoBehaviour
{
    public List<GameDifficulty> RemoveObjectOnTheseDifficulties = new List<GameDifficulty>();
    public List<GameObject> AffectTheseInstead = new List<GameObject>(); // If there are any objects in this, affect those. Otherwise, affect the object with this on it.
}