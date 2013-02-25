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

menu_handler() {
    level endon( "intermission" );
    
    iprintln( "menu_handler started" );
    
    for ( ;; ) {
		self waittill( "menuresponse", menu, response );
		
		if ( response == "open" || response == "close" )
			continue;

		if ( menu == game["menu_team"] ) {
			switch ( response ) {
                case "allies":
                case "axis":
                case "autoassign":
                    if ( level.bGameStarted )
                        response = "allies";
                    else
                        response = "axis";
                        
                    if ( response == self.pers["team"] && self.sessionstate == "playing" )
                        break;

                    if ( response != self.pers["team"] && self.sessionstate == "playing" )
                        self suicide();

                    self notify( "end_respawn" );
                    
                    self openmenu( "weapon_americangerman" );

                    self.pers["team"] = response;
                    self.pers["weapon"] = undefined;
                    self.pers["savedmodel"] = undefined;

                    self setClientCvar( "scr_showweapontab", "1" );

                    if ( self.pers["team"] == "allies" ) {
                        self setClientCvar( "g_scriptMainMenu", game["menu_weapon_allies"] );
                        self openMenu( game["menu_weapon_allies"] );
                    }
                    else {
                        self setClientCvar( "g_scriptMainMenu", game["menu_weapon_axis"] );
                        self openMenu( game["menu_weapon_axis"] );
                    }
                    break;

                case "spectator":
                    if ( self.pers["team"] != "spectator" ) {
                        self.pers["team"] = "spectator";
                        self.pers["weapon"] = undefined;
                        self.pers["savedmodel"] = undefined;
                        
                        self.sessionteam = "spectator";
                        self setClientCvar( "g_scriptMainMenu", game["menu_team"] );
                        self setClientCvar( "scr_showweapontab", "0" );
                        zombies\players::spawn_spectator();
                    }
                    break;

                case "weapon":
                    if ( self.pers["team"] == "allies" )
                        self openMenu( game["menu_weapon_allies"] );
                    else if ( self.pers["team"] == "axis" )
                        self openMenu( game["menu_weapon_axis"] );
                    break;
                    
                case "viewmap":
                    self openMenu( game["menu_viewmap"] );
                    break;

                case "callvote":
                    self openMenu( game["menu_callvote"] );
                    break;
			}
		}		
		else if ( menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"] ) {
			if ( response == "team" ) {
				self openMenu( game["menu_team"] );
				continue;
			}
			else if ( response == "viewmap" ) {
				self openMenu( game["menu_viewmap"] );
				continue;
			}
			else if ( response == "callvote" ) {
				self openMenu( game["menu_callvote"] );
				continue;
			}
			
			if ( !isdefined( self.pers["team"] ) || ( self.pers["team"] != "allies" && self.pers["team"] != "axis" ) )
				continue;

			weapon = self maps\mp\gametypes\_teams::restrict_anyteam( response );

			if ( weapon == "restricted" ) {
				self openMenu( menu );
				continue;
			}
			
			if ( isdefined( self.pers["weapon"] ) && self.pers["weapon"] == weapon )
				continue;
			
			if ( !isdefined( self.pers["weapon"] ) ) {
				self.pers["weapon"] = weapon;
				zombies\players::spawn_player();
			}
			else {
				self.pers["weapon"] = weapon;

				weaponname = maps\mp\gametypes\_teams::getWeaponName( self.pers["weapon"] );
				
				if ( maps\mp\gametypes\_teams::useAn( self.pers["weapon"] ) )
					self iprintln( &"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname );
				else
					self iprintln( &"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname );
			}
		}
		else if ( menu == game["menu_viewmap"] ) {
			switch ( response ) {
                case "team":
                    self openMenu( game["menu_team"] );
                    break;
                    
                case "weapon":
                    if ( self.pers["team"] == "allies" )
                        self openMenu( game["menu_weapon_allies"] );
                    else if ( self.pers["team"] == "axis" )
                        self openMenu( game["menu_weapon_axis"] );
                    break;

                case "callvote":
                    self openMenu( game["menu_callvote"] );
                    break;
			}
		}
		else if ( menu == game["menu_callvote"] ) {
			switch ( response ) {
                case "team":
                    self openMenu( game["menu_team"] );
                    break;
                    
                case "weapon":
                    if ( self.pers["team"] == "allies" )
                        self openMenu( game["menu_weapon_allies"] );
                    else if ( self.pers["team"] == "axis" )
                        self openMenu( game["menu_weapon_axis"] );
                    break;

                case "viewmap":
                    self openMenu( game["menu_viewmap"] );
                    break;
			}
		}
		else if ( menu == game["menu_quickcommands"] )
			maps\mp\gametypes\_teams::quickcommands( response );
		else if ( menu == game["menu_quickstatements"] )
			maps\mp\gametypes\_teams::quickstatements( response );
		else if ( menu == game["menu_quickresponses"] )
			maps\mp\gametypes\_teams::quickresponses( response );
	}
}