using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowManny : MonoBehaviour
{
    public GameObject manny;
    private Quaternion initialRotation;

    private void Start()
    {
        initialRotation = transform.rotation;
    }
    
    void Update()
    {
        transform.position = manny.transform.position;
        
    }
    void LateUpdate()
    {
        transform.rotation = initialRotation;
    }
}
