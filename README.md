# Jalecitos

This Readme shows how to run Jalecitos locally, utilizing docker and docker compose


# Prerequisites

- Linux / MacOS
- Docker
- Docker Compose

## Start

1. Download Code by doing `git clone git@gitlab.com:jalecitos/jalecitos-rails.git`
2. Move to the directory `cd jalecitos-rails`
3. Grant permissons to user `usermod -a -G docker $USER` (reboot if necessary)
3. Export PATH for jalecitos CLI `bash jalecitos-cli path`
4. Start project `jalecitos-cli start`

## Stop

1. `jalecitos-cli stop`
