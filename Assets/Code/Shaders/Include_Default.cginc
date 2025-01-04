// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//	#include "Assets/Resources/Code/Shaders/Include_Default.cginc"
// 
// 	This is where functions will be stored that need to be recycled by 
//	Pass Storage shaders, to then be passed on to each of my shaders.




	
																										// CALCULATIONS //

	fixed ReturnTextureCutoutAlpha(fixed3 inBloodTexture)
	{
		return ceil((inBloodTexture.r + inBloodTexture.g + inBloodTexture.b) / 3.0);
	}



/////////////////////////////////////////
//			INPUT / OUTPUT
/////////////////////////////////////////

			// GPU Per-Instancing
			#include "UnityCG.cginc"
			#pragma multi_compile_instancing

	struct vertexInput_Color//OutlineBasic
	{
		fixed4 vertex : POSITION;
		fixed3 normal : NORMAL;

				// GPU Per-Instancing
				UNITY_VERTEX_INPUT_INSTANCE_ID
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





/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////
			
		// BASIC

			
			// Uses: 
			// uniform fixed _Outline;
			// uniform fixed4 _OutlineColor;

			vertexOutput_Color vert_OutlineBasic (vertexInput_Color v)
			{
				vertexOutput_Color o;

						// GPU Per-Instancing
						UNITY_SETUP_INSTANCE_ID(v);

			    fixed4 thisPos = mul( UNITY_MATRIX_MV, v.vertex);
			    fixed3 normalDir = normalize(mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal));
			    normalDir.z = -0.4; // Original called for -0.4
				fixed thisDistance = length(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz) * 0.03; // Change outline by distance.
			    thisPos = thisPos + fixed4(normalize(normalDir),0) * ( _Outline * thisDistance );
			    o.pos = mul(UNITY_MATRIX_P, thisPos);
			 		
			    return o;
			}
			float4 frag_OutlineBasic (vertexOutput_Color i) : COLOR
			{
				return _OutlineColor;
			}
			
			
			
			   
			
		// WOUND	
			
			
			// Uses: 
			// uniform fixed _Outline;
			// uniform fixed4 _OutlineColor;
			// uniform sampler2D _BloodTex;

			vertexOutput_Texture vert_OutlineWound (vertexInput_Texture v)
			{
				vertexOutput_Texture o;
			    fixed4 thisPos = mul( UNITY_MATRIX_MV, v.vertex); 
			    fixed3 normalDir = normalize(mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal));
			    normalDir.z = -0.4; // Original called for -0.4
				fixed thisDistance = length(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz) * 0.03; // Change outline by distance.
			    thisPos = thisPos + fixed4(normalize(normalDir),0) * ( _Outline * thisDistance );
			    o.pos = mul(UNITY_MATRIX_P, thisPos);
			    
			 	o.tex = v.texcoord;

			    return o;			
			}
			
			float4 frag_OutlineWound (vertexOutput_Texture i) : COLOR
			{
					// Blood Texture
				fixed4 myBloodTexture = tex2D(_BloodTex, i.tex.xy);
			
				return fixed4(_OutlineColor.rgb, min(ReturnTextureCutoutAlpha(myBloodTexture.rgb), round(_OutlineColor.a))); // Outline can now be turned off with a low alpha.
			}
	


