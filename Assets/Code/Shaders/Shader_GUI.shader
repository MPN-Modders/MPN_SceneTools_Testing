// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Madness/GUI - Flat" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
	
	Tags {"LightMode"="ForwardBase" "IgnoreProjector"="True"}
	Lighting Off
	Fog { Mode Off }
	//ZTest Less
	//ZWrite On
	//Blend SrcAlpha OneMinusSrcAlpha
	//AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
	
			//AlphaToMask On // This doesn't work. SHOULD prevent alpha from obscuring other alphas beneath.
			//ColorMask RGB // Don't need, was just playing with this.
	
		Pass {
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			uniform sampler2D _MainTex;
			
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
				fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
				
				//return fixed4(myTexture.rgb * lerp(1, lightFinal, 0.5) + (_LightColor0 * 0.1), myTexture.a * _Transparent);
				return fixed4(myTexture.rgb, 1);
			}
			
			ENDCG
		}
	} 
	
}
