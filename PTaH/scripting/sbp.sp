#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <PTaH>

#pragma newdecls required

#define INTERVAL 3

ConVar g_cBlockPlugins = null;
ConVar g_cBlockSM = null;
ConVar g_cBlockMeta = null;
ConVar g_cAllowRootAdmin = null;

public void OnPluginStart() 
{
	g_cBlockPlugins = CreateConVar("sbp_block_plugins", "1", "Block \"sm plugins\" and \"sm exts\"?", _, true, 0.0, true, 1.0);
	g_cBlockSM = CreateConVar("sbp_block_sm", "1", "Block \"sm\"?", _, true, 0.0, true, 1.0);
	g_cBlockMeta = CreateConVar("sbp_block_meta", "1", "Block \"meta\"?", _, true, 0.0, true, 1.0);
	g_cAllowRootAdmin = CreateConVar("sbp_allow_rootadmin", "1", "Allow root admins to access all commands?", _, true, 0.0, true, 1.0);
	
	PTaH(PTaH_ConsolePrint, Hook, ConsolePrint);
	PTaH(PTaH_ExecuteStringCommand, Hook, ExecuteStringCommand);
	
	LoadTranslations("sbp.phrases");
}

public Action ConsolePrint(int client, char message[512])
{
	if (IsClientConnected(client))
	{
		if (g_cAllowRootAdmin.BoolValue && CheckCommandAccess(client, "sm_admin", ADMFLAG_ROOT, true))
			return Plugin_Continue;
		
		if(g_cBlockPlugins.BoolValue)
		{
			if(message[1] == '"' && (StrContains(message, "\" (") != -1 || (StrContains(message, ".smx\" ") != -1)))
				return Plugin_Handled;
			else if(StrContains(message, "To see more, type \"sm plugins", false) != -1 || StrContains(message, "To see more, type \"sm exts", false) != -1)
			{
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}

public Action ExecuteStringCommand(int client, char message[512]) 
{
	if (IsClientValid(client))
	{
		static char sMessage[512];
		sMessage = message;
		TrimString(sMessage);
		
		if (g_cAllowRootAdmin.BoolValue && CheckCommandAccess(client, "sm_admin", ADMFLAG_ROOT, true))
				return Plugin_Continue;
		
		if(g_cBlockSM.BoolValue && StrContains(sMessage, "sm ") == 0 || StrEqual(sMessage, "sm", false))
		{
			return Plugin_Handled;
		}
		
		if(g_cBlockMeta.BoolValue && StrContains(sMessage, "meta ") == 0 || StrEqual(sMessage, "meta", false))
		{
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue; 
}

bool IsClientValid(int client)
{
	if (client > 0 && client <= MaxClients)
		if (IsClientInGame(client) && !IsFakeClient(client) && !IsClientSourceTV(client))
			return true;
	return false;
}
