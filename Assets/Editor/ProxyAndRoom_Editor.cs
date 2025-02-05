using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

// NOTE: For help on creatng Unity Editor WINDOWS, go here: http://docs.unity3d.com/Manual/editor-EditorWindows.html
// NOTE: For Inspector Editors panels, go here: https://www.youtube.com/watch?v=WlGwBmM-dfA


[CanEditMultipleObjects]
public class Proxy_Editor : Editor
{
	public Mesh testMesh;
	protected EditorStorage editorStorage;

	protected SerializedProperty value; 
	void OnEnable()
	{
		value = serializedObject.FindProperty("Type");
	}
	public override void OnInspectorGUI()
	{
		int previousValue = value.enumValueIndex;

		base.OnInspectorGUI();

		if (previousValue != value.enumValueIndex)
		{
			UpdateMesh();
		}
	}

	void UpdateMesh()
    {
		editorStorage = editorStorage ?? Resources.Load("SceneTools/EditorStorage") as EditorStorage;

		//Debug.LogWarning(" == COOL FEATURE ");
		//Debug.LogWarning(" https://docs.unity3d.com/ScriptReference/BuildAssetBundleOptions.DisableLoadAssetByFileName.html ");
		//Debug.LogWarning(" https://docs.unity3d.com/ScriptReference/BuildAssetBundleOptions.DisableLoadAssetByFileNameWithExtension.html ");
		//Debug.LogWarning(" This could mean we can stop the project from exporting anything not in appropriate folders?? As well as NOT including the Proxy/Marker meshes");

		foreach (Object t in serializedObject.targetObjects)
		{
			try
			{
				MeshFilter mf = ((ProxyObj)t).GetComponent<MeshFilter>();
				mf.sharedMesh = null; // Clear Mesh (so we can reaasign to Fallback)

				foreach (EditorStorage.MeshDisplay meshDisplay in GetList())
					if (IsTypeMatch(meshDisplay, value.enumNames[value.enumValueIndex])) // if (meshList.Types.Contains(value.enumNames[value.enumValueIndex]))
					{
						mf.sharedMesh = meshDisplay.Mesh;
						return;
					}

				// Fallback
				mf.sharedMesh = GetList()[0].Mesh;
			}
			catch
            {
				// FAIL: You may have removed the mesh 
            }
		}
	}
	protected virtual List<EditorStorage.MeshDisplay> GetList()
	{
		return new List<EditorStorage.MeshDisplay>(); // editorStorage.Fallback; 
	}
	protected virtual bool IsTypeMatch(EditorStorage.MeshDisplay meshList, string inTypeName)
    { return true; }

}


[CanEditMultipleObjects]
[CustomEditor(typeof(ProxyObj_Door))]
public class ProxyObj_Door_Editor : Proxy_Editor
{
	protected override List<EditorStorage.MeshDisplay> GetList() { return editorStorage.Doors.ConvertAll(o => (EditorStorage.MeshDisplay)o); }
	protected override bool IsTypeMatch(EditorStorage.MeshDisplay meshList, string inTypeName)
	{
		return ((EditorStorage.MeshDisplay_Doors)meshList).Type.ToString() == inTypeName;
    }
}
[CanEditMultipleObjects]
[CustomEditor(typeof(ProxyObj_Cover))]
public class ProxyObj_Cover_Editor : Proxy_Editor
{
	protected override List<EditorStorage.MeshDisplay> GetList() { return editorStorage.Cover.ConvertAll(o => (EditorStorage.MeshDisplay)o); }
	protected override bool IsTypeMatch(EditorStorage.MeshDisplay meshList, string inTypeName)
	{
		return ((EditorStorage.MeshDisplay_Cover)meshList).Type.ToString() == inTypeName;
	}

}
[CanEditMultipleObjects]
[CustomEditor(typeof(ProxyObj_Locker))]
public class ProxyObj_Locker_Editor : Proxy_Editor
{
	protected override List<EditorStorage.MeshDisplay> GetList() { return editorStorage.Lockers.ConvertAll(o => (EditorStorage.MeshDisplay)o); }
	protected override bool IsTypeMatch(EditorStorage.MeshDisplay meshList, string inTypeName)
	{
		return ((EditorStorage.MeshDisplay_Lockers)meshList).Type.ToString() == inTypeName;
	}

}
[CanEditMultipleObjects]
[CustomEditor(typeof(ProxyObj_Interact))]
public class ProxyObj_Interact_Editor : Proxy_Editor
{
	protected override List<EditorStorage.MeshDisplay> GetList() { return editorStorage.Interactives.ConvertAll(o => (EditorStorage.MeshDisplay)o); }
	protected override bool IsTypeMatch(EditorStorage.MeshDisplay meshList, string inTypeName)
	{
		return ((EditorStorage.MeshDisplay_Interactives)meshList).Type.ToString() == inTypeName;
	}

}
[CanEditMultipleObjects]
[CustomEditor(typeof(ProxyObj_Togglable))]
public class ProxyObj_Togglable_Editor : Proxy_Editor
{
	protected override List<EditorStorage.MeshDisplay> GetList() { return editorStorage.Togglables.ConvertAll(o => (EditorStorage.MeshDisplay)o); }
	protected override bool IsTypeMatch(EditorStorage.MeshDisplay meshList, string inTypeName)
	{
		return ((EditorStorage.MeshDisplay_Togglables)meshList).Type.ToString() == inTypeName;
	}

}



