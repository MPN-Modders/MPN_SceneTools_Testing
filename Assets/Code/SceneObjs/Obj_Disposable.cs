using UnityEngine;


public class Obj_Disposable : MonoBehaviour
{
    // Use these Function Names on your Character's AnimationEvent to use Disposables:
    //   Event_Disposable_R     - [Input Type: Object] Creates Disposable in the character's main hand.
    //   Event_Disposable_L     - [Input Type: Object] Creates Disposable in the character's off hand.
    //   Event_Disposable_Use   - [Input Type: Int] Play the "Use" state on the Disposable's animator. (0: main hand, 1: off hand)
    //   Event_Disposable_End   - [Input Type: Int] Destroy the Disposable. (0: main hand, 1: off hand)
    [Space(10)]
    [Header("(View this script for use instructions)")]
    public Animator myAnimator;
}

