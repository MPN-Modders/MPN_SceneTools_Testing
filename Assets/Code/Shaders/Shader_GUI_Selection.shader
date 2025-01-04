// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/GUI - Select Object" {
	Properties {
		//_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainColor ("Main Color", Color) = (1, 0, 0, 0.5)
		_Outline("Outline Thickness", Range(0.05, 0.4)) = 0.05
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
	}
	SubShader {
			
		Tags{ "Queue" = "Transparent+1000" "IgnoreProjector" = "True" "RenderType" = "Opaque" }

		ZTest Gequal

		/////////////////////////////////////////
		//			TOON OUTLINE
		/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINE"

		ZTest Lequal

		Pass {
			Name "SELECTOBJECT"

			Tags {"LightMode"="ForwardBase" }
			Blend SrcAlpha One

		AlphaTest Greater[_Cutoff]
		Lighting Off
		Fog{ Mode Off }
		Cull Back
		Zwrite On

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			//sampler2D _MainTex;
			fixed4 _MainColor;
			
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
				//fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				return fixed4(_MainColor.r, _MainColor.g, _MainColor.b, /*myTexture.a * */ _MainColor.a);
				
					// IMPORTANT: We CAN'T include Texture here because THERE ISN'T ONE! This is the *Selection* material, and it is NOT a clone.
			}
			
			
			ENDCG
		}


	

				
	} 
	
}
