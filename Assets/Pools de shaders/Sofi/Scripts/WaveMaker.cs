using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveMaker : MonoBehaviour
{
    public Material deformMaterial;


    private void Start()
    {

    }
    private void OnCollisionEnter(Collision collision)
    {
        deformMaterial.SetVector("_CollisionWaves2", collision.transform.position);
        Debug.Log("Waves");
        StartCoroutine(enumerator());
    }

    private IEnumerator enumerator()
    {


        deformMaterial.SetFloat("_Frequency2", 10f);
        deformMaterial.SetFloat("_Height2", 0.07f);
        yield return new WaitForSeconds(1f);


        deformMaterial.SetFloat("_Height2", 0f);
        deformMaterial.SetFloat("_Frequency2", 0f);
        Debug.Log("entro a corutina");
    }

}
