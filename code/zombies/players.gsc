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
    
    level.darkness = hud::create_element( "server icon", "black", 640, 480 );
    level.darkness.alpha = 0;
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
    self.info[ "connected_name" ] = self.name;
    self.info[ "client_number" ] = self getEntityNumber();
    self.info[ "ishunter" ] = false;
    self.info[ "iszombie" ] = false;
    self.info[ "has_spawned" ] = false;
    
    if ( cvar::get_global( "zom_force_drawsun" ) )
        self setClientCvar( "r_drawsun", 0 );
    if ( cvar::get_global( "zom_force_fastsky" ) )
        self setClientCvar( "r_fastsky", 1 );
    
	if ( flag::isset( "zombies_intermission" ) )
	{
		spawn_intermission();
		return;
	}

    self hud::message_init();
    
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
	
	resettimeout();
    
    self.info[ "has_spawned" ] = false;
    
    if ( isDefined( self.newteam ) ) {
        self zombies\misc::set_team( self.newteam, true );
        self.newteam = undefined;
    }
    
    // --> 
    // class selection should be here, immediately before they are spawned
    // -->
    
    pthread::create( undefined, zombies\misc::spawn_protection, self, undefined, true );
        
	self.sessionteam = self.pers[ "team" ];
	self.sessionstate = "playing";
    
    // for now, just set them to a default class
    self zombies\classes::set_class( self.info[ "team" ], 0 );
		
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
    
    self zombies\models::player();
    
    self weapon::default_loadout();
	
	if ( self.info[ "iszombie" ] )
		self setClientCvar( "cg_objectiveText", "Kill the Hunters!" );
	else if ( self.info[ "ishunter" ] )
		self setClientCvar( "cg_objectiveText", "Kill the Zombies!" );

	if( cvar::get_global( "scr_drawfriend" ) ) {
        self.headicon = game[ "headicon_" + self.pers[ "team" ] ];
        self.headiconteam = self.pers[ "team" ];
	}
    
    self zombies\hud::player_create();
    pthread::create( undefined, ::player_alive_thread, self, undefined, true );
    
    self zombies\classes::spawn_player();
    
    self.info[ "has_spawned" ] = true;
    
    self notify( "spawned" );
    self notify( "spawned player" );	
}

spawn_spectator( vOrigin, vAngles ) { 
    self notify( "end_respawn" );

	resettimeout();

    self zombies\hud::remove_hud();
    self zombies\misc::set_team( "spectator", true );
	self.sessionstate = "spectator";

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

	self setClientCvar( "cg_objectiveText", "Zombies: Kill the Hunters!\nHunters: Kill the Zombies!" );
    
    self notify( "spawned" );
	self notify( "spawned spectator" );
}

spawn_intermission() {
    self notify( "end_respawn" );

	resettimeout();

    self zombies\hud::remove_hud();
    self zombies\misc::set_team( "intermission", true );
	self.sessionstate = "intermission";

    spawnpointname = "mp_teamdeathmatch_intermission";
    spawnpoints = entity::get_array( spawnpointname, "classname" );
    if ( spawnpoints ) {
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnpoints );
        self spawn( spawnpoint.origin, spawnpoint.angles );
    }
    else
        maps\mp\_utility::error( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" );
        
	self notify( "spawned" );
	self notify( "spawned intermission" );
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

tempjump() {   
    if ( getCvar( "jumpheight" ) == "" )
        setCvar( "jumpheight", 100 );
    height = getCvarInt( "jumpheight" );
    
    wait 1;
    
    doublejumped = false;
    self.jumpblocked = false;
    airjumps = 0;
	while ( isAlive( self ) ) {
		if ( self useButtonPressed() && !self.jumpblocked && !self isOnGround() ) 
        {
            if ( !self isOnGround() )
                airjumps++;
                
            if ( airjumps == 1 ) {
                airjumps = 0;
                self thread blockjump();
            }

			for ( i = 0; i < 2; i++ ) 
            {
				self.health += height;
				self finishPlayerDamage(self, self, height, 0, "MOD_PROJECTILE", "panzerfaust_mp", (self.origin + (0,0,-1)), vectornormalize(self.origin - (self.origin + (0,0,-1))), "none");
			}
			wait 1;
		}
		wait 0.05;
	}
}

blockjump() 
{
    self.jumpblocked = true;
    
    while ( isAlive( self ) && !self isOnGround() )
        wait 0.05;
        
    self.jumpblocked = false;
}

remove_zombie_ammo() {   
    slots = [];
    slots[ 0 ] = "primary";
    slots[ 1 ] = "primaryb";
    slots[ 2 ] = "pistol";
    slots[ 3 ] = "grenade";

    for ( i = 0; i < slots.size; i++ ) {
        if ( self getWeaponSlotWeapon( slots[ i ] ) != "none" ) {
            if ( slots[ i ] != "grenade" )
                self setWeaponSlotClipAmmo( slots[ i ], 0 );
            self setWeaponSlotAmmo( slots[ i ], 0 );
        }
    }
}

player_alive_thread() {
    self endon( "end_respawn" );
    self endon( "disconnect" );
    
    dropweapon = cvar::get_global( "zom_dropweapon" );
    
    while ( isAlive( self ) ) {
        self zombies\hud::player_update();
            
        if ( self.info[ "iszombie" ] && dropweapon )
            self remove_zombie_ammo();

        wait level.fFrameTime;
    }
    
    // do things after they die
    self zombies\hud::remove_hud();
}