close all;
clear all;




% -- Example 2:  This is a quick example of how you can:

%    a)  Automate the title of your plots such that you don't
%        have to type each of them up one-by-one
%   
%    b)  Have greek characters on the x-axis ticks !



% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%
%    Our tasks:  We will plot 3 simple sinusoids, where the general 
%                form of the equation is:
%
%                f(x) = sin(n.*x)
%                
%
%    Plot #1:    f(x) = sin(1.*x);
%
%    Plot #2:    f(x) = sin(2.*x);
%
%    Plot #3:    f(x) = sin(3.*x);
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


% -- Define m
m = 1:1:3;

% -- Define plotting vector for x
x = 0 : 0.01 : 2*pi;


% -- Define the 3 functions of interest (I'm gonna use structs.... just
%    for fun !)

f(1).wave = [ ];  % -- Initialize struct


% -- Now, we store the 3 waves

for count = 1:1:length(m)
    
    f(count).wave = sin(count.*x);
    
end

% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%          Figure 1:  Plotting the 3 sine waves
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

my_plothandle = [ ];  % -- Initialize plothandle storage vector
my_legend = { };      % -- Intialize string storage vector
my_legend_plothandle = [ ];  % -- Initialize plothandle storage vector

% -- Define color pallet for my plots !
% -------------------------------------------

my_color =   [ 1      0       0;   % -- Red    
               0      1       0;   % -- Green
               0      0       1];  % -- Blue

           
% -- Main loop for plotting

for count = 1:1:length(m)
    
    figure;
    
    my_plothandle(count) = plot(x, f(count).wave);
    set( my_plothandle(count), 'Linewidth', 2, 'Color', my_color(count,:) );
    

    % \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    %            Defining the x-axis Greek-lettered labels
    % \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    % -- Define the numerical positions of where you want your tickmarks
    
    my_xtick_positions = [0  pi/4   pi/2   3*pi/4  pi  2*pi];
    
    % -- Define the Greek letters of each of your tick marks !
    
    my_greek_xaxis = {'bullshit'
                      '\pi/4'
                      '\pi/2'
                      '3\pi/4'
                      '\pi'
                      'crap'};
                  
                  
    % -- Now, use "set(gca, ....)"  to change the x-axis tick marks to
    %    Greek letters !
    
    set(gca, 'XTick', my_xtick_positions, 'XTickLabels', my_greek_xaxis);
    
    % -- Fill in the usual stuff !
    grid on;
    xlabel('x-axis');
    ylabel('y-axis');
    
    % -- We can use "num2str" and "strcat" to label our titles !!
    
    title( strcat('Graph for f(x) = sin(',  num2str(count), 'x) with Greek \pi axes'    )  );
    
    
    % -- We can also generate dynamically-changing legends !
    %    Notice the entire thing on the right are enclosed with {   }  
    %    because it has to be a string !
    
    my_legend(count) = { strcat('f(x) = sin(', num2str(count), 'x)'   )  } ;
    
    
    % -- Add legend to each of our plot
    
    my_legend_plothandle(count) = legend(my_legend(count), 'location', 'northeast');
    
    % -- Change the legend fonts
    set(my_legend_plothandle(count), 'FontSize', 12, 'FontName', 'Arial');
    
    
end 
                  
                     
    





