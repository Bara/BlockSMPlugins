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

char g_sLogs[PLATFORM_MAX_PATH + 1];

public Plugin myinfo =
{
    name = "Block SM Plugins",
    description = "",
    author = "Bara",
    version = "1.0.0",
    url = "https://github.com/Bara"
};

public void OnPluginStart() 
{
    g_cBlockPlugins = CreateConVar("sbp_block_plugins", "1", "Block \"sm plugins\" and \"sm exts\"?", _, true, 0.0, true, 1.0);
    g_cBlockSM = CreateConVar("sbp_block_sm", "1", "Block \"sm\"?", _, true, 0.0, true, 1.0);
    g_cBlockMeta = CreateConVar("sbp_block_meta", "1", "Block \"meta\"?", _, true, 0.0, true, 1.0);
    g_cAllowRootAdmin = CreateConVar("sbp_allow_rootadmin", "1", "Allow root admins to access all commands?", _, true, 0.0, true, 1.0);
    
    PTaH(PTaH_ConsolePrintPre, Hook, ConsolePrint);
    PTaH(PTaH_ExecuteStringCommandPre, Hook, ExecuteStringCommand);
    
    char sDate[18];
    FormatTime(sDate, sizeof(sDate), "%y-%m-%d");
    BuildPath(Path_SM, g_sLogs, sizeof(g_sLogs), "logs/sbp-%s.log", sDate);
}

public Action ConsolePrint(int iClient, char sMessage[1024])
{
    if (IsClientConnected(iClient))
    {
        if (g_cAllowRootAdmin.BoolValue && CheckCommandAccess(iClient, "sbp_admin", ADMFLAG_ROOT, true))
            return Plugin_Continue;
        
        if(g_cBlockPlugins.BoolValue)
        {
            if(sMessage[1] == '"' && (StrContains(sMessage, "\" (") != -1 || (StrContains(sMessage, ".smx\" ") != -1)))
                return Plugin_Handled;
            else if(StrContains(sMessage, "To see more, type \"sm plugins", false) != -1 || StrContains(sMessage, "To see more, type \"sm exts", false) != -1)
            {
                PrintToConsole(iClient, " ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶");
                PrintToConsole(iClient, " ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶_____¶¶______¶¶¶____¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶______¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶______¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶______¶¶______¶¶______¶¶______¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶_____¶¶______¶¶______¶¶______¶¶¶¶¶");
                PrintToConsole(iClient, " ¶¶¶__¶¶¶¶¶¶¶¶¶¶______¶¶______¶¶______¶¶______¶¶¶¶¶\n \
                                            ¶______¶¶¶¶¶¶¶¶¶_____¶¶______¶¶______¶¶______¶¶¶¶¶\n \
                                            ¶¶______¶¶¶¶¶¶¶______¶¶______¶¶______¶¶______¶¶¶¶¶\n \
                                            ¶¶¶______¶¶¶¶¶¶¶_____¶¶______¶¶______¶¶______¶¶¶¶¶\n \
                                            ¶¶¶¶______¶¶¶¶¶______¶¶______¶¶______¶¶______¶¶¶¶¶\n \
                                            ¶¶¶¶¶_______¶¶¶______¶¶______¶¶______¶¶______¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶_______¶¶¶_____¶¶______¶¶______¶¶¶___¶¶¶¶¶¶¶");
                PrintToConsole(iClient, " ¶¶¶¶¶¶¶¶______¶¶¶¶_¶¶¶¶______¶¶¶¶__¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶______¶¶¶¶¶¶¶¶¶¶___¶¶¶¶¶¶¶¶¶¶¶_____¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶________¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶________¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶__________¶¶¶¶¶¶¶¶¶¶__________¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶_________________________¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶__________________¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n \
                                            ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶\n ");
                PrintToConsole(iClient, "\t\tNo chance\n");

                LogToFile(g_sLogs, "\"%L\" tried to get the plugin list", iClient);
                
                return Plugin_Handled;
            }
        }
    }
    return Plugin_Continue;
}

public Action ExecuteStringCommand(int iClient, char sCommandString[512]) 
{
    if (IsClientValid(iClient))
    {
        static char sMessage[512];
        strcopy(sMessage, sizeof(sMessage), sCommandString);
        TrimString(sMessage);
        
        if (g_cAllowRootAdmin.BoolValue && CheckCommandAccess(iClient, "sm_admin", ADMFLAG_ROOT, true))
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

bool IsClientValid(int iClient)
{
    if (iClient > 0 && iClient <= MaxClients)
    {
        if (IsClientInGame(iClient) && !IsFakeClient(iClient) && !IsClientSourceTV(iClient))
        {
            return true;
        }
    }
    
    return false;
}
