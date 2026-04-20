# 🎹 Piano Visualization

ESP32 ile piyanodan alınan nota bilgisini Firebase üzerinden anlık olarak görselleştiren Flutter mobil uygulaması.

## 📱 Özellikler

- **Anlık nota gösterimi** — ESP32'den Firebase'e gönderilen nota anında ekranda görülür
- **Görsel piyano klavyesi** — 3 oktavlık (C3-B5) interaktif piyano, basılan tuş renk ve ışıkla vurgulanır
- **Nota geçmişi** — Son basılan notalar yatay kaydırılabilir listede gösterilir
- **Velocity göstergesi** — Basma kuvveti animasyonlu bar ile gösterilir
- **Bağlantı durumu** — Firebase bağlantısı canlı olarak izlenir (LIVE / OFFLINE)
- **Premium koyu tema** — Piyano estetiğine uygun neon parlama efektleri

## 🚀 Kurulum

### 1. Flutter SDK Kurulumu

Flutter kurulu değilse:

```powershell
# Flutter SDK'yı indir: https://docs.flutter.dev/get-started/install/windows/mobile
# İndirilen zip'i çıkart (örn. C:\flutter)
# PATH'e ekle:
$env:Path += ";C:\flutter\bin"
```

### 2. Bağımlılıkları Yükle

```powershell
cd c:\Users\Ahmet\Desktop\piano_visualization
flutter pub get
```

### 3. Uygulamayı Çalıştır

```powershell
# Emülatör veya USB bağlı telefon
flutter run
```

### 4. APK Oluştur (Opsiyonel)

```powershell
flutter build apk
```

## 🔥 Firebase Yapısı

ESP32'nin Firebase Realtime Database'e şu formatta veri göndermesi beklenir:

```
/piano
  ├── note: "C4"          (String — nota ismi)
  ├── velocity: 100       (int — basma kuvveti, 0-127)
  ├── timestamp: ...      (int — zaman damgası)
  └── active: true        (bool — tuş basılı mı)
```

**Database URL:** `https://pianovisualization06-default-rtdb.europe-west1.firebasedatabase.app`

## 📁 Proje Yapısı

```
piano_visualization/
├── lib/
│   ├── main.dart                    # Uygulama giriş noktası
│   ├── models/
│   │   └── note_model.dart          # Nota veri modeli
│   ├── screens/
│   │   └── piano_screen.dart        # Ana ekran
│   ├── services/
│   │   └── firebase_service.dart    # Firebase Realtime DB servisi
│   └── widgets/
│       ├── note_display.dart        # Nota gösterimi widget
│       ├── note_history.dart        # Nota geçmişi widget
│       └── piano_keyboard.dart      # Piyano klavyesi widget
├── android/
│   └── app/
│       └── google-services.json     # Firebase yapılandırma
├── pubspec.yaml
└── README.md
```

## 🧪 Test Etme

Firebase Console'dan manuel veri yazarak test edebilirsin:

1. [Firebase Console](https://console.firebase.google.com) → pianovisualization06 → Realtime Database
2. `piano` düğümü altına veri ekle:
   - `note`: `"C4"`
   - `velocity`: `100`
   - `active`: `true`
   - `timestamp`: `0`
3. Uygulamada anında görünmesi lazım!
