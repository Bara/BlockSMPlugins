#include <sourcemod>
#include <phooks>

char g_sLogs[PLATFORM_MAX_PATH + 1];

public void OnPluginStart()
{
	PHook(PHook_ConsolePrint, ConsolePrint);
	
	char sDate[18];
	FormatTime(sDate, sizeof(sDate), "%y-%m-%d");
	BuildPath(Path_SM, g_sLogs, sizeof(g_sLogs), "logs/block_sm_plugins-%s.log", sDate);
	
	LoadTranslations("smblockplugins.phrases");
}

public Action ConsolePrint(int client, char sMessage[192])
{
	if(client < 1)
		return Plugin_Continue;
	
	if (client > 0 && client <= MaxClients && IsClientInGame(client))
	{
		if (CheckCommandAccess(client, "sm_admin", ADMFLAG_ROOT, true))
			return Plugin_Continue;
		
		if(sMessage[1] == '"' && (StrContains(sMessage, "\" (") != -1 || (StrContains(sMessage, ".smx\" ") != -1)))
			return Plugin_Handled;
		else if(StrContains(sMessage, "To see more, type \"sm plugins", false) != -1 || StrContains(sMessage, "To see more, type \"sm exts", false) != -1)
		{
			char sBuffer[256];
			Format(sBuffer, sizeof(sBuffer), "%T\n", "SMPlugin", client);
			strcopy(sMessage, sizeof(sMessage), sBuffer);
			LogToFile(g_sLogs, "\"%L\" tried access to sm plugins", client);
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}  