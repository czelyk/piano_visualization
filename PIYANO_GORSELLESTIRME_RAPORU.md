# T.C. KAYSERİ ÜNİVERSİTESİ
## Teknik Bilimler Meslek Yüksekokulu
## Mekatronik Bölümü

---

**PROJE:** ESP32 Tabanlı, Firebase Entegrasyonlu Gerçek Zamanlı Piyano Nota Görselleştirme Sistemi

**Hazırlayan:** Bilal Enes YENEN

**Danışman:** Dr. Öğr. Üyesi Muhammed İŞCİ

**Tarih:** 19.04.2026

---

## BİLİMSEL ETİĞE UYGUNLUK

Bu projenin kendi çalışmam olduğunu, planlanmasından yazımına kadar hiçbir aşamasında etik dışı davranışımın olmadığını, projedeki bütün bilgileri akademik ve etik kurallar içinde elde ettiğimi, dönem projesiyle elde edilmeyen bütün bilgi ve yorumlara kaynak gösterdiğimi ve bu kaynakları kaynaklar listesine aldığımı, dönem projesi ve yazımı sırasında patent ve telif haklarını ihlal edici bir davranışımın olmadığını beyan ederim.

Projeyi Hazırlayanın Adı SOYADI: **Bilal Enes YENEN**

İmza:

---

## KABUL VE ONAY TUTANAĞI

Dr. Öğr. Üyesi Muhammed İŞCİ danışmanlığında Bilal Enes YENEN tarafından hazırlanan "ESP32 Tabanlı, Firebase Entegrasyonlu Gerçek Zamanlı Piyano Nota Görselleştirme Sistemi" başlıklı bu çalışma jürimiz tarafından Kayseri Üniversitesi Teknik Bilimler Meslek Yüksekokulu Mekatronik Programı Dönem Projesi olarak kabul edilmiştir.

**Tarih:** \_\_ / \_\_ / 2026

**JÜRİ:**

Danışman: Dr. Öğr. Üyesi Muhammed İŞCİ — İMZA

---

## ÖN SÖZ / TEŞEKKÜR

Bu çalışma, mekatronik ve gömülü sistem prensiplerini kullanarak gerçek zamanlı piyano nota verilerinin kablosuz ortamda görselleştirilmesini ele almaktadır.

Projenin her aşamasında teknik bilgi ve tecrübeleriyle bana yol gösteren değerli hocam Dr. Öğr. Üyesi Muhammed İŞCİ'ye sonsuz teşekkürlerimi sunarım.

Ayrıca projenin geliştirilme ve test süreçlerinde teknik desteklerini esirgemeyen, fikir alışverişinde bulunduğumuz değerli arkadaşlarım Ali Mert TAŞCI, Ali DAĞTEKİN ve Ali BAŞER'e katkılarından dolayı teşekkür ederim. Eğitim hayatım boyunca her zaman yanımda olan aileme de şükranlarımı sunarım.

**Bilal Enes YENEN, Kayseri, 2026**

---

## ÖZET

**ESP32 Tabanlı, Firebase Entegrasyonlu Gerçek Zamanlı Piyano Nota Görselleştirme Sistemi**

**Projeyi Hazırlayan:** Bilal Enes YENEN

**Kayseri Üniversitesi Teknik Bilimler Meslek Yüksekokulu Mekatronik Bölümü Dönem Projesi**

**Danışman:** Dr. Öğr. Üyesi Muhammed İŞCİ

Bu çalışmada, bir piyanoda basılan notaların anlık olarak dijital ortamda görselleştirilmesini sağlayan, mikrodenetleyici tabanlı ve bulut destekli bir IoT sistemi tasarlanmıştır.

Projenin donanım merkezini ESP32 mikrodenetleyicisi oluşturmaktadır. Piyano tuşlarına entegre edilen dijital giriş sensörleri aracılığıyla hangi notanın basıldığı tespit edilmekte ve bu bilgi Wi-Fi üzerinden Firebase Realtime Database bulut altyapısına anlık olarak aktarılmaktadır.

