/*
 * main.c
 *
 *  Created on: Apr 26, 2019
 *      Author: Jacob Boline
 */

#include "xparameters.h"
#include "xbram.h"
#include <stdio.h>

#define BRAM_DEVICE_ID		XPAR_BRAM_0_DEVICE_ID
#define BRAM_BASE_ADDR		XPAR_BRAM_0_BASEADDR

XBram Bram;	/* The Instance of the BRAM Driver */

int main(void)
{
	int Status;

	XBram_Config *ConfigPtr;

	/*
	 * Initialize the BRAM driver. If an error occurs then exit
	 */

	/*
	 * Lookup configuration data in the device configuration table.
	 * Use this configuration info down below when initializing this
	 * driver.
	 */
	ConfigPtr = XBram_LookupConfig(BRAM_DEVICE_ID);
	if (ConfigPtr == (XBram_Config *) NULL) {
		return XST_FAILURE;
	}

	Status = XBram_CfgInitialize(&Bram, ConfigPtr,
					 ConfigPtr->CtrlBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	int idx;
	for(idx = 0; idx < 38400; idx++)
	{
		XBram_WriteReg(BRAM_BASE_ADDR, idx, 0x00000000B);
	}

	return XST_SUCCESS;
}