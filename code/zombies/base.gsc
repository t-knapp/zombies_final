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

setup() {
    // this sets default callbacks and stuff
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
    
    level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerKilled = ::Callback_PlayerKilled;
    
    allowed[ 0 ] = "tdm";
	maps\mp\gametypes\_gameobjects::main( allowed );
    
    if ( !isDefined( game[ "state" ] ) )
        game[ "state" ] = "playing";
        
    // we don't use the standard 1.1libraries flags ^^
    flag::remove( "game started" );
    flag::remove( "game ended" );
    flag::remove( "intermission" );
    
    // our flags
    flag::create( "zombies_pregame_wait_for_players" );
    flag::create( "zombies_pregame_countdown" );
    flag::create( "zombies_pregame_over" );
    flag::create( "zombies_game_started" );
    flag::create( "zombies_game_ended" );
    flag::create( "zombies_intermission" );
    
    level.bMapEnded = false;
	level.aHealthQueue = [];
	level.iHealthQueueCurrent = 0;
    level.bGameStarted = false;
	
	spawnpointname = "mp_teamdeathmatch_spawn";
	spawnpoints = entity::get_array( spawnpointname, "classname" );

	if ( spawnpoints.size > 0 ) {
		for ( i = 0; i < spawnpoints.size; i++ )
			spawnpoints[ i ] placeSpawnpoint();
	}
	else
		maps\mp\_utility::error( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" );
		
	setArchive( true );
}

Callback_StartGameType() {
	maps\mp\gametypes\_teams::scoreboard();
	maps\mp\gametypes\_teams::initGlobalCvars();
	maps\mp\gametypes\_teams::restrictPlacedWeapons();

	setClientNameMode( "auto_change" );
}

Callback_PlayerConnect() {
    level notify( "connecting", self );
    
    self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill( "begin" );
	self.statusicon = "";
    
    level notify( "connected", self );
}

Callback_PlayerDisconnect() {
    level notify( "disconnected", self );
}

// we notify damage_callback first, so that if we need to catch anything before it goes through, we can
// damage is not notified unless actual damage is applied :)
Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc ) {
    self notify( "damage_callback", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
    
    // block spectator damgae
    if ( self.info[ "team" ] == "spectator" || ( isPlayer( eAttacker ) && eAttacker.info[ "team" ] == "spectator" ) )
        return;
    
    // block friendlyfire
    if ( !cvar::get_global( "zom_friendlyfire" ) && ( isPlayer( eAttacker ) && eAttacker != self && self.info[ "team" ] == eAttacker.info[ "team" ] ) )
        return;
        
    if ( !isDefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
        
    if ( iDamage < 1 )
		iDamage = 1;
        
    self notify( "damage", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
    self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
}

Callback_PlayerKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc ) {
    self endon( "spawned" );
    self notify( "killed_callback", eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc );

    // block spectator damage
    if ( self.info[ "team" ] == "spectator" || ( isPlayer( eAttacker ) && eAttacker.info[ "team" ] == "spectator" ) )
        return;
        
    // if this was a headshot, let everyone know
    if ( sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE" )
        sMeansOfDeath = "MOD_HEAD_SHOT";
        
    if ( cvar::get_global( "zom_obituary" ) )
        obituary( self, attacker, sWeapon, sMeansOfDeath );
        
    self.sessionstate = "dead";
	self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.headicon = "";
    
    self notify( "killed", eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc );
    
    if ( flag::isset( "zombies_game_ended" ) )
        return;
        
    if ( cvar::get_global( "zom_dropweapon" ) )
        self dropItem( self getCurrentWeapon() );
        
    if ( cvar::get_global( "zom_drophealth" ) )
        self zombies\misc::drop_health();
        
    eBody = self cloneplayer();
    
    wait 2;
    
    bDoKillcam = true;
    if ( cvar::get_global( "scr_forcerespawn" ) )
        bDoKillcam = false;
        
    if ( bDoKillcam )
        self zombies\killcam::main( eAttacker getEntityNumber(), 2 );
    else
        pthread::create( undefined, zombies\players::respawn, self, undefined, true );
}