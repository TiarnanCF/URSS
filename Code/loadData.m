example = matfile(strcat('residentsAveBase',string(thisCount),'.mat'));
residentsAveBase = example.residentsAveBase;
example = matfile(strcat('residentsAve1',string(thisCount),'.mat'));
residentsAve1 = example.residentsAve1;
example = matfile(strcat('residentsAve2',string(thisCount),'.mat'));
residentsAve2 = example.residentsAve2;
example = matfile(strcat('residentsAve3',string(thisCount),'.mat'));
residentsAve3 = example.residentsAve3;
example = matfile(strcat('residentsAve4',string(thisCount),'.mat'));
residentsAve4 = example.residentsAve4;
example = matfile(strcat('residentsAve5',string(thisCount),'.mat'));
residentsAve5 = example.residentsAve5;
example = matfile(strcat('residentsAve6',string(thisCount),'.mat'));
residentsAve6 = example.residentsAve6;

example = matfile(strcat('lockdownAveBase',string(thisCount),'.mat'));
lockdownAveBase = example.lockdownAveBase;
example = matfile(strcat('lockdownAve1',string(thisCount),'.mat'));
lockdownAve1 = example.lockdownAve1;
example = matfile(strcat('lockdownAve2',string(thisCount),'.mat'));
lockdownAve2 = example.lockdownAve2;
example = matfile(strcat('lockdownAve3',string(thisCount),'.mat'));
lockdownAve3 = example.lockdownAve3;
example = matfile(strcat('lockdownAve4',string(thisCount),'.mat'));
lockdownAve4 = example.lockdownAve4;
example = matfile(strcat('lockdownAve5',string(thisCount),'.mat'));
lockdownAve5 = example.lockdownAve5;
example = matfile(strcat('lockdownAve6',string(thisCount),'.mat'));
lockdownAve6 = example.lockdownAve6;

example = matfile(strcat('visitorsBase',string(thisCount),'.mat'));
visitorsBase = example.visitorsBase;
example = matfile(strcat('visitors1',string(thisCount),'.mat'));
visitors1 = example.visitors1;
example = matfile(strcat('visitors2',string(thisCount),'.mat'));
visitors2 = example.visitors2;
example = matfile(strcat('visitors3',string(thisCount),'.mat'));
visitors3 = example.visitors3;
example = matfile(strcat('visitors4',string(thisCount),'.mat'));
visitors4 = example.visitors4;
example = matfile(strcat('visitors5',string(thisCount),'.mat'));
visitors5 = example.visitors5;
example = matfile(strcat('visitors6',string(thisCount),'.mat'));
visitors6 = example.visitors6;

example = matfile(strcat('vaccLeft1',string(thisCount),'.mat'));
vaccLeft1 = example.vaccLeft1;
example = matfile(strcat('vaccLeft2',string(thisCount),'.mat'));
vaccLeft2 = example.vaccLeft2;
example = matfile(strcat('vaccLeft3',string(thisCount),'.mat'));
vaccLeft3 = example.vaccLeft3;
example = matfile(strcat('vaccLeft4',string(thisCount),'.mat'));
vaccLeft4 = example.vaccLeft4;
example = matfile(strcat('vaccLeft6',string(thisCount),'.mat'));
vaccLeft6 = example.vaccLeft6;

example = matfile(strcat('vaccSupply',string(thisCount),'.mat'));
vaccSupply = example.vaccSupply;

numIts = size(visitors4,3);