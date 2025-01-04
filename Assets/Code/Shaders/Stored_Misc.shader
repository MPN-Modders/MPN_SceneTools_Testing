// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/StoredPasses/Misc"{
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
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Transparent ( "Transparent", Range (0, 1) ) = 1
		_TintColor ( "Tint Color", Color ) = (0, 0, 0, 0)
	}
	
SubShader {





/////////////////////////////////////////
//				DEETS
/////////////////////////////////////////


		Pass { Name "DEETSALPHA"
		Tags{"LightMode" = "ForwardBase"}
			Lighting On
			ZTest LEqual // No difference from the default LEqual, apparently. 
			Blend SrcAlpha OneMinusSrcAlpha
			AlphaTest Greater [fixed (0.1)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			
					//AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
					//ZWrite On
			AlphaToMask Off	// AlphaToMask is more for Cutouts. We CAN use it, but it doesn't deal in soft blends like Detail ought to.
			ZWrite Off		

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdadd_fullshadows 
				#pragma multi_compile_fog	
			// NOTE: target 3.0 was added as of 6/23/16, and I don't know if it's necessary. But it seemed to get rid of errors on Build
			#pragma target 3.0 			
			//
			#include "UnityCG.cginc"
            #include "AutoLight.cginc" //#include "TerrainEngine.cginc"
			
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed _Transparent;
			uniform fixed4 _LightColor0;
			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				LIGHTING_COORDS(5,6) // SHADOWS
				UNITY_FOG_COORDS(3)	// FOG
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				UNITY_TRANSFER_FOG(o, o.pos);	// FOG
				return o;
			}
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				
					// NOTE: Just copy this directly from Terrain - Shadow
				fixed3 normalDir = i.normalWorld;
				fixed3 lightDir = normalize( _WorldSpaceLightPos0.xyz );
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				
				float lightFinal = saturate ( dot( lightDir, normalDir ) * 2);// * saturate(dot(fixed3(0.0f, 1.0f, 0.0f), lightDir)); // SHADOWS
				lightFinal *= LIGHT_ATTENUATION(i);  // SHADOWS  // This makes sure shadows turn lightFinal (whether a surface is facing light) to darkness, THUS they use ambient color.
				
				float4 lightColorFinal = ((1 - lightFinal)) * UnityAmbientLight 
										 + (lightFinal * max(UnityAmbientLight, _LightColor0));

				lightColorFinal.a = 1; // Without this, light was making things LESS transparent the more into the light they are.
				
				//myTexture.a *= _Transparent;
				float4 finalOutput = myTexture * lightColorFinal;// * lightColorFinal; //lerp(1, lightFinal, 0.6) * lightColorFinal;
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				finalOutput.a *= _Transparent;
				return finalOutput;
			}
			
			ENDCG
		}




		Pass { Name "DEETSCUTOUT"
			Tags {"LightMode"="ForwardBase"}// "RenderType "="Transparent+60" }
			Lighting On
			//ZTest Less // No difference from the default LEqual, apparently. 
			//ZWrite on
			//Blend SrcAlpha OneMinusSrcAlpha
			Blend SrcAlpha OneMinusSrcAlpha, Zero SrcAlpha
			AlphaTest Greater [_Transparent]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
			Cull Back
			
			CGPROGRAM
			#pragma vertex vert_Cutout
			#pragma fragment frag_Cutout
			#pragma multi_compile_fwdadd_fullshadows 
				#pragma multi_compile_fog	
			#include "UnityCG.cginc"
            #include "AutoLight.cginc"
			
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed _Transparent;
			
			uniform fixed4 _LightColor0;
			
			uniform fixed _Offset;
			
			#include "Include_Cutoffs.cginc"  // <--- Also contains Cutout stuff because of shared variables.

			
			ENDCG
		}
		Pass { Name "DEETSCUTOUT_BACKFACE"
			Tags {"LightMode"="ForwardBase"}// "RenderType "="Transparent+60" }
			Lighting On
			Blend SrcAlpha OneMinusSrcAlpha, Zero SrcAlpha
			AlphaTest Greater [_Transparent]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
			Cull Front
			
			CGPROGRAM
			#pragma vertex vert_Cutout_Backface
			#pragma fragment frag_Cutout
			#pragma multi_compile_fwdadd_fullshadows 
				#pragma multi_compile_fog	
			#include "UnityCG.cginc"
            #include "AutoLight.cginc"
			
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed _Transparent;
			
			uniform fixed4 _LightColor0;
			
			uniform fixed _Offset;
			
			#include "Include_Cutoffs.cginc"  // <--- Also contains Cutout stuff because of shared variables.

			
			ENDCG
		}

		
		//From https://answers.unity.com/questions/1003169/shadow-caster-shader.html
		Pass{
			Name "SHADOWPASS"
			Tags{ "LightMode" = "ShadowCaster" }

			Fog{ Mode Off }
			//ZWrite On ZTest Less Cull Off  // REMOVED 7/20/20 - Don't seem to do anything, AND they were blocking up the 4th wall in the Door Kickers Tower1 stage which caused Depth of Field to blur EVERYTHING.
			Offset 1, 1
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"
							#pragma multi_compile_instancing

				sampler2D _MainTex;

			struct v_in
			{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;

				// GPU Per-Instancing
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 uv : TEXCOORD1;
			};


			v2f vert(v_in v)
			{
				v2f o;

						// GPU Per-Instancing
						UNITY_SETUP_INSTANCE_ID(v);

				o.uv = v.texcoord;
				TRANSFER_SHADOW_CASTER(o)

				return o;
			}

			float4 frag(v2f i) : COLOR
			{
				fixed4 c = tex2D(_MainTex, i.uv);
				clip(c.a - 0.9);
				SHADOW_CASTER_FRAGMENT(i)
			}

			ENDCG
		}

		Pass{
			Name "SHADOWPASS_CHARACTER"
			Tags{ "LightMode" = "ShadowCaster" }

			Fog{ Mode Off }
			//ZWrite On ZTest Less Cull Off  // REMOVED 7/20/20 - Don't seem to do anything, AND they were blocking up the 4th wall in the Door Kickers Tower1 stage which caused Depth of Field to blur EVERYTHING.
			Offset 1, 1

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"


			sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform sampler2D _BloodTex;
			
			// Included so Include_Default works:
			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;


			#include "Include_Default.cginc"


			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 uv : TEXCOORD1;
			};


			v2f vert(appdata_full v)
			{
				v2f o;
				o.uv = v.texcoord;
				TRANSFER_SHADOW_CASTER(o)

				return o;
			}

			float4 frag(v2f i) : COLOR
			{
				fixed4 c = tex2D(_MainTex, i.uv 	* _MainTex_ST.xy + _MainTex_ST.zw);
				fixed4 myBloodTexture = tex2D(_BloodTex, i.uv 	* _MainTex_ST.xy + _MainTex_ST.zw);	// _MainTex_ST is how we calculate OFFSET.

				c.a = min(ReturnTextureCutoutAlpha(myBloodTexture.rgb), round(c.a));

				clip(c.a - 0.9);
				SHADOW_CASTER_FRAGMENT(i)
			}

			ENDCG
		}

		/////////////////////////////////////////
		//				LIGHTING (80s)
		/////////////////////////////////////////
		Pass{ 
			Name "80sLights"
			Tags {"LightMode" = "ForwardBase" }
			//BlendOp  Max
			//Blend DstAlpha One	
			Blend SrcAlpha One
			AlphaTest Greater[_Cutoff]
			Lighting Off
			Fog { Mode Off }
			Cull off
			ZTest Always

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			fixed4 _MainColor;

			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
			};

			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				o.tex = v.texcoord;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(vertexOutput i) : COLOR {
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				return fixed4(_MainColor.r, _MainColor.g, _MainColor.b, myTexture.a * _MainColor.a);
			}


			ENDCG
		}

	}
}