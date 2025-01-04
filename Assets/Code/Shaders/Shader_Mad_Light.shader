// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/Light Surface" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_LightColor ("LightColor", Color) = (1,1,1,1)
		//_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_Illumination ( "Illumination", Range (0, 1) ) = 1
		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)

	}
	SubShader {
		//Tags { "RenderType" = "Opaque""Queue"="Geometry+0" }


		/////////////////////////////////////////
		//			TERRAIN
		/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Primary/PRIMARYTERRAIN"




		/////////////////////////////////////////
		//			LIGHT GLOW
		/////////////////////////////////////////
		Pass {
			Tags {"LightMode" = "ForwardBase" "Queue" = "Geometry" "RenderType" = "Geometry""IgnoreProjector" = "True" }
			//Zwrite Off
			AlphaTest Greater[fixed(0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			Fog { Mode Off }

			//ZTest Less

			Blend SrcAlpha OneMinusSrcAlpha, Zero SrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			// User Vars
			uniform fixed4 _LightColor;
			uniform fixed _Illumination;

			// Unity Vars
			uniform float4 _LightColor0;

			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
			};

			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				fixed4 posWorld : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				fixed4 col : COLOR;
			};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);

				o.normalWorld = normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz);

				o.col = lerp(fixed4(0,0,0,0), _LightColor, _Illumination); // Apply Light Illumination

				return o;
			}

			fixed4 frag(vertexOutput i) : COLOR
			{
				// Final Color
				return i.col;
			}


			ENDCG
		}


		/////////////////////////////////////////
		//			TOON OUTLINE
		/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINE"




	} 
	FallBack "Standard"

}
