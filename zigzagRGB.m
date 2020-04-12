function [z]=zigzagRGB(M)
    p1 = zigzag(M(:,:,1));
    p2 = zigzag(M(:,:,2));
    p3 = zigzag(M(:,:,3));
    z= [p1;p2;p3];
end
