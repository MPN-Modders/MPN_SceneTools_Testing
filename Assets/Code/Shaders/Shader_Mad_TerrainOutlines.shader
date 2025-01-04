// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Madness/Terrain - Outlines"{
	Properties {
	 		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
	}
	
	CGINCLUDE
		//#include "UnityCG.cginc"
		//#include "AutoLight.cginc"
		//#include "Lighting.cginc"
	ENDCG


SubShader {
	
	
		Tags { "Queue"="Geometry+40" }	// Add this to ANY SHADER that does not require a silhouette behind it.
	
	
	
		// NOTE: If errors, destroy this pass! This was added as a test for toon shading.
	
		Pass {
		Tags { "LightMode" = "ForwardBase" "IgnoreProjector"="True"}
			Cull Off
			Lighting Off
										//ZWrite Off
										//ZTest Always
										//ColorMask RGB // alpha not used
			//Zwrite Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
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
				fixed4 thisPos = mul(UNITY_MATRIX_MV, v.vertex); // NOTE: Tried using UnityObjectToClipPos(v.vertex) but it just comes out invisible.
			    fixed3 normalDir = mul( (fixed3x3)UNITY_MATRIX_IT_MV, v.normal); // Must keep v.normal without making it negative. This keeps corners connected.
			    normalDir.z = 1; // Original called for -0.4
				fixed thisDistance = length(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz) * 0.02; // Change outline by distance. Low number equals less change.
			    thisPos = thisPos + fixed4(normalize(normalDir),0) * ( _Outline * thisDistance );
			    o.pos = mul(UNITY_MATRIX_P, thisPos);
			 		
			    return o;			
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
				
				return _OutlineColor;
			}
			
			
			ENDCG		
		}
	
	}
}