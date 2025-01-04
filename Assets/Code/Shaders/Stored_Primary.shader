// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'




																								//   SHADER HELP:  https://thebookofshaders.com/
																								//   SHADER HELP:  https://thebookofshaders.com/
																								//   SHADER HELP:  https://thebookofshaders.com/
																								//   SHADER HELP:  https://thebookofshaders.com/
																								//   SHADER HELP:  https://thebookofshaders.com/

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/StoredPasses/Primary"{
	//Properties {
	//		_MainTex ("Texture", 2D) = "white" {}
	// 		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
	// 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
	//}
	
	//CGINCLUDE
		//#include "UnityCG.cginc"
		//#include "AutoLight.cginc"
		//#include "Lighting.cginc"
	//ENDCG


	Properties {
		//_MainTex ("Texture", 2D) = "white" {}
		//_BloodTex ( "Blood", 2D) = "red" {}
		//_BloodColor ( "Blood Color", Color) = (0,0,0,0)
 		//_GlowColor ( "Glow Color", Color) = (0,0,0,0)				// Color glow on top of all other colors.
 		//_BumpMap ( "Bump Map", 2D) = "bump" {}
		//_EmitMap ( "Emission Map", 2D) = "black" {}
 		//_RimFade ( "Rim Fade", Range ( 30, 30 ) ) = 30
 		//_RimDepth ( "Rim Depth", Range(4, 4) ) = 4
 		//_RimPower ( "Rim Power", Range (0.5, 0.5) ) = 0.5
		//_ToneLimit ( "2-Tone Depth", Range (0.5,0.5) ) = 0.5		// How far from light the normal must be to tint it.
 		//_TonePower ( "2-Tone Strength", Range (0.5, 0.5) ) = 0.5		// See-through of the tone
		//_TintColor ( "Tint Color", Color ) = (0, 0, 0, 0)
	}

