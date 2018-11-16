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

// the following vars we don't think are used:
	float sum1, sum2;
	float new_T, old_T, delta_T;
	long count1, count2;
	// but I don't yet have the courage to delete them ^^^^^^^


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

float sum = 0.0;
float convolution_output = 0.0;
float filter[3][3] = {{0, -1, 0},
											{-1, 4, -1},
											{0, -1, 0}};

// using x and y this time instead of j and k, just for clarity and
// proactive with the quad-nested for-loops
int x, y;
// j and k already declared
for (y=0; y < height; y++)
{
	for (x=0; x < width; x++)
	{
		// first, are excluding the outer row of pixels on the image from
		// the convolution with the 3x3 filter. Outer row ONLY because
		// we know it's a 3x3 filter. Else, base on size of filter.
		if (x==0 || x==width-1 || y==0 || y==height-1)  //use == for compare
		{
			image_out[y][x] = image_in[y][x];
		}
		else
		{
			for (j=0; j<3; j++)
			{
				for (k=0; k<3; k++)
				{
					sum += ((float) image_in[y+j-1][x+k-1]) * filter[j][k];
				}
			}

			convolution_output = sum;
			sum = 0.0; // we need to reset this each iteration
			if (convolution_output > 255)
			{
				convolution_output = 255;
			}
			else if (convolution_output < 0)
			{
				convolution_output = 0;
			}
			image_out[y][x] = (int) convolution_output;
		}
	}
}

//Homework6 lenna.512 testout.raw 512 512

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
