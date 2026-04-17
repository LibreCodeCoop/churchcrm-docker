# ChurchCRM Docker environment

A Docker environment to run ChurcCRM.

## Setup

Clone this repository and run:

```bash
docker compose up -d
```

## Configuring

At the docker-compose.yml have all available environment and you can copy what you want to customize and paste into a `.env` file.

You also can override the docker-compose.yml creating a [`docker-compose.override.yml`](https://docs.docker.com/compose/how-tos/multiple-compose-files/merge/) file [extending](https://docs.docker.com/compose/how-tos/multiple-compose-files/extends/) the original `docker-cmpose.yml` file


## Extra informations

| Official ChurchCRM data | Location                              |
| ----------------------- | ------------------------------------- |
| repository              | https://github.com/ChurchCRM/CRM      |
| Website                 | https://churchcrm.io/                 |
| Documentation           | https://github.com/ChurchCRM/CRM/wiki |

> This repository haven't any connection with ChurchCRM, is made to attend a necessity of herself.
