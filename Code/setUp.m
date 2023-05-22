%Length of outbreak
maxtime = 731;

%Population of each country
populations = [64765000, 4904000, 1885000];

sigmaS = 83/491;
sigmaA = 17/491;
sigmaSprime = 0.113;
sigmaAprime = 0.0907;
deltaS = 0.2;
deltaA = 0.2/9;

h = 0.03077;
d = 0.0743;
g = 0.2;

betaS=0.5;
betaR=0.06;
betaV=0.0374;

alphaE=0.4;
alphaD=0.1;
alphaA=0.58;
alphaS=1;

kappaE=0;
kappaS=1;
kappaD=0.1;
kappaA=0.58;

%Transition Matrix
transMx = zeros(18,18);
transMx(3,2) = sigmaS;
transMx(4,2) = sigmaA;
transMx(5,3) = deltaS;
transMx(6,4) = deltaA;
transMx(7,3) = g;
transMx(7,4) = g;
transMx(7,5) = g;
transMx(7,6) = g;
transMx(7,9) = g;
transMx(9,3) = h;
transMx(9,5) = h;
transMx(10,9) = d;
transMx(11,13) = g;
transMx(11,14) = g;
transMx(16,15) = g;
transMx(11,16) = g;
transMx(11,17) = g;
transMx(13,8) = sigmaSprime;
transMx(14,8) = sigmaAprime;
transMx(13,12) = sigmaSprime;
transMx(14,12) = sigmaAprime;
transMx(15,13) = deltaS;
transMx(16,14) = deltaA;
transMx(17,13) = h;
transMx(17,15) = h;
transMx(18,17) = d;

%Vaccination mx recording max number of people who can be vaccinated in a
%given day in each country
totVacc = [10000000 2000000 1000000];
vaccRate = [308680, 26524, 9716];
initialVacc = [0 0 0];
vacc = zeros(18,3);
vacc(1,:) = vaccRate;
vacc(7,:) = vaccRate;
vaccPos = 11;
vaccStart = 313;
supDay = 28;
restric = [maxtime, maxtime, maxtime];

%infection matrix creation
infMx = zeros(18,18);
infMx(1,2) = betaS * alphaE;
infMx(1,3) = betaS * alphaS;
infMx(1,4) = betaS * alphaA;
infMx(1,5) = betaS * alphaD;
infMx(1,11) = betaS * kappaE;
infMx(1,12) = betaS * kappaS;
infMx(1,13) = betaS * kappaA;
infMx(1,14) = betaS * kappaD;

infMx(7,2) = betaR * alphaE;
infMx(7,3) = betaR * alphaS;
infMx(7,4) = betaR * alphaA;
infMx(7,5) = betaR * alphaD;
infMx(7,11) = betaR * kappaE;
infMx(7,12) = betaR * kappaS;
infMx(7,13) = betaR * kappaA;
infMx(7,14) = betaR * kappaD;

infMx(10,2) = betaV * alphaE;
infMx(10,3) = betaV * alphaS;
infMx(10,4) = betaV * alphaA;
infMx(10,5) = betaV * alphaD;
infMx(10,11) = betaV * kappaE;
infMx(10,12) = betaV * kappaS;
infMx(10,13) = betaV * kappaA;
infMx(10,14) = betaV * kappaD;

infMx = infMx .* permute([1 1 1], [1 3 2]);

restrictionFactor = 0.3;
travelFactor = 0.2;
facRestric = [200 20 10];
facRelax = [50 5 5];

%Information on number of countries and classes
countryCount = length(populations);
dim = size(infMx);
classCount = dim(1);

%Creating important matrix
corrector =  eye(countryCount) .* permute(ones(1,countryCount),[1 3 2]) + permute(eye(countryCount), [3 2 1]) .* ones(countryCount,1);

for i = 1:countryCount
    corrector(i,i,i) = 1;
end

corrector = permute(corrector, [4 2 3 1]);


%For travelRate resident of k travelling country j to i is position (:,k,j,i)
travelMx = zeros(1,countryCount,countryCount,countryCount);
%travel of resident GB to ROI and back
travelMx(:,1,1,2) = 10137;
travelMx(:,1,2,1) = travelMx(:,1,1,2);
%travel if resident GB to NI and back
travelMx(:,1,1,3) = 4027;
travelMx(:,1,3,1) = travelMx(:,1,1,3);
%travel of resident ROI to GB and back
travelMx(:,2,2,1) = 7123;
travelMx(:,2,1,2) = travelMx(:,2,2,1);
%travel of resident ROI to NI and back
travelMx(:,2,2,3) = 2055;
travelMx(:,2,3,2) = travelMx(:,2,2,3);
%travel of resident NI to ROI and back
travelMx(:,3,3,2) = 790;
travelMx(:,3,2,3) = travelMx(:,3,3,2);
%travel if resident NI to GB and back
travelMx(:,3,3,1) = 117;
travelMx(:,3,1,3) = travelMx(:,3,3,1);

%amount each class travels
travelFrac = [1 1 0.5 1 0 0 1 1 0 0 1 1 0.5 1 0 0 0 0]';
%full travel details
travelRate = travelMx .* travelFrac;


%Economy
touristGain = 122 * 8;
lockdownLoss = 0.5;

%START OF CODE
para = struct('beta',infMx,'betaRestric',restrictionFactor,'travelRestric',travelFactor,'trans',transMx,'travelRate',travelRate, 'vacc', vacc, 'totVacc', totVacc,'vaccPos', vaccPos,'vaccStart',vaccStart,'supplyDay', supDay,'facRestric',facRestric,'facRelax',facRelax,'restric',restric);

%Create the ICs
ICs = zeros(length(transMx),length(populations),length(populations));
for i = 1:length(populations)
    ICs(1,i,i) = populations(i) - 60000;
end
ICs(1,2,1) = 30000;
ICs(1,3,1) = 30000;
ICs(1,1,2) = 30000;
ICs(1,3,2) = 30000;
ICs(1,1,3) = 30000;
ICs(1,2,3) = 30000;

ICs(3,1,1) = 1;

ICs(1,1,1) = ICs(1,1,1) - 1;

%Color Matrix
color = [0.1569    0.2275    0.9882; 0.8902    0.2078    0.0706; 0.9490    0.5490    0.0275; 0.4196    0.0745    0.7412; 0         0         0; 0.0118    0.5608    0.1569;0.5000    0.5000    0.5000];