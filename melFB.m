%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computation of Mel Filterbank %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function melFilterBank = melFB(ncoefs, samplingRate, windowSize) 
    numberOfFilters=ncoefs;
    LowFreq=300;
    HighFreq=3500;
    mLowFreq= f2m(LowFreq);
    mHighFreq= f2m(HighFreq);
    mSpan=mHighFreq-mLowFreq;
    mSpanStep = mSpan/(numberOfFilters+1);
    mCenterFreq = [mLowFreq:mSpanStep:mHighFreq];
    kCenterFreq = m2f(mCenterFreq);

    melFilterBank = zeros(windowSize/2,numberOfFilters);
    for k=1:windowSize/2
	    currentFreq = (k-1)*samplingRate/windowSize;
	    for i=1:numberOfFilters
            if(currentFreq>kCenterFreq(i))
                if(currentFreq<kCenterFreq(i+1))
                    melFilterBank(k,i)=1-(kCenterFreq(i+1)-currentFreq)/(kCenterFreq(i+1)-kCenterFreq(i));
                else
				    if(currentFreq<kCenterFreq(i+2))
					    melFilterBank(k,i)=1-abs(kCenterFreq(i+1)-currentFreq)/(kCenterFreq(i+2)-kCenterFreq(i+1));
				    end
			    end
		    end
	    end
    end
end