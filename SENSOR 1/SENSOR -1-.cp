#line 1 "D:/TÜM YEDEKLERÝM/Elektronik-20191028T093703Z-001/Elektronik/WEB SÝTEM/GÝTHUB/Mesafe Ölçer/SENSOR 1/SENSOR -1-.c"




sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;

sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;


unsigned int sayac_TMR1=0;
char txt[7];
unsigned int toplamSure=0,mesafe_mm=0,Sure_us=0;

void InitTimer1()
{
 T1CON = 0;
 TMR1H = 0;
 TMR1L = 0;
}

int MesafeOlc()
{
 long toplam=0,temp=0;
 char i,sayac;
 for(i=0;i<64;i++)
 {
  PORTB.f7 =1;
 Delay_us(10);
  PORTB.f7 =0;
 while(! PORTB.f0 );
 T1CON.TMR1ON=1;
 while( PORTB.f0 );
 T1CON.TMR1ON=0;
 sayac_TMR1=(TMR1H<<8)+TMR1L;
 toplam+=((long)sayac_TMR1*34)/200;
 TMR1H=0; TMR1L=0;
 sayac_TMR1=0;
 Delay_ms(5);
 }
 return (toplam>>6);
}

void Kurulum()
{
 CMCON=7;
 TRISD=0;
 TRISB=1;
 PORTB=0;
 InitTimer1();
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
}

void main()
{
 Kurulum();
 Lcd_Out(1,1,"xxxxxxxxxxxxxxxx");
 Lcd_Out(2,1,"    xxxxxxxxx");
 Delay_ms(7000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,4,"#YAPIMCI#");
 Lcd_Out(2,2," EMRE METIN.!");
 delay_ms(10000);
 Lcd_Cmd(_Lcd_CLEAR);
 Lcd_Out(1,2,"OLCULEN MESAFE");
 while(1)
 {
 mesafe_mm=MesafeOlc();
 WordToStr(mesafe_mm,txt);
 Lcd_Out(2,1,txt);
 Lcd_Out_CP(" mm");
 }
}
