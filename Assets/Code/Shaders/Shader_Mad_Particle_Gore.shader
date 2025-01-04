// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/Particle: Gore" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Outline("Outline Thickness", Range(0.05, 0.4)) = 0.05
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
	}
		SubShader{

		Tags {"LightMode" = "ForwardBase""Queue" = "Transparent+0"  "RenderType " = "Transparent+60" }  // Was Transparent+0 on 1/3/19
		Lighting Off
		//ZTest Less // No difference from the default LEqual, apparently. 
		//ZWrite off
			//Fog { Mode off }
			//Blend SrcAlpha OneMinusSrcAlpha
			//AlphaTest Greater[fixed(0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html

					//AlphaToMask On // This doesn't work. SHOULD prevent alpha from obscuring other alphas beneath.
					//ColorMask RGB // Don't need, was just playing with this.

				Pass {

					CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma multi_compile_fwdbase

					uniform sampler2D _MainTex;
					uniform fixed4 _LightColor0;

					struct vertexInput {
						fixed4 vertex : POSITION;
						fixed3 normal : NORMAL;
						fixed4 texcoord : TEXCOORD0;
						fixed4 color : COLOR;
					};
					struct vertexOutput {
						fixed4 pos : SV_POSITION;
						fixed4 tex : TEXCOORD1;
						fixed3 normalWorld : TEXCOORD2;
						//LIGHTING_COORDS(5,6) // SHADOWS
						fixed4 col : COLOR;
					};

					vertexOutput vert(vertexInput v) {
						vertexOutput o;
						o.pos = UnityObjectToClipPos(v.vertex);
						o.tex = v.texcoord;
						o.normalWorld = normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz);
						o.col = v.color;
						//TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
						return o;
					}
					fixed4 frag(vertexOutput i) : COLOR
					{
						fixed3 normalDir = i.normalWorld;
						fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
						fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
						float lightFinal = dot(lightDir, normalDir);// * (LIGHT_ATTENUATION(i) * saturate(dot(fixed3(0.0f, 1.0f, 0.0f), lightDir))); // SHADOWS
						float4 lightColorFinal = ((_LightColor0)+(1 - lightFinal) * (UNITY_LIGHTMODEL_AMBIENT) * 0.5);

						return fixed4(i.col.rgb * myTexture.rgb * lerp(1, lightFinal, 0.5) * (lightColorFinal), 1);
					}

					ENDCG
				}


		    /////////////////////////////////////////
            //			TOON OUTLINE
            /////////////////////////////////////////
            UsePass "Madness/StoredPasses/Outline/OUTLINE"

		}

}
