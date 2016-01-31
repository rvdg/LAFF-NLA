function [ sigma, v ] = Norm2_and_vector( A )

    [ U, S, V ] = svd( A );
    sigma = S(1,1);
    v = V(:,1);

end

