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
			//			Cutoffs
			/////////////////////////////////////////

			

					vertexOutput_Shadow vert_Cutout_CALCULATE(vertexInput_Texture v, float inNormalInvert) 
					{
						vertexOutput_Shadow o;
						o.pos = UnityObjectToClipPos(v.vertex);
						o.tex = v.texcoord;
						o.normalWorld = normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz) * inNormalInvert; 	// <------ Inversion for Cutout Backfaces to receive light
						TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
						UNITY_TRANSFER_FOG(o, o.pos);	// FOG
						return o;
					}

			// VERTEX

			vertexOutput_Shadow vert_Cutout(vertexInput_Texture v)
			{
				return vert_Cutout_CALCULATE(v,1);
			}
			vertexOutput_Shadow vert_Cutout_Backface(vertexInput_Texture v)
			{
				return vert_Cutout_CALCULATE(v, -1);
			}

			// FRAG

			fixed4 frag_Cutout(vertexOutput_Shadow i) : COLOR
			{

				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

					// NOTE: Just copy this directly from Terrain - Shadow
				fixed3 normalDir = i.normalWorld;
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw + fixed2(_Offset, 0)); // _MainTex_ST is how we calculate OFFSET.);

				float lightFinal = saturate(dot(lightDir, normalDir) * 2);// * saturate(dot(fixed3(0.0f, 1.0f, 0.0f), lightDir)); // SHADOWS
				lightFinal *= LIGHT_ATTENUATION(i);  // SHADOWS  // This makes sure shadows turn lightFinal (whether a surface is facing light) to darkness, THUS they use ambient color.

				float4 lightColorFinal = ((1 - lightFinal)) * UnityAmbientLight
										 + (lightFinal * max(UnityAmbientLight, _LightColor0));

				//myTexture.a = saturate(ceil(myTexture.a - _Transparent));
				float4 finalOutput = myTexture * lightColorFinal + fixed4(_TintColor.rgb,0);// * lightColorFinal; //lerp(1, lightFinal, 0.6) * lightColorFinal;
				UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
				finalOutput.a = saturate(ceil(finalOutput.a - _Transparent));
				return finalOutput;
			}
			