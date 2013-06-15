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
    if ( zombies\misc::is_winter_map() ) {
        mptype\american_airborne_winter::precache();
        mptype\british_commando_winter::precache();
        mptype\russian_conscript_winter::precache();
        mptype\german_waffen_winter::precache();
    }
    else {
        mptype\american_airborne::precache();
        mptype\british_airborne::precache();
        mptype\russian_veteran::precache();
        mptype\german_fallschirmjagercamo::precache();
    }
}

player() {
    self detachall();
    
    self.voice = "british";
    
    if ( zombies\misc::is_winter_map() ) {
        if ( self.info[ "team" ] == "zombies" )
            self mptype\british_commando_winter::main();
        else {
            if ( randomInt( 100 ) > 50 ) {
                self mptype\american_airborne_winter::main();
                self.voice = "american";
            }
            else {
                self mptype\german_waffen_winter::main();
                self.voice = "german";
            }
        }
    }
    else {
        if ( self.info[ "team" ] == "zombies" )
            self mptype\british_airborne::main();
        else {
            if ( randomInt( 100 ) > 50 ) {
                self mptype\american_airborne::main();
                self.voice = "american";
            }
            else {
                self mptype\german_fallschirmjagercamo::main();
                self.voice = "german";
            }
        }
    }
}