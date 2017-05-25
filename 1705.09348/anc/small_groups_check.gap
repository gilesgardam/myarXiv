## WARNING: this script could take a day to execute!

IsLaw := function(G, F, w)
    local Ggens, k, images, phi;
    Ggens := GeneratorsOfGroup(F);
    k := Size(Ggens);
    for images in Tuples(G, k) do
        phi := GroupHomomorphismByImages(F, G, Ggens, images);
        if not IsOne(Image(phi, w)) then
            return false;
        fi;
    od;
    return true;
end;

PowerSubgroup := function(G, pow)
    # super naive!
    return Subgroup(G, List(G, x -> x^pow));
end;

PowerPairs := function(n)
    ## returns all pairs [r, s] such that
    ##     n = r * s
    ##     gcd(r, s) = 1
    ##     r, s > 1
    ## and the smallest prime dividing n divides r
    ## (so as to make the pair effectively unordered)

    local ret, prime_powers, k, comb, s, r;

    ret := [];

    ## e.g. prime_powers = [2, 729]
    prime_powers := List(Collected(Factors(n)), x -> x[1]^x[2]);

    k := Size(prime_powers);
    for comb in Combinations(prime_powers{[2..k]}) do
        if Size(comb) = 0 then
            continue;          # do not want s = 1
        fi;
        s := Product(comb);
        r := n / s;
        Add(ret, [r, s]);
    od;

    return ret;
end;

CheckDerivedLengths := function(G, r, s)
    local der_len, Gr, Gs;
    der_len := DerivedLength(G);
    Gr := PowerSubgroup(G, r);
    if Order(Gr) = Order(G) then
        return false;
    fi;
    Gs := PowerSubgroup(G, s);
    if Order(Gs) = Order(G) then
        return false;
    fi;
    if DerivedLength(Gr) < der_len and DerivedLength(Gs) < der_len then
        Print("Found a group W, id = ", IdGroup(G), "\n");
        Print("Derived length of G = ", DerivedLength(G), "\n");
        Print("Derived length of G^", r, " = ", DerivedLength(Gr), "\n");
        Print("Derived length of G^", s, " = ", DerivedLength(Gs), "\n");
        return true;
    fi;
end;

TestGroup := function(G, F, w, r, s)
    local Gr, Gs;
    Gr := PowerSubgroup(G, 2);
    Gs := PowerSubgroup(G, 3);
    Print("Testing SmallGroup(", IdGroup(G), ")\n");
    Print("Does w hold in G?   ");
    Print(IsLaw(G, F, w), "\n");
    Print("Does w hold in G^", r, "? ");
    Print(IsLaw(Gr, F, w), "\n");
    Print("Does w hold in G^", s, "? ");
    Print(IsLaw(Gs, F, w), "\n");

end;

Print("If a group doesn't satisfy a law that its power subgroups do, then\n");
Print("this is the case in all of its direct factors.\n");
Print("Finding the smallest group with proper coprime power subgroups\n");
Print("that is not a non-trivial direct product...\n");
for n in [1..42] do
    for G in AllSmallGroups(n, IsNilpotent, false) do
        if Size(DirectFactorsOfGroup(G)) > 1 then
            continue;
        fi;
        for pairs in PowerPairs(n) do
            r := pairs[1];
            s := pairs[2];
            Gr := PowerSubgroup(G, r);
            Gs := PowerSubgroup(G, s);
            if Order(Gr) < n and Order(Gs) < n then
                Print("Found proper power subgroup for ", IdGroup(G), " ");
                Print("with powers ", r, " and ", s, "\n");
            fi;
        od;
    od;
od;

F := FreeGroup("x", "y");
x := F.1;
y := F.2;

Print("--------------------\n");

C7 := CyclicGroup(7);
G := SemidirectProduct(AutomorphismGroup(C7), C7);
w := Comm(Comm(x^2, y^2)^3, y^3);
Print("G is the holomorph of the cyclic group of order 7\n");
Print("w is the law [ [ x^2, y^2 ]^3, y^3 ]\n");
TestGroup(G, F, w, 2, 3);

Print("--------------------\n");

C9 := CyclicGroup(9);
H := SemidirectProduct(AutomorphismGroup(C9), C9);
w := Comm(x^2, x^y);
Print("H is the holomorph of the cyclic group of order 9\n");
Print("w is the law [ x^2, x^y ]\n");
TestGroup(H, F, w, 2, 3);

Print("--------------------\n");

Print("Finding the smallest non-metabelian group with\n");
Print("metabelian coprime power subgroups...\n");
Print("Warning: this could take a day or so!\n");
for n in [1..1458] do
    pairs := PowerPairs(n);
    if Size(pairs) = 0 then
        continue; # definitely no proper coprime power subgroups
    fi;

    M := NumberSmallGroups(n);
    Print("Starting order ", n, " with ", M, " groups\n");

    for i in [1..M] do
        G := SmallGroup(n, i);
        if IsNilpotent(G) then
            continue;
        fi;
        if not IsSolvable(G) then
            continue;
        fi;

        for pair in pairs do
            r := pair[1];
            s := pair[2];
            CheckDerivedLengths(G, r, s);
        od;
    od;
od;
