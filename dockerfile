# Base image: Ubuntu
FROM ubuntu:20.04

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Set VNC password as an environment variable
ENV VNC_PASSWORD=password  

# Update and install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    sudo \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    dbus-x11 \
    net-tools \
    iputils-ping \
    python3 \
    python3-pip \
    novnc \
    websockify \
    xauth \
    xfce4-power-manager \
    xscreensaver \
    firefox \
    && apt-get clean

# Install .NET SDK (for C# development)
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-6.0 \
    && apt-get clean

# Install Visual Studio Code (C# editor)
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/ \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
    && apt-get update \
    && apt-get install -y code \
    && apt-get clean

# Create a non-root user for running VSCode
RUN useradd -ms /bin/bash devuser \
    && echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to non-root user
USER devuser

# Install VSCode extensions: C# Extension and Code Snippets for C#
RUN code --no-sandbox --user-data-dir=/home/devuser/.vscode-data --install-extension ms-dotnettools.csharp \
    && code --no-sandbox --user-data-dir=/home/devuser/.vscode-data --install-extension ms-dotnettools.csdevkit \
    && code --no-sandbox --user-data-dir=/home/devuser/.vscode-data --install-extension jorgeserrano.vscode-csharp-snippets

# Switch back to root user to finalize further setup if needed
USER root

# Copy test scripts to the container
COPY tests/ /home/devuser/tests/

# Change ownership of the test files to devuser
RUN chown -R devuser:devuser /home/devuser/tests/

# Set up VNC password programmatically
RUN mkdir -p /home/devuser/.vnc \
    && echo $VNC_PASSWORD | vncpasswd -f > /home/devuser/.vnc/passwd \
    && chmod 600 /home/devuser/.vnc/passwd \
    && chown -R devuser:devuser /home/devuser/.vnc

# Create a simple xstartup file for VNC that starts XFCE4 or xterm
RUN echo -e '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' > /home/devuser/.vnc/xstartup \
    && chmod +x /home/devuser/.vnc/xstartup \
    && chown -R devuser:devuser /home/devuser/.vnc

# Disable screensaver and power management (to prevent sleep/blanking)
RUN echo -e '#!/bin/bash\nxscreensaver-command -exit\nxfce4-power-manager --quit\nxset s off\nxset -dpms\nxset s noblank\nstartxfce4 &' > /home/devuser/.vnc/xstartup \
    && chmod +x /home/devuser/.vnc/xstartup

# Create alias for running VSCode with --no-sandbox
RUN echo 'alias code="code --no-sandbox"' >> /home/devuser/.bashrc

# Set the working directory to the user's home directory
WORKDIR /home/devuser/tests/

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Start VNC server and noVNC
CMD su - devuser -c "vncserver :1 -geometry 1280x800 -depth 24" && /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080 && tail -f /dev/null
