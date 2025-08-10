up:
	docker compose up --build -d

down:
	docker compose down

lms-console:
	docker compose exec lms bundle exec rails console

crs-console:
	docker compose exec crs bundle exec rails console

lms-console-test:
	docker compose exec -e RAILS_ENV=test lms bundle exec rails console

crs-console-test:
	docker compose exec -e RAILS_ENV=test crs bundle exec rails console

lms-test:
	docker compose exec -e RAILS_ENV=test lms bundle exec rspec

crs-test:
	docker compose exec -e RAILS_ENV=test crs bundle exec rspec
