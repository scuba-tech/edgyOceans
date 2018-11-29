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
// IMAGE PROCESSING EE-462:  Iterative Thresholding
// This code was developed on 29 November 2018 by C. Drew and P. Brine
// working together (to get unstuck) in B123.
//I pledge my honor that I have abided by the Stevens Honor System.
//-- Peter Brine & C. Drew

/*
Based on the imageprocessing.c structure, write a small routine which can
automatically calculate the global threshold value according to the
iterative global threshold estimation algorithm we discussed in class.

Hint: you have to initialize a T; then read through the image several times
to update the T; your iteration will stop when your newly updated Ti is
not much different from the previous Ti-1, i.e. T i – Ti-1< a.
You can let a = 5 for example.
You should try to let the program display the updated Ti at each iteration
so you’ll have an idea of whether it is running properly.
Finally you should apply your final T to the image and obtained a
binary output image and print out the result.

Iterative global threshold estimate algorithm (Lec. 8, s.24)
1. Select an arbitrary initial threshold T
2. Segment the iage to obtain two pixel groups:
			Group 1 pixel values > T
			Group 2 pixel values ≤ T
3. Compute the average values u_1 and u_2 of group 1 and 2 pixels
4. Update the threshold value; T = 1/2 (u_1 + u_2)
5. Repeat steps 2~4 until changes in T become small (start with a=5)
*/

int threshold = 127;
int thresholdOld = threshold;
long int avgLow = 0;
int countLow = 0;
long int avgHigh = 0;
int countHigh = 0;
int delta = 255; //5 represents a

while(delta > 1)
{
	//reset variables and set old threshold to current threshold
	thresholdOld = threshold;
	avgLow = 0;
	avgHigh = 0;
	countLow = 0;
	countHigh = 0;
	for (j=0; j < height; j++)
	{
		for (k=0; k < width; k++)
		{
			if(image_in[j][k] <= threshold) //if pixels are below threshold...
			{
				avgLow += image_in[j][k]; //add to low average variable
				countLow++; //keep track of how many pixels are below threshold
			}
			else //otherwise, if pixels are above threshold...
			{
				avgHigh += image_in[j][k]; //add to high average variable
				countHigh++; //keep track of how many pixels are above threshold
			}
		}
	}
	avgLow /= countLow; //calculate average of pixels below threshold
	avgHigh /= countHigh; //calculate average of pixels above threshold
	threshold = (avgLow + avgHigh)/2; //calculate new threshold
	delta = abs(threshold - thresholdOld); //compare old threshold to new
	printf("Threshold: %d\n", threshold);
	printf("Delta: %d\n", delta);
}

for(j=0; j<height; j++)
	for(k=0; k<width; k++)
		if(image_in[j][k] <= threshold) //if input pixel is below threshold...
			image_out[j][k] = 0; //set output pixel to black
		else //otherwise, if input pixel is above threshold...
			image_out[j][k] = 255; //set output pixel to white

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
