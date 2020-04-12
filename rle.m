function [output]= rle(im)
    a=1;
    l = length(im(1,:));
    output=struct('symbol',{},'occur',{});
    output(1).symbol=im(a);
    output(1).occur=1;
    for i=1:l-1
        if(im(i)==im(i+1) && output(a).occur < 255)
                output(a).occur = output(a).occur + 1;
        else
                a=a+1;
                im(i)=im(i+1);
                output(a).symbol=im(i);
                output(a).occur=1;
        end
    end
end
  
    
