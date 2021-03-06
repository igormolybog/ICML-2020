function [S, W, ret] = BO_synthetic (m, n, sparsity, n_values)

size = [m, n*n];
A = uniform_pattern(size, sparsity, n_values);


% plot_structure(A)

H = A.'*A;
[S,W] = get_structure(H);
ret = BayOpt(S, W);
end


%%

function ret = BayOpt(S, W)

n = sqrt(dims(S));

vars = getvars(n, 1);


objfun = @(x) fun_n(x, S, W, zeros(n,1), n);

results = bayesopt(objfun,vars);
ret = results.MinObjective;
end

%%

function bvars = getvars(n, R)
% generating variables for both LMI_P (bvars)
% and LMI_P_dB (svars)
    [rxball, rzball] = ballRvars(R);
    [phixball, phizball] = phivars(n);
    bvars = [rxball phixball rzball phizball];
end

%%

function [rx, rz] = ballRvars(R)
    rx = optimizableVariable('x1',[0,R]);
    rz = optimizableVariable('z1',[0,R]);
end

%%

function [phix, phiz] = phivars(n)

    x2 = optimizableVariable('x2',[0, pi]);
    x3 = optimizableVariable('x3',[0, pi]);
    x4 = optimizableVariable('x4',[0, pi]);
        x5 = optimizableVariable('x5',[0, pi]);
        x6 = optimizableVariable('x6',[0, pi]);
        x7 = optimizableVariable('x7',[0, pi]);
        x8 = optimizableVariable('x8',[0, pi]);
        x9 = optimizableVariable('x9',[0, pi]);
        x10 = optimizableVariable('x10',[0, pi]);
        x11 = optimizableVariable('x11',[0, pi]);
        x12 = optimizableVariable('x12',[0, pi]);
        x13 = optimizableVariable('x13',[0, pi]);
        x14 = optimizableVariable('x14',[0, pi]);
        x15 = optimizableVariable('x15',[0, pi]);
        x16 = optimizableVariable('x16',[0, pi]);
        x17 = optimizableVariable('x17',[0, pi]);
        x18 = optimizableVariable('x18',[0, pi]);
        x19 = optimizableVariable('x19',[0, pi]);
        x20 = optimizableVariable('x20',[0, pi]);
        x21 = optimizableVariable('x21',[0, pi]);
        x22 = optimizableVariable('x22',[0, pi]);
        x23 = optimizableVariable('x23',[0, pi]);
        x24 = optimizableVariable('x24',[0, pi]);
        x25 = optimizableVariable('x25',[0, pi]);
        x26 = optimizableVariable('x26',[0, pi]);
        x27 = optimizableVariable('x27',[0, pi]);
        x28 = optimizableVariable('x28',[0, pi]);
        x29 = optimizableVariable('x29',[0, pi]);
        x30 = optimizableVariable('x30',[0, 2*pi]);

        z2 = optimizableVariable('z2',[0, pi]);
        z3 = optimizableVariable('z3',[0, pi]);
        z4 = optimizableVariable('z4',[0, pi]);
        z5 = optimizableVariable('z5',[0, pi]);
        z6 = optimizableVariable('z6',[0, pi]);
        z7 = optimizableVariable('z7',[0, pi]);
        z8 = optimizableVariable('z8',[0, pi]);
        z9 = optimizableVariable('z9',[0, pi]);
        z10 = optimizableVariable('z10',[0, pi]);
        z11 = optimizableVariable('z11',[0, pi]);
        z12 = optimizableVariable('z12',[0, pi]);
        z13 = optimizableVariable('z13',[0, pi]);
        z14 = optimizableVariable('z14',[0, pi]);
        z15 = optimizableVariable('z15',[0, pi]);
        z16 = optimizableVariable('z16',[0, pi]);
        z17 = optimizableVariable('z17',[0, pi]);
        z18 = optimizableVariable('z18',[0, pi]);
        z19 = optimizableVariable('z19',[0, pi]);
        z20 = optimizableVariable('z20',[0, pi]);
        z21 = optimizableVariable('z21',[0, pi]);
        z22 = optimizableVariable('z22',[0, pi]);
        z23 = optimizableVariable('z23',[0, pi]);
        z24 = optimizableVariable('z24',[0, pi]);
        z25 = optimizableVariable('z25',[0, pi]);
        z26 = optimizableVariable('z26',[0, pi]);
        z27 = optimizableVariable('z27',[0, pi]);
        z28 = optimizableVariable('z28',[0, pi]);
        z29 = optimizableVariable('z29',[0, pi]);
        z30 = optimizableVariable('z30',[0, 2*pi]);
        
        phix = [x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30];
        phiz = [z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24,z25,z26,z27,z28,z29,z30];
        phix = phix(1:n-1);
        phiz = phiz(1:n-1);
end

%%

function result = fun_n(t, S, W, omega, n)
    
    rx = t.x1;
    rz = t.z1;
    phix = table2array(t(:, 2:n));
    phiz = table2array(t(:, n+2:2*n));
    
    xcart = npol2ncart(rx, phix).';
    zcart = npol2ncart(rz, phiz).';
    
    assert(dims(zcart) == dims(omega));
    
    result = LMI_P(xcart+omega, zcart+omega, S, W);
end
        

%%

function plot_structure(A)
% Display pattern of A

figure(1)

copy = sparse(size(A,1),size(A,2));
u = unique(A);
for i = 1:size(u,1)
    if all(u(i) == 0)
        continue
    end
    indexes_i = find(A==u(i));
    copy(indexes_i) = i;
end
cspy(copy, 'Marker', {'+', '*' 'h', 'p', 'o', '.', 'x', 's', 'd'},'MarkerSize', 16)
% titl = title('\bf A^{case9}_0');
% set(titl,'Interpreter','latex');
xlab = xlabel('');
set(gca,'FontSize',24)
set(gcf,'units','points','position',[10,10,600,500])
colorbar('off')
grid minor
% print('figs/A','-dpng')
end