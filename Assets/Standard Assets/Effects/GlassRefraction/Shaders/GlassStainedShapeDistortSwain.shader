// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Per pixel bumped refraction.
// Uses a normal map to distort the image behind, and
// an additional texture to tint the color.

Shader "FX/Glass/ShapeDistort (Swain)" {
Properties {
	_BumpAmt	("Distortion", range (-258,258)) = 10
	_Severity	("Severity", range(10,0)) = 4
	//_MainTex	("Tint Color (RGB)", 2D) = "white" {}
	//_BumpMap	("Normalmap", 2D) = "bump" {}
	//_NormalUse	("EdgeSoften", range(0,1)) = 0
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
	float3 normalWorld : TEXCOORD1;
	float3 lookDir : TEXCOORD2;
	//fixed4 posWorld : TEXCOORD3;
	float3 normalView : TEXCOORD3;
};

float _BumpAmt;
float _Severity;
//float4 _BumpMap_ST;
//float4 _MainTex_ST;

v2f vert (appdata_t v)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.normalWorld = UnityObjectToWorldNormal(v.normal);// normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz); // SWAIN ADD
	o.lookDir = normalize(WorldSpaceViewDir(v.vertex)); // SWAIN ADD

					// SWAIN ADDITIONS //								
					// These let us get the normal of the SURFACE ITSELF, RELATIVE TO THE CAMERA! 
					// From https://forum.unity.com/threads/getting-normals-relative-to-camera-view.452631/#post-2933684  
					float3 viewNorm = mul((float3x3)UNITY_MATRIX_V, o.normalWorld);
					float3 viewPos = UnityObjectToViewPos(v.vertex);
					float3 viewDir = normalize(viewPos);

					// get vector perpendicular to both view direction and view normal
					float3 viewCross = cross(viewDir, viewNorm);

					// swizzle perpendicular vector components to create a new perspective corrected view normal
					o.normalView = float3(viewCross.y, viewCross.x, 0.0);// / length(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);//lerp(length(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz) * 0.5, 1, 0.5);


		// SWAIN: Normalize these to get rid of the weird border around the sphere
		//o.lookDir = saturate(o.lookDir);
		//o.normalWorld = saturate(o.normalWorld);	// NOTE: The border glitch seemed to be pulling from the 0,0 position of the screen without this.
		// MOVED from below!
		o.normalWorld = dot(o.lookDir, o.normalWorld); 
		o.normalWorld = saturate(o.normalWorld); // NOTE: The border glitch seemed to be pulling from the 0,0 position of the screen without this.
		o.normalWorld = pow(o.normalWorld, _Severity);

	o.uvgrab.xy = (float2(o.vertex.x, -o.vertex.y) + o.vertex.w) * 0.5;
	o.uvgrab.zw = o.vertex.zw;
	return o;
}

sampler2D _GrabTexture;
float4 _GrabTexture_TexelSize;
//sampler2D _BumpMap;
//sampler2D _MainTex;

half4 frag (v2f i) : SV_Target
{
	// calculate perturbed coordinates
	float2 offset = _GrabTexture_TexelSize.xy  * i.normalWorld * i.normalView * _BumpAmt * 3;

				i.uvgrab.xy += offset * UNITY_Z_0_FAR_FROM_CLIPSPACE(i.uvgrab.z);

	half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));

	//return fixed4(i.normalWorld, 1);
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
