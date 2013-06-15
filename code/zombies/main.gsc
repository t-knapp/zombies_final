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
    // i blame ringo for these two
    if ( getCvarInt( "sv_fps" ) != 25 )
        setCvar( "sv_fps", 25 );
    if ( getCvarInt( "sv_maxrate" ) != 25000 )
        setCvar( "sv_maxrate", 25000 );
        
    // load 1.1libraries
    library::load_all();
    
    zombies\settings::init();
    zombies\developer::init();
    zombies\mapvote::init();
    zombies\models::init();
    zombies\precache::init();
    zombies\base::setup();
    zombies\classes::init();
    zombies\ranks::init();
    zombies\players::init();
    zombies\weapons::init();
    zombies\weather::init();
    zombies\gamelogic::init();
}