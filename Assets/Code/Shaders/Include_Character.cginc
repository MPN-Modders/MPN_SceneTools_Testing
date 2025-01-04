// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//	#include "Assets/Resources/Code/Shaders/Include_Default.cginc"
// 
// 	This is where functions will be stored that need to be recycled by 
//	Pass Storage shaders, to then be passed on to each of my shaders.





/////////////////////////////////////////
//			INPUT / OUTPUT
/////////////////////////////////////////

	// GPU Per-Instancing
#pragma vertex vert
#pragma fragment frag
#pragma target 3.0
#pragma multi_compile_fog	
#pragma multi_compile_fwdadd_fullshadows 
//#pragma multi_compile_shadowcaster

#include "UnityCG.cginc"	// FOG + others
#include "AutoLight.cginc"
#include "Include_Calculations.cginc"

	struct vertexInput_Standard {
		fixed4 vertex : POSITION;
		fixed3 normal : NORMAL;
		fixed4 texcoord : TEXCOORD0;
		fixed4 tangent : TANGENT;
	};

	////////////////////
	struct vertexOutput_Standard
	{
		fixed4 pos : SV_POSITION;
		fixed4 tex : TEXCOORD0;
		fixed3 normalWorld : TEXCOORD2;
		fixed3 lookDir : TEXCOORD3;
		fixed3 lightDir : TEXCOORD4;
		LIGHTING_COORDS(5, 6) 	// SHADOWS
		UNITY_FOG_COORDS(1)		// FOG
	};




/////////////////////////////////////////
//			VERT
/////////////////////////////////////////
			

	// VERTEX: Common Details
	vertexOutput_Standard vert_Basic(vertexInput_Standard v)
	{
		vertexOutput_Standard o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.tex = v.texcoord;

		o.normalWorld = normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz);
		o.lookDir = normalize(WorldSpaceViewDir(v.vertex)); //normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);

		return o;
	}
	// VERTEX: Standard Character
	vertexOutput_Standard vert_Standard(vertexInput_Standard v)
	{
		vertexOutput_Standard o = vert_Basic(v);

		o.lightDir = normalize(_WorldSpaceLightPos0.xyz);

		TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
		UNITY_TRANSFER_FOG(o, o.pos);	// FOG

		return o;
	}


