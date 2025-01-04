// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/StoredPasses/Secondary"{
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


SubShader {

	
	
	//Tags { "RenderType" = "Opaque""Queue"="Geometry+0" }

		
	/////////////////////////////////////////
	//		SECONDARY LIGHTS
	/////////////////////////////////////////
									
									Pass {	Name "SECONDARYTERRAIN_SIMPLE"  // Used by world Terrain, because we can't use texture info to paint lights on Terrain!
							            Tags {"LightMode" = "ForwardAdd"}
							            
										Blend SrcAlpha One
							 			ZWrite Off
										ZTest Equal

							           CGPROGRAM
							            #pragma vertex vert
							            #pragma fragment frag
							            #pragma target 3.0 			

							            #pragma multi_compile_fwdadd_fullshadows
										#pragma multi_compile_fog	

							            #include "UnityCG.cginc"
							            #include "AutoLight.cginc"
							           // #include "Lighting.cginc"
										uniform float4 _LightColor0;

							           	struct vertexInput{
											fixed4 vertex : POSITION;
											fixed3 normal : NORMAL;
										};
										struct vertexOutput {
											fixed4 col : COLOR;
											fixed4 pos : SV_POSITION;
							      			LIGHTING_COORDS(5,6) // SHADOWS
											UNITY_FOG_COORDS(3)	// FOG
							            };
							 
							            vertexOutput vert (vertexInput v) {
											_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

							                vertexOutput o;
							                o.pos = UnityObjectToClipPos(v.vertex);
							                
											fixed3 normalDir = normalize( mul( fixed4(v.normal, 1), unity_WorldToObject ).xyz );		// ADDED for LIGHT DIRECTION
											fixed4 posWorld =  mul( unity_ObjectToWorld, v.vertex ); 									// ADDED for LIGHT DIRECTION
											fixed3 lightDir =  normalize( _WorldSpaceLightPos0.xyz - posWorld.xyz); 			// ADDED for LIGHT DIRECTION
											o.col = _LightColor0 * saturate ( dot( lightDir * 100, normalDir ) );// o.lightFinal = saturate ( dot( lightDir * 100, normalDir ) );						// ADDED for LIGHT DIRECTION  ("* 100" makes sure that the light stays BRIGHT up until the dot product gets to the back of the object. then it's 0)


							     			TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
											UNITY_TRANSFER_FOG(o, o.pos);	// FOG
							     			
							                return o;
							            }
							 
							            float4 frag (vertexOutput i) : COLOR 
							            {
							            		// Final Output								
											float4 finalOutput = i.col * LIGHT_ATTENUATION(i); // return _LightColor0 * LIGHT_ATTENUATION(i) * i.lightFinal;
											UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
											return finalOutput;
							             }
							            ENDCG
							        }



		Pass {	Name "SECONDARYTERRAIN_IMPROVED"
            Tags {"LightMode" = "ForwardAdd"}
            
			Blend SrcAlpha One
 			ZWrite Off
			ZTest Lequal // Was Equal, swapped to Lequal when glass kept flickering

			CGPROGRAM
            #pragma vertex vert_SecondaryLight		// inside Include_SecondLights.cginc
            #pragma fragment frag_SecondaryLight	// inside Include_SecondLights.cginc
            #pragma target 3.0 			

            #pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog	

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed4 _LightColor0;

			#include "Include_SecondLights.cginc"

            ENDCG
        }
		/// Used by SOME Cutouts to color their opposite side with Point Lights!
		Pass {	Name "SECONDARYTERRAIN_IMPROVED_BACKFACE"
			Tags {"LightMode" = "ForwardAdd"}
			Cull Front // ADDED to _BACKFACE light shader!

			Blend SrcAlpha One
			ZWrite Off
			ZTest Lequal // Was Equal, swapped to Lequal when glass kept flickering

			CGPROGRAM
			#pragma vertex vert_SecondaryLight_Backface		// inside Include_SecondLights.cginc
			#pragma fragment frag_SecondaryLight			// inside Include_SecondLights.cginc
			#pragma target 3.0 			

			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog	

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed4 _LightColor0;

			#include "Include_SecondLights.cginc"

			ENDCG
		}

		Pass{ Name "SECONDARYTERRAIN_IMPROVED_ALPHA"			// NOTE: IDENTICAL to SECONDARYTERRAIN_IMPROVED! Just uses Transparency!
			Tags {"LightMode" = "ForwardAdd"}

			Blend SrcAlpha One
			ZWrite Off
			ZTest Lequal // Was Equal, swapped to Lequal when glass kept flickering

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0 			

			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog	

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			// #include "Lighting.cginc"
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed4 _LightColor0;
			uniform fixed _Transparent = 1;
			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput {
				fixed4 col : COLOR;
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				LIGHTING_COORDS(5,6) // SHADOWS
				UNITY_FOG_COORDS(3)	// FOG
			};

			vertexOutput vert (vertexInput v) {
            	//_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				o.normalWorld = normalize( mul( fixed4(v.normal, 1), unity_WorldToObject ).xyz );

				fixed4 posWorld =  mul( unity_ObjectToWorld, v.vertex ); 									// ADDED for LIGHT DIRECTION
				fixed3 lightDir =  normalize( _WorldSpaceLightPos0.xyz - posWorld.xyz); 					// ADDED for LIGHT DIRECTION
				o.col = _LightColor0 * saturate ( dot( lightDir * 100, o.normalWorld ) );// ADDED for LIGHT DIRECTION  ("* 100" makes sure that the light stays BRIGHT up until the dot product gets to the back of the object. then it's 0)

     			TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				UNITY_TRANSFER_FOG(o, o.pos);	// FOG
     			
                return o;
            }

			float4 frag(vertexOutput i) : COLOR
			{
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.

					// Final Output								
				float4 finalOutput = myTexture * i.col * LIGHT_ATTENUATION(i);
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				finalOutput.a *= _Transparent;
				return (finalOutput + _TintColor);
			}
			ENDCG
		}












											Pass { Name "SECONDARYBASIC"
											Tags {"LightMode" = "ForwardAdd"}
												Blend One OneMinusSrcAlpha
												
												AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
												ZWrite Off
												ZTest Equal
												//AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
												

												CGPROGRAM
									            #pragma vertex vert
									            #pragma fragment frag

												#pragma multi_compile_fog	
									            #include "UnityCG.cginc"
									 
									            //#include "UnityCG.cginc" 	 // Taken from above. Not needed, I believe.
									            //#include "AutoLight.cginc" // Taken from above. Not needed, I believe.
									            // #include "Lighting.cginc"
									            
												uniform float4 _LightColor0;
												
												
												struct vertexInput{
													fixed4 vertex : POSITION;
													fixed3 normal : NORMAL;
												};
												struct vertexOutput{
													fixed4 pos : SV_POSITION;
													fixed4 col : COLOR;
													UNITY_FOG_COORDS(1)	// FOG
												};
												
												vertexOutput vert (vertexInput v) 
												{
													_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

													vertexOutput o;
													o.pos = UnityObjectToClipPos( v.vertex );
													fixed4 posWorld =  mul( unity_ObjectToWorld, v.vertex ); //_Object2World and UNITY_MATRIX_MVP not the same, look up difference!
													fixed3 normalDir = normalize( mul( fixed4(v.normal, 1), unity_WorldToObject ).xyz );
													fixed3 lookDir =  normalize( _WorldSpaceCameraPos.xyz - mul( unity_ObjectToWorld, v.vertex ).xyz);
														fixed3 vertexToLight =  _WorldSpaceLightPos0.xyz -  posWorld;
														fixed atten = saturate( pow( 1 / length(vertexToLight), 1.2 ) );
													fixed3 lightDir =  normalize( _WorldSpaceLightPos0.xyz - posWorld.xyz); //normalize( lerp( _WorldSpaceLightPos0.w, _WorldSpaceLightPos0.xyz, vertexToLight) ); // Modified for Point Lights
													
														// Amb Light
													fixed4 myAmbientLight = _LightColor0 * dot(normalDir, lightDir) * (atten * 0.5) * ( 1 - dot( lookDir, normalDir ) );
														// Rim Light (Sourced)
													fixed4 myRimLight = _LightColor0 * pow( 1 - dot( lookDir, normalDir ), 4) * atten;
													//fixed myRimLight = saturate ( pow( 1 - dot( lookDir, normalDir ), _RimFade ) * _RimDepth); // Rim currently does not use bump map
														// Specular Light
													//fixed mySpecLight = _LightColor0 * pow( max( 0.0, dot ( reflect( -lightDir, normalDir ) , lookDir) ), 2) * atten;//
													
													o.col = myRimLight + myAmbientLight;// + mySpecLight;

													UNITY_TRANSFER_FOG(o, o.pos);	// FOG
													
													return o;
												}
												fixed4 frag (vertexOutput i) : COLOR 
												{
													
												            		// Final Output								
													UNITY_APPLY_FOG(i.fogCoord, i.col);	// FOG
													return i.col;
												}
												
												
												ENDCG
											}

		Pass { Name "SECONDARYBASIC_IMPROVED"
		Tags {"LightMode" = "ForwardAdd"}
			//Blend One OneMinusSrcAlpha
			Blend SrcAlpha One

			AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			ZWrite Off
			ZTest Equal
			//AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.

           CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0 			

            #pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog	

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

           // #include "Lighting.cginc"
			uniform fixed4 _TintColor;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform sampler2D _EffectMap;
			uniform fixed4 _LightColor0;
			uniform fixed4 _CustomColor; uniform fixed4 _CustomColor2;

			#include "Include_Calculations.cginc"

           	struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput {
				fixed4 col : COLOR;
				fixed4 pos : SV_POSITION;
      			fixed4 tex : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				LIGHTING_COORDS(5,6) // SHADOWS
				UNITY_FOG_COORDS(3)	// FOG
            };

			vertexOutput vert (vertexInput v) 
			{
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

				vertexOutput o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.tex = v.texcoord;
				o.normalWorld = normalize( mul( fixed4(v.normal, 1), unity_WorldToObject ).xyz );

				fixed4 posWorld =  mul( unity_ObjectToWorld, v.vertex ); //_Object2World and UNITY_MATRIX_MVP not the same, look up difference!
				fixed3 lookDir =  normalize( _WorldSpaceCameraPos.xyz - mul( unity_ObjectToWorld, v.vertex ).xyz);
					//fixed3 vertexToLight =  _WorldSpaceLightPos0.xyz -  posWorld;
					//fixed atten = saturate( 1 / length(vertexToLight) );
				fixed3 lightDir =  _WorldSpaceLightPos0.xyz - posWorld.xyz; //normalize( lerp( _WorldSpaceLightPos0.w, _WorldSpaceLightPos0.xyz, vertexToLight) ); // Modified for Point Lights
				
					// Amb Light
				fixed4 myAmbientLight = 2 * _LightColor0 * dot(o.normalWorld, normalize(lightDir));// * (atten) * ( 1 - dot( lookDir, o.normalWorld ) );
					// Rim Light (Sourced)
				fixed4 myRimLight = _LightColor0 * pow(1 - dot(lookDir, o.normalWorld), 2);
				myRimLight *= 5 * saturate(20 / length(lightDir)); // 10;  // The FURTHER AWAY the light is from us, the more we're gonna reduce this.

				o.col = myAmbientLight + myRimLight;

				TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				UNITY_TRANSFER_FOG(o, o.pos);	// FOG
				
				return o;
			}
			fixed4 frag (vertexOutput i) : COLOR 
			{
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				fixed4 myEffectMap = tex2D(_EffectMap, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw);

				// Apply Custom Color
				float overlayValue = ReturnOverlayVal(myTexture.rgb);
				myTexture.rgb = ColorizeTexture(myTexture.rgb, overlayValue, myEffectMap.b, _CustomColor, _CustomColor2);
				//(fixed3 inTexture, fixed overlayValue, fixed map, fixed3 color1, fixed3 color2)

				// Reduce by Emission (point lights should not affect glowy parts on me)
				myTexture -= pow(myEffectMap.r, 2);

            		// Final Output								
				float4 finalOutput = myTexture * i.col * LIGHT_ATTENUATION(i);
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				return finalOutput + _TintColor;
			}
			
			
			ENDCG
		}
	
			




			Pass{ Name "REFLECTIONS"
				Tags {"LightMode" = "ForwardBase" "Queue" = "Geometry" "RenderType" = "Geometry""IgnoreProjector" = "True" }

				Blend SrcAlpha One
				ZWrite Off

				CGPROGRAM

				#pragma vertex vert_Reflect  
				#pragma fragment frag

				#include "UnityCG.cginc"
				#include "AutoLight.cginc"

				// User-specified uniforms
				float _CubeScaling;
				float _CubeAmount;
				uniform samplerCUBE _Cube;
				uniform sampler2D _EffectMap;
				uniform fixed4 _LightColor0;

				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float3 normalDir : TEXCOORD0;
					float3 viewDir : TEXCOORD1;
					float4 tex : TEXCOORD2;
						// Taken from Distort Shader
						float4 uvgrab : TEXCOORD3;
						float2 uvbump : TEXCOORD4;
				};

				// Taken from Distort Shader
				float _BumpAmt;
				sampler2D _BumpMap;
				float4 _BumpMap_ST;

			#include "Include_Reflect.cginc"


			float4 frag(vertexOutput input) : COLOR
			{
				float4 myMap = tex2D(_EffectMap, input.tex.xy);

				return ReflectColor(_BumpMap, _BumpMap_ST, _BumpAmt, _Cube, input.uvbump, input.viewDir, input.normalDir, _LightColor0) * myMap.g;
			}

			ENDCG
		}


			Pass{ Name "REFLECTIONS_MENU" // ONLY EXISTS so we can pass in the MENU light color
				Tags {"LightMode" = "ForwardBase" "Queue" = "Geometry" "RenderType" = "Geometry""IgnoreProjector" = "True" }

				Blend SrcAlpha One
				ZWrite Off

				CGPROGRAM

				#pragma vertex vert_Reflect  
				#pragma fragment frag

				#include "UnityCG.cginc"
				#include "AutoLight.cginc"

				// User-specified uniforms
				float _CubeScaling;
				float _CubeAmount;
				uniform samplerCUBE _Cube;
				uniform sampler2D _EffectMap;
				uniform float4 _MenuLightColor;

				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float3 normalDir : TEXCOORD0;
					float3 viewDir : TEXCOORD1;
					float4 tex : TEXCOORD2;
						// Taken from Distort Shader
						float4 uvgrab : TEXCOORD3;
						float2 uvbump : TEXCOORD4;
				};

				// Taken from Distort Shader
				float _BumpAmt;
				sampler2D _BumpMap;
				float4 _BumpMap_ST;

			#include "Include_Reflect.cginc"


			float4 frag(vertexOutput input) : COLOR
			{
				float4 myMap = tex2D(_EffectMap, input.tex.xy);

				return ReflectColor(_BumpMap, _BumpMap_ST, _BumpAmt, _Cube, input.uvbump, input.viewDir, input.normalDir, _MenuLightColor) * myMap.g;
			}

			ENDCG
		}

			Pass{ Name "REFLECTIONS_TERRAIN"
				Tags {"LightMode" = "ForwardBase" "Queue" = "Geometry" "RenderType" = "Geometry""IgnoreProjector" = "True" }

				Blend SrcAlpha One
				ZWrite Off

				CGPROGRAM

				#pragma vertex vert_Reflect  
				#pragma fragment frag

				#include "UnityCG.cginc"
				#include "AutoLight.cginc"

				// User-specified uniforms
				float _CubeScaling;
				float _CubeAmount;
				uniform samplerCUBE _Cube;
				uniform sampler2D _CubeMap; uniform float4 _CubeMap_ST;
				uniform fixed4 _LightColor0;

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float3 normalDir : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
				float4 tex : TEXCOORD2;
					// Taken from Distort Shader
					float4 uvgrab : TEXCOORD3;
					float2 uvbump : TEXCOORD4;
			};

				// Taken from Distort Shader
				float _BumpAmt;
				sampler2D _BumpMap;
				float4 _BumpMap_ST;

			#include "Include_Reflect.cginc"


			float4 frag(vertexOutput input) : COLOR
			{
				float4 myMap = tex2D(_CubeMap, input.tex.xy   * _CubeMap_ST.xy + _CubeMap_ST.zw);

				return ReflectColor(_BumpMap, _BumpMap_ST, _BumpAmt, _Cube, input.uvbump, input.viewDir, input.normalDir, _LightColor0) * myMap;  // TERRAIN: Use WHOLE map!
			}

			ENDCG
		}










	}

}