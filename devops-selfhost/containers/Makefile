SHELL := /bin/bash

LLAMA_DIR := $(HOME)/containers/llama.cpp
STIRLING_DIR := $(HOME)/containers/stirling-pdf
NEXTCLOUD_DIR := $(HOME)/containers/nextcloud

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

stirling-up:
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

nextcloud-up:
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

clean:
	docker system prune