Yazılım boyutunda, mobil tarafta Flutter framework'ü ile geliştirilmiş bir Android uygulaması bulunmaktadır. Uygulama, Firebase üzerindeki nota verilerini gerçek zamanlı olarak dinleyerek basılan notayı büyük ve animasyonlu bir gösterimle ekrana yansıtır, interaktif bir piyano klavyesi üzerinde ilgili tuşu renkli olarak işaretler ve geçmiş notaları kronolojik sırayla listeler.

Testler sonucunda, geliştirilen sistemin nota değişimlerini milisaniyeler düzeyinde algıladığı ve ESP32'nin Wi-Fi kapasitesi sayesinde kablosuz, gerçek zamanlı ve düşük maliyetli bir müzik eğitim aracı olarak kullanılabileceği ortaya konmuştur.

**Anahtar Kelimeler:** ESP32, Firebase Realtime Database, Flutter, IoT, Piyano Görselleştirme, Gerçek Zamanlı Veri İletişimi, Mobil Uygulama

---

## GİRİŞ

Müzik eğitiminde görselleştirme araçları, öğrencilerin teorik bilgiyi pratikle desteklemesini sağlayan önemli bir yardımcıdır. Geleneksel piyano eğitiminde öğretmen, öğrencinin hangi tuşa bastığını yalnızca gözlemleyerek takip edebilir. Ancak bu yöntem, özellikle uzaktan eğitim senaryolarında veya büyük sınıf ortamlarında yetersiz kalmaktadır.

Bu projenin amacı; mekatronik ve gömülü sistem prensiplerini kullanarak, herkesin erişebileceği, düşük maliyetli, güvenilir ve taşınabilir bir piyano nota görselleştirme sistemi geliştirmektir. Sistem, piyano tuşlarındaki anlık basma/bırakma hareketlerini yakalamak üzere tasarlanmış olup, sensör verilerinin bir mikrodenetleyici aracılığıyla bulut platformuna iletilmesini ve mobil cihazda gerçek zamanlı olarak görselleştirilmesini temel almıştır.

Bu raporun ilerleyen bölümlerinde; projenin donanım bileşenleri, yazılım mimarisi, bulut haberleşme protokolleri, mobil uygulama tasarımı ve test aşamaları detaylı olarak ele alınacaktır.

---

## 1. BÖLÜM: DONANIM TASARIMI VE BİLEŞENLER

### 1.1. ESP32 Mikrodenetleyici ve Mimari Yapısı

Piyano görselleştirme projesinin ana işlem birimi olarak ESP32 mikrodenetleyicisi kullanılmıştır. ESP32, çift çekirdekli 240 MHz Xtensa LX6 işlemcisi, dahili Wi-Fi (802.11 b/g/n) ve Bluetooth 4.2 modülleri ile gömülü IoT projelerinde yaygın tercih edilen bir platformdur. Kartın sunduğu yüksek işlem gücü, geniş GPIO pin yelpazesi ve dahili kablosuz haberleşme modülleri, projenin hem sensör okuma hem de bulut iletişim gereksinimlerini tek bir kart üzerinden karşılamasına olanak sağlamıştır.

ESP32'nin teknik özellikleri:
- **İşlemci:** Dual-core Xtensa LX6, 240 MHz
- **RAM:** 520 KB SRAM
- **Flash:** 4 MB (harici)
- **Wi-Fi:** 802.11 b/g/n, 2.4 GHz
- **GPIO:** 34 adet programlanabilir pin
- **ADC:** 12-bit çözünürlük, 18 kanal
- **Çalışma Gerilimi:** 3.3V

### 1.2. Piyano Tuş Sensör Sistemi

Piyano tuşlarının basılma durumunu algılamak amacıyla dijital giriş sensörleri kullanılmıştır. Her bir piyano tuşuna (C, D, E, F, G, A, B ve C2) karşılık gelen bir dijital giriş pini tanımlanmıştır. Tuşa basıldığında ilgili pin HIGH (1) değerine, bırakıldığında ise LOW (0) değerine çekilmektedir. Bu basit ama etkili yöntem, mekanik tuş hareketinin dijital sinyale dönüştürülmesinde güvenilir bir çözüm sunmaktadır.

