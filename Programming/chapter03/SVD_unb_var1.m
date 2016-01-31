
% Copyright 2016 The University of Texas at Austin
%
% For licensing information see
%                http://www.cs.utexas.edu/users/flame/license.html 
%                                                                                 
% Programmed by: Name of author
%                Email of author

function [ A_out, U_out, V_out ] = SVD_unb_var1( A, U, V )

  [ ATL, ATR, ...
    ABL, ABR ] = FLA_Part_2x2( A, ...
                               0, 0, 'FLA_TL' );

  [ UL, UR ] = FLA_Part_1x2( U, ...
                               0, 'FLA_LEFT' );

  [ VL, VR ] = FLA_Part_1x2( V, ...
                               0, 'FLA_LEFT' );

  while ( size( ATL, 1 ) < size( A, 1 ) )

    [ A00,  a01,     A02,  ...
      a10t, alpha11, a12t, ...
      A20,  a21,     A22 ] = FLA_Repart_2x2_to_3x3( ATL, ATR, ...
                                                    ABL, ABR, ...
                                                    1, 1, 'FLA_BR' );

    [ U0, u1, U2 ]= FLA_Repart_1x2_to_1x3( UL, UR, ...
                                         1, 'FLA_RIGHT' );

    [ V0, v1, V2 ]= FLA_Repart_1x2_to_1x3( VL, VR, ...
                                         1, 'FLA_RIGHT' );

    %------------------------------------------------------------%

    [ sigma_1, v1 ]  = Norm2_and_vector( ABR );
    

    %------------------------------------------------------------%

    [ ATL, ATR, ...
      ABL, ABR ] = FLA_Cont_with_3x3_to_2x2( A00,  a01,     A02,  ...
                                             a10t, alpha11, a12t, ...
                                             A20,  a21,     A22, ...
                                             'FLA_TL' );

    [ UL, UR ] = FLA_Cont_with_1x3_to_1x2( U0, u1, U2, ...
                                           'FLA_LEFT' );

    [ VL, VR ] = FLA_Cont_with_1x3_to_1x2( V0, v1, V2, ...
                                           'FLA_LEFT' );

  end

  A_out = [ ATL, ATR
            ABL, ABR ];

  U_out = [ UL, UR ];

  V_out = [ VL, VR ];

return

