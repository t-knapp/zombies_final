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
    precache::object( &"GAME CAM", "string" );
}

main( playerNum, delay )
{
	self endon( "disconnect" );
	self endon( "spawned" );

	if ( playerNum < 0 )
		return;
		
	self.sessionstate = "spectator";
	self.spectatorclient = playerNum;
	self.archivetime = delay + 7;

	wait 0.05;
		
	if ( !isDefined( self.gc_topbar ) )
	{
		self.gc_topbar = newClientHudElem( self );
		self.gc_topbar.archived = false;
		self.gc_topbar.x = 0;
		self.gc_topbar.y = 0;
		self.gc_topbar.alpha = 0.75;
		self.gc_topbar.sort = 1000;
		self.gc_topbar setShader( "black", 640, 112 );
	}

	if ( !isDefined( self.gc_bottombar ) )
	{
		self.gc_bottombar = newClientHudElem( self );
		self.gc_bottombar.archived = false;
		self.gc_bottombar.x = 0;
		self.gc_bottombar.y = 368;
		self.gc_bottombar.alpha = 0.75;
		self.gc_bottombar.sort = 1000;
		self.gc_bottombar setShader( "black", 640, 112 );
    }
    
    if ( !isdefined( self.gc_title ) )
	{
		self.gc_title = newClientHudElem( self );
		self.gc_title.archived = false;
		self.gc_title.x = 320;
		self.gc_title.y = 40;
		self.gc_title.alignX = "center";
		self.gc_title.alignY = "middle";
		self.gc_title.sort = 1001; // force to draw after the bars
		self.gc_title.fontScale = 3.5;
        self.gc_title setText( &"GAME CAM" );
	}
}

remove()
{
	self.gc_topbar destroy();
	self.gc_bottombar destroy();
	self.gc_title destroy();
	
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.sessionstate = "dead";
}