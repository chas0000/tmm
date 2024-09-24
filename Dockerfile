# 使用Ubuntu基础镜像  
FROM debian:latest  

ENV LANG zh_CN.UTF-8  
ENV LANGUAGE zh_CN:zh  
ENV LC_ALL zh_CN.UTF-8


# 安装必要的软件包  
RUN apt-get update && apt-get install -y locales \  
&& locale-gen zh_CN.UTF-8 && update-locale LANG=zh_CN.UTF-8
RUN apt-get update && apt-get install -y \  
    xserver-xorg-video-dummy \  
    xinit \  
    xvfb \  
    tigervnc-standalone-server \  
    fluxbox \  
    nodejs npm \  
    wget \  
    unzip \
    fcitx5 \
    fcitx5-rime \
    mediainfo
RUN wget https://release.tinymediamanager.org/v5/dist/tinyMediaManager-5.0.11-linux-amd64.tar.xz -O /tmp/tmm.tar.xz \
    && tar -xf /tmp/tmm.tar.xz -C /opt
# 安装noVNC  
RUN mkdir -p /opt/novnc \  
    && wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip -O /tmp/novnc.zip   
RUN unzip /tmp/novnc.zip -d /opt

RUN mv /opt/noVNC-master/* /opt/novnc   

RUN rm -rf /opt/novnc/noVNC-master 

RUN rm /tmp/novnc.zip  
    
# 设置VNC密码  
RUN mkdir -p /root/.vnc && \  
    echo "123456" | vncpasswd -f > /root/.vnc/passwd && \  
    chmod 600 /root/.vnc/passwd 
COPY xstartup /root/.vnc/  

RUN chmod +x /root/.vnc/xstartup 

ENV DISPLAY=:1

# 编写启动脚本  
COPY start.sh /usr/local/bin/start.sh  
RUN chmod +x /usr/local/bin/start.sh  
  
# 启动脚本示例（start.sh）  
# 注意：这个脚本需要根据你的具体需求进行调整  
# #!/bin/bash  
# Xvfb :1 -screen 0 1024x768x16 &  
# vncserver :1 -geometry 1024x768 -depth 16 -passwordfile /root/.vnc/passwd &  
# fluxbox & 
# /opt/novnc/utils/websockify --web /opt/novnc --no-tls 6080 localhost:5901  
  
# 而且，上面的vncserver命令可能需要根据你的TigerVNC安装进行调整  
  
# 暴露端口（noVNC的WebSocket端口，这里假设是6080）  
EXPOSE 6080  
  
# 设置容器启动时执行的命令  
CMD ["/usr/local/bin/start.sh"]
