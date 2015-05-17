/*
AboveUltimate HydraBlast! Missile launcher FS
                                                                     _______       ______
                                                                    (  ____ \     (  __  \
                                                                    | (    \/     | (  \  )
                                                                    | (__         | |   ) |
                                                                    |  __)        | |   | |
                                                                    | (           | |   ) |
                                                                    | (____/\     | (__/  )
                                                                    (_______/_____(______/
                                                                            (_____)
Author: Extreme_D
E-Mail: Mustafastation@gmail.com

Date: 18 Sept 2014
Last Update: 17 May 2015 (0.3) 

Future Features:*Add visual missile launch effects   *Incorporate ExtremeProjectileMotion once complete

Gamemode requirements: Create a checkpoint at X:841 Y:863 Z:97

Current Version: 0.3 *Used MapAndreas

0.2 
*Used SetTimerEx instead of SetTimer 
*Randomized explosions locations

0.1 
*Added missiles ammo *Added multipile explosions

0.05 
*Added OnPlayerDeath and OnPlayerStateChange *Created Missiles launch function 
*Worked on LaunchMissiles function *Fixed loadmissiles commands
Testing: N/A

0.01 
Basic Structure *Added /missileshelp command *Added /loadmissiles command *Added /launchmissiles command 
*Created LoadMissile Function *Created Unloadmissiles function
Compiles OK with 0 bugs
Testing: N/A
*/


//===============/Includes=========
#include <a_samp>
#include <zcmd>
//#include <mapandreas>
//================Includes/=========

//================/Constants========
#define FLATBED_ID      455

#define TARGETRANGE     300.0

#define GREEN       0x00620099
#define RED         0xAA3333AA
#define BEGE        0xFFA97F99
#define LBLUE       0x33CCFFAA
#define ROYALBLUE   0x4169FFAA
#define YELLOW      0xFFFF00AA
#define ORANGE      0xFF9900AA
#define PINK        0xFF66FFAA
// Checkpoint coordinate X:841.0 Y:863.0 Z:97.0
//================Constants/========

//========/Global Variables=========
new playerHasMissiles[ MAX_PLAYERS ];       // Array to keep track if player ID has loaded missiles

new Float: MarkerX[ MAX_PLAYERS ];          // Array to store player choosen X marker waypoint
new Float: MarkerY[ MAX_PLAYERS ];          // Array to store player choosen Y marker waypoint
new Float: MarkerZ[ MAX_PLAYERS ];          // Array to store player choosen Z marker waypoint

new Vehicles[ 4 ];                          // Array to store Flatbed vehicle IDs

new MissilesAmmo[ MAX_PLAYERS ];            // Array to store the number of missiles a player has

new playerSettingMarker[ MAX_PLAYERS ];     // Array to keep track if player ID 
//========Global Variables/=========

//=======/Function Prototyping=======
forward LoadMissiles( playerid );           // Function to load missiles
forward UnloadMissiles( playerid );         // Function to UNload missiles
forward LaunchMissiles( playerid );         // Function to Launch Missiles
forward CreateExplosionWithTime( playerid );// Function to create explosion
//=======Function Prototyping/=======


// FS intiation
public OnFilterScriptInit()
{
    //MapAndreas_Init(2);           --FS does not load properly when called
    print("--------------------------------------");
    print(" Missile launch system by by Extreme_D");
    print("--------------------------------------");
    
    
    // The 4 launching vehicles
    Vehicles[ 0 ] = CreateVehicle( 455, 861.0, 882.0, 13.7, 180.0, 234, 234, 60);
    Vehicles[ 1 ] = CreateVehicle( 455, 868.0, 886.0, 13.7, 180.0, 234, 234, 60);
    Vehicles[ 2 ] = CreateVehicle( 455, 875.0, 890.0, 13.8, 180.0, 234, 234, 60);
    Vehicles[ 3 ] = CreateVehicle( 455, 882.0, 894.0, 13.8, 180.0, 234, 234, 60);
    
    return 1;
}

// Function to see if player dies, if he's load, use UnloadMissiles
public OnPlayerDeath(playerid, killerid, reason)
{
    
    UnloadMissiles( playerid );
    return 1;
}

// Function to see if a left vehicle for more than 30 seconds
public OnPlayerStateChange(playerid, newstate, oldstate)
{   
    if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT && playerHasMissiles[playerid])
    {
        UnloadMissiles( playerid );
    }
    return 1;
}

// Function to LOAD missiles
public LoadMissiles( playerid )
{
    // Debug message
    SendClientMessage( playerid, LBLUE, "Load Misiles called" );
    
    playerHasMissiles[ playerid ] = 1;
    MissilesAmmo[ playerid ] = 3;
    
    return 1;
}

