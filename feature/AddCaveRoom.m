function ablock = AddCaveRoom(seed, chunkX, chunkZ, ablock, x, y, z)
    ablock = AddCaveTunnel(seed, chunkX, chunkZ, ablock, x, y, z, 1 + rand() * 6, 0, 0, -1, -1, 0.5);
end