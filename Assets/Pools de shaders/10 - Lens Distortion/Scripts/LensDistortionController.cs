using UnityEngine;
using UnityEngine.UI;

public class LensDistortionController : MonoBehaviour
{
    [Header("Shader Material")]
    public Material lensMaterial;

    [Header("UI Sliders")]
    public Slider exponentSlider;
    public Slider scaleSlider;

    private void Start()
    {
        exponentSlider.minValue = 0.5f;
        exponentSlider.maxValue = 2f;
        exponentSlider.value = 1f;

        scaleSlider.minValue = 0f;
        scaleSlider.maxValue = 1f;
        scaleSlider.value = 1f;
    }

    private void Update()
    {
        lensMaterial.SetFloat("_Exponent", exponentSlider.value);
        lensMaterial.SetFloat("_Scale", scaleSlider.value);
    }
}
