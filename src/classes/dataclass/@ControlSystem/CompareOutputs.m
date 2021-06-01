function error = CompareOutputs(ics1,ics2,ind)

    error = ics1.Outputs{ind(1)} - ics2.Outputs{ind(2)};
end

