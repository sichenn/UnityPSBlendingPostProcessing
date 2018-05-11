Shader "Kumu/PostProcessing/Photoshop/ComponentBlending"
{
	Properties
	{
		[HideInInspector]
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_BlendTex("Blend Texture", 2D) = "black"{}
		[KeywordEnum(None, Hue, Saturation, Color, Luminosity)] _BlendMode("Blend Mode", Float) = 0
	}
	
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex BlendVert
			#pragma fragment frag
			#pragma shader_feature _BLENDMODE_HUE, _BLENDMODE_SATURATION, _BLENDMORE_COLOR, _BLENDMODE_LUMINOSITY

			#include "UnityCG.cginc"
			#include "PSBlend.cginc"

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex,i.uv);
				fixed4 blend = tex2D(_BlendTex, i.uv);
				
				#if _BLENDMODE_HUE
					col = blendHue(col, blend, blend.a * _Color.a);
				#elif _BLENDMODE_SATURATION
					col = blendSaturation(col, blend, blend.a * _Color.a);
				#elif _BLENDMODE_COLOR
					col = blendColor(col, blend, blend.a * _Color.a);
				#elif _BLENDMODE_LUMINOSITY
					col = blendLuminosity(col, blend, blend.a * _Color.a);
				#endif
				
				return col;
			}
			ENDCG

		}

	}
	Fallback "Diffuse"
}
