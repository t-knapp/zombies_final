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

/*
    Main idea here is to determine what maps are up for vote BEFORE precache() is called,
    so we can use it in a brand-new map vote hud thing :D
*/
init() {
    precache::object( "blank", "shader" );
    precache::object( "white", "shader" );
    precache::object( &"time remaining: ", "string" );
    precache::object( &"votes: ", "string" );
    precache::object( &"location: ", "string" );
    precache::object( &"hazard: ", "string" );
    precache::object( &"random", "string" );
    precache::object( &"wins!", "string" );
    precache::object( "levelshots/unknownmap.dds", "shader" );
    
    level.mapvote = false;

    maps = get_random_map_rotation();
    if ( isDefined( maps ) ) {
        currentmap = getCvar( "mapname" );
        level.mapvote = true;
        level.mapcandidate = [];
        
        for ( j = 0; j < 5; j++ ) {
            level.mapcandidate[ j ] = [];
            level.mapcandidate[ j ][ "mapname" ] = &"random";
            level.mapcandidate[ j ][ "fullmapname" ] = "random";
            level.mapcandidate[ j ][ "gametype" ] = "zom";
            level.mapcandidate[ j ][ "votes" ] = 0;
        }
        
        i = 0;
        for ( j = 0; j < 5; j++ ) {
            if ( maps[ i ][ "map" ] == currentmap && maps[ i ][ "gametype" ] == "zom" )
                i++;
                
            if ( !isDefined( maps[ i ] ) )
                break;
                
            level.mapcandidate[ j ][ "mapname" ] = get_map_name( maps[ i ][ "map" ] );
            level.mapcandidate[ j ][ "fullmapname" ] = maps[ i ][ "map" ];
            level.mapcandidate[ j ][ "gametype" ] = maps[ i ][ "gametype" ];
            level.mapcandidate[ j ][ "votes" ] = 0;
            
            precache_map_info( maps[ i ][ "map" ], j );
            
            i++;
            
            if ( !isDefined( maps[ i ] ) )
                break;
                
            if ( j > 2 )
                break;
        }
    }
}

