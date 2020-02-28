using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Float : MonoBehaviour
{
    [SerializeField] float sinMagnitude;

    private Vector3 startPos;

    private void Start()
    {
        startPos = transform.position;
    }

    private void FixedUpdate()
    {
        transform.position = startPos + new Vector3(0, sinMagnitude* Mathf.Sin(Time.time) * Time.deltaTime, 0);
            //new Vector3(startPos.x, Mathf.Sin(Time.time) * Time.deltaTime, startPos.z);
    }
}
