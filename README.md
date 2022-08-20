# HOMER 7 Docker Containers

This repository provides ready-to-run [HOMER](https://github.com/sipcapture/homer/tree/homer) recipe using `Docker` and [docker-compose](https://docs.docker.com/compose/install/)

### Running Containers
- Adjust docker-compose.yml to use some external reverse proxy (on network "cnet")
- Adjust dist.env (optional)

For initial install run:

```bash
./install.sh
./set_keys.sh
```



