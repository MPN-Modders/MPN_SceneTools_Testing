Shader  "Madness/Items - Main" {
	Properties {
			_MainTex ( "Texture", 2D) = "white" {}
	 		//_BumpMap ( "Bump Map", 2D) = "bump" {}
	 		_ShadowLimit ( "Shadow Depth", Range (-0.5,1.5) ) = 0		// How far away from light must a normal be before it turns black.
			_ToneLimit ( "2-Tone Depth", Range (-0.5,1.5) ) = 0.5		// How far from light the normal must be to tint it.
	 		_TonePower ( "2-Tone Strength", Range (0, 1) ) = 0.5		// See-through of the tone
	 		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
			_TintColor ( "Tint Color", Color ) = (0, 0, 0, 0)
	}
	
	SubShader {
	
		
		
	Tags { "RenderType" = "Opaque" }
	//Tags{ "Queue" = "Geometry+5" } 	// REMOVE THIS IF IT CAUSES PROBLEMS. Setting it to EXACTLY the same amount as Character Silhouettes lets ONLY the Toon Outlines show through.


/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINE"
		
	
/////////////////////////////////////////
//			PRIMARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Primary/PRIMARYBASIC"
			
			
		
/////////////////////////////////////////
//		SECONDARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Secondary/SECONDARYBASIC_IMPROVED"
		
		
	
	}
	Fallback "Diffuse"
}