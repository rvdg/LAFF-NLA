m = 8;
n = 7;

A = rand( m, n );
W = rand( n, n );
T = rand( n, n );
t = zeros( n, 1 );

[ QR, t ] = HQR_blk_var3( A, t, 3 );

Q = FormQ( QR, t );

R = triu( QR( 1:n, : ) );

A - Q * R
