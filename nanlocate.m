function k = nanlocate(xx,x)
% function B = nanlocate(xx,x)
%
% A version of locate that can handle NaN (calls the original locate)
%
% INPUT:
%	xx = a monotonic vector to be searched through
%	x = desired value to search for
%
% OUTPUT:
%	k = index such that x is between xx(k) and xx(k+1)
%

nan_locations = find(isnan(xx));

	% handle the different cases for nan_locations
	if (numel(nan_locations) == 0)

		% if there are no NaNs, run locate normally
		k = locate(xx,x);

	elseif (numel(nan_locations) == length(xx))

		% if nothing but NaNs
		k = 0;

	elseif (numel(nan_locations) > 0)

		% only run locate up to the first NaN
		nan_index = nan_locations(1);
		yy = squeeze(xx(1:nan_index-1));
		k0 = locate(yy,x);

		if k0 == length(yy)

			k = length(xx);

		else

			k = k0;

		end

	else

		k = 0;

	end
	
end
