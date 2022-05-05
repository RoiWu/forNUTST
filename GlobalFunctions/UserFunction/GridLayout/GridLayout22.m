% Change in GridLayout.ResizeCell() - eacousineau
% Enable non-figure parents in constructor, Parent
classdef GridLayout < handle
    
    properties
        Container
        
        NumRows
        NumCols
        RowHeight
        ColWidth
        HGap
        VGap
        HMargin
        VMargin
        
        % Sizing policies
        % 0: Absolute
        % 1: Proportional

        RowHeightPolicy
        RowHeightAbsolute
        RowHeightWeight
        
        ColWidthPolicy
        ColWidthAbsolute
        ColWidthWeight
    end
    
    properties (Constant)
        MinRowHeight = 10
        MinColWidth = 10
    end
    
    properties (SetAccess = private)
        Cell  % Cell container
    end
    
    methods
        function Obj = GridLayout(Parent, varargin)
            Names = { ...
                'NumRows' ...
                'NumCols' ...
                'RowHeight' ...
                'ColWidth' ...
                'HGap' ...
                'VGap' ...
                'Gap' ...
                'HMargin' ...
                'VMargin' ...
                'Margin'};
            NamesCell = CellProps.GetCellParamNames();
            [P, PC] = ParseArgs(varargin, Names, NamesCell);
            
            if isempty(Parent) % || ~ishghandle(Parent)
                Parent = gcf;
            end
            Obj.Container = uicontainer( ...
                'Parent', Parent, ...
                'ResizeFcn', @(hsrc,ev)UpdateLayout(Obj));
            
            % NumRows
            DefaultNumRows = 1;
            if ~isempty(P.RowHeight) && iscell(P.RowHeight)
                DefaultNumRows = length(P.RowHeight);
            end
            Obj.NumRows = GetArg(P,'NumRows',DefaultNumRows);
            % NumCols
            DefaultNumCols = 1;
            if ~isempty(P.ColWidth) && iscell(P.ColWidth)
                DefaultNumCols = length(P.ColWidth);
            end
            Obj.NumCols = GetArg(P,'NumCols',DefaultNumCols);
            % RowHeight
            Value = GetArg(P,'RowHeight','*');
            if ~iscell(Value)
                Obj.RowHeight = cell(1,Obj.NumRows);
                [Obj.RowHeight{1:end}] = deal(Value);
            else
                Obj.RowHeight = P.RowHeight;
            end
            % ColWidth
            Value = GetArg(P,'ColWidth','*');
            if ~iscell(Value)
                Obj.ColWidth = cell(1,Obj.NumCols);
                [Obj.ColWidth{1:end}] = deal(Value);
            else
                Obj.ColWidth = P.ColWidth;
            end
            % HGap
            Obj.HGap = GetArg(P,'HGap',5);
            % VGap
            Obj.VGap = GetArg(P,'VGap',5);
            % Gap (overrides HGap, VGap)
            if ~isempty(P.Gap)
                Obj.HGap = P.Gap;
                Obj.VGap = P.Gap;
            end
            % HMargin
            Obj.HMargin = GetArg(P,'HMargin',Obj.HGap);
            % VMargin
            Obj.VMargin = GetArg(P,'VMargin',Obj.VGap);
            % Margin (overrides HMargin, VMargin)
            if ~isempty(P.Margin)
                Obj.HMargin = P.Margin;
                Obj.VMargin = P.Margin;
            end
            
            % Create array of cell containers
            Obj.Cell = zeros(Obj.NumRows,Obj.NumCols);
            for RIdx = 1:Obj.NumRows
                for CIdx = 1:Obj.NumCols
                    ThisCell = uicontainer( ...
                        'Parent', Obj.Container, ...
                        'Units', 'pixels', ...
                        'Position', [5*RIdx 5*CIdx 100 100]); % Not important!
                    Props = CellProps(PC);
                    if ~isempty(Props.Color)
                        set(ThisCell, 'BackgroundColor', Props.Color);
                    end
                    setappdata(ThisCell,'Props',Props);
                    setappdata(ThisCell,'RSpan',[RIdx RIdx]);
                    setappdata(ThisCell,'CSpan',[CIdx CIdx]);
                    Obj.Cell(RIdx,CIdx) = ThisCell;
                end
            end

            % RowHeightPolicy
            Obj.RowHeightPolicy   = zeros(1,Obj.NumRows);
            Obj.RowHeightAbsolute = zeros(1,Obj.NumRows);
            Obj.RowHeightWeight   = zeros(1,Obj.NumRows);
            for RIdx = 1:Obj.NumRows
                RHeight = Obj.RowHeight{RIdx};
                if ischar(RHeight)
                    if RHeight(end) == '*'
                        Obj.RowHeightPolicy(RIdx) = 1; % Proportional
                        Weight = RHeight(1:end-1);
                        if isempty(Weight)
                            Weight = '1';
                        end
                        Obj.RowHeightWeight(RIdx) = str2double(Weight);
                    else
                        error('RowHeight must be a string ending in ''*''.')
                    end
                elseif isnumeric(RHeight)
                    Obj.RowHeightPolicy(RIdx) = 0; % Absolute
                    Obj.RowHeightAbsolute(RIdx) = RHeight;
                else
                    error('RowHeight must be a string or a number.');
                end
            end
            
            % ColWidthPolicy
            Obj.ColWidthPolicy   = zeros(1,Obj.NumCols);
            Obj.ColWidthAbsolute = zeros(1,Obj.NumCols);
            Obj.ColWidthWeight   = zeros(1,Obj.NumCols);
            for CIdx = 1:Obj.NumCols
                CWidth = Obj.ColWidth{CIdx};
                if ischar(CWidth)
                    if CWidth(end) == '*'
                        Obj.ColWidthPolicy(CIdx) = 1; % Proportional
                        Weight = CWidth(1:end-1);
                        if isempty(Weight)
                            Weight = '1';
                        end
                        Obj.ColWidthWeight(CIdx) = str2double(Weight);
                    elseif any(strcmp(CWidth,{'Auto','a'}))
                        Obj.ColWidthPolicy(CIdx) = 1; % Automatic
                    else
                        error('Illegal ColWidth string format.')
                    end
                elseif isnumeric(CWidth)
                    Obj.ColWidthPolicy(CIdx) = 0; % Absolute
                    Obj.ColWidthAbsolute(CIdx) = CWidth;
                else
                    error('ColWidth must be a string or a number.');
                end
            end
            
            UpdateLayout(Obj);
        end

        function MergeCells(Obj, RSpan, CSpan)
            if isempty(RSpan)
                RSpan = [1 Obj.NumRows];
            end
            if isscalar(RSpan)
                RSpan = [RSpan RSpan];
            end
            if isempty(CSpan)
                CSpan = [1 Obj.NumCols];
            end
            if isscalar(CSpan)
                CSpan = [CSpan CSpan];
            end
            for RIdx = RSpan(1):RSpan(2)
                for CIdx = CSpan(1):CSpan(2)
                    ThisCell = Obj.Cell(RIdx,CIdx);
                    if RIdx == RSpan(1) && CIdx == CSpan(1)
                        setappdata(ThisCell,'RSpan',RSpan);
                        setappdata(ThisCell,'CSpan',CSpan);
                    else
                        delete(ThisCell);
                    end
                end
            end
        end

        function RemoveCells(Obj, RSpan, CSpan)
            if isempty(RSpan)
                RSpan = [1 Obj.NumRows];
            end
            if isscalar(RSpan)
                RSpan = [RSpan RSpan];
            end
            if isempty(CSpan)
                CSpan = [1 Obj.NumCols];
            end
            if isscalar(CSpan)
                CSpan = [CSpan CSpan];
            end
            for RIdx = RSpan(1):RSpan(2)
                for CIdx = CSpan(1):CSpan(2)
                    ThisCell = Obj.Cell(RIdx,CIdx);
                    if ishghandle(ThisCell)
                        delete(ThisCell);
                    end
                end
            end
        end

        function FormatCells(Obj, RSpan, CSpan, varargin)
            if isscalar(RSpan)
                RSpan = [RSpan RSpan];
            end
            if isscalar(CSpan)
                CSpan = [CSpan CSpan];
            end
            for RIdx = RSpan(1):RSpan(2)
                for CIdx = CSpan(1):CSpan(2)
                    ThisCell = Obj.Cell(RIdx,CIdx);
                    if ~ishghandle(ThisCell)
                        continue; % Cell is removed
                    end
                    Props = getappdata(ThisCell,'Props');
                    for i = 1:2:length(varargin)
                        Props.(varargin{i}) = varargin{i+1};
                    end
                    if ~isempty(Props.Color)
                        set(ThisCell, 'BackgroundColor', Props.Color);
                    end
                    setappdata(ThisCell,'Props',Props);
                end
            end
        end

        function UpdateLayout(Obj)
            % Layout size
            Position = getpixelposition(Obj.Container);
            LayoutWidth = Position(3);
            LayoutHeight = Position(4);

            % Determine column widths
            CWidthSum = LayoutWidth-(Obj.NumCols-1)*Obj.VGap-2*Obj.VMargin;
            CWidth = zeros(1,Obj.NumCols);
            % The absolute-width columns have priority
            CMask = Obj.ColWidthPolicy == 0;
            CWidth(CMask) = Obj.ColWidthAbsolute(CMask);
            % Divide the remaining space among the proportional rows
            CWidthProportionalMask = Obj.ColWidthPolicy == 1;
            CWidthSumProportional = CWidthSum - sum(CWidth);
            CWidthSumProportional = max(CWidthSumProportional,0);
            CWidthWeight = Obj.ColWidthWeight(CWidthProportionalMask);
            CWidth(CWidthProportionalMask) = CWidthSumProportional*CWidthWeight/sum(CWidthWeight);
            CWidth = max(CWidth, Obj.MinColWidth);

            % Determine row heights
            RHeightSum = LayoutHeight-(Obj.NumRows-1)*Obj.HGap-2*Obj.HMargin;
            RHeight = zeros(1,Obj.NumRows);
            % The absolute-height rows have priority
            RMask = Obj.RowHeightPolicy == 0;
            RHeight(RMask) = Obj.RowHeightAbsolute(RMask);
            % Divide the remaining space among the proportional rows
            RMask = Obj.RowHeightPolicy == 1;
            RHeightSumProportional = RHeightSum - sum(RHeight);
            RHeightSumProportional = max(RHeightSumProportional,0);
            Weight = Obj.RowHeightWeight(RMask);
            RHeight(RMask) = RHeightSumProportional*Weight/sum(Weight);
            RHeight = max(RHeight, Obj.MinRowHeight);
            
            % Horizontal and vertical offsets for each cell
            CellOffsetH = cumsum([Obj.VMargin CWidth(1:end-1)+Obj.VGap]);
            CellOffsetV = LayoutHeight-cumsum([RHeight(1)+Obj.HMargin RHeight(2:end)+Obj.HGap]);

            % Set cell positions
            Cells = get(Obj.Container,'Children');
            for i = 1:length(Cells)
                RSpan = getappdata(Cells(i),'RSpan');
                CSpan = getappdata(Cells(i),'CSpan');
                RIdx  = RSpan(1):RSpan(2);
                CIdx  = CSpan(1):CSpan(2);

                set(Cells(i), ...
                    'Position', [ ...
                        CellOffsetH(CIdx(1)) ...
                        CellOffsetV(RIdx(end)) ...
                        sum(CWidth(CIdx))+Obj.HGap*(length(CIdx)-1) ...
                        sum(RHeight(RIdx))+Obj.VGap*(length(RIdx)-1)]);
                    
                GridLayout.ResizeCell(Cells(i));
            end
        end
    end
    
    methods (Static, Access = private)
        function ResizeCell(Src)
            Child = get(Src,'Children');
            if isempty(Child)
                return;
            end
            assert(isscalar(Child), ...
                'Cell has more than one child. This is not allowed.');
            
            IsAxes = false;
            % Use bugfix from layout.GridBagLayout.layout(this)
            % http://www.mathworks.com/matlabcentral/fileexchange/22968-gridbaglayout/
            if ishghandle(Child, 'axes') && ...
                    strcmp(get(Child, 'ActivePositionProperty'), 'outerposition')
                IsAxes = true;
                OldUnits = get(Child, 'Units');
                set(Child, 'Units', 'Pixels');
                ChildPosition = get(Child, 'OuterPosition');
            else
                ChildPosition = get(Child, 'Position');
            end
            
            % Child offset and size
            ChildOffset = ChildPosition(1:2);
            ChildSize = ChildPosition(3:4);
            % Cell size
            CellPosition = getpixelposition(Src);
            CellSize = CellPosition(3:4);
            % Cell propoerties
            Props = getappdata(Src,'Props');
            % Horizontal alignment
            HAlign  = Props.HAlign;
            HMargin = Props.HMargin;
            if strcmp(HAlign,'Left')
                ChildOffset(1) = HMargin;
            elseif strcmp(HAlign,'Right')
                ChildOffset(1) = CellSize(1)-ChildSize(1)-HMargin;
            elseif strcmp(HAlign,'Center')
                ChildOffset(1) = (CellSize(1)-ChildSize(1))/2;
            else % Stretch
                ChildOffset(1) = HMargin;
                ChildSize(1) = CellSize(1)-2*HMargin;
            end
            % Vertical alignment
            VAlign  = Props.VAlign;
            VMargin = Props.VMargin;
            if strcmp(VAlign,'Bottom')
                ChildOffset(2) = VMargin;
            elseif strcmp(VAlign,'Top')
                ChildOffset(2) = CellSize(2)-ChildSize(2)-VMargin;
            elseif strcmp(VAlign,'Center')
                ChildOffset(2) = (CellSize(2)-ChildSize(2))/2;
            else % Stretch
                ChildOffset(2) = VMargin;
                ChildSize(2) = CellSize(2)-2*VMargin;
            end
            % Prevent non-positive sizes
            ChildSize = max(ChildSize,.1);
            % Update child position
            ChildPosition = [ChildOffset ChildSize];
            if ~IsAxes
                set(Child,'Position', ChildPosition);
            else
                set(Child, 'OuterPosition', ChildPosition, 'Units', OldUnits);
            end
        end
        
    end
end

% EOF