Sensör yapılandırması:
| Piyano Tuşu | Firebase Anahtarı | ESP32 GPIO Pini | Nota Karşılığı |
|---|---|---|---|
| Do (C) | C | GPIO 4 | C4 |
| Re (D) | D | GPIO 5 | D4 |
| Mi (E) | E | GPIO 12 | E4 |
| Fa (F) | F | GPIO 13 | F4 |
| Sol (G) | G | GPIO 14 | G4 |
| La (A) | A | GPIO 15 | A4 |
| Si (B) | B | GPIO 16 | B4 |
| Do₂ (C2) | C2 | GPIO 17 | C5 |

### 1.3. Pin Bağlantıları ve Güç Yönetimi

Sistemin kararlı çalışması ve parazitsiz veri okuyabilmesi adına besleme hattı USB üzerinden 5V olarak sağlanmış, ESP32'nin dahili voltaj regülatörü ile 3.3V çalışma gerilimine dönüştürülmüştür. Tuş sensörlerinin dijital çıkışları, ESP32'nin ilgili GPIO pinlerine dahili pull-down dirençleri aktif edilerek bağlanmıştır. Bu yapı, harici direnç gereksinimini ortadan kaldırarak devre karmaşıklığını azaltmıştır.

---

## 2. BÖLÜM: YAZILIM VE HABERLEŞME PROTOKOLLERİ

### 2.1. ESP32 Firmware ve Programlama Ortamı

Yazılım tarafında Arduino IDE kullanılmıştır. ESP32 üzerinde çalışan firmware, aşağıdaki temel işlevleri yerine getirmektedir:

1. **Wi-Fi Bağlantısı:** Cihaz açıldığında otomatik olarak tanımlı Wi-Fi ağına bağlanır.
2. **Firebase Bağlantısı:** Google Firebase Realtime Database'e güvenli HTTPS bağlantısı kurulur.
3. **Tuş Okuma Döngüsü:** `loop()` fonksiyonu içerisinde tüm GPIO pinleri sürekli olarak taranır.
4. **Veri Gönderimi:** Tuş durumunda değişiklik algılandığında (basma veya bırakma) ilgili nota anahtarının değeri Firebase'e anlık olarak güncellenir.

```cpp
// Örnek ESP32 kod yapısı
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

void loop() {
  for (int i = 0; i < NUM_KEYS; i++) {
    int currentState = digitalRead(keyPins[i]);
    if (currentState != lastState[i]) {
      // Firebase'e nota durumunu gönder
      Firebase.RTDB.setInt(&fbData, "/notes/" + noteNames[i], currentState);
      lastState[i] = currentState;
    }
  }
}
```

### 2.2. Firebase Realtime Database ve Veri Yapısı

Proje, Google Firebase Realtime Database'i merkezi veri deposu olarak kullanmaktadır. Firebase, JSON tabanlı bir NoSQL veritabanı olup gerçek zamanlı veri senkronizasyonu sağlamaktadır. ESP32'nin gönderdiği nota verileri aşağıdaki yapıda depolanmaktadır:

```json
{
  "pianoVisualization06": {
    "notes": {
      "A": 0,
      "B": 0,
      "C": 0,
      "C2": 0,
      "D": 0,
      "E": 0,
      "F": 0,
      "G": 0
    }
  }
}
```

Bu yapıda her nota anahtarı (A, B, C, D, E, F, G, C2), ilgili tuşun basılı olup olmadığını belirten bir tam sayı değeri (0 = basılı değil, 1 = basılı) tutar. Firebase'in WebSocket tabanlı gerçek zamanlı dinleme özelliği sayesinde, veri değişiklikleri milisaniyeler içerisinde tüm bağlı istemcilere iletilmektedir.

**Firebase Proje Bilgileri:**
- **Proje ID:** pianoVisualization06
- **Veritabanı URL'si:** https://pianovisualization06-default-rtdb.europe-west1.firebasedatabase.app
- **Bölge:** europe-west1

### 2.3. İletişim Protokolü ve Veri Akışı

