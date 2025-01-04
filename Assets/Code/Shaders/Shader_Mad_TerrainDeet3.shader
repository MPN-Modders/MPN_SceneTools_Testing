Shader "Madness/Terrain - Detail:Cutout" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Transparent ( "Transparent", Range (0, 1) ) = 1
		_Offset("Position Offset", Range(0,1)) = 0	// For Chainsaw. 
		_TintColor("Tint Color", Color) = (0, 0, 0, 0)
	}
	SubShader {
	
		Tags {"Queue"="Geometry+0"  "RenderType" = "Opaque"}	//REENABLED FOR NOW, til we have a fix - Disabled 1/3/17 due to Unity 5 conversion
		//Tags {"Queue"="Geometry+50" }// "RenderType "="Transparent+60" }
	
	
	
		UsePass "Madness/StoredPasses/Misc/DEETSCUTOUT"
	


/////////////////////////////////////////
//		SECONDARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Secondary/SECONDARYTERRAIN_IMPROVED"
		



/////////////////////////////////////////
//		SHADOW PASS
/////////////////////////////////////////
		//UsePass "Madness/StoredPasses/Misc/SHADOWPASS"
		// NO SHADOWS on this pass!

		
	} 
		//FallBack "Standard"
		// Do NOT use this: We don't want shadows on basic Cutouts

}
