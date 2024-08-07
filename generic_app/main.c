#include "hardware.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <isr_compat.h>

#define WDTCTL_               0x0120    /* Watchdog Timer Control */
//#define WDTHOLD             (0x0080)
//#define WDTPW               (0x5A00)

#define METADATA_START 0x160
#define METADATA_END  (METADATA_START + 8) // 4 bytes per region and assuming 2 regions

// How to define uccmin and uccmax in memory for different regions.
// While all tests only use two regions, this file shows how to specify 
// more regions for larger tests
uint16_t ucc1min __attribute__((section (".ucc1min"))) = 0xe23e;
uint16_t ucc1max __attribute__((section (".ucc1max"))) = 0xe296;
uint16_t ucc2min __attribute__((section (".ucc2min"))) = 0xe298;
uint16_t ucc2max __attribute__((section (".ucc2max"))) = 0xe2f4;
uint16_t ucc3min __attribute__((section (".ucc3min"))) = 0xe2f6;
uint16_t ucc3max __attribute__((section (".ucc3max"))) = 0xe352;
uint16_t ucc4min __attribute__((section (".ucc4min"))) = 0xe354;
uint16_t ucc4max __attribute__((section (".ucc4max"))) = 0xe4ca;
uint16_t ucc5min __attribute__((section (".ucc5min"))) = 0xe4cc;
uint16_t ucc5max __attribute__((section (".ucc5max"))) = 0xe528;
uint16_t ucc6min __attribute__((section (".ucc6min"))) = 0xe52a;
uint16_t ucc6max __attribute__((section (".ucc6max"))) = 0xe586;
uint16_t ucc7min __attribute__((section (".ucc7min"))) = 0xFFFF;
uint16_t ucc7max __attribute__((section (".ucc7max"))) = 0xFFFF;
uint16_t ucc8min __attribute__((section (".ucc8min"))) = 0xFFFF;
uint16_t ucc8max __attribute__((section (".ucc8max"))) = 0xFFFF;


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

__attribute__ ((section (".region_3"))) int test_one(char *actual, char *attempt){
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

__attribute__ ((section (".region_4"))) int test_two(char *actual, char *attempt){
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

__attribute__ ((section (".region_4"))) int test_three(char *actual, char *attempt){
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

__attribute__ ((section (".region_4"))) int test_four(char *actual, char *attempt){
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
__attribute__ ((section (".region_4"))) int test_five(char *actual, char *attempt){
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
__attribute__ ((section (".region_5"))) int test_six(char *actual, char *attempt){
    //this 
    //is 
    // a
    // test
    
    
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

__attribute__ ((section (".region_6"))) int test_seven(char *actual, char *attempt){
    /* how about
    if i 
    do this */
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

ISR(PORT1,TCB){
	P1IFG &= ~P1IFG;
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
	 char input[6] = {'c', 'h', 'a', 'o', 's', '\0'};

         while (1){
         
            char *buffer = malloc(6);
            char *buffer_two = malloc(5);
            memset(buffer, 0, 6);
            memset(buffer_two, 0, 5);
            
            int result = -1;
            int test_result = -1;
            
	    getUserInput(buffer, input);
	    stringCopy(buffer_two, "test");
	     
	    
	    result = passwordComparison(buffer, test_password);
	    test_result = test_one(buffer, test_password);
	    test_result = test_two(buffer, test_password);
	    test_result = test_three(buffer, test_password);
	    test_result = test_four(buffer, test_password);
	    test_result = test_five(buffer, test_password);
	    test_result = test_six(buffer, test_password);
	    test_result = test_seven(buffer, test_password);
	    
	    if (result == 0){
	        secureFunction();
	    }
	    free(buffer);
	    free(buffer_two);
	}
        return 0;
}
