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
}

player_create() {
    if ( !isDefined( self.hud ) )
        self.hud = [];
        
    self.hud[ "health_counter" ] = self hud::create_element( "text", 0.75 );
    self.hud[ "health_counter" ] hud::set_point( "center", undefined, 567, 465 );
}

player_update() {
    self.hud[ "health_counter" ] setValue( self.health );
}

remove_hud() {
    if ( isDefined( self.hud[ "health_counter" ] ) )        
        self.hud[ "health_counter" ] destroy();
}