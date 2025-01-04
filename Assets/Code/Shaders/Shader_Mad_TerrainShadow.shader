Shader "Madness/Terrain - General"{
	Properties {
			_MainTex ("Texture", 2D) = "white" {}
	 		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
			_TintColor ( "Tint Color", Color ) = (0, 0, 0, 0)
	}
	
	//CGINCLUDE
		//#include "UnityCG.cginc"
		//#include "AutoLight.cginc"
		//#include "Lighting.cginc"
	//ENDCG


SubShader {
		
	
	Tags { "Queue" = "Geometry+0"  "RenderType" = "Opaque"}



/////////////////////////////////////////
//			PRIMARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Primary/PRIMARYTERRAIN"
		
		
/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINE"

		
/////////////////////////////////////////
//		SECONDARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Secondary/SECONDARYTERRAIN_IMPROVED"
	
		  
		
/////////////////////////////////////////
//		SHADOW PASS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Misc/SHADOWPASS"

}
				//FallBack "Diffuse"   //  <--- Including this Fallback is what has the character absorb shadows. This also makes it so Alpha blocks shadows behind it.

}