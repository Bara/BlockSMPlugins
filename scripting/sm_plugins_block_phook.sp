#include <phooks>

public void OnPluginStart()
{    
	PHook(PHook_ConsolePrint, ConsolePrint);
}

public Action ConsolePrint(int iClient, char sMessage[192])
{
	if(sMessage[1] == '"' && (StrContains(sMessage, "\" (") != -1 || (StrContains(sMessage, ".smx\" ") != -1)))
		return Plugin_Handled;
	else if(StrContains(sMessage, "To see more, type \"sm plugins") != -1 || StrContains(sMessage, "To see more, type \"sm exts"))
	{
		strcopy(sMessage, sizeof(sMessage), "No chance\n");
		return Plugin_Changed;
	}
	return Plugin_Continue;
}  