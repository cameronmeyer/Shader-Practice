using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Turntable : MonoBehaviour
{
    [SerializeField] float rotSpeed;
    
    void FixedUpdate()
    {
        transform.Rotate(0.0f, rotSpeed, 0.0f);
    }
}
