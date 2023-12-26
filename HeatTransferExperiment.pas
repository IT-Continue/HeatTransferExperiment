program HeatTransferExperiment;

const
    mf = 100;

type
    vector = array[1..mf] of real;

var
    N: integer;
    T, alfa, beta: vector;
    ai, bi, ci, fi: real;
    lamda, ro, c, h, tau, R, T0, Th, t_end, time: real;
    f, g, input_file: text;
    name_of_experement, flag, input_file_name: string;

procedure experiment(name_of_experement: string; N: integer; t_end: real; R: real; lamda: real; ro: real; c: real; T0: real; Th: real);
begin
    h := R / (N - 1);
    tau := t_end / 100.0;

    for var i := 1 to N do
        T[i] := T0;

    time := 0;
    while time < t_end do
    begin
        time := time + tau;
        alfa[1] := 1.0;
        beta[1] := 0.0;

        for var i := 2 to N - 1 do
        begin
            ai := 0.5 * lamda * (2 * i + 1) / (sqr(h) * i);
            ci := 0.5 * lamda * (2 * i - 1) / (sqr(h) * i);
            bi := ai + ci + ro * c / tau;
            fi := -ro * c * T[i] / tau;
            alfa[i] := ai / (bi - ci * alfa[i - 1]);
            beta[i] := (ci * beta[i - 1] - fi) / (bi - ci * alfa[i - 1]);
        end;

        T[N] := Th;
        for var i := N - 1 downto 1 do
            T[i] := alfa[i] * T[i + 1] + beta[i];
    end;

    Assign(f, name_of_experement + '_res.txt');
    Rewrite(f);
    Writeln(f, 'name_of_experement = ', name_of_experement);
    Writeln(f, 'Радиус цилиндра N = ', N);
    Writeln(f, 'Радиус цилиндра t_end = ', t_end);
    Writeln(f, 'Радиус цилиндра R = ', R:6:4);
    Writeln(f, 'Радиус цилиндра lamda = ', lamda:6:4);
    Writeln(f, 'Радиус цилиндра ro = ', ro:6:4);
    Writeln(f, 'Радиус цилиндра c = ', c:6:4);
    Writeln(f, 'Радиус цилиндра T0 = ', T0:6:4);
    Writeln(f, 'Радиус цилиндра Th = ', Th:6:4);

    Close(f);

    Assign(g, name_of_experement + '_tempr.txt');
    Rewrite(g);
    for var i := 1 to N do
        Writeln(g, ' ', h * (i - 1):6:3, ' ', T[i]:8:5);
    Close(g);
end;

begin
    writeln('Введите режим работы программы текстом 1) test 2) keyboard 3) file');
    ReadLn(flag);
    if flag = 'test' then
    begin
      writeln('You choice is test');
      name_of_experement := 'test';
      N := 100;
      R := 0.1;
      lamda := 0.12;
      ro := 400;
      c := 500;
      T0 := 20;
      Th := 50;  
      t_end := 3600;
      experiment(name_of_experement, N, t_end, R, lamda, ro, c, T0, Th);
      end
    else if flag = 'keyboard' then
    begin
      writeln('You choice is keyboard');
      writeln('name_of_experement: ');
      ReadLn(name_of_experement);
      writeln('N: ');
      ReadLn(N); 
      writeln('R: ');
      ReadLn(R); 
      writeln('lamda: ');
      ReadLn(lamda); 
      writeln('ro: ');
      ReadLn(ro); 
      writeln('c: ');
      ReadLn(c); 
      writeln('T0: ');
      ReadLn(T0); 
      writeln('Th: ');
      ReadLn(Th); 
      writeln('t_end: ');
      ReadLn(t_end); 
      experiment(name_of_experement, N, t_end, R, lamda, ro, c, T0, Th);
      end
    else if flag = 'file' then
    begin
      writeln('You choice is file');
      writeln('input_file_name: ');
      ReadLn(input_file_name);
      Assign(input_file, input_file_name + '.txt');
      Reset(input_file);
      Read(input_file, name_of_experement);
      Read(input_file, N);
      Read(input_file, R);
      Read(input_file, lamda);
      Read(input_file, ro);
      Read(input_file, c);
      Read(input_file, T0);
      Read(input_file, Th);
      Read(input_file, t_end);
      input_file.close();
      experiment(name_of_experement, N, t_end, R, lamda, ro, c, T0, Th);
      end
    
end.