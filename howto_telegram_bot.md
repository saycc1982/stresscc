# 如何创建 Telegram Bot 并获取用户 ID

本文将指导您如何创建 Telegram Bot 并获取您的用户 ID，以便与 ED 网站压力测试系统配合使用。

## 第一步：创建 Telegram Bot

### 1. 打开 Telegram 并搜索 BotFather

1. 在 Telegram 中搜索 `@BotFather`
2. 点击开始对话或发送 `/start` 命令

### 2. 创建新的 Bot

1. 发送 `/newbot` 命令给 BotFather
2. 按照提示输入 Bot 的名称（例如：`My Stress Test Bot`）
3. 输入 Bot 的用户名，必须以 `bot` 结尾（例如：`my_stress_test_bot`）

### 3. 获取 Bot Token

创建成功后，BotFather 会发送一条包含 HTTP API Token 的消息，格式如下：
```
123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ
```

请保存好这个 Token，您将在配置文件中使用它。

## 第二步：获取您的 Telegram 用户 ID

### 方法一：使用 User Info Bot

1. 在 Telegram 中搜索 `@userinfobot`
2. 点击开始对话或发送 `/start` 命令
3. 机器人会回复您的用户信息，包括 ID，格式如下：
   ```
   Id: 987654321
   ```

### 方法二：使用 Telegram 网页版

1. 打开 [Telegram Web](https://web.telegram.org)
2. 找到与您要获取 ID 的用户（通常就是您自己）的聊天
3. 点击用户头像或名称进入用户信息页面
4. 在浏览器地址栏中查看 URL，用户 ID 通常在 URL 中，格式如下：
   ```
   https://web.telegram.org/k/#987654321
   ```
   其中 `987654321` 就是用户 ID

### 方法三：通过机器人交互获取

1. 启动您创建的 Bot（在 Telegram 中搜索您创建的 Bot 用户名）
2. 发送 `/start` 命令给您的 Bot
3. 在服务器端查看日志，通常会显示发送消息的用户 ID

## 第三步：创建配置文件

创建一个名为 `telegram.conf` 的文本文件，内容格式如下：

```
YOUR_BOT_TOKEN
YOUR_USER_ID
```

将 `YOUR_BOT_TOKEN` 替换为您从 BotFather 获取的 Token，将 `YOUR_USER_ID` 替换为您获取的用户 ID。

例如：
```
123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ
987654321
```

## 第四步：启动 Telegram Bot 模式

使用以下命令启动 ED 网站压力测试系统的 Telegram Bot 模式：

```bash
./stresscc -telegram-config ./telegram.conf
```

## 验证设置

1. 打开 Telegram
2. 找到您创建的 Bot
3. 发送 `/start` 命令
4. 如果一切设置正确，您应该会收到 Bot 的欢迎消息

## 故障排除

### 常见问题

1. **Bot 没有响应**
   - 检查 Bot Token 是否正确
   - 确认配置文件格式是否正确（两行，第一行是 Token，第二行是 User ID）
   - 检查服务器是否能访问 Telegram 服务器（可能需要配置代理）

2. **权限问题**
   - 确认 User ID 是否正确
   - 只有配置文件中指定的用户 ID 才能控制 Bot

3. **网络连接问题**
   - 确保服务器可以访问 `api.telegram.org`
   - 如果在受限网络环境中，可能需要配置代理

### 日志检查

如果遇到问题，可以查看程序输出的日志信息，通常会包含错误详情，帮助您诊断问题。

## 安全建议

1. **保护 Bot Token**
   - 不要在公开场合分享您的 Bot Token
   - 如果怀疑 Token 泄露，请使用 BotFather 重新生成

2. **限制访问**
   - ED 网站压力测试系统已经限制只有配置文件中指定的用户可以控制 Bot
   - 不要将 User ID 设置为不信任的用户

3. **定期检查**
   - 定期检查 Bot 的使用情况
   - 如果发现异常使用，请立即重新生成 Token

## 更多信息

- [Telegram Bot 官方文档](https://core.telegram.org/bots)
- [BotFather 帮助命令](https://core.telegram.org/bots#botfather)
