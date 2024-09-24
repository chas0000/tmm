# 使用Ubuntu基础镜像  
FROM debian:latest  
# 安装必要的软件包  
RUN apt-get update && apt-get install -y locales \  
&& locale-gen zh_CN.UTF-8 

ENV LANG=zh_CN.UTF-8  
ENV LANGUAGE=zh_CN:zh  

RUN apt-get update && apt-get install -y \
    xz-utils \
    xserver-xorg-video-dummy \  
    xinit \  
    xvfb \  
    tigervnc-standalone-server \  
    fluxbox \  
    wget \  
    unzip \
    fcitx5 \
    fcitx5-rime \
    mediainfo
    
RUN wget https://release.tinymediamanager.org/v5/dist/tinyMediaManager-5.0.11-linux-amd64.tar.xz -O /tmp/tmm.tar.xz 

RUN ls /tmp/tmm.tar.xz

RUN xz -d /tmp/tmm.tar.xz \  
    && tar -xf /tmp/tmm.tar -C /opt
   
# 安装noVNC  
RUN mkdir -p /opt/novnc

RUN wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip -O /tmp/novnc.zip 
RUN ls /tmp/novnc.zip
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
  

EXPOSE 6080  
  
# 设置容器启动时执行的命令  
ENTRYPOINT ["bash"]
CMD ["-c", "exec bash"]
