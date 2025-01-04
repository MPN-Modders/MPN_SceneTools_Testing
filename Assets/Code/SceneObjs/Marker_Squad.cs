using UnityEngine;
using System.Collections.Generic;

public class Marker_Squad : Marker_DataAssigner
{
    [Space(6)]
    [Header("\tSQUAD ASSIGNMENT")]
    [Space(20)]
    public float SecondsInRoomTilSpawn = 2;
    public List<ProxyObj_REPOSITORY> SpawnFromDoors;
    
    [Space(10)]
    public SpawnRules SpawnRequirement = SpawnRules.None;   
    public SpawnRules SpawnRestriction = SpawnRules.None;   

    [Space(10)]
    [Tooltip("Multiplier to the time between spawning squads.")]
    public float SpawnFrequencySlowdownMult = 1;
    [Tooltip("Never stop spawning (unless an event disables me).")]
    public bool NeverendingWaves = false;                   
    public bool SpawnDuringCutscenes = false;				
    [Tooltip("Allies in the room affect when these dudes want to spawn, and can prevent it. This spawner will ignore that.")]
    public bool IgnoreFactionAllyCount = false;
    
    [Space(10)]
    [Tooltip("NewTandem: Create a brand new series of squads that will spawn at their own pace.\n\nAddToMatchingFaction: Join an already existing wave of enemies.\n\nMissionWaves:Like NewTandem, but uses the Start/EndText values below and fully locks down the room.")]
    public TandemTypes WaveSpawnType = TandemTypes.NewTandem;
    [Tooltip("Text that plays during MissionWaves spawn type.")]
    public string StartText = "", StartText_Sub = "", EndText = "", EndText_Sub = "";


    [Space(20)]
    public WaveSpawn_STP Wave;

    public enum TandemTypes { NewTandem, AddToMatchingFaction, MissionWaves };
    public enum SpawnRules { None, MyFactionPresent, MyFactionAlerted }
}


    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [System.Serializable]
    public class WaveSpawn_STP
    {
        [Tooltip("Used by Wave_Generator to estimate squad size. Squads cannot be bigger than this value.")]
        public int MaxSquadSize = 4;    
        [Tooltip("Used by Wave_Manager. What's the cutoff for guys on screen? (Note: If no guys on screen, the next squad will spawn no matter its roster count).")]
        public int MaxUnitCount = 8;    

        [SerializeField]
        public List<WaveCharacter_STP> WaveUnits = new List<WaveCharacter_STP>();

        [SerializeField]
        [Tooltip("Loadouts to pull weapons from.")]
        public List<WeaponLoadout_STP> WeaponStock = new List<WeaponLoadout_STP>();
        [Tooltip("Randomize the order of weapons taken from all WeaponStock, but the SAME WAY each time.\n\nThis means every time you play, your wave will spawn with the same exact (randomized) weapons.")]
        public int WeaponStock_RandomSeed = 0;     

        [SerializeField]
        [Tooltip("Rules for assigning weapons to squads, by spawn number.\n\nIgnorePref: Squad won't use their WeaponPrefs to pick weapons. \n\nMelee, Ranged, ForceUnarmed: Set the squad to pick from this weapon type.\n\nInvertedPick: The squad will take its weapon from the front of the weapon list rather than the end.")]
        public List<WeaponDraft_STP> WeaponDrafts = new List<WeaponDraft_STP>();

        [SerializeField]
        public List<SingleCharacter_STP> Bosses = new List<SingleCharacter_STP>();

        [SerializeField]
        public List<WaveSquad_STP> CustomSquads = new List<WaveSquad_STP>();
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
        public class Character_STP
        {
            public string MadCard = "NONE";
            public CharacterTypes Character;

        }
    [System.Serializable]
    public class WaveCharacter_STP : Character_STP
    {
        public int Total;
        [Range(0, 1)]
        [Tooltip("The even-ness of squads having some of every Unit Type in it. At 0, all types will be spread evenly throughout. At 1, the higher levels won't generate until the ones below them are spent. At 0.5, squads will gradually stop including earlier characters in the list, and increase in later ones as squads are formed.")]
        public float GenerationScale = 0.5f;
    }
    [System.Serializable]
    public class SingleCharacter_STP : Character_STP
    {
        public string SerialNumber;
        public string Weapon;
        public string Sidearm;
        public string Throwable;
        public string Key;
        public List<string> Gear = new List<string>();
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [System.Serializable]
    public class WeaponLoadout_STP
    {
        public string MadCard = "NONE";
        public LoadoutPools Loadout;
        public int Count;
        public enum LoadoutPools
        {
            Unarmed, Melee_ALL, Melee_HUGE, Melee_T2, Melee_T4, Melee_T6, Melee_T8, MERCs_T3, MERCs_T5, NEXUS_T5, NEXUS_T6_Melee, NEXUS_T7_Ranged, NEXUS_T8, Ranged_ALL, Ranged_T2_Pistol,
            Ranged_T3_Pistol, Ranged_T5_Pistol_Shot, Ranged_T5_SMG, Ranged_T7_SMG, Ranged_T8_Rifle, ROBOT_T3, Street_T2_Toughs, Street_T5_Hunters, Tools_T1, Tools_T3_MERC, Tools_T4_BANDIT, Tools_T6,
        }
    }
    [System.Serializable]
    public class WeaponDraft_STP
    {
        public enum DraftTypes { IgnorePref, Melee, Ranged, ForceUnarmed, InvertedPick, None = 50 }; // Default has guys auto-generate their preferred Main and Sidearms. InvertedPick has guys draw weapons from the lowest tier rather than the highest.
        [Tooltip("Rules for assigning weapons to squads, by spawn number.\n\nIgnorePref: Squad won't use their WeaponPrefs to pick weapons. \n\nMelee, Ranged, ForceUnarmed: Set the squad to pick from this weapon type.\n\nInvertedPick: The squad will take its weapon from the front of the weapon list rather than the end.")]
        public DraftTypes Type;
        public int SquadNumber;
    }
    [System.Serializable]
    public class WaveSquad_STP
    {
        public int SpawnOrder = 0; // When to interject this squad into the wave. If more than the number of squads, it will spawn last.
        [SerializeField]
        public List<SingleCharacter_STP> SquadUnits = new List<SingleCharacter_STP>();
    }



