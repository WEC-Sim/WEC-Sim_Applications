function dist = mooring_obj_func(F, xref, zref, par)
[x,z]=mooring_operation(F(1),F(2),par);
dist=(x(end)-xref)^2+(z(end)-zref)^2;
end