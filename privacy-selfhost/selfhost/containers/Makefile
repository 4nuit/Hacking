SHELL := /bin/bash
NETWORKS := frontend backend

# Dockerfiles
LLAMA_DIR := $(HOME)/containers/llama.cpp
STIRLING_DIR := $(HOME)/containers/stirling-pdf
NEXTCLOUD_DIR := $(HOME)/containers/nextcloud

# Volumes
STIRLING_DATA := $(HOME)/Containers-data/stirling
NEXTCLOUD_DATA := $(HOME)/Containers-data/nextcloud
NEXTCLOUD_DB := $(HOME)/Containers-data/nextcloud-db

NC_UID := 33
NC_GID := 33

DB_UID := 999
DB_GID := 999

.PHONY: \
	llama-up llama-down llama-restart llama-logs llama-cli \
	stirling-up stirling-down stirling-restart stirling-logs \
	nextcloud-up nextcloud-stop nextcloud-down nextcloud-restart nextcloud-logs \
	status clean help

help:
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  make llama-up (using MODEL variable, default qwen)"
	@echo "  make llama-down"
	@echo "  make llama-restart"
	@echo "  make llama-logs"
	@echo ""
	@echo "  make stirling-up"
	@echo "  make stirling-down"
	@echo "  make stirling-restart"
	@echo "  make stirling-logs"
	@echo ""
	@echo "  make nextcloud-up"
	@echo "  make nextcloud-down"
	@echo "  make nextcloud-restart"
	@echo "  make nextcloud-logs"
	@echo ""
	@echo "  make status"
	@echo "  make net-status"

	@echo "  make clean"
	@echo ""

#
# LLAMA SERVER
#

llama-up:
	MODEL=/models/qwen/Qwen3.5-0.8B-Base-Q4_0.gguf docker compose -f $(LLAMA_DIR)/docker-compose.yml up -d

llama-down:
	docker compose -f $(LLAMA_DIR)/docker-compose.yml stop

llama-restart:
	docker compose -f $(LLAMA_DIR)/docker-compose.yml restart

llama-logs:
	docker logs -f llama-server

#
# STIRLING PDF
#

stirling-init:
	mkdir -p \
		$(STIRLING_DATA)/configs \
		$(STIRLING_DATA)/logs \
		$(STIRLING_DATA)/customFiles \
		$(STIRLING_DATA)/pipeline

	sudo chown -R 1000:1000 $(STIRLING_DATA)
	sudo chmod -R 750 $(STIRLING_DATA)

stirling-up: stirling-init
	docker compose -f $(STIRLING_DIR)/docker-compose.yml up -d

stirling-down:
	docker compose -f $(STIRLING_DIR)/docker-compose.yml stop

stirling-restart:
	docker compose -f $(STIRLING_DIR)/docker-compose.yml restart

stirling-logs:
	docker logs -f stirling-pdf

#
# NEXTCLOUD
#

nextcloud-init:
	@echo "# Ensuring base directories exist"
	@sudo mkdir -p $(NEXTCLOUD_DATA)/{data,config,themes,tmp}
	@sudo mkdir -p $(NEXTCLOUD_DB)

	@echo "# Fixing ownership only if needed"
	@sudo chown -R 33:33 $(NEXTCLOUD_DATA)
	@sudo chown -R 999:999 $(NEXTCLOUD_DB)

	@echo "# Fixing permissions only if needed"
	@sudo find $(NEXTCLOUD_DATA) ! -perm 750 -exec chmod 750 {} +
	@sudo find $(NEXTCLOUD_DB)   ! -perm 750 -exec chmod 750 {} +

nextcloud-up: nextcloud-init
	docker compose -f $(NEXTCLOUD_DIR)/docker-compose.yml up -d

nextcloud-stop:
	docker compose -f $(NEXTCLOUD_DIR)/docker-compose.yml stop

nextcloud-down:
	docker compose -f $(NEXTCLOUD_DIR)/docker-compose.yml down

nextcloud-restart:
	docker compose -f $(NEXTCLOUD_DIR)/docker-compose.yml restart

nextcloud-logs:
	docker compose -f $(NEXTCLOUD_DIR)/docker-compose.yml logs -f

#
# UTILS
#


status:
	docker ps

net-status:
	docker network ls

clean:
	@if [ -n "$$(docker ps -aq)" ]; then docker stop $$(docker ps -aq); fi
	docker system prune -f
