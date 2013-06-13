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
    precache::object( &"players needed to start: ", "string" );
    precache::object( &"time until game starts: ", "string" );
    
    // not much to do here
    pthread::create( undefined, ::start_game, level, undefined, true );
}

start_game() {
    pthread::create( undefined, ::auto_rotate, level, undefined, true );
    
    wait_for_players();
    pre_game();
    run_game();
    post_game();
}

wait_for_players() {
    elem = hud::create_element( "server text", 2 );
    elem hud::set_point( "center", undefined, 320, 240 );
    elem.label = &"players needed to start: ";
    elem.sort = 9001;
    
    while ( true ) {
        players = entity::get_players( "all", true );
        if ( players.size > 0 )
            break;
            
        elem setValue( 1 - players.size );
            
        wait 1;
    }
    
    elem fadeOverTime( 1 );
    elem.alpha = 0;
    
    wait 1;
    
    elem destroy();
    
    level notify( "stop_rotate_if_empty" );
}

pre_game() {
    elem = hud::create_element( "server text", 2 );
    elem hud::set_point( "center", undefined, 320, 240 );
    elem.label = &"time until game starts: ";
    elem.sort = 9001;
    elem.alpha = 0;
    
    elem setTimer( 46 );
    
    elem fadeOverTime( 1 );
    elem.alpha = 1;
    
    wait 1;
    
    wait 35;
    
    elem moveOverTime( 10 );
    elem hud::set_point( "center", undefined, 320, 20 );
    
    wait 10;
    
    elem fadeOverTime( 1 );
    elem.alpha = 0;
    
    wait 1;
    
    elem destroy();
}

run_game() {
}

post_game() {
}

auto_rotate() {
    level endon( "stop_rotate_if_empty" );
}