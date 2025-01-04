// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/Particle: Blood" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader {

	Tags{ "LightMode" = "ForwardBase" "IgnoreProjector" = "True" "Queue" = "Transparent+60" }
		Pass{
			LOD 100
			Lighting Off
			//AlphaTest Greater [_Cutoff]
			AlphaTest Greater[fixed(0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			Cull Off
			ZTest Less
			ZWrite off
			Fog{ Mode Off }
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			sampler2D _MainTex;
			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed4 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				fixed4 col : COLOR;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				
				o.tex = v.texcoord;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.col = v.color;
				
				return o;
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				return fixed4(i.col.r, i.col.g, i.col.b, myTexture.a * i.col.a);
			}
			
			
			ENDCG
		}
	} 
	
}
