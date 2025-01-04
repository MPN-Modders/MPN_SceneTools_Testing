// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Madness/Unlit Color (Character, Non-Colorizable)" { // (Mask-Safe) DO NOT USE" {
	Properties {
		//_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,0,0,1)
	 		//_Outline ( "Outline Thickness", Range (0.01, 0.1) ) = 0.1
	 		//_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)

	}
	SubShader {

	
	
	
	
	
		Tags { "Queue"="Geometry+40" }	// Add this to ANY SHADER that does not require a silhouette behind it.
		
/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////
		/*Pass {
		Tags { "LightMode" = "ForwardBase"}
			Fog { Mode Off }
		 	ZTest Less
			Cull Front
			Lighting Off
										//ZWrite Off
										//ZTest Always
										//ColorMask RGB // alpha not used
			//Zwrite Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

			
			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
			
			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
			};
			
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
			};
			
			vertexOutput vert (vertexInput v) {
			
			 	vertexOutput o;
			    fixed4 thisPos = mul( UNITY_MATRIX_MV, v.vertex); 
			    fixed3 normalDir = mul( (fixed3x3)UNITY_MATRIX_IT_MV, v.normal);  
			    normalDir.z = -0.4; // Original called for -0.4
				fixed thisDistance = length(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz) * 0.03; // Change outline by distance.
			    thisPos = thisPos + fixed4(normalize(normalDir),0) * ( _Outline * thisDistance );
			    o.pos = mul(UNITY_MATRIX_P, thisPos);
			 		
			    return o;		
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
				
				return _OutlineColor;
			}
			
			
			ENDCG		
		}
		*/
	
	
	
	
	
		Pass {
			Tags {"LightMode"="ForwardBase"}
			//LOD 100
			Lighting Off
			Fog { Mode Off }
			//AlphaTest Greater [_Cutoff]
			AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			//uniform sampler2D _MainTex;
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
				//fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				//return fixed4(_Color.r, _Color.g, _Color.b, myTexture.a);
				return _Color;
			}
			
			
			ENDCG
		}
	} 
	
}
