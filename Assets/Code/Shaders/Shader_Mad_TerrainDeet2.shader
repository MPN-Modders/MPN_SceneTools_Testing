Shader "Madness/Terrain - Detail (Mask-Safe)" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Transparent ( "Transparent", Range (0, 1) ) = 1
	}
	SubShader {
	
	Tags { "RenderType" = "Opaque" }
	
	Tags { "Queue" = "Geometry+20" } 	// These are for outline behind walls. Transparency+50 is the old amount, but that would make these items overlap-silhouette EACHOTHER.
	
	
		
		UsePass "Madness/StoredPasses/Misc/DEETSALPHA"

	} 
}
