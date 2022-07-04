# mld_agu2014
Calculating MLD using stratifiation 

This code was developed specifically for some calculations done for AGU 2014. With the exception of the I/O, it should be generally applicable 

## Pseudo-code idea

#### 1.) Choose a density threshold
To calculate the mixed layer depth from stratification, first choose a density threshold:
```% Critical density difference (kg/m^3)
delta_rho_crit = 0.03;
```
#### 2.) Calculate $\Delta\rho$
Next, calculate `delta_rho`, which is the difference between the surface density and the subsurface density at each grid cell. It will have a value of `0.0` in the top grid cell:
```% Initialize
delta_rho = zeros(size(DRHODR));

% Iterate over the depth levels
for k=2:size(DZ,3)
    delta_rho(:,:,k) = nansum(-1.0.*DRHODR(:,:,1:k).*...
                                     DZ(:,:,1:k),3);
end
```
#### 3.) Estiamte depth where $\Delta\rho$ meets the threshold criterion
Now use a "locate" function to find the grid cell wherein the density difference exceeds the threshold chosen above. Finally, use linear interpolation to estimate the depth within that grid cell where the difference exceeds the threshold.
```
% Select a column indexed by (i,j)
col = delta_rho(i,j,:);

% Locate grid values
ii = nanlocate(col,delta_rho_crit);  

% If value not found, set mld to NaN. Otherwise, interpolate to find depth where threshold met
if (ii==length(col) || ii==0)

    mld(i,j) = NaN;

else

    % Linearly interpolate to find mld
    dzdsig = (z(ii+1)-z(ii))./(col(ii+1)-col(ii));
    mld(i,j) = z(ii) + dzdsig.*(delta_rho_crit - col(ii));

end
```

NOTE: the above only works if the density monotonically increases with depth! Some preprocessing may be needed.
