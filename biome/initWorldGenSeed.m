function worldGenSeed = initWorldGenSeed(baseSeed)
    global seed;
    worldGenSeed = mod(seed * mod(seed * 1284865837 + 4150755663, 2147483648), 2147483648);
    worldGenSeed = worldGenSeed + baseSeed;
    worldGenSeed = mod(worldGenSeed * mod(worldGenSeed * 1284865837 + 4150755663, 2147483648), 2147483648);
    worldGenSeed = worldGenSeed + baseSeed;
    worldGenSeed = mod(worldGenSeed * mod(worldGenSeed * 1284865837 + 4150755663, 2147483648), 2147483648);
    worldGenSeed = worldGenSeed + baseSeed;
    worldGenSeed = mod(worldGenSeed, 4294967296);
end