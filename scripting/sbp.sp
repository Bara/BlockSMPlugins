#pragma semicolon 1

#include <sourcemod>
#include <PTaH>

#pragma newdecls required

char g_sLogs[PLATFORM_MAX_PATH + 1];

public void OnPluginStart() 
{
	PTaH(PTaH_ConsolePrint, Hook, ConsolePrint);
	
	char sDate[18];
	FormatTime(sDate, sizeof(sDate), "%y-%m-%d");
	BuildPath(Path_SM, g_sLogs, sizeof(g_sLogs), "logs/sbp-%s.log", sDate);
	
	LoadTranslations("sbp.phrases");
}

public Action ConsolePrint(int client, char message[512])
{
	if(client < 1)
		return Plugin_Continue;
	
	if (client > 0 && client <= MaxClients && IsClientInGame(client))
	{
		if (CheckCommandAccess(client, "sm_admin", ADMFLAG_ROOT, true))
			return Plugin_Continue;
		
		if(message[1] == '"' && (StrContains(message, "\" (") != -1 || (StrContains(message, ".smx\" ") != -1)))
			return Plugin_Handled;
		else if(StrContains(message, "To see more, type \"sm plugins", false) != -1 || StrContains(message, "To see more, type \"sm exts", false) != -1)
		{
			char sBuffer[256];
			Format(sBuffer, sizeof(sBuffer), "%T\n", "SMPlugin", client);
			strcopy(message, sizeof(message), sBuffer);
			LogToFile(g_sLogs, "\"%L\" tried access to sm plugins/exts", client);
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}
