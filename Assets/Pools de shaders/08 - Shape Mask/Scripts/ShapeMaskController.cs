using UnityEngine;
using UnityEngine.UI;

public class ShapeMaskController : MonoBehaviour
{
    [Header("Shader Material")]
    public Material shapeMaterial;

    [Header("UI Sliders")]
    public Slider vignetteSlider;
    public Slider scaleSlider;
    public Slider sizeSlider;

    void Start()
    {
        vignetteSlider.minValue = 0;
        vignetteSlider.maxValue = 10;
        vignetteSlider.value = 10;

        scaleSlider.minValue = 0;
        scaleSlider.maxValue = 1;
        scaleSlider.value = shapeMaterial.GetFloat("_Scale");

        sizeSlider.minValue = 0;
        sizeSlider.maxValue = 1;
        sizeSlider.value = shapeMaterial.GetFloat("_Size");
    }

    void Update()
    {
        shapeMaterial.SetFloat("_VignetteMultiplier", vignetteSlider.value);
        shapeMaterial.SetFloat("_Scale", scaleSlider.value);
        shapeMaterial.SetFloat("_Size", sizeSlider.value);
    }
}
