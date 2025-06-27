using System.Collections;
using UnityEngine;

public class ImpactSender : MonoBehaviour
{
    public Material deformMaterial;


    private void Start()
    {
        deformMaterial.SetFloat("_Height", 0.50f);
    }
    private void OnCollisionEnter(Collision collision)
    {
        deformMaterial.SetVector("_CollisionWaves", collision.transform.position);
        Debug.Log("Waves");
        StartCoroutine(enumerator());
    }

    private IEnumerator enumerator()
    {
        Debug.Log("entro a corutina");
        deformMaterial.SetFloat("_Frequency", 7.76f);
        deformMaterial.SetVector("_DeformationVector", new Vector3(0, 5, 0));
        deformMaterial.SetFloat("_Height", 0.05f);

        yield return new WaitForSeconds(1f);

        deformMaterial.SetFloat("_Height", 0f); // Reset deformation
    }


}


