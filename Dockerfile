FROM jenkins/jenkins:lts-jdk21

USER root

# Install prerequisites
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    gnupg2 \
    ca-certificates

# Add Docker GPG key and repository
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Update apt and install Docker CLI only
RUN apt-get update && apt-get install -y docker-ce-cli

# ARG to pass host Docker GID
ARG DOCKER_GID=999

# Add jenkins user to host Docker group
RUN groupadd -g ${DOCKER_GID} dockerhost || true \
    && usermod -aG dockerhost jenkins

# Clean up apt cache
RUN rm -rf /var/lib/apt/lists/*

USER jenkins

