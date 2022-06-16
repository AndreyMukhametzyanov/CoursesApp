# Установка менеджера версий ASDF с нуля:
1. Устанавливаем git и зависимости
```shell script
$ sudo apt install curl git
```
2. Подгружаем актуальный список пакетов и обновляемся:
```shell script
$ sudo apt update && sudo apt upgrade
```
3. Качаем ASDF:
```shell script
$ git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
```
4. Устанавливаем ASDF (подрубаемся к шеллу):
```shell script
$ . $HOME/.asdf/asdf.sh
```
если не прописались зависимости добавляем их сами 
```shell script
$ echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc

$ echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
```
5. Проверяем через любой редактор, что все прописалось в файле .bashrc:
```shell script
$ cat .bashrc
```
6. Проверяем что ASDF находится:
```shell script
$ asdf
```
7. Устанавливаем компиляторы (не всегда требуется):
```shell script
$ sudo apt-get install gcc
```
8. Устанавливваем следующие системные зависимости:
```shell script
$ sudo apt install automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev unzip curl
$ sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
```
9. Устанавливаем глобально Руби и проверяем что все ок:
```shell script
$ asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
$ asdf list-all ruby
$ asdf install ruby 3.1.2
$ asdf global ruby 3.1.2
$ ruby -v
```
10. Устанавливаем глобально NodeJs через ASDF и проверяем что все ок:
```shell script
$ asdf plugin-add nodejs
$ asdf list-all nodejs
$ asdf install nodejs 14.19.3
$ nodejs
$ asdf global nodejs 14.19.3
$ node -v
```
11. Устанавливаем и запускаем БД:
```shell script
$ sudo apt install postgresql postgresql-contrib
$ sudo service postgresql start
```
12. Делаем себя суперменом:
```shell script
$ sudo -u postgres createuser --superuser *имя*
```
13. Устанавливаем Yarn, чтоб JS не ругался:
```shell script
$ yarn install
$ npm install --global yarn
```
14. Устанавливаем библиотеку для связи с БД:
```shell script
$ sudo apt-get install libpq-dev
```
15. Разворачиваем проект и проверяем что все ок:
```shell script
$ mkdir ruby_projects
$ cd ruby_projects/
$ git clone *ссылка на GIT*
$ cd *корень проекта*/
$ bundle install
$ rails db:create
$ rspec
$ rails s
```
На этом все. Вы потрясающий! 
