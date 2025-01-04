// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/GUI - Color" {
	Properties {
		_Color ("Color", Color) = (1,0,0,1)
	}
	SubShader {
	
	Tags {"Queue"="Transparent+10"  "RenderType "="Transparent+10" }
	Lighting Off
	ZTest Less
	ZWrite Off
	AlphaTest Greater [fixed (0.01)]
	
		Pass {
	Blend SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			uniform fixed4 _Color;
			
			struct vertexInput{
				fixed4 vertex : POSITION;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				
				return o;
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
				return _Color;
			}
			
			
			ENDCG
		}
	} 
	
}
