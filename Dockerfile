FROM debian:bullseye-slim

# 1. Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win32
ENV WINEPREFIX=/wine32

# 2. Install required packages
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    software-properties-common \
    wget curl gnupg2 sudo git \
    xvfb x11vnc xauth \
    x11-utils \
    python3 python3-pip \
    wine32 wine winbind cabextract unzip

# 3. Download and install MetaTrader 5
RUN mkdir -p /opt/mt5 && \
    wget -O /opt/mt5/mt5setup.exe "https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe" && \
    wine /opt/mt5/mt5setup.exe /silent

# 4. Install Python MT5 module
RUN pip3 install MetaTrader5

# 5. Add sample automation script
COPY mt5_automation.py /opt/mt5/

# 6. Startup command (Xvfb is needed for GUI apps in Docker)
CMD xvfb-run wine "C:\\Program Files\\MetaTrader 5\\terminal64.exe"
