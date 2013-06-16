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
    level endon( "zombies_game_ended" );
    
    for ( ;; ) {
		self waittill( "menuresponse", menu, response );
		
		if ( response == "open" || response == "close" )
			continue;

		if ( menu == game["menu_team"] ) {
			switch ( response ) {
                case "allies":
                case "axis":
                case "autoassign":                  
                    if ( flag::isset( "zombies_game_started" ) )
                        response = "allies";
                    else
                        response = "axis";
                        
                    if ( cvar::get_global( "zom_force_team" ) != "none" )
                        response = cvar::get_global( "zom_force_team" );
                        
                    if ( response == self.pers["team"] && self.sessionstate == "playing" )
                        break;

                    if ( response != self.pers["team"] && self.sessionstate == "playing" )
                        self suicide();

                    self notify( "end_respawn" );

                    self.pers["team"] = response;
                    self.pers["weapon"] = undefined;
                    self.pers["savedmodel"] = undefined;
                    
                    if ( response == "axis" )
                        self.info[ "new_team" ] = "hunters";
                    else
                        self.info[ "new_team" ] = "zombies";
                    
                    self zombies\players::spawn_player();
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
			quickcommands( response );
		else if ( menu == game["menu_quickstatements"] )
			quickstatements( response );
		else if ( menu == game["menu_quickresponses"] )
			quickresponses( response );
	}
}


quickcommands(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
    
    switch ( self.info[ "nationality" ] ) {
		case "american":
			switch ( response ) {
                case "1":
                    soundalias = "american_follow_me";
                    saytext = &"QUICKMESSAGE_FOLLOW_ME";
                    //saytext = "Follow Me!";
                    break;

                case "2":
                    soundalias = "american_move_in";
                    saytext = &"QUICKMESSAGE_MOVE_IN";
                    //saytext = "Move in!";
                    break;

                case "3":
                    soundalias = "american_fall_back";
                    saytext = &"QUICKMESSAGE_FALL_BACK";
                    //saytext = "Fall back!";
                    break;

                case "4":
                    soundalias = "american_suppressing_fire";
                    saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
                    //saytext = "Suppressing fire!";
                    break;

                case "5":
                    soundalias = "american_attack_left_flank";
                    saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
                    //saytext = "Squad, attack left flank!";
                    break;

                case "6":
                    soundalias = "american_attack_right_flank";
                    saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
                    //saytext = "Squad, attack right flank!";
                    break;

                case "7":
                    soundalias = "american_hold_position";
                    saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
                    //saytext = "Squad, hold this position!";
                    break;

                case "8":
                    temp = randomInt(2);

                    if(temp)
                    {
                        soundalias = "american_regroup";
                        saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
                        //saytext = "Squad, regroup!";
                    }
                    else
                    {
                        soundalias = "american_stick_together";
                        saytext = &"QUICKMESSAGE_SQUAD_STICK_TOGETHER";
                        //saytext = "Squad, stick together!";
                    }
                    break;
            }
			break;

		case "british":
			switch ( response ) {
                case "1":
                    soundalias = "british_follow_me";
                    saytext = &"QUICKMESSAGE_FOLLOW_ME";
                    //saytext = "Follow Me!";
                    break;

                case "2":
                    soundalias = "british_move_in";
                    saytext = &"QUICKMESSAGE_MOVE_IN";
                    //saytext = "Move in!";
                    break;

                case "3":
                    soundalias = "british_fall_back";
                    saytext = &"QUICKMESSAGE_FALL_BACK";
                    //saytext = "Fall back!";
                    break;

                case "4":
                    soundalias = "british_suppressing_fire";
                    saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
                    //saytext = "Suppressing fire!";
                    break;

                case "5":
                    soundalias = "british_attack_left_flank";
                    saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
                    //saytext = "Squad, attack left flank!";
                    break;

                case "6":
                    soundalias = "british_attack_right_flank";
                    saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
                    //saytext = "Squad, attack right flank!";
                    break;

                case "7":
                    soundalias = "british_hold_position";
                    saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
                    //saytext = "Squad, hold this position!";
                    break;

                case "8":
                    temp = randomInt(2);

                    if(temp)
                    {
                        soundalias = "british_regroup";
                        saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
                        //saytext = "Squad, regroup!";
                    }
                    else
                    {
                        soundalias = "british_stick_together";
                        saytext = &"QUICKMESSAGE_SQUAD_STICK_TOGETHER";
                        //saytext = "Squad, stick together!";
                    }
                    break;
			}
			break;

		case "russian":
			switch ( response ) {
                case "1":
                    soundalias = "russian_follow_me";
                    saytext = &"QUICKMESSAGE_FOLLOW_ME";
                    //saytext = "Follow Me!";
                    break;

                case "2":
                    soundalias = "russian_move_in";
                    saytext = &"QUICKMESSAGE_MOVE_IN";
                    //saytext = "Move in!";
                    break;

                case "3":
                    soundalias = "russian_fall_back";
                    saytext = &"QUICKMESSAGE_FALL_BACK";
                    //saytext = "Fall back!";
                    break;

                case "4":
                    soundalias = "russian_suppressing_fire";
                    saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
                    //saytext = "Suppressing fire!";
                    break;

                case "5":
                    soundalias = "russian_attack_left_flank";
                    saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
                    //saytext = "Squad, attack left flank!";
                    break;

                case "6":
                    soundalias = "russian_attack_right_flank";
                    saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
                    //saytext = "Squad, attack right flank!";
                    break;

                case "7":
                    soundalias = "russian_hold_position";
                    saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
                    //saytext = "Squad, hold this position!";
                    break;

                case "8":
                    soundalias = "russian_regroup";
                    saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
                    //saytext = "Squad, regroup!";
                    break;
			}
			break;

        case "german":
			switch ( response ) {
                case "1":
                    soundalias = "german_follow_me";
                    saytext = &"QUICKMESSAGE_FOLLOW_ME";
                    //saytext = "Follow Me!";
                    break;

                case "2":
                    soundalias = "german_move_in";
                    saytext = &"QUICKMESSAGE_MOVE_IN";
                    //saytext = "Move in!";
                    break;

                case "3":
                    soundalias = "german_fall_back";
                    saytext = &"QUICKMESSAGE_FALL_BACK";
                    //saytext = "Fall back!";
                    break;

                case "4":
                    soundalias = "german_suppressing_fire";
                    saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
                    //saytext = "Suppressing fire!";
                    break;

                case "5":
                    soundalias = "german_attack_left_flank";
                    saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
                    //saytext = "Squad, attack left flank!";
                    break;

                case "6":
                    soundalias = "german_attack_right_flank";
                    saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
                    //saytext = "Squad, attack right flank!";
                    break;

                case "7":
                    soundalias = "german_hold_position";
                    saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
                    //saytext = "Squad, hold this position!";
                    break;

                case "8":
                    soundalias = "german_regroup";
                    saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
                    //saytext = "Squad, regroup!";
                    break;
			}
			break;
    }			

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();	
}

quickstatements(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
	
	switch ( self.info[ "nationality" ] ) {
		case "american":
			switch ( response ) {
                case "1":
                    soundalias = "american_enemy_spotted";
                    saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
                    //saytext = "Enemy spotted!";
                    break;

                case "2":
                    soundalias = "american_enemy_down";
                    saytext = &"QUICKMESSAGE_ENEMY_DOWN";
                    //saytext = "Enemy down!";
                    break;

                case "3":
                    soundalias = "american_in_position";
                    saytext = &"QUICKMESSAGE_IM_IN_POSITION";
                    //saytext = "I'm in position.";
                    break;

                case "4":
                    soundalias = "american_area_secure";
                    saytext = &"QUICKMESSAGE_AREA_SECURE";
                    //saytext = "Area secure!";
                    break;

                case "5":
                    soundalias = "american_grenade";
                    saytext = &"QUICKMESSAGE_GRENADE";
                    //saytext = "Grenade!";
                    break;

                case "6":
                    soundalias = "american_sniper";
                    saytext = &"QUICKMESSAGE_SNIPER";
                    //saytext = "Sniper!";
                    break;

                case "7":
                    soundalias = "american_need_reinforcements";
                    saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
                    //saytext = "Need reinforcements!";
                    break;

                case "8":
                    soundalias = "american_hold_fire";
                    saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
                    //saytext = "Hold your fire!";
                    break;
			}
			break;

		case "british":
			switch ( response ) {
                case "1":
                    soundalias = "british_enemy_spotted";
                    saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
                    //saytext = "Enemy spotted!";
                    break;

                case "2":
                    soundalias = "british_enemy_down";
                    saytext = &"QUICKMESSAGE_ENEMY_DOWN";
                    //saytext = "Enemy down!";
                    break;

                case "3":
                    soundalias = "british_in_position";
                    saytext = &"QUICKMESSAGE_IM_IN_POSITION";
                    //saytext = "I'm in position.";
                    break;

                case "4":
                    soundalias = "british_area_secure";
                    saytext = &"QUICKMESSAGE_AREA_SECURE";
                    //saytext = "Area secure!";
                    break;

                case "5":
                    soundalias = "british_grenade";
                    saytext = &"QUICKMESSAGE_GRENADE";
                    //saytext = "Grenade!";
                    break;

                case "6":
                    soundalias = "british_sniper";
                    saytext = &"QUICKMESSAGE_SNIPER";
                    //saytext = "Sniper!";
                    break;

                case "7":
                    soundalias = "british_need_reinforcements";
                    saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
                    //saytext = "Need reinforcements!";
                    break;

                case "8":
                    soundalias = "british_hold_fire";
                    saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
                    //saytext = "Hold your fire!";
                    break;
			}
			break;

		case "russian":
			switch ( response ) {
                case "1":
                    soundalias = "russian_enemy_spotted";
                    saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
                    //saytext = "Enemy spotted!";
                    break;

                case "2":
                    soundalias = "russian_enemy_down";
                    saytext = &"QUICKMESSAGE_ENEMY_DOWN";
                    //saytext = "Enemy down!";
                    break;

                case "3":
                    soundalias = "russian_in_position";
                    saytext = &"QUICKMESSAGE_IM_IN_POSITION";
                    //saytext = "I'm in position.";
                    break;

                case "4":
                    soundalias = "russian_area_secure";
                    saytext = &"QUICKMESSAGE_AREA_SECURE";
                    //saytext = "Area secure!";
                    break;

                case "5":
                    soundalias = "russian_grenade";
                    saytext = &"QUICKMESSAGE_GRENADE";
                    //saytext = "Grenade!";
                    break;

                case "6":
                    soundalias = "russian_sniper";
                    saytext = &"QUICKMESSAGE_SNIPER";
                    //saytext = "Sniper!";
                    break;

                case "7":
                    soundalias = "russian_need_reinforcements";
                    saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
                    //saytext = "Need reinforcements!";
                    break;

                case "8":
                    soundalias = "russian_hold_fire";
                    saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
                    //saytext = "Hold your fire!";
                    break;
			}
			break;

		case "german":
			switch ( response ) {
                case "1":
                    soundalias = "german_enemy_spotted";
                    saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
                    //saytext = "Enemy spotted!";
                    break;

                case "2":
                    soundalias = "german_enemy_down";
                    saytext = &"QUICKMESSAGE_ENEMY_DOWN";
                    //saytext = "Enemy down!";
                    break;

                case "3":
                    soundalias = "german_in_position";
                    saytext = &"QUICKMESSAGE_IM_IN_POSITION";
                    //saytext = "I'm in position.";
                    break;

                case "4":
                    soundalias = "german_area_secure";
                    saytext = &"QUICKMESSAGE_AREA_SECURE";
                    //saytext = "Area secure!";
                    break;

                case "5":
                    soundalias = "german_grenade";
                    saytext = &"QUICKMESSAGE_GRENADE";
                    //saytext = "Grenade!";
                    break;

                case "6":
                    soundalias = "german_sniper";
                    saytext = &"QUICKMESSAGE_SNIPER";
                    //saytext = "Sniper!";
                    break;

                case "7":
                    soundalias = "german_need_reinforcements";
                    saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
                    //saytext = "Need reinforcements!";
                    break;

                case "8":
                    soundalias = "german_hold_fire";
                    saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
                    //saytext = "Hold your fire!";
                    break;
			}
			break;
    }			

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

quickresponses(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
    
    switch ( self.info[ "nationality" ] ) {
		case "american":
			switch ( response ) {
                case "1":
                    soundalias = "american_yes_sir";
                    saytext = &"QUICKMESSAGE_YES_SIR";
                    //saytext = "Yes Sir!";
                    break;

                case "2":
                    soundalias = "american_no_sir";
                    saytext = &"QUICKMESSAGE_NO_SIR";
                    //saytext = "No Sir!";
                    break;

                case "3":
                    soundalias = "american_on_my_way";
                    saytext = &"QUICKMESSAGE_ON_MY_WAY";
                    //saytext = "On my way.";
                    break;

                case "4":
                    soundalias = "american_sorry";
                    saytext = &"QUICKMESSAGE_SORRY";
                    //saytext = "Sorry.";
                    break;

                case "5":
                    soundalias = "american_great_shot";
                    saytext = &"QUICKMESSAGE_GREAT_SHOT";
                    //saytext = "Great shot!";
                    break;

                case "6":
                    soundalias = "american_took_long_enough";
                    saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
                    //saytext = "Took long enough!";
                    break;

                case "7":
                    temp = randomInt(3);

                    if(temp == 0)
                    {
                        soundalias = "american_youre_crazy";
                        saytext = &"QUICKMESSAGE_YOURE_CRAZY";
                        //saytext = "You're crazy!";
                    }
                    else if(temp == 1)
                    {
                        soundalias = "american_you_outta_your_mind";
                        saytext = &"QUICKMESSAGE_YOU_OUTTA_YOUR_MIND";
                        //saytext = "You outta your mind?";
                    }
                    else
                    {
                        soundalias = "american_youre_nuts";
                        saytext = &"QUICKMESSAGE_YOURE_NUTS";
                        //saytext = "You're nuts!";
                    }
                    break;
            }
			break;

		case "british":
			switch ( response ) {
                case "1":
                    soundalias = "british_yes_sir";
                    saytext = &"QUICKMESSAGE_YES_SIR";
                    //saytext = "Yes Sir!";
                    break;

                case "2":
                    soundalias = "british_no_sir";
                    saytext = &"QUICKMESSAGE_NO_SIR";
                    //saytext = "No Sir!";
                    break;

                case "3":
                    soundalias = "british_on_my_way";
                    saytext = &"QUICKMESSAGE_ON_MY_WAY";
                    //saytext = "On my way.";
                    break;

                case "4":
                    soundalias = "british_sorry";
                    saytext = &"QUICKMESSAGE_SORRY";
                    //saytext = "Sorry.";
                    break;

                case "5":
                    soundalias = "british_great_shot";
                    saytext = &"QUICKMESSAGE_GREAT_SHOT";
                    //saytext = "Great shot!";
                    break;

                case "6":
                    soundalias = "british_took_long_enough";
                    saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
                    //saytext = "Took long enough!";
                    break;

                case "7":
                    soundalias = "british_youre_crazy";
                    saytext = &"QUICKMESSAGE_YOURE_CRAZY";
                    //saytext = "You're crazy!";
                    break;
			}
			break;

		case "russian":
			switch ( response ) {
                case "1":
                    soundalias = "russian_yes_sir";
                    saytext = &"QUICKMESSAGE_YES_SIR";
                    //saytext = "Yes Sir!";
                    break;

                case "2":
                    soundalias = "russian_no_sir";
                    saytext = &"QUICKMESSAGE_NO_SIR";
                    //saytext = "No Sir!";
                    break;

                case "3":
                    soundalias = "russian_on_my_way";
                    saytext = &"QUICKMESSAGE_ON_MY_WAY";
                    //saytext = "On my way.";
                    break;

                case "4":
                    soundalias = "russian_sorry";
                    saytext = &"QUICKMESSAGE_SORRY";
                    //saytext = "Sorry.";
                    break;

                case "5":
                    soundalias = "russian_great_shot";
                    saytext = &"QUICKMESSAGE_GREAT_SHOT";
                    //saytext = "Great shot!";
                    break;

                case "6":
                    soundalias = "russian_took_long_enough";
                    saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
                    //saytext = "Took long enough!";
                    break;

                case "7":
                    soundalias = "russian_youre_crazy";
                    saytext = &"QUICKMESSAGE_YOURE_CRAZY";
                    //saytext = "You're crazy!";
                    break;
			}
			break;

		case "german":
			switch ( response ) {
                case "1":
                    soundalias = "german_yes_sir";
                    saytext = &"QUICKMESSAGE_YES_SIR";
                    //saytext = "Yes Sir!";
                    break;

                case "2":
                    soundalias = "german_no_sir";
                    saytext = &"QUICKMESSAGE_NO_SIR";
                    //saytext = "No Sir!";
                    break;

                case "3":
                    soundalias = "german_on_my_way";
                    saytext = &"QUICKMESSAGE_ON_MY_WAY";
                    //saytext = "On my way.";
                    break;

                case "4":
                    soundalias = "german_sorry";
                    saytext = &"QUICKMESSAGE_SORRY";
                    //saytext = "Sorry.";
                    break;

                case "5":
                    soundalias = "german_great_shot";
                    saytext = &"QUICKMESSAGE_GREAT_SHOT";
                    //saytext = "Great shot!";
                    break;

                case "6":
                    soundalias = "german_took_long_enough";
                    saytext = &"QUICKMESSAGE_TOOK_YOU_LONG_ENOUGH";
                    //saytext = "Took you long enough!";				
                    break;

                case "7":
                    soundalias = "german_are_you_crazy";
                    saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
                    //saytext = "Are you crazy?";
                    break;
			}
			break;
    }			

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

doQuickMessage(soundalias, saytext)
{
	if(self.sessionstate != "playing")
		return;

	if(isdefined(level.QuickMessageToAll) && level.QuickMessageToAll)
	{
		self.headiconteam = "none";
		self.headicon = "gfx/hud/headicon@quickmessage";

		self playSound(soundalias);
		self sayAll(saytext);
	}
	else
	{
		if(self.sessionteam == "allies")
			self.headiconteam = "allies";
		else if(self.sessionteam == "axis")
			self.headiconteam = "axis";
		
		self.headicon = "gfx/hud/headicon@quickmessage";

		self playSound(soundalias);
		self sayTeam(saytext);
		self pingPlayer();
	}
}

saveHeadIcon()
{
	if(isdefined(self.headicon))
		self.oldheadicon = self.headicon;

	if(isdefined(self.headiconteam))
		self.oldheadiconteam = self.headiconteam;
}

restoreHeadIcon()
{
	if(isdefined(self.oldheadicon))
		self.headicon = self.oldheadicon;

	if(isdefined(self.oldheadiconteam))
		self.headiconteam = self.oldheadiconteam;
}