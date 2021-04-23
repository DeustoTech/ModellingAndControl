function [mu,sigma]=ShowTimeStampDistri(iTable)

    dtspan = diff(iTable.tspan);

    mu = mean(dtspan);
    sigma = std(dtspan) + 1e-4;

    histogram(diff(iTable.tspan))
    xlim([mu-sigma mu+sigma])
    title('\Delta Time Stamp Distribution')

end

