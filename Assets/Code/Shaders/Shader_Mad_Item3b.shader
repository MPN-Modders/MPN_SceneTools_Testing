Shader  "Madness/Items - Simple, EXTREMELY (Unlit)" {
	Properties {
			_MainTex ( "Texture", 2D) = "white" {}
	 		_Outline ( "Outline Thickness", Range (0, 0.5) ) = 0.3
	 		_OutlineColor ( "Outline Color", Color ) = (0, 0, 0, 1)
			_TintColor ( "Tint Color", Color ) = (0, 0, 0, 0)
	}
	
	SubShader {
	
	
/////////////////////////////////////////
//			TOON OUTLINE
/////////////////////////////////////////
		UsePass "Madness/StoredPasses/Outline/OUTLINE"


/////////////////////////////////////////
//			PRIMARY LIGHTS
/////////////////////////////////////////

		UsePass "Madness/StoredPasses/Primary/PRIMARYSIMPLEUNLIT"
		
		
		
		
	
	}
}