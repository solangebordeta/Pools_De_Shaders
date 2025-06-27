using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoverLupa : MonoBehaviour
{
    public Camera mainCamera;

    void Update()
    {
        Vector3 mousePos = Input.mousePosition;
        Ray ray = mainCamera.ScreenPointToRay(mousePos);
        if (Physics.Raycast(ray, out RaycastHit hit))
        {
            transform.position = hit.point + new Vector3(0, 0.1f, 0); // ajusta la altura si quieres
        }
    }
}
