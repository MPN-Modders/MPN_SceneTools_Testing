
using UnityEngine;

public class Dev_Cam : MonoBehaviour
{
    public string LinkedRoomDisplay;

    public void LinkToRoom(RoomObj inRoom)
    {
        LinkedRoomDisplay = inRoom.name;
    }
}
