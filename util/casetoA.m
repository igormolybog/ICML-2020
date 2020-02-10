
function [A_nodal, A_branch] = casetoA(current_case)
%%% mpc-list
% mpc = case9;
% mpc = case14;
% mpc = case30;
% mpc = case39;
% mpc = case57;
% mpc = case118;
% mpc = case300;
% mpc = case1354pegase;
% mpc = case2383wp; 
% mpc = case2736sp;
% mpc = case2737sop;
% mpc = case2746wop;
% mpc = case2746wp;
% mpc = case2869pegase;
% mpc =  case9241pegase;
mpc = current_case;

% THIS PART SIMPLIFIES THE STRUCTURE OF A:
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mpc.branch(:,3) = zeros(size(mpc.branch(:,3)));
% mpc.branch(:,4) = ones(size(mpc.branch(:,4)));
% mpc.branch(:,5) = zeros(size(mpc.branch(:,5)));
% mpc.branch(:,9) = zeros(size(mpc.branch(:,9)));
% mpc.branch(:,10) = zeros(size(mpc.branch(:,10)));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nb = size(mpc.bus, 1);

busL = mpc.bus(:,1);
busN = sparse(busL, ones(nb,1), (1:nb));

mpc.bus(:,1) = busN(mpc.bus(:,1));
mpc.branch = mpc.branch(find(mpc.branch(:,11)),:);
mpc.branch(:,1) = busN(mpc.branch(:,1));
mpc.branch(:,2) = busN(mpc.branch(:,2));
mpc.gen(:,1) = busN(mpc.gen(:,1));

nl = size(mpc.branch, 1);
ng = size(mpc.gen, 1);

[Y,Yf,Yt] = makeYbus(mpc);

Cf = sparse(1:nl, mpc.branch(:,1), 1, nl, nb);
Ct = sparse(1:nl, mpc.branch(:,2), 1, nl, nb);
Cg = sparse(1:ng, mpc.gen(:,1), 1, ng, nb);

ff = mpc.branch(:,1);
tt = mpc.branch(:,2);
zz = find((mpc.bus(:,3) == 0) & (mpc.bus(:,4) == 0) & (mpc.bus(:,2) == 1));

%%%%%

Yp = cell(nb,1);
Yq = cell(nb,1);
Yfp = cell(nl,1);
Yfq = cell(nl,1);
Ytp = cell(nl,1);
Ytq = cell(nl,1);
for ii = 1 : nb
    en     = sparse(nb,1);
    en(ii) = 1;    
    Yp{ii} = (Y'*en*en' + en*en'*Y)/2;
    Yq{ii} = (Y'*en*en' - en*en'*Y)/2i;
end

%%%%%

for ll = 1 : nl
    ef = sparse(nb,1);
    ef(ff(ll)) = 1;    
    et = sparse(nb,1);
    et(tt(ll)) = 1;
    el = sparse(nl,1);
    el(ll) = 1;    
    Yfp{ll} = (Yf'*el*ef' + ef*el'*Yf)/2;
    Yfq{ll} = (Yf'*el*ef' - ef*el'*Yf)/2i;    
    Ytp{ll} = (Yt'*el*et' + et*el'*Yt)/2;
    Ytq{ll} = (Yt'*el*et' - et*el'*Yt)/2i;
end

% pp  = find(mpc.bus(:,2) ~= 3);
% pp = pp(1:ceil(0.1*length(pp))); % 10% of the nodal active power injection
% qq  = find(mpc.bus(:,2) == 1);

vv  = 1:nb;
% pp  = [];
% qq  = [];
pp = 1:nb;
qq = 1:nb;

ppf = 1:nb;
qqf = 1:nb;
ppt = 1:nb;
qqt = 1:nb;


vvLen = length(vv);
ppLen = length(pp);
qqLen = length(qq);

ppfLen = length(ppf);
qqfLen = length(qqf);
pptLen = length(ppt);
qqtLen = length(qqt);

for idxM = 1:vvLen
        eeMat = sparse(vv(idxM),vv(idxM),1,nb,nb,1);
        vvCoeffM(:,idxM) = eeMat(:);
end

for idxM = 1:ppLen
    ppCoeffM(:,idxM) = Yp{pp(idxM)}(:);
end

for idxM = 1:qqLen
    qqCoeffM(:,idxM) = Yq{qq(idxM)}(:);
end

for idxM = 1:ppfLen
    ppfCoeffM(:,idxM) = Yfp{ppf(idxM)}(:);
end

for idxM = 1:qqfLen
    qqfCoeffM(:,idxM) = Yfq{qqf(idxM)}(:);
end

for idxM = 1:pptLen
    pptCoeffM(:,idxM) = Ytp{ppt(idxM)}(:);
end

for idxM = 1:qqtLen
    qqtCoeffM(:,idxM) = Ytq{qqt(idxM)}(:);
end

% allCoeffM = [vvCoeffM,ppCoeffM,qqCoeffM,ppfCoeffM,qqfCoeffM,pptCoeffM,qqtCoeffM];
nodalCoeffM = [vvCoeffM,ppCoeffM,qqCoeffM];
baranchCoeffM = [ppfCoeffM,qqfCoeffM,pptCoeffM,qqtCoeffM];

% A = [real(allCoeffM.'), -imag(allCoeffM.')];

A_nodal = sparse(nodalCoeffM.');
A_branch = sparse(baranchCoeffM.');

% A_full = [nodalCoeffM, baranchCoeffM].';
% H = A.'*A;
% S = ones(size(H)) - spones(H);
end

