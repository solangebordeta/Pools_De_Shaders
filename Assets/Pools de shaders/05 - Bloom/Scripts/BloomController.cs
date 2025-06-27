using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BloomController : MonoBehaviour
{
    [Header("UI Sliders")]
    public Slider thresholdMin;
    public Slider thresholdMax;
    public Slider intensity;
    public Slider offset;


    public RawImage renderTexture;

    [Header("Target Material")]
    private Material bloomMaterial;

    private string thresholdMinProp = "_BloomThresholdMin";
    private string thresholdMaxProp = "_BloomThresholdMax";
    private string intensityProp = "_Intensity";
    private string offsetProp = "_OffsetMain";

    void Start()
    {
        bloomMaterial = renderTexture.material;

        if (bloomMaterial != null)
        {
            if (bloomMaterial.HasProperty(thresholdMinProp))
                thresholdMin.value = bloomMaterial.GetFloat(thresholdMinProp);

            if (bloomMaterial.HasProperty(thresholdMaxProp))
                thresholdMax.value = bloomMaterial.GetFloat(thresholdMaxProp);

            if(bloomMaterial.HasProperty(intensityProp))
                intensity.value = bloomMaterial.GetFloat(intensityProp);

            if(bloomMaterial.HasProperty (offsetProp))
                offset.value = bloomMaterial.GetFloat(offsetProp);

        }

        thresholdMin.onValueChanged.AddListener(OnMinThresholdChanged);
        thresholdMax.onValueChanged.AddListener(OnMaxThresholdChanged);
        intensity.onValueChanged.AddListener(OnIntensityChanged);
        offset.onValueChanged.AddListener(OnOffsetChanged);
    }

    void OnMinThresholdChanged(float value)
    {
        if (bloomMaterial != null)
            bloomMaterial.SetFloat(thresholdMinProp, value);
    }

    void OnMaxThresholdChanged(float value)
    {
        if (bloomMaterial != null)
            bloomMaterial.SetFloat(thresholdMaxProp, value);
    }

    void OnIntensityChanged(float value)
    {
        if(bloomMaterial != null)
            bloomMaterial .SetFloat(intensityProp, value);   
    }

    void OnOffsetChanged(float value)
    {
        if (bloomMaterial != null)
            bloomMaterial.SetFloat(offsetProp, value);
    }
}
