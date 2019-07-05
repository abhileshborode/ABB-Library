%% Evaluation Script
function Eval_Script(functionName,N)
if ~exist('functionName','var')
    functionName = 'all';
end

load proj2EvalCases.mat;

fun_count = 1;
for i=1:length(test_case)
    
    fun = test_case(i);
    
    if ~strcmp(functionName, fun.Function_Name) && ~strcmp(functionName,'all')
        continue;
    end
    
    if exist('N','var') && (fun_count == N)
        fun_count = fun_count+1;
    elseif exist('N','var') && (fun_count > N)
        break;
    elseif exist('N','var')
        fun_count = fun_count+1;
        continue;
    end
    
    try
        fileID = fopen('tmp.m','w+');
    catch
        fileID = fopen('tmp.m','w+');
    end
    fprintf(fileID,'function [output] = tmp(inputStruct)\n\n');
    
    fprintf(fileID,'score = @(val) 1-1/(1+exp(-(val-.05)*100));\n');
    
    fprintf(fileID,'output = struct(''error_text'',{},''help_score'',0,''effort'',0,''output_error'',[],''timing_performance'',[]);\n\n');
    fprintf(fileID,'output(1).percentError = -1;\n');
    
    fprintf(fileID,'if ~exist(''%s.m'',''file'');\n',fun.Function_Name);
    fprintf(fileID,'\toutput.error_text{end+1} = ''Function %s cannot be found.'';\n',fun.Function_Name);
    fprintf(fileID,'\treturn;\n');
    fprintf(fileID,'end\n');
    
    
    fprintf(fileID,'[~,name,~] = fileparts(which(''%s.m''));\n', fun.Function_Name);
    fprintf(fileID,'caseMatch = strcmp(name,''%s'');\n',fun.Function_Name);
    fprintf(fileID,'if ~caseMatch\n\toutput.error_text{end+1} = [''Case sensitive match for %s does not exist, you used '' name];\n',fun.Function_Name);
    fprintf(fileID,'\treturn;\n');
    fprintf(fileID,'end\n');
    
    
    fprintf(fileID,'T = evalc(''help %s.m'');\n\n',fun.Function_Name);
    fprintf(fileID,['output(1).help_score = 0;\nif strcmp(''No help found for %s.m.'',strtrim(deblank(T)));\n',...
        '\toutput.error_text{end+1} = ''No helpfile Provided.'';\n',...
        'else\n',...
        '\tif numel(T) < %i\n',...
        '\t\toutput.error_text{end+1} = ''Help File Data Insufficient.'';\n',...
        '\t\toutput.help_score = score(max([%i-numel(T),0])/5000);\n',...
        '\telse\n',...
        '\t\toutput.help_score = 1;\n',...
        '\tend\n',...
        'end\n\n'],fun.Function_Name,fun.Help_Length,fun.Help_Length);
    
    fprintf(fileID,'fileID = fopen(''%s.m'');\n',fun.Function_Name);
    fprintf(fileID,'numChar = numel(fread(fileID,''char''))-numel(T);\n');
    fprintf(fileID,'fclose(fileID);\n');
    fprintf(fileID,'output.effort = numChar > %i;\n\n\n',fun.Function_Length);
    
    fprintf(fileID,'try\n');
    fprintf(fileID,'     [');
    for i=1:fun.Number_Outputs
        if( i < fun.Number_Outputs )
            fprintf(fileID,'O%i, ',i);
        else
            fprintf(fileID,'O%i',i);
        end
    end
    fprintf(fileID,'] = %s(',fun.Function_Name);
    
    for i=1:fun.Number_Inputs
        fprintf(fileID,'inputStruct.Inputs.I%i',i);
        if( i < fun.Number_Inputs)
            fprintf(fileID,', ',i);
        else
            fprintf(fileID,');',i);
        end
    end
    
    fprintf(fileID,'\n\n\toutput.percentError = zeros(%i,1);\n',fun.Number_Outputs);
    fprintf(fileID,'\n\n\tuseAlt = false;\n');
    for i=1:fun.Number_Outputs
        fprintf(fileID,'\tif all(size(O%i)==size(inputStruct.Outputs.O%i))\n',i,i);
        fprintf(fileID,'\t\tif norm(inputStruct.Outputs.O%i) >0\n',i);
        if i==1
            fprintf(fileID,'\t\t\toutput.percentError(%i) = 100*norm(O%i-inputStruct.Outputs.O%i)/norm(inputStruct.Outputs.O%i);\n',i,i,i,i);
            fprintf(fileID,'\t\t\tif isfield(inputStruct.Outputs,''O%iAlt'')\n',i);
            fprintf(fileID,'\t\t\t\te_alt = 100*norm(O%i-inputStruct.Outputs.O%iAlt)/norm(inputStruct.Outputs.O%iAlt);\n',i,i,i);
            fprintf(fileID,'\t\t\t\tif all(e_alt<output.percentError(%i))\n',i);
            fprintf(fileID,'\t\t\t\t\toutput.percentError(%i) = e_alt;\n',i);
            fprintf(fileID,'\t\t\t\t\tuseAlt = true;\n');
            fprintf(fileID,'\t\t\t\tend\n');
            fprintf(fileID,'\t\t\tend\n');
            fprintf(fileID,'\t\telse\n');
            fprintf(fileID,'\t\t\toutput.percentError(%i) = 100*norm(O%i-inputStruct.Outputs.O%i);\n',i,i,i);
            fprintf(fileID,'\t\t\tif isfield(inputStruct.Outputs,''O%iAlt'')\n',i);
            fprintf(fileID,'\t\t\t\te_alt = 100*norm(O%i-inputStruct.Outputs.O%iAlt)/norm(inputStruct.Outputs.O%iAlt);\n',i,i,i);
            fprintf(fileID,'\t\t\t\tif all(e_alt<output.percentError(%i))\n',i);
            fprintf(fileID,'\t\t\t\t\toutput.percentError(%i) = e_alt;\n',i);
            fprintf(fileID,'\t\t\t\t\tuseAlt = true;\n');
            fprintf(fileID,'\t\t\t\tend\n');
            fprintf(fileID,'\t\t\tend\n');
            fprintf(fileID,'\t\tend\n');
        else
            fprintf(fileID,'\t\t\tif ~useAlt\n');
            fprintf(fileID,'\t\t\t\toutput.percentError(%i) = 100*norm(O%i-inputStruct.Outputs.O%i)/norm(inputStruct.Outputs.O%i);\n',i,i,i,i);
            fprintf(fileID,'\t\t\telse\n');
            fprintf(fileID,'\t\t\t\toutput.percentError(%i) = 100*norm(O%i-inputStruct.Outputs.O%iAlt)/norm(inputStruct.Outputs.O%iAlt);\n',i,i,i,i);
            fprintf(fileID,'\t\t\tend\n');
            fprintf(fileID,'\t\telse\n');
            fprintf(fileID,'\t\t\tif ~useAlt\n');
            fprintf(fileID,'\t\t\t\toutput.percentError(%i) = 100*norm(O%i-inputStruct.Outputs.O%i);\n',i,i,i);
            fprintf(fileID,'\t\t\telse\n');
            fprintf(fileID,'\t\t\t\toutput.percentError(%i) = 100*norm(O%i-inputStruct.Outputs.O%iAlt);\n',i,i,i);
            fprintf(fileID,'\t\t\tend\n');
            fprintf(fileID,'\t\tend\n');
        end
        fprintf(fileID,'\telse\n\t\toutput.percentError(%i) = -1;\n\t\toutput.error_text{end+1} = [''Output Number %i has the wrong size is: ['' int2str(size(O%i)) ''] shoudl be ['' int2str(size(inputStruct.Outputs.O%i)) '']''];\n',i,i,i,i);
        fprintf(fileID,'\tend\n\n');
        
        
    end
    
    % %% Run Timing checks
    % fprintf(fileID,'\nwarning(''off'',''all'');\n');
    % fprintf(fileID,'\tN_times=30;\n\tx = zeros(N_times,1);for c=1:N_times, x(c) = timeit(@()magic(200),1); end\n\tbaseLineTime = median(x);\n');
    % fprintf(fileID,'\tx = zeros(N_times,1);for c=1:length(x), x(c) = timeit(@()%s(',fun.Function_Name);
    %
    % for k=1:fun.Number_Inputs
    %     fprintf(fileID,'inputStruct.Inputs.I%i',k);
    %     if( k < fun.Number_Inputs)
    %         fprintf(fileID,', ');
    %     else
    %         fprintf(fileID,')');
    %     end
    % end
    % fprintf(fileID,',%i);end\n\ttimingRatio=median(x)/baseLineTime;\n',fun.Number_Outputs);
    % fprintf(fileID,'\toutput.timing_performance = 100*(timingRatio-inputStruct.timingRatio)/inputStruct.timingRatio;\n\n');
    % fprintf(fileID,'\twarning(''on'',''all'');\n');
    
    %%
    fprintf(fileID,'\ncatch ME\n');
    fprintf(fileID,'\tif strcmp(''MATLAB:dispatcher:InexactCaseMatch'',ME.identifier)\n');
    fprintf(fileID,'\t\toutput.error_text{end+1} = [''Cannot find an exact (case-sensitive) match for %s ''];\n',fun.Function_Name);
    fprintf(fileID,'\telse\n');
    fprintf(fileID,'\t\toutput.error_text{end+1} = [ME.message, ''  Line '' , int2str(ME.stack(1).line) , '' in '' ME.stack(1).name];\n');
    fprintf(fileID,'\tend\n');
    fprintf(fileID,'end\n');
    
    fprintf(fileID,'\nend\n\n');
    
    % fprintf(fileID,'function runTiming(inputStruct)\n');
    % fprintf(fileID,'for i = 1:100\n');
    % fprintf(fileID,'\t%s(',fun.Function_Name);
    %
    % for k=1:fun.Number_Inputs
    %     fprintf(fileID,'inputStruct.Inputs.I%i',k);
    %     if( k < fun.Number_Inputs)
    %         fprintf(fileID,', ');
    %     else
    %         fprintf(fileID,')');
    %     end
    % end
    % fprintf(fileID,';\nend\n');
    %fprintf(fileID,'end');
    
    
    fclose('all');
    
    a=which('tep.m');
    [~,output] = evalc('tmp(fun)');
    %%
    disp(['Function: ' fun.Function_Name])
    if length(fun.Special_Case) > 0
        disp(['Special Case: ' fun.Special_Case]);
    end
    fprintf('\tHelp File Score: %1.1f out of 1\n', output.help_score);
    fprintf('\tEffort Score: %1.1f out of 1\n', output.effort);
    for k = 1:length(output.percentError)
        fprintf('\tOutput%i Percent Error: %3.2f%%\n', k, output.percentError(k));
    end
    %disp( output.timing_performance);
    % fprintf('\tTiming Performance: ');
    % if abs(output.timing_performance) <= 50
    %     fprintf('Same as baseline\n');
    % elseif output.timing_performance < -50
    %     fprintf('Faster than Baseline (nice!)\n');
    % elseif output.timing_performance > 400
    %     fprintf('Too Slow! Work on your effiency!\n');
    % elseif output.timing_performance > 300
    %     fprintf('Slower than baseline, improvements can be made...\n');
    % else
    %     fprintf('Same as baseline\n');
    % end
    fprintf('\tErrors:\t');
    if length(output.error_text)
        for j=1:length(output.error_text)
            fprintf('\n\t\t%s\n', (output.error_text{j}));
        end
    else
        fprintf('\tNo Matlab Errors or Warnings\n');
    end
    delete('tmp.m')
end

