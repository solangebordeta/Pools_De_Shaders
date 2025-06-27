using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[RequireComponent(typeof(Camera))]
public class PostProcess : MonoBehaviour
{
    [SerializeField] private List<ShaderKeySlider> shaderKeySliders = new List<ShaderKeySlider>();
    [SerializeField] private Shader shader;
    private Material material;

    private void Awake()
    {
        material = new Material(shader);

        foreach (ShaderKeySlider pair in shaderKeySliders)
        {
            pair.SetSliderRange();
            pair.Slider.onValueChanged.AddListener((value) => OnSliderChanged(value, pair.Key));
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }

    private void OnSliderChanged(float value, string key)
    {
        material.SetFloat(key, value);
    }
}