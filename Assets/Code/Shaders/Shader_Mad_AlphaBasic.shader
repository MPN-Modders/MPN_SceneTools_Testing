// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/Alpha - Basic (UI Only)" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Transparent ( "Transparent", Range (0, 1) ) = 1
	}
	SubShader {
	
	Tags {"LightMode"="ForwardBase""Queue"="Transparent"  "RenderType "="Transparent" }
	Lighting Off
	ZTest Less 
	ZWrite off 
	Blend SrcAlpha OneMinusSrcAlpha
	AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
	
			//AlphaToMask On // This doesn't work. SHOULD prevent alpha from obscuring other alphas beneath.
			//ColorMask RGB // Don't need, was just playing with this.
	
		Pass {
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			
			uniform sampler2D _MainTex;
			uniform fixed _Transparent;
			uniform fixed4 _LightColor0;
			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				//LIGHTING_COORDS(5,6) // SHADOWS
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				//TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				return o;
			}
			fixed4 frag (vertexOutput i) : COLOR
			{		
				
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.
				
					// NOTE: Just copy this directly from Terrain - Shadow
				fixed3 normalDir = i.normalWorld;
				fixed3 lightDir = normalize( _WorldSpaceLightPos0.xyz );
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				float lightFinal = saturate ( dot( lightDir, normalDir ) * 2);// * saturate(dot(fixed3(0.0f, 1.0f, 0.0f), lightDir)); // SHADOWS
				float4 lightColorFinal = ((1 - lightFinal)) * UnityAmbientLight 
										+ (lightFinal * max(UnityAmbientLight, _LightColor0));
				
				myTexture.a *= _Transparent;
				
				return myTexture * lightColorFinal;// * lightColorFinal; //lerp(1, lightFinal, 0.6) * lightColorFinal;
			}
			
			ENDCG
		}
	} 
	
}
