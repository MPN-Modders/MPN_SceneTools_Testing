// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Per pixel bumped refraction.
// Uses a normal map to distort the image behind, and
// an additional texture to tint the color.

Shader "FX/Glass/BumpDistort (Swain)" {
Properties {
	_BumpAmt	("Distortion", range (-128,128)) = 10
	_MainTex	("Tint Color (RGB)", 2D) = "white" {}
	_BumpMap	("Normalmap", 2D) = "bump" {}
	_NormalUse	("EdgeSoften", range(0,1)) = 0

}

Category {

	// We must be transparent, so other objects are drawn before this one.
	Tags { "Queue"="Transparent+1000" "RenderType"="Opaque" }
	// ADDED 1000 so it happens after everything...

	SubShader {

		// This pass grabs the screen behind the object into a texture.
		// We can access the result in the next pass as _GrabTexture
		GrabPass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
		}


	// Main pass: Take the texture grabbed above and use the bumpmap to perturb it
	// on to the screen
	Pass {
		Name "BASE"
		Tags { "LightMode" = "Always" }

	ZWrite Off

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"


	struct appdata_t {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float2 texcoord: TEXCOORD0;
	};

	struct v2f {
		float4 vertex : SV_POSITION;
		float4 uvgrab : TEXCOORD0;
		float2 uvbump : TEXCOORD1;
		float2 uvmain : TEXCOORD2;
		float3 normalWorld : TEXCOORD3;
		fixed4 posWorld : TEXCOORD4;
		fixed3 lookDir : TEXCOORD64;
	};

		float _BumpAmt;
		float _NormalUse;
		float4 _BumpMap_ST;
		float4 _MainTex_ST;


	v2f vert (appdata_t v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.normalWorld = normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz); // SWAIN ADD
		o.posWorld = mul(unity_ObjectToWorld, v.vertex);
		o.lookDir = normalize(WorldSpaceViewDir(v.vertex));

		// Convert Normal World here so it's not done below
		o.normalWorld = saturate(pow(dot(o.lookDir, o.normalWorld), 4 * _NormalUse)); // If _NormalUse is 0, then the pow returns as 1 (meaning normal makes no changes). _NormalUse of 1 lets the pow(_NormalStrength) go at its full strength


		//#if UNITY_UV_STARTS_AT_TOP
		float scale = -1.0;
		//#else
		//float scale = 1.0;
		//#endif
		o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
		o.uvgrab.zw = o.vertex.zw;
		o.uvbump = TRANSFORM_TEX( v.texcoord, _BumpMap );
		o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
		return o;
	}

	sampler2D _GrabTexture;
	float4 _GrabTexture_TexelSize;
	sampler2D _MainTex;
	sampler2D _BumpMap;
	//float _NormalStrength;

	half4 frag (v2f i) : SV_Target
	{
		#if UNITY_SINGLE_PASS_STEREO
		i.uvgrab.xy = TransformStereoScreenSpaceTex(i.uvgrab.xy, i.uvgrab.w);
		#endif

		//fixed3 lookDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);

		// calculate perturbed coordinates
		half2 bump = UnpackNormal(tex2D( _BumpMap, i.uvbump )).rg; // we could optimize this by just reading the x & y without reconstructing the Z
		float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize.xy * i.normalWorld;

				//#ifdef UNITY_Z_0_FAR_FROM_CLIPSPACE //to handle recent standard asset package on older version of unity (before 5.5)
					i.uvgrab.xy = offset * UNITY_Z_0_FAR_FROM_CLIPSPACE(i.uvgrab.z) + i.uvgrab.xy;
				//#else
				//	i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
				//#endif

		half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
		half4 tint = tex2D(_MainTex, i.uvmain);
		col *= tint;

		return col;
		}
		ENDCG
	}






	}





	// ------------------------------------------------------------------
	// Fallback for older cards and Unity non-Pro

	SubShader {
		Blend DstColor Zero
		Pass {
			Name "BASE"
			SetTexture [_MainTex] {	combine texture }
		}
	}
}

}
