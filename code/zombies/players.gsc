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
        pthread::create( undefined, ::on_damage, player, undefined, true );
    }
}

on_connect() {
    // handle things on connect for player
    iPrintLn( self.name + "^7 has joined." );

	if ( game[ "state" ] == "intermission" )
	{
		spawn_intermission();
		return;
	}

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
    self notify( "spawned" );
	self notify( "end_respawn" );
	
	resettimeout();

	self.sessionteam = self.pers[ "team" ];
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.reflectdamage = undefined;
		
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

	maps\mp\gametypes\_teams::loadout();
	
	self giveWeapon(self.pers["weapon"]);
	self giveMaxAmmo(self.pers["weapon"]);
	self setSpawnWeapon(self.pers["weapon"]);
	
	if(self.pers["team"] == "allies")
		self setClientCvar("cg_objectiveText", &"TDM_KILL_AXIS_PLAYERS");
	else if(self.pers["team"] == "axis")
		self setClientCvar("cg_objectiveText", &"TDM_KILL_ALLIED_PLAYERS");

	if(level.drawfriend)
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
	self notify( "spawned" );
	self notify( "end_respawn" );

	resettimeout();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.reflectdamage = undefined;

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
}

on_damage() {
    self endon( "disconnect" );
    
    while ( true ) {
        self waittill( "damage", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
        self iPrintLn( "would have done damage here ;)" );
    }
}