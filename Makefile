VERSION := $(shell grep 'version:' pubspec.yaml | head -1 | awk '{print $$2}' | cut -d'+' -f1)

.PHONY: help android-debug android-release linux-debug linux-release

help:
	@echo "Usage: make <target>"
	@echo "  android-debug   Build Android APK (debug)   -> cofee-$(VERSION)-debug.apk"
	@echo "  android-release Build Android APK (release) -> cofee-$(VERSION)-release.apk"
	@echo "  linux-debug     Build Linux bundle (debug)  -> cofee-$(VERSION)-linux-debug.tar.gz"
	@echo "  linux-release   Build Linux bundle (release)-> cofee-$(VERSION)-linux-release.tar.gz"

android-debug:
	flutter build apk --debug
	mv -f build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/cofee-$(VERSION)-debug.apk

android-release:
	flutter build apk --release
	mv -f build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/cofee-$(VERSION)-release.apk

linux-debug:
	flutter build linux --debug
	tar -czf cofee-$(VERSION)-linux-debug.tar.gz -C build/linux/x64/debug/bundle/ .

linux-release:
	flutter build linux --release
	tar -czf cofee-$(VERSION)-linux-release.tar.gz -C build/linux/x64/release/bundle/ .
