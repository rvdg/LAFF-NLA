function T = HQR_Form_T( U, t )

T = triu( trilu( U )' * trilu( U ), 1 ) + diag( t );

return
