syms s
syms t

%Abrir o arquivo dos dados
dados = readmatrix('Dados _Laplace_Senoidal.txt');

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
xl= 1./(s * L);
xl(xl(:) == Inf) = 0;%Tratando quando L = 0
%capacitância
C = double(dados(:,7));
%Admitancia do capacitor
xc =(s*C);

%Adimitancias Equivalentes
Y = R + xl + xc;
%Matriz diagonal das Adimitancias
Y = diag(Y);

Af = MIRed * Y;
Fn = Af * MIRed';




%Matriz das fontes de tensão Independentes
for c = 1:size(dados,1)
            if c == 1
             Vi = [laplace(double(dados(c,9))*sin(double(dados(c,13))*t+double(dados(c,10))))];
            else
             Vi = [Vi;laplace(double(dados(c,9))*sin(double(dados(c,13))*t+double(dados(c,10))))];
            end
                   
end

%Representação de condições iniciais do indutor
Vl = -s*double(dados(:,6));
%Representação de condições iniciais do capacitor
Vc = double(dados(:,8))/s;
Vc(Vc(:) == Inf) = 0;%Tratando quando I0 = 0
Vs = Vi+Vl+Vc;

%Matriz das fontes de Corrente
for c = 1:size(dados,1)
            if c == 1
             Js = [laplace(double(dados(c,11))*sin(double(dados(c,13))*t+double(dados(c,12))))];
            else
             Js = [Js;laplace(double(dados(c,11))*sin(double(dados(c,13))*t+double(dados(c,12))))];
            end
                   
end

Is =  Af*Vs - MIRed*Js;

%Tensão nos nós em laplace
Es = (inv(Fn))*Is;

%Tensão nos nós no tempo
Et = ilaplace(Es,s,t);

%Tensão nos ramos em laplace
V = MIRed'*Es;

%Tensão nos ramos no tempo
Vt = ilaplace(V,s,t);


%Corrente nos ramos laplace
J = Js + Y*V - Y*Vs;

%Corrente nos ramos no tempo
j = ilaplace(J);

%Plotar gráficos das tensões de Nó
figure(1),clf
fplot(Et,[0,100])
title('Tensão nos Nós')
legend(int2str((1:size(Et,1))'));
xlabel('tempo (s)')
ylabel('Tensão (V)')


%Plotar gráfico das tensões nos Ramos
figure(2),clf
fplot(Vt,[0,100])
title('Tensão nos Ramos')
legend(int2str(dados(:,1)));
xlabel('tempo (s)')
ylabel('Tensão (V)')

%Plotar gráfico das correntes nos Ramos
figure(3),clf
fplot(j,[0,100])
title('Corrente nos Ramos')
legend(int2str(dados(:,1)));
xlabel('tempo (s)')
ylabel('Corrente (A)')
