function [y,map] = readIRM(filename)
    map = [];
    y=[];
    fid = fopen(filename,'r');
    header.signature = fread(fid,2,'*char');
    header.signature = [header.signature(1) header.signature(2)];
    header.type = fread(fid,1,'uint8');
    header.bpp = fread(fid,1,'uint8');
    header.bpo = fread(fid,1,'uint8');
    header.parcours = fread(fid,1,'*char');
    header.l = fread(fid,1,'uint16');
    header.c = fread(fid,1,'uint16');
    header.lm = fread(fid,1,'uint64');
    header.rleLength = fread(fid,1,'uint64');
    switch header.type
        case 1
            A = zeros(3,header.l*header.c,'uint8');
            a = 1;
            for i = 1:header.rleLength
                pixel = zeros(3,1,'uint8');
                pixel(1) = fread(fid,1,'uint8');
                pixel(2) = fread(fid,1,'uint8');
                pixel(3) = fread(fid,1,'uint8');
                occ = fread(fid,1,['ubit' mat2str(header.bpo)]);
                for j = 1:occ
                    A(:,a) = pixel;
                    a = a+1;
                end
            end
            switch header.parcours
                case 'H'
                    y = zeros(header.l,header.c,3,'uint8');
                    for i = 1:3
                        c=1;
                        for j = 1:header.l
                            y(j,:,i) = A(i,c:c+header.c-1);
                            c = c + header.c;
                        end
                    end
                case 'V'
                    y(:,:,1) = reshape(A(1,:),header.l,[]);
                    y(:,:,2) = reshape(A(2,:),header.l,[]);
                    y(:,:,3) = reshape(A(3,:),header.l,[]);
                case 'Z'
                    y = antizigzag([A(1,:) A(2,:) A(3,:)],header.l,header.c,3);
            end
        case 2
            map = zeros(header.lm,3);
            for i = 1:header.lm
                map(i,1) = fread(fid,1,'uint8')/255;
                map(i,2) = fread(fid,1,'uint8')/255;
                map(i,3) = fread(fid,1,'uint8')/255;
            end
            A = zeros(1,header.l*header.c,'uint8');
            a = 1;
            for i = 1:header.rleLength
                pixel = fread(fid,1,['ubit' mat2str(header.bpp)]);
                occ = fread(fid,1,['ubit' mat2str(header.bpo)]);
                for j = 1:occ
                    A(a) = pixel;
                    a = a+1;
                end
            end
            switch header.parcours
                case 'H'
                    y = zeros(header.l,header.c,'uint8');
                    c=1;
                    for j = 1:header.l
                        y(j,:) = A(c:c+header.c-1);
                        c = c + header.c;
                    end
                case 'V'
                    y(:,:) = reshape(A(:),header.l,[]);
                case 'Z'
                    y = antizigzag(A(:),header.l,header.c,1);
            end
        case 3
            A = zeros(1,header.l*header.c,'uint8');
            a = 1;
            for i = 1:header.rleLength
                pixel = fread(fid,1,'uint8');
                occ = fread(fid,1,['ubit' mat2str(header.bpo)]);
                for j = 1:occ
                    A(a) = pixel;
                    a = a+1;
                end
            end
            switch header.parcours
                case 'H'
                    y = zeros(header.l,header.c,'uint8');
                    c=1;
                    for j = 1:header.l
                        y(j,:) = A(c:c+header.c-1);
                        c = c + header.c;
                    end
                case 'V'
                    y(:,:) = reshape(A(:),header.l,[]);
                case 'Z'
                    y = antizigzag(A(:),header.l,header.c,1);
            end
        case 4 
            A = zeros(1,header.l*header.c,'logical');
            a = 1;
            for i = 1:header.rleLength
                pixel = fread(fid,1,'ubit1') && true;
                occ = fread(fid,1,['ubit' mat2str(header.bpo)]);
                for j = 1:occ
                    A(a) = pixel;
                    a = a+1;
                end
            end
            switch header.parcours
                case 'H'
                    y = zeros(header.l,header.c,'logical');
                    c=1;
                    for j = 1:header.l
                        y(j,:) = A(c:c+header.c-1);
                        c = c + header.c;
                    end
                case 'V'
                    y(:,:) = reshape(A(:),header.l,[]);
                case 'Z'
                    y = antizigzag(A(:),header.l,header.c,1);
            end
    end
    fclose(fid);
end