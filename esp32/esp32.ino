#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Token oluşturma ve RTDB yardımcı kütüphaneleri
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// Wi-Fi Bilgileri (Burayı kendi ağınıza göre değiştirin)
#define WIFI_SSID "deneme"
#define WIFI_PASSWORD "12345678"

// Firebase API Anahtarı ve Veritabanı URL'si (Flutter projenizdeki bilgiler alınmıştır)
#define API_KEY "AIzaSyCjRksDcuFtjvRmZlNW429uIBly8MX3g04"
#define DATABASE_URL "https://pianovisualization06-default-rtdb.europe-west1.firebasedatabase.app/"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

bool signupOK = false;

// Piyano Tuşlarının Bağlı Olduğu GPIO Pinleri
const int pinC  = 4;
const int pinD  = 5;
const int pinE  = 12;
const int pinF  = 13;
const int pinG  = 14;
const int pinA  = 15;
const int pinB  = 16;
const int pinC2 = 17;

const int numKeys = 8;
// Firebase'deki anahtar isimleriyle birebir aynı sırayla
const int keyPins[numKeys] = {pinA, pinB, pinC, pinC2, pinD, pinE, pinF, pinG};
const String keyNames[numKeys] = {"A", "B", "C", "C2", "D", "E", "F", "G"};

// Tuşların bir önceki durumlarını tutacağımız dizi (Başlangıçta hepsi 0)
int lastState[numKeys] = {0, 0, 0, 0, 0, 0, 0, 0};

void setup() {
  Serial.begin(115200);

  // Pinleri giriş olarak ve dahili pull-down dirençleri aktif olarak ayarla.
  // Bu sayede butona basılmadığında pin 0 değerini okuyacak, basıldığında 3.3V vererek 1 yapacaksınız.
  for (int i = 0; i < numKeys; i++) {
    pinMode(keyPins[i], INPUT_PULLDOWN); 
  }

  // Wi-Fi'ye Bağlan
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("WiFi'a baglaniliyor");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("WiFi Baglantisi Basarili! IP Adresi: ");
  Serial.println(WiFi.localIP());

  // Firebase Yapılandırması
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  // Anonim olarak Firebase'e kaydol/bağlan
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Firebase baglantisi hazir!");
    signupOK = true;
  } else {
    Serial.printf("Firebase baglantisi basarisiz: %s\n", config.signer.signupError.message.c_str());
  }

  // Token durumunu yazdırmak isterseniz
  config.token_status_callback = tokenStatusCallback;
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  // Eğer Firebase hazirsa ve veri göndermeye uygunsa
  if (Firebase.ready() && signupOK) {
    
    // Tüm tuşları tara
    for (int i = 0; i < numKeys; i++) {
      int currentState = digitalRead(keyPins[i]);
      
      // Eğer tuş durumunda bir değişiklik olduysa (basıldıysa veya bırakıldıysa)
      if (currentState != lastState[i]) {
        lastState[i] = currentState;
        String path = "/notes/" + keyNames[i];
        
        // Veritabanını güncelle
        if (Firebase.RTDB.setInt(&fbdo, path.c_str(), currentState)) {
          Serial.print(keyNames[i]);
          Serial.print(" notasi guncellendi: ");
          Serial.println(currentState);
        } else {
          Serial.print("Guncelleme hatasi: ");
          Serial.println(fbdo.errorReason());
        }
      }
    }
  }
  
  // ESP32'yi ve Wi-Fi sürecini boğmamak,
  // aynı zamanda buton "debounce" etkisini engellemek için küçük bir bekleme
  delay(15);
}