run() {
    flag::create( "mapvote complete" );
    
    /*title = hud::create_element( "server text", 2 );
    title hud::set_point( "center middle", undefined, 320, 120 );
    title.label = &"time remaining: ";*/
    
    width = 128;
    height = 192;
    linewidth = 2;
    xoffset = 0;
    offset = 128;
    
    panels = [];
    
    // background
    bg = hud::create_element( "server icon", "black", width * 5, height );
    bg hud::set_point( "left middle", undefined, xoffset, 240 );
    bg.sort = -2;
    bg fadein( 1 );
    
    // top line
    tl = hud::create_element( "server icon", "white", width * 5, linewidth );
    tl hud::set_point( "left top", undefined, xoffset, 240 - ( height / 2 ) );
    tl fadein( 1 );
    
    // separator
    sp = hud::create_element( "server icon", "white", ( width * 5 ) - linewidth, linewidth );
    sp hud::set_point( "center middle", undefined, 320, 240 + ( height / 2 ) - 40 );
    sp fadein( 1 );
    
    // bottomline
    bl = hud::create_element( "server icon", "white", width * 5, linewidth );
    bl hud::set_point( "left top", undefined, xoffset, 240 + ( height / 2 ) );
    bl fadein( 1 );
    
    // leftline
    
    ll = hud::create_element( "server icon", "white", linewidth, height - linewidth );
    ll hud::set_point( "left middle", undefined, xoffset, 241 );
    ll fadein( 1 );
    
    // rightline
    rl = hud::create_element( "server icon", "white", linewidth, height - linewidth );
    rl hud::set_point( "right middle", undefined, width * 5, 241 );
    rl fadein( 1 );
    
    wait 1;

    for ( i = 0; i < 5; i++ ) {
        panels[ i ] = [];

        center = ( width / 2 ) + xoffset;
        panels[ i ][ "centerpoint" ] = center;
        
        panels[ i ][ "background" ] = hud::create_element( "server icon" );
        panels[ i ][ "background" ] hud::set_point( "left top", undefined, xoffset, 240 - ( height / 2 ) );
        panels[ i ][ "background" ].sort = -1;
        panels[ i ][ "background" ] fadein();
        
        panels[ i ][ "mapname" ] = hud::create_element( "server text", 1.4 );
        panels[ i ][ "mapname" ] hud::set_point( "center middle", undefined, center, 240 - ( height / 2 ) + 15 );
        panels[ i ][ "mapname" ].sort = 9001;
        panels[ i ][ "mapname" ] fadein();
        
        panels[ i ][ "votecount" ] = hud::create_element( "server text", 2 );
        panels[ i ][ "votecount" ] hud::set_point( "center middle", undefined, center, 240 + ( height / 2 ) - 23 );
        panels[ i ][ "votecount" ].sort = 9001;
        panels[ i ][ "votecount" ] setValue( 0 );
        panels[ i ][ "votecount" ] fadein();

        if ( level.mapcandidate[ i ][ "fullmapname" ] == "random" ) {
            panels[ i ][ "mapname" ] hud::set_point( "center middle", undefined, center, 220 );
            panels[ i ][ "mapname" ] setText( &"random" );
        }
        else {
            panels[ i ][ "background" ] setShader( "levelshots/" + level.mapcandidate[ i ][ "fullmapname" ] + ".dds", width, width );
            panels[ i ][ "mapname" ] setText( level.mapcandidate[ i ][ "mapname" ] );
            
            panels[ i ][ "location" ] = hud::create_element( "server text", 0.5 );
            panels[ i ][ "location" ] hud::set_point( "center middle", undefined, center, 260 );
            panels[ i ][ "location" ].label = &"location: ";
            panels[ i ][ "location" ] setText( level.mapcandidate[ i ][ "hud_location" ] );
            panels[ i ][ "location" ].sort = 9001;
            panels[ i ][ "location" ] fadein();
            
            panels[ i ][ "hazard" ] = hud::create_element( "server text", 0.5 );
            panels[ i ][ "hazard" ] hud::set_point( "center middle", undefined, center, 275 );
            panels[ i ][ "hazard" ].label = &"hazard: ";
            panels[ i ][ "hazard" ] setText( level.mapcandidate[ i ][ "hud_hazard" ] );
            panels[ i ][ "hazard" ].sort = 9001;
            panels[ i ][ "hazard" ] fadein();
        }

        xoffset += width;
    }
    
    wait 0.6;
    
    // do important things
    players = entity::get_players();
    for ( i = 0; i < players.size; i++ )
        players[ i ] thread player_logic( panels );
        
    //title setTimer( 15 );
    
    thread update_votes( panels, players );
    thread run_wait();
    flag::waitfor( "mapvote complete" );
    
    newmapid = 0;
    topvotes = 0;
    for ( i = 0; i < 5; i++ ) {
        if ( level.mapcandidate[ i ][ "votes" ] > topvotes ) {
            newmapid = i;
            topvotes = level.mapcandidate[ i ][ "votes" ];
        }
    }
  
    centerpoint = panels[ 2 ][ "centerpoint" ];
    
    for ( i = 0; i < panels.size; i++ ) {
        if ( i == newmapid )
            continue;
            
        panels[ i ][ "background" ] fadeout();       
        panels[ i ][ "mapname" ] fadeout();
        panels[ i ][ "location" ] fadeout();
        panels[ i ][ "hazard" ] fadeout();
        panels[ i ][ "votecount" ] fadeout();
    }
        
    for ( i = 0; i < players.size; i++ ) {
        if ( isDefined( players[ i ].voteindicator ) )
            players[ i ].voteindicator fadeout();
    }
    
    //title fadeout( 1 );
   
    // move panel center and fade back in
    panels[ newmapid ][ "votecount" ] setText( &"Wins!" );
    
    if ( newmapid != 2 ) {
        panels[ newmapid ][ "background" ] moveOverTime( 1 );
        panels[ newmapid ][ "background" ] hud::set_point( "left top", undefined, 256, 240 - ( height / 2 ) );
        
        panels[ newmapid ][ "mapname" ] moveOverTime( 1 );
        
        if ( newmapid == 4 )
            panels[ newmapid ][ "mapname" ] hud::set_point( "center middle", undefined, centerpoint, 220 );
        else
            panels[ newmapid ][ "mapname" ] hud::set_point( "center middle", undefined, centerpoint, 240 - ( height / 2 ) + 15 );
        
        panels[ newmapid ][ "location" ] moveOverTime( 1 );
        panels[ newmapid ][ "location"] hud::set_point( "center middle", undefined, centerpoint, 260 );
        
        panels[ newmapid ][ "hazard" ] moveOverTime( 1 );
        panels[ newmapid ][ "hazard" ] hud::set_point( "center middle", undefined, centerpoint, 275 );
        
        panels[ newmapid ][ "votecount" ] moveOverTime( 1 );
        panels[ newmapid ][ "votecount" ] hud::set_point( "center middle", undefined, centerpoint, 240 + ( height / 2 ) - 23 );
        
        wait 1;
    }

    bg scaleOverTime( 1, width, height );
    bg moveOverTime( 1 );
    bg.x = 256;
    bg.y = 240;
    
    tl scaleOverTime( 1, width, linewidth );
    tl moveOverTime( 1 );
    tl.x = 256;
    tl.y = 240 - ( height / 2 );
    
    sp scaleOverTime( 1, width, linewidth );
    sp moveOverTime( 1 );
    sp.x = 320;
    sp.y = 240 + ( height / 2 ) - 40;
    
    bl scaleOverTime( 1, width, linewidth );
    bl moveOverTime( 1 );
    bl.x = 256;
    bl.y = 240 + ( height / 2 );
    
    ll moveOverTime( 1 );
    ll.x = 256;
    
    rl moveOverTime( 1 );
    rl.x = 384;
    
    wait 1;
    
    map = level.mapcandidate[ newmapid ][ "fullmapname" ];
    
    if ( map == "random" )
        map = grab_random_map();
    
    setCvar( "sv_maprotationcurrent", " gametype zom map " + map );
    
    wait 4;
    
    flag::set( "mapvote complete" );
}

