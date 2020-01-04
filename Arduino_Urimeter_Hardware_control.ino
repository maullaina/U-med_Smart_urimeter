#include <Servo.h>
#include <LiquidCrystal.h>

  //VARIABLES
  int sensor_out = 0;
  unsigned long time1=millis(); //set up time
  float volume = 0;
  int sensor_out_decision = 2;
  int valve1_pin = 8;
  int valve2_pin = 9;
  const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 6;
  LiquidCrystal lcd(rs, en, d4, d5, d6, d7); // Display


void setup() {
  Serial.begin(9600);
  pinMode(2, INPUT); //sensor
  pinMode(valve1_pin, OUTPUT); //valve 1
  pinMode(valve2_pin, OUTPUT); //valve 2
  lcd.begin(16, 2);// set up the LCD's number of columns and rows
  //use the function interrupt to send data to matlab
  attachInterrupt(digitalPinToInterrupt(2), interrupt, FALLING); 
  }

void interrupt(){
  Serial.println(1);
}


void func_volume_reset(float *volume){
  /*this function will reset the volume to 0 every 30 min. The variable 
   volume is a pointer cause we need to modify it)*/
   *volume= 0;
  }


void func_volume(float *volume){
  /*this function will sum the defined volume every time the sensor detects 
   liquid. At the end we will print the total volume and compute the ml 
   every 30 min   */
   *volume = *volume + 15;
  }

    
void loop() {
  /*In the main loop all the action of our device will be defined. we setup 
  2 variables time1 and time2 to create a timer of 30 min.*/
  
  unsigned long time2=millis();
  while(time2=millis()<time1 + 30000){
    sensor_out = digitalRead(2);
    if(sensor_out_decision != sensor_out){ //OK-check  sensitivity-
      //Serial.print("enter\n");
      if (sensor_out==0){
       // Serial.print("Option water\n"); 
        
        /*if we want the solenoid to allow water to flow, 
        set the pin high. When you want the water to stop flowing, 
        set the pin low.*/
        
        digitalWrite(valve1_pin, HIGH);    //Switch Solenoid ON
        delay(1000); // CHECK IN SILICO 
        digitalWrite(valve1_pin, LOW);    //Switch Solenoid OFF
        //Serial.print("SUMA VOLUM\n");
        
        func_volume(&volume);
        lcd.clear();
        lcd.print(String("Volume: ") + String(volume) + String(" mL"));
        lcd.display();
       }
        
       else{
       // Serial.print("Option air\n"); 
       }
       
       sensor_out_decision=sensor_out;
       
      }
      else{
        //Serial.print("waiting\n");
      }
  }
  
    /* after the 30 min the while loop will break and thats the moment we will 
    print the total value, then reset that variable and open valve 2*/
    
   // Serial.print("Volum total = \n");
   // Serial.print(volume);
    func_volume_reset(&volume);
    digitalWrite(valve2_pin, HIGH);
    delay(5000);
    digitalWrite(valve2_pin, LOW); 
     
    time1=millis();
}
