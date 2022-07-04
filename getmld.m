function mld = getmld(z,delta_rho,delta_rho_crit)

    % Declare array
    mld = NaN([size(delta_rho,1) size(delta_rho,2)]);

    % Create and impose land mask
    land_mask = isnan(delta_rho);
    delta_rho(land_mask) = NaN;    

    % Calculate based of mixed layer
    for i=1:size(delta_rho,1)

        for j=1:size(delta_rho,2)

            % Select a column
	    col = delta_rho(i,j,:);
            
            % If not monotonic, make it so
            %if ~is_monotonic_increase(col)
            %    col = monreg(col);
            %end

            % Locate grid values
            ii = nanlocate(col,delta_rho_crit);  

            % If value not found, set mld to NaN, 
            % otherwise interpolate to find depth
            if (ii==length(col) || ii==0)

                mld(i,j) = NaN;

            else

                % Linearly interpolate to find mld
                dzdsig = (z(ii+1)-z(ii))./(col(ii+1)-col(ii));
                mld(i,j) = z(ii) + dzdsig.*(delta_rho_crit - col(ii));

            end

	end

    end

end