[CanEditMultipleObjects]
[CustomEditor(typeof(RoomObj))]
public class RoomObj_Editor : Editor
{

	public override void OnInspectorGUI()
	{
		base.OnInspectorGUI();

		GUILayout.Space(10); 
		GUILayout.Box("", new GUILayoutOption[]{GUILayout.ExpandWidth(true), GUILayout.Height(1)}); 


		EditorStyles.label.alignment = TextAnchor.MiddleCenter;
		GUILayout.Space(15);
		GUILayout.BeginVertical(); 


		EditorGUILayout.LabelField("Press to set world Lights/Fog/Camera to this room's values.");


		GUILayout.Space(5);

		GUILayout.BeginHorizontal(); GUILayout.FlexibleSpace();	
		if (GUILayout.Button("SYNCH VISUALS", new GUILayoutOption[] { GUILayout.Width(200), GUILayout.Height (50)}  ))
			ActivateRoomVisuals();
		GUILayout.FlexibleSpace(); GUILayout.EndHorizontal();
		
		GUILayout.EndVertical();
		EditorStyles.label.alignment = TextAnchor.MiddleLeft;
		GUILayout.Space(15);
	}



	private void ActivateRoomVisuals()
	{
		RoomObj thisRoom = (RoomObj) target;
		RoomObj[] allRooms = (RoomObj[]) Resources.FindObjectsOfTypeAll<RoomObj>();

        Light[] allLights;
        // Lights + Background
        for (int i = 0; i < allRooms.Length; i ++) 
		{
			allLights = allRooms[i].GetComponentsInChildren<Light>();
			for (int l = 0; l < allLights.Length; l ++)
				allLights[l].enabled = allRooms[i] == thisRoom;

			allRooms[i].BackgroundFolder.SetActive(allRooms[i] == thisRoom);
		}

		// Camera
		Dev_Cam devCam = Transform.FindObjectOfType<Dev_Cam>();
		if (!devCam)
		{
			devCam = (PrefabUtility.InstantiatePrefab(Resources.Load("SceneTools/Dev_Cam")) as GameObject).GetComponent<Dev_Cam>();
			devCam.name = "Dev_Cam";
			Debug.Log("Created a new <color=white>\"Dev_Cam\"</color>", devCam);
		}

		// Name by Scene Link
		devCam.LinkToRoom(thisRoom);
		devCam.transform.SetParent(null);
		devCam.transform.position = thisRoom.CameraPoint.transform.position;// + thisRoom.startCamera.transform.up + thisRoom.startCamera.transform.forward;
		devCam.transform.rotation = thisRoom.CameraPoint.transform.rotation;

		// Fog & Sky
		RenderSettings.skybox = thisRoom.Skybox;
		RenderSettings.ambientLight = thisRoom.AmbientColor;

		RenderSettings.fog = thisRoom.FogDensity > 0;
		RenderSettings.fogColor = thisRoom.FogColor;
		RenderSettings.fogDensity = thisRoom.FogDensity;
		RenderSettings.fogMode = thisRoom.FogMode;
		RenderSettings.fogStartDistance = thisRoom.FogLinearStartEnd.x;
		RenderSettings.fogEndDistance = thisRoom.FogLinearStartEnd.y;
	}

}


[CanEditMultipleObjects]
[CustomEditor(typeof(ProxyObj_Playground))]
public class ProxyObj_Playground_Editor : Editor
{
	protected EditorStorage editorStorage;

	protected SerializedProperty value;
	void OnEnable()
	{
		value = serializedObject.FindProperty("ScaffoldLegs");
	}
	public override void OnInspectorGUI()
	{
		bool previousValue = value.boolValue;

		base.OnInspectorGUI();

		if (previousValue != value.boolValue)
		{
			UpdateMesh();
		}
	}
	void UpdateMesh()
	{
		editorStorage = editorStorage ?? Resources.Load("SceneTools/EditorStorage") as EditorStorage;

		foreach (Object t in serializedObject.targetObjects)
		{
			try
			{
				MeshFilter mf = ((ProxyObj)t).GetComponent<MeshFilter>();
				mf.sharedMesh = editorStorage.ControlRoom[(t as ProxyObj_Playground).ScaffoldLegs ? 1 : 0];
			}
			catch
			{
				// FAIL: You may have removed the mesh?
			}
		}
	}

}