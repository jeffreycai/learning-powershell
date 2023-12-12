# Dockerized Local Project Template

This is a boilerplate repository to help you start a local project that runs in a Dockerized environment. The repository includes the following key features:

- Use Docker Compose to run the app, with the runtime container image defined in `docker/Dockerfile`.
- SSH key integration, which is mounted in the Docker image (encrypted/decrypted with `ansible-vault`).
- Docker in Docker functionality achieved by mounting the host's Docker socket in the container.
- Repository root mounted to the `/opt` path in the container.

## How to Run

Follow the steps below to build and run the Dockerized local project:

1. Build the runtime container image:
```
make build
```

If you want to clean, build, and push the image, use the following command:
```
make rebuild
```

2. Push the container image to the registry (if applicable):
```
make push
```

3. Pull the container image (if needed) before running it:
```
make pull
```

4. To clean up the container image (local and remote if pushed), use:
```
make clean
```

5. To run the project locally, use one of the following commands:
- Run the command as the local user:
```
make debug
```
- Run the command as root:
```
make debug_root
```

Please make sure to have Docker and Docker Compose installed on your local machine before running the above commands. Additionally, ensure that you have configured the necessary SSH keys and encrypted files with `ansible-vault` for proper integration within the Docker container.