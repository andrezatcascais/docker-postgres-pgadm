#!/bin/bash

# Function to check if Docker Compose is installed
check_docker_compose() {
    if ! [ -x "$(command -v docker-compose)" ]; then
        echo "Docker Compose is not installed. Installing it now..."
        sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo "Docker Compose installed successfully."
    else
        echo "Docker Compose is already installed."
    fi
}

# Name of the Network
NETWORK_NAME="local-network"
# Create Docker network if not exists
create_network() {
    
    if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
        echo "Creating Docker network '$NETWORK_NAME'..."
        docker network create "$NETWORK_NAME"
        echo "Docker network '$NETWORK_NAME' created."
    else
        echo "Docker network '$NETWORK_NAME' already exists."
    fi
}

# Copy docker-compose file from a template
copy_docker_compose() {
   if [ -d "postgres-env-dev" ]; then
        echo "The directory 'postgres-env-dev' already exists. Renaming it to 'postgres-env-dev_old'..."
        mv postgres-env-dev postgres-env-dev_old
        echo "'postgres-env-dev' has been renamed to 'postgres-env-dev_old'."
    fi

    if [ -f docker-compose-example.yml ]; then
        mkdir -p postgres-env-dev
        cp docker-compose-example.yml postgres-env-dev/docker-compose.yml
        echo "docker-compose.yml has been copied to 'postgres-env-dev' folder."
        update_network_name
    else
        echo "docker-compose-example.yml file not found!"
        exit 1
    fi
}

# Update the network name in the docker-compose.yml file
update_network_name() {
    cd postgres-env-dev
    local network_name="$NETWORK_NAME"
    sed -i "s/name: local-network/name: $network_name/g" docker-compose.yml
    echo "Updated the network name in 'docker-compose.yml' to '$network_name'."
}

# Final message
final_message() {
    echo ""
    echo "Done! We've reached the end, and now you have an environment with PostgreSQL and pgAdmin web."
    # echo "Please manually change to the 'postgres-env-dev' directory by running:"
    # echo "cd postgres-env-dev"
    echo ""
    echo "Whenever you need to work with these tools, just open the terminal in the folder where you added the docker-compose.yml file and run the following command:"
    echo "docker-compose -f docker-compose.yml up"
    echo ""
    echo ">> To view the containers, open a new terminal tab and type: docker ps"
}

# Execute the functions
check_docker_compose
create_network
copy_docker_compose
final_message
