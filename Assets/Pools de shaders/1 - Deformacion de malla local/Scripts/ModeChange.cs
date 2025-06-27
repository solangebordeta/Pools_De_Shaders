using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;

public class ModeChange : MonoBehaviour
{

    [SerializeField] private Toggle worldSpaceToggle;
    [SerializeField] private Material worldSpaceRippleMat;

    public void ChangeToggle()
    {
        //worldSpaceToggle.isOn = !worldSpaceToggle.isOn;

        if (worldSpaceToggle.isOn)
        {
            worldSpaceRippleMat.SetInt("_Selector", 1);
        }

        if(!worldSpaceToggle.isOn) 
        {
            worldSpaceRippleMat.SetInt("_Selector", 0);
        }

        
    }
  
}
