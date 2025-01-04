// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/Particle: Smoke" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Transparent ( "Transparent", Range (0, 1) ) = 1
	}
	SubShader {
	
	Tags {"LightMode"="ForwardBase""Queue"="Transparent+0"  "RenderType "="Transparent+60" }  // Was Transparent+0 on 1/3/19
	Lighting Off
	ZTest Less // No difference from the default LEqual, apparently. 
	ZWrite off
	//Fog { Mode off }
	Blend SrcAlpha OneMinusSrcAlpha
	AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
	
			//AlphaToMask On // This doesn't work. SHOULD prevent alpha from obscuring other alphas beneath.
			//ColorMask RGB // Don't need, was just playing with this.
	
		Pass {
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed _Transparent;
			uniform fixed4 _LightColor0;
			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD1;
				fixed3 normalWorld : TEXCOORD2;
				fixed3 lightDir : TEXCOORD4;
				//LIGHTING_COORDS(5,6) // SHADOWS
				fixed4 col : COLOR;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				o.col = v.color;
				o.lightDir = normalize(_WorldSpaceLightPos0.xyz);
				//TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				return o;
			}
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed4 UnityAmbientLight = UNITY_LIGHTMODEL_AMBIENT * 1; // UNITY_LIGHTMODEL_AMBIENT *= 2; // Ambient is only half strength, I cannot figure out why. So, double it.
				_LightColor0 *= 0.5f; // Unity 5 Update doubled light brightness.

				fixed3 normalDir = i.normalWorld;
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw);
				float lightFinal = (dot(i.lightDir, normalDir) + 1) / 2; //  This provides a basic blend based on lighting
				
				//float4 lightColorFinal = ((1 - lightFinal)) * UNITY_LIGHTMODEL_AMBIENT + (lightFinal * max(UNITY_LIGHTMODEL_AMBIENT, _LightColor0));
				float4 lightColorFinal = lerp(UnityAmbientLight, _LightColor0, lightFinal); // CHANGED: 1/19/20  This blends between ambient (darkness) and light based in lightFinal

				//return fixed4(i.col.rgb * myTexture.rgb * lerp(1, lightFinal, 0.5) * (lightColorFinal), myTexture.a * _Transparent * i.col.a);  //return fixed4(i.col.rgb * lerp(1, lightFinal, 0.5) * (lightColorFinal), myTexture.a * _Transparent * i.col.a);
				return fixed4(i.col.rgb * myTexture.rgb * lightColorFinal, myTexture.a * _Transparent * i.col.a);
			}
			
			ENDCG
		}
	} 
	
}
