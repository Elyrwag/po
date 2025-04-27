# po
Projektowanie obiektowe

### Zadanie 1: Pascal

:white_check_mark: 3.0 procedura do generowania 50 losowych liczb od 0 do 100

:white_check_mark: 3.5 procedura do sortowania liczb

:white_check_mark: 4.0 dodanie parametrów do procedury losującej określających zakres losowania: od, do, ile

:white_check_mark: 4.5 5 testów jednostkowych testujące procedury

:white_check_mark: 5.0 skrypt w bashu do uruchamiania aplikacji w Pascalu

**Commit zbiorczy**: [commit 5 i poniżej](https://github.com/Elyrwag/po/commit/6f5a8c0c6bd311fd7a91456e36e021f1417ee1d7)

**Kod**: [pascal](https://github.com/Elyrwag/po/tree/main/pascal)


### Zadanie 2: PHP

framework Symfony w PHP, baza danych: SQLite

:white_check_mark: 3.0 model z kontrolerem z produktami, zgodnie z CRUD

:white_check_mark: 3.5 skrypty do testów endpointów via curl

:white_check_mark: 4.0 dwa dodatkowe kontrolery wraz z modelami (kategorie, opinie)

:white_check_mark: 4.5 widoki do wszystkich kontrolerów

:white_check_mark: 5.0 panel administracyjny z mockowanym logowaniem

**Commit zbiorczy**: [commit 5 i poniżej](https://github.com/Elyrwag/po/commit/7284992fd0e8076aec650afde55b473a3865562c)

**Kod**: [symfony-php](https://github.com/Elyrwag/po/tree/main/symfony-php)


### Zadanie 3: Kotlin

framework Spring Boot w Kotlinie

:white_check_mark: 3.0 kontroler wraz z danymi wyświetlanymi z listy na endpoint’cie w formacie JSON

:white_check_mark: 3.5 klasa do autoryzacji (mock) jako Singleton w formie eager

:white_check_mark: 4.0 obsługiwanie danych autoryzacji przekazywanych przez użytkownika

:white_check_mark: 4.5 wstrzykiwanie Singletonu do głównej klasy via @Autowired

:white_check_mark: 5.0 do wyboru również wersja Singletona w wersji lazy

**Commit zbiorczy**: [commit 5 i poniżej](https://github.com/Elyrwag/po/commit/c3ab1c1bfb263d9aa76deb0b705c8ffa1f579f5e)

**Kod**: [spring-kotlin](https://github.com/Elyrwag/po/tree/main/spring-kotlin)


### Zadanie 4: Go

framework Echo w Go, baza danych: SQLite, serwis zewnętrzny: OpenWeatherMap

:white_check_mark: 3.0 aplikacja, która posiada kontroler Pogody oraz pozwala na pobieranie danych o pogodzie

:white_check_mark: 3.5 model Pogoda wykorzystując gorm

:white_check_mark: 4.0 klasa proxy, która pobierze dane z serwisu zewnętrznego podczas zapytania do naszego kontrolera

:white_check_mark: 4.5 zapisanie pobranych danych z zewnątrz do bazy danych

:white_check_mark: 5.0 rozszerzenie endpointu na więcej niż jedną lokalizację

**Commit zbiorczy**: [commit 5 i poniżej](https://github.com/Elyrwag/po/commit/eb7edd66b22754a8490269e4d6b2dbe7c054f7e8)

**Kod**: [echo-go](https://github.com/Elyrwag/po/tree/main/echo-go)


### Zadanie 5: React + Go

Aplikacja webowa - sklep 

Frontend: React, Backend: Go

:white_check_mark: 3.0 dwa komponenty: Produkty oraz Płatności. Płatności wysyłają do aplikacji serwerowej dane, a w Produktach pobierane są dane o produktach z aplikacji serwerowej

:white_check_mark: 3.5 Koszyk wraz z widokiem; wykorzystany routing

:white_check_mark: 4.0 React hooks do przesyłania danych pomiędzy wszystkimi komponentami

:white_check_mark: 4.5 skrypt uruchamiający aplikację serwerową oraz kliencką na dockerze via docker-compose

:white_check_mark: 5.0 axios oraz nagłówki pod CORS

**Commit zbiorczy**: [commit 5 i poniżej](https://github.com/Elyrwag/po/commit/)

**Kod**: [shop-app](https://github.com/Elyrwag/po/tree/main/shop-app)

