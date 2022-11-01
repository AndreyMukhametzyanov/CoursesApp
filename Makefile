.PHONY: check
check:
	bundle exec annotate --frozen
	bundle exec bundle-audit check --update
	bundle exec brakeman --no-pager
	bundle exec rubocop
	bundle exec rspec
