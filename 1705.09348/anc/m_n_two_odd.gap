F := FreeGroup("a", "b");
a := F.1;
b := F.2;

LoadPackage("kbmag");

m := 2;
for k in [1..24] do
    n := 2*k+1;
    Print("m,n = ", m, ",", n, "\n");
    G := F / [
        Comm(a^m, b^m),
        Comm(a^n, b^n),
        Comm((a*b)^m, (b*a)^m),
        Comm((a*b)^n, (b*a)^n),
    ];
    t1 := Runtimes().user_time_children;

    rws := KBMAGRewritingSystem(G);
    OR := OptionsRecordOfKBMAGRewritingSystem(rws);
    OR.maxeqns := 100 * 32767;
    KnuthBendix(rws);
    Print(Order(rws, Comm(a, b)), "\n");

    t2 := Runtimes().user_time_children;
    Print("That took ", StringTime(t2-t1), "\n");
od;
