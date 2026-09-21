COMPOSE ?= docker-compose
SERVICE ?= app

.PHONY: help build up start down stop restart logs ps sh claude codex test lint clean rebuild

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

build: ## Build the app image
	$(COMPOSE) build

up: ## Start the app in the background
	$(COMPOSE) up -d

start: ## Start the app in the foreground
	$(COMPOSE) up

down: ## Stop and remove containers
	$(COMPOSE) down

stop: ## Stop containers without removing them
	$(COMPOSE) stop

restart: ## Restart the app service
	$(COMPOSE) restart $(SERVICE)

logs: ## Follow app logs
	$(COMPOSE) logs -f $(SERVICE)

ps: ## Show running containers
	$(COMPOSE) ps

sh: ## Open a shell inside the app container
	$(COMPOSE) exec $(SERVICE) bash

claude: ## Run `claude` inside the app container
	$(COMPOSE) exec $(SERVICE) claude

codex: ## Run `codex` inside the app container
	$(COMPOSE) exec $(SERVICE) codex

test: ## Run tests inside the app container
	$(COMPOSE) exec $(SERVICE) npm test

lint: ## Run linter inside the app container
	$(COMPOSE) exec $(SERVICE) npm run lint

rebuild: ## Rebuild the image without cache
	$(COMPOSE) build --no-cache

clean: ## Remove containers, networks and volumes
	$(COMPOSE) down -v --remove-orphans
