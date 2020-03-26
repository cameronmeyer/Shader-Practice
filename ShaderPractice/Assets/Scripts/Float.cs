using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Float : MonoBehaviour
{
    [SerializeField] float sinMagnitude;
    [SerializeField] bool useWorldSpace = false;

    private Vector3 startPos;

    private void Start()
    {
        startPos = transform.position;
    }

    private void FixedUpdate()
    {
        if(useWorldSpace)
        {
            Vector3 worldTransform = new Vector3(0, sinMagnitude * Mathf.Sin(Time.time) * Time.deltaTime, 0);
            transform.position = startPos + transform.TransformDirection(worldTransform);
        }
        else
        {
            transform.position = startPos + new Vector3(0, sinMagnitude * Mathf.Sin(Time.time) * Time.deltaTime, 0);
        }
    }
}
