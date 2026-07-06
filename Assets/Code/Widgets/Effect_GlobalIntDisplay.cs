using UnityEngine;

public class Effect_GlobalIntDisplay : MonoBehaviour
{
    [Tooltip("The name of a Global Int (defined by you through the EventSystem's IntegerSet Action) that will be displayed.")]
    public string GlobalInt = "MyGlobalInt";
    [Tooltip("The UI Text element to receive the GlobalInt's value.")]
    public UnityEngine.UI.Text DisplayTo;
}