// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//	#include "Assets/Resources/Code/Shaders/Include_Default.cginc"
// 
// 	This is where functions will be stored that need to be recycled by 
//	Pass Storage shaders, to then be passed on to each of my shaders.




	
																										// CALCULATIONS //


		/////////////////////////////////////////
		//			INPUT / OUTPUT
		/////////////////////////////////////////
			//#pragma multi_compile_fwdadd_fullshadows
			//#pragma multi_compile_fog	
			//#include "UnityCG.cginc"
			//#include "AutoLight.cginc"

 
			struct vertexInput_Color//OutlineBasic
			{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
			};
			struct vertexOutput_Color//OutlineBasic
			{
				fixed4 pos : SV_POSITION;
			};

			struct vertexInput_Texture//OutlineWound
			{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};

			struct vertexOutput_Texture//OutlineWound 
			{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
			};


			struct vertexOutput_Shadow {
				fixed4 col : COLOR;
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				LIGHTING_COORDS(5, 6) // SHADOWS
				UNITY_FOG_COORDS(3)	// FOG
			};




			/////////////////////////////////////////
			//			SECONDARY LIGHTS
			/////////////////////////////////////////

					vertexOutput_Shadow vert_SecondaryLight_CALCULATE(vertexInput_Texture v, float inNormalInvert) 
					{
						//_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
						vertexOutput_Shadow o;

						o.pos = UnityObjectToClipPos(v.vertex);
						o.tex = v.texcoord;
						o.normalWorld = normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz) * inNormalInvert;	// <------ Inversion for Cutout Backfaces to receive light

						fixed4 posWorld = mul(unity_ObjectToWorld, v.vertex); 							// ADDED for LIGHT DIRECTION
						fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz - posWorld.xyz); 			// ADDED for LIGHT DIRECTION
						o.col = _LightColor0 * saturate(dot(lightDir * 40, o.normalWorld));			// ADDED for LIGHT DIRECTION  ("* 40" makes sure that the light stays BRIGHT up until the dot product gets to the back of the object. then it's 0)
						// NOTE ON ABOVE: Lights snap on terrain/cutouts because of the *40. Increase to *100 to remove ALL blending. 

						TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
						UNITY_TRANSFER_FOG(o, o.pos);	// FOG

						return o;
					}

			// VERTEX

			// Standard: Point lights on most surfaces
			vertexOutput_Shadow vert_SecondaryLight(vertexInput_Texture v) 
			{
				return vert_SecondaryLight_CALCULATE(v,1);
			}
			// Inverted: Point lights on backfaces (cutouts)
			vertexOutput_Shadow vert_SecondaryLight_Backface(vertexInput_Texture v) 
			{
				return vert_SecondaryLight_CALCULATE(v, -1);
			}

			// FRAG

			float4 frag_SecondaryLight(vertexOutput_Shadow i) : COLOR
			{
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.

					// Final Output								
				float4 finalOutput = myTexture * i.col * LIGHT_ATTENUATION(i);
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				return finalOutput + _TintColor;
			}