fadein( time, alpha ) {
    if ( !isDefined( time ) )
        time = 0.6;
    if ( !isDefined( alpha ) )
        alpha = 1;
        
    self.alpha = 0;
    self fadeOverTime( time );
    self.alpha = alpha;
}

fadeout( time ) {
    if ( !isDefined( time ) )
        time = 0.6;
        
    self fadeOverTime( time );
    self.alpha = 0;
    self thread waittodestroy( time );
}

fadeout_nodelete( time ) {
    if ( !isDefined( time ) )
        time = 0.6;
    
    self fadeOverTime( time );
    self.alpha = 0;
}

waittodestroy( time ) {
    wait ( time );
    self destroy();
}

update_votes( panels, players ) {
    level endon( "mapvote complete" );
    
    time = 12;
    while ( time > 0 ) {
        for ( i = 0; i < 5; i++ )
            level.mapcandidate[ i ][ "votes" ] = 0;
            
        for ( i = 0; i < players.size; i++ ) {
            if ( isDefined( players[ i ].choice ) )
                level.mapcandidate[ players[ i ].choice ][ "votes" ]++;
        }
                
        for ( i = 0; i < 5; i++ )
            panels[ i ][ "votecount" ] setValue( level.mapcandidate[ i ][ "votes" ] );
            
        time -= 0.1;
        wait 0.1;
    }
}

player_logic( panels ) {
    level endon( "mapvote complete" );
    self endon( "disconnect" );
    
    self closemenu();
    
    hasvoted = false;
    
    self.voteindicator = hud::create_element( "icon", "white", 128, 190 );
    self.voteindicator hud::set_point( "center middle", undefined, 65, 241 );
    self.voteindicator.sort = 9003;
    self.voteindicator.color = ( 0, 1, 0 );
    self.voteindicator.alpha = 0;
    
    while ( true ) {
        if ( self attackbuttonpressed() ) {
            if ( !hasvoted ) {
                self.voteindicator.alpha = 0.2;
                hasvoted = true;
                self.choice = 0;
            }
            else
                self.choice++;
                
            if ( self.choice == 5 )
                self.choice = 0;
                
            self iPrintLn( "You voted for ^2%s", level.mapcandidate[ i ][ "mapname" ] );
            self.voteindicator.x = panels[ self.choice ][ "centerpoint" ];
        }
        while ( self attackbuttonpressed() )
            wait 0.1;
        
        wait 0.1;
    }
}

run_wait() {
    wait 10;
    flag::set( "mapvote complete" );
}

precache_map_info( name, j ) {
    mapname = &"unknown";
    location = &"unknown";
    hazard = &"none";
    
    switch ( name ) {
        case "mp_brecourt":
            mapname = &"brecourt";
            location = &"le grand chemin, france";
            hazard = &"poison cloud";
            break;
        case "mp_carentan":
            mapname = &"carentan";
            location = &"carentan, france";
            hazard = &"stormy";
            break;
        case "mp_chateau":
            mapname = &"chateau";
            location = &"bavarian alps, germany";
            hazard = &"stormy";
            break;
        case "mp_dawnville":
            mapname = &"dawnville";
            location = &"sainte Mere Eglise, france";
            hazard = &"haboob";
            break;
        case "mp_depot":
            mapname = &"depot";
            break;
        case "mp_harbor":
            mapname = &"harbor";
            location = &"warsaw, poland";
            hazard = &"blizzard";
            break;
        case "mp_hurtgen":
            mapname = &"hurtgen";
            location = &"hurtgen forest, belgium/germany";
            hazard = &"blizzard";
            break;
        case "mp_pavlov":
            mapname = &"pavlov";
            location = &"stalingrad, russia";
            hazard = &"blizzard";
            break;
        case "mp_powcamp":
            mapname = &"pow camp";
            location = &"strasshof an der nordbahn, austria";
            hazard = &"stormy";
            break;
        case "mp_railyard":
            mapname = &"railyard";
            location = &"warsaw, poland";
            hazard = &"blizzard";
            break;
        case "mp_rocket":
            mapname = &"rocket";
            hazard = &"blizzard";
            break;
        case "mp_ship":
            mapname = &"ship";
            location = &"atlantic ocean";
            hazard = &"stormy";
            break;
    }
    
    precache::object( "levelshots/" + name + ".dds", "shader" );
    precache::object( mapname, "string" );
    precache::object( location, "string" );
    precache::object( hazard, "string" );
    
    level.mapcandidate[ j ][ "hud_mapname" ] = mapname;
    level.mapcandidate[ j ][ "hud_location" ] = location;
    level.mapcandidate[ j ][ "hud_hazard" ] = hazard;
}

