m = 8;
n = 7;

A = rand( m, n );
t = zeros( n, 1 );

[ Aout, t ] = HQR_unb_var1( A, t )

Q = FormQ_unb_var1( Aout, t );

R = triu( Aout( 1:n, : ) );

A - Q * R
