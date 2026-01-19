# Geo Memoir (Flutter)

 aplikacja "Geo Journal" w Flutter (Dart) – **3–4 widoki**, **GPS + aparat/galeria**, oraz **komunikacja z API (GET/POST)**.

## Funkcje (wymagania z zadania)

- **Widoki (4):**
  - **Oś czasu / Lista wpisów** – tytuł, data, znacznik lokalizacji, status synchronizacji.
  - **Mapa wpisów** – markery dla wpisów z GPS.
  - **Szczegóły wpisu** – opis, podgląd zdjęcia, współrzędne, mapa podglądowa, akcje.
  - **Ustawienia / ...** – motyw jasny/ciemny/systemowy + przycisk API GET.

- **Natywne funkcje (min. 1):**
  - **GPS** (`geolocator`) – pobranie bieżącej pozycji po kliknięciu.
  - **Aparat/galeria** (`image_picker`) – dodanie zdjęcia do wpisu.

- **API (min. 1 endpoint):**
  - **GET**: pobranie przykładowych wpisów z JSONPlaceholder.
  - **POST**: wysłanie wpisu do API (symulacja synchronizacji).

- **UX / stany:**
  - stan **pusty** (brak wpisów / brak lokalizacji na mapie),
  - stan **ładowania** (start aplikacji, pobieranie API),
  - stan **błędu** (brak internetu / brak uprawnień do GPS).

## Uruchomienie

1. Zainstaluj Flutter SDK oraz Android Studio.

```bash
flutter pub get
flutter run
```

Sprawdź środowisko:

```bash
flutter doctor
flutter devices
```

## Testy lokalne

1. **Dodaj wpis** → użyj przycisku **"Pobierz lokalizację"** (GPS) i/lub **"Zrób zdjęcie"**.
2. Zapisz wpis → wróć do listy → wpis ma datę i znacznik lokalizacji.
3. Wejdź w **Szczegóły** → widać opis, (opcjonalnie) zdjęcie oraz mapę.
4. Przejdź do **Mapa** → marker wpisu jest widoczny.
5. Wejdź w **Szczegóły** wpisu, który nie jest zsynchronizowany → kliknij **"Wyślij do API"** (POST).
6. Wyłącz internet → spróbuj pobrać z API w ustawieniach → pokaże się błąd.
7. Zablokuj lokalizację (uprawnienia) → spróbuj pobrać GPS → pokaże się komunikat.


## Propozycja minimum 3 commitów

1. `feat: init Geo Memoir screens + store`
2. `feat: add GPS + photo to entry form`
3. `feat: add API GET/POST + states + README`

## Uwagi

- Na Androidzie wymagany jest prawidłowy **Google Maps API Key** w `android/app/src/main/AndroidManifest.xml`.
- Projekt używa prostego zapisu lokalnego w `SharedPreferences`.

