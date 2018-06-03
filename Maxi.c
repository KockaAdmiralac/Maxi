#include <built_in.h>

// For integer to string conversion before sending to UART
char text[16];

// Sends delimiter to UART
void sendDelimiter() {
     UART1_Write_Text("|");
}

// Sends ADC value from channel to UART
void sendChannel(int channel) {
     WordToStrWithZeros(ADC_Read(channel), text);
     UART1_Write_Text(text);
     UART1_Write(10);
}

void main() {
     // RA0, RA1 and RA2 are used for UART
     ANSELA = 0x0F;
     ANSELC = 0;
     // Initialize UART
     UART1_Init(9600);
     // Wait for UART
     Delay_ms(100);
     sendDelimiter();
     // Program loop
     while (1) {
           sendChannel(0);
           sendChannel(1);
           sendChannel(2);
           sendChannel(3);
           sendDelimiter();
           Delay_ms(100);
     }
}
