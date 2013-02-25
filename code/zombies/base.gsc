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
    
    level.mapended = false;
	level.healthqueue = [];
	level.healthqueuecurrent = 0;
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

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc ) {
    self notify( "damage", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
}

Callback_PlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc ) {
    self notify( "killed", eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc );
}