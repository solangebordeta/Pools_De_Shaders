using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FilmParameterController : MonoBehaviour
{
    public Material targetMaterial; 
    public Slider Speed; 
    public Slider Scale;
    public Slider Opacity; 

    void Start()
    {
        Speed.onValueChanged.AddListener(UpdateShaderParameters);
        Scale.onValueChanged.AddListener(UpdateShaderParameters);
        Opacity.onValueChanged.AddListener(UpdateShaderParameters);
    }

    void UpdateShaderParameters(float value)
    {
        if (targetMaterial != null)
        {
            targetMaterial.SetFloat("_Speed", Speed.value);
            targetMaterial.SetFloat("_Scale", Scale.value);
            targetMaterial.SetFloat("_Opacity", Opacity.value);
        }
    }

    void Update()
    {
        if (targetMaterial != null)
        {
            targetMaterial.SetFloat("_Speed", Speed.value);
            targetMaterial.SetFloat("_Scale", Scale.value);
            targetMaterial.SetFloat("_Opacity", Opacity.value);
        }
    }
}
