# Use Debian as base
FROM debian:bullseye

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y wget curl unzip gnupg software-properties-common \
                   wine wine32 xvfb python3 python3-pip git && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/mt5

# Download MetaTrader 5 installer
RUN wget -O mt5setup.exe "https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe"

# Install MT5 using Wine (headless)
RUN xvfb-run wine mt5setup.exe /silent

# Copy your MT5 Python automation script
COPY mt5_automation.py .

# Install MetaTrader5 Python API
RUN pip3 install MetaTrader5

# Launch MT5 and run your Python automation after small wait
CMD xvfb-run wine "C:\\Program Files\\MetaTrader 5\\terminal64.exe" & \
    sleep 15 && \
    python3 /opt/mt5/mt5_automation.py
