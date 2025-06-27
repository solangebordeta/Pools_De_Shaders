using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ProjectorController : MonoBehaviour
{
    [Header("UI Sliders")]
    public Slider rotationScale;

    [Header("Target Material")]
    public Material projectorMaterial;

    private string rotationProp = "_RotateScale";

    void Start()
    {
        if (projectorMaterial != null)
        {
            if (projectorMaterial.HasProperty(rotationProp))
                rotationScale.value = projectorMaterial.GetFloat(rotationProp);

            
        }

        rotationScale.onValueChanged.AddListener(OnMinThresholdChanged);
  
    }

    void OnMinThresholdChanged(float value)
    {
        if (projectorMaterial != null)
            projectorMaterial.SetFloat(rotationProp, value);
    }

}