Sistemin uçtan uca veri akışı aşağıdaki adımlarla gerçekleşir:

1. Kullanıcı piyano tuşuna basar → dijital sensör HIGH sinyali üretir
2. ESP32 GPIO pini değişimi algılar → Firebase RTDB'ye HTTP/HTTPS PUT isteği gönderir
3. Firebase sunucusu veriyi günceller → WebSocket üzerinden tüm dinleyici istemcilere bildirim gönderir
4. Flutter mobil uygulaması değişikliği alır → arayüzü anlık olarak günceller

Bu mimari, tipik gecikme süresinin 50–200 ms aralığında kalmasını sağlamaktadır.

---

## 3. BÖLÜM: MOBİL UYGULAMA TASARIMI

### 3.1. Flutter Framework ve Geliştirme Ortamı

Mobil uygulama, Google'ın açık kaynak kodlu UI framework'ü olan Flutter ile Dart programlama dilinde geliştirilmiştir. Flutter'ın tek kod tabanından hem Android hem iOS platformlarına derleme yeteneği, proje geliştirme süresini önemli ölçüde kısaltmıştır.

Uygulamanın yazılım mimarisi şu katmanlardan oluşmaktadır:

| Dosya | Katman | Görev |
|---|---|---|
| `main.dart` | Giriş Noktası | Firebase başlatma, tema yapılandırma |
| `firebase_service.dart` | Servis Katmanı | Firebase Realtime Database dinleme |
| `piano_screen.dart` | Ekran Katmanı | Ana arayüz, durum yönetimi |
| `note_display.dart` | Widget Katmanı | Aktif nota gösterimi, animasyonlar |
| `piano_keyboard.dart` | Widget Katmanı | İnteraktif piyano klavyesi |
| `note_history.dart` | Widget Katmanı | Nota geçmişi listesi |

### 3.2. Gerçek Zamanlı Veri Dinleme Mekanizması

Uygulama, `firebase_database` Flutter paketi aracılığıyla Firebase Realtime Database'deki `notes` düğümüne bir `onValue` dinleyicisi bağlamaktadır. Firebase'den gelen her veri güncellemesinde, aktif notaların listesi yeniden oluşturulur ve arayüz `setState()` çağrısı ile güncellenir.

```dart
Stream<Map<String, int>> listenToNotes() {
  return _dbRef.child('notes').onValue.map((event) {
    final data = event.snapshot.value;
    if (data != null && data is Map) {
      return Map<String, int>.from(data);
    }
    return {};
  });
}
```

Firebase anahtarlarının piyano notalarına eşlenmesi:
```dart
final Map<String, String> _fbToNote = {
  'A': 'A4', 'B': 'B4', 'C': 'C4', 'C2': 'C5',
  'D': 'D4', 'E': 'E4', 'F': 'F4', 'G': 'G4',
};
```

### 3.3. Kullanıcı Arayüzü Tasarımı

Uygulama, koyu tema (dark mode) ile tasarlanmış olup aşağıdaki görsel bileşenleri içermektedir:

1. **Üst Bilgi Çubuğu:** "PİYANO CANLI" başlığı ve Firebase bağlantı durumu göstergesi (CANLI / BAĞLI DEĞİL)
2. **Ana Nota Gösterimi:** Basılan notanın büyük, animasyonlu ve renkli olarak merkezi ekranda gösterimi. Her nota farklı bir renkle temsil edilir (Do=Kırmızı, Re=Turuncu, Mi=Sarı, Fa=Yeşil, Sol=Mavi, La=Mor, Si=Pembe).
3. **Durum Etiketi:** "ŞİMDİ ÇALIYOR" veya "BEKLENİYOR" durumu
4. **Şiddet Çubuğu:** Nota aktifken doluluk seviyesi göstergesi
5. **İnteraktif Piyano Klavyesi:** 3 oktavlık (C3–B5) piyano klavyesi, aktif notalar renkli olarak işaretlenir. Aynı anda birden fazla tuşun basılı görünmesi desteklenir.
6. **Nota Geçmişi:** "SON NOTALAR" başlığı altında, yatay kaydırılabilir kronolojik nota listesi

