/*
    1.1 Zombies - a Call of Duty modification
    Copyright (C) 2013 DJ Hepburn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

init() {
    pthread::create( undefined, ::on_connect_handler, level, undefined, true );
}

on_connect_handler() {
    for ( ;; ) {
        level waittill( "connected", player );
        pthread::create( undefined, ::on_connect, player, undefined, true );
    }
}

on_connect() {
    // handle things on connect for player
    // setup variables and things
    self.info = [];

	if ( game[ "state" ] == "intermission" )
	{
		spawn_intermission();
		return;
	}
    
    iPrintLn( self.name + "^7 has joined." );

    self setClientCvar( "g_scriptMainMenu", game[ "menu_team" ] );
    self setClientCvar( "scr_showweapontab", "0" );
    
    if ( !isdefined( self.pers[ "team" ] )  ) 
        self openMenu( game[ "menu_team" ] );

    self.pers[ "team" ] = "spectator";
    self.sessionteam = "spectator";

    spawn_spectator();
    
    pthread::create( undefined, zombies\menu::menu_handler, self, undefined, true );
}

spawn_player() {
    self notify( "end_respawn" );
    self notify( "spawned" );
    self notify( "spawned player" );	
	
	resettimeout();

    if ( self.pers[ "team" ] == "axis" )
        self.info[ "team" ] = "hunters";
    else if ( self.pers[ "team" ] == "allies" )
        self.info[ "team" ] = "zombies";
        
	self.sessionteam = self.pers[ "team" ];
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
		
	spawnpointname = "mp_teamdeathmatch_spawn";
	spawnpoints = entity::get_array( spawnpointname, "classname" );
    if ( spawnpoints ) {
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnpoints );
        self spawn( spawnpoint.origin, spawnpoint.angles );
    }
    else
        maps\mp\_utility::error( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" );

	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	
	if(!isdefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);
        
    self weapon::default_loadout();
	
	if(self.pers["team"] == "allies")
		self setClientCvar("cg_objectiveText", &"TDM_KILL_AXIS_PLAYERS");
	else if(self.pers["team"] == "axis")
		self setClientCvar("cg_objectiveText", &"TDM_KILL_ALLIED_PLAYERS");

	if( cvar::get_global( "scr_drawfriend" ) )
	{
		if(self.pers["team"] == "allies")
		{
			self.headicon = game["headicon_allies"];
			self.headiconteam = "allies";
		}
		else
		{
			self.headicon = game["headicon_axis"];
			self.headiconteam = "axis";
		}
	}
}

spawn_spectator( vOrigin, vAngles ) { 
    self notify( "end_respawn" );
	self notify( "spawned" );
	self notify( "spawned spectator" );

	resettimeout();

    self.info[ "team" ] = "spectator";
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;

	if ( self.pers[ "team" ] == "spectator" )
		self.statusicon = "";
	
	if ( isDefined( vOrigin ) && isDefined( vAngles ) )
		self spawn( vOrigin, vAngles );
	else {
        spawnpointname = "mp_teamdeathmatch_intermission";
		spawnpoints = entity::get_array( spawnpointname, "classname" );
        if ( spawnpoints ) {
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnpoints );
            self spawn( spawnpoint.origin, spawnpoint.angles );
        }
		else
			maps\mp\_utility::error( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" );
	}

	self setClientCvar( "cg_objectiveText", &"TDM_ALLIES_KILL_AXIS_PLAYERS" );
}

spawn_intermission() {
    self notify( "end_respawn" );
	self notify( "spawned" );
	self notify( "spawned intermission" );
    
	resettimeout();

    self.info[ "team" ] = "intermission";
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;

    spawnpointname = "mp_teamdeathmatch_intermission";
    spawnpoints = entity::get_array( spawnpointname, "classname" );
    if ( spawnpoints ) {
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnpoints );
        self spawn( spawnpoint.origin, spawnpoint.angles );
    }
    else
        maps\mp\_utility::error( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" );
}


respawn()
{
	if(!isdefined(self.pers["weapon"]))
		return;

	self endon("end_respawn");
	
	if( cvar::get_global( "scr_forcerespawn" ) > 0)
	{
		pthread::create( undefined, ::waitForceRespawnTime, self, undefined, true );
		pthread::create( undefined, ::waitRespawnButton, self, undefined, true );
		self waittill("respawn");
	}
	else
	{
		pthread::create( undefined, ::waitRespawnButton, self, undefined, true );
		self waittill("respawn");
	}
	
	pthread::create( undefined, ::spawn_player, self, undefined, true );
}

waitForceRespawnTime()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait cvar::get_global( "scr_forcerespawn" );
	self notify("respawn");
}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	self.respawntext = newClientHudElem(self);
	self.respawntext.alignX = "center";
	self.respawntext.alignY = "middle";
	self.respawntext.x = 320;
	self.respawntext.y = 70;
	self.respawntext.archived = false;
	self.respawntext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

	pthread::create( undefined, ::removeRespawnText, self, undefined, true );
	pthread::create( undefined, ::waitRemoveRespawnText, self, "end_respawn", true );
	pthread::create( undefined, ::waitRemoveRespawnText, self, "respawn", true );

	while(self useButtonPressed() != true)
		wait .05;
	
	self notify("remove_respawntext");

	self notify("respawn");	
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isdefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}