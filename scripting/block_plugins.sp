#include <sourcemod>
#include <PTaH>

char g_sLogs[PLATFORM_MAX_PATH + 1];

public void OnPluginStart()
{
	PTaH(PTaH_ConsolePrint, Hook, ConsolePrint);
	
	char sDate[18];
	FormatTime(sDate, sizeof(sDate), "%y-%m-%d");
	BuildPath(Path_SM, g_sLogs, sizeof(g_sLogs), "logs/block_sm_plugins-%s.log", sDate);
	
	LoadTranslations("smblockplugins.phrases");
}

public Action ConsolePrint(int iClient, char sMessage[1024])
{
	if(iClient < 1)
		return Plugin_Continue;
	
	if (iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient))
	{
		if (CheckCommandAccess(iClient, "sm_admin", ADMFLAG_ROOT, true))
			return Plugin_Continue;
		
		if(sMessage[1] == '"' && (StrContains(sMessage, "\" (") != -1 || (StrContains(sMessage, ".smx\" ") != -1)))
			return Plugin_Handled;
		else if(StrContains(sMessage, "To see more, type \"sm plugins", false) != -1 || StrContains(sMessage, "To see more, type \"sm exts", false) != -1)
		{
			char sBuffer[256];
			Format(sBuffer, sizeof(sBuffer), "%T\n", "SMPlugin", iClient);
			strcopy(sMessage, sizeof(sMessage), sBuffer);
			LogToFile(g_sLogs, "\"%L\" tried access to sm plugins", iClient);
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}  