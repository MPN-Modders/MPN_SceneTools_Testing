// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/GUI - Detail" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,0,0,1)
	}
	SubShader {
	
	Tags {"Queue"="Transparent+10"  "RenderType "="Transparent+10" }
	Lighting Off
	ZTest Less
	ZWrite Off
	AlphaTest Greater [fixed (0.01)]
	//Zwrite Off
	
		Pass {
	Blend SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			uniform sampler2D _MainTex;
			uniform fixed4 _Color;
			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				
				o.tex = v.texcoord;
				o.pos = UnityObjectToClipPos( v.vertex );
				
				return o;
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				return fixed4(_Color.rgb, myTexture.a * _Color.a);
			}
			
			
			ENDCG
		}
	} 
	
}
