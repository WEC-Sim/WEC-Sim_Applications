function body1_hydroForceIndex  = calcIndex(z, bemDepths)

[~, body1_hydroForceIndex] = min(abs(bemDepths-z));

end
