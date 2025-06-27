using System.Collections;
using UnityEngine;

public class ImpactSender : MonoBehaviour
{
    public Material deformMaterial;
 
    private void OnCollisionEnter(Collision collision)
    {
        deformMaterial.SetVector("_CollisionWaves", collision.transform.position);
        Debug.Log("Waves");
        StartCoroutine(enumerator());
    }

    private IEnumerator enumerator()
    {
        deformMaterial.SetFloat("_Frequency", 7.76f);
        deformMaterial.SetVector("_DeformationVector", new Vector3(0, 5, 0));
        deformMaterial.SetFloat("_Height", 3);
        yield return null;
    }
}

