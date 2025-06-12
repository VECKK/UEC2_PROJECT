# Repozytorium GIT na potrzeby Projektu UEC2

Repozytorium do tworzenia projektu gry na przedmiot Układy Elektroniki cyfrowej 2.

AGH, EAIiIB, MTM

Autorstwo: Wiktoria Borycka, Kacper Kierzek

## Programowanie płytki basys 3

Po podłączeniu płytki pod port USB należy uruchomić:

```bash
. env.sh
program_fpga.sh
```

## Inne dostępne narzędzia

Wyczyszczenie wszystkich tymczasowych plików, sprecyzowane w .gitignore

```bash
clean.sh
```

Wygenerowanie nowego bitstreamu, wynik w /results

```bash
generate_bitstream.sh
```