// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader  "Madness/GUI - Item" {
	Properties {
	 		_Outline ( "Outline Thickness", Range (0.05, 1) ) = 0.5
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
			_TintColor ( "Tint Color", Color ) = (1, 1, 1, 1)
	}
	
	SubShader {
		Tags {"Queue"="Transparent"  "RenderType "="Transparent"  "LightMode" = "ForwardBase" }
			Lighting Off
			Fog { Mode Off }
			//Zwrite Off
			
			/////////////////////////////////////////
			//			PRIMARY LIGHTS
			/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINEMENU"

/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////

		Pass {
			Cull Front
			Blend SrcAlpha OneMinusSrcAlpha 
	
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
				fixed4 thisPos = mul(UNITY_MATRIX_MV, v.vertex);
			    fixed3 normalDir = mul( (fixed3x3)UNITY_MATRIX_IT_MV, v.normal);  
			    normalDir.z = -0.4; // Original called for -0.4
				fixed thisDistance = length(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz) * 0.03; // Change outline by distance.
			    thisPos = thisPos + fixed4(normalize(normalDir),0) * ( _Outline * thisDistance);
			    o.pos = mul(UNITY_MATRIX_P, thisPos);
			 		
			    return o;			
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
				
				return _OutlineColor;
			}
			
			
			ENDCG		
		}
		
/////////////////////////////////////////
//			PRIMARY LIGHTS
/////////////////////////////////////////

		Pass {
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			
				// User Vars
			uniform fixed4 _TintColor;
			
				// Unity Vars
			uniform float4 _LightColor0;
			
			struct vertexInput {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
			};
			
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 col : COLOR;
			};
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.col = _TintColor;
				
				return o; 
			}
			
			fixed4 frag (vertexOutput i) : COLOR
			{
				return i.col;
			}
			
			
			ENDCG
		}
		
		
		
	
	}
}