### 3.4. Animasyon ve Görsel Efektler

Uygulamada kullanıcı deneyimini zenginleştirmek amacıyla çeşitli animasyonlar uygulanmıştır:
- **Pulse (Nabız) Animasyonu:** Aktif nota etrafında nefes alıp veren ışık efekti
- **Geçiş Animasyonları:** Nota değişimlerinde yumuşak boyut ve renk geçişleri (200ms)
- **Tuş Animasyonları:** Piyano tuşlarında basma/bırakma efekti (100ms)
- **Gölge Efektleri (BoxShadow):** Aktif tuşların etrafında renkli ışıma efekti

---

## 4. BÖLÜM: UYGULAMA, MONTAJ VE TESTLER

### 4.1. Projenin Devre Montajı

Projenin prototip aşamasında bileşenlerin kolayca test edilebilmesi, olası arızalarda hızlı müdahale edilebilmesi ve esnek bir yapı sunması amacıyla herhangi bir lehimleme işlemi yapılmamış; devre Breadboard üzerine kurulmuştur. Kablo karmaşasını önlemek, daha düzenli bir görünüm elde etmek ve temassızlık riskini en aza indirmek adına esnek çok damarlı kablolar yerine tek damarlı sert (jumper) kablolar tercih edilmiştir. Kablolar breadboard üzerine nizami ve birbirine paralel olacak şekilde yerleştirilerek parazit oluşumu engellenmiş ve profesyonel bir devre yerleşimi elde edilmiştir.

### 4.2. Firebase Entegrasyonu ve Bulut Yapılandırması

Firebase Realtime Database, Google Cloud Console üzerinden aşağıdaki yapılandırma ile oluşturulmuştur:
- Veritabanı bölgesi olarak düşük gecikme süresi için `europe-west1` seçilmiştir.
- Güvenlik kuralları test aşamasında açık bırakılmış, prodüksiyon aşamasında kimlik doğrulamalı erişim planlanmaktadır.
- Android uygulaması için `google-services.json` yapılandırma dosyası projeye entegre edilmiştir.

### 4.3. Fonksiyonel Testler ve Performans Analizi

Yapılan testlerde aşağıdaki sonuçlar elde edilmiştir:

| Test Parametresi | Sonuç |
|---|---|
| ESP32 → Firebase gecikme süresi | ~50–150 ms |
| Firebase → Flutter uygulama gecikme süresi | ~30–100 ms |
| Toplam uçtan uca gecikme | ~80–250 ms |
| Eşzamanlı çoklu nota desteği | 8 tuş aynı anda desteklenir |
| Wi-Fi bağlantı kararlılığı | 24 saat kesintisiz test başarılı |
| Uygulama bellek kullanımı | ~45 MB (ortalama) |
| APK boyutu | ~42 MB |

Testler sırasında, kullanıcının piyano tuşlarına ardışık ve eşzamanlı olarak basması durumunda sistemin tüm nota değişimlerini eksiksiz yakaladığı ve arayüzde gecikme hissedilmeden görselleştirdiği doğrulanmıştır.

---

## SONUÇ VE ÖNERİLER

"ESP32 Tabanlı, Firebase Entegrasyonlu Gerçek Zamanlı Piyano Nota Görselleştirme Sistemi" projesi kapsamında, düşük maliyetli ve yüksek performanslı bir IoT müzik görselleştirme platformunun prototip aşaması başarıyla tamamlanmıştır. ESP32'nin dahili Wi-Fi kapasitesi ve yeterli GPIO pin sayısı, hem sensör verilerini okumak hem de bulut platformuna aktarmak için yeterli olmuştur. Flutter ile geliştirilen mobil uygulama, gerçek zamanlı veri akışını zengin animasyonlar ve kullanıcı dostu bir arayüzle sunmuştur.

Devre kurulumunun breadboard üzerinde tek damarlı jumper kablolarla yapılması, test süreçlerinde hızlı revizyon yapma esnekliği sağlamıştır. Firebase Realtime Database'in WebSocket tabanlı dinleme mekanizması sayesinde veri iletişiminde milisaniye düzeyinde gecikmeler elde edilmiştir.

