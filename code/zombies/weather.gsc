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
    // default fog already implemented because of 1.1libraries
    level.timeofday = "night";
    if ( math::rand( 100 ) > 20 )
        level.timeofday = "day";
        
    if ( level.timeofday == "night" ) {
        level.darkness.alpha = 0.7;
        
        weather::set_fog( "expfog", 0, 0.001, "black", 0 );
    }
    else {
        level.darkness.alpha = 0.1;
        
        switch ( string::tolower( cvar::get_global( "mapname" ) ) ) {
            // other stuff
            case "mp_brecourt":
                weather::set_fog( "expfog", 0, 0.005, "camo green", 0 );
                break;
            case "mp_depot":
                // depot can have two 
                weather::set_fog( "expfog", 0, 0.0007, "dust", 0 );
                //weather::set_fog( "expfog", 0, 0.004, "camouflage green", 0 );
                break;
                
            // dusty maps
            case "mp_dawnville":
                weather::set_fog( "expfog", 0, 0.0007, "dust", 0 );
                create_hazard( "haboob" );
                break;
                
            // rainy maps
            case "mp_carentan":
            case "mp_chateau":
            case "mp_powcamp":
            case "mp_ship":
                level.darkness.alpha = 0.4; // :D
                weather::set_fog( "expfog", 0, 0.001, "bluey grey", 0 );
                create_hazard( "stormy" );
                break;
                
            // snow maps
            case "mp_harbor":
            case "mp_hurtgen":
            case "mp_pavlov":
            case "mp_railyard":
            case "mp_rocket":
                weather::set_fog( "expfog", 0, 0.0007, "white", 0 );
                create_hazard( "blizzard" );
                break;
            
            // otherwise
            default:
                break;
        }
    }
}

create_hazard( sType ) {
    if ( !isDefined( sType ) )
        return false;
        
    hazard = weather::create_weather_event( "blank" );
    
    switch ( sType ) {
        case "blizzard":
        case "haboob":
        case "stormy":
            hazard = weather::create_weather_event( sType, 30, 150 );
            break;
        default:
            return;
            break;
    }
    
    pthread::create( undefined, ::run_hazard, level, hazard, true );
}

run_hazard( event ) {
    level endon( "game over" );
    
    lasteventtime = gettime();
    nexteventtime = lasteventtime + 150000;
    nexteventtime += ( math::rand( 500 ) * 1000 );
    
    while ( true ) {
        // at least 3 minutes inbetween 
        if ( gettime() > nexteventtime ) {
            weather::start_weather_event( event );
            
            wait 1;
            
            while ( level.weatherEvent )
                wait 1;
                
            lasteventtime = gettime();
            nexteventtime = lasteventtime + 150000;
            nexteventtime += ( math::rand( 500 ) * 1000 );
        }
        
        wait 1;
    }
}