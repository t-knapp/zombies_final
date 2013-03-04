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
    weapon::default_settings();
    
    weapon::update_info( "enfield_mp", "clipsize,int,0;startammo,int,0;maxammo,int,0;" );
    weapon::update_info( "sten_mp", "clipsize,int,0;startammo,int,0;maxammo,int,0;" );
    weapon::update_info( "bren_mp", "clipsize,int,0;startammo,int,0;maxammo,int,0;" );
}