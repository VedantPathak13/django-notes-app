#!/bin/bash

# deploying the django webapp and handling the errors

code_clone() {

echo "Cloning the code from github repo"

yum install git -y

if [[ -d "django-notes-app" ]]; then
	echo "The code directory already exists, skipping the cloning process."
else
	git clone https://github.com/VedantPathak13/django-notes-app.git || {
	echo "Failed to clone the code"
	return 1
	}
fi
}


# Function to install required dependencies

requirements() {
	echo "Installing the required dependencies"
	sudo yum install -y docker nginx || {
        	echo "Failed to install dependencies"
        	return 1
	}
echo "Dependencies Installed successfully"
}

# Function to perform required restart

required_restart() {
	echo "Performing required restart"
	sudo chown "$USER" /var/run/docker.sock || {
		echo "Failed to change the ownership of docker.soket and restart"
	return 1
	# systemctl enable docker
	# systemctl enable nginx
	# systemctl restart docker
	} 
}

# Function to deploy django app

deploy() {
	echo "Building and deploying Django application..."
	docker build -t notes-app . && docker-compose up -d || {
	echo "Failed to build and deploy the app"
	return 1
	}
echo "application deployed successfully"
}

# Main deployment script

echo "********** DEPLOYMENT STARTED **********"

# Clone the code

if ! code_clone; then
	cd django-notes-app || exit 1
fi

# Install Dependencies

if ! requirements; then
	exit 1
fi

# Perform required restart

if ! required_restart; then
	exit 1
fi

# Deployment of the app

if ! deploy; then
	echo "Deployment failed"
	exit 1
fi

echo "********** Deployment done **********"




