#!/bin/bash  
  
# 启动 Xvfb  
Xvfb :1 -screen 0 1024x768x16 &  
XVFB_PID=$!  
  
# 等待 Xvfb 启动  
while ! pgrep -x Xvfb > /dev/null; do  
    sleep 1  
done  
  
# 启动 VNC 服务器  
vncserver :1 -geometry 1024x768 -depth 16 -passwordfile /root/.vnc/passwd &  
VNC_PID=$!  
  
# 等待 VNC 服务器启动（这里只是简单的等待，更好的方法是检查端口）  
sleep 5  
echo "完成启动VNC"
# 启动 Fluxbox（这里假设它已经配置好了）  
fluxbox &  
FLUXBOX_PID=$!  
echo "完成启动Fluxbox"  
# 启动 NoVNC WebSocket 代理  
/opt/novnc/utils/websockify --web /opt/novnc --no-tls 6080 localhost:5901 &  
WEBSOCKIFY_PID=$!  
  
# 注意：通常不建议在脚本中直接设置输入法，这应该在用户会话中处理  
# 假设这是在一个有图形界面的环境中，并且用户已经登录  
# im-config -n fcitx5  
# fcitx5 &  
  
# 启动 tinyMediaManager（确保它可以在没有图形界面的环境中运行，或者在一个适当的容器中）  
/opt/tinyMediaManager/tinyMediaManager &  
TINYMM_PID=$!  
echo "完成启动tmm"  
# 等待所有后台进程结束（这里只是示例，通常你不会这样做，除非你确实需要）  
# wait $XVFB_PID $VNC_PID $FLUXBOX_PID $WEBSOCKIFY_PID $TINYMM_PID
