function test_designmat()
% Multi-Test

testCase = [15]
    
EEGsim = simulate_test_case(testCase,'noise',0,'basis','box');
cfgDesign = [];

cfgDesign.coding = 'dummy';
cfgDesign.formula   = {'y~1',       'y~1+cat(conditionA)*continuousA', 'y~1+spl(splineA,5)+spl(splineB,5)+continuousA'};
cfgDesign.eventtype = {'stimulus1', 'stimulus2',                       'stimulus3'};




dc_designmat(EEGsim,cfgDesign);
%%
% test some bugs that crashed the function (e.g. #4)
cfgDesign.formula{1} = 'xyz ~1';
dc_designmat(EEGsim,cfgDesign);
cfgDesign.formula{1} = 'a ~1';
dc_designmat(EEGsim,cfgDesign);

%% test two events with same predictorName
for e = 1:length(EEGsim.event)
   EEGsim.event(e).evt = e; 
end
EEG2 = dc_designmat(EEGsim,'eventtype',{'stimulus1' 'stimulus2'},'formula',{'y~evt','y~evt'});
assert(size(EEG2.deconv.X,2) == 4);
%%
% We had a bug where specifying only the interaction without main effects
% jumbles things
EEG2 = dc_designmat(EEGsim,'eventtype','stimulus2','formula','y~conditionA:continuousA');

assert(strcmp(EEG2.deconv.variableNames{EEG2.deconv.cols2variableNames(end)},'conditionA:continuousA'))