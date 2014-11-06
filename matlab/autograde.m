function [ ] = autograde( )

    function [grade] = run_test_case(case_name, ...
            case_string, expected, should_pass, points)
        
        grade = 0;
        threshold = 0.0001;
        
        try
            [~, result] = evalc(case_string);
            if((isrow(expected) && iscolumn(result)) || (iscolumn(expected) && isrow(result)) && should_pass)
                result = result';
            end
            if(close_enough(expected, result, threshold) == should_pass)
                grade = points;
            end
        catch ME
            fprintf(comments_file, '\tException in %s %s:%d: %s\n', case_name, ME.stack(1).name, ME.stack(1).line, ME.message);
        end
        
        if(grade <= 0)
            fprintf(comments_file, '\tCase incorrect: %s\n', case_name);
        end
    end

% close enough calculation for floating point matrices
% thing1 and thing2 are matrices to compare
    function [result] = close_enough(thing1, thing2, threshold)
        differences = thing1 - thing2;
        maxes = bsxfun(@max, thing1, thing2);
        error = differences ./ maxes;
        max_deviation = max(abs(error));
        result = max_deviation < threshold;
    end

load('Project2.mat', 'A1', 'b1', 'A2', 'b2', 'A3', 'b3', 'A4', 'b4');
load('additional.mat', 'A5', 'b5', 'A6', 'b6', 'A7', 'b7', 'A8', 'b8');

grade_file = fopen('grades.csv', 'w');
comments_file = fopen('grades_notes.txt', 'w');

listing = dir('*-*');

for folder = listing'
   folder_name = folder.name;
   disp(folder_name);
   addpath(fullfile(pwd, folder_name));
   grade = 0;
   grade_output = '%s, %d\n';
   fprintf(comments_file, '%s:\n', folder_name);
   
   % AUTOGRADER GOES HERE
      
   target_function = 'GaussElim';
   if (exist(target_function, 'file')) % 36 points
       
       grade = grade + run_test_case('1', 'GaussElim(A1, b1);', A1\b1, true, 10);
       grade = grade + run_test_case('3', 'GaussElim(A3, b3);', A3\b3, false, 2);
       grade = grade + run_test_case('4', 'GaussElim(A4, b4);', A4\b4, true, 10);
       grade = grade + run_test_case('5', 'GaussElim(A5, b5);', A5\b5, true, 10);
       grade = grade + run_test_case('6', 'GaussElim(A6, b6);', A6\b6, false, 2);
       grade = grade + run_test_case('7', 'GaussElim(A7, b7);', A7\b7, false, 2);

   else
       fprintf(comments_file, '\tcould not find %s\n', target_function);
   end
   
   target_function = 'GaussElimPP';
   if (exist(target_function, 'file')) % 56 points
       
       grade = grade + run_test_case('1PP', 'GaussElimPP(A1, b1);', A1\b1, true, 7);
       grade = grade + run_test_case('2PP', 'GaussElimPP(A2, b2);', A2\b2, true, 7);
       grade = grade + run_test_case('3PP', 'GaussElimPP(A3, b3);', A3\b3, true, 7);
       grade = grade + run_test_case('4PP', 'GaussElimPP(A4, b4);', A4\b4, true, 7);
       grade = grade + run_test_case('5PP', 'GaussElimPP(A5, b5);', A5\b5, true, 7);
       grade = grade + run_test_case('6PP', 'GaussElimPP(A6, b6);', A6\b6, true, 7);
       grade = grade + run_test_case('7PP', 'GaussElimPP(A7, b7);', A7\b7, true, 7);
       grade = grade + run_test_case('8PP', 'GaussElimPP(A8, b8);', A8\b8, true, 7);
       
   else
       fprintf(comments_file, '\tcould not find %s\n', target_function);
   end

   % END AUTOGRADER
   
   fprintf(grade_file, grade_output, folder_name, grade);
   rmpath(fullfile(pwd, folder_name));
end

fclose('all');

end
