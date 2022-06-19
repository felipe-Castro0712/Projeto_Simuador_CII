clear

%Abrir o arquivo dos dados
dados = readmatrix('Dados_Tempo.txt');

%Verificar quantos nós tem o circuito
if max(dados(:,2)) > max(dados(:,3))
    nos = max(dados(:,2));
else
    nos = max(dados(:,3));
end

%Criação da matriz incidencia do tamanho necessário para o circuito
MI = eye(nos,size(dados,1));

%Verificando os valores de saida e entrada dos nós
for d = 1:nos

    for c = 1:size(dados,1)
        if  dados(c,2) == d
            MI(d,c) = 1;
        else
            if dados(c,3) == d
                MI(d,c) = -1;
            else
                MI(d,c) = 0;
            end
        end
        
    end
end

%Criação da Matriz de Incidencia Reduzida
MIRed = MI(1:size(MI,1)-1,:);

%Matriz de Adimitancias

%resistor
R = double(dados(:, 4));
%Adimitancia do Resistor
R = 1./R;
R(R(:) == Inf) = 0;%Tratando quando R = 0
%indutor
L = double(dados(:,5));
%Adimitancia do indutor
xl = 1./(L*1i);
xl(xl(:) == Inf) = 0;%Tratando quando L = 0
%capacitância
C = double(dados(:,6));
%Admitancia do capacitor
xc =1./(C*-1i);
xc(xc(:) == Inf) = 0;%Tratando quando c = 0


%Adimitancias Equivalentes
Y = R + xl + xc;
%Matriz diagonal das Adimitancias
Y = diag(Y);


%Criação da matriz das fontes de tensão independentes do tamanho necessário para o circuito
Vs = eye(size(dados,1),1);

%Matriz das fontes de tensão Independentes
for c = 1:size(dados,1)
            Vs(c,1) = double(dados(c,7))*cosd(double(dados(c,8)))+double(dados(c,7))*sind(double(dados(c,8)))*1i;        
end




%Matriz das fontes de correntes independentes
%Criação da matriz das fontes de tensão independentes do tamanho necessário para o circuito
Js = eye(size(dados,1),1);

%Matriz das fontes de tensão Independentes
for c = 1:size(dados,1)
            Js(c,1) = double(dados(c,9))*cosd(double(dados(c,10)))+double(dados(c,9))*sind(double(dados(c,10)))*1i;        
end



%Matriz Yn
Yn = MIRed*Y;
Yn = Yn*MIRed';


%Matriz Is
Isa = MIRed * Y * Vs;
Isb = MIRed * Js;
Is = Isa - Isb;

%Matriz Tensão nos nós
E = inv(Yn)*Is;


%Matriz Tensão nos ramos
V = MIRed'*E;

%Matriz Corrente nos ramos
J = Js + Y*V - Y*Vs;

%Plotar Diagrama Vetorial


figure(1),clf
color = ['r','b','g','c','m','y','k','w'];
for c = 1:size(E,1)
    
    %plot([0,real(E(c))],[0,imag(E(c))])
    compass(real(E(c)),imag(E(c)),color(c))
    hold on
    if c == 1
    
        a = [int2str(c)];
    else
        a = [a;int2str(c)];
    end
end
title('Diagrama Fasorial das Tensões nos Nós')
legend(a);


%Diagrama Fasorial das Tensões nos Ramos
figure(2),clf

color = ['r','b','g','c','m','y','k','w'];
for c = 1:size(V,1)
    compass(real(V(c)),imag(V(c)),color(c))
    hold on
    if c == 1
    
        a = [int2str(c)];
    else
        a = [a;int2str(c)];
    end
end
title('Diagrama Fasorial das Tensões nos Ramos')
legend(a);



figure(3),clf

color = ['r','b','g','c','m','y','k','w'];
for c = 1:size(J,1)
    compass(real(J(c)),imag(J(c)),color(c))
    hold on
    if c == 1
    
        a = [int2str(c)];
    else
        a = [a;int2str(c)];
    end
end
title('Diagrama Fasorial das Correntes nos Ramos')
legend(a);