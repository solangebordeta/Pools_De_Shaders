using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Camera))]
public class PostProcessGrayScaleEffect : MonoBehaviour
{
    [SerializeField] private List <SliderController> slider = new List<SliderController> ();
    [SerializeField] private Shader shader;
    private Material material;


    private void Awake()
    {
        material = new Material(shader);
        foreach (SliderController slider in slider)
        {
            slider.slider.onValueChanged.AddListener((value) => SetSlider(value, slider.nombre));
        }
    }

    private void SetSlider(float value, string name)
    {
        material.SetFloat(name, value);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}

