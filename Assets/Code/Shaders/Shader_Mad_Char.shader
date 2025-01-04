Shader  "Madness/Character - Standard" {
	Properties {
			_MainTex ( "Texture", 2D) = "white" {}
			_EffectMap("*** Effect Map <--- USE THIS!", 2D) = "black" {}
			_BloodTex ( "Blood", 2D) = "red" {}
			_BloodColor ( "Blood Color", Color) = (0,0,0,0)
	 		_GlowColor ( "Glow Color", Color) = (0,0,0,0)					// Color glow on top of all other colors.
					_EmitMap ( "UNUSED: Emission Map", 2D) = "black" {}
	 		_RimFade ( "Rim Fade", Range ( 0, 30 ) ) = 30
	 		_RimDepth ( "Rim Depth", Range(0, 10) ) = 4
	 		_RimPower ( "Rim Power", Range (0.5, 1) ) = 0.5
			_ToneLimit ( "2-Tone Depth", Range (0.5,0.5) ) = 0.5			// How far from light the normal must be to tint it.
	 		_TonePower ( "2-Tone Strength", Range (0.5, 0.5) ) = 0.5		// See-through of the tone
	 		_Outline ( "Outline Thickness", Range (0.05, 0.2) ) = 0.05
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
			_TintColor ("Tint Color", Color ) = (0, 0, 0, 0)
			_CustomColor("Custom Color", Color) = (0.5, 0.5, 0.5, 0)		// Arena color tint
			_CustomColor2("Custom Color 2", Color) = (0.5, 0.5, 0.5, 0)		// Arena color tint
					_CustomMap("UNUSED: Custom Map", 2D) = "white" {}
	}


	SubShader {
	
		Tags {"Queue"="Geometry+0"  "RenderType" = "Opaque"}	//REENABLED FOR NOW, til we have a fix - Disabled 1/3/17 due to Unity 5 conversion
		//Tags {"Queue"="Geometry+50" }// "RenderType "="Transparent+60" }
	
	
	
	// Proper Pass Order:
	// Silhouette
	// Toon					 (If not first, the other side of blood holes will not properly show)
	// Interior
	// Primary
	// Secondary


																								//   SHADER HELP:  https://thebookofshaders.com/
																								//   SHADER HELP:  https://thebookofshaders.com/
																								//   SHADER HELP:  https://thebookofshaders.com/
																								//   SHADER HELP:  https://thebookofshaders.com/
	
/////////////////////////////////////////
//			SILHOUETTE
/////////////////////////////////////////
		//UsePass "Madness/StoredPasses/Outline/SILHOUETTEWOUND"

		
		
/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINEWOUND"


		
/////////////////////////////////////////
//			INTERIOR SKIN
/////////////////////////////////////////

		UsePass "Madness/StoredPasses/Outline/INTERIOR"

		
/////////////////////////////////////////
//			PRIMARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Primary/PRIMARYCHARACTER"
		
		
/////////////////////////////////////////
//			SECONDARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Secondary/SECONDARYBASIC_IMPROVED"
		
		

/////////////////////////////////////////
//		SHADOW PASS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Misc/SHADOWPASS_CHARACTER"

	}

	FallBack "Diffuse"   //  <--- Including this Fallback is what has the character absorb shadows. This also makes it so Alpha blocks shadows behind it.

	// TODO: Follow ShadowCaster instructions here: https://forum.unity3d.com/threads/fallback-off-turns-off-shadows-in-surface-shader.257430/

}  