function pix = pixelize(datain_all, intens, box, nx, ny, namefile, showplot)

% pix = pixelize(datain_all, intens, box, nx, ny, namefile)
% pixelize PALM data
% datain_all - input data, #points-by-2 matrix, each row correspond to xy
% coordinate of the datapoint
% intens - intensities of each center (stored in a0_phot)
% box = [xlim1, xlim2, ylim1, ylim2] - selected ROI 
% nx - number of pixels in x direction 
% ny - number of pixels in y direction 
% namefile - (optional) name of the TXT file with matrix pix
if ~exist ('showplot', 'var')
    showplot = 1;
end

sx = (box(2)-box(1))/nx; %size of the pixels
sy = (box(4)-box(3))/ny;

datain = ROIdata (datain_all, box(1), box(2), box(3),  box(4), showplot);

pixvec = ceil ([(datain(:,1) - box(1))/sx , (datain(:,2) - box(3))/sy ]);

% indrem_min = find (or(pixvec(:,1) < 0, pixvec(:,2) < 0));
% indrem_max = find (or(pixvec(:,1) > nx, pixvec(:,2) > ny));


pix = zeros(nx, ny);
for ii=1 : size(datain, 1)
    coord = [pixvec(ii,1), pixvec(ii,2)];
    pix(coord(1), coord(2)) = pix (coord(1), coord(2)) + intens(ii);
end

pix = flipud(pix'); % to follow the matlab notation for imagesc(pix)...

if ~exist ('showplot', 'var')
    showplot = 1;
end
    
if showplot
    figure
    imagesc(pix)
    set (gca, 'DataAspectRatio',[sy sx 1]);
end

if exist('namefile', 'var')
    if ~isempty(namefile)
        fid = fopen([namefile '.txt'], 'wt'); % Open for writing
        for i=1:size(pix,1)
            fprintf(fid, '%d ', pix(i,:));
            fprintf(fid, '\n');
        end
        fclose(fid);
    end
end