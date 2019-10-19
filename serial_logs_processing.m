%------------------------------------
% Serial Log processessing
%------------------------------------
% Romain Jacob, September 2018
%------------------------------------

clear all;
close all;
clc;

format long;

% Choose the desired parsing
% 1 : Native Crystal
% 2 : GMW Crystal
% 6 : GMW Sleeping Beauty
% 7 : Native and GMW LWB
result_to_parse = 2;
paper_test = 0; % Set to 1 for re-running the analysis of the Baloo paper tests.

% Define the type of experiment to post-process
if (result_to_parse == 1)
%     experiment= '/Crystal/Native/paper/';
    experiment= '/Crystal/Native/thesis/';
    tests= {'U0', 'U1', 'U20'};
elseif (result_to_parse == 2)
    experiment= '/Crystal/GMW-Sky/thesis/';
%     experiment= '/Crystal/GMW-Sky/paper/';
%     experiment= '/Crystal/GMW-CC430/';
    tests= {'U0', 'U1', 'U20'};
elseif (result_to_parse == 6)
%     experiment= '/SleepingBeauty/GMW-CC430/';
    experiment= '/SleepingBeauty/GMW-Sky/';
    tests= {'U3','U6','U12'};
elseif (result_to_parse == 7)
%     experiment= '/LWB/Native/';
%     experiment= '/LWB/GMW-Sky/';
    experiment= '/LWB/GMW-CC430/';
    tests= {'IPI4','IPI30'};
end
    
% List of source node IDs
if paper_test
    nodes = [002 003 004 006 007 008 010 011 013 014 015 016 017 018 019 020 022 023 024 025 026 027 028 032 033];
else % list of nodes for the tests re-run for the thesis 
    nodes = [002 003 004 006 008 010 011 013 015 016 017 018 019 020 022 023 024 025 026 027 028 032 033];
end

% Define path to FlockLab logs
[result, path] = unix('pwd');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following code should not be changed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%s\t%s\n', 'Experiment :', experiment(1:end));

