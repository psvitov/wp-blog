# Описание задачи:

Требуется написать скрипт, который создает инфраструктуру и разворачивает  блог wordpress на одном сервере. При создании инфраструктуры для размещения блога необходимо использовать Docker.

Веб-сервер: любой

Бэкенд: PHP

БД: mysql

Блог должен быть доступен по адресу blog.example.com

Также требуется настроить простой мониторинг. Обязательные параметры: загрузка памяти (диска и ОЗУ), загрузка CPU. Дополнительные параметры приветствуются.
Особенности реализации - на ваше усмотрение. Желательно использовать Prometheus+Grafana.
Результат выполнения выложить в отдельный открытый репозиторий на Github и прислать на него ссылку. В репозитории также должна быть краткая инструкция как развернуть решение.

## Подготовительные работы:

Для создания облачной инфраструктуры и последующей работой с ней необходимо на локальный компьютер с ОС `Linux` установить следующее программное обеспечение:

- Git ([Документация](https://git-scm.com/download/linux))
- Ansible ([Документация](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))
- Terraform ([Документация](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))

Установка настроена на облачный сервис Yandex.Cloud
Для установки в других облачных сервисах необходимо изменить описание провайдена в файле main.tf

## 1 этап: скачивание репозитория

```
git clone https://github.com/psvitov/wp-blog.git
```

Структура репозитория:

```
├── ansible
├── ansible.cfg
├── ansible.tf
├── inventory.tf
├── main.tf
├── meta.txt
├── monitoring
│   ├── metrics
│   ├── node_exporter.service
│   └── prometheus.service
├── monitoring.yml
├── network.tf
├── variables.tf
├── vpc.tf
├── wp
│   ├── .env
│   ├── docker-compose.yml
│   ├── settings.sh
│   └── site.env
└── wp-blog.yml
```

- каталог Ansible: предназначен для формирования временных файлов манифеста Ansible
- ansible.cfg: конфигурационный файл Ansible
- ansible.tf: запуск манифестов Ansible после создания инфраструктуры
- inventory.tf: создание инвентори-файла для Ansible
- main.tf: основной файл Terraform
- meta.txt: файл конфигурации пользователя на удаленных серверах
- каталог monitoring: каталог с системными файлами для установки и настройки мониторинга
- monitoring.yml: манифест Ansible для настройки мониторинга
- network.tf: файл сетевых настроек Terraform
- variables.tf: файл переменных Terraform
- vpc.tf:файл для создания ВМ Terraform
- каталог wp: каталог для настройки блога Wordpress
- wp-blog.yml: манифест Ansible для настройки блога Wordpress

# 2 этап: предварительная настройка

 В файле meta.txt внести следующие данные:

 - `name: <user>` указать имя пользователя от чьего имени будет проводиться установка
 - `- <ssh-key>` указать SSH-ключ пользователя

 В файле variables.tf внести следующие данные:

 - `default = "OAuth key"` указать токен Yandex.Cloud
 - `default = "ID Yandex.Cloud"` указать идентификатор ключа доступа к Yandex.Cloud

В файле wp/.env заменить данные на актуальные:

```
WORDPRESS_DB_HOST=db
WORDPRESS_DB_NAME=mysql
WORDPRESS_DB_PASSWORD=123456
WORDPRESS_DB_USER=admin
MYSQL_DATABASE=mysql
MYSQL_PASSWORD=123456
MYSQL_RANDOM_ROOT_PASSWORD=1
MYSQL_USER=admin
```
В файле wp/site.env заменить данные на актуальные:

```
TITLE=example
URL=blog.example.com
ADMIN_USER=admin
ADMIN_PASSWORD=123
ADMIN_EMAIL=admin@example.com
```
### Примечание: 
Lля доступа по DNS-имени, прописанному в переменной URL, необходимо указывать реальный домен и настроить DNS-записи
В случае локальной установки необходимо сделать DNS-запись на сервере, либо в файле hosts добавить строку в зависимости от используемой ОС:

- Windows XP, 2003, Vista, 7, 8, 10 — c:\windows\system32\drivers\etc\hosts
- Linux, Ubuntu, Unix, BSD — /etc/hosts
- macOS — /private/etc/hosts

```
<ip address> blog.example.com www.blog.example.com
```
В файле monitoring/metrics заменить данные в последней строке на актуальные:

```
  - job_name: 'node_exporter_clients'
    scrape_interval: 5s
    static_configs:
      - targets:
          - localhost:9100
```

# 3 этап: установка

Инициализация провайдера:

```
terraform init
```

Проверка плана установки:

```
terraform plan
```

Установка облачной инфраструктуры и настройка сервера:

```
terraform apply
```

# 4 этап: проверка установки

Скриншот блога Wordpress:

![0.png](https://github.com/psvitov/wp-blog/blob/main/0.png)

Скриншот Prometheus

![1.png](https://github.com/psvitov/wp-blog/blob/main/1.png)

Скриншот Node Exporter

![2.png](https://github.com/psvitov/wp-blog/blob/main/2.png)

Скриншот Grafana

![3.png](https://github.com/psvitov/wp-blog/blob/main/3.png)

# 5 этап: дополнительная настройка Grafana

Для вывода метрик сервера необходимо настроить соединение Grafana и Prometheu, и подключить дашбоард метрик Node exporter

- при первом входе в Grafana необходимо будет задать пароль
- в разделе `Administrations - Data Source` нажать `Add new Data Source`, выбрать Prometheus, указать в строке URL: http://localhost:9090, сохранить и протестировать соединение
- в разделе `Dashboard - New - Import` в строке Grafana ID указать 1860, нажать Load, выбрать подключенный сервер Prometheus в соответствующей строке, нажать Import

После добавления нового дашбоарда:

![4.png](https://github.com/psvitov/wp-blog/blob/main/4.png)

---

# Дополнительные вопросы:

1. По какому принципу работает программа traceroute?

## Ответ:
traceroute - программа построения маршрута от источника до определенного адресата, выстаривает цепочку сетевых устройств путем пересылки запроса от устройства к устройству

2. В чем отличие между KVM, XEN и OpenVZ. Какие преимущества и недостатки каждой из этих технологий вы знаете?

### KVM
Плюсы: полная аппаратная виртуализация, распределение общих ресурсов
Минусы: работает только на оборудовании, поддерживающем аппаратную виртуализацию

### XEN 
Плюсы: полная аппаратная виртуализация и паравиртуализация, стабильность, хорошая производительность
Минусы: большой расход ресурсов на эмуляцию аппаратных функций

### OpenVZ 
Плюсы: Хорошая производительность и распределение ресурсов
Минусы: работает только на Linux

3. Что такое InnoDB и MyISAM?

## Ответ:
InnoDB и MyISAM - движки СУБД MySQL

4. Какие базы данных под Linux вы знаете ?

## Ответ:
MySQL, PostgreSQL, MongoDB, MariaDB, Clickhouse

5. Что такое swap ?

## Ответ:
SWAP - буфер виртуальной памяти, исполбзуемый как файл подкачки при нехватке аппаратной ОЗУ, так же используется для гибернации - сохраняет образ памяти во время сна. 
