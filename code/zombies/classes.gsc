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
    level.aClasses = [];
    
    add_class( 0, "basic", "hunters" );   
    add_hunter_class_info( 0, "health", 100 );
    add_hunter_class_info( 0, "pistol", "luger_mp" );
    add_hunter_class_info( 0, "grenade", "stielhandgranate_mp" );
    add_hunter_class_info( 0, "grenadecount", 2 );
    
    add_class( 0, "basic", "zombies" );
    add_zombie_class_info( 0, "health", 1000 );
}

add_class( iID, sClassName, sTeam ) {
    if ( !isDefined( iID ) || !isDefined( sClassName ) || !isDefined( sTeam ) )
        return false;
        
    if ( !isDefined( level.aClasses[ sTeam ] ) )
        level.aClasses[ sTeam ] = [];
        
    tmp = get_class( iID, sTeam );
    if ( isDefined( tmp ) )
        return false;
        
    class = spawnstruct();
    class.name = sClassName;
    class.team = sTeam;
    class.id = iID;
    class.health = undefined;
    class.shields = undefined;
    class.damagemult = undefined;
    class.secondary = undefined;
    class.pistol = undefined;
    class.grenade = undefined;
    class.grenadecount = 0;
    
    level.aClasses[ sTeam ][ iID ] = class;
}

add_hunter_class_info( iID, sName, oValue ) {
    add_class_info( "hunters", iID, sName, oValue );
}

add_zombie_class_info( iID, sName, oValue ) {
    add_class_info( "zombies", iID, sName, oValue );
}

add_class_info( sTeam, iID, sName, oValue ) {
    if ( !isDefined( sTeam ) || !isDefined( iID ) || !isDefined( sName ) || !isDefined( oValue ) )
        return false;
        
    if ( !isDefined( level.aClasses[ sTeam ][ iID ] ) )
        return false;
        
    class = get_class( sTeam, iID );
    
    bApply = true;
    switch ( sName ) {
        // modifiers
        case "health":      class.health = oValue;          break;
        case "shields":     class.shields = oValue;         break;
        case "damagemult":  class.damagemult = oValue;      break;
        
        // weapons
        case "secondary":   class.secondary = oValue;       break;
        case "pistol":      class.pistol = oValue;          break;
        case "grenade":     class.grenade = oValue;         break;
        case "grenadecount":class.grenadecount = oValue;    break;
        default:            bApply = false;                 break;
    }
    
    if ( bApply )
        level.aClasses[ sTeam ][ iID ] = class;
}

get_class( sTeam, iID ) {
    if ( !isDefined( iID ) || !isDefined( sTeam ) )
        return undefined;
        
    class = undefined;
    if ( isDefined( level.aClasses[ sTeam ][ iID ] ) )
        class = level.aClasses[ sTeam ][ iID ];
    return class;
}

set_class( sTeam, iID ) {  
    self.class = get_class( sTeam, iID );
    
    if ( !isDefined( self.class ) ) {
        self.class = spawnstruct();
        self.class.id = -1;
        self.class.name = "undefined";
        self.class.team = sTeam;
    }
}

select_class() {
    if ( self.info[ "class" ] != "none" )
        return true;
        
    // force players to be default
    self set_class( self.info[ "team" ], 0 );

    if ( self.info[ "team" ] == "hunters" ) {
        self endon( "disconnect" );
        
        iprintln( "hunter select" );
        
        weapselected = false;
        selected = undefined;
        
        self openMenu( "weapon_americangerman" );
        
        wait ( level.fFrameTime );
        
        while ( true ) {
            self waittill( "menuresponse", menu, response );
            
            if ( response == "close" )
                break;
            else if ( response != "open" ) {
                weapselected = true;
                selected = response;
                break;
            }
        }
        
        if ( !weapselected )
            return false;
            
        self.info[ "primary_weapon" ] = selected;
    }
    else
        self.info[ "primary_weapon" ] = "enfield_mp";
    
    // TODO: other class logic here
    return true;
}
// do various things per class ;)
spawn_player() {
    if ( isDefined( self.class.health ) ) {
        self.maxhealth = self.class.health;
        self.health = self.maxhealth;
    }
    
    if ( isDefined( self.class.secondary ) ) {
        self weapon::give( self.class.secondary, "secondary" );
        self.info[ "secondary_weapon" ] = self.class.secondary;
    }
        
    if ( isDefined( self.class.pistol ) ) {
        self weapon::give( self.class.pistol, "pistol" );
        self.info[ "pistol" ] = self.class.pistol;
    }
        
    if ( isDefined( self.class.grenade ) ) {
        self weapon::give( self.class.grenade, "grenade" );
        self setWeaponSlotAmmo( "grenade", self.class.grenadecount );
        self.info[ "grenade" ] = self.class.grenade;
    }
}