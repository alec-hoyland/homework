

close all;
clear all;


% -- Example 1:  Plotting multiple pcolor plots that will show:
%
%    a)  A  5 x 3 matrix worth of data
%    b)  The x-axis will have strings as tick marks !
%    c)  The y-axis data will contain defined unitss
%    d)  We will also use Greek letters in our plot !



%  Our fake 5 x 3 data matrix X:

%
%
%                         Coffee bean type
%             
%                       alpha1  alpha2 beta3
%                      |----------------------
%       X    =    500  |   100    90   80 
%                1000  |    90    50   50
%                2000  |    50   100   60
%    (altitidue) 3000  |    40    10  100
%       in ft    4000  |     0    50   20
%
%                 
%     The values inside the 5 x 3 matrix = # of barrels of coffee beans
%                                          harvested at each altitude
%                                          in the higlands of Ethiopia
% 

% -- Suppose you had a 5 x 3 data matrix

X = [100  90  80;
      90  50  50;
      50 100  60;
      40  10 100;
       0  50  20];
   
   
% -- Define the strings we need for the x-axis tick marks
%
my_xtick_strings = { '\alpha1'
                     '\alpha2'
                     '\beta3'};
   
% -- We can immediately ascertain the dimensions of X

disp('This size of data matrix X is');
[number_of_rows, number_of_columns] = size(X)


% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%     Note:  The pcolor command =  A LOWER-LEFT CORNER priority 
%                                  function
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


% -- In order to display the full 5 x 3 data matrix, we need to add
%    1 "fake column and 1 "fake" row of "NaN" data

fake_column = NaN .* ones(number_of_rows, 1);
fake_row    = NaN .* ones(1, number_of_columns + 1);  % -- Note the extra +1 here !

% -- Concatenate fake column
disp('Adding fake column to X');
X_for_pcolor = horzcat(X, fake_column)

% -- Concatenate fake column
disp('Adding fake row to X');
X_for_pcolor = vertcat(X_for_pcolor, fake_row)
   

% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
% -- Define a "fake" x-axis
%
% ** Note:  Even though we have 3 columns of data, in order to make the
%           data in column #3 visible using pcolor, we must add 1 more
%           "fake" column worth of x-axis value.
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

x = [1  2  3  4];  

% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
% -- Define a real y-axis (altitude...  in units of ft)
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

y = [500 1000 2000 3000 4000 5000];  % -- Notice the extra "5000" ft 
                                     %    y-value. This is for fake
                                     %    data only !
                                       
% -- Creat meshgrid
[Xmesh, Ymesh] = meshgrid(x, y);


% -- We will define colorbar shading values to be:
%
%                   cmin  =  lowest  # of barrels harvested = 0
%                   cmax  =  highest # of barrels harvested = 100

cmin = 0;
cmax = 100;




% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%        Figure 1:  Plot the pcolor data (ascending y-axis version)
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

figure;

% -- make the pcolor plot
my_pcolor_plothandle1 = pcolor(Xmesh, Ymesh, X_for_pcolor);

% -- Add colorbar (and you need the plothandle for the colorbar too !)
colorbar_handle1 = colorbar;

% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%  -- Using "caxis" to limit the color axis values
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

caxis(  [cmin  cmax]);


% -- Add string label to colorbar
set(get(colorbar_handle1, 'YLabel'), 'String', '# of barrels harvested', 'FontSize', 12);

% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
% -- Now, using the "set(gca, ... )" command, we will replace the x-axis
%    tick marks with our strings:
%
%
%   Location of strings:
%
%
%     x =    1       1.5      2        2.5     3      3.5       4
%   --------------------------------------------------------------------->
%                   alpha1            alpha2         beta3
%

set(gca, 'XTick', [1.5   2.5   3.5  ], 'XTickLabels', my_xtick_strings);

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%  --  Again, using "set(gca, ...)", let's reverse the y-axis values !!
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

set(gca, 'YDir', 'reverse');

% -- Now, we add the other essentials
xlabel('Coffee bean type');
ylabel('Altitude (ft)');
title(strcat('Example 1:  Greek \sigma_d_a_m_m_i_t values =', num2str(cmax), ' barrels max' ) );
colormap(jet);





