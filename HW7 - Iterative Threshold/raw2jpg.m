function   raw2jpg(infilename,outfilename,ncols,nrows)

fid = fopen(infilename,'rb');

[x,count] = fread(fid, [ncols,nrows],'uchar');
if (count ~= (nrows*ncols) )
  error('dimensions dont match file contents---load aborted');
end
fclose(fid);     

imwrite(x'/256,outfilename,'jpg');

