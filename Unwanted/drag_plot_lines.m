function drag_plot_lines(aH, upper_limit_mz_value, max_intensity)
global h_u 
% pt2 = [];
% pt5 = [];
% f = figure;
% aH = axes('Xlim',[0, 1], 'YLim', [0, 1]);
    h_u = line([upper_limit_mz_value upper_limit_mz_value], [0 max_intensity],'ButtonDownFcn', @startDragFcn);

    set(gcf, 'WindowButtonUpFcn', @stopDragFcn)

    function startDragFcn(varargin)
        set(gcf, 'WindowButtonMotionFcn', @draggingFcn)
    end

    function draggingFcn(varargin)
        pt = get(aH, 'CurrentPoint');
        set(h_u, 'XData', pt(1)*[1 1]);
%         disp(pt)
    end

    function stopDragFcn(varargin)
        global pt6
        set(gcf,'WindowButtonMotionFcn', '');
        pt = get(aH, 'CurrentPoint');
%         disp(pt(1))
        pt6 = pt(1);
        disp(pt6)
%         drawnow()
    end

%     h_l = line([lower_limit_mz_value lower_limit_mz_value], [0 max_intensity],'ButtonDownFcn', @startDragFcn2);
% 
%     set(gcf, 'WindowButtonUpFcn', @stopDragFcn2)
% 
%     function startDragFcn2(varargin)
%         set(gcf, 'WindowButtonMotionFcn', @draggingFcn2)
%     end
% 
%     function draggingFcn2(varargin)
%         pt4 = get(aH, 'CurrentPoint');
%         set(h_l, 'XData', pt4(1)*[1 1]);
% %         disp(pt)
%     end
% 
%     function stopDragFcn2(varargin)
%         global pt5
%         set(gcf,'WindowButtonMotionFcn', '');
%         pt4 = get(aH, 'CurrentPoint');
% %         disp(pt(1))
%         pt5 = pt4(1);
% %         drawnow()
%         disp(pt5)
%     end
% % disp(pt2(1))
% % disp(pt5(1))
end