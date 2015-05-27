#pragma semicolon 1
#include <sourcemod>

// ====[ CONSTANTS ]===================================================
#define PLUGIN_NAME		"SOAP Pregame Mayhem"
#define PLUGIN_AUTHOR		"Lange, athairus"
#define PLUGIN_VERSION		"3.4"
#define PLUGIN_CONTACT		"http://steamcommunity.com/id/langeh/"
#define RED 0
#define BLU 1
#define TEAM_OFFSET 2

// ====[ PLUGIN ]======================================================
public Plugin:myinfo =
{
	name			= PLUGIN_NAME,
	author			= PLUGIN_AUTHOR,
	description	= "Automatically loads and unloads plugins when the \"Waiting for players\" period ends",
	version		= PLUGIN_VERSION,
	url				= PLUGIN_CONTACT
};

// ====[ VARIABLES ]===================================================

new bool:g_dm = false;

// ====[ FUNCTIONS ]===================================================

/* OnPluginStart()
 *
 * When the plugin starts up.
 * -------------------------------------------------------------------------- */

public OnPluginStart()
{
	LoadTranslations("soap_tf2dm.phrases");

	CreateTimer(5.0, HudTimer, _, TIMER_REPEAT);

	// Hook map-ending conditions (maxrounds, timelimit)
	// TODO: Make sure map actually changes eventually when SOAP DM activated
	// HookEvent("teamplay_game_over", GameOverEvent);

}

/* StopDeathmatching()
 *
 * Executes soap_mayhem_off.cfg if it hasn't already been executed..
 * -------------------------------------------------------------------------- */
StopDeathmatching()
{
	if(g_dm == true)
	{
		PrintHintTextToAll("Resetting...");
		ServerCommand("exec sourcemod/soap_mayhem_off.cfg");
		// PrintToChatAll("[SOAP] %t", "Plugins unloaded");
		g_dm = false;
	}
}

/* StartDeathmatching()
 *
 * Executes soap_mayhem.cfg if it hasn't already been executed..
 * -------------------------------------------------------------------------- */
StartDeathmatching()
{
	if(g_dm == false)
	{
		ServerCommand("exec sourcemod/soap_mayhem.cfg");
		// PrintToChatAll("[SOAP] %t", "Plugins reloaded");
		g_dm = true;
	}
}

/* TF2_OnWaitingForPlayersStart()
 *
 * Does what's on the tin..
 * -------------------------------------------------------------------------- */
public TF2_OnWaitingForPlayersStart() 
{
	PrintToServer("\"Waiting For Players\" has begun.");
	StartDeathmatching();
}

/* TF2_OnWaitingForPlayersEnd()
 *
 * Does what's on the tin..
 * -------------------------------------------------------------------------- */
public TF2_OnWaitingForPlayersEnd() 
{
	PrintToServer("\"Waiting For Players\" has ended.");
	StopDeathmatching();
}

public Action:HudTimer(Handle:timer)
{
	if(g_dm == true)
	{
		PrintHintTextToAll("PREGAME MAYHEM!!!");
	}
}

// ====[ CALLBACKS ]===================================================

public GameOverEvent(Handle:event, const String:name[], bool:dontBroadcast)
{
	PrintToServer("GameOverEvent()");
	StartDeathmatching();
}
