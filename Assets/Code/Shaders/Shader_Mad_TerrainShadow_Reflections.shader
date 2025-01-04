Shader "Madness/Terrain - General +Reflect"{
	Properties {
			_MainTex ("Texture", 2D) = "white" {}
	 		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
			_TintColor ( "Tint Color", Color ) = (0, 0, 0, 0)

			_Cube("Reflection Cube", Cube) = "" {}
			_CubeMap("Cube Map", 2D) = "black" {}
			_CubeAmount("Reflect Amount", range(0,5)) = 1

			_BumpMap("Distort Map", 2D) = "bump" {}
			_BumpAmt("Distortion", range (0,5)) = 0.1
	}
	
	//CGINCLUDE
		//#include "UnityCG.cginc"
		//#include "AutoLight.cginc"
		//#include "Lighting.cginc"
	//ENDCG


SubShader {
		
	
	Tags { "RenderType" = "Opaque""Queue"="Geometry+0" }



/////////////////////////////////////////
//			PRIMARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Primary/PRIMARYTERRAIN"
		
		
/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINE"

/////////////////////////////////////////
//			REFLECTION
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Secondary/REFLECTIONS_TERRAIN"


/////////////////////////////////////////
//		SECONDARY LIGHTS
/////////////////////////////////////////

		UsePass "Madness/StoredPasses/Secondary/SECONDARYTERRAIN_IMPROVED"
	
		  
/////////////////////////////////////////
//		SHADOW PASS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Misc/SHADOWPASS"

	}
	
	//FallBack "Standard"

}