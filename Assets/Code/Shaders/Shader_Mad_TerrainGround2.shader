// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_LightmapInd', a built-in variable
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Madness/Terrain - Ground TEST"{
	Properties
	{ 
		[HideInInspector] _Control("Control (RGBA)", 2D) = "red" {}
	[HideInInspector] _Splat3("Layer 3 (A)", 2D) = "white" {}
	[HideInInspector] _Splat2("Layer 2 (B)", 2D) = "white" {}
	[HideInInspector] _Splat1("Layer 1 (G)", 2D) = "white" {}
	[HideInInspector] _Splat0("Layer 0 (R)", 2D) = "white" {}
	//Used in fallback on old cards & base map
	[HideInInspector] _MainTex("BaseMap (RGB)", 2D) = "white" {}
	[HideInInspector] _Color("Main Color", Color) = (1,1,1,1)

		_Outline("Outline Thickness", Range(0.05, 0.4)) = 0.05
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)

	}

		SubShader
	{
		Tags
	{
		"SplatCount" = "4"
		"Queue" = "Geometry-100"
		"RenderType" = "Opaque"
	}
		Blend SrcAlpha OneMinusSrcAlpha



		Pass{
		Name "FORWARD"
		Tags{ "LightMode" = "ForwardBase" }

		CGPROGRAM
		// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_fwdbase
		// NOTE: target 3.0 was added as of 6/23/16, and I don't know if it's necessary. But it seemed to get rid of errors on Build
#pragma target 3.0 	
#pragma multi_compile_fog	

		//
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

		// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		//#pragma surface surf Lambert
		struct Input
	{
		float2 uv_Control : TEXCOORD0;
		float2 uv_Splat0 : TEXCOORD1;
		float2 uv_Splat1 : TEXCOORD2;
		float2 uv_Splat2 : TEXCOORD3;
		float2 uv_Splat3 : TEXCOORD4;
	};

	sampler2D _Control;
	sampler2D _Splat0,_Splat1,_Splat2,_Splat3;

	void surf(Input IN, inout SurfaceOutput o)
	{
		fixed4 splat_control = tex2D(_Control, IN.uv_Control);
		fixed4 firstSplat = tex2D(_Splat0, IN.uv_Splat0);
		fixed3 col;
		col = splat_control.r * tex2D(_Splat0, IN.uv_Splat0).rgb;
		col += splat_control.g * tex2D(_Splat1, IN.uv_Splat1).rgb;
		col += splat_control.b * tex2D(_Splat2, IN.uv_Splat2).rgb;
		col += splat_control.a * tex2D(_Splat3, IN.uv_Splat3).rgb;
		o.Albedo = col;
		o.Alpha = 1;
		if (tex2D(_Splat0, IN.uv_Splat0).a == 0)
			o.Alpha = 1 - splat_control.r;
		else if (tex2D(_Splat1, IN.uv_Splat1).a == 0)
			o.Alpha = 1 - splat_control.g;
		else if (tex2D(_Splat2, IN.uv_Splat2).a == 0)
			o.Alpha = 1 - splat_control.b;
		else if (tex2D(_Splat3, IN.uv_Splat3).a == 0)
			o.Alpha = 1 - splat_control.a;
	}


	// vertex-to-fragment interpolation data
#ifdef LIGHTMAP_OFF
	struct v2f_surf {
		float4 pos : SV_POSITION;
		float4 pack0 : TEXCOORD0;
		float4 pack1 : TEXCOORD1;
		float2 pack2 : TEXCOORD2;
		fixed3 normal : TEXCOORD3;
		fixed3 vlight : TEXCOORD4;
		LIGHTING_COORDS(5,6)
			UNITY_FOG_COORDS(7)	// FOG
	};
#endif
#ifndef LIGHTMAP_OFF
	struct v2f_surf {
		float4 pos : SV_POSITION;
		float4 pack0 : TEXCOORD0;
		float4 pack1 : TEXCOORD1;
		float2 pack2 : TEXCOORD2;
		float2 lmap : TEXCOORD3;
		LIGHTING_COORDS(4,5)
			UNITY_FOG_COORDS(6)	// FOG
	};
#endif
#ifndef LIGHTMAP_OFF
	// float4 unity_LightmapST;
#endif
	float4 _Control_ST;
	float4 _Splat0_ST;
	float4 _Splat1_ST;
	float4 _Splat2_ST;
	float4 _Splat3_ST;

	// vertex shader
	v2f_surf vert_surf(appdata_full v) {
		v2f_surf o;
		//UNITY_INITIALIZE_OUTPUT(v2f_surf, o); // I don't know why this was needed. But it was. Otherwise, I get an "variable o used without being initialzied" error...
		//#if defined(UNITY_COMPILER_HLSL)
		//	#define UNITY_INITIALIZE_OUTPUT(v2f_surf,o) o = (v2f_surf)0;
		//#else
		//	#define UNITY_INITIALIZE_OUTPUT(v2f_surf,o)
		//#endif
		o.pos = UnityObjectToClipPos(v.vertex);
		o.pack0.xy = TRANSFORM_TEX(v.texcoord, _Control);
		o.pack0.zw = TRANSFORM_TEX(v.texcoord, _Splat0);
		o.pack1.xy = TRANSFORM_TEX(v.texcoord, _Splat1);
		o.pack1.zw = TRANSFORM_TEX(v.texcoord, _Splat2);
		o.pack2.xy = TRANSFORM_TEX(v.texcoord, _Splat3);

#ifndef LIGHTMAP_OFF
		o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#endif

		float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);

#ifdef LIGHTMAP_OFF
		o.normal = worldN;
#endif

		// SH/ambient and vertex lights
#ifdef LIGHTMAP_OFF
		float3 shlight = ShadeSH9(float4(worldN,1.0));
		o.vlight = shlight;
#ifdef VERTEXLIGHT_ON
		float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		o.vlight += Shade4PointLights(
			unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
			unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
			unity_4LightAtten0, worldPos, worldN);
#endif // VERTEXLIGHT_ON
#endif // LIGHTMAP_OFF

		// pass lighting information to pixel shader
		TRANSFER_VERTEX_TO_FRAGMENT(o);
		UNITY_TRANSFER_FOG(o, o.pos);	// FOG
		return o;
	}
#ifndef LIGHTMAP_OFF 
	// sampler2D unity_Lightmap;
#ifndef DIRLIGHTMAP_OFF
	// sampler2D unity_LightmapInd;
#endif
#endif

	// fragment shader
	fixed4 frag_surf(v2f_surf IN) : SV_Target{
		// prepare and unpack data
#ifdef UNITY_COMPILER_HLSL
		Input surfIN = (Input)0;
#else
		Input surfIN;
#endif

	surfIN.uv_Control = IN.pack0.xy;
	surfIN.uv_Splat0 = IN.pack0.zw;
	surfIN.uv_Splat1 = IN.pack1.xy;
	surfIN.uv_Splat2 = IN.pack1.zw;
	surfIN.uv_Splat3 = IN.pack2.xy;


	//#ifdef UNITY_COMPILER_HLSL
	//SurfaceOutput= (SurfaceOutput)0;
	//#else
	//SurfaceOutput o;
	//#endif
	SurfaceOutput o;
	//UNITY_INITIALIZE_OUTPUT(SurfaceOutput, o); // I don't know why this was needed. But it was. Otherwise, I get an "variable o used without being initialzied" error...

	o.Albedo = 0.0;
	o.Emission = 0.0;
	o.Specular = 0.0;
	o.Alpha = 0.0;
	o.Gloss = 0.0;
#ifdef LIGHTMAP_OFF
	o.Normal = IN.normal;
#endif

	// call surface function
	surf(surfIN, o);							// SWAIN NOTE: THIS is what applies the Splat maps. 

												// compute lighting & shadowing factor
	fixed atten = LIGHT_ATTENUATION(IN);
	fixed4 c = 0;


	fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
	_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

	fixed3 normalDir = IN.normal;
	fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
	float lightFinal = saturate(dot(lightDir, normalDir) * 2);
	lightFinal *= LIGHT_ATTENUATION(IN);
	float4 lightColorFinal = ((1 - lightFinal)) * UnityAmbientLight + (lightFinal * max(UnityAmbientLight, _LightColor0));
	c = lightColorFinal * fixed4(o.Albedo, 1);

	UNITY_APPLY_FOG(IN.fogCoord, c);	// FOG

	return c;

	}

		ENDCG

	}


		/////////////////////////////////////////
		//			TOON OUTLINE
		/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINE"



		/////////////////////////////////////////
		//		SECONDARY LIGHTS
		/////////////////////////////////////////

		UsePass "Madness/StoredPasses/Secondary/SECONDARYTERRAIN_IMPROVED"






		#LINE 57

	}

		Dependency "AddPassShader" = "Hidden/TerrainEngine/Splatmap/Lightmap-AddPass"
		Dependency "BaseMapShader" = "Diffuse"

		//Fallback to Diffuse
		Fallback "Diffuse"
}
