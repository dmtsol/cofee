# Cofee — Калькулятор пропорций кофе

Мобильное и десктопное приложение для расчёта пропорций кофе и воды при заваривании. Позволяет задать собственное базовое соотношение (например, 60 г кофе на 1000 мл воды), автоматически пересчитывает один параметр из другого, сохраняет рецепты и переключает тему оформления.

---

## Возможности

- **Произвольная пропорция** — задайте базовые значения кофе (г) и воды (мл). Например, 60 г на 1000 мл — и приложение рассчитает соотношение.
- **Двусторонний расчёт** — измените количество кофе → вода пересчитается автоматически, и наоборот.
- **Помол** — сохраняйте номер помола вместе с каждым рецептом.
- **Сохранение рецептов** — все рецепты хранятся локально на устройстве. Можно загрузить любой сохранённый рецепт в калькулятор одним нажатием.
- **Три темы оформления** — светлая, тёмная или системная (Material 3).

---

## Скриншоты

### Android

<p float="left">
  <img src="screenshots/android/cofee-android-01.jpg" width="250" />
  <img src="screenshots/android/cofee-android-02.jpg" width="250" />
  <img src="screenshots/android/cofee-android-03.jpg" width="250" />
</p>

### Linux

<p float="left">
  <img src="screenshots/linux/cofee-linux-01.png" width="400" />
  <img src="screenshots/linux/cofee-linux-02.png" width="400" />
</p>
<p float="left">
  <img src="screenshots/linux/cofee-linux-03.png" width="400" />
  <img src="screenshots/linux/cofee-linux-04.png" width="400" />
  <img src="screenshots/linux/cofee-linux-05.png" width="400" />
</p>

---

## Как использовать

1. Установите приложение (см. [ Downloads](#downloads)).
2. На главном экране задайте **базовую пропорцию**: например, кофе 60 г, вода 1000 мл.
3. Укажите желаемое количество воды (или кофе) — второе поле рассчитается автоматически.
4. При необходимости укажите помол и сохраните рецепт.
5. В разделе «Рецепты» можно просмотреть, удалить или загрузить сохранённые рецепты.

---

## Системные требования

### Android
- **ОС**: Android 7.0 (API 24) или новее
- **RAM**: от 2 ГБ
- **Свободное место**: ~200 МБ

### Linux (x64)
- **ОС**: любой дистрибутив с glibc 2.31+
- **GTK**: GTK 3.0 или новее
- **RAM**: от 2 ГБ
- **Свободное место**: ~200 МБ

---

## Сборка из исходников

### Требуемый toolchain

| Компонент | Версия | Назначение |
|-----------|--------|------------|
| **Flutter** (stable) | >= 3.5.0, Dart ^3.5.0 | Фреймворк |
| **Java JDK** | 17+ | Сборка Android |
| **Android SDK** | 34+ (platform 34) | Сборка Android |
| **Android NDK** | 28.2+ (устанавливается Gradle) | Нативные библиотеки |
| **Gradle** | 8.x (обёртка в проекте) | Система сборки |
| **Linux:** cmake, clang++, GTK3, pkg-config, ninja-build | — | Сборка Linux |

### Сборка

```bash
# Установить зависимости
flutter pub get

# Запустить на подключённом устройстве
flutter run

# Android (debug)
flutter build apk --debug
# → build/app/outputs/flutter-apk/app-debug.apk

# Android (release)
flutter build apk --release
# → build/app/outputs/flutter-apk/cofee-release.apk

# Linux x64 (debug)
flutter build linux --debug
# → build/linux/x64/debug/bundle/

# Linux x64 (release)
flutter build linux --release
# → build/linux/x64/release/bundle/
```

### Автоматизация (Makefile)

```bash
make android-release   # собрать Android release
make linux-release     # собрать Linux release
make help              # список всех целей
```

Makefile упаковывает Linux-бинарник в `cofee-{version}-linux-{variant}.tar.gz` автоматически.

### Примечания

- Android SDK и NDK загружаются автоматически при первой сборке через Gradle
- Для `flutter build apk --release` используется debug-подпись (не подходит для Google Play)
- APK переименовывается с указанием версии через Makefile (см. `Makefile`)

---

## Технологии

- **Flutter** / **Dart**
- **Provider** — управление состоянием
- **path_provider** — хранение рецептов в JSON-файле
- **shared_preferences** — сохранение выбранной темы
- **Material Design 3**

---

## Downloads

| Платформа | Ссылка |
|-----------|--------|
| Android APK (release) | [cofee-1.0.0-release.apk](https://github.com/dmtsol/cofee/releases/download/v1.0.0/cofee-1.0.0-release.apk) |
| Linux x64 (release) | [cofee-1.0.0-linux-release.tar.gz](https://github.com/dmtsol/cofee/releases/download/v1.0.0/cofee-1.0.0-linux-release.tar.gz) |

---

## Лицензия

MIT License — см. файл [LICENSE](LICENSE).
