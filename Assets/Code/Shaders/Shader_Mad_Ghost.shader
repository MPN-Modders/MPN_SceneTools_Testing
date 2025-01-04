// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/Effect: Ghost" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Transparent ( "Transparent", Range (0, 1) ) = 1
		_NormalTransparent("Facing Transparent", Range(0, 1)) = 1
		_RimColor("Ghost Color", Color) = (1,0,1,0)				// Color glow on top of all other colors.
		_RimFade("Rim Fade", Range(0, 30)) = 30
		_RimDepth("Rim Depth", Range(0, 10)) = 4
		_RimPower("Rim Power", Range(0.5, 1)) = 0.5
			_GlowColor("Glow Color", Color) = (0,0,0,0)					// Color glow on top of all other colors.
			_TintColor("Tint Color", Color) = (0, 0, 0, 0)
		_CustomColor("Custom Color", Color) = (0, 0, 0, 0)		// Arena color tint
		_CustomColor2("Custom Color 2", Color) = (0, 0, 0, 0)		// UNUSED
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
				#include "UnityCG.cginc"	// FOG + others
	            #include "AutoLight.cginc"

			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform fixed _Transparent;
			uniform fixed _NormalTransparent;
			uniform fixed4 _LightColor0;
			
			uniform fixed4 _CustomColor;
			uniform fixed4 _RimColor;
			uniform half _RimFade;
			uniform half _RimDepth;
			uniform half _RimPower;

			uniform fixed4 _GlowColor;
			uniform fixed4 _TintColor;

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
				fixed3 lookDir : TEXCOORD3;
				//LIGHTING_COORDS(5,6) // SHADOWS
				fixed4 col : COLOR;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				o.normalWorld = normalize( mul( fixed4( v.normal, 1 ), unity_WorldToObject).xyz );
				o.col = v.color;

				o.lookDir = normalize(WorldSpaceViewDir(v.vertex)); //normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);

				//TRANSFER_VERTEX_TO_FRAGMENT(o); // SHADOWS
				return o;
			}
			fixed4 frag (vertexOutput i) : COLOR
			{
				fixed3 lightDir = normalize( _WorldSpaceLightPos0.xyz );
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy 	* _MainTex_ST.xy + _MainTex_ST.zw); // _MainTex_ST is how we calculate OFFSET.

				i.col.a *= lerp(1 - dot(i.lookDir, i.normalWorld), 1, _NormalTransparent);
				
				float greyScale = max(max(myTexture.r, myTexture.g), myTexture.b);
				greyScale = pow(saturate(greyScale + 0.5f), 3); // Saturate grayscale
				
				// Amount of Rim Light to use
				fixed myRimLight = saturate(pow(1 - dot(i.lookDir, i.normalWorld), _RimFade) * _RimDepth) * _RimPower;

				// Change Rim Color into Custom Tint if it has Alpha
				_RimColor.rgb = lerp(_RimColor.rgb, _CustomColor.rgb, _CustomColor.a);
					
				// Transparent
				myTexture.a *= _Transparent * i.col.a * greyScale;

				fixed4 finalOutput = fixed4(i.col.rgb * myTexture.rgb, myTexture.a) + _RimColor * myRimLight;
				
				finalOutput = lerp(finalOutput, _RimColor, max(myRimLight, (1 - greyScale / 2) * myTexture.a ));

				finalOutput.rgb = lerp(finalOutput + _TintColor, _GlowColor, _GlowColor.a); // Glow added! Overwrites any color, including TINT, and ignores Fog.

				// Sparkles draw from the texture's color, if any.
				return finalOutput; //return fixed4(i.col.rgb, myTexture.a * _Transparent * i.col.a);
			}
			
			ENDCG
		}
	} 
	
}
