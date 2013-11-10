%% Programmierubung 2: Quadratische Optimierungsprobleme
%
% Seien $m\in\rm I\!N$, $A\in\rm I\!R^{m\times 2}$; $b\in\rm I\!R^m$. Wir betrachten das zweidimensionale quadratische Optimierungs-
% problem mit linearen Ungleichungsnebenbedingungen
% $\min_{x\in\rm I\!R^2}{\frac{1}{2}x^Tx+_1+x_2}\space s.t.\space Ax\le b$, wobei
% $A_{i,1}=-cos(\frac{\pi}{2} \frac{i-1}{m-1})$
% $A_{i,2}=-sin(\frac{\pi}{2} \frac{i-1}{m-1})$ fuer $i=1,\dots, m$
% und b=\beta e, wo e Einheitsvektor ist.
%
%% function Aufgabe_2()
%
function Uebung2()

    TeilAufgabe1();
    [x,y]=TeilAufgabe2();
    TeilAufgabe3();
    TeilAufgabe4(x,y);
    
end
%% Teilaufgabe 1
%
% Visualisierung des zulaessigen Gebiets fuer m = 10 und $\beta\in\{-1,0,1\}$.
%
function TeilAufgabe1()
% setze a und B fuer Ax<=b
m=2;
beta=[-1 0 1];
A(m,2)=0;   
b(m)=0;
for i=1:1:m
    A(i,1)=-cos(pi/2*(i-1)/(m-1));
    A(i,2)=-sin(pi/2*(i-1)/(m-1));
    b(i)=beta(1)*1;
end
% grid size
%[X, Y] = meshgrid((-50:1:50), (-50:1:50));

%figure, hold on
%both=1;
%for i=1:1:m
    %ineq = A(i,1)*X+A(i,1)*Y<=b(i);
    %contourf(i*ineq, [i , i], 'b')  %# Fill area for inequation
    %both=both&ineq;
%end

end
%% Teilaufgabe 2
%
% Berechnen der Loesung des gegebenes Problems fuer $m\in\{10, 100, 1000\}$ und $\beta\in\{-2,-1,0,1,2\}$.
% Dafuer wird function {\bf quadprog} benutzt mit der active-set-Variante.
% Diese FUnktion loest Optimierungsprobleme mit der quadratischen
% Zielfunktionen.
%
function[x_out, y_out] = TeilAufgabe2()
% gebe Extremstelle fuer m=10 und beta=-1, 0, 1 fuer die Aufgabe 4 zurueck
m=[10 100 1000];
beta=[-2 -1 0 1 2];
% Zielfunktion $\min{f(x)}=\min{1/2}x^THx+f^Tx$
H=[1 0;0 1];
f=[1;1];
% Ausgabe fuer Teilaufgabe 4 (Loesung fuer m=10 und beta= -1, 0, 1)
x_out=0;
y_out=0;
for m_i=1:1:3 
    A(m(m_i),2)=0; 
    A(m(m_i),2)=0;   
    b(m(m_i))=0;
    % berechne Matrix A
    for i=1:1:m(m_i)
        A(i,1)=-cos(pi/2*(i-1)/(m(m_i)-1));
        A(i,2)=-sin(pi/2*(i-1)/(m(m_i)-1));
    end
    
    for beta_j=1:1:5
        % berechne Vektor b
        for i=1:1:m(m_i)
            b(i)=beta(beta_j)*1;
        end
        % loese das Problem
        opts = optimoptions('quadprog','Algorithm','active-set','Display','off');
        [x,fval,~,~,~] = quadprog(H,f,A,b,[],[],[],[],[],opts);
        
        % speichere Ergebnis bei m=10 fuer Teilaufgabe 4
        if m(m_i)==10 && (2<=beta_j) && (beta_j<=4) 
            x_out(beta_j-1)=x(1);
            y_out(beta_j-1)=x(2);
        end
        solution=sprintf('m = %i    beta = %d       x=(%d,%d)           optimal value = %d', m(m_i), beta(beta_j), x(1), x(2), fval);
        disp(solution);
    end
    disp('  ');
