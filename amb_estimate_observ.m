function [N_stim, sigmaq_N_stim] = amb_estimate_observ(pr_Rsat, pr_Msat, ...
         ph_Rsat, ph_Msat, pivot, sat, phase)

% SYNTAX:
%   [N_stim, sigmaq_N_stim] = amb_estimate_observ(pr_Rsat, pr_Msat, ...
%   ph_Rsat, ph_Msat, pivot, sat, phase);
%
% INPUT:
%   pr_Rsat = ROVER-SATELLITE code-pseudorange
%   pr_Msat = MASTER-SATELLITE code-pseudorange
%   ph_Rsat = ROVER-SATELLITE phase-pseudorange
%   ph_Msat = MASTER-SATELLITE phase-pseudorange
%   pivot = pivot satellite
%   sat = configuration of satellites in view
%   phase = carrier L1 (phase=1), carrier L2 (phase=2)
%
% OUTPUT:
%   N_stim = linear combination ambiguity estimate
%   sigmaq_N_stim = assessed variances of combined ambiguity
%
% DESCRIPTION:
%   Estimation of phase ambiguities (and of their error variance) by
%   using both phase and code observations (satellite-receiver distance).

%----------------------------------------------------------------------------------------------
%                           goGPS v0.1.3 alpha
%
% Copyright (C) 2009-2011 Mirko Reguzzoni, Eugenio Realini
%----------------------------------------------------------------------------------------------
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%----------------------------------------------------------------------------------------------

%variables initialization
global lambda1
global lambda2
global sigmaq_cod1

%PIVOT position research
i = find(pivot == sat);

%pivot code observations
pr_RP = pr_Rsat(i);
pr_MP = pr_Msat(i);

%pivot phase observations
ph_RP = ph_Rsat(i);
ph_MP = ph_Msat(i);

%observed code double differences
comb_pr = (pr_Rsat - pr_Msat) - (pr_RP - pr_MP);

%observed phase double differences
comb_ph = (ph_Rsat - ph_Msat) - (ph_RP - ph_MP);

%linear combination of initial ambiguity estimate
if (phase == 1)
    N_stim = ((comb_pr - comb_ph * lambda1)) / lambda1;
    sigmaq_N_stim = 4*sigmaq_cod1 / lambda1^2;
else
    N_stim = ((comb_pr - comb_ph * lambda2)) / lambda2;
    sigmaq_N_stim = 4*sigmaq_cod1 / lambda2^2;
end