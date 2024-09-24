# 使用Ubuntu基础镜像  
FROM tinymediamanager/tinymediamanager
# 安装必要的软件包  

RUN apt-get update && apt-get install -y \
    fcitx5 \
    fcitx5-rime 
    
COPY ./startup.sh /usr/local/bin/ 
RUN chmod +x /usr/local/bin/startup.sh
# 设置容器启动时执行的命令  
ENTRYPOINT ["/usr/local/bin/startup.sh"]
CMD ["/app/tinyMediaManager -Dtmm.contentfolder=/data"]
