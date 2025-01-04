// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/GUI - Bar" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,0,0,1)
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_Brighten ("Brighten Range", Range (-1,1)) = 0.3
		_Transparent ("Transparency Range", Range (0,1)) = 1 // This is how faded the bar is. SWAIN IS A SHADER GOD.
	}
	SubShader {
	Tags {"Queue"="Transparent+10"  "RenderType "="Transparent+10" }
	LOD 100
	Blend SrcAlpha OneMinusSrcAlpha 
	AlphaTest Greater [fixed(0.01)]
	Lighting Off
	ZWrite Off
	
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			sampler2D _MainTex;
			fixed4 _Color;
			fixed _Cutoff;
			fixed _Brighten;
			fixed _Transparent;
			
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
				_Brighten += _Cutoff;
				return fixed4(_Color.r + (1 - myTexture.a) * _Brighten, 
							  _Color.g + (1 - myTexture.a) * _Brighten,
							  _Color.b + (1 - myTexture.a) * _Brighten,
							  _Transparent * ceil(myTexture.a - _Cutoff) );
			}
			
			
			ENDCG
		}
	} 
	
}
