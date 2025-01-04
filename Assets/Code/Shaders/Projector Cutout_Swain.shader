// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'

Shader "Projector/Cutout(Swain)" { 
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_ShadowTex ("Cookie", 2D) = "" {}
		_FalloffTex ("FallOff", 2D) = "" {}
		_Transparent("Transparency", Range(0, 1)) = 0.9
		_IgnoreLighting("IgnoreLighting", Range(0, 1)) = 0
	}
	Subshader {

		Pass {
			Tags {"LightMode" = "ForwardBase"} //  "Queue" = "Transparent"

			Lighting On

			ZWrite Off
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha//, One SrcAlpha    //Blend One SrcAlpha  This does a FLAT addition.
			Offset -1, -1
	 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog	
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			struct v2f {
				float4 uvShadow : TEXCOORD0;
				float4 uvFalloff : TEXCOORD1;
				fixed4 texcoord : TEXCOORD2;
				float4 pos : SV_POSITION;
				UNITY_FOG_COORDS(3)
			};
			
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;

			v2f vert (float4 vertex : POSITION)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (vertex);
				o.uvShadow = mul (unity_Projector, vertex);
				o.uvFalloff = mul (unity_ProjectorClip, vertex);
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}
			
			uniform fixed4 _LightColor0;
			sampler2D _ShadowTex;
			sampler2D _FalloffTex;
			fixed4 _Color;
			float _Transparent;
			float _IgnoreLighting;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				
				//return fixed4(0,0,0,0);
				//return fixed4(_LightColor0.rgb, 1);

				fixed4 texS = tex2Dproj(_ShadowTex, UNITY_PROJ_COORD(i.uvShadow));
				texS.rgb *= _Color.rgb * 1.5f;
				texS.rgb *= lerp(max(UnityAmbientLight, _LightColor0), fixed3(1,1,1), _IgnoreLighting);
				//texS.a = 1.0 - texS.a;

				fixed4 texF = tex2Dproj(_FalloffTex, UNITY_PROJ_COORD(i.uvFalloff));
				//UNITY_APPLY_FOG_COLOR(i.fogCoord, texS, fixed4(1,1,1,1));
				UNITY_APPLY_FOG(i.fogCoord, texS);	// FOG

				texS.a *= _Transparent * texF.a;

				return texS;
			}
			ENDCG
		}

			/*
		Pass{
				Tags{ "LightMode" = "ForwardAdd" }
				Zwrite On
				ZTest LEqual
				Blend SrcAlpha OneMinusSrcAlpha//, One SrcAlpha    //Blend One SrcAlpha  This does a FLAT addition.
				Cull Off
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				struct v2f {
					float4 pos : SV_POSITION;
				};
			
			uniform fixed4 _LightColor0;
			v2f vert(float4 vertex : POSITION)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(vertex);
				return o;
			}
			fixed4 frag(v2f i) : SV_Target
			{
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				_LightColor0 *= LIGHT_ATTENUATION(i);
				//return fixed4(0, 0, 1, 0.5f);
				return fixed4(_LightColor0.rgb,0.5f);
			}
				ENDCG
		}*/
	}
}
