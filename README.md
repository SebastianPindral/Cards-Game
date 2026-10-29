Cards-Game

Karciana gra strategiczna stworzona w silniku Godot, przenosząca kilka znanych gier karcianych wieloosobowych do wersji cyfrowej. 
Rozgrywka prowadzona przeciwko algorytmom w formie asynchronicznej.

W projekcie skupiłem się na stworzeniu solidnej architektury logicznej dla gry karcianej. 
Najważniejsze systemy to:
**Dynamiczny System Kart:** Obsługa stanów karty (w talii, na ręce, zagrana, stos odrzuconych) za pomocą sygnałów i maszyn stanów.

**każdy z elementów gry został zaprojektowany tak by można było zmienić jedną grę w inna 
przez samą zmianę zasad bez konieczności każdorazowego modyfikowania Frameworku.

**Architektura oparta na zasobach (Custom Resources):** Statystyki kart, grafiki i efekty są zdefiniowane jako osobne pliki `.tres`, co pozwala na łatwe dodawanie nowej zawartości bez modyfikacji kodu scen. 
**Interfejs Użytkownika (UI):** Responsywny UI dostosowany do mechaniki karcianej (drag and drop kart, podgląd talii, płynne animacje interfejsu przy użyciu `Tween`).

## Jak uruchomić projekt lokalnie? 
1. Sklonuj to repozytorium na swój komputer.
2. Pobierz i zainstaluj **Godot Engine** (wersja 4.3 zalecana).
3. W Godot Project Managerze kliknij **Import** i wskaż plik `project.godot` znajdujący się w tym folderze.
4. Uruchom projekt, naciskając klawisz **F5**.
