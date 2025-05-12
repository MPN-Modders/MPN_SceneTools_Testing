using UnityEngine;

public class Effect_RendererVanisher : MonoBehaviour
{
    [Tooltip("Vanish all contained renderers if the Player moves further into the distance (global Z axis) than this object." +
     " Note-A: If no object specified, the object with the script will be used. " +
     " Note-B: Using VanishArea (below) will negate and ignore this usage.")]
    public Transform centerPointCheckFrom;
    [Tooltip("Vanish all contained renderers if the Player moves below (global Y axis) this object.")]
    public Transform VanisherCeiling;
    [Tooltip("Vanish all contained renderers if the Player enters this area. IMPORTANT: This area should not be rotated, much like Zone_Camera. " +
         "However, the layer is unimportant, as M:PN only uses the bounding box.")]
    public Collider VanishArea;

    [Space(10)]
    [Tooltip("If FALSE, do not use \"centerPointCheckFrom\" whatsoever.")]
    public bool VanishWhenBehindPoint = true;       // The default. Vanish when behind point.
    [Tooltip("If FALSE, invert the \"VanisherCeiling\" check to disable when ABOVE the object instead.")]
    public bool VanishWhenBelowCeiling = true;      // Extra. Vanish below/above VanisherCeiling

    [Tooltip("Never re-enable after disabled.")]
    public bool VanishForever = false;
    [Tooltip("Invert ALL centerPoint/Ceiling/Area checks, so the renderers are on when they would otherwise be off, and vice versa.")]
    public bool InvertChecks = false;   // This means vanisher turns ON when in the area, or below the ceiling, etc

    [Space(10)]
    [Header("2 Layers: ON and OFF(Blank to Ignore)")]
    [Tooltip("If using, the attached object will also change its Layer in addition to vanishing." +
             " The first element in the array is for ENABLED, the second for VANISHED" +
             " (useful for changing how the object handles collision when on/off)." +
             " Leave either or both blank to ignore.")]
    public string[] OnOffLayers = new string[2];
    [Header("turn OFF (and so on).")]
    [Header("These Renderers turn ON when my renderers")]
    public Renderer[] myEnableRenderers = new Renderer[0];
    public Renderer[] myDisableRenderers = new Renderer[0];
    public GameObject[] myDisableGOs;
    public GameObject[] myEnableGOs;

}
