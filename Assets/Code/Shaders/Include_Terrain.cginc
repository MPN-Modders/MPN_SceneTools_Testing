


// GPU Per-Instancing
#include "UnityCG.cginc"
//#include "AutoLight.cginc"
#pragma multi_compile_instancing

struct vertexInput 
{
	fixed4 vertex : POSITION;
	fixed3 normal : NORMAL;
	fixed4 texcoord : TEXCOORD0;
};
struct vertexOutput 
{
	fixed4 pos : SV_POSITION;
	fixed4 tex : TEXCOORD1;
	fixed3 normalWorld : TEXCOORD2;
	fixed3 lightDir : TEXCOORD4;
	//fixed4 col : COLOR;
	LIGHTING_COORDS(5, 6) // SHADOWS
		UNITY_FOG_COORDS(3)	// FOG
};


vertexOutput vert(vertexInput v)
{
	vertexOutput o;
	o.pos = UnityObjectToClipPos(v.vertex);
	o.tex = v.texcoord;
	o.normalWorld = normalize(mul(fixed4(v.normal, 1), unity_WorldToObject).xyz);
	//o.col = _TintColor;
	o.lightDir = normalize(_WorldSpaceLightPos0.xyz);

	TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
	UNITY_TRANSFER_FOG(o, o.pos);	// FOG

	return o;
}



fixed4 drawFrag(vertexOutput i, float inEmission) : COLOR
{
	fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
	_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

	fixed4 myTexture = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.

	fixed3 normalDir = i.normalWorld;
	float lightFinal = saturate(dot(i.lightDir, normalDir) * 2); // * saturate(dot(fixed3(0.0f, 1.0f, 0.0f), lightDir));
	lightFinal *= LIGHT_ATTENUATION(i);  // SHADOWS  // This makes sure shadows turn lightFinal (whether a surface is facing light) to darkness, THUS they use ambient color.
	float4 lightColorFinal = ((1 - lightFinal)) * UnityAmbientLight + (lightFinal * max(UnityAmbientLight, _LightColor0));

	// Final Output								
	float4 finalOutput = myTexture * lightColorFinal;// * lightColorFinal; //lerp(1, lightFinal, 0.6) * lightColorFinal;

	finalOutput += myTexture * inEmission; // NEW 5/22/24 - This gives weapons emission!

	UNITY_APPLY_FOG(i.fogCoord, finalOutput);	// FOG
	
	return finalOutput + _TintColor;
}

// Do this in PRIMARYTERRAIN! (it doesnt have an effect map
/*fixed4 frag(vertexOutput i) : COLOR
{
	return drawFrag(i, 0);
}*/




