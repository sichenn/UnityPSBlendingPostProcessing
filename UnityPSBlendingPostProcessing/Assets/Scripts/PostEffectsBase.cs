﻿using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public abstract class PostEffectsBase : MonoBehaviour
{
    [Header("Quality Settings")]
    public bool UpdatePropertiesPerFrame = false;
    [Range(1, 8)]
    public int DownSample = 2;

    // Called when start
    protected void CheckResources()
    {
        bool isSupported = CheckSupport();

        if (isSupported == false)
        {
            NotSupported();
        }
    }

    // Called in CheckResources to check support on this platform
    protected bool CheckSupport()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            Debug.LogWarning("This platform does not support image effects or render textures.");
            return false;
        }

        return true;
    }

    // Called when the platform doesn't support this effect
    protected void NotSupported()
    {
        enabled = false;
    }

    protected virtual void Start()
    {
        CheckResources();
        updateProperties();
        updateKeywords();
    }

    protected virtual void Update()
    {
        if(UpdatePropertiesPerFrame)
        {
            updateProperties();
            updateKeywords();
        }
    }

    protected abstract void updateProperties();
    protected virtual void updateKeywords()
    {
        //you can update material shaderKeywords here
    }

    // Called when need to create the material used by this effect
    protected Material CheckShaderAndCreateMaterial(Shader shader, Material material)
    {
        if (shader == null)
        {
            return null;
        }

        if (shader.isSupported && material && material.shader == shader)
            return material;

        if (!shader.isSupported)
        {
            return null;
        }
        else
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            if (material)
                return material;
            else
                return null;
        }
    }
}