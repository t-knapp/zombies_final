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
    amount = cvar::get_global( "zom_playerstartcount" );
    
    elem = hud::create_element( "server text", 2 );
    elem hud::set_point( "center middle", undefined, 320, 240 );
    elem.label = &"players needed to start: ";
    elem.sort = 9001;
    
    while ( true ) {
        players = entity::get_players( "all", true );
        if ( players.size > ( amount - 1 ) )
            break;
            
        elem setValue( amount - players.size );
            
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
    elem hud::set_point( "center middle", undefined, 320, 240 );
    elem.label = &"time until game starts: ";
    elem.sort = 9001;
    elem.alpha = 0;
    
    elem setTimer( 46 );
    
    elem fadeOverTime( 1 );
    elem.alpha = 1;
    
    wait 1;
    
    wait 35;
    
    elem moveOverTime( 10 );
    elem hud::set_point( "center middle", undefined, 320, 20 );
    
    wait 10;
    
    elem fadeOverTime( 1 );
    elem.alpha = 0;
    
    wait 1;
    
    elem destroy();
}

run_game() {
    flag::set( "zombies_game_started" );
    
    pick_zombie();

    pthread::create( undefined, ::time, level, undefined, true );
    
    wait 1;
    
    while ( !flag::get( "zombies_game_ended" ) ) {
        players = entity::get_players();
        hunters = [];
        zombies = [];
        
        for ( i = 0; i < players.size; i++ ) {                  
            if ( players[ i ].info[ "team" ] == "zombies" )
                zombies[ zombies.size ] = players[ i ];
            else if ( players[ i ].info[ "team" ] == "hunters" && players[ i ].sessionstate == "playing" )
                hunters[ hunters.size ] = players[ i ];
        }
        
        if ( zombies.size == 0 && hunters.size > 0 ) {
            pick_zombie();
            wait 2;
            continue;
        }
        
        if ( hunters.size == 0 && zombies.size > 0 ) {
            pthread::create( undefined, ::end_game, level, "zombies", true );
            break;
        }
        
        wait 1;
    }
}

time() {
    level.clock = hud::create_element( "server timer" );
    level.clock hud::set_point( "center middle", undefined, 320, 460 );
    level.clock.font = "bigfixed";
    
    time = 0;
    timelimit = cvar::get_global( "zom_timelimit" );
    level.clock setTimer( timelimit * 60 );
    
    level endon( "stop clock" );
    for ( ;; ) {
        wait 1;
        time++;
        
        if ( time >= ( timelimit * 60 ) )
            break;
    }
    
    level.clock destroy();
    
    pthread::create( undefined, ::end_game, level, "hunters", true );
}

end_game( winner ) {
    flag::set( "zombies_game_ended" );
    
    level notify( "stop clock" );
    if ( isDefined( level.clock ) )
        level.clock destroy();
    
    if ( winner == "zombies" )
        iPrintLnBold( "Zombies win!" );
    else if ( winner == "hunters" )
        iPrintLnBold( "Hunters win!" );
        
    wait 3;
        
    players = entity::get_players();
    for ( i = 0; i < players.size; i++ ) {
        players[ i ] zombies\players::spawn_spectator();
        players[ i ] closemenu();
        players[ i ] setClientCvar( "g_scriptmainmenu", "main" );
    }
    
    wait 2;
    
    pthread::create( undefined, zombies\mapvote::run, level, undefined, true );
    flag::waitfor( "mapvote complete" );
    
    wait 5;
    
    exitLevel( false );
}

post_game() {
}

auto_rotate() {
    level endon( "stop_rotate_if_empty" );
}

pick_zombie() {
    players = entity::get_players( "all", true );
    goodplayers = [];
    for ( i = 0; i < players.size; i++ ) {
        if ( players[ i ].info[ "has_spawned" ] )
            goodplayers[ goodplayers.size ] = players[ i ];
    }
    
    if ( goodplayers.size == 0 )
        return;
    
    id = randomInt( goodplayers.size );
    ply = goodplayers[ id ];
        
    
    while ( ply.name == getCvar( "lastzom" ) ) {
        iPrintLnBold( ply.name + "^7 was the zombie last time... picking someone else..." );
        wait 2;
        
        id = randomInt( goodplayers.size );
        ply = goodplayers[ id ];
    }
    
    ply zombies\misc::set_team( "zombies" );
    ply suicide();
    
    iprintlnbold( ply.name + "^7 was selected to be the zombie!" );
}