%%Creating Terrain
function terrain_map = generate_terrain()
num_el = 400; 
x = linspace(-100, 100, num_el); %defining x values for the terrain line using num_el

D = 0.9;
freq_ratio = 1.5;
w0 = 0.09;
amp = 5; 
n = (0:9)';%D,freq,w,amp and n are constants needed to make the line. 
phi = 2 * pi * rand(numel(n), 1); %phase offsets of phi are randomly generated with n and rand in the same size as numel(n). The phi will be used with cos to get height to plot the terrain line.
height = amp * sum(freq_ratio.^((D - 2) * n) .* cos(w0 * freq_ratio.^n * x + phi), 1); %height is found as a vector aligned with x.
terrain_map = [x(:), height(:)]; %Storing terrain as 2 columns for x and height.

%Plotting and Adding Area Colors to Terrain:
figure
area(x, height, 'FaceColor',[0.65 0.33 0.18 ], 'EdgeColor', 'none') %Adding solid brown color (defined in the brackets) to the area under the terrain line (defined by x,height) using the "area" and "facecolor" functions. "Edgecolor" "None" prevents gridlines from showing up.
hold on %"hold on" added so that the 'sky' color layer can be added to the plot.

max_height = max(height); %setting a height limit to align with computed 'height' above/make adding colors to area easier.
%Making a gradient for the background sky color (area above the terrain
%line):
nGrad = 256; %MATLAB "Fill" and "patch" functions can only interpolate between corner vertices. We need to make a really fine grid to get a gradient. nGrad defines total number of points to generate and interpolate between, aka a 256 step/resolution color gradient. 256 makes it look smooth.
t = linspace(0, 1, nGrad).'; %t is a column of values from from 0 to 1 and will be our vertical interpolation parameter. It represents the vertical position along the color gradient points (with t=0 intended to be at the terrain line and t=1 be at the max_height) and will be used to get the y color fill values later.
xFill = repmat(x, nGrad, 1); %The "repmat" function copies our row vector x an nGrad number times vertically and 1 time horizontally, so every row stacked on top of each other is the same x array (because we need to expand the 1xN row vector to 256xN grid).  Every column is a horizontal location, repeated 256 times vertically for each of our color steps. This makes each gradient layer aligns with the x values of the terrain line horizontally.
yFill = height + (max_height - height) .* t; %yFill calculates the y coordinate for all the points in the 256xN grid from xFill.The (max_height-height) part finds the vertical distance at each x point from the terrain line height to the top boundary. The ".*t" part multiplies the distances by the 256x1 t grid, making the corresponding 256xN heights. Adding "height" to all this at the beginning shifts all values up so that t=0 sits on the terrain line(so only the area above it gets the gradient).

hFill = surface(xFill, yFill, zeros(size(yFill)), yFill);%creates a 3D grid with the xfill and yfill coordinates above, so the z coordinate is removed using zeros(size(yFill)). yFill as the last argument tells MATLAB to get the color of every vertex from its y value when color map is used.
set(hFill, 'FaceColor', 'interp', 'EdgeColor', 'none')%This part smoothes the gradient with 'interp' and 'facecolor' (colors are interpolated across the faces of the mesh instead of coloring each grid cell a solid color). Setting "edgecolor" to "none"  makes sure the grid lines don't show up on the final plot.

cmap = [linspace(1, 1, nGrad)', linspace(0, 1, nGrad)', zeros(nGrad, 1)]; %Color arguments are set here to be used with colormap function below. To get the right vibe for a "Burned Planet" tank game we're going to blend red and yellow to make the sky have fire colors.Pure red is [1 0 0] and pure yellow is [1 1 0] with the 3 columns representing RGB (ex. [1 0 0] for red is 1 (full red), 0 (no green), 0 (no blue)). We're trying to make it go from yellow at the top (max_height) to more red/orange at the bottom. To do this a 256xRGB matrix is set up with linspace(1,1,nGrad)' for red, linspace(0,1,nGrad)' for yellow (from green), and  zeros(nGrad,1) for blue (no blue wanted). 
colormap(cmap) %applying the gradient coloring defined above using colormap function.
caxis([min(height) max_height]) %Limiting the plot so it stays in the right area/still goes down to the low points of the terrain line.
 
plot(x, height, 'k', 'LineWidth', 1.5)%plotting the terrain line border
ylim([0, max_height])%limiting y axis so only values above 0 are plotted (cannot have negative ground).
view(2)
hold off  
end

