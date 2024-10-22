#include "hardware.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <isr_compat.h>

#define WDTCTL_               0x0120    /* Watchdog Timer Control */
//#define WDTHOLD             (0x0080)
//#define WDTPW               (0x5A00)

#define METADATA_START 0x160
#define METADATA_END  (METADATA_START + 12) // 4 bytes per region and assuming 2 regions

// UCC definitions
uint16_t ucc1min __attribute__((section (".ucc1min"))) = 0xE23E;
uint16_t ucc1max __attribute__((section (".ucc1max"))) = 0xE296;
uint16_t ucc2min __attribute__((section (".ucc2min"))) = 0xE298;
uint16_t ucc2max __attribute__((section (".ucc2max"))) = 0xE2F4;
uint16_t ucc3min __attribute__((section (".ucc3min"))) = 0xE0FC;
uint16_t ucc3max __attribute__((section (".ucc3max"))) = 0xE126;


/**
 * main.c
 */

char* test_password = "chaos";
int counter = 0;


/* A function to stand in for some secure operation
   In this psuedo-program it simply increments a counter but this 
   is a stand in for what would be what runs after the user logs in
*/
void secureFunction(void){
    counter++;
}


// REGION ONE //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* simplistic way of copy strings from one buffer to another */
__attribute__ ((section (".region_1"))) void stringCopy(char *dst, char *src){
    int n = strlen(src);
    for(int i=0; i<n; i++){
        dst[i] = src[i];
    }
    
}

/* Stand in for getting user input. Instead we copy the "input" from one buffer we set to a new buffer
   buffer is defined within this function to allow for an overflow to occur  however buffer is simply copied into
   the output pointer for later use
*/
__attribute__ ((section (".region_1"))) void getUserInput(char* output, char *input){
    char buffer[6] = {'\0'};
    
    stringCopy(buffer, input);
    stringCopy(output, buffer);
}

// REGION TWO ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* A simple string comparison function. In reality since this operation effects the secure execution 
of the device it wouldnt be in an untrusted region however we made it a second region for testing purposes
*/
__attribute__ ((section (".region_2"))) int passwordComparison(char *actual, char *attempt){
    int n = strlen(actual);
    int m = strlen(attempt);
    

    if (n!=m){
        return -1;
    }else{
        for(int i=0; i<n; i++){
            if (actual[i] != attempt[i]){
                return -1;
            }
        }
        return 0;
    }
}

// A dummy ISR
ISR(PORT1,TCB){
	P1IFG &= ~P1IFG;
	__asm__ volatile("br #0xe29a" "\n\t");
	P5OUT = ~P5OUT;
}


// MAIN /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int main(void)
{

        uint32_t* wdt = (uint32_t*)(WDTCTL_);
        *wdt = WDTPW | WDTHOLD;

	P1DIR = 0x00;
	P1IE = 0x01;
	P1IES = 0x00;
	P1IFG = 0x00;

	P5DIR = 0xFF;
	P5OUT = 0x00;
	
	eint();

	 // serves as the user input. Change from chaos to test an invalid password
	 char input[6] = {'c', 'h', 'a', 'o', 't', '\0'};

         while (1){
         
            // Test Setup
            char *buffer_two = malloc(5);
            memset(buffer_two, 0, 5);
            
            char buffer[6] = {'\0'};
            int result = -1;
        
        // Execution enters the first UCC
	    getUserInput(buffer, input);
        // Attempts to write to buffer_two will violate stack integrity
        //   as buffer_two is defined outside UCC one's frame
	    stringCopy(buffer_two, "test");
	     
	    // Entering UCC two
	    result = passwordComparison(buffer, test_password);
	    
        // The "Secure" functionality
	    if (result == 0){
	        secureFunction();
	    }

        // Cleanup
	    free(buffer);
	    free(buffer_two);
	}
        return 0;
}
