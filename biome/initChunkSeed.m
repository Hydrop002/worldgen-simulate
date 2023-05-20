function chunkSeed = initChunkSeed(x, z, worldGenSeed)
    chunkSeed = mod(worldGenSeed * mod(worldGenSeed * 1284865837 + 4150755663, 2147483648), 2147483648);
    chunkSeed = chunkSeed + x;
    chunkSeed = mod(chunkSeed * mod(chunkSeed * 1284865837 + 4150755663, 2147483648), 2147483648);
    chunkSeed = chunkSeed + z;
    chunkSeed = mod(chunkSeed * mod(chunkSeed * 1284865837 + 4150755663, 2147483648), 2147483648);
    chunkSeed = chunkSeed + x;
    chunkSeed = mod(chunkSeed * mod(chunkSeed * 1284865837 + 4150755663, 2147483648), 2147483648);
    chunkSeed = chunkSeed + z;
    chunkSeed = mod(chunkSeed, 4294967296);
end