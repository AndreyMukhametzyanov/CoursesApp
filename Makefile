.PHONY: check
check:
	bundle exec annotate --frozen
	bundle exec bundle-audit check --update
	bundle exec brakeman --no-pager
	bundle exec rubocop
	bundle exec rspec

.PHONY: docker_start
docker_start:
	docker-compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from course_app
#Запускаем докер с условниями: 1) Останавливаем все контейнеры, если какой-либо контейнер был остановле
#2)возвращам код выхода выбранного сервисного контейнера.

.PHONY: docker_stop
docker_stop:
	docker-compose -f docker-compose.yml down --remove-orphans --volumes
#закрываем докер с опциями удаления контейнеров и томов