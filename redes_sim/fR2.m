function z = fR2(y_real,y_ajustado)
    yav = mean(y_real);
    s1 = sum((y_real-yav).^2);
    s2 = sum((y_real-y_ajustado).^2);
    z = 1 - s2/s1;
end