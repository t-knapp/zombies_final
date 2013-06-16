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
    minefields = entity::get_array( "minefield" );
    if ( minefields.size == 0 )
        return;
        
    minefieldtype = "none";
    switch ( string::tolower( cvar::get_global( "mapname" ) ) ) {
        case "mp_brecourt":     minefieldtype = "radiation";    break;
        case "mp_hurtgen":
        case "mp_pavlov":
        case "mp_rocket":       minefieldtype = "standard";     break;
    }
    
    if ( minefieldtype == "standard" ) {
        level._effect[ "mine_explosion" ] = loadfx( "fx/impacts/newimps/minefield.efx" );
        pthread::create( undefined, ::standard_minefields, level, undefined, true );
    }
    else if ( minefieldtype == "radiation" )
        pthread::create( undefined, ::radiation_minefields, level, undefined, true );
}

standard_minefields() {
    minefields = entity::get_array( "minefield" );
    for ( i = 0; i < minefields.size; i++ )
        pthread::create( undefined, ::standard_think, minefields[ i ], undefined, true );
}

standard_think() {
    level endon( "zombies_end_game" );
    
    while ( true ) {
        self waittill( "trigger", other );
        
        if ( isPlayer( other ) )
            pthread::create( undefined, ::standard_kill, other, self, true );
    }
}

standard_kill( trig ) {
    if ( isDefined( self.flag ) )
        return;
        
    self.flag = true;
	self playsound( "minefield_click" );
    
    wait 0.5;
    wait randomfloat( 0.5 );
    
    if ( self istouching( trig ) ) {
        self playsound( "explo_mine" );
        playfx( level._effect[ "mine_explosion" ], self.origin );
        radiusdamage( self.origin, 300, 2000, 50 );
    }
    
    self.flag = undefined;
}

radiation_minefields() {
    minefields = entity::get_array( "minefield" );
    for ( i = 0; i < minefields.size; i++ ) 
        pthread::create( undefined, ::radiation_think, minefields[ i ], undefined, true );
}

radiation_think() {
    level endon( "zombies_end_game" );
    
    while ( true ) {
        self waittill( "trigger", other );
        
        if ( isPlayer( other ) && other.info[ "team" ] == "hunters" )
            pthread::create( undefined, ::radiation_kill, other, self, true );
    }
}

radiation_kill( trig ) {
    if ( isDefined( self.flag ) )
        return;
        
    self.flag = true;
    
    dmg = [];
    
    lastval = 0;
    for ( i = 1; i < 30; i++ ) {
        // calculate the total amount of damage that sound have been done
        tmp = math::pow( 1 * ( 1 + 0.36 ), i );
        
        // determine actual damage to be done at this point
        dmg[ i - 1 ] = tmp - lastval;
    }
    
    p = 0;
    if ( isDefined( self.radiationp ) )
        p = self.radiationp;
        
    while ( isAlive( self ) && self istouching( trig ) ) {
        self.radiationp = p;
        self finishPlayerDamage( self, self, (int)dmg[ p ], 0, "MOD_SUICIDE", "none", ( 0, 0, 0 ), ( 0, 0, 1 ), "head" );
        wait 1;
        p++;
    }
    
    self.flag = undefined;
    
    if ( !isAlive( self ) )
        self.radiationp = undefined;
}