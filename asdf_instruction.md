# Установка и настройка ASDF

1. sudo apt install curl git
2. sudo apt update
3. sudo apt upgrade
4. git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
5.  . $HOME/.asdf/asdf.sh
6. cat .bashrc
7. asdf
8. asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
9. asdf list-all ruby
10. asdf install ruby 3.1.2
11. apt-get install gcc
12. sudo apt-get install gcc
13. sudo apt install automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev unzip curl
14. sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
15. asdf plugin-add nodejs
16. asdf list-all nodejs
17. asdf install nodejs 14.19.3
18. nodejs
19. asdf global nodejs 14.19.3
20. node -v
21. asdf global ruby 3.1.2
22. ruby -v
23. sudo apt install postgresql postgresql-contrib
24. sudo service postgresql start
25. mkdir ruby_projects
26. cd ruby_projects/
27. git clone https://github.com/AndreyMukhametzyanov/CoursesApp.git
28. cd CoursesApp/
29. bundle install
30. sudo apt-get install libpq-dev
31. bundle install
32. sudo -u postgres createuser --superuser *имя*
33. rails db:create
34. rspec
35. rails s
36. yarn install
37. npm install --global yarn
38. yarn install
39. rails s
