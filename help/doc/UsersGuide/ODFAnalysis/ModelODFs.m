%% Model ODFs
% Describes how to define model ODFs in MTEX, i.e., uniform ODFs, unimodal
% ODFs, fibre ODFs, Bingham ODFs and ODFs defined by its
% Fourier coefficients. 
%
%% Open in Editor
%
%% Contents
%

%% Introduction
%
% MTEX provides a very simple way to define model ODFs. Generally, there are
% five types to descripe an ODF in MTEX:
% 
% * uniform ODF
% * unimodal ODF
% * fibre ODF
% * Bingham ODF
% * Fourier ODF
%
% The central idea is that MTEX allows you to calculate mixture models, by
% adding and subtracting arbitary ODFs. Model ODFs may be used as
% references for ODFs estimated from pole figure data or EBSD data and are
% instrumental for <PoleFigureSimulation_demo.html pole figure simulations>
% and <EBSDSimulation_demo.html sinle orientation simulations>. These
% relationships are visualized in the following chart.
%
% <<odf.png>>

%% The Uniform ODF
%
% The most simplest case of a model ODF is the uniform ODF
%
% $$f(g) = 1,\quad  g \in SO(3),$$
%
% which is everywhere identical to one. In order to define a uniform ODF
% one needs only to specify its crystal and specimen symmetry and to use
% the command [[uniformODF.html,uniformODF]].

cs = symmetry('cubic');
ss = symmetry('orthorhombic');
odf = uniformODF(cs,ss)

%% Unimodal ODFs
% An unimodal ODF
%
% $$f(g; x) = \psi (\angle(g,x)),\quad g \in SO(3),$$
%
% is specified by a <kernel_index.html radially symmetrial function> $\psi$
% centered at a modal <orientation_index.html orientation>, $x\in SO(3)$
% and. In order to define a unimodal ODF one needs
%
% * a preferred <orientation_index.html orientation> mod1
% * a <kernel_index.html kernel> function *psi* defining the shape
% * the crystal and specimen <symmetry_index.html symmetry>

x = orientation('Miller',[1,2,2],[2,2,1],cs,ss);
psi = kernel('von Mises Fisher','HALFWIDTH',10*degree);
odf = unimodalODF(x,cs,ss,psi)

plotpdf(odf,[Miller(1,0,0),Miller(1,1,0)],'antipodal')

%%
% For simplicity one can also ommit the kernel function. In this case the
% default de la Vallee Poussin kernel is choosen with halfwidth of 10 degree.


%% Fibre ODFs
% A fibre is a rotation mapping a <Miller_index.html crystal direction> $h
% \in S^2$ onto a <vector3d_index.html specimen direction> $r \in S^2$,
% i.e.
%
% $$g*h = r.$$
%
% A fibre ODF may be writte as
%
% $$f(g; h,r) = \psi(\angle(g*h,r)),\quad g \in SO(3),$$
%
% with an arbitary <kernel_index.html radially symmetrial
% function> $\psi$. In order to define a fibre ODF one needs
%
% * a <Miller_index.html crystal direction> *h0*
% * a <vector3d_index.html specimen direction> *r0*
% * a <kernel_index.html kernel> function *psi* defining the shape
% * the crystal and specimen <symmetry_index.html symmetry>

h = Miller(0,0,1);
r = xvector;
odf = fibreODF(h,r,cs,ss,psi)

plotpdf(odf,[Miller(1,0,0),Miller(1,1,0)],'antipodal')

%% ODFs given by Fourier coefficients
%
% In order to define a ODF by it *Fourier coefficients* the Fourier
% coefficients *C* has to be give as a literaly ordered, complex valued
% vector of the form
%
% $$ C = [C_0,C_1^{-1-1},\ldots,C_1^{11},C_2^{-2-2},\ldots,C_L^{LL}] $$
%
% where $l=0,\ldots,L$ denotes the order of the Fourier coefficients.

cs   = symmetry('triclinic');    % crystal symmetry
ss   = symmetry('triclinic');    % specimen symmetry
C = [1;reshape(eye(3),[],1);reshape(eye(5),[],1)]; % Fourier coefficients
odf = FourierODF(C,cs,ss)

plot(odf,'sections',6,'alpha','projection','plain')

%%

plotpdf(odf,[Miller(1,0,0),Miller(1,1,0)],'antipodal')

%% Bingham ODFs
%
% The Bingham quaternion distribution  
%
% $$f(g; A,\kappa) = \frac{1}{_1F_1(\frac{1}{2};2;\kappa)} \exp( g^T U^T K U g),\quad g \in S^3$$ 
%
% has a (4x4)-orthogonal matrix $U$ and shape parameters $K$ as
% argument. The (4x4) matrix can be interpreted as 4 orthogonal
% <quaternion_index.html quaternions> $u_{1,..,4}$, where the
% $k_{1,..,4}$ allow different shapes, e.g.
%
% * unimodal ODFs
% * fibre ODF
% * spherical ODFs
%
% A Bingham distribution is characterized by
%
% * four <orientation_index.html orientations>
% * four values lambda
%

cs = symmetry('-3m');
ss = symmetry('-1');

%%
% *Bingham unimodal ODF*

% a modal orientation
mod = orientation('Euler',45*degree,0*degree,0*degree);

% the corresponding Bingham ODF
odf = BinghamODF(20,mod * quaternion(eye(4)),cs,ss)

plot(odf,'sections',6,'silent')

%%
% *Bingham fibre ODF*

odf = BinghamODF([-10,-10,10,10],quaternion(eye(4)),cs,ss)

plot(odf,'sections',6,'silent')

%%
% *Bingham spherical ODF*

odf = BinghamODF([-10,10,10,10],quaternion(eye(4)),cs,ss)

plot(odf,'sections',6,'silent');

%% Combining model ODFs
% All the above can be arbitrarily rotated and combinend. For instance, the
% classical Santafe example can be defined by commands

cs = symmetry('cubic');
ss = symmetry('orthorhombic');

psi = kernel('von Mises Fisher','HALFWIDTH',10*degree);
mod1 = orientation('Miller',[1,2,2],[2,2,1],cs,ss);

odf =  0.73 * uniformODF(cs,ss,'comment','the SantaFe-sample ODF') ...
  + 0.27 * unimodalODF(mod1,cs,ss,psi)

close all
plotpdf(odf,[Miller(1,0,0),Miller(1,1,0)],'antipodal')
