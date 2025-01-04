Shader "Madness/Terrain - Detail" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Transparent ( "Transparent", Range (0, 1) ) = 1
		_Offset("Position Offset", Range(0,1)) = 0	// For Chainsaw. 
		_TintColor("Tint Color", Color) = (0, 0, 0, 0)
	}
	SubShader {



		//Tags {"Queue"="Transparent+60""RenderType" = "Opaque"}//"Queue"="Geometry+100" }//  "RenderType "="Transparent+60" }
		//Tags {"Queue"="Geometry+0"  "RenderType" = "Opaque"}	// Update 2/27/17: Changed Transparent+60 to Geometry+0, othewise Details would not show shadows underneath.
		//Tags {"Queue"="Geometry+500""RenderType "="Transparent" } // Updated 2/28/17 can't do that! Geometry was set higher.
		Tags{ "Queue" = "Geometry+100""RenderType " = "Opaque" } // Updated 10/21/18 - Set to +100 Because it HAS TO come after 2060, which is where Masks set Terrain. Otherwise, water vanishes over Door terrains.


		UsePass "Madness/StoredPasses/Misc/DEETSALPHA"
			

			/*
			// ADDITIONAL PASS (This lets our Point Light cast onto this otherwise "Zwrite Off" shader
			// Taken from: https://forum.unity.com/threads/transparency-shader-with-forwardbase-and-forwardadd.373695/
			Tags{ "Queue" = "Geometry" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			Pass{
				Zwrite On
				Blend SrcAlpha OneMinusSrcAlpha
				ColorMask 0
			}
			*/

		/////////////////////////////////////////
		//		SECONDARY LIGHTS
		/////////////////////////////////////////
		//UsePass "Madness/StoredPasses/Secondary/SECONDARYTERRAINALPHA"
		UsePass "Madness/StoredPasses/Secondary/SECONDARYTERRAIN_IMPROVED_ALPHA" // Added 1/31/18 



	} 
			//FallBack "Standard"
			// Do NOT use this until we can find a way for Cutouts to only draw their NON-alpha'd parts to the shadow mask.

}
