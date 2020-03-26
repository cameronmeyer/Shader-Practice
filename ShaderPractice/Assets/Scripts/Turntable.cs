using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Turntable : MonoBehaviour
{
    [SerializeField] float rotSpeed;
    [SerializeField] bool useWorldSpace = false;
    [SerializeField] bool rotOnYAxis = true;
    [SerializeField] bool rotOnXAxis = false;
    
    void FixedUpdate()
    {
        if(useWorldSpace)
        {
            if (rotOnYAxis)
                transform.Rotate(0.0f, rotSpeed, 0.0f, Space.World);
            else if (rotOnXAxis)
                transform.Rotate(rotSpeed, 0.0f, 0.0f, Space.World);
            else
                transform.Rotate(0.0f, 0.0f, rotSpeed, Space.World);
        }
        else
        {
            if (rotOnYAxis)
                transform.Rotate(0.0f, rotSpeed, 0.0f);
            else if (rotOnXAxis)
                transform.Rotate(rotSpeed, 0.0f, 0.0f);
            else
                transform.Rotate(0.0f, 0.0f, rotSpeed);
        }
    }
}
