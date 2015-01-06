build:
	@git submodule update --init --recursive
	@make build-icons
	@make build-default
	@make build-rails
	@make build-node

build-default:
	@echo "Getting latest..."
	@git pull origin master
	
	@echo "Installing node dependencies..."
	@npm install
	
	@echo "Installing ruby dependencies..."
	@bundle
	
	@echo "Running tests..."
	@gulp docs:test
	
	@echo "Building project"
	@gulp build

build-rails:
	@echo "Bumping Rails gem version"
	@cd lib-docs/rails;gem bump
	
	@echo "Copying in assets"
	@mkdir -p rails
	@rm -rf rails/*
	@cp -r lib-docs/rails/app rails/
	@cp -r lib-docs/rails/lib rails/
	# @cp -r lib/sass/* rails/app/assets/stylesheets/
	@rsync -av --exclude-from 'rsync-exclude.txt' lib-core/sass/ rails/app/assets/stylesheets/
	@cp lib-core/sass/themes/default/theme.sass lib-docs/sass/themes/default/
	@cp public/js/kickstart.js rails/app/assets/javascripts/kickstart_rails
	@cp lib-docs/rails/Gemfile lib-docs/rails/kickstart_rails.gemspec lib-docs/rails/LICENSE lib-docs/rails/Rakefile lib-docs/rails/README.md rails/
	@cd rails;gem release

build-node:
	@npm version patch
	@npm publish

build-icons:
	@mkdir -p docs
	@mkdir -p docs/svgs
	@echo "Generating SVGs"
	@./build.rb

setup:
	@make build-icons
	@sudo npm install -g gulp
	@sudo npm install
	@bundle install
	@make build-default
