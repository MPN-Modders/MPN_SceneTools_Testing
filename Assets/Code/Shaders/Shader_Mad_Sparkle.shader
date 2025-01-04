// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/Particle: Sparkle" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Transparent ( "Transparent", Range (0, 1) ) = 1
		//_Stencil("Stencil Ref", Float) = 0 // 6/10/19 - Unity now requires this property even if you're not fucking using it. Great job.
	}
	SubShader {
	
	Tags {"LightMode"="ForwardBase""Queue"="Transparent+60"  "RenderType "="Transparent+60" }
	Lighting Off
	ZTest Less // No difference from the default LEqual, apparently. 
	ZWrite off
	Fog { Mode off }
	Blend SrcAlpha One
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
				//LIGHTING_COORDS(5,6) // SHADOWS
				fixed4 col : COLOR;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				o.col = v.color;
				//TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				return o;
			}
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed3 lightDir = normalize( _WorldSpaceLightPos0.xyz );
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.
				
				
				// Sparkles draw from the texture's color, if any.
				return fixed4(i.col.rgb * myTexture.rgb, myTexture.a * _Transparent * i.col.a); //return fixed4(i.col.rgb, myTexture.a * _Transparent * i.col.a);
			}
			
			ENDCG
		}
	} 
	
}
