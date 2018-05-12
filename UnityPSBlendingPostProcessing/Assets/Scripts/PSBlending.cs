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
        private Material camTexMaterial;
        public Material material
        {
            get
            {
                camTexMaterial = CheckShaderAndCreateMaterial(Shader, camTexMaterial);
                return camTexMaterial;
            }
        }

        protected override void Start()
        {
            base.Start();
            UpdateProperties();
        }

        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (camTexMaterial && Shader)
            {
                int renderTextureWidth = Screen.width / DownSample;
                int renderTextureHeight = Screen.height / DownSample;

                RenderTexture buffer0 = RenderTexture.GetTemporary(renderTextureWidth, renderTextureHeight);
                buffer0.filterMode = FilterMode.Bilinear;
                Graphics.Blit(source, buffer0, camTexMaterial, 0);
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
                material.shaderKeywords = new List<string> { "BLENDMODE_" + BlendMode.ToString().ToUpper() }.ToArray();
                material.SetTexture("_BlendTex", Texture);
                material.SetFloat("_Intensity", Intensity);
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