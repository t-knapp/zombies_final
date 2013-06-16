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
    // default settings already implemented because of 1.1libraries
    
    weapon::update_info( "enfield_mp", "clipsize,int,0;startammo,int,0;maxammo,int,0;" );
    weapon::update_info( "sten_mp", "clipsize,int,0;startammo,int,0;maxammo,int,0;" );
    weapon::update_info( "bren_mp", "clipsize,int,0;startammo,int,0;maxammo,int,0;" );
}

// modified version of 1.1libraries
loadout() {
    primary = self.info[ "primary_weapon" ];
    if ( !weapon::exists( primary ) )
        return false;
        
    self weapon::give( primary, "primary", true );
    info = weapon::get_info( primary );
}

/*
    if ( self.info[ "team" ] == "hunters" )
        self weapon::give( "luger_mp", "pistol" );
    else
        self weapon::give( "colt_mp", "pistol" );
    
    grenadecount = 1;
    switch ( info.type ) {
        case "rifle":       
        case "riflesemi":   grenadecount = 3; break;
        case "lmg":
        case "lmgsemi":
        case "smg":
        case "smgsemi":     grenadecount = 2; break;
    }
    
    if ( self.info[ "team" ] == "hunters" ) {
        self weapon::give( "stielhandgranate_mp", "grenade" );
        self setWeaponSlotAmmo( "grenade", grenadecount );
    }
}*/