/////////////////////////////////////////
//			FRAG
/////////////////////////////////////////

	fixed4 frag_Standard(vertexOutput_Standard i, fixed4 inLightColor, fixed4 inAmbLight)
	{
		// Texture
		fixed4 myEffectMap = tex2D(_EffectMap, i.tex.xy);
		fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
		// myEffectMap.r  <-- Emissions
		// myEffectMap.g  <-- Reflections (which also have an entirely second map for Bump)
		// myEffectMap.b  <-- Custom Tint
		// myEffectMap.a  <-- UNUSED
				//fixed4 myEmission = tex2D(_EmitMap, i.tex.xy);
				//fixed4 myCustomMap = tex2D(_CustomMap, i.tex.xy);

		// Get Black/White Overlay Value
		float overlayValue = ReturnOverlayVal(myTexture.rgb); // = min(1, (myTexture.r + myTexture.g + myTexture.b) / 3);

		// Tone & Shadow
		_TonePower = 1;
		fixed myTone = max((1 - _TonePower), saturate(round(dot(i.lightDir, i.normalWorld) + (1 - _ToneLimit)))); // Returns either 1 or _TonePower.				
		//myTone *= LIGHT_ATTENUATION(i);  // SHADOWS 			// MOVED BELOW to inLightColor, this was doing NOTHING and characters wouldn't take shadows from Directional Lights
		fixed4 myToneColor = saturate(fixed4(myTone, myTone, myTone, 1) * 1.5 + inAmbLight);

		// Final Light
		inLightColor *= LIGHT_ATTENUATION(i);  // SHADOWS 			
		inLightColor = max(inAmbLight, inLightColor) * myToneColor + (1 - myToneColor) * (inAmbLight);// * myShadowColor;				

		// Blood Texture
		fixed4 myBloodTexture = tex2D(_BloodTex, i.tex.xy);
		// Adjust Main Texture by Blood
		myBloodTexture.a = round(myBloodTexture.a); // Harden blood, no soft edges.
		myBloodTexture.a *= overlayValue * 4;		// Blood doesn't appear over black lines. // Why was there an error on the above code?  ---  THIS WAS THE ERROR: Shader error in 'Madness/Character - 4b (Wounds)': 'ceil': no matching 0 parameter intrinsic function; Possible intrinsic functions are: ceil(float|half|min10float|min16float) at line 251
		myTexture.rgb *= 1 - myBloodTexture.a;		// Blacken area near edge of blood, and prevents texture from glowing beneath blood.				

			// Custom Color alters Texture Color
			//overlayValue = 2 * pow(1 - abs(overlayValue - 0.5f) * 2, 1.5f);		// Adjust overlayValue to apply only to GREY areas!
			// Part 1: Get Color												// Part 2: Affect greys, not white or black.	// Part 3: Find WHITE or GREY map		
			//myTexture.rgb += (_CustomColor.rgb - fixed3(0.5, 0.5, 0.5))			* _CustomColor.a  * overlayValue				* round(0.6f - myEffectMap.b);
			//myTexture.rgb += (_CustomColor2.rgb - fixed3(0.5, 0.5, 0.5))  		* _CustomColor2.a * overlayValue				* round(myEffectMap.b - 0.2);  // round(-abs(myEffectMap.b - 0.5) + 0.6); 
		
			// SWAIN OVERLAY 1 (washes out white)
			//myTexture.rgb = lerp(myTexture.rgb,		 (1 - (1 - 2 * (myTexture.rgb - 0.5f)) * (1 - _CustomColor.rgb))		*		((2 * myTexture.rgb) * _CustomColor.rgb)		, _CustomColor.a  * round(0.6f - myEffectMap.b));
			//myTexture.rgb = lerp(myTexture.rgb,		 (1 - (1 - 2 * (myTexture.rgb - 0.5f)) * (1 - _CustomColor2.rgb))		*		((2 * myTexture.rgb) * _CustomColor2.rgb)		, _CustomColor2.a * round(myEffectMap.b - 0.2));

			// DEFAULT OVERLAY FORMULA (washes out grey)
			//overlayValue = overlayValue > 0.5; // Sets this to 0 or 1, so we know whether or not to use MULTIPLY or SCREEN
			//myTexture.rgb = lerp(myTexture.rgb,    (overlayValue) * (1 - (1 - 2 * (myTexture.rgb - 0.5)) * (1 - _CustomColor.rgb))		+	(1 - overlayValue) * ((2 * myTexture.rgb) * _CustomColor.rgb),		_CustomColor.a  * round(0.6f - myEffectMap.b));
			//myTexture.rgb = lerp(myTexture.rgb,    (overlayValue) * (1 - (1 - 2 * (myTexture.rgb - 0.5)) * (1 - _CustomColor2.rgb))		+   (1 - overlayValue) * ((2 * myTexture.rgb) * _CustomColor2.rgb),		_CustomColor2.a * round(myEffectMap.b - 0.2));
			myTexture.rgb = ColorizeTexture(myTexture.rgb, overlayValue, myEffectMap.b, _CustomColor, _CustomColor2);

			// OVERLAY MATH (found online)
			//	(Target > 0.5) * (1 - (1 - 2 * (Target - 0.5)) * (1 - Blend)) +
			//	(Target <= 0.5) * ((2 * Target) * Blend)


		// Specular Light
		fixed mySpecLight = pow(max(0.0, dot(reflect(-i.lookDir, i.normalWorld), i.lookDir)), 2);
		fixed4 bloodFinal = fixed4(((myBloodTexture.rgb) + fixed3(0.4f, 0.4f, 0.4f) * mySpecLight) * myBloodTexture.a, 0); // Takes the blood layer, adds specular lighting to it.

			// Rim Light (Sourced)
		fixed myRimLight = saturate(pow(1 - dot(i.lookDir, i.normalWorld), _RimFade) * _RimDepth); // Rim currently does not use bump map

			// Final Color
		fixed4 finalDraw = myTexture * inLightColor
					+ (inLightColor * myRimLight * _RimPower * 0.5f)
					+ bloodFinal
					+ (myTexture * myEffectMap.r)
					;

		// Final Output								
		float4 finalOutput = fixed4(finalDraw.rgb, min(ReturnTextureCutoutAlpha(myBloodTexture.rgb), round(myTexture.a))); // Set alpha to the lowest of BLOOD or TEXTURE alpha.
		UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG

		// Apply TINT and then GLOW //
		finalOutput.rgb = lerp(finalOutput + _TintColor, _GlowColor, _GlowColor.a); // Glow added! Overwrites any color, including TINT, and ignores Fog.
		// NOTE: We only Lerp the .rgb because we DON'T want to screw with the alpha (which would make wounds non-transparent)

		//SHADOW_CASTER_FRAGMENT(i);
		return finalOutput;
	}