grab_random_map() {
    currentmap = getCvar( "mapname" );
    
    maps = [];
    maps[ 0 ] = "mp_brecourt";
    maps[ 1 ] = "mp_carentan";
    maps[ 2 ] = "mp_chateau";
    maps[ 3 ] = "mp_dawnville";
    maps[ 4 ] = "mp_depot";
    maps[ 5 ] = "mp_harbor";
    maps[ 6 ] = "mp_hurtgen";
    maps[ 7 ] = "mp_pavlov";
    maps[ 8 ] = "mp_powcamp";
    maps[ 9 ] = "mp_railyard";
    maps[ 10 ] = "mp_rocket";
    maps[ 11 ] = "mp_ship";
    
    goodmaps = [];
    for ( i = 0; i < maps.size; i++ ) {
        if ( maps[ i ] != currentmap )
            goodmaps[ goodmaps.size ] = maps[ i ];
    }
    
    map = goodmaps[ randomInt( goodmaps.size ) ];
    return map;
}

get_random_map_rotation( rotation )
{
    if ( !isDefined( rotation ) )
        rotation = getCvar( "sv_maprotation" );
        
    if ( rotation == "" )
        return undefined;
        
	rotation = string::strip( rotation );
	
	// Explode entries into an array
    arr = string::explode( rotation, " " );

	// Remove empty elements (double spaces)
	temparr = [];
    for ( i = 0; i < arr.size; i++ ) {
        element = string::strip( arr[ i ] );
        if ( element != "" )
            temparr[ temparr.size ] = element;
    }

	mapsinvote = [];
    number = 0;
	lastgt = "zom";
	for ( i = 0; i < temparr.size; )
	{
		switch ( temparr[ i ] )
		{
			case "gametype":
				if ( isdefined( temparr[ i + 1 ] ) )
					lastgt = temparr[ i + 1 ];
				i += 2;
				break;

			case "map":
				if ( isdefined( temparr[ i + 1 ] ) )
				{
					mapsinvote[ mapsinvote.size ][ "gametype" ]	= lastgt;
					mapsinvote[ mapsinvote.size - 1 ][ "map" ] = temparr[ i + 1 ];
				}

				i += 2;
				break;

			// If code get here, then the maprotation is corrupt so we have to fix it
			default:
				iprintlnbold( "Warning: Error detected in map rotation" );
	
				if ( is_gametype( temparr[ i ] ) )
					lastgt = temparr[ i ];
				else
				{
					mapsinvote[ mapsinvote.size ][ "gametype" ]	= lastgt;
					mapsinvote[ mapsinvote.size - 1 ][ "map" ] = temparr[ i ];
				}
					

				i += 1;
				break;
		}
		if ( number && mapsinvote.size >= number )
			break;
	}

	// Shuffle the array 20 times
	for ( k = 0; k < 20; k++ )
	{
		for ( i = 0; i < mapsinvote.size; i++ )
		{
			j = randomInt( mapsinvote.size );
			element = mapsinvote[ i ];
			mapsinvote[ i ] = mapsinvote[ j ];
			mapsinvote[ j ] = element;
		}
	}

	return mapsinvote;
}

is_gametype( gt )
{
	switch ( gt )
	{
		case "dm":
		case "tdm":
		case "sd":
		case "hq":
		case "ctf":
		case "ihtf":
		case "wrz":
		case "zom":	
        case "zombies":
		case "obj":	
		case "ft":	
		case "utd":			
			return true;

		default:
			return false;
	}
}

get_map_name( map ) {
    switch ( string::tolower( map ) ) {
        case "mp_brecourt":     return &"Brecourt";
        case "mp_carentan":     return &"Carentan";
        case "mp_chateau":      return &"Chateau";
        case "mp_dawnville":    return &"Dawnville";
        case "mp_depot":        return &"Depot";
        case "mp_harbor":       return &"Harbor";
        case "mp_hurtgen":      return &"Hurtgen";
        case "mp_pavlov":       return &"Pavlov";
        case "mp_powcamp":      return &"POW Camp";
        case "mp_railyard":     return &"Railyard";
        case "mp_rocket":       return &"Rocket";
        case "mp_ship":         return &"Ship";
        default:                return map;
    }
}