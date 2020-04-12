function [output] = rleRGB(im)
    l = length(im(1,:));
    output=struct('symbol',{},'occur',{});
    output(1).symbol=[im(1,1) im(2,1) im(3,1)];
    output(1).occur=1;
    a=1;
    for i=1:l-1
        if(im(1,i)==im(1,i+1) && im(2,i)==im(2,i+1) && im(3,i)==im(3,i+1) && output(a).occur < 255 )
                output(a).occur = output(a).occur + 1;
        else
                a=a+1;
                im(:,i)=im(:,i+1);
                output(a).symbol=[im(1,i) im(2,i) im(3,i)];
                output(a).occur=1;
        end
    end
end