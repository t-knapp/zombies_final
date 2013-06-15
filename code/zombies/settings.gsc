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
    // defines already implemented in 1.1libraries
    cvar::get_global( "dev_mode", true, 0 );
    
    cvar::get_global( "scr_drawfriend", true, 1 );
    cvar::get_global( "scr_forcerespawn", true, 0 );
    cvar::get_global( "zom_drophealth", true, 0 );
    cvar::get_global( "zom_dropweapon", true, 0 );
    cvar::get_global( "zom_force_drawsun", true, 1 );
    cvar::get_global( "zom_force_fastsky", true, 1 );
    cvar::get_global( "zom_force_team", true, "none" );
    cvar::get_global( "zom_friendlyfire", true, 0 );
    cvar::get_global( "zom_obituary", true, 1 );
    cvar::get_global( "zom_playerstartcount", true, 3 );
    cvar::get_global( "zom_timelimit", true, 25 );
    
    // because i'm too lazy to setup a config properly
    cvar::get_global( "sv_maprotation", true, "map mp_brecourt map mp_carentan map mp_chateau map mp_dawnville map mp_depot map mp_harbor map mp_hurtgen map mp_pavlov map mp_powcamp map mp_railyard map mp_rocket map mp_ship" );
}