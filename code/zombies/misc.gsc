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

drop_health() {
}

set_team( sTeam, bSpawnCall ) {
    if ( !isDefined( sTeam ) )
        return false;
    
    if ( !isDefined( bSpawnCall ) )
        bSpawnCall = false;
        
    self.info[ "team" ] = sTeam;
    
    if ( sTeam == "zombies" )
        self.pers[ "team" ] = "allies";
    else if ( sTeam == "hunters" )
        self.pers[ "team" ] = "axis";

    if ( bSpawnCall ) {
        self.spectatorclient = -1;
        self.archivetime = 0;
    }
    
    switch ( sTeam ) {
        case "hunters":
        case "axis":
            self.info[ "ishunter" ] = true;
            self.info[ "iszombie" ] = false;
            break;
        case "zombies":
        case "allies":
            self.info[ "ishunter" ] = false;
            self.info[ "iszombie" ] = true;
            break;
        case "spectator":
        case "intermission":
            self.sessionstate = sTeam;
        default:
            self.info[ "ishunter" ] = false;
            self.info[ "iszombie" ] = false;
            break;
    }
}

spawn_protection() {
    self.spawnprotection = true;

    pthread::create( undefined, ::spawn_protection_attack, self, undefined, true );
    pthread::create( undefined, ::spawn_protection_time, self, undefined, true );
    
    self iPrintLn( "Spawn protection enabled." );
    
    self endon( "disconnect" );
    self waittill( "stop_spawn_protection" );

    self iPrintLn( "Spawn protection disabled." );
    self.spawnprotection = undefined;
}

spawn_protection_attack() {
    self endon( "disconnect" );
    self endon( "stop_spawn_protection" );
    
    while ( true ) {
        if ( self attackbuttonpressed() || self meleebuttonpressed() )
            break;
            
        wait 0.05;
    }
    
    self notify( "stop_spawn_protection" );
}

spawn_protection_time() {
    self endon( "disconnect" );
    self endon( "stop_spawn_protection" );
    
    time = 0;
    while ( time < 5 ) {
        wait 0.05;
        time += 0.05;
    }
    
    self notify( "stop_spawn_protection" );
}

is_winter_map() {
    map = cvar::get_global( "mapname" );
    
    switch ( map ) {
        case "mp_harbor":
        case "mp_hurtgen":
        case "mp_pavlov":
        case "mp_railyard":
        case "mp_rocket":
            return true;
        default:
            return false;
    }
}