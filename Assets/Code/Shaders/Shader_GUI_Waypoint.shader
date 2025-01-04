// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/GUI - Waypoint" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,0,0,1)
		//_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_Transparent ( "Transparent", Range (0, 1) ) = 1

	}
	SubShader {
	
/////////////////////////////////////////
//			SELECT OUTLINE
/////////////////////////////////////////

	Tags { "Queue" = "Transparent+65" } 	// This places this shader in front of TerrainDeet (skirts on walls, etc).
	Tags { "RenderType" = "Opaque"}
			
	

	Pass {
	Tags {"LightMode"="ForwardBase" }
			Cull Off
			Lighting Off
			ZWrite Off
			ZTest Greater
										//ColorMask RGB // alpha not used
			Blend One OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			uniform sampler2D _MainTex;
			uniform fixed4 _Color;
			uniform fixed _Transparent;
			
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
				return fixed4(_Color.r * 0.15f, _Color.g * 0.15f, _Color.b * 0.15f, _Transparent  * 0.15f);
			}
			
			
			ENDCG		
		}
		
		
		Pass {
			Tags {"LightMode"="ForwardBase""IgnoreProjector"="True" "RenderType"="Transparent+60"}
	LOD 100
	Lighting Off
	//AlphaTest Greater [_Cutoff]
	AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
	Cull Off
	ZTest Less
	ZWrite off
	Fog { Mode Off }
	Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			uniform sampler2D _MainTex;
			uniform fixed4 _Color;
			uniform fixed _Transparent;
			
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
				return fixed4(_Color.r, _Color.g, _Color.b, myTexture.a * _Transparent);
			}
			
			
			ENDCG
		}
	} 
	
}
