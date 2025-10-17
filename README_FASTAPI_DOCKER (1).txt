Швидкий гайд: Клонування FastAPI-застосунку та запуск у Docker Compose
======================================================================

1) Клонування репозиторію
-------------------------
git clone https://github.com/GoIT-Python-Web/Computer-Systems-hw02
cd Computer-Systems-hw02

2) Створити файли для Docker
----------------------------
У корені клонованого проєкту створіть два файли (з цього архіву/відповіді):
- Dockerfile
- docker-compose.yaml

Переконайтесь, що у проєкті є requirements.txt (він є в репозиторії).

3) Налаштувати рядок підключення до БД
--------------------------------------
Відкрийте файл conf/db.py і змініть рядок підключення:
  Було:
    SQLALCHEMY_DATABASE_URL = f"postgresql+psycopg2://postgres:567234@localhost:5432/hw02"
  Має бути (замість localhost використати ім'я сервісу в docker-compose — db):
    SQLALCHEMY_DATABASE_URL = "postgresql+psycopg2://postgres:567234@db:5432/hw02"

Альтернатива: якщо у вашому коді є читання змінної оточення, можна використовувати env-перемінну
SQLALCHEMY_DATABASE_URL, яку ми передаємо у docker-compose.yaml, і не змінювати conf/db.py.

4) Запуск середовища
--------------------
docker compose up --build
# або (залежно від версії Docker)
# docker-compose up --build

Docker збере імідж застосунку, запустить PostgreSQL та сам застосунок.

5) Перевірка роботи
-------------------
Відкрийте в браузері: http://localhost:8000
- Ви маєте побачити сторінку "Welcome to FastAPI!" та кнопку "Перевірити БД".
- Після натискання "Перевірити БД" повинно з'явитися повідомлення, що підключення успішне.

Додатково можна перевірити інтерактивну документацію:
  http://localhost:8000/docs
  http://localhost:8000/redoc

Якщо бачите помилку замість "Welcome to FastAPI!" — перевірте:
- що у conf/db.py хост саме db (не localhost)
- що у docker-compose.yaml сервіси називаються app та db, і app залежить від db (depends_on + healthcheck)
- що пароль/юзер/БД збігаються: postgres / 567234 / hw02

6) Корисні команди
------------------
Зупинити середовище:
  docker compose down

Перезапустити з перебудовою образу:
  docker compose up --build -d

Подивитися логи:
  docker compose logs -f
  docker compose logs -f app
  docker compose logs -f db

Зайти в контейнер застосунку:
  docker compose exec app /bin/sh

7) Швидке виправлення conf/db.py командою sed (за бажанням)
-----------------------------------------------------------
# Знаходячись у корені проєкту, виконайте:
sed -i.bak 's/@localhost:/@db:/g' conf/db.py
# Це створить резервну копію conf/db.py.bak і замінить localhost на db.