for i=1:numel(tests)
    test_path = strcat(path, experiment, tests{i});

    % Display network configuration
    fprintf('\n%s\n', '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    fprintf('%s\t%s\n', 'Case :', tests{i}(1:end));

    % Load serial data
    clear csvfile_serial csvsedfile_serial matfile_serial;
    
    csvfile_serial = [test_path '/serial.csv'];
    csvsedfile_serial = [test_path '/serialsed.csv'];
    csvfile_serial_snd = [test_path '/serialsedsnd.csv'];
    csvfile_serial_rcv = [test_path '/serialsedrcv.csv'];
    matfile_serial = [test_path '/serial.mat'];
    matfile_serial_snd = [test_path '/serialsnd.mat'];
    matfile_serial_rcv = [test_path '/serialrcv.mat'];
    
    if (~exist(csvsedfile_serial, 'file'))   
        if (result_to_parse == 1)
            [~,~] = unix(['sed -e "/,E/!d" -e "s/[^:]*:\(.*\):.*/\1/" ' csvfile_serial ' > ' csvsedfile_serial]);
        elseif (result_to_parse == 7)            
            [~,~] = unix(['sed -e "/DC/!d" -e "s/[^,]*,\([0-9]*\)[^:]*: \(.*\)/\1,\2/" "/~/d" ' csvfile_serial ' > ' csvsedfile_serial]);
        else               
            [~,~] = unix(['sed -e "/DC/!d" -e "s/[^,]*,\([0-9]*\)[^:]*:[^:]*:\(.*\)/\1,\2/" "/~/d" ' csvfile_serial ' > ' csvsedfile_serial]);
        end
    end
    
    if (~exist(csvfile_serial_rcv, 'file'))   
        if (result_to_parse == 1)
            [~,~] = unix(['sed -e "/[^,]*,1,1,r,T.*0$/!d" -e "s/[^,]*,1,1,r,T [0-9]*:[0-9]* 2 \([0-9]*\) \([0-9]*\).*/\1,\2/" ' csvfile_serial ' > ' csvfile_serial_rcv]);
            [~,~] = unix(['sed -e "/Q/!d" -e "s/[^,]*,\([0-9]*\),[0-9]*,r,Q [0-9]*:[0-9]* \([0-9]*\).*/\1,\2/" ' csvfile_serial ' > ' csvfile_serial_snd]);
        elseif (result_to_parse == 6)                
            [~,~] = unix(['sed -e "/PRR:/!d" -e "s/[^P]*PRR: \([0-9]*\).*/\1/" ' csvfile_serial ' > ' csvfile_serial_rcv]);
            [~,~] = unix(['sed -e "/ S:/!d" -e "s/[^:]*:[^:]*: \([0-9]*\) \([0-9]*\) \([0-9]*\)/\3,\2,\1/" ' csvfile_serial ' > ' csvfile_serial_snd]);
        elseif (result_to_parse == 7)                
            [~,~] = unix(['sed -e "/FSR:/!d" -e "/[^,],1,/!d" -e "s/[^R]*R: \([0-9]*\).*/\1/" ' csvfile_serial ' > ' csvfile_serial_rcv]);
        else                
            [~,~] = unix(['sed -e "/ R:/!d" -e "s/[^:]*:[^:]*: \([0-9]*\) \([0-9]*\)/\2,\1/" ' csvfile_serial ' > ' csvfile_serial_rcv]);
            [~,~] = unix(['sed -e "/ S:/!d" -e "s/[^:]*:[^:]*: \([0-9]*\) \([0-9]*\)/\2,\1/" ' csvfile_serial ' > ' csvfile_serial_snd]);
        end
    end
    
%     sed -e '/R:/!d' -e 's/[^:]*: \([0-9]*\) \([0-9]*\) \([0-9]*\)/\3,\2,\1/' serial.csv

    if (~exist(matfile_serial, 'file'))
        g = csvread(csvsedfile_serial);
        save(matfile_serial, 'g');
    else
        load(matfile_serial);
    end
    
    nb_pkt_sent_total = 0;
    nb_pkt_sent_unique = 0;
    PRR(1) = NaN;
    SND = NaN;

    if (~strcmp(tests{i}, 'U0'))
        if (result_to_parse ~= 7) 
            if (~exist(matfile_serial_snd, 'file'))
                SND = csvread(csvfile_serial_snd);
                save(matfile_serial_snd, 'SND');
            else
                load(matfile_serial_snd);
            end
        end

        if (~exist(matfile_serial_rcv, 'file'))
            RCVD = csvread(csvfile_serial_rcv);
            save(matfile_serial_rcv, 'RCVD');
        else
            load(matfile_serial_rcv);
        end
    
        if (result_to_parse == 6)
            nb_pkt_sent_total(i) = size(SND,1);
            SND=unique(SND,'rows');
            nb_pkt_sent_unique(i) = size(SND,1);
            PRR(i) = RCVD(end);
            fprintf('PRR: %f%%\n', PRR(i)/100);
        elseif (result_to_parse ~= 7)
            nb_pkt_sent_total(i) = size(SND,1);
            SND=unique(SND,'rows');
            RCVD=unique(RCVD,'rows');
            nb_pkt_sent_unique(i) = size(SND,1);
            PRR(i) = size(RCVD,1) / size(SND,1)*100;
            fprintf('PRR: %f%%\n', PRR(i));
            lost_packets = setdiff(SND,RCVD,'rows');
        else
            PRR(i) = RCVD(end);
            fprintf('PRR: %f%%\n', PRR(i)/100);
        end
        
    end
    
    if (result_to_parse == 1)
        fprintf('Average RF DC: %f%%\n', mean(g));
        fprintf('Scaled (without sink): %f%%\n', mean(g)/5);
        fprintf('Unique packets sent by source nodes: \t%d\n', sum(nb_pkt_sent_unique));
        fprintf('Total packets sent by source nodes: \t%d\n', sum(nb_pkt_sent_total));
        
    else
        for node_index=1:size(nodes,2)
            test_result_all = g( g(:,1) == nodes(node_index) , 2);
            test_result(node_index) = test_result_all(end);
        end
        if (result_to_parse ~= 7)
            fprintf('Unique packets sent by source nodes: \t%d\n', sum(nb_pkt_sent_unique));
            fprintf('Total packets sent by source nodes: \t%d\n', sum(nb_pkt_sent_total));
        end
        if (result_to_parse == 2 || result_to_parse == 3 )
            fprintf('Total averaged DC (without sink): \t%f%%\n', mean(test_result)/5);
        else
            fprintf('Total averaged DC (without sink): \t%f%%\n', mean(test_result));            
        end
    end
    
end