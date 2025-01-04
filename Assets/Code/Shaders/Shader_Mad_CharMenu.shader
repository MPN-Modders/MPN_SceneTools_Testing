Shader  "Madness/Menu/Character - Menu&UI" {
	Properties {
			_MainTex ( "Texture", 2D) = "white" {}
			_EffectMap("*** Effect Map <--- USE THIS!", 2D) = "black" {}
			_BloodTex ( "Blood", 2D) = "red" {}
			_BloodColor ( "Blood Color", Color) = (1,0,0,0)
	 		_GlowColor ( "Glow Color", Color) = (0,0,0,0)				// Color glow on top of all other colors.
					//_EmitMap ( "UNUSED: Emission Map", 2D) = "black" {}
	 		_RimFade ( "Rim Fade", Range ( 10, 30 ) ) = 30
	 		_RimDepth ( "Rim Depth", Range(4, 10) ) = 4
	 		_RimPower ( "Rim Power", Range (0.5, 1) ) = 0.5
			_ToneLimit ( "2-Tone Depth", Range (0.5,0.5) ) = 0.5		// How far from light the normal must be to tint it.
	 		_TonePower ( "2-Tone Strength", Range (0.5, 0.5) ) = 0.5		// See-through of the tone
	 		_Outline ( "Outline Thickness", Range (0.05, 0.2) ) = 0.05
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
			_TintColor ( "Tint Color", Color ) = (0, 0, 0, 0)
			_CustomColor("Custom Color", Color) = (0.5, 0.5, 0.5, 0)		// Arena color tint
			_CustomColor2("Custom Color 2", Color) = (0.5, 0.5, 0.5, 0)		// Arena color tint
					//_CustomMap("UNUSED: Custom Map", 2D) = "white" {}

			_Cube("Reflection Cube", Cube) = "" {}
			_CubeAmount("Reflect Amount", range(0,5)) = 1
			_BumpMap("Distort Map", 2D) = "bump" {}
			_BumpAmt("Distortion", range(0,5)) = 0.1

			//_LightColorInput ( "Light Color", Color ) = (1, 1, 1, 1)
			//_LightColorDir ("Light Dir", Vector) = (0,0,1)
			_MenuLightColor ( "Menu Light Color", Color ) = (1, 1, 1, 1)
			_MenuLightDir ("Menu Light Dir", Vector) = (0,0,1)
			_MenuAmbientColor ( "Menu Ambient Color", Color ) = (1, 1, 1, 1)
	}
	
	
	SubShader {
	
		Fog { Mode Off }
	

	
/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINEMENU"


		
/////////////////////////////////////////
//			PRIMARY LIGHTS
/////////////////////////////////////////
		Tags { "RenderType" = "Opaque" }

		UsePass "Madness/StoredPasses/Primary/PRIMARYCHARACTER_MENU"


/////////////////////////////////////////
//			REFLECTION
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Secondary/REFLECTIONS_MENU"

		
		
/////////////////////////////////////////
//		SECONDARY LIGHTS
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Secondary/SECONDARYBASIC_IMPROVED"



		
	
	}
	FallBack "Diffuse"

}