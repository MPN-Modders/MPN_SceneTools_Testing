using UnityEngine;
using System.IO;
using UnityEditor; // For Building Asset Bundles


public class AssetBundle_Builder_Editor
{
    static readonly string FileExt = ".sobj";

    [MenuItem("Madness/AssetBundle/ >> Build (Uncompressed)")]
    static void Build_Uncompressed()
    {
        BuildAllAssetBundles(BuildAssetBundleOptions.UncompressedAssetBundle);
    }
    [MenuItem("Madness/AssetBundle/ >> Build (Compressed) *RECOMMENDED*")]
    static void Build_Compressed()
    {
        BuildAllAssetBundles(BuildAssetBundleOptions.ChunkBasedCompression);
    }

    static void BuildAllAssetBundles(BuildAssetBundleOptions inBuildOption)
    {
        try
        {
            AssetBundle.UnloadAllAssetBundles(false);

            DirectoryInfo thisDir = Directory.CreateDirectory(Application.persistentDataPath + "/SceneObjs/");

            AssetBundleManifest abm = 
            BuildPipeline.BuildAssetBundles(thisDir.FullName,
                                            inBuildOption, // .None
                                            BuildTarget.StandaloneWindows64);

            bool openFolder = true;
            string[] allBundles = abm.GetAllAssetBundles();
            int succeses = 0;
            foreach (string s in allBundles)
            {
                try
                {
                    if (s.Length > 4 && s.Substring(s.Length - 4) != FileExt)
                    {
                        // Remove Previous + Manifest
                        File.Delete(thisDir.FullName + s + FileExt);    
                        File.Delete(thisDir.FullName + s + ".manifest");
                        // Rename .sobj
                        File.Move(thisDir.FullName + s, thisDir.FullName + s + FileExt);

                        WriteManifest(thisDir.FullName, s + FileExt, out string outLog);
                    }
                    else 
                        Debug.Log("DEV: FILETYPE EXISTS?");
                    
                    // Check: Not scene bundle?
                    AssetBundle thisBundle = AssetBundle.LoadFromFile(thisDir.FullName + s + FileExt);
                    if (!thisBundle.isStreamedSceneAssetBundle)
                    {
                        string assetNames = "";
                        foreach (string n in thisBundle.GetAllAssetNames())
                            assetNames += "\n > " + n;

                        Debug.LogWarning($"WARNING: Scene Tools cannot export .sobj <color=red>{s}</color> because it does not contain a scene. <color=white>CLICK HERE TO VIEW ASSETS</color>\n<color=#FF8899>{assetNames}</color>\n");
                        File.Delete(thisDir.FullName + s + FileExt);
                        succeses--;
                    }
                    thisBundle.Unload(false);
                    
                    if (openFolder)
                        EditorUtility.RevealInFinder(thisDir.FullName + s + FileExt);
                    openFolder = false;

                    succeses++;
                }
                catch (System.Exception ex)
                {
                    Debug.Log($"CREATED: {s} <color=red>(Couldn't set .SOBJ File Extension)</color>\n{ex}");
                }
            }

            // Remove Unity Waste
            File.Delete(thisDir.FullName + thisDir.Name);
            File.Delete(thisDir.FullName + thisDir.Name + ".manifest");
             
            if (allBundles.Length == 0)
                Debug.LogWarning("No Asset Bundles Exported!");
            else
                Debug.Log($"Asset Bundle{(succeses > 1 ? "s" : "")} Exported Successfully to <color=#DDFFDD>{thisDir.FullName}</color>");

        } catch (System.Exception ex)
        {
            Debug.LogError("<color=red>ERROR!</color> Asset Bundle Build FAILED (click for more)\n\n" + ex);
        }
    }

    static void WriteManifest(string inPath, string inFilename, out string outLog)
    {
        outLog = "";

        try
        {
            // RE-ENABLE THIS IF USING --> // DirectoryInfo manifestDir = Directory.CreateDirectory(inPath + "/Manifests/");

            // This points to the "AppData/LocalLow/GibbingTree/Madness Project Nexus Mod Kit/MadObjs/" folder for the ModTools project.
            // Use manifestDir.FullName to get the path.


            // DARKSIGNAL: Write whatever you like here!
            //
            // inFilename <-- The the .sobj filename, including the extension.
            //
            // outLog <-- This is for the debug on line 36, so you can check whatever you want
            //
            // Use manifestDir to locate the asset bundle and read it for parts and export a log.

        }
        catch (System.Exception ex)
        {
            outLog = "ERROR: " + ex;
        }
    }


}

