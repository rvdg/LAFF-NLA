%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (isaacjlee@hotmail.com)
%    
%  Summary:
%    
%    This program creates a GUI (graphical user interface). It allows the
%    user to visualize the definition of an induced matrix norm.
%    
%    You can define your own matrices and norms (the code works for any p
%    between 1 and infinity!) by modifying the list of matrices and norms
%    that you can find immediately below.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    visualize_matrix_norm
%    
%--------------------------------------------------------------------------
function visualize_matrix_norm()
    % Close all figures
    close all;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Define the global variables
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    global matrices matrixIndex;
    global norms normIndex norm_maximum;
    global handle_gui handle_plot;
    
    % Default list of 2 x 2 matrices
    matrices = {'[   3    0;    0    2]', ...
                '[   1   -1;    3    2]', ...
                '[   2   -1;   -1    2]', ...
                '[   1    0;    0    1]', ...
                '[   0    1;   -1    0]', ...
                '[   0    0;    0    0]', ...
                '[ 1/4  1/3;    1  1/2]', ...
                '[   1    1; -1/4  1/2]', ...
                '[   1    2;    1    2]', ...
                '[ 0.7  0.3; -0.6 -0.4]'};
    
    % Set the index to the first position
    matrixIndex = 1;
    
    % List of available induced matrix norms
    norms = {1, 1.5, 2, 3, 10, 'inf'};
    
    % Consider the first one in the norms list
    normIndex = 1;
    
    % Reset the current maximum of norm ||Ax||_{p}
    norm_maximum = 0;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Create the handle to the GUI
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    handle_gui = figure('Name'        , 'Visualization of matrix norms', ...
                        'Units'       , 'normalized', ...
                        'Position'    , [0.00 0.00 0.60 0.60], ...
                        'Color'       , [0.91 0.91 0.90], ...
                        'DockControls', 'off', ...
                        'MenuBar'     , 'none', ...
                        'NumberTitle' , 'off', ...
                        'Resize'      , 'on', ...
                        'ToolBar'     , 'none');
    
    movegui(handle_gui, 'center');
    
    % Store various information for plotting as a struct
    A = eval(matrices{matrixIndex});
    handle_plot = struct;
    handle_plot.windowLocation = [0.06 0.15 0.46 0.70];
    handle_plot.windowCenter   = [0.06 0.15] + 0.5 * [0.46 0.70];
    handle_plot.windowSize     = 1.25 * max(norm(A, 'inf'), 1);
    handle_plot.x              = struct;
    handle_plot.y              = struct;
    
    % Display the GUI
    drawGUI();
end


