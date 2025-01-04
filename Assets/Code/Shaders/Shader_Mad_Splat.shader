// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/Blood Splat" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color("Color", Color) = (1,0,0,1)
		//_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_Transparent ( "Transparent", Range (0, 1) ) = 1

	}
	SubShader {
	Tags {"LightMode"="ForwardBase" "IgnoreProjector"="True" "Queue"="Transparent"} // "Transparent+60"
	LOD 100
	Lighting Off
	//AlphaTest Greater [_Cutoff]
	AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
	Cull Off // Leave culling off! GPU Instancing keeps this from being an extra draw call <3 <3 
	ZTest Less
	ZWrite off
	Fog { Mode Off }
	Blend SrcAlpha OneMinusSrcAlpha
	
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

					// GPU Per-Instancing
					#pragma multi_compile_instancing
					#include "UnityCG.cginc"

			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed _Transparent;

						// GPU Per-Instance Batching (so we can have one material with multiple colors?)
						UNITY_INSTANCING_BUFFER_START(Props)
							UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
						UNITY_INSTANCING_BUFFER_END(Props)
						//	https://docs.unity3d.com/Manual/GPUInstancing.html				// NOTE: Want TEXTURES? Check this out: https://www.reddit.com/r/Unity3D/comments/6uueox/gpu_instancing_texture2darray/   !!!!!
						//uniform fixed4 _Color;

			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed4 texcoord : TEXCOORD0;

						// GPU Per-Instancing
						UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct vertexOutput{
				fixed4 col : COLOR;
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;

						// GPU Per-Instancing
						UNITY_SETUP_INSTANCE_ID(v);
						o.col = UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
						//	https://docs.unity3d.com/Manual/GPUInstancing.html				// NOTE: Want TEXTURES? Check this out: https://www.reddit.com/r/Unity3D/comments/6uueox/gpu_instancing_texture2darray/   !!!!!


				o.tex = v.texcoord;
				o.pos = UnityObjectToClipPos( v.vertex );

				return o;
			}
			
			/*fixed4 frag (vertexOutput i) : COLOR {
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				return fixed4(_Color.r, _Color.g, _Color.b, myTexture.a * _Color.a * _Transparent);
			}*/
			fixed4 frag(vertexOutput i) : COLOR
			{
				// Take Alpha from Texture, multiply by _Trasparent and Color's alpha.
				i.col.a = i.col.a * _Transparent * tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw).a; // _MainTex_ST is how we calculate OFFSET.

				return  i.col;
			}
			
			
			ENDCG
		}
	} 
	
}
