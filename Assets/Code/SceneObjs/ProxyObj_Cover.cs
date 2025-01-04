using UnityEngine;

public class ProxyObj_Cover : ProxyObj_Base
{
    public ProxyType Type;

    public enum ProxyType
    {
        Barrel = 0,
        Crate1,
        Crate2,
        Crate3,
        Crate4,
        Pallet,
        Desk1,
        Desk2,
        Counter,
        Table,
        Wall1,
        Wall2,
        Wall3,
        Wall4a,
        Wall4b,
        Wall4c,


        CornerR = 100,
        CornerL,
    }
}


