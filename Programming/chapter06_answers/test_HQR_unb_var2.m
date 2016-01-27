m = 8;
n = 7;

A = rand( m, n );
W = rand( n, n );
T = rand( n, n );
t = zeros( n, 1 );

[ Aout, t, T, W ] = HQR_unb_var2( A, t, T, W )

Q = FormQ_unb_var1( Aout, t );

R = triu( Aout( 1:n, : ) );

A - Q * R