end

end
%% Teilaufgabe 3
%
% Loesung des Problem mit m=1000 und $\beta\in\{0, 10^{-12}\}$,
%
function TeilAufgabe3()

% m=1000 and beta=0
m=1000;
beta=0;
% Zielfunktion $\min{f(x)}=\min{1/2}x^THx+f^Tx$
H=[1 0;0 1];
f=[1;1];

A(m,2)=0; 
A(m,2)=0;   
b(m)=0;

for i=1:1:m
    A(i,1)=-cos(pi/2*(i-1)/(m-1));
    A(i,2)=-sin(pi/2*(i-1)/(m-1));
    b(i)=beta*1;
end

opts = optimoptions('quadprog','Algorithm','active-set','Display','off');
[x,fval,~,~,~] = quadprog(H,f,A,b,[],[],[],[],[],opts);

solution=sprintf('m = %i    beta = %d       x=(%d,%d)       optimal value = %d', m, beta, x(1), x(2), fval);
disp(solution);

% m=1000 and $beta=10^{-12}$
m=1000;
beta=10^(-12);
% Objective $\min{f(x)}=\min{1/2}x^THx+f^Tx$
H=[1 0;0 1];
f=[1;1];
% Matrix A bleibt gleich
b(m)=0;
for i=1:1:m
    b(i)=beta*1;
end

opts = optimoptions('quadprog','Algorithm','active-set','Display','off');
[x,fval,~,~,~] = quadprog(H,f,A,b,[],[],[],[],[],opts);

solution=sprintf('m = %i    beta = %d       x=(%d,%d)       optimal value = %d', m, beta, x(1), x(2), fval);
disp(solution);

end
%% Teilaufgabe4
%
% finden aktive Ungleichungen und formuliere neus Gleichungsbeschraenktes
% Problem
%
function TeilAufgabe4(x, y)

m=10;
beta=[-1 0 1];

% matrix A
A(m,2)=0; 
A(m,2)=0;   
b(m)=0;
for i=1:1:m
    A(i,1)=-cos(pi/2*(i-1)/(m-1));
    A(i,2)=-sin(pi/2*(i-1)/(m-1));
end

for j=1:1:3 % fuer jedes beta
    disp(sprintf('beta=%i', beta(j)));
    for i=1:1:m
        b(i)=beta(j)*1;
    end

    % Laut der Komplementaritaetsbedingung gilt es fuer ein lokales Minimum
    % $x^{*}$,dass die Nebenbedingungen in Form der Ungleichungen im Punkt $x^{*}$
    % aktiv sind. Anhand der Loesungen aus der Teilaufgabe2 bestimmen wir somit
    % die Aktive-Indizes und formulieren neues Gleichungsbeschraenktes
    % Problem
    newA(1,2)=0;
    newB(1)=0;

    for i=1:1:m
        if (A(i,1)*x(j)+A(i,1)*y(j)==b(i)) % wenn die Ungleichung aktiv ist
            if (min(size(newA))== 1) 
                newA=[A(i,1) A(i,2)]; % wenn das die erste Zeile des neuen Gleichungssystem ist
                newB=b(i);
            else
                newA=[newA; A(i,1) A(i,2)];
                newB=[newB;  b(i)];
            end
            row = sprintf('%d *x_1+%d*x_2= %d',A(i,1),A(i,2), b(i));
            disp(row);
        else
        % wir betrachten nur aktive Ungleichungen 
        end
    end % end for i
    
    
    % berechne Zweinormkondition fuer neue Matrix newA
    cond_newA=cond(newA,2);
    cond_newB=cond(newB,2);

    solution=sprintf('Zweinormkondition des neuen Sytems Kondition der Matrix A %d und des Vektors B %d', cond_newA, cond_newB);
    disp(solution);    
end % for j

end
