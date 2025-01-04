// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/Effect: 80sGlow" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainColor ("Main Color", Color) = (1, 0, 0, 0.5)
		_Transparent("Transparent", Range(0, 1)) = 1
	}
	SubShader {
	Tags { "Queue" = "Transparent+100"  "IgnoreProjector" = "True" } 	// This places this shader in front of TerrainDeet (skirts on walls, etc).
	Tags { "RenderType" = "Opaque"}
			
	

	Pass {
	Tags {"LightMode"="ForwardBase" }
	//BlendOp  Max
	//Blend DstAlpha One	
	Blend SrcAlpha One
	AlphaTest Greater [_Cutoff]
	Lighting Off
	Fog { Mode Off }
	Cull Off
	Zwrite Off
	ZTest Always

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			sampler2D _MainTex;
			fixed4 _MainColor;
			float _Transparent;

			#include "UnityCG.cginc" // Needed for lookDir to use WorldSpaceViewDir()
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				fixed fadeAmount : TEXCOORD1;
			};
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;
				
				o.tex = v.texcoord;
				o.pos = UnityObjectToClipPos( v.vertex );

				fixed3 normalWorld = UnityObjectToWorldNormal(v.normal);
				fixed3 lookDir = normalize(WorldSpaceViewDir(v.vertex));

				o.fadeAmount = saturate(   (abs(dot(lookDir, normalWorld)) - 0.2f) * 3);   //   Use on Sphere Shader:  saturate(abs(dot(lookDir, normalWorld)) - 0.75f) * 2;
				// IMPORTANT: In Isometric view, this dot product will NOT look right! Make sure to test in Perspectiove view!
				return o;
			}
			
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy);

				return fixed4(_MainColor.r, _MainColor.g, _MainColor.b, _MainColor.a * _Transparent * i.fadeAmount * myTexture.a);
			}
			
			
			ENDCG
		}
	} 
	
}
