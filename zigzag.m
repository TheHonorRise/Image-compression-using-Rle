function [z]=zigzag(M)
    z=[];
    [L,C,P]=size(M);
    for i=1:P
        c=flip(M(:,:,i));
        if(mod(L,2)==0)
            for i=-L+1:C-1
                if(mod(i,2)~=0)
                    z=[z diag(c,i).'];
                else
                    z=[z flip(diag(c,i)).'];
                end
            end
        else
            for i=-L+1:C-1
                if(mod(i,2)==0)
                    z=[z diag(c,i).'];
                else
                    z=[z flip(diag(c,i)).'];
                end
            end
        end
    end
end

            
            
            
            

        

