/**********************************************************************************
* imageproc.c
* Usage: imageproc in_file_name out_file_name width height
 **********************************************************************************/


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "CImg.h"
using namespace cimg_library;

int main(int argc, char *argv[])
{
	FILE  *in, *out;
	int   j, k, width, height;
	int ** image_in, ** image_out;
	float sum1, sum2;
	float new_T, old_T, delta_T;
	long count1, count2;


	if(argc<5) { printf("ERROR: Insufficient parameters!\n"); return(1);}

	width = atoi(argv[3]);
	height = atoi(argv[4]);

	image_in = (int**) calloc(height, sizeof(int*));
	if(!image_in)
	{
		printf("Error: Can't allocate memmory!\n");
		return(1);
	}

	image_out = (int**) calloc(height, sizeof(int*));
	if(!image_out)
	{
		printf("Error: Can't allocate memmory!\n");
		return(1);
	}

	for (j=0; j<height; j++)
	{
		image_in[j] = (int *) calloc(width, sizeof(int));
		if(!image_in[j])
		{
			printf("Error: Can't allocate memmory!\n");
			return(1);
		}

		image_out[j] = (int *) calloc(width, sizeof(int));
		if(!image_out[j])
		{
			printf("Error: Can't allocate memmory!\n");
			return(1);
		}

	}

	if((in=fopen(argv[1],"rb"))==NULL)
	{
		printf("ERROR: Can't open in_file!\n");
		return(1);
	}

	if((out=fopen(argv[2],"wb"))==NULL)
	{
		printf("ERROR: Can't open out_file!\n");
		return(1);
	}

	for (j=0; j<height; j++)
		for (k=0; k<width; k++)
	    	{
			if((image_in[j][k]=getc(in))==EOF)
			{
				printf("ERROR: Can't read from in_file!\n");
				return(1);
		      }
	    	}
      if(fclose(in)==EOF)
	{
		printf("ERROR: Can't close in_file!\n");
		return(1);
	}

	/* display image_in */
	CImg<int> image_disp(width, height,1,1,0);
	/* CImg<type> image_name(width,height,temporal_frame_number,color_plane_number,initial_value) */

	for (j=0; j<height; j++)
		for (k=0; k<width; k++)
	   	{
			image_disp(k,j,0,0) = image_in[j][k];
		}
	CImgDisplay disp_in(image_disp,"Image_In",0);
	/* CImgDisplay display_name(image_displayed, "window title", normalization_factor) */


/********************************************************************/
/* Image Processing begins                                          */
/********************************************************************/

// This code was developed on 15 November 2018 by C. Drew and P. Brine
// working together (to get unstuck) in B123.
//I pledge my honor that I have abided by the Stevens Honor System.
//-- Peter Brine & C. Drew

float histogram[256];				// counting buffer for the histogram
float eqTransfer[256];			// transfer function for histogram equalization

for (j=0; j<256; j++)				// setting initial values to 0.0
	{
		histogram[j] = 0.0;
	}

for (j=0; j<256; j++)				// setting initial values to 0.0
	{
		eqTransfer[j] = 0.0;
	}

// This for-loop is to build the non-normalized histogram:
for (j=0; j<height; j++)
	{
		for (k=0; k<width; k++)
	    {
						histogram[image_in[j][k]]++;
						// increments the histogram bin by one each time
						// according to the the brightness value at a given pixel
			}
	}

//divide histogram by total pixels, reassign answer to same histogram:
for(j=0; j<256; j++)
	{
		histogram[j] /= ((float) width*height);
	}

// Creating transfer function:
for (j=0; j<256; j++)
{
	for (k=0; k<j+1; k++) // "from 0 to J"
	{
		eqTransfer[j] += histogram[k];
	}
eqTransfer[j] = floor(255.0 * eqTransfer[j]);
			// 255.0 is "L-1" term from L6S21 (brightness is 0 - 256)
			// we originally tried rounding by using floor+0.5,
			// but this caused the ouput to be black. So, using floor only.
}


//Applying the transfer function:
for (j=0; j<height; j++)
{
	for (k=0; k<width; k++)
	{
		image_out[j][k] = (int) eqTransfer[image_in[j][k]];
		/* From R-->L: brightness value of input image at pixel [j,k]
		is applied to the input of the transfer equation. The output
		from this is then changed into an integer, and stored in the
		output image at [j,k].
		*/
	}
}

/********************************************************************/
/* Image Processing ends                                          */
/********************************************************************/

	/* display image_out */
	for (j=0; j<height; j++)
		for (k=0; k<width; k++)
	   	{
			image_disp(k,j,0,0) = image_out[j][k];
		}
	CImgDisplay disp_out(image_disp,"Image_Out",0);


	/* save image_out into out_file in RAW format */
	for (j=0; j<height; j++)
		for (k=0; k<width; k++)
	    {
	            if((putc(image_out[j][k],out))==EOF)
	            {
		        	printf("ERROR: Can't write to out_file!\n");
				    return(1);
	            }
		}

    if(fclose(out)==EOF)
	{
		printf("ERROR: Can't close out_file!\n");
		return(1);
	}

	/* closing */
	while (!disp_in.is_closed)
		disp_in.wait();
	while (!disp_out.is_closed)
		disp_out.wait();

	for (j=0; j<height; j++)
	{
		free(image_in[j]);
		free(image_out[j]);
	}
	free(image_in);
	free(image_out);

    return 0;
}
