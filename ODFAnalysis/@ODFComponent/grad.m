function g = grad(component,ori,varargin)
% gradient at orientation g
%
% Syntax
%   g = grad(component,ori)
%
% Input
%  component - @unimodalComponent
%  ori - @orientation
%
% Output
%  g - @vector3d
%

delta = get_option(varargin,'delta',1*degree);

rot = rotation('axis',[xvector,yvector,zvector],'angle',delta/2);

%f = component.eval([ori(:),(rot*ori).']);
f = component.eval([ori*inv(rot),ori*rot]);

g = vector3d(f(:,4)-f(:,1),f(:,5)-f(:,2),f(:,6)-f(:,3)) ./ delta;