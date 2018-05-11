Shader "Kumu/PostProcessing/Photoshop/ConstrastBlending"
{
	Properties
	{
		[HideInInspector]
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_BlendTex("Blend Texture", 2D) = "black"{}
		[KeywordEnum(None, Overlay, SoftLight, HardLight, VividLight, LinearLight, PinLight, HardMix)] _BlendMode("Blend Mode", Float) = 0
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
			#pragma shader_feature _BLENDMODE_SOFTLIGHT _BLENDMODE_HARDLIGHT _BLENDMODE_VIVIDLIGHT
			#pragma shader_feature _BLENDMODE_LINEARLIGHT, _BLENDMODE_PINLIGHT, _BLENDMODE_HARDMIX
			#include "UnityCG.cginc"
			#include "PSBlend.cginc"

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex,i.uv);
				fixed4 blend = tex2D(_BlendTex, i.uv);
				
				#if _BLENDMODE_SOFTLIGHT
					col = blendNormal(col, blend, _Intensity);
				#elif _BLENDMODE_HARDLIGHT
					col = blendHardLight(col, blend, _Intensity);
				#elif _BLENDMODE_VIVIDLIGHT 
					col = blendVividLight(col, blend, _Intensity);
				#elif _BLENDMODE_LINEARLIGHT
					col = blendLinearLight(col, blend, _Intensity);
				#elif _BLENDMODE_PINLIGHT
					col = blendPinLight(col, blend, _Intensity);
				#elif _BLENDMODE_HARDMIX
					col = blendHardMix(col, blend, _Intensitys);
				#endif
				
				return col;
			}
			ENDCG

		}

	}
	Fallback "Diffuse"
}
