
_main:

;MyProject.c,9 :: 		void main() {
;MyProject.c,11 :: 		TRISD = 0b00000000; // TRISD initialized to 0 (output)
	CLRF       TRISD+0
;MyProject.c,12 :: 		PORTD = 0b00000000; // PORTD initialized to 0
	CLRF       PORTD+0
;MyProject.c,13 :: 		TRISC = 0xF0;
	MOVLW      240
	MOVWF      TRISC+0
;MyProject.c,14 :: 		TRISB = 0x83;
	MOVLW      131
	MOVWF      TRISB+0
;MyProject.c,15 :: 		CCPPWM_init();
	CALL       _CCPPWM_init+0
;MyProject.c,17 :: 		while(1) {
L_main0:
;MyProject.c,18 :: 		follow_line();
	CALL       _follow_line+0
;MyProject.c,19 :: 		}
	GOTO       L_main0
;MyProject.c,20 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_move_forward:

;MyProject.c,22 :: 		void move_forward() {
;MyProject.c,23 :: 		PORTD = 0x05; // 0000 0101 >> both motors are on and moving forward
	MOVLW      5
	MOVWF      PORTD+0
;MyProject.c,24 :: 		}
L_end_move_forward:
	RETURN
; end of _move_forward

_turn_right:

;MyProject.c,28 :: 		void turn_right() {
;MyProject.c,29 :: 		PORTD = 0x09; // 0000 1001 >> left motor moves forward and right motor moves backwards
	MOVLW      9
	MOVWF      PORTD+0
;MyProject.c,30 :: 		}
L_end_turn_right:
	RETURN
; end of _turn_right

_turn_left:

;MyProject.c,32 :: 		void turn_left() {
;MyProject.c,33 :: 		PORTD = 0x06; // 0000 0110 >> right motor moves forward and left motor moves backwards
	MOVLW      6
	MOVWF      PORTD+0
;MyProject.c,34 :: 		}
L_end_turn_left:
	RETURN
; end of _turn_left

_stop:

;MyProject.c,36 :: 		void stop() {
;MyProject.c,37 :: 		PORTD = 0x00; // both motors stop
	CLRF       PORTD+0
;MyProject.c,38 :: 		}
L_end_stop:
	RETURN
; end of _stop

_my_delay:

;MyProject.c,40 :: 		void my_delay(unsigned int mscnt) { // delay, 1000 = 1 second
;MyProject.c,43 :: 		for(ms = 0; ms < mscnt; ms++) {
	CLRF       R1+0
	CLRF       R1+1
L_my_delay2:
	MOVF       FARG_my_delay_mscnt+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__my_delay23
	MOVF       FARG_my_delay_mscnt+0, 0
	SUBWF      R1+0, 0
L__my_delay23:
	BTFSC      STATUS+0, 0
	GOTO       L_my_delay3
;MyProject.c,44 :: 		for(cnt = 0; cnt < 155; cnt++); // 1ms
	CLRF       R3+0
	CLRF       R3+1
L_my_delay5:
	MOVLW      0
	SUBWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__my_delay24
	MOVLW      155
	SUBWF      R3+0, 0
L__my_delay24:
	BTFSC      STATUS+0, 0
	GOTO       L_my_delay6
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
	GOTO       L_my_delay5
L_my_delay6:
;MyProject.c,43 :: 		for(ms = 0; ms < mscnt; ms++) {
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;MyProject.c,45 :: 		}
	GOTO       L_my_delay2
L_my_delay3:
;MyProject.c,46 :: 		}
L_end_my_delay:
	RETURN
; end of _my_delay

_follow_line:

;MyProject.c,50 :: 		void follow_line() {
;MyProject.c,51 :: 		if((PORTB & 0x01) && (PORTB & 0x02)) {
	BTFSS      PORTB+0, 0
	GOTO       L_follow_line10
	BTFSS      PORTB+0, 1
	GOTO       L_follow_line10
L__follow_line16:
;MyProject.c,52 :: 		PORTD = 0X00; // both sensors detected black lines >> stop
	CLRF       PORTD+0
;MyProject.c,53 :: 		} else if(PORTB & 0x02) {
	GOTO       L_follow_line11
L_follow_line10:
	BTFSS      PORTB+0, 1
	GOTO       L_follow_line12
;MyProject.c,54 :: 		turn_left(); // left sensor detects a black line >> turns left
	CALL       _turn_left+0
;MyProject.c,55 :: 		} else if (PORTB & 0x01) {
	GOTO       L_follow_line13
L_follow_line12:
	BTFSS      PORTB+0, 0
	GOTO       L_follow_line14
;MyProject.c,56 :: 		turn_right(); // right sensor detects a black line >> turns right
	CALL       _turn_right+0
;MyProject.c,57 :: 		} else {
	GOTO       L_follow_line15
L_follow_line14:
;MyProject.c,58 :: 		move_forward(); // no black lines are detected on both sensors >> moves forward
	CALL       _move_forward+0
;MyProject.c,59 :: 		}
L_follow_line15:
L_follow_line13:
L_follow_line11:
;MyProject.c,60 :: 		}
L_end_follow_line:
	RETURN
; end of _follow_line

_CCPPWM_init:

;MyProject.c,62 :: 		void CCPPWM_init(void) { // Configure CCP1 and CCP2 at 2ms period with 50% duty cycle
;MyProject.c,63 :: 		T2CON = 0x07; // enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS per count 2000uS to count 250 counts)
	MOVLW      7
	MOVWF      T2CON+0
;MyProject.c,64 :: 		CCP1CON = 0x0C; // enable PWM for CCP1
	MOVLW      12
	MOVWF      CCP1CON+0
;MyProject.c,65 :: 		CCP2CON = 0x0C; // enable PWM for CCP2
	MOVLW      12
	MOVWF      CCP2CON+0
;MyProject.c,66 :: 		PR2 = 250; // 250 counts = 8uS * 250 = 2ms period
	MOVLW      250
	MOVWF      PR2+0
;MyProject.c,67 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;MyProject.c,68 :: 		CCPR1L = 100; // pc2
	MOVLW      100
	MOVWF      CCPR1L+0
;MyProject.c,69 :: 		CCPR2L = 100; // pc1
	MOVLW      100
	MOVWF      CCPR2L+0
;MyProject.c,70 :: 		}
L_end_CCPPWM_init:
	RETURN
; end of _CCPPWM_init
