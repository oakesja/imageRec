function [ xCorners, yCorners ] = findCorners( mask, xCentroid, yCentroid )
[rows, columns] = find(mask);
xCorners = [0 0 0 0]; % X coordinate of corners in each quadrant.
yCorners = [0 0 0 0]; % X coordinate of corners in each quadrant.
maxDistance = [0 0 0 0]; % Distance of furthers X coordinate from centroid in each quadrant.
for k = 1 : length(columns)
	rowk = rows(k);
	colk = columns(k);
	distanceSquared = (colk - xCentroid)^2 + (rowk - yCentroid)^2;
	if rowk < yCentroid
		% It's in the top half
		if colk < xCentroid
			% It's in the upper left quadrant
			if distanceSquared > maxDistance(1)
				% Record the new furthest point in quadrant #1.
				maxDistance(1) = distanceSquared;
				xCorners(1) = colk;
				yCorners(1) = rowk;
			end
		else
			% It's in the upper right quadrant
			if distanceSquared > maxDistance(2)
				% Record the new furthest point in quadrant #2.
				maxDistance(2) = distanceSquared;
				xCorners(2) = colk;
				yCorners(2) = rowk;
			end
		end
	else
		% It's in the bottom half.
		if colk < xCentroid
			% It's in the lower left quadrant
			if distanceSquared > maxDistance(3)
				% Record the new furthest point in quadrant #3.
				maxDistance(3) = distanceSquared;
				xCorners(3) = colk;
				yCorners(3) = rowk;
			end
		else
			% It's in the lower right quadrant
			if distanceSquared > maxDistance(4)
				% Record the new furthest point in quadrant #4.
				maxDistance(4) = distanceSquared;
				xCorners(4) = colk;
				yCorners(4) = rowk;
			end
		end
	end
end

end

