using UnityEngine;
using System.Collections.Generic;

public class CustomAddon_Vendor : SceneObj 
{
    [Header("   !! PLACE ON CUSTOM INTERACTIVE !!")]
    [Space(20)]

    [Tooltip("The name of this \"Store\" to appear at the top of the screen.")]
    public string Name = "Buy";
    [Tooltip("The style of Vendor to use.")]
    public MenuTypes Type = MenuTypes.Buy;
    public Currency UseCurrency = Currency.Cash;
    [Tooltip("Individual items cannot be removed by purchasing them (making them infinite).")]
    public bool AmShoppingList = true;
    [Tooltip("Item's Tier will be used when filling this Vendor.")]
    public bool EnforceTier = true;

    [Space(10)]
    [Tooltip("How to sort this Vendor amongst any other Vendors on the same Interactive.")]
    public int TabPriority = 0;
    [Tooltip("Default Filter to apply on load, if any (such as on Weapons or Armor).")]
    public int StartFilter = 0;

    [Space(10)]
    [Tooltip("The MadCards of the items in this Vendor.")]
    public List<string> Stock = new List<string>();


}