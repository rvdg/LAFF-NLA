function [ A_out, R_out ] = CGS_unb_var1( A, R )

  [ AL, AR ] = FLA_Part_1x2( A, ...
                               0, 'FLA_LEFT' );

  [ RTL, RTR, ...
    RBL, RBR ] = FLA_Part_2x2( R, ...
                               0, 0, 'FLA_TL' );

  while ( size( AL, 2 ) < size( A, 2 ) )

    [ A0, a1, A2 ]= FLA_Repart_1x2_to_1x3( AL, AR, ...
                                         1, 'FLA_RIGHT' );

    [ R00,  r01,   R02,  ...
      r10t, rho11, r12t, ...
      R20,  r21,   R22 ] = FLA_Repart_2x2_to_3x3( RTL, RTR, ...
                                                  RBL, RBR, ...
                                                  1, 1, 'FLA_BR' );

    %------------------------------------------------------------%

    % r01 = A0' * a1;
    r01 = laff_gemv( 'Transpose', 1, A0, a1, 0, r01 );
   
    % a1 = a1 - A0 * r01;
    a1 = laff_gemv( 'No transpose', -1, A0, r01, 1, a1 );
    
    %rho11 = norm( a1 );
    rho11 = laff_norm2( a1 );
    
    % a1 = a1 / rho11;
    a1 = laff_invscal( rho11, a1 );
    
    %------------------------------------------------------------%

    [ AL, AR ] = FLA_Cont_with_1x3_to_1x2( A0, a1, A2, ...
                                           'FLA_LEFT' );

    [ RTL, RTR, ...
      RBL, RBR ] = FLA_Cont_with_3x3_to_2x2( R00,  r01,   R02,  ...
                                             r10t, rho11, r12t, ...
                                             R20,  r21,   R22, ...
                                             'FLA_TL' );

  end

  A_out = [ AL, AR ];

  R_out = [ RTL, RTR
            RBL, RBR ];

return
