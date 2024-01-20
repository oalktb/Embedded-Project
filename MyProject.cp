#line 1 "C:/Users/user1/Desktop/MyProject.c"
void my_delay();
void turn_left();
void turn_right();
void move_forward();
void follow_line();
void CCPPWM_init(void);
void stop();

void main() {
 unsigned int k;
 TRISD = 0b00000000;
 PORTD = 0b00000000;
 TRISC = 0xF0;
 TRISB = 0x83;
 CCPPWM_init();

 while(1) {
 follow_line();
 }
}

void move_forward() {
 PORTD = 0x05;
}



void turn_right() {
 PORTD = 0x09;
}

void turn_left() {
 PORTD = 0x06;
}

void stop() {
 PORTD = 0x00;
}

void my_delay(unsigned int mscnt) {
 unsigned int ms;
 unsigned int cnt;
 for(ms = 0; ms < mscnt; ms++) {
 for(cnt = 0; cnt < 155; cnt++);
 }
}



void follow_line() {
 if((PORTB & 0x01) && (PORTB & 0x02)) {
 PORTD = 0X00;
 } else if(PORTB & 0x02) {
 turn_left();
 } else if (PORTB & 0x01) {
 turn_right();
 } else {
 move_forward();
 }
}

void CCPPWM_init(void) {
 T2CON = 0x07;
 CCP1CON = 0x0C;
 CCP2CON = 0x0C;
 PR2 = 250;
 TRISC = 0x00;
 CCPR1L = 100;
 CCPR2L = 100;
}