function drawGUI()
    global matrices matrixIndex;
    global norms normIndex norm_maximum;
    global handle_gui handle_plot handle_field_matrixNorm;
    
    
    % Call the GUI handle and clear the screen
    figure(handle_gui);
    clf;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set up the left panel
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Dedicate a part of the GUI for graphing the unit ball x and the
    % linearly transformed ball y = A*x
    subplot('Position', handle_plot.windowLocation, 'FontSize', 12);
    
    
    %----------------------------------------------------------------------
    %  Initialize the unit ball x and the linearly transformed ball y
    %  
    %  Fields of structs x and y:
    %      all       - list of all vectors on the ball x or y
    %      current   - handle to the most recently drawn vector
    %      label     - handle to the label "x" or "Ax"
    %      maximizer - handle to the maximizing vector "x" or "Ax"
    %----------------------------------------------------------------------
    % For the unit ball x
    color_x       = [0.70 0.35 0.45];
    color_x_light = [0.90 0.55 0.45];
    
    handle_plot.x.all       = animatedline('Color'     , color_x, ...
                                           'LineStyle' , 'none', ...
                                           'Marker'    , '.', ...
                                           'MarkerSize', 7);
    
    handle_plot.x.current   = line([0 0], [0 0], 'Color', color_x_light, 'LineWidth', 2); hold on;
    
    handle_plot.x.label     = text(0, 0, 'x', 'Color'     , color_x, ...
                                              'FontSize'  , 18, ...
                                              'FontWeight', 'bold', ...
                                              'Visible'   , 'off');
    
    handle_plot.x.maximizer = plot(0, 0, 'o', 'Color'          , color_x, ...
                                              'MarkerFaceColor', color_x_light, ...
                                              'MarkerSize'     , 10, ...
                                              'Visible'        , 'off'); hold on;
    
    % For the linearly transformed ball y = A*x
    color_y       = [0.25 0.35 0.50];
    color_y_light = [0.25 0.60 0.70];
    
    handle_plot.y.all       = animatedline('Color'     , color_y, ...
                                           'LineStyle' , 'none', ...
                                           'Marker'    , '.', ...
                                           'MarkerSize', 7);
    
    handle_plot.y.current   = line([0 0], [0 0], 'Color', color_y_light, 'LineWidth', 2); hold on;
    
    handle_plot.y.label     = text(0, 0, 'Ax', 'Color'     , color_y, ...
                                               'FontSize'  , 18, ...
                                               'FontWeight', 'bold', ...
                                               'Visible'   , 'off');
    
    handle_plot.y.maximizer = plot(0, 0, 'o', 'Color'          , color_y, ...
                                              'MarkerFaceColor', color_y_light, ...
                                              'MarkerSize'     , 10, ...
                                              'Visible'        , 'off');
    
    % Set the title and axis labels
    title('Click and drag on this plot window!', 'FontSize', 20);
    xlabel('x_{1}'     , 'FontSize', 22);
    ylabel('x_{2}     ', 'FontSize', 22, 'Rotation', 0);
    
    % Set the plot range
    x_max = handle_plot.windowSize;
    axis([-x_max x_max -x_max x_max]);
    axis square;
    
    % Turn the grid on
    grid on;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set up the right panel
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Create the label for the drop down menu for matrices
    uicontrol('Style'              , 'text', ...
              'String'             , 'Select the matrix A:', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.57 0.75 0.35 0.10], ...
              'BackgroundColor'    , [0.91 0.91 0.90], ...
              'ForegroundColor'    , [0.30 0.25 0.45], ...
              'FontSize'           , 18, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left');
    
    % Create the drop down menu for matrices
    uicontrol('Style'              , 'popupmenu', ...
              'String'             , matrices, ...
              'Value'              , matrixIndex, ...
              'Units'              , 'normalized', ...
              'Position'           , [0.57 0.65 0.35 0.10], ...
              'BackgroundColor'    , [0.90 0.92 0.95], ...
              'ForegroundColor'    , [0.10 0.10 0.10], ...
              'FontName'           , 'courier', ...
              'FontSize'           , 17, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left', ...
              'Callback'           , @changeMatrix);
    
    % Create the label for the drop down menu for norms
    uicontrol('Style'              , 'text', ...
              'String'             , 'Select the norm p:', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.57 0.50 0.35 0.10], ...
              'BackgroundColor'    , [0.91 0.91 0.90], ...
              'ForegroundColor'    , [0.30 0.25 0.45], ...
              'FontSize'           , 18, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left');
    
    % Create the drop down menu for norms
    uicontrol('Style'              , 'popupmenu', ...
              'String'             , norms, ...
              'Value'              , normIndex, ...
              'Units'              , 'normalized', ...
              'Position'           , [0.57 0.40 0.12 0.10], ...
              'BackgroundColor'    , [0.90 0.92 0.95], ...
              'ForegroundColor'    , [0.10 0.10 0.10], ...
              'FontName'           , 'courier', ...
              'FontSize'           , 17, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left', ...
              'Callback'           , @changeNorm);
    
    % Create the label for the text showing the maximum norm
    uicontrol('Style'              , 'text', ...
              'String'             , 'Current maximum of ||Ax||_{p}:', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.57 0.25 0.35 0.10], ...
              'BackgroundColor'    , [0.91 0.91 0.90], ...
              'ForegroundColor'    , [0.30 0.25 0.45], ...
              'FontSize'           , 18, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left');
    
    % Create the field to show the maximum norm
    handle_field_matrixNorm = ...
    uicontrol('Style'              , 'text', ...
              'String'             , sprintf('%.6f', norm_maximum), ...
              'Units'              , 'normalized', ...
              'Position'           , [0.57 0.18 0.16 0.06], ...
              'BackgroundColor'    , [0.85 0.85 0.82], ...
              'ForegroundColor'    , [0.50 0.10 0.10], ...
              'FontName'           , 'courier', ...
              'FontSize'           , 17, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left');
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Wait for user response
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    set(handle_gui, 'WindowButtonDownFcn', @startDrawing, ...
                    'WindowButtonUpFcn'  , @stopDrawing);
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to change the matrix A
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function changeMatrix(source, ~)
    global matrixIndex;
    
    % Update the matrix index
    matrixIndex = source.Value;
    
    resetVariables();
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to change the norm p
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function changeNorm(source, ~)
    global normIndex;
    
    % Update the norm index
    normIndex = source.Value;
    
    resetVariables();
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to reset variables when the user considers a
%   different matrix or norm
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function resetVariables()
    global matrices matrixIndex;
    global norm_maximum;
    global handle_plot;
    
    % Reset the current maximum norm
    norm_maximum = 0;
    
    % Reset the information for plotting
    A = eval(matrices{matrixIndex});
    handle_plot.windowSize = 1.25 * max(norm(A, 'inf'), 1);
    handle_plot.x          = struct;
    handle_plot.y          = struct;
    
    % Display the GUI
    drawGUI();
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   This routine uses the mouse location to trace the unit ball x and the
%   linearly transformed ball A*x. It also updates the current maximum
%   norm ||A*x||_{p} and displays the value to the user.
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function startDrawing(source, ~)
    global matrices matrixIndex;
    global norms normIndex norm_maximum;
    global handle_gui handle_plot handle_field_matrixNorm;
    
    
    % Get the matrix A and the norm p
    A = eval(matrices{matrixIndex});
    p = norms{normIndex};
    
    
    %----------------------------------------------------------------------
    %  Find the unit vector pointing to the mouse cursor
    %----------------------------------------------------------------------
    % Get the location of the mouse cursor
    mouseLocation = get(source, 'CurrentPoint');
    
    % Find the vector pointing to the mouse cursor (we need to account for
    % the aspect ratio of the plot window)
    x = (mouseLocation - handle_plot.windowCenter)';
    x(1) = x(1) / handle_plot.windowLocation(3);
    x(2) = x(2) / handle_plot.windowLocation(4);
    
    x = x / norm(x, p);
    
    
    %----------------------------------------------------------------------
    %  Calculate y = A*x
    %----------------------------------------------------------------------
    y = A*x;
    
    norm_Ax = norm(y, p);
    
    % Update the current maximum norm
    if (norm_Ax + 1e-12 >= norm_maximum)
        norm_maximum = norm_Ax;
        
        % Display the value to the user
        set(handle_field_matrixNorm, 'String', sprintf('%.6f', norm_maximum));
        
        % Display the locations of the maximizers
        set(handle_plot.x.maximizer, 'XData', x(1), 'YData', x(2), 'Visible', 'on');
        set(handle_plot.y.maximizer, 'XData', y(1), 'YData', y(2), 'Visible', 'on');
    end
    
    
    %----------------------------------------------------------------------
    %  Some bookkeeping
    %----------------------------------------------------------------------
    % Add vectors x and y to the lists
    addpoints(handle_plot.x.all, x(1), x(2));
    addpoints(handle_plot.y.all, y(1), y(2));
    
    % Update the lines representing x and y = A*x
    set(handle_plot.x.current, 'XData', [0 x(1)], 'YData', [0 x(2)]);
    set(handle_plot.y.current, 'XData', [0 y(1)], 'YData', [0 y(2)]);
    
    % Update the positions of the labels "x" and "Ax"
    dx = 0.1 * handle_plot.windowSize;
    set(handle_plot.x.label, 'Position', 1.1*x + sign(x(1))*[dx; 0], 'Visible', 'on');
    set(handle_plot.y.label, 'Position', 1.1*y + sign(y(1))*[dx; 0], 'Visible', 'on');
    
    
    %----------------------------------------------------------------------
    %  Allow the user to trace the balls continuously
    %----------------------------------------------------------------------
    set(handle_gui, 'WindowButtonMotionFcn', @startDrawing);
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   This routine stops tracing the balls x and A*x by redefining what
%   happens when the mouse moves (do nothing).
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function stopDrawing(~, ~)
    global handle_gui;
    
    set(handle_gui, 'WindowButtonMotionFcn', '');
end