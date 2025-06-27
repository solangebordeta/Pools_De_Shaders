using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BloomShaderController : MonoBehaviour
{
    public Material PostProcessMat;

    private void Awake()
    {
        if (PostProcessMat == null)
        {
            enabled = false;
        }
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, PostProcessMat);
    }
}
