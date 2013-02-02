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
    vector scale( vector a, int scale )
    vec = vector::scale( ( 128, 128, 10 ), 10 );
    
    Returns vector <a> scaled by <scale>
*/
scale( vecA, scale ) {
    return ( vecA[ 0 ] * scale, vecA[ 1 ] * scale, vecA[ 2 ] * scale );
}

/*
    vector multiply( vector a, vector b )
    vec = vector::multiply( ( 128, 128, 10 ), ( 256, 256, 10 ) );
    
    Returns dot product of <a> and <b>
*/
multiply( vecA, vecB ) {
    return ( vecA[ 0 ] * vecB[ 0 ], vecA[ 1 ] * vecB[ 1 ], vecA[ 2 ] * vecB[ 2 ] );
}

/*
    vector add( vector a, vector b )
    vec = vector::add( ( 10, 10, 10 ), ( 5, 5, 5 ) );
    
    Returns sum of <a> and <b>
*/
add( vecA, vecB ) {
    return ( vecA[ 0 ] + vecB[ 0 ], vecA[ 1 ] + vecB[ 1 ], vecA[ 2 ] + vecB[ 2 ] );
}

/*
    vector subtract( vector a, vector b )
    vec = vector::substract( ( 10, 10, 10 ), ( 5, 5, 5 ) );
    
    Returns difference of <a> and <b>
*/
subtract( vecA, vecB ) {
    return ( vecA[ 0 ] - vecB[ 0 ], vecA[ 1 ] - vecB[ 1 ], vecA[ 2 ] - vecB[ 2 ] );
}