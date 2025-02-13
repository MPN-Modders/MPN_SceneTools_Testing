using UnityEngine;
using System.Collections.Generic;

public class Remover_WorldChange : MonoBehaviour
{
    [Space(15)]
    [Header("NOTE: This only updates between Scenes, NOT when World Change updates.")]

    // CONVERT
    [Tooltip("Stages that must have been beaten.")]
    public List<string> StagesRequired = new List<string>();
    [Tooltip("Stages that cannot have been beaten.")]
    public List<string> StagesForbidden = new List<string>();
    [Tooltip("Stages that must have been played (win or lose).")]
    public List<string> StagesPlayed = new List<string>();

    [Space(10)]
    [Tooltip("Deactivate instead of destroy.")]
    public bool DisableOnly = false;

    [Tooltip("All of these must be TRUE in order to enable this object.")]
    public List<string> RequiredChanges = new List<string>();
    [Tooltip("If any of these are true, then this cannot be on.")]
    public List<string> ForbiddenChanges = new List<string>();
}