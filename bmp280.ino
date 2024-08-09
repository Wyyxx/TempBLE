#include <Wire.h>
#include <SPI.h>
#include <Adafruit_BMP280.h>

#include "BluetoothSerial.h"

// Check if Bluetooth configs are enabled
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

// Bluetooth Serial object
BluetoothSerial SerialBT;

#define BMP_SCK  (13)
#define BMP_MISO (12)
#define BMP_MOSI (11)
#define BMP_CS   (10)

Adafruit_BMP280 bmp;

// Variables to hold sensor readings
float temperature = 0;
float pressure    = 0;
float altitude    = 0;

unsigned status;

// Stores the elapsed time from device start up
unsigned long elapsedMillis = 0; 
// The frequency of sensor updates to firebase, set to 10seconds
unsigned long update_interval = 30000; 


// Handle received and sent messages
String message = "";
char incomingChar;
String temperatureString = "";

void Bmp280_Init(){
delay(100);
  status = bmp.begin();
  if (!status) {
    Serial.println(F("Could not find a valid BMP280 sensor, check wiring or "
                      "try a different address!"));
    Serial.print("SensorID was: 0x"); Serial.println(bmp.sensorID(),16);
    Serial.print("        ID of 0xFF probably means a bad address, a BMP 180 or BMP 085\n");
    Serial.print("   ID of 0x56-0x58 represents a BMP 280,\n");
    Serial.print("        ID of 0x60 represents a BME 280.\n");
    Serial.print("        ID of 0x61 represents a BME 680.\n");
    while (1) delay(10);
  }
  bmp.setSampling(
    Adafruit_BMP280::MODE_NORMAL,
    Adafruit_BMP280::SAMPLING_X2,
    Adafruit_BMP280::SAMPLING_X16,
    Adafruit_BMP280::FILTER_X16,
    Adafruit_BMP280::STANDBY_MS_500
  );
}

void updateSensorReadings() {
  temperature = bmp.readTemperature();
  pressure = bmp.readPressure() / 100.0F;
  altitude = bmp.readAltitude();

  // Check if any reads failed and exit early (to try again).
  if (isnan(temperature) || isnan(pressure) || isnan(altitude) ) {
    Serial.println(F("Error al leer el sensor bmp280"));
    return;
  }

  Serial.printf("Temperature reading: %.2f \n", temperature);
  Serial.printf("Pressure reading: %.2f \n", pressure);
  Serial.printf("altitude reading: %.2f \n", altitude);
 
}



String readTemperature() {
     return String(temperature);
}

String readPressure() {
      return String(pressure);
}
String readAltitude() {
      return String(altitude);
}

void bluetooth_Init(){
  delay(100);
  // Bluetooth device name
  if (!SerialBT.begin("ESP32_remedial_ricardo")){
    Serial.println("No se encontro Bluetooth");
  }else {
    Serial.println("Bluetooth listo");
  }
  
}

void sendDataToBluetooth(){
    Serial.println("Envio datos ");
    SerialBT.println(readTemperature() + "," + readPressure() + "," + readAltitude());
    Serial.println("Datos enviados");
}
void readDataFromBluetooth(){
    // Read received messages
  if (SerialBT.available()){
    char incomingChar = SerialBT.read();
    if (incomingChar != '\n'){
      message += String(incomingChar);
    }
    else{
      message = "";
    }
    Serial.write(incomingChar);  
  }
    // Check received message and control output accordingly
    if (message =="datos"){
      updateSensorReadings();
      sendDataToBluetooth();
    }
    delay(3);
}

void uploadSensorData() {
  if (millis() - elapsedMillis > update_interval){
    elapsedMillis = millis();
    updateSensorReadings();
    sendDataToBluetooth();
  }
}


void setup() {
  Serial.begin(115200);
  Bmp280_Init();
  bluetooth_Init();
}



void loop() {
    uploadSensorData();
    readDataFromBluetooth();
}
