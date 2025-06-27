using UnityEngine;
using System.Collections.Generic;

[ExecuteAlways]
public class CreateMap : MonoBehaviour
{
    [SerializeField] private GameObject prefab;

    [SerializeField] private int size = 10;

    [SerializeField] List<GameObject> list = new();

    public bool run;

    void Update()
    {
        if (run)
        {
            run = false;

            foreach (GameObject go in list)
                DestroyImmediate(go);
            list.Clear();

            for (int i = 0; i < size; i++)
                for (int j = 0; j < size; j++)
                {
                    var go = GameObject.Instantiate(prefab, transform);
                    list.Add(go);
                    go.transform.position = new Vector3(-size/4 + 0.25f * i, 0, -size/4 + 0.25f * j);
                }
        }
    }
}
