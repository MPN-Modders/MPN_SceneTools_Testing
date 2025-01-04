// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader  "Madness/Blood - Gibs" {
	Properties {
			_MainTex ( "Texture", 2D) = "white" {}
	 		_ShadowLimit ( "Shadow Depth", Range (-0.5,1.5) ) = 0		// How far away from light must a normal be before it turns black.
			_ToneLimit ( "2-Tone Depth", Range (-0.5,1.5) ) = 0.5		// How far from light the normal must be to tint it.
	 		_TonePower ( "2-Tone Strength", Range (0, 1) ) = 0.5		// See-through of the tone
	 		_Outline ( "Outline Thickness", Range (0, 0.5) ) = 0.3
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
			_BloodColor ( "Blood Color", Color ) = (0, 0, 0, 0)
			_TintColor("Tint Color", Color) = (0, 0, 0, 0)
			_GlowColor("Glow Color", Color) = (0,0,0,0)					// Color glow on top of all other colors.
			_BoneValue("Bone Value", Range(0, 1)) = 0					// Adjusts this material from _BloodColor toward White
	}
	

	SubShader {
	
		Tags { "Queue"="Geometry" }  // REMOVED 2/11/19 We don't do silhouettes anymore, AND even so, you were seeing Gibs on top of the new Item Selection shader.    //  "Geometry+40"	   // Add this to ANY SHADER that does not require a silhouette behind it.
	
		Tags{ "RenderType" = "Opaque" }

		/////////////////////////////////////////
		//			TOON OUTLINE
		/////////////////////////////////////////
				UsePass "Madness/StoredPasses/Outline/OUTLINE" // OUTLINEWOUND"



		/////////////////////////////////////////
		//			PRIMARY LIGHTS
		/////////////////////////////////////////

				UsePass "Madness/StoredPasses/Primary/PRIMARY GIBS" 
			


		/////////////////////////////////////////
		//		SHADOW PASS
		/////////////////////////////////////////
				UsePass "Madness/StoredPasses/Misc/SHADOWPASS"	// Why is this commented out? Not needed?
														// TURNED ON 6/14/21 - Otherwise Huskmen don't cast shadows
	
		}
			//FallBack "Diffuse"   //  <--- Including this Fallback is what has the character absorb shadows. This also makes it so Alpha blocks shadows behind it.

}