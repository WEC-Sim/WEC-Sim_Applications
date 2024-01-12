%close all

figure()
plot(output_orig.moorDyn.Lines.Time, output_orig.moorDyn.Lines.FairTen4)
hold on
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen4,'--')
legend('original','new')
title('FairTen4')

figure()
plot(output_orig.moorDyn.Lines.Time, output_orig.moorDyn.Lines.FairTen5)
hold on
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen5,'--')
legend('original','new')
title('FairTen5')

figure()
plot(output_orig.moorDyn.Lines.Time, output_orig.moorDyn.Lines.FairTen6)
hold on
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen6,'--')
legend('original','new')
title('FairTen6')
