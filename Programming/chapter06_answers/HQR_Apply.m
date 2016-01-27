function [ B1, ...
           B2 ] = HQR_Apply( T, U1, B1, ...
                                U2, B2 )
                            
[ m_T, n_T ] = size( T );

T = T( :, 1:m_T );

U1 = trilu( U1 );

Wt = T' \ ( U1' * B1 + U2' * B2 );

B1 = B1 - U1 * Wt;
B2 = B2 - U2 * Wt;

end