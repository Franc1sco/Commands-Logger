#include <sourcemod>
#include <sdktools>


new String:g_sCmdLogPath[256];

#define DATA "1.0"

public Plugin:myinfo =
{
    name = "SM commands logger",
    author = "Franc1sco franug", 
    description = "Logging every command that the client use", 
    version = DATA, 
    url = "http://steamcommunity.com/id/franug"
};

public OnPluginStart()
{
	CreateConVar("sm_commandslogger_version", DATA, "", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	for(new i=0;;i++)
	{
		BuildPath(Path_SM, g_sCmdLogPath, sizeof(g_sCmdLogPath), "logs/CmdLog_%d.log", i);
		if ( !FileExists(g_sCmdLogPath) )
			break;
	}
}

public OnAllPluginsLoaded()
{
	AddCommandListener(Commands_CommandListener);
}

public Action:Commands_CommandListener(client, const String:command[], argc)
{
	if ( !client || !IsClientInGame(client))
		return Plugin_Continue;


	decl String:f_sCmdString[256];
	GetCmdArgString(f_sCmdString, sizeof(f_sCmdString));
	LogToFileEx(g_sCmdLogPath, "%L used: %s %s", client, command, f_sCmdString);

	return Plugin_Continue;
}