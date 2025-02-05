using UnityEngine;
using System.Collections.Generic;

public class CustomObj_Cover : ProxyObj_Cover
{
    [Space(5)]
    [Header(" == CUSTOM OBJECT == ")]
    [Space(20)]


    [Tooltip("Does this cover prevent the user from taking any damage from their front-facing arc?")]
    public bool InvincibleFront = true;

    [Tooltip("Animation (by name) to use when using this cover.")]
    [Space(5)]
    public string AnimUse = "idle_generic_cover_1";
    [Tooltip("Animation (by name) for leaping over this cover. Leave empty to prohibit vaulting.")]
    public string AnimVault = "Anim_Vault";

    [Tooltip("Point where a user can snap into cover.")]
    [Space(5)]
    public List<Cover_Point> CoverPoints;
}