// Function to UNLOAD missiles
public UnloadMissiles( playerid )
{   
    // Debug message
    SendClientMessage( playerid, LBLUE, "Missiles have been unloaded." );
    
    playerHasMissiles[ playerid ] = 0;
    return 1;
}

// Function to LAUNCH missiles
public LaunchMissiles ( playerid )
{
    // Debug message
    SendClientMessage( playerid, LBLUE, "Launch Misiles called" );
    
    if( playerHasMissiles[ playerid ] && MissilesAmmo[ playerid ] > 0 )
    {
        SendClientMessage( playerid, YELLOW, "Select the target by choosing a waypoint (right click) on your map." );
        SendClientMessage( playerid, YELLOW, "You have 30 seconds to select the target." );
        
        playerSettingMarker[ playerid ] = 1;
  
    }
    
    
    return 1;
}


// Function to CREATE explosion
public CreateExplosionWithTime( playerid )
{
    TogglePlayerControllable(playerid,1);
//  new Float:RandomX = random(100), Float:RandomY = random(100);
    new Float:SumX;
    new Float:SumY;
    SumX = floatadd(MarkerX[playerid], SumX); 
    SumY = floatadd(MarkerY[playerid], SumY);

    CreateExplosion( SumX +random(10), SumY+random(10), MarkerZ[ playerid ], 6, 100);

    SendClientMessage( playerid, YELLOW, "Boom" );
    return 1;
}

//=================/CallBacks===============

// Callback for when player creates a marker on map and creates explosions
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if( playerSettingMarker[ playerid ] )
    {
        playerSettingMarker[ playerid ] = 0;
                
        MarkerX[ playerid ] = fX;
        MarkerY[ playerid ] = fY;
        //MarkerZ[ playerid ] = MapAndreas_FindZ_For2DCoord(fX, fY, fZ);    --FS does not load properly when called
        MarkerZ[ playerid ] = fZ;

        // If player picked target is within range
        if( IsPlayerInRangeOfPoint( playerid, TARGETRANGE, MarkerX[ playerid ], MarkerY[ playerid ], MarkerZ[ playerid] ) )
        {
            SendClientMessage( playerid, YELLOW, "Missile is arming..." );
            TogglePlayerControllable(playerid,0);
            
            MissilesAmmo[ playerid ]--;
                        
            SetTimerEx( "CreateExplosionWithTime", 5000, false,"i",playerid );
            SetTimerEx( "CreateExplosionWithTime", 5400, false,"i",playerid );
            SetTimerEx( "CreateExplosionWithTime", 5800, false,"i",playerid );
            SetTimerEx( "CreateExplosionWithTime", 6200, false,"i",playerid );

          
        }
        else
        {
            SendClientMessage( playerid, RED, "ERROR: Target is out of range" );
        }        
    }
}

//=================CallBacks/===============




//================/Player Commands================
// Basic help and information command
CMD:missileshelp( playerid )
{
    SendClientMessage( playerid, YELLOW, "To use the missile launch system you must acquire a Flatbed truck" );
    SendClientMessage( playerid, YELLOW, "Head to the checkpoint located at the quarry and use /loadmissiles to load the missiles to the truck" );
    SendClientMessage( playerid, YELLOW, "To launch the missiles, you must stand by a reasonable distance to the target" );
    SendClientMessage( playerid, YELLOW, "use /launchmissile and then on your main menu, go to the map and set a waypoint (right click) on the target" );
    SendClientMessage( playerid, YELLOW, "it takes 10 seoncds to arm and launch the missile, you must remain stationary and not move until missile is launched" );
    return 1;
}

// Command to load missiles into the Flatbed truck
CMD:loadmissiles( playerid )
{
    // If player is in the checkpoint and is in a Flatbed truck
    if( IsPlayerInRangeOfPoint( playerid, 10.0, 841.0, 863.0, 13.0) && ( IsPlayerInVehicle( playerid , Vehicles[0] ) 
        || IsPlayerInVehicle( playerid , Vehicles[1] ) || IsPlayerInVehicle( playerid , Vehicles[2] )
        || IsPlayerInVehicle( playerid , Vehicles[3] ) ) )
    {
        SendClientMessage( playerid, GREEN, "Missiles have been loaded, /launchmissile to launch at a target." );
        LoadMissiles( playerid );

    }
    
    // Otherwise ....
    if( !IsPlayerInRangeOfPoint( playerid, 10, 841.0, 863.0, 13.0) )
    {
        SendClientMessage( playerid, RED, "You are not in range of the checkpoint." );
    }

    
    // Send message if player is NOT in a flatbed
    
    return 1;
}

// Command to launch missiles
CMD:launchmissile( playerid )
{
    if( MissilesAmmo[ playerid ] )
        LaunchMissiles( playerid );
    else
        SendClientMessage( playerid, RED, "Out of ammo!" );
    
    return 1;
}

//================Player Commands/================
