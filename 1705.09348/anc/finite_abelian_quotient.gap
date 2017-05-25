## Warning: this takes several hours.
F := FreeGroup("a", "b");
a := F.1;
b := F.2;

G := F / [
    Comm(a^3, b^3),
    Comm(a^4, b^4),
    Comm((a*b)^3, (b*a)^3),
    Comm((a*b)^4, (b*a)^4),
    a^24,
    b^24,
];

K := Kernel(MaximalAbelianQuotient(G));
KK := Image(IsomorphismFpGroup(K));

LoadPackage("kbmag");
rws := KBMAGRewritingSystem(KK);
OR := OptionsRecordOfKBMAGRewritingSystem(rws);
OR.maxeqns := 100 * 32767;
KnuthBendix(rws);
Display(Size(rws));
