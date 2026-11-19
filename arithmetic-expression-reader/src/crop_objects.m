function crops = crop_objects(img, regions)
%CROP_OBJECTS Crops each region of img using its bounding box.
    crops = cell(1, numel(regions));
    for i = 1:numel(regions)
        crops{i} = imcrop(img, regions(i).BoundingBox);
    end
end