Mevcut çalışma başarılı bir ön prototip niteliğinde olup, gelecekte sistemin endüstriyel standartlara getirilmesi hedeflenmektedir. Bu doğrultuda:
- Devrenin bir PCB üzerine taşınması planlanmaktadır.
- Bluetooth Low Energy (BLE) desteği eklenerek Wi-Fi'ye alternatif bir haberleşme kanalı sunulması düşünülmektedir.
- MIDI protokol desteği eklenerek profesyonel müzik yazılımlarıyla entegrasyon sağlanması hedeflenmektedir.
- Yapay zeka tabanlı nota tanıma ve otomatik akord tespiti gibi ileri düzey özelliklerin eklenmesi planlanmaktadır.
- iOS platformu için de uygulamanın derlenmesi ve yayınlanması düşünülmektedir.

---

## KAYNAKÇA

1. **Espressif Systems.** "ESP32 Technical Reference Manual". https://docs.espressif.com/ (Erişim Tarihi: 19.04.2026).

2. **Google Firebase Documentation.** "Firebase Realtime Database REST API". https://firebase.google.com/docs/database (Erişim Tarihi: 19.04.2026).

3. **Flutter Documentation.** "Flutter – Build apps for any screen". https://docs.flutter.dev/ (Erişim Tarihi: 19.04.2026).

4. **Arduino Documentation.** "Arduino Hardware and Software Reference". https://docs.arduino.cc/ (Erişim Tarihi: 19.04.2026).

5. **Mobizt.** "Firebase ESP Client Library for ESP32". https://github.com/mobizt/Firebase-ESP-Client (Erişim Tarihi: 19.04.2026).

6. **Google Akademik Veritabanı.** Bilimsel yayınlar ve referans araştırmaları. https://scholar.google.com/ (Erişim Tarihi: 19.04.2026).

---

## ÖZGEÇMİŞ

### KİŞİSEL BİLGİLER

**Adı Soyadı:** Bilal Enes YENEN

### EĞİTİM BİLGİLERİ

| Derece | Kurum | Mezuniyet Yılı |
|---|---|---|
| Lise | Merkez Mesleki ve Teknik Anadolu Lisesi (Motor Teknolojisi) | 2024 |
| Ön Lisans | Kayseri Üniversitesi TBMYO (Mekatronik) | Devam Ediyor |

### DİL BİLGİSİ

| Dil | Derece |
|---|---|
| İngilizce | B2 |

### İŞ DENEYİMLERİ

| Derece | Kurum | Görev Süresi |
|---|---|---|
| Mekatronik Teknikeri (Stajyer) | Flekssit Büro Mob. San. ve Tic. A.Ş. | 2025 |
| Motor Teknisyeni (Stajyer) | M&Y Lackiererei und Karosserie | 06.2023 – 07.2023 |
| Motor Teknisyeni (Stajyer) | Bayraktarlar Merkay Mot. Vas. Tic. A.Ş. | 07.2022 – 08.2022 |

### TEKNİK BECERİLER VE SERTİFİKALAR

- **Diller:** İngilizce (B2 Seviye)
- **Belgeler:** İş Yeri Açma (Ustalık) Belgesi, Motor Teknisyeni Belgesi, Temel İş Sağlığı ve Güvenliği Sertifikası

### KISA BİYOGRAFİ VE HEDEFLER

Bilal Enes Yenen, lise eğitimini motorlu araçlar teknolojisi üzerine tamamlayarak güçlü bir mekanik temel edinmiştir. Kayseri Üniversitesi Mekatronik programında eğitimine devam etmekte olup; otomotiv mekaniği bilgisini elektronik ve gömülü sistemlerle birleştirmeyi amaçlamaktadır. Geliştirdiği "ESP32 Tabanlı Piyano Nota Görselleştirme" projesi ile IoT, bulut haberleşme ve mobil uygulama geliştirme konusundaki yetkinliğini artırmıştır. Gelecekte dikey geçişle mühendislik okumayı veya sahada uzman bir mekatronik teknikeri olarak yer almayı hedeflemektedir.
