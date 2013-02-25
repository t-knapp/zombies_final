main()
{
	precacheModel("xmodel/vehicle_german_yacht_static");
	maps\mp\_load::main();
    
    rail = getentarray ("rail","targetname");
    for (i=0;i<rail.size;i++)
        rail[i] delete();
}