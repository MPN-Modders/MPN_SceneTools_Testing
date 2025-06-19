using UnityEngine;
using UnityEngine.Video;


public class Tool_MoviePlayer : MonoBehaviour
{
	public VideoPlayer TargetVideo;
	[Tooltip("It's highly recommended you send players to a Scene that is tied to one of your Hub stages (which are also included in the Hubs list on your Campaign MadCard).")]
    public string GoToScene;
}
