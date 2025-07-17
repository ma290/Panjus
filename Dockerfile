# Use 32-bit Debian base for Wine compatibility
FROM i386/debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Add 32-bit arch and update
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y wget curl gnupg2 software-properties-common && \
    apt install -y wine32 wine64 python3 python3-pip xvfb unzip cabextract

# Create Wine environment and init
RUN mkdir -p /root/.wine && xvfb-run wineboot --init

# Download MT5 installer
WORKDIR /root
RUN wget -O mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe

# Install MT5 silently
RUN xvfb-run wine mt5setup.exe /silent

# Install Python deps
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy your automation script
COPY your_mt5_script.py /root/your_mt5_script.py

# Run Python script
CMD ["xvfb-run", "python3", "/root/your_mt5_script.py"]
