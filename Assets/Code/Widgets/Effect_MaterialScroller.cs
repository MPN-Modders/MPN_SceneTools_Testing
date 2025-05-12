using UnityEngine;
using System.Collections.Generic;

public class Effect_MaterialScroller : MonoBehaviour
{
    [Tooltip("The number of seconds (per axis) until that axis has looped back to the beginning.")]
    public Vector2 Shift = new Vector2(1, 1);
    public bool RandomStartOffset = false;

    [Tooltip("Properties of all Materials on the attached object to scroll. Project Nexus mostly uses \"_MainTex\", \"_CubeMap\", and \"_BumpMap\" for its default Materials.")]
    [Space(10)]
    public List<string> Properties = new List<string>() { "_MainTex", "_CubeMap", "_BumpMap" };

    [Tooltip("Materials must match these names to qualify. Leave empty to include all Materials.")]
    [Space(10)]
    public List<string> ValidMaterials = new List<string>();
}

