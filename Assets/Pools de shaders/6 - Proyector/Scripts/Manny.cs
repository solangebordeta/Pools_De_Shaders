using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Manny : MonoBehaviour
{
    public float roamRadius = 10f;     
    public float waitTime = 3f;         

    private NavMeshAgent agent;
    private float timer;
    private Vector3 startPosition;

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        startPosition = transform.position;
        timer = waitTime;
        GoToNewPosition();
    }

    void Update()
    {
        if (!agent.pathPending && agent.remainingDistance <= agent.stoppingDistance)
        {
            timer += Time.deltaTime;
            if (timer >= waitTime)
            {
                GoToNewPosition();
                timer = 0;
            }
        }
    }

    void GoToNewPosition()
    {
        Vector3 randomDirection = Random.insideUnitSphere * roamRadius;
        randomDirection += startPosition;

        NavMeshHit hit;
        if (NavMesh.SamplePosition(randomDirection, out hit, roamRadius, NavMesh.AllAreas))
        {
            agent.SetDestination(hit.position);
        }
    }
}
