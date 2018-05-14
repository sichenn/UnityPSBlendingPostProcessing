using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dawn.PostProcessing
{
    [ExecuteInEditMode]
    public class PSBlending : PostEffectsBase
    {
        [Header("Quality Settings")]
        [Range(1, 8)]
        public int DownSample = 2;
        [Header("Shader Properties")]
        public Shader Shader;
        public PSBlendMode BlendMode = PSBlendMode.None;
        public Texture Texture;
        [Range(0, 1)]
        public float Intensity = 1;
        private RenderTexture rt;
        [SerializeField]
        [HideInInspector]
        private Material blendMaterial;
        public Material material
        {
            get
            {
                blendMaterial = CheckShaderAndCreateMaterial(Shader, blendMaterial);
                return blendMaterial;
            }
        }
        private bool isFirstFrameCompleted = false;

        protected override void Start()
        {
            base.Start();
            UpdateProperties();
        }

        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (material)
            {
                int renderTextureWidth = Screen.width / DownSample;
                int renderTextureHeight = Screen.height / DownSample;

                RenderTexture buffer0 = RenderTexture.GetTemporary(renderTextureWidth, renderTextureHeight);
                buffer0.filterMode = FilterMode.Bilinear;
                Graphics.Blit(source, buffer0, material, 0);
                Graphics.Blit(buffer0, destination);
                RenderTexture.ReleaseTemporary(buffer0);
            }
            else
            {
                Graphics.Blit(source, destination);
            }
        }

        public void UpdateProperties()
        {
            if (material)
            {
                material.SetTexture("_BlendTex", Texture);
                material.SetFloat("_Intensity", Intensity);
                material.shaderKeywords = new string[] { "BLENDMODE_" + BlendMode.ToString().ToUpper() };
            }
        }
    }

    public enum PSBlendMode
    {
        None,
        Normal,
        Dissolve_NotSupported,
        Darken,
        Multiply,
        ColorBurn,
        LinearBurn,
        DarkerColor,
        Lighten,
        Screen,
        ColorDodge,
        LinearDodge,
        LighterColor,
        Overlay,
        SoftLight,
        HardLight,
        VividLight,
        LinearLight,
        PinLight,
        HardMix,
        Difference,
        Exclusion,
        Subtract,
        Divide,
        Hue,
        Saturation,
        Color,
        Luminosity
    }
}