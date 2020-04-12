function []=writeIRM(A,map,filename)
    [l,c,p] = size(A);
    [lm,~] = size(map);
    header.l = l;
    header.c = c;
    header.lm = lm;
    header.signature = 'IR';
    [l,c,p] = size(A);
    [lm,~] = size(map);
    if (p>1)
        type = 'rgb';
    else
        if(lm>2)
            type = 'ind';
        else
            if(max(A)<2)
                type = 'bin';
            else
                type = 'grs';
            end
        end
    end
    switch(type)
        case 'rgb'%----------------------------------------------------------------------------------------
            header.type = 1;
            header.bpp = 24;
            imH = [reshape(A(:,:,1).',1,[]);reshape(A(:,:,2).',1,[]);reshape(A(:,:,3).',1,[])];
            outH = rleRGB(imH);
            imZ = zigzagRGB(A);
            outZ = rleRGB(imZ);
            imV = [reshape(A(:,:,1),1,[]);reshape(A(:,:,2),1,[]);reshape(A(:,:,3),1,[])];
            outV = rleRGB(imV);
            sz = 24*l*c;
            rh = ceil(log2(max([outH.occur])))*length(outH)+24*length(outH);
            rz = ceil(log2(max([outZ.occur])))*length(outZ)+24*length(outZ);
            rv = ceil(log2(max([outV.occur])))*length(outV)+24*length(outV);
            rh = (sz-rh)/sz;
            rz = (sz-rz)/sz;
            rv = (sz-rv)/sz;
            if(rh>rz && rh>rv)
                header.parcours = 'H';
                header.bpo = ceil(log2(max([outH.occur])));
                header.rleLength = length([outH.occur]);
                out = outH;
            elseif(rz>rh && rz>rv)
                header.parcours = 'Z';
                header.bpo = ceil(log2(max([outZ.occur])));
                header.rleLength = length([outZ.occur]);
                out = outZ;
            else
                header.parcours = 'V';
                header.bpo = ceil(log2(max([outV.occur])));
                header.rleLength = length([outV.occur]);
                out = outV;
            end
            fid = fopen(filename,'w');
            fwrite(fid,header.signature(1),'uchar');
            fwrite(fid,header.signature(2),'uchar');
            fwrite(fid,header.type,'uint8');
            fwrite(fid,header.bpp,'uint8');
            fwrite(fid,header.bpo,'uint8');
            fwrite(fid,header.parcours,'uchar');
            fwrite(fid,header.l,'uint16');
            fwrite(fid,header.c,'uint16');
            fwrite(fid,header.lm,'uint64');
            fwrite(fid,header.rleLength,'uint64');
            for i = 1:length(out)
                fwrite(fid,out(i).symbol(1),'uint8');
                fwrite(fid,out(i).symbol(2),'uint8');
                fwrite(fid,out(i).symbol(3),'uint8');
                fwrite(fid,out(i).occur,['ubit' mat2str(header.bpo)]);
            end
            fclose(fid);
        case 'ind'%----------------------------------------------------------------------------------------
            header.type = 2;
            header.bpp = ceil(log2(lm));
            imH = reshape(A.',1,[]);
            outH = rle(imH);
            imZ = zigzag(A);
            outZ = rle(imZ);
            imV = reshape(A,1,[]);
            outV = rle(imV);
            sz = header.bpp*l*c;
            rh = ceil(log2(max([outH.occur])))*length(outH)+header.bpp*length(outH);
            rz = ceil(log2(max([outZ.occur])))*length(outZ)+header.bpp*length(outZ);
            rv = ceil(log2(max([outV.occur])))*length(outV)+header.bpp*length(outV);
            rh = (sz-rh)/sz;
            rz = (sz-rz)/sz;
            rv = (sz-rv)/sz;
            if(rh>rz && rh>rv)
                header.parcours = 'H';
                header.bpo = ceil(log2(max([outH.occur])));                
                header.rleLength = length(outH);
                out = outH;
            elseif(rz>rh && rz>rv)
                header.parcours = 'Z';
                header.bpo = ceil(log2(max([outZ.occur])));
                header.rleLength = length(outZ);
                out = outZ;
            else
                header.parcours = 'V';
                header.bpo = ceil(log2(max([outV.occur])));
                header.rleLength = length(outV);
                out = outV;
            end
            fid = fopen(filename,'w');
            fwrite(fid,header.signature(1),'uchar');
            fwrite(fid,header.signature(2),'uchar');
            fwrite(fid,header.type,'uint8');
            fwrite(fid,header.bpp,'uint8');
            fwrite(fid,header.bpo,'uint8');
            fwrite(fid,header.parcours,'uchar');
            fwrite(fid,header.l,'uint16');
            fwrite(fid,header.c,'uint16');
            fwrite(fid,header.lm,'uint64');
            fwrite(fid,header.rleLength,'uint64');
            for i = 1:lm
                fwrite(fid,map(i,1)*255,'ubit8');
                fwrite(fid,map(i,2)*255,'ubit8');
                fwrite(fid,map(i,3)*255,'ubit8');
            end
            for i = 1:length(out)
                fwrite(fid,out(i).symbol,['ubit' mat2str(header.bpp)]);
                fwrite(fid,out(i).occur,['ubit' mat2str(header.bpo)]);
            end
            fclose(fid);    
            
        case 'grs'%----------------------------------------------------------------------------------------
            header.type = 3;
            header.bpp = 8;
            imH = reshape(A.',1,[]);
            outH = rle(imH);
            imZ = zigzag(A);
            outZ = rle(imZ);
            imV = reshape(A,1,[]);
            outV = rle(imV);
            sz = header.bpp*l*c;
            rh = ceil(log2(max([outH.occur])))*length(outH)+header.bpp*length(outH);
            rz = ceil(log2(max([outZ.occur])))*length(outZ)+header.bpp*length(outZ);
            rv = ceil(log2(max([outV.occur])))*length(outV)+header.bpp*length(outV);
            rh = (sz-rh)/sz;
            rz = (sz-rz)/sz;
            rv = (sz-rv)/sz;
            if(rh>rz && rh>rv)
                header.parcours = 'H';
                header.bpo = ceil(log2(max([outH.occur])));
                out = outH;
                header.rleLength = length(outH);
            elseif(rz>rh && rz>rv)
                header.parcours = 'Z';
                header.bpo = ceil(log2(max([outZ.occur])));
                out = outZ;
                header.rleLength = length(outZ);
            else
                header.parcours = 'V';
                header.bpo = ceil(log2(max([outV.occur])));
                out = outV;
                header.rleLength = length(outV);
            end
            fid = fopen(filename,'w');
            fwrite(fid,header.signature(1),'uchar');
            fwrite(fid,header.signature(2),'uchar');
            fwrite(fid,header.type,'uint8');
            fwrite(fid,header.bpp,'uint8');
            fwrite(fid,header.bpo,'uint8');
            fwrite(fid,header.parcours,'uchar');
            fwrite(fid,header.l,'uint16');
            fwrite(fid,header.c,'uint16');
            fwrite(fid,header.lm,'uint64');
            fwrite(fid,header.rleLength,'uint64');
            for i = 1:length(out)
                fwrite(fid,out(i).symbol,'uint8');
                fwrite(fid,out(i).occur,['ubit' mat2str(header.bpo)]);
            end
            fclose(fid);
        case 'bin'
            header.type = 4;
            header.bpp = 0;
            imH = reshape(A.',1,[]);
            outH = rle(imH);
            imZ = zigzag(A);
            outZ = rle(imZ);
            imV = reshape(A,1,[]);
            outV = rle(imV);
            sz = l*c;
            rh = ceil(log2(max([outH.occur])))*length(outH)+length(outH);
            rz = ceil(log2(max([outZ.occur])))*length(outZ)+length(outZ);
            rv = ceil(log2(max([outV.occur])))*length(outV)+length(outV);
            rh = (sz-rh)/sz;
            rz = (sz-rz)/sz;
            rv = (sz-rv)/sz;
            if(rh>rz && rh>rv)
                header.parcours = 'H';
                header.bpo = ceil(log2(max([outH.occur])));
                out = outH;
                header.rleLength = length(outH);
            elseif(rz>rh && rz>rv)
                header.parcours = 'Z';
                header.bpo = ceil(log2(max([outZ.occur])));
                out = outZ;
                header.rleLength = length(outZ);
            else
                header.parcour = 'V';
                header.bpo = ceil(log2(max([outV.occur])));
                out = outV;
                header.rleLength = length(outV);
            end
            fid = fopen(filename,'w');
            fwrite(fid,header.signature(1),'uchar');
            fwrite(fid,header.signature(2),'uchar');
            fwrite(fid,header.type,'uint8');
            fwrite(fid,header.bpp,'uint8');
            fwrite(fid,header.bpo,'uint8');
            fwrite(fid,header.parcours,'uchar');
            fwrite(fid,header.l,'uint16');
            fwrite(fid,header.c,'uint16');
            fwrite(fid,header.lm,'uint64');
            fwrite(fid,header.rleLength,'uint64');
            for i = 1:header.rleLength
                fwrite(fid,out(i).symbol,'ubit1');
                fwrite(fid,out(i).occur,['ubit' mat2str(header.bpo)]);
            end
            
    end
end
    