// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/Light Surface (Cutout)" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_LightColor ("LightColor", Color) = (1,1,1,1)
		//_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_Illumination ( "Illumination", Range (0, 1) ) = 1
		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)

	}
	SubShader {
			Tags {"LightMode" = "ForwardBase""Queue" = "Transparent+60" "IgnoreProjector" = "True" "RenderType" = "Transparent+60"}

		
		Pass {
			LOD 100
			Lighting Off
			AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			ZTest Less
			ZWrite off // Transition Arrows use this, since ALL door lights use this shader. THUS, we gotta keep it off.
			Cull Back
			//Fog { Mode Off }
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#pragma target 3.0
				#pragma multi_compile_fog	
				#pragma multi_compile_fwdadd_fullshadows 
				#pragma multi_compile_shadowcaster

			#include "UnityCG.cginc"	// FOG + others

			uniform sampler2D _MainTex;
			uniform fixed4 _LightColor;
			uniform fixed _Illumination;
			
			uniform float4 _LightColor0;
			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
				UNITY_FOG_COORDS(3)	// FOG
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				
				o.tex = v.texcoord;
				o.pos = UnityObjectToClipPos( v.vertex );
				
				UNITY_TRANSFER_FOG(o, o.pos);	// FOG
				return o;
			}
			
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				
				fixed4 lightColorFinal = max(UnityAmbientLight, _LightColor0);// * myShadowColor;					// Rim Light (Sourced)				

				fixed3 finalColor = myTexture * lightColorFinal;	// Texture * Room Light
				UNITY_APPLY_FOG(i.fogCoord, finalColor);			// FOG (apply BEFORE illumination)
				finalColor = lerp(finalColor, _LightColor, _Illumination); // Apply Light Illumination

				return fixed4(finalColor, myTexture.a);
			}
			
			
			ENDCG
		}


	} 
	FallBack "Standard"

}
