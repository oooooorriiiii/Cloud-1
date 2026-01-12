NAME = inception
DOCKER_COMPOSE = docker compose -f ./docker-compose.yml
DATA_PATH = ./data

all: up

up:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	$(DOCKER_COMPOSE) up -d --build

down:
	$(DOCKER_COMPOSE) down

stop:
	$(DOCKER_COMPOSE) stop

start:
	$(DOCKER_COMPOSE) start

clean:
	$(DOCKER_COMPOSE) down --rmi all -v

fclean: clean
	@sudo rm -rf $(DATA_PATH)
	@echo "Data directories (persistence) strictly removed."

re: fclean up

logs:
	$(DOCKER_COMPOSE) logs -f

ps:
	$(DOCKER_COMPOSE) ps

.PHONY: all up down stop start clean fclean re logs ps