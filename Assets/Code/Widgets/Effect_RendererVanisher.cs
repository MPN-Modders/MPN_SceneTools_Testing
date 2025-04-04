using UnityEngine;

public class Effect_RendererVanisher : MonoBehaviour
{
    public Transform centerPointCheckFrom;
    public Transform VanisherCeiling;
    public Collider VanishArea;
    public bool VanishWhenBehindPoint = true;       // The default. Vanish when behind point.
    public bool VanishWhenBelowCeiling = true;      // Extra. Vanish below/above VanisherCeiling

    public bool VanishForever = false;
    public bool InvertChecks = false;   // This means vanisher turns ON when in the area, or below the ceiling, etc

    [Header("2 Layers: ON and OFF(Blank to Ignore)")]
    public string[] OnOffLayers = new string[2];
    [Header("These Renderers turn ON when my renderers turn OFF")]
    public Renderer[] myEnableRenderers = new Renderer[0];
    public Renderer[] myDisableRenderers = new Renderer[0];
    public GameObject[] myDisableGOs;
    public GameObject[] myEnableGOs;
}
