using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[Serializable]
public class ShaderKeySlider 
{
    public string Key;
    public Slider Slider;
    public float minValue;
    public float maxValue;
    public bool startAtMax;

    public void SetSliderRange()
    {
        Slider.maxValue = maxValue;
        Slider.minValue = minValue;

        if (startAtMax)
        {
            Slider.value = maxValue;
        }
        else
        {
            Slider.value = minValue;
        }
    }
}