using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneChanger : MonoBehaviour
{
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            int nextScene = SceneManager.GetActiveScene().buildIndex + 1;

            if (nextScene == 0)
                nextScene = 1;

            if (nextScene < SceneManager.sceneCountInBuildSettings)
            {
                SceneManager.LoadScene(nextScene);
            }
        }

        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            int prevScene = SceneManager.GetActiveScene().buildIndex - 1;

            if (prevScene == 0)
                prevScene = 1;

            if (prevScene >= 0)
            {
                SceneManager.LoadScene(prevScene);
            }
        }

        if (Input.GetKeyDown(KeyCode.B))
        {
            SceneManager.LoadScene("MainMenu");
        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Application.Quit();
        }

        if (Input.GetKeyDown(KeyCode.B))
        {
            SceneManager.LoadScene("MainMenu");
        }
    }

    public void ChangeScene(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }


}
