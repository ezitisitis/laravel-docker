# Laravel Docker

This container contains Docker files and docker-compose files for Laravel.

## Docker-compose prerequisites

1. Traefik container (You can use: 
   [ezitisitis/docker-compose-traefik-v2](traefik_docker_compose_repository))
2. Database container (You can use: 
   [ezitisitis/docker-compose-mysql5.7](mysql_docker_compose_repository))
   
[traefik_docker_compose_repository]: https://github.com/ezitisitis/docker-compose-traefik-v2
[mysql_docker_compose_repository]: https://github.com/ezitisitis/docker-compose-mysql5.7

## Docker-compose usage

1. Copy docker-compose file which is located in `~/docker-compose` directory to 
Your project root directory.
2. Replace `placeholder` in docker-compose file with your actual project name.
3. Execute `docker-compose up -d`