SubShader {

	
	//Tags { "RenderType" = "Opaque""Queue"="Geometry+0" }



/////////////////////////////////////////
//			PRIMARY LIGHTS
/////////////////////////////////////////

		Pass { Name "PRIMARYTERRAIN"
		
		Tags{"LightMode" = "ForwardBase" "RenderType"="Geometry"}
		
			Lighting On
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0 			
				#pragma multi_compile_fog	
				#pragma multi_compile_fwdadd_fullshadows
			// NOTE: target 3.0 was added as of 6/23/16, and I don't know if it's necessary. But it seemed to get rid of errors on Build
			

			//
			#include "UnityCG.cginc"	// FOG + others
            #include "AutoLight.cginc"
			//#include "TerrainEngine.cginc"
			/// The above gives you all combinations of spot/point-keywords with shadows as well as without. The functional code then becomes (tested unity4.0):
			
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;

			uniform fixed4 _LightColor0;
			//uniform fixed4 unity_Ambient;

			/*struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				fixed3 lightDir : TEXCOORD4;
				//fixed4 col : COLOR;
				LIGHTING_COORDS(5,6) // SHADOWS
				UNITY_FOG_COORDS(3)	// FOG
			};*/

			#include "Include_Terrain.cginc"

			// Do this in PRIMARYTERRAIN! (it doesnt have an effect map
			fixed4 frag(vertexOutput i) : COLOR
			{
				return drawFrag(i, 0);
			}
			/*vertexOutput vert(vertexInput v) {
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				//o.col = _TintColor;
				o.lightDir = normalize(_WorldSpaceLightPos0.xyz);

				TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				UNITY_TRANSFER_FOG(o, o.pos);	// FOG

				return o;
			}
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.

				fixed3 normalDir = i.normalWorld;
				float lightFinal = saturate ( dot(i.lightDir, normalDir ) * 2); // * saturate(dot(fixed3(0.0f, 1.0f, 0.0f), lightDir));
				lightFinal *= LIGHT_ATTENUATION(i);  // SHADOWS  // This makes sure shadows turn lightFinal (whether a surface is facing light) to darkness, THUS they use ambient color.
				float4 lightColorFinal = ((1 - lightFinal)) * UnityAmbientLight		+		(lightFinal * max(UnityAmbientLight, _LightColor0));

				// Final Output								
				float4 finalOutput = myTexture * lightColorFinal;// * lightColorFinal; //lerp(1, lightFinal, 0.6) * lightColorFinal;
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				return finalOutput + _TintColor;
			}*/
			
			ENDCG
		}
		Pass { Name "PRIMARYWEAPON_EMISSION"
		
		Tags{"LightMode" = "ForwardBase" "RenderType"="Geometry"}
		
			Lighting On
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0 			
				#pragma multi_compile_fog	
				#pragma multi_compile_fwdadd_fullshadows

			#include "UnityCG.cginc"	// FOG + others
            #include "AutoLight.cginc"
			
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform sampler2D _EffectMap;

			uniform fixed4 _LightColor0;
			
			#include "Include_Terrain.cginc"
			
			fixed4 frag(vertexOutput i) : COLOR
			{
				fixed4 myEffectMap = tex2D(_EffectMap, i.tex.xy);

				return drawFrag(i, myEffectMap.r);
			}
			ENDCG
		}
		
		
		Pass {  Name "PRIMARYCHARACTER_REFLECT"
			Tags {"LightMode" = "ForwardBase"} //"LightMode"="ShadowCaster"} // This here will make a pass totally a "shadowcaster", aka this pass would cast shadows only.
			
			CGPROGRAM
			#pragma vertex vert_OutlineWound
			#pragma fragment frag_OutlineWound

			uniform sampler2D _MainTex; // uniform float4 _MainTex_ST;
			uniform sampler2D _EffectMap; //uniform sampler2D _EmitMap;  uniform sampler2D _CustomMap;
			uniform fixed4 _TintColor;
			uniform fixed4 _CustomColor; uniform fixed4 _CustomColor2;
			//uniform sampler2D _BumpMap;
			//uniform sampler2D _EmitMap;
			uniform sampler2D _BloodTex;
			uniform fixed4 _BloodColor;
			uniform fixed4 _GlowColor;
			uniform half _RimFade;
			uniform half _RimDepth;
			uniform half _RimPower;
			//uniform fixed _ShadowLimit;
			uniform fixed _ToneLimit;
			uniform fixed _TonePower;
			uniform fixed _Transparent;
			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
			// Reflection Vars
			float _CubeScaling;
			float _CubeAmount;
			uniform samplerCUBE _Cube;

			#include "Include_Default.cginc"
			#include "Include_Character.cginc"


			ENDCG
		}

		
		
		Pass {  Name "PRIMARYCHARACTER"
			Tags {"LightMode"="ForwardBase"} //"LightMode"="ShadowCaster"} // This here will make a pass totally a "shadowcaster", aka this pass would cast shadows only.
			//LOD 100
			//Lighting Off // What did this do?
			//AlphaTest Greater [_Cutoff]
			AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			
			//ZTest Less
			Blend SrcAlpha OneMinusSrcAlpha, Zero SrcAlpha
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.

			
			CGPROGRAM
			#pragma vertex vert_Standard
			#pragma fragment frag
			#pragma target 3.0
				#pragma multi_compile_fog	
				#pragma multi_compile_fwdadd_fullshadows 

				#include "UnityCG.cginc"	// FOG + others
	            #include "AutoLight.cginc"

				// User Vars
			uniform sampler2D _MainTex; // uniform float4 _MainTex_ST;
			uniform sampler2D _EffectMap; //uniform sampler2D _EmitMap;  uniform sampler2D _CustomMap;
			uniform fixed4 _TintColor;
			uniform fixed4 _CustomColor; uniform fixed4 _CustomColor2; 
			//uniform sampler2D _BumpMap;
			//uniform sampler2D _EmitMap;
			uniform sampler2D _BloodTex;
			uniform fixed4 _BloodColor;
			uniform fixed4 _GlowColor;
			uniform half _RimFade;
			uniform half _RimDepth;
			uniform half _RimPower;
			//uniform fixed _ShadowLimit;
			uniform fixed _ToneLimit;
			uniform fixed _TonePower;
			uniform fixed _Transparent;
			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
				// Reflection Vars
			float _CubeScaling;
			float _CubeAmount;
			uniform samplerCUBE _Cube;


				// Unity Vars
			uniform float4 _LightColor0;
			
			#include "Include_Default.cginc"
			#include "Include_Character.cginc"
			//#include "Include_Calculations.cginc" // This is included in Include_Character!

			fixed4 frag (vertexOutput_Standard i) : COLOR
			{
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				return frag_Standard(i, _LightColor0, UNITY_LIGHTMODEL_AMBIENT);
			}
			
			ENDCG
		}
		

		Pass{ Name "PRIMARYCHARACTER_MENU"
			Tags {"LightMode" = "ForwardBase" "Queue" = "Geometry"}// "RenderType"="Geometry"}
			//Zwrite Off
			AlphaTest Greater[fixed(0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			Cull Off
			//ZTest Less

			Blend SrcAlpha OneMinusSrcAlpha, Zero SrcAlpha
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

						// User Vars
					uniform sampler2D _MainTex;// uniform float4 _MainTex_ST; 
					uniform sampler2D _EffectMap; // uniform sampler2D _EmitMap;  uniform sampler2D _CustomMap;
					uniform fixed4 _TintColor;
					uniform fixed4 _CustomColor; uniform fixed4 _CustomColor2;
					uniform sampler2D _BloodTex;
					uniform fixed4 _GlowColor;
					uniform half _RimFade;
					uniform half _RimDepth;
					uniform half _RimPower;
					//uniform fixed _ShadowLimit;
					uniform fixed _ToneLimit;
					uniform fixed _TonePower;
					uniform fixed _Outline;
					uniform fixed4 _OutlineColor;
					// Reflection Vars
				float _CubeScaling;
				float _CubeAmount;
				uniform samplerCUBE _Cube;

				// Unity Vars
			uniform float4 _MenuLightColor; //_SwainLightColor;
			uniform float4 _MenuAmbientColor;
			uniform float4 _MenuLightDir;//_SwainLightDir;

			#include "Include_Default.cginc"
			#include "Include_Character.cginc"

			vertexOutput_Standard vert(vertexInput_Standard v)
			{
				vertexOutput_Standard o = vert_Basic(v);

				o.lightDir = -_MenuLightDir; // I don't know why this is backwards, oh well?
				return o;
			}
			fixed4 frag(vertexOutput_Standard i) : COLOR
			{
				_MenuLightColor *= 0.5;
				return frag_Standard(i, _MenuLightColor, _MenuAmbientColor);
			}

			ENDCG
		}


		
		Pass { Name "PRIMARYBASIC"
		Tags {"LightMode" = "ForwardBase"  "RenderType"="Geometry"}
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
						
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
				#pragma multi_compile_fog	
				#pragma multi_compile_fwdadd_fullshadows 
				#include "UnityCG.cginc"	// FOG + others
	            #include "AutoLight.cginc"
				//#include "TerrainEngine.cginc"
				// User Vars
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			//uniform sampler2D _BumpMap;
			//uniform fixed _ShadowLimit;
			uniform fixed _ToneLimit;
			uniform fixed _TonePower;
			
				// Unity Vars
			uniform float4 _LightColor0;
			
			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
				fixed4 tangent : TANGENT;
			};
			
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				fixed4 posWorld : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				fixed3 lightDir : TEXCOORD3;
				//fixed3 tangentWorld : TEXCOORD3;
				//fixed3 binormalWorld : TEXCOORD4;
				//fixed4 col : COLOR;
				LIGHTING_COORDS(5,6) // SHADOWS
				UNITY_FOG_COORDS(7)	// FOG
			};
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.posWorld = mul( unity_ObjectToWorld, v.vertex );
				
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				//o.tangentWorld = normalize( mul( unity_ObjectToWorld, v.tangent ).xyz );
				//o.binormalWorld = normalize( cross( o.normalWorld, o.tangentWorld ) * v.tangent.w );
				o.lightDir = normalize(_WorldSpaceLightPos0.xyz);

				o.tex = v.texcoord;
				//o.col = _TintColor;

				TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				UNITY_TRANSFER_FOG(o, o.pos);	// FOG

				return o; 
			}
			
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				
				
				fixed3 normalDir = i.normalWorld;
				fixed3 lookDir =  normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				//fixed3 lightDir = normalize( _WorldSpaceLightPos0.xyz );
				
					// Texture
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy		* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				
					// Calculate Normal
				normalDir = i.normalWorld;// normalize(mul(localCoords, local2WorldTranspose));
				
					// Tone & Shadow
				_TonePower = 1;
				fixed myTone = max( (1 - _TonePower), saturate( round( dot( i.lightDir, normalDir ) + (1 - _ToneLimit)) ) ) ; // Returns either 1 or _TonePower.	
				myTone *= LIGHT_ATTENUATION(i);  // SHADOWS 			
				fixed4 myToneColor = saturate ( fixed4( myTone, myTone, myTone, 1 ) * 1.5  + (UnityAmbientLight ) );
				
					// Final Light
				fixed4 lightColorFinal = max(UnityAmbientLight, _LightColor0) * myToneColor 
										+ (1 - myToneColor) * (UnityAmbientLight);// * myShadowColor;
				
					// Final Output								
				float4 finalOutput = myTexture * lightColorFinal;
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				return finalOutput + _TintColor;
}
			
			
			ENDCG
		}
		
		
		
		Pass { Name "PRIMARYSIMPLE"
		Tags {"LightMode" = "ForwardBase" "Queue"="Geometry" "RenderType"="Geometry"}
			//Zwrite Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
				#pragma multi_compile_fog	
				#include "UnityCG.cginc"	// FOG + others
			
					// GPU Per-Instancing
					//#include "UnityCG.cginc"
					#pragma multi_compile_instancing

				// User Vars
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;

				// Unity Vars
			uniform float4 _LightColor0;
			
			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;

						// GPU Per-Instancing
						UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				fixed4 posWorld : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				//fixed4 col : COLOR;
				UNITY_FOG_COORDS(3)	// FOG
			};
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;

						// GPU Per-Instancing
						UNITY_SETUP_INSTANCE_ID(v);

				o.pos = UnityObjectToClipPos( v.vertex );
				o.posWorld = mul( unity_ObjectToWorld, v.vertex );
				
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				
				o.tex = v.texcoord;
				//o.col = _TintColor;

				UNITY_TRANSFER_FOG(o, o.pos);	// FOG

				return o; 
			}
			
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

					// Texture
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy		* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				
					// Final Light
				fixed4 lightFinal =  max(UnityAmbientLight, _LightColor0);
				
					// Final Output								
				float4 finalOutput = myTexture * lightFinal;
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				return finalOutput + _TintColor;
	
			}
			
			
			ENDCG
		}
		
		
		
		Pass { Name "PRIMARYSIMPLEUNLIT"
		Tags {"LightMode" = "ForwardBase" "Queue"="Geometry" "RenderType"="Geometry""IgnoreProjector"="True" }
			//Zwrite Off

			Fog { Mode Off }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
				
			
				// User Vars
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;

				// Unity Vars
			uniform float4 _LightColor0;
			
			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				fixed4 posWorld : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				//fixed4 col : COLOR;
			};
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.posWorld = mul( unity_ObjectToWorld, v.vertex );
				
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				
				o.tex = v.texcoord;
				
				//o.col = _TintColor;
				return o; 
			}
			
			fixed4 frag (vertexOutput i) : COLOR
			{

					// Texture
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy		* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				
					// Final Color								
				return _TintColor - (1 - myTexture);
	
			}
			
			
			ENDCG
		}
		
		
			Pass { Name "PRIMARYUNLITCOLOR"  // Used by: Character "Glass"
			Tags {"LightMode" = "ForwardBase" "Queue"="Geometry" "RenderType"="Geometry""IgnoreProjector"="True" }
			//Zwrite Off
			AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			Fog { Mode Off }
			//Cull Off

			//ZTest Less
			
			Blend SrcAlpha OneMinusSrcAlpha, Zero SrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

					// GPU Per-Instancing
					#pragma multi_compile_instancing
					#include "UnityCG.cginc"

				// User Vars
			uniform fixed4 _TintColor;
			uniform fixed4 _ShineColor = fixed4(1,1,1,1);
			uniform fixed4 _GlowColor;
			// uniform fixed4 _UnlitColor; // LEAVE THIS OFF!! UNITY_DEFINE_INSTANCED_PROP below is where it gets defined!

				// Unity Vars
			uniform float4 _LightColor0;
			
						// GPU Per-Instance Batching (so we can have one material with multiple colors?)
						UNITY_INSTANCING_BUFFER_START(Props)
							UNITY_DEFINE_INSTANCED_PROP(float4, _UnlitColor)
						UNITY_INSTANCING_BUFFER_END(Props)
						//	https://docs.unity3d.com/Manual/GPUInstancing.html 				// NOTE: Want TEXTURES? Check this out: https://www.reddit.com/r/Unity3D/comments/6uueox/gpu_instancing_texture2darray/   !!!!!

			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;

						// GPU Per-Instancing
						UNITY_VERTEX_INPUT_INSTANCE_ID

			};
			
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				//fixed4 posWorld : TEXCOORD1;
				//fixed3 normalWorld : TEXCOORD2;
				fixed4 col : COLOR;
			};
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;
				
						// GPU Per-Instancing
						UNITY_SETUP_INSTANCE_ID(v);
						o.col = UNITY_ACCESS_INSTANCED_PROP(Props,_UnlitColor); // o.col = lerp(_TintColor + _UnlitColor, _GlowColor, _GlowColor.a);
						o.col.rgb = lerp((_TintColor + o.col).rgb, _GlowColor.rgb, _GlowColor.a); // Fade toward GLOW
						//	https://docs.unity3d.com/Manual/GPUInstancing.html 				// NOTE: Want TEXTURES? Check this out: https://www.reddit.com/r/Unity3D/comments/6uueox/gpu_instancing_texture2darray/   !!!!!
				
				o.pos = UnityObjectToClipPos(v.vertex);

					/// Facing Color (white toward camera)  //
				//GOAL: Create a SHEEN when glass faces the camera!
				
				fixed3 normalWorld = normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz);
				fixed3 lookDir = normalize(WorldSpaceViewDir(v.vertex)); //normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				// Even out Y plane so that looking up/down at this vertex counts almost like looking directly at it.
				normalWorld = normalize(fixed3(normalWorld.x, normalWorld.y / 10, normalWorld.z));
				lookDir = normalize(fixed3(lookDir.x, lookDir.y / 10, lookDir.z));
				
				// Distance: Fade out dot of CAT EYE to invisible when you get far enough.
				float dist = saturate((length(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz) - 30) * 0.05f);

				// Get Dot Product
				float d = dot(normalWorld, lookDir);// normalize(_WorldSpaceCameraPos.xyz - o.pos.xyz), v.normal);

				// Saturate to make it extremely all-or-nothing (only respect DIRECT visual contact) 
				d = pow(saturate(d - dist), 20);
				// NOTE: This removes all but a little gradient
				// NOTE2: We put Saturate INSIDE the pow, because we need to get rid of negative dot products. This causes certain faces to
				//		  shine as they begin to face AWAY from camera.

				// Modify Dot by Alpha of Glass (which determines its GLOW, this it's more of a light source and not glass)
				d = lerp(d, 0, saturate(o.col.a * 5 - 4) );
				// NOTE: from 0 to 0.66, the shine will be 100%. from 0.6 to 1, shine will fade from full to nothing
				// NOTE2: Saturate is there to keep the lerp from going BACKWARDS toward MORE white.

				// Add WHITE to color based on dot (but reduce by Glow amount)
				//o.col = lerp( o.col, half4(1,1,1,1), d - _GlowColor.a);
				o.col = lerp(o.col, _ShineColor, d - _GlowColor.a);
				

				// Alpha is used to determine how GLOWY something is (and thus, how SHINY it ISN'T)
				// Thus, show color 100% as of NOW
				o.col.a = 1;

				return o; 
			}
			
			fixed4 frag (vertexOutput i) : COLOR
			{
				// Final Color
				return i.col; 
			}
			
			
			ENDCG
		}
		
		
		
		Pass { Name "PRIMARY GIBS"  // Used by: Character "Glass"
			Tags{ "LightMode" = "ForwardBase" } //"LightMode"="ShadowCaster"} // This here will make a pass totally a "shadowcaster", aka this pass would cast shadows only.
													//Zwrite Off
			AlphaTest Greater[fixed(0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
											 //ZTest Less
			Blend SrcAlpha OneMinusSrcAlpha, Zero SrcAlpha
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
				#pragma multi_compile_fog	
				#include "UnityCG.cginc"

						// GPU Per-Instancing
						#pragma multi_compile_instancing
						//#include "UnityCG.cginc"

						// GPU Per-Instance Batching (so we can have one material with multiple colors?)
						UNITY_INSTANCING_BUFFER_START(Props)
							UNITY_DEFINE_INSTANCED_PROP(fixed4, _BloodColor)
						UNITY_INSTANCING_BUFFER_END(Props)
						//	https://docs.unity3d.com/Manual/GPUInstancing.html				// NOTE: Want TEXTURES? Check this out: https://www.reddit.com/r/Unity3D/comments/6uueox/gpu_instancing_texture2darray/   !!!!!
						//uniform fixed4 _BloodColor;

			uniform sampler2D _MainTex;
			uniform fixed _ShadowLimit;
			uniform fixed _ToneLimit;
			uniform fixed _TonePower;
			uniform fixed4 _GlowColor;
			uniform float _BoneValue;

				// Unity Vars
			uniform float4 _LightColor0;
			
			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;

						// GPU Per-Instancing
						UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct vertexOutput {
				fixed4 col : COLOR;
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				fixed4 posWorld : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				UNITY_FOG_COORDS(3)	// FOG
			};
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;

						// GPU Per-Instancing
						UNITY_SETUP_INSTANCE_ID(v);
						o.col = UNITY_ACCESS_INSTANCED_PROP(Props, _BloodColor);
						//	https://docs.unity3d.com/Manual/GPUInstancing.html				// NOTE: Want TEXTURES? Check this out: https://www.reddit.com/r/Unity3D/comments/6uueox/gpu_instancing_texture2darray/   !!!!!

						// Fade color toward White
						o.col.rgb = lerp(o.col.rgb, fixed3(1, 1, 1), _BoneValue);

				o.pos = UnityObjectToClipPos( v.vertex );
				o.posWorld = mul( unity_ObjectToWorld, v.vertex );
				
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				
				o.tex = v.texcoord;

				UNITY_TRANSFER_FOG(o, o.pos);	// FOG

				//UNITY_INITIALIZE_OUTPUT(vertexOutput, o); // I don't know why this was needed. But it was. Otherwise, I get an "variable o used without being initialzied" error...
				return o; 
			}
			
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				
					// ** REMEMBER! **
					// Gibs are affected by light, but not color. of that light This is how I should revisit trying to portray them.
				
				fixed3 normalDir = i.normalWorld;
				fixed3 lookDir =  normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				fixed3 lightDir = normalize( _WorldSpaceLightPos0.xyz );
				
					// Texture
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				
					// Ambient Light
				//fixed ambGrey = (_LightColor0.r + _LightColor0.g + _LightColor0.b + 1) / 4;
				//fixed4 myAmbient = saturate( ( fixed4( ambGrey, ambGrey, ambGrey, 1) + _LightColor0 + fixed4(1, 1, 1, 1) * 3) / 5 );
				
					// Tone & Shadow
				_TonePower = 1;
				fixed myTone = max( (1 - _TonePower), saturate( round( dot( lightDir, normalDir ) + (1 - _ToneLimit)) ) ) ; // Returns either 1 or _TonePower.				
				fixed4 myToneColor = saturate ( fixed4( myTone, myTone, myTone, 1 ) * 1.5  + (UnityAmbientLight ) );
			
					// Final Light
				fixed4 lightColorFinal = max(UnityAmbientLight, _LightColor0) * myToneColor + (1 - myToneColor) * (UnityAmbientLight);// * myShadowColor;
				fixed dimness = (lightColorFinal.r + lightColorFinal.g + lightColorFinal.b) / 3;

					// Final Output								
				float4 finalOutput = myTexture * i.col * dimness;// * lightColorFinal;
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				
				// Apply Glow (for flashing Characters
				finalOutput.rgb = lerp(finalOutput, _GlowColor, _GlowColor.a); // Glow added! Overwrites any color and ignores Fog.
				
				// Respect Alpha
				finalOutput.a = myTexture.a;
				return finalOutput;

			}
			
			
			ENDCG
		}
			
	}
}