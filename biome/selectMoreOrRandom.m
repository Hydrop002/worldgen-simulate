function r = selectMoreOrRandom(p1, p2, p3, p4)
    if p2 == p3 && p3 == p4
        r = p2;
    elseif p1 == p2 && p2 == p3
        r = p1;
    elseif p1 == p2 && p2 == p4
        r = p1;
    elseif p1 == p3 && p3 == p4
        r = p1;
    elseif p1 == p2 && p3 ~= p4
        r = p1;
    elseif p1 == p3 && p2 ~= p4
        r = p1;
    elseif p1 == p4 && p2 ~= p3
        r = p1;
    elseif p2 == p3 && p1 ~= p4
        r = p2;
    elseif p2 == p4 && p1 ~= p3
        r = p2;
    elseif p3 == p4 && p1 ~= p2
        r = p3;
    else
        r = selectRandom([p1, p2, p3, p4]);
    end
end