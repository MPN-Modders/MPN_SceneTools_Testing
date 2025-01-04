
struct vertexInput {
	float4 vertex : POSITION;
	float3 normal : NORMAL;
	float4 texcoord : TEXCOORD0;
};


vertexOutput vert_Reflect (vertexInput input)
{
	vertexOutput output;

	float4x4 modelMatrix = unity_ObjectToWorld;
	float4x4 modelMatrixInverse = unity_WorldToObject;
	output.viewDir = mul(modelMatrix, input.vertex).xyz - _WorldSpaceCameraPos;

	output.normalDir = normalize(mul(fixed4(input.normal, 1), unity_WorldToObject).xyz); // SWAIN ADD
	output.pos = UnityObjectToClipPos(input.vertex);
	output.tex = input.texcoord;

	// Taken from Distort Shader
	output.uvgrab.xy = (float2(output.pos.x, output.pos.y * -1) + output.pos.w) * 0.5;
	output.uvgrab.zw = output.pos.zw;
	output.uvbump = TRANSFORM_TEX(input.texcoord, _BumpMap);

	return output;
}


float4 ReflectColor(sampler2D BumpMap, float4 BumpMap_ST, float BumpAmount, samplerCUBE CubeMap, float2 uvBump, float3 viewDir, float3 normalDir, float4 inLight)
{
	// Taken from Distort Shader
	half3 bump = UnpackNormal(tex2D(BumpMap, uvBump * BumpMap_ST.xy + BumpMap_ST.zw));
	float3 offset = bump * BumpAmount;

	float3 reflectedDir = reflect(viewDir, normalize(normalDir));
	float4 finalColor = texCUBE(_Cube, reflectedDir + offset) * _CubeAmount; // _CubeAmount is like extra brightness

	// World Light should affect the amount of Shiny this object produces.
	return finalColor * saturate(inLight.r + inLight.g + inLight.b);
}

