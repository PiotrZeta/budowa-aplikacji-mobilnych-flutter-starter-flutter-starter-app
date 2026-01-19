# Sprawozdanie 2: Budowa aplikacji mobilnych z użyciem technologii frontendowych

**Imię i nazwisko studenta:** Piotr Zdebel  
**Grupa:**  
**Data:** 19.01.2026

---

## Część teoretyczna

### Hybrydowe aplikacje mobilne vs. natywne aplikacje mobilne

**Zagadnienie:**  
Aplikacje **natywne** są tworzone osobno dla każdej platformy (Android/iOS) w jej typowym ekosystemie (np. Kotlin/Java w Androidzie, Swift/Objective‑C w iOS). Aplikacje **hybrydowe / cross‑platform** wykorzystują jedną bazę kodu do budowania wersji na różne platformy (np. Flutter, React Native, NativeScript). Różnice w praktyce dotyczą architektury, wydajności, dostępu do funkcji urządzenia i kosztów.

**Aplikacje natywne**:
- **Architektura:** kod i UI bezpośrednio pod platformę (Android/iOS), wykorzystuje natywne komponenty i biblioteki.
- **Wydajność:** zwykle najwyższa – brak dodatkowej warstwy pośredniej, najlepsze wsparcie dla animacji i cięższych operacji.
- **Dostęp do API urządzenia:** najszybszy i najpełniejszy (kamera, Bluetooth, czujniki, tło, itp.).
- **Koszt/czas:** zwykle większy, bo często trzeba utrzymywać 2 aplikacje (Android i iOS).

**Aplikacje hybrydowe / cross‑platform**:
- **Architektura:** jedna aplikacja w jednym języku/frameworku, a integracja z urządzeniem przez most/plug‑iny.
- **Wydajność:** bardzo dobra, ale zależy od technologii. Flutter renderuje UI własnym silnikiem, React Native korzysta z natywnych komponentów przez warstwę pośrednią.
- **Dostęp do API urządzenia:** dostępny przez biblioteki/plug‑iny (np. geolocator, image_picker). Czasem trzeba dopisać kod natywny, gdy brakuje gotowego plug‑inu.
- **Koszt/czas:** często mniejszy (jeden zespół, jeden kod), szybsze wdrożenie.

#### Pytania kontrolne
1. **Co decyduje o tym, że aplikacja jest natywna, a co — że hybrydowa?**  
   Natywna: kod i UI tworzone bezpośrednio dla Android/iOS w ich technologiach. Hybrydowa/cross‑platform: jedna baza kodu uruchamiana na wielu platformach przez framework (np. Flutter/React Native) i integrację przez plug‑iny.
2. **Jakie są kluczowe różnice w wydajności między tymi rozwiązaniami?**  
   Natywne zwykle osiągają najlepszą wydajność i najniższe opóźnienia. Cross‑platform może mieć narzut (np. most komunikacyjny lub dodatkowy rendering), ale w wielu aplikacjach różnica jest mało odczuwalna.
3. **W jakich przypadkach warto wybrać rozwiązanie hybrydowe, a w jakich natywne?**  
   Hybrydowe/cross‑platform: szybkie MVP, aplikacje CRUD, ograniczony budżet, jedna aplikacja na Android/iOS. Natywne: gry 3D, bardzo wymagające UI/animacje, integracje systemowe „na granicy możliwości”, aplikacje działające mocno w tle.
4. **Jak wygląda utrzymanie i rozwój aplikacji w obu podejściach?**  
   Natywne: często 2 osobne codebase’y → więcej pracy przy zmianach. Cross‑platform: jedna baza kodu → łatwiej utrzymać spójność, ale trzeba pilnować kompatybilności plug‑inów i aktualizacji SDK.

| Cecha | Aplikacje natywne | Aplikacje hybrydowe / cross‑platform |
|-------|-------------------|--------------------------------------|
| Języki programowania | Kotlin/Java (Android), Swift/Obj‑C (iOS) | Dart (Flutter), JS/TS (React Native), JS/TS (NativeScript) |
| Wydajność | Zwykle najwyższa | Zwykle bardzo dobra; zależna od frameworku i użytych pluginów |
| Dostęp do API urządzenia | Pełny, bezpośredni | Przez pluginy/most; czasem potrzebny kod natywny |
| Koszt utrzymania | Wyższy (często 2 aplikacje) | Niższy (jedna baza kodu) |
| Czas wdrożenia | Dłuższy | Krótszy (szybciej powstaje MVP) |
| Aktualizacje | Osobno dla Android/iOS | Często jedna zmiana w kodzie dla obu platform |

**Wnioski:**  
Wybór technologii zależy od wymagań biznesowych i technicznych. Jeśli priorytetem jest szybkie dostarczenie aplikacji na wiele platform, sensowne jest podejście cross‑platform (np. Flutter). Jeśli priorytetem są maksymalna wydajność i bardzo głębokie integracje systemowe – warto rozważyć natywne rozwiązanie.

---

### Progressive Web Apps (PWA) jako alternatywa dla tradycyjnych aplikacji mobilnych

**Zagadnienie:**  
**PWA** to aplikacje webowe, które zachowują się „jak aplikacje mobilne”: mogą być instalowane, działać offline, korzystać z cache oraz (w wybranych przypadkach) z powiadomień. PWA działają w przeglądarce, więc mają ograniczony dostęp do funkcji systemowych w porównaniu do aplikacji natywnych/cross‑platform.

#### Pytania kontrolne
1. **Jakie cechy odróżniają PWA od klasycznych stron internetowych?**  
   Instalowalność, własna ikona, uruchamianie jak aplikacja, cache offline, lepsze działanie w słabej sieci.
2. **Jakie technologie umożliwiają działanie PWA w trybie offline i powiadomienia push?**  
   Service Worker + Cache Storage/IndexedDB (offline), Web Push + Service Worker (push).
3. **Jakie ograniczenia mają PWA w dostępie do natywnych funkcji urządzenia?**  
   Ograniczenia zależne od przeglądarki/systemu (np. tło, czujniki, Bluetooth, pliki). Część funkcji może nie działać na iOS lub wymagać obejść.
4. **W jakich zastosowaniach PWA może być lepszym wyborem niż aplikacja natywna?**  
   Gdy kluczowa jest szybkość wdrożenia, dostępność przez URL, brak potrzeby publikacji w sklepie, proste aplikacje biznesowe (formularze, katalogi, dashboardy) i szeroki zasięg.

**Wnioski:**  
PWA to dobra alternatywa dla prostych aplikacji informacyjnych i biznesowych, szczególnie gdy liczy się czas i koszt. Dla aplikacji wymagających bogatych funkcji urządzenia (kamera, GPS, działanie w tle) częściej wybiera się Flutter/React Native lub natywne rozwiązania.
