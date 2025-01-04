// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/StoredPasses/Outline"{
	//Properties {
	//		_MainTex ("Texture", 2D) = "white" {}
	// 		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
	// 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
	//}
	
	//CGINCLUDE
		//#include "UnityCG.cginc"
		//#include "AutoLight.cginc"
		//#include "Lighting.cginc"
	//ENDCG

	Properties {
		_BloodTex ( "Blood", 2D) = "red" {}
		_BloodColor ( "Blood Color", Color) = (0,0,0,0)
 		_Outline ( "Outline Thickness", Range (0.05, 0.4) ) = 0.05
 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
	}

SubShader {



	
	//Tags { "RenderType" = "Opaque""Queue"="Geometry+0" }



		
/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////

		
		
		Pass { Name "OUTLINE"
		Tags { "LightMode" = "ForwardBase" "Queue"="Geometry" "RenderType"="Geometry""IgnoreProjector"="True"}
			Cull Front
			Lighting Off
			AlphaToMask On	// So we can turn off outlines on any Material by setting Outline alpha.
										//ZWrite Off
										//ZTest Always
										//ColorMask RGB // alpha not used
			Offset -0.5, -2 // Added 10/29/19, seems to clean up outlines?

			CGPROGRAM
			#pragma vertex vert_OutlineBasic
			#pragma fragment frag_OutlineBasic

					// GPU Per-Instancing
					#include "UnityCG.cginc"
					#pragma multi_compile_instancing // Leave this here, otherwise we can't toggle GPU Instancing on

						// Per-Instance Batching (so we can have one material with multiple colors?)
			uniform fixed4 _OutlineColor;
			uniform fixed _Outline;
			uniform sampler2D _BloodTex;	// NOTE: This is only here so Terrain Shaders don't break in Unity5. For some reason, Include_Default has functions that, while never used, still get 
											//  	 included and can't find appropriate functions. To see what I mean, try annoting out _BloodTex here.
			
			#include "Include_Default.cginc"
			
			ENDCG		
		}


	Pass { Name "OUTLINEWOUND"
	Tags {"LightMode" = "ForwardBase""IgnoreProjector" = "True"}//"Queue"="Transparent+60" "IgnoreProjector"="True"} "RenderType"="Transparent+60"}
		AlphaTest Greater[fixed(0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html

		//ZWrite off
		//Blend SrcAlpha OneMinusSrcAlpha
			Cull Front
			Lighting Off
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
			//Offset -1, -20// Added 10/29/19, seems to clean up outlines?

			CGPROGRAM
			#pragma vertex vert_OutlineWound
			#pragma fragment frag_OutlineWound

			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
			uniform sampler2D _BloodTex;

			//#include "Include_Calculations.cginc"
			#include "Include_Default.cginc"


			ENDCG
		}


		// Used by Shader_GUI_Selection, so the outlines of weapons can appear thru the wall.
		Pass { Name "OUTLINESELECTION" 
		Tags { "LightMode" = "ForwardBase"  "RenderType"="Opaque" "IgnoreProjector"="True"} // TransparentCutout
			
			//Blend SrcAlpha One
			ZTest Always	// NOTE [2/8/19] 
			Cull Front
			Lighting Off
			//Zwrite Off	// NOTE [2/8/19] This is cool - if we leave this ON, then when behind a wall/floor, the selection outline overwrites whatever it was printed over (thanks to ZTest Always). But with Zwrite ON, it changes the depth buffer of
							//				 whatever it wrote over...thus punching a hole so that ordinary objects drawn later can appear on top! (This is how Masks work)
							//				 HOWEVER...turning Zwrite OFF would mean that the original ZBuffer of the wall or floor would stay the same, so the OUTLINE (aka a big glowing blob) would be drawn, but the object itself wouldnt because
							//				 the depth buffer hasn't changed. So outline gets drawn as a colored shape, and the object/item gets left un-drawn.

			AlphaToMask On	// So we can turn off outlines on any Material by setting Outline alpha.

			Offset -1, -2 // Added 4/23/24 Trying to draw Selection Outlines for Item - Weapon +Reflect, which draws everything in the WRONG FUCKING ORDER, FUCK UNITY. This at least draws the outline.


			CGPROGRAM
			#pragma vertex vert_OutlineBasic
			#pragma fragment frag_OutlineBasic

			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
			uniform sampler2D _BloodTex;	// NOTE: This is only here so Terrain Shaders don't break in Unity5. For some reason, Include_Default has functions that, while never used, still get 
											//  	 included and can't find appropriate functions. To see what I mean, try annoting out _BloodTex here.
			
			#include "Include_Default.cginc"
			
			ENDCG		
		}

		Pass { Name "OUTLINEMENU" // Used by Menu objects to not be affected by fog.
		Tags { "LightMode" = "ForwardBase" "Queue"="Geometry" "RenderType"="Geometry""IgnoreProjector"="True"}
			AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			Cull Front
			Lighting Off
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
			
			Fog { Mode Off }
										//ZWrite Off
										//ZTest Always
										//ColorMask RGB // alpha not used
			
			CGPROGRAM
			//#pragma vertex vert_OutlineWound
			//#pragma fragment frag_OutlineWound
			#pragma vertex vert_OutlineBasic
			#pragma fragment frag_OutlineBasic

				// GPU Per-Instancing		// NOTE: Selection Outlines don't use this, but vert_OutlineBasic does (due to standard outlines)
				#pragma multi_compile_instancing
				#include "UnityCG.cginc"

			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
			uniform sampler2D _BloodTex;
			
			//#include "Include_Calculations.cginc"
			#include "Include_Default.cginc"
			
			
			ENDCG		
		}

		
	
	
	
	
	
			
	
	

/////////////////////////////////////////
//			SELECT OUTLINE
/////////////////////////////////////////

	Pass { Name "SILHOUETTE"
	Tags {"LightMode"="ForwardBase" "IgnoreProjector"="True" }
			Cull Back
			Lighting Off
			ZWrite Off
			ZTest Always
										//ColorMask RGB // alpha not used
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		
			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
			
			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
			};
			
			struct vertexOutput{
				fixed4 pos : SV_POSITION;
			};
			
			vertexOutput vert (vertexInput v) {				
			 	vertexOutput o;
				o.pos = UnityObjectToClipPos( v.vertex );
			    return o;			
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
				
				return fixed4(0.5f,0.5f,0.5f, 1);
				return _OutlineColor;
			}
			
			
			ENDCG		
		}
		
		
		
	Pass { Name "SILHOUETTEWOUND"
	Tags {"LightMode"="ForwardBase" "IgnoreProjector"="True" }
			AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html
			Cull Back // used to be ALL, fix?
			Lighting Off
			ZWrite Off
			ZTest Greater // Was Always as of 9/21/15
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
			
										//ColorMask RGB // alpha not used
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
			uniform sampler2D _BloodTex;
			
			//#include "Include_Calculations.cginc"
			#include "Include_Default.cginc"

			
			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.tex = v.texcoord;
				
				return o; 
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
			
					// Blood Texture
				fixed4 myBloodTexture = tex2D(_BloodTex, i.tex.xy);
				
				return fixed4(fixed3(0.5f,0.5f,0.5f), ReturnTextureCutoutAlpha(myBloodTexture.rgb));
				//return fixed4(_OutlineColor.rgb, ReturnTextureCutoutAlpha(myBloodTexture.rgb));
			}
			
			
			ENDCG			
		}










/////////////////////////////////////////
//			Interior Skin
/////////////////////////////////////////


	Pass { Name "INTERIOR"
	Tags {"LightMode"="ForwardBase" } //"Queue"="Transparent+60" "IgnoreProjector"="True"} // "RenderType"="Transparent+60"}
		AlphaTest Greater [fixed (0.001)]  // This and ZWrite off is where alpha cutout technique comes from: http://docs.unity3d.com/Documentation/Components/SL-AlphaTest.html

		//ZWrite off
	//Blend SrcAlpha OneMinusSrcAlpha
			Cull Front
			Lighting Off
			AlphaToMask On	// Unity 5 Conversion. This makes this shader work like it used to in Unity 4.
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			uniform fixed _Outline;
			uniform fixed4 _OutlineColor;
			uniform sampler2D _BloodTex;
			uniform fixed4 _BloodColor;
			uniform fixed4 _GlowColor;

			//#include "Include_Calculations.cginc"
			#include "Include_Default.cginc"

			struct vertexInput{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput {
				fixed4 pos : SV_POSITION;
				fixed4 tex : TEXCOORD0;
			};
			
			vertexOutput vert (vertexInput v) {
			
			 	vertexOutput o;
				o.pos = UnityObjectToClipPos( v.vertex );
			    
			 	o.tex = v.texcoord;

			    return o;			
			}
			
			fixed4 frag (vertexOutput i) : COLOR {
			
					// Blood Texture
				fixed4 myBloodTexture = tex2D(_BloodTex, i.tex.xy);


				//return fixed4(_BloodColor.r, _BloodColor.g, _BloodColor.b, min(ReturnTextureCutoutAlpha(myBloodTexture.rgb), round(_BloodColor.a))); // Interior can now be turned off with a low blood color alpha.

				_BloodColor.a = min(ReturnTextureCutoutAlpha(myBloodTexture.rgb), round(_BloodColor.a) * round(_OutlineColor.a));

				return lerp(_BloodColor, _GlowColor, _GlowColor.a);
			}
			
			
			ENDCG	
		}









	}
}