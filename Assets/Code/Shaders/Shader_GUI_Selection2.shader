// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Madness/GUI - Select Object [Item-Only Through Walls]" {

	Properties{
		//_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1, 0, 0, 0.5)
		_Outline("Outline Thickness", Range(0.05, 0.4)) = 0.05
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
	}
		SubShader{

		Tags{ "Queue" = "Geometry+20" "IgnoreProjector" = "True" "RenderType" = "Opaque" }
		// Geometry +20 is the same as Items. This helps the shader not screw up and create flickering triangles.

		// IMPORTANT: The only reason this works is because I set it to the same depth as a gun (2020)! If used on anything else, it WON'T work right!
		//			  The outline will overlap the object whose 
		//
		// ALSO:	  I can't just make guns have a depth of 2000 and set this there too, because then it screw up when passing thru terrain. Terrain needs
		//			  to stay one of the LOWEST layers!
		//

		/////////////////////////////////////////
		//			TOON OUTLINE
		/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINESELECTION"


		ZTest Gequal



		// IMPORTANT: Copied DIRECTLY from Shader_GUI_Selection, because for some reason Ztest doesn't work on UsePass, thus the object won't show thru walls.
		Pass{
		Name "SELECTOBJECT"

		Tags{ "LightMode" = "ForwardBase" }
		Blend SrcAlpha One

		AlphaTest Greater[_Cutoff]
		Lighting Off
		Fog{ Mode Off }
		Cull Front
		//Zwrite Off

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		//sampler2D _MainTex;
		fixed4 _MainColor;

	struct vertexInput {
		fixed4 vertex : POSITION;
		fixed4 texcoord : TEXCOORD0;
	};
	struct vertexOutput {
		fixed4 pos : SV_POSITION;
		fixed4 tex : TEXCOORD0;
	};

	vertexOutput vert(vertexInput v) {
		vertexOutput o;

		o.tex = v.texcoord;
		o.pos = UnityObjectToClipPos(v.vertex);
		return o;
	}

	fixed4 frag(vertexOutput i) : COLOR{
		//fixed4 myTexture = tex2D(_MainTex, i.tex.xy);
		return fixed4(_MainColor.r, _MainColor.g, _MainColor.b, /*myTexture.a * */ _MainColor.a);
	}


		ENDCG
	}



	}

}
