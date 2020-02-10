% Initial setup
addpath('../util/');

caseN = 9;


%%
% Load A
A = casetoA(caseN);

% Display pattern of A

copy = sparse(size(A,1),size(A,2));
u = unique(A);
for i = 1:size(u,1)
    if all(u(i) == 0)
        continue
    end
    indexes_i = find(A==u(i));
    copy(indexes_i) = i;
end
cspy(copy, 'Marker', {'+', 'o', '.', 'x', 's', 'd'},'MarkerSize', 16)
% titl = title('\bf A^{case9}_0');
% set(titl,'Interpreter','latex');
xlab = xlabel('');
set(gca,'FontSize',24)
set(gcf,'units','points','position',[10,10,600,500])
colorbar('off')
grid minor
print('../Section 2/A','-dpng')

%%
% Load H
A = casetoA(caseN);
H = A.'*A;

% Display sparsity of H

copy = sparse(size(H,1),size(H,2));
u = unique(H);
for i = 1:size(u,1)
    if all(u(i) == 0)
        continue
    end
    indexes_i = find(H==u(i));
    copy(indexes_i) = i;
end
cspy(copy, 'Marker', {'+', '*' 'h', 'p', 'o', '.', 'x', 's', 'd'}, 'MarkerSize', 16)
% titl = title('case9');
% set(titl,'Interpreter','latex');
xlab = xlabel('');
set(gca,'FontSize',24)
set(gcf,'units','points','position',[10,10,600,600])
colorbar('off')
grid minor
print('H','-dpng')
% print the number of unique values
max(max(copy))-1    








