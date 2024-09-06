# PostgreSQL and pgAdmin with Docker Compose

#### Docker Compose script to create a local environment for development with PostgreSQL and pgAdmin

### To run this script is necessary:
- docker-compose-example.yml
- setup-docker-even.sh

### Instructions:

1. Save the shell script `setup_docker_env.sh` and make it executable by running:
   ```bash
   chmod +x setup_docker_env.sh   
   ```
   >  ⚠ If you want to change the Docker network name, you should edit the setup_docker_env.sh file and update the global variable NETWORK_NAME.


2. Run script (By using source setup_docker_env.sh, it runs in the same shell session as your terminal, meaning cd will change the directory in the terminal session itself.)
   ```bash
   source setup_docker_env.sh
   ```

3. if case you need to run the shell script by ./setup_docker_env.sh, so,
"please manually change to the 'postgres-env-dev' directory by running":
   ```bash
   cd postgres-env-dev
   ```
4. Whenever you need to work with these tools, just open the terminal in the folder where you added the docker-compose.yml file and run the following command:
   ```bash
   docker-compose -f docker-compose.yml up
   ```  
5. To view the containers, open a new terminal tab and type:
   ```bash
   docker ps
   ```
6. Verify that the directory being mounted in the container has the correct permissions. In your docker-compose.yml, you're mounting the host directory ./data/pgadmin to /var/lib/pgadmin in the container. Ensure that the user running Docker has read and write permissions for this directory.
   ```bash
   cd postgres-env-dev
   sudo chmod -R 777 ./data/pgadmin/
   ```
   
