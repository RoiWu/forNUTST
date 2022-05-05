function xy = PolyDraw(varargin)
%% PolyDraw
%
% xy = PolyDraw
% 
%     % PolyDraw EVOKED WITH 0 INPUTS DEFAULTS TO CURRENT AXIS
%         % AND SPECIFIES LINE DRAWING THAT WILL REMAIN ON THE FIGURE
%         % AFTER DRAWING IS COMPLETE. EasyDraw RETURNS THE XY
%         % COORDINATES FOR THE (CLOSED) POLYGON DRAWN ON THE FIGURE
% 
% 
% xy = PolyDraw(axis_handle);
% 
%     % 1st INPUT SPECIFIES AN AXIS HANDLE (1 == USE CURRENT AXIS);
% 
% 
% xy = PolyDraw(1,2);
% 
%     % 2nd INPUT SPECIFIES LINE (1 |DEFAULT) OR SPLINE (2) DRAWING
% 
% 
% xy = PolyDraw(1,2,.5);
% 
%     % 3rd INPUT SPECIFIES WHETHER TO KEEP (-1 |DEFAULT) OR DELETE (0)
%         % THE LINE POLYGON; ANY OTHER POSITIVE NUMBER INPUT (e.g. 1.5)
%         % IN THIS ARG POSITION WILL DELETE THE POLYGON AFTER A PAUSE 
%         % OF THAT LENGTH (e.g. pause(1.5) )
%
%
%% ---------------------- EXAMPLES -------------------------
%{

% CREATE A FIGURE, AXIS, and PLOT
%---
clc; close all; clear all;
x = 0:pi/100:2*pi;
y = sin(x);

fh1 = figure(1);
ax1 = axes('Position',[.1 .1 .8 .8]);
ph1 = plot(x,y);
%---

% THEN...

%% EVOKE THE PolyDraw FUNCTION WITH NO INPUT ARGS

xy = PolyDraw;


%% EVOKE PolyDraw && SPECIFY AXIS
xy = PolyDraw(ax1);


%% EVOKE PolyDraw && CREATE A SPLINE CURVE FROM THE DRAWN LINE POLYGON
xy = PolyDraw(1,2);         % SPLINE W/ DEFAULT AXIS
xy = PolyDraw(ax1,2);       % SPLINE W/ SPECIFIED AXIS


%% EVOKE PolyDraw && DELETE (OR KEEP) THE POLYGON ON THE FIGURE
xy = PolyDraw(1,2,-1);      % KEEP IT (THE LINE POLYGON)
xy = PolyDraw(1,2,-1);      % KEEP IT (THE SPLINE CURVE)
xy = PolyDraw(1,2,0);       % DELETE IT (THE SPLINE CURVE) ASAP
xy = PolyDraw(1,1,0);       % DELETE IT (THE LINE POLYGON) ASAP
xy = PolyDraw(1,1,.5);      % DELETE IT (THE LINE POLYGON) AFTER .5 SECONDS

%}
%% -----------------------------------------------------------


%% -- DEAL ARGS

    if nargin < 1
        % 0 INPUTS DEFAULTS TO CURRENT AXIS
    
        ax = gca;
        axP = get(gca,'Position');
        v2=1; v3=-1;

    elseif nargin == 1
        % 1st INPUT SPECIFIES AXIS (1 == USE CURRENT AXIS);
        v1 = varargin{1};
        
            if v1==1;
                ax = gca;
            else
                ax = v1;
            end
        v2=1; v3=-1;

    elseif nargin == 2
        % 2nd INPUT SPECIFIES LINE (1 |DEFAULT) OR SPLINE (2)
        [v1, v2] = deal(varargin{:});

            if v1==1;
                ax = gca;
            else
                ax = v1;
            end
         v3=-1;

    elseif nargin == 3
        % 3rd INPUT SPECIFIES WHETHER TO KEEP (-1 |DEFAULT) OR DELETE (0)
        % THE LINE POLYGON; ANY OTHER POSITIVE NUMBER INPUT (e.g. 1.5)
        % IN THIS ARG POSITION WILL DELETE THE POLYGON AFTER A PAUSE 
        % OF THAT LENGTH (e.g. pause(1.5) )
        [v1, v2, v3] = deal(varargin{:});

            if v1==1;
                ax = gca;
            else
                ax = v1;
            end

    else

        warning('Too many inputs')

    end


%% -- CREATE SOME AXES TO DRAW ON
ax1 = axes('Position',ax.Position,'Color','none',...
            'XLim',ax.XLim,'YLim',ax.YLim);
    hold on
ax2 = axes('Position',ax.Position,'Color','none',...
            'XLim',ax.XLim,'YLim',ax.YLim);
    hold on


%% -- LOOP OVER ginput(1) -- SAVE POINTS -- PLOT LINE
xx = [];
yy = [];
n = 0;
but1 = 1;

disp('Use the RIGHT MOUSE button to click on points.')
disp('Use the LEFT MOUSE button to click LAST point.')
while but1 == 1
    [xi,yi,but1] = ginput(1);

    plot(xi,yi,'ro','Parent',ax1)
    hold on

   n = n+1;

    xx(n) = xi;
    yy(n) = yi;
    line(xx,yy,'Parent',ax1)
    hold on
    
end
    
%% -- CLOSE THE POLYGON AND PLOT
    n = n+1;
    xx(n) = xx(1);
    yy(n) = yy(1);
    line(xx,yy,'Parent',ax1)
    hold on

%% -- STORE OUTPUT VARIABLE XY COORDINATES FOR CLOSED POLYGON
    xy = [xx;yy]; 


%% -- INTERPOLATE (OR NOT) A SPLINE CURVE
if v2 == 2
    t = 1:n;
    ts = 1: 0.1: n;
    xys = spline(t,xy,ts);

    ax1.delete
    plot(xys(1,:),xys(2,:),'b-','Parent',ax2);
    drawnow
end


%% -- DELETE (OR NOT) THE DRAWN POLYGON
if v3 >= 0
    pause(v3)
    ax1.delete
    ax2.delete
end



%%
end