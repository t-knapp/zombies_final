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

// precache all our required materials
init() {
    game[ "allies" ] = "british";
    game[ "axis" ] = "german";
    game[ "menu_team"] = "team_germanonly";
	game[ "menu_weapon_allies" ] = "weapon_british";
	game[ "menu_weapon_axis" ] = "weapon_americangerman";
	game[ "menu_viewmap" ] = "viewmap";
	game[ "menu_callvote" ] = "callvote";
	game[ "menu_quickcommands" ] = "quickcommands";
	game[ "menu_quickstatements" ] = "quickstatements";
	game[ "menu_quickresponses" ] = "quickresponses";
	game[ "headicon_allies" ] = "gfx/hud/headicon@allies.tga";
	game[ "headicon_axis" ] = "gfx/hud/headicon@axis.tga";
    game[ "layoutimage" ] = cvar::get_global( "mapname" );
    
    // menus
    precache::object( &"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN", "string" );
    precache::object( &"MPSCRIPT_KILLCAM", "string" );
	precache::object( game[ "menu_team" ], "menu" );
	precache::object( game[ "menu_weapon_allies" ], "menu" );
	precache::object( game[ "menu_weapon_axis" ], "menu" );
	precache::object( game[ "menu_viewmap" ], "menu" );
	precache::object( game[ "menu_callvote" ], "menu" );
	precache::object( game[ "menu_quickcommands" ], "menu" );
	precache::object( game[ "menu_quickstatements" ], "menu" );
	precache::object( game[ "menu_quickresponses" ], "menu" );
    
    // strings
    
    // shaders
    precache::object( "levelshots/layouts/hud@layout_" + game[ "layoutname" ], "shader" );
	precache::object( "black", "shader" );
	precache::object( "hudScoreboard_mp", "shader" );
	precache::object( "gfx/hud/hud@mpflag_spectator.tga", "shader" );
    
    // items
    precache::object( "item_health", "item" );
	precache::object( "item_health_large", "item" );
	precache::object( "item_health_small", "item" );
	precache::object( "fraggrenade_mp", "item" );
	precache::object( "colt_mp", "item" );
	precache::object( "m1carbine_mp", "item" );
	precache::object( "m1garand_mp", "item" );
	precache::object( "thompson_mp", "item" );
	precache::object( "bar_mp", "item" );
	precache::object( "springfield_mp", "item" );
	precache::object( "mk1britishfrag_mp", "item" );
	precache::object( "enfield_mp", "item" );
	precache::object( "sten_mp", "item" );
	precache::object( "bren_mp", "item" );
	precache::object( "rgd-33russianfrag_mp", "item" );
	precache::object( "luger_mp", "item" );
	precache::object( "mosin_nagant_mp", "item" );
	precache::object( "ppsh_mp", "item" );
	precache::object( "mosin_nagant_sniper_mp", "item" );
	precache::object( "stielhandgranate_mp", "item" );
	precache::object( "kar98k_mp", "item" );
	precache::object( "mp40_mp", "item" );
	precache::object( "mp44_mp", "item" );
	precache::object( "kar98k_sniper_mp", "item" );
	precache::object( "panzerfaust_mp", "item" );
    precache::object( "fg42_mp", "item" );
    
    // models
    
    // shellshocks
    precache::object( "default", "shellshock" );
	precache::object( "groggy", "shellshock" );
	precache::object( "stop", "shellshock" );
    
    // headicons
    precache::object( game[ "headicon_allies" ], "headicon" );
	precache::object( game[ "headicon_axis" ], "headicon" );
    
    // statusicons
    precache::object( "gfx/hud/hud@status_dead.tga", "statusicon" );
	precache::object( "gfx/hud/hud@status_connecting.tga", "statusicon" );
    
    // fx	
    
    setCvar( "scr_layoutimage", "levelshots/layouts/hud@layout_" + game[ "layoutimage" ] );
    makeCvarServerInfo( "scr_layoutimage", "" );
    
    maps\mp\gametypes\_teams::modeltype();
}