function h = setMarkerColor(h, color, alpha)
  % sets the marker color and transparency
  % see: http://undocumentedmatlab.com/blog/plot-markers-transparency-and-color-gradient

  % Arguments:
    % h: the plot handle
    % color: a numerical vector or matrix specifying the color or a colorspec code
        % if color is a vector, it should be 3x1 or 4x1
        % where the first three elements are the RGB color the fourth is the alpha value
        % if color is a matrix, it should be 3 x N or 4 x N and will color the points with a gradient
    % alpha: the transparency as a value between 0 and 1 (1 is opaque)
        % if color is 4x1, alpha is ignored
        % if alpha is not supplied, alpha is 1
  % Output:
    % h: the plot handle

    % if color is a character vector, convert it to an RGB
    if ischar(color)
        color = vectorise(str2rgb(color));
        if isnan(color)
            disp('[ERROR] unknown colorspec code')
            return
        end
    end
    
    % if color is numeric, then it should be a 4x1 or 3x1 vector, or a matrix
    if isnumeric(color)

        % normalize
        if max(max(color)) > 1
            color = color / 255;
        end

        if isvector(color)
            % color is a 4x1 or 3x1 vector
            if length(color) == 4
                color = vectorise(color);
            elseif length(color) == 3
                if nargin < 3
                    % default to opaque
                    color(4) = 1;
                else
                    color(4) = alpha;
                end
                color = vectorise(color);
            else
                disp('[ERROR] color vector is incorrect size')
                return
            end

        elseif ismatrix(color)
            % color is a 3 x N or 4 x N matrix
            if size(color, 1) == 3
                if nargin < 3
                    % opaque
                    color(4, :) = 1;
                else
                    color(4,:) = alpha;
                end
            elseif size(color, 1) == 4
                % do nothing
            else
                disp('[ERROR] color is not the correct dimensions')
                return
            end

        else
            disp('[ERROR] color is not the correct class')
            return
        end

    else
        disp('[ERROR] color is not the correct class')
        return
    end

    if isvector(color)
        h.MarkerHandle.EdgeColorData = uint(255*color);
        h.MarkerHandle.FaceColorData = uint(255*color);
    end

    if ismatrix(color)
        h.MarkerHandle.FaceColorBinding = 'interpolated';
        h.MarkerHandle.FaceColorData = color;
    end

end % function
