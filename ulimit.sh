#!/bin/bash
# 配置 Ubuntu 24.04 的 nofile 限制（最大打开文件数）

# 检查是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "错误：请使用 sudo 或 root 权限运行此脚本"
    exit 1
fi

# 定义要设置的限制值
LIMIT=1024000

# 1. 配置 /etc/security/limits.conf
echo "正在配置 /etc/security/limits.conf..."
cat << EOF | tee -a /etc/security/limits.conf > /dev/null
# 增加最大打开文件数限制（由脚本添加）
* soft nofile $LIMIT
* hard nofile $LIMIT
root soft nofile $LIMIT
root hard nofile $LIMIT
EOF

# 2. 确保 PAM 模块启用
echo "正在配置 PAM 模块..."
for file in /etc/pam.d/common-session /etc/pam.d/common-session-noninteractive; do
    if ! grep -q "pam_limits.so" "$file"; then
        echo "session required pam_limits.so" | tee -a "$file" > /dev/null
        echo "已在 $file 中添加 pam_limits.so"
    else
        echo "$file 中已存在 pam_limits.so，无需修改"
    fi
done

# 3. 配置 Systemd 限制
echo "正在配置 Systemd 限制..."
for file in /etc/systemd/system.conf /etc/systemd/user.conf; do
    # 先尝试替换已存在的配置
    if sed -i "s/^#*DefaultLimitNOFILE=.*/DefaultLimitNOFILE=$LIMIT/" "$file"; then
        echo "已更新 $file 中的 DefaultLimitNOFILE"
    else
        # 如果没有找到则追加配置
        echo "DefaultLimitNOFILE=$LIMIT" | tee -a "$file" > /dev/null
        echo "已在 $file 中添加 DefaultLimitNOFILE"
    fi
done

# 4. 重新加载 systemd 配置
echo "重新加载 systemd 配置..."
systemctl daemon-reload

# 5. 提示用户
echo "----------------------------------------"
echo "nofile 限制配置已完成！"
echo "请执行以下操作使配置生效："
echo "1. 完全注销当前用户并重新登录"
echo "2. 对于服务，需重启相应服务"
echo "3. 验证命令：ulimit -n 和 ulimit -Hn"
echo "----------------------------------------"
