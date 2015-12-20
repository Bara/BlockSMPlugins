#pragma semicolon 1

#include <sourcemod>
#include <dhooks>
#include <sdktools>

#pragma newdecls required

Handle g_hClientPrintf = null;
Handle g_hTimer = null;

public void OnMapStart()
{
	StartTimer();
}

public void OnPluginStart()
{    
	StartPlugin();
	StartTimer();
}

stock void StartTimer()
{
	if(g_hTimer != null)
	{
		delete g_hTimer;
		g_hTimer = null;
	}
		
	g_hTimer = CreateTimer(1.0, Timer_RestartPlugin, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_RestartPlugin(Handle timer)
{
	StartPlugin();
}

stock void StartPlugin()
{
	Handle gameconf = LoadGameConfigFile("clientprintf-hook.games");
	if(gameconf == null)
		SetFailState("Failed to find clientprintf-hook.games.txt gamedata");
	
	int offset = GameConfGetOffset(gameconf, "ClientPrintf");
	if(offset == -1)
	{
		SetFailState("Failed to find offset for ClientPrintf");
		delete gameconf;
	}
	
	StartPrepSDKCall(SDKCall_Static);
	
	if(!PrepSDKCall_SetFromConf(gameconf, SDKConf_Signature, "CreateInterface"))
	{
		SetFailState("Failed to get CreateInterface");
		delete gameconf;
	}
	
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Pointer, VDECODE_FLAG_ALLOWNULL);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	
	char identifier[64];
	if(!GameConfGetKeyValue(gameconf, "EngineInterface", identifier, sizeof(identifier)))
	{
		SetFailState("Failed to get engine identifier name");
		delete gameconf;
	}
	
	Handle temp = EndPrepSDKCall();
	Address addr = SDKCall(temp, identifier, 0);
	
	delete gameconf;
	delete temp;
	
	if(!addr)
		SetFailState("Failed to get engine ptr");
	
	g_hClientPrintf = DHookCreate(offset, HookType_Raw, ReturnType_Void, ThisPointer_Ignore, Hook_ClientPrintf);
	DHookAddParam(g_hClientPrintf, HookParamType_Edict);
	DHookAddParam(g_hClientPrintf, HookParamType_CharPtr);
	DHookRaw(g_hClientPrintf, false, addr);
}

public MRESReturn Hook_ClientPrintf(Handle hParams)
{
	char buffer[1024];
	DHookGetParamString(hParams, 2, buffer, 1024);
	if(buffer[1] == '"' && (StrContains(buffer, "\" (") != -1 || (StrContains(buffer, ".smx\" ") != -1))) 
	{
		DHookSetParamString(hParams, 2, "");
		return MRES_ChangedHandled;
	}
	else if(StrContains(buffer, "To see more, type \"sm plugins") != -1)
	{
		DHookSetParamString(hParams, 2, "No chance\n");
		return MRES_ChangedHandled;
	}
	return MRES_Ignored;
}  