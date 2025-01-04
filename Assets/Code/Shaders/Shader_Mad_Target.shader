// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/Target Reticle" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainColor ("Main Color", Color) = (1, 0, 0, 0.5)
		_Intensity("Intensity", Range(0, 1)) = 1
		_Transparent("Transparency", Range(0, 1)) = 1
	}
	SubShader {
	Tags { "Queue" = "Transparent+65"  "IgnoreProjector" = "True" } 	// This places this shader in front of TerrainDeet (skirts on walls, etc).
	Tags { "RenderType" = "Opaque"}
			
	

			//BlendOp  Max
			//Blend DstAlpha One	
			//ZTest Less

			AlphaTest Greater[_Cutoff]
			Lighting Off
			Fog{ Mode Off }
			Cull off
			Zwrite Off

		// First Pass: 
		Pass {
			Tags {"LightMode"="ForwardBase" }
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			sampler2D _MainTex; uniform float4 _MainTex_ST;
			fixed4 _MainColor;
			uniform fixed _Intensity;
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
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				return fixed4(_MainColor.r, _MainColor.g, _MainColor.b, myTexture.a * pow(_MainColor.a, 3) * _Intensity * _Transparent);
			}
			
			
			ENDCG
		}

		Pass {
			Tags {"LightMode"="ForwardBase" }
			Blend SrcAlpha One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			sampler2D _MainTex; uniform float4 _MainTex_ST;
			fixed4 _MainColor;
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
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				return fixed4(_MainColor.r, _MainColor.g, _MainColor.b, myTexture.a * _MainColor.a * _Transparent);
			}
			
			
			ENDCG
		}


	

				
	} 
	
}
