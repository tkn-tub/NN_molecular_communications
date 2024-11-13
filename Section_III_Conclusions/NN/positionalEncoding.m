function posEncoding = positionalEncoding(sequence_length, d_model)
    pos = (0:sequence_length-1)';
    i = (0:d_model-1);
    angle_rates = 1 ./ (10000 .^ (2 * floor(i/2) / d_model));
    posEncoding = pos * angle_rates;
    posEncoding(:, 1:2:end) = sin(posEncoding(:, 1:2:end));
    posEncoding(:, 2:2:end) = cos(posEncoding(:, 2:2:end));
    posEncoding = posEncoding';
end