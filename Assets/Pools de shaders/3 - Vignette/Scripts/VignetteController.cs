using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class VignetteController : MonoBehaviour
{
    [Header("UI Sliders")]
    public Slider vignetteMultiplierSlider;
    public Slider vignetteSmothnessSlider;
    public Image renderTexture;

    [Header("Target Material")]
    private Material vignetteMaterial;

    private string vignetteMultiplierProp = "_VignetteMultiplier";
    private string vignetteSmothnessProp = "_Smoothness";

    void Start()
    {
        vignetteMaterial = renderTexture.material;

        if (vignetteMaterial != null)
        {
            if (vignetteMaterial.HasProperty(vignetteMultiplierProp))
                vignetteMultiplierSlider.value = vignetteMaterial.GetFloat(vignetteMultiplierProp);

            if (vignetteMaterial.HasProperty(vignetteSmothnessProp))
                vignetteSmothnessSlider.value = vignetteMaterial.GetFloat(vignetteSmothnessProp);
        }

        vignetteMultiplierSlider.onValueChanged.AddListener(OnThresholdChanged);
        vignetteSmothnessSlider.onValueChanged.AddListener(OnIntensityChanged);
    }

    void OnThresholdChanged(float value)
    {
        if (vignetteMaterial != null)
            vignetteMaterial.SetFloat(vignetteMultiplierProp, value);
    }

    void OnIntensityChanged(float value)
    {
        if (vignetteMaterial != null)
            vignetteMaterial.SetFloat(vignetteSmothnessProp, value);
    }
}

