#include <xc.h>

// Function prototypes
void initADC();
unsigned int readADC();

void main() {
    // Configuration
    TRISC.F0 = 0;   // Set PORTC0 as output for controlling a device
    TRISA.F0 = 1;   // Set RA0 as input for LDR sensor
    ANSEL = 0x01;   // Enable AN0 as analog input (LDR connected to RA0)
    CMCON0 = 0x07;  // Disable comparators

    // Initialize ADC
    initADC();

    while (1) {
        unsigned int sensorValue = readADC();

        // Assuming lower ADC values represent higher light intensity
        // Adjust the threshold based on your LDR characteristics and environment
        if (sensorValue < 512) {
            PORTC.F0 = 1;  // Turn on device during the night
        } else {
            PORTC.F0 = 0;  // Turn off device during the day
        }

        __delay_ms(500);  // Delay for stability, adjust as needed
    }
}

void initADC() {
    ADCON1 = 0b10000000;  // Right justify result, Fosc/8, Vref+ = VDD, Vref- = VSS
    ADCON0 = 0b01000001;  // ADC ON, Channel AN0, Fosc/8
}

unsigned int readADC() {
    GO_DONE_bit = 1;       // Start ADC conversion
    while (GO_DONE_bit);   // Wait for conversion to complete
    return ((ADRESH << 8) + ADRESL);  // Return 10-bit ADC result
}