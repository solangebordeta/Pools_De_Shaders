using UnityEngine;

public class FreeCameraController : MonoBehaviour
{
    [Header("Movement")]
    public float moveSpeed = 5f;
    public float boostMultiplier = 2f;
    public float moveSmoothTime = 0.1f;

    [Header("Rotation")]
    public float mouseSensitivity = 3f;
    public bool invertY = false;
    public float rotationSmoothTime = 0.05f;

    private float yaw = 0f;
    private float pitch = 0f;

    private Vector3 currentVelocity = Vector3.zero;
    private Vector3 targetPosition;
    private Quaternion targetRotation;

    private void Start()
    {
        Vector3 angles = transform.eulerAngles;
        yaw = angles.y;
        pitch = angles.x;

        targetPosition = transform.position;
        targetRotation = transform.rotation;

        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }

    private void Update()
    {
        HandleRotation();
        HandleMovement();

        transform.position = Vector3.Lerp(transform.position, targetPosition, Time.deltaTime / moveSmoothTime);
        transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime / rotationSmoothTime);
    }

    private void HandleRotation()
    {
        if (Input.GetMouseButtonDown(1))
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }

        if (Input.GetMouseButton(1))
        {
            float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity;
            float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity;

            yaw += mouseX;
            pitch += invertY ? mouseY : -mouseY;
            pitch = Mathf.Clamp(pitch, -89f, 89f);

            targetRotation = Quaternion.Euler(pitch, yaw, 0f);
        }

        if (Input.GetMouseButtonUp(1))
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
    }

    private void HandleMovement()
    {
        Vector3 input = new Vector3(
            Input.GetAxisRaw("Horizontal"),
            0,
            Input.GetAxisRaw("Vertical")
        ).normalized;

        float speed = moveSpeed;
        if (Input.GetKey(KeyCode.LeftShift))
            speed *= boostMultiplier;

        Vector3 move = transform.TransformDirection(input) * speed;
        targetPosition += move * Time.deltaTime;
    }
}
