// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/Effect: 80sGlow [Character]" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_EightiesColor("Glow Color", Color) = (1, 0, 0, 0.5)
		_Transparent("Transparent", Range(0, 1)) = 1
	}
		SubShader{
		Tags { "Queue" = "Transparent"  "IgnoreProjector" = "True" } 	// This places this shader in front of TerrainDeet (skirts on walls, etc).
		Tags { "RenderType" = "Opaque"}



		Pass {
		Tags {"LightMode" = "ForwardBase" }
		//BlendOp  Max
		//Blend DstAlpha One	
		Blend SrcAlpha One
		AlphaTest Greater[_Cutoff]
		Lighting Off
		Fog { Mode Off }
		Cull Back
		ZWrite off
		ZTest Less

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				sampler2D _MainTex;
				float _Transparent;
				//fixed4 _EightiesColor;

				#include "UnityCG.cginc" // Needed for lookDir to use WorldSpaceViewDir()

								// GPU Per-Instancing
								#pragma multi_compile_instancing

								// GPU Per-Instance Batching (so we can have one material with multiple colors?)
								UNITY_INSTANCING_BUFFER_START(Props)
									UNITY_DEFINE_INSTANCED_PROP(float4, _EightiesColor)
								UNITY_INSTANCING_BUFFER_END(Props)
								//	https://docs.unity3d.com/Manual/GPUInstancing.html 				// NOTE: Want TEXTURES? Check this out: https://www.reddit.com/r/Unity3D/comments/6uueox/gpu_instancing_texture2darray/   !!!!!

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
					fixed fadeAmount : TEXCOORD1;
					fixed4 col : COLOR;
				};

				vertexOutput vert(vertexInput v)
				{
					vertexOutput o;

					o.tex = v.texcoord;
					o.pos = UnityObjectToClipPos(v.vertex);

					fixed3 normalWorld = UnityObjectToWorldNormal(v.normal);
					fixed3 lookDir = normalize(WorldSpaceViewDir(v.vertex));

					o.fadeAmount = saturate((abs(dot(lookDir, normalWorld)) - 0.2f) * 3);   //   Use on Sphere Shader:  saturate(abs(dot(lookDir, normalWorld)) - 0.75f) * 2;
					// IMPORTANT: In Isometric view, this dot product will NOT look right! Make sure to test in Perspectiove view!
					
								// GPU Per-Instancing
								UNITY_SETUP_INSTANCE_ID(v);
								o.col = UNITY_ACCESS_INSTANCED_PROP(Props, _EightiesColor);
								//	https://docs.unity3d.com/Manual/GPUInstancing.html 				// NOTE: Want TEXTURES? Check this out: https://www.reddit.com/r/Unity3D/comments/6uueox/gpu_instancing_texture2darray/   !!!!!

					return o;
				}

				fixed4 frag(vertexOutput i) : COLOR
				{
					fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				
					return fixed4(i.col.r, i.col.g, i.col.b, i.col.a * _Transparent * i.fadeAmount * myTexture.a);
				}


				ENDCG
			}
		}

}
