# 课堂实操 Redis 服务器

## 实验环境

在 Windows 与 Ubuntu 24.04.1 LTS（WSL 2）中用 Docker 运行 Redis 7.4.12。宿主机地址为 `127.0.0.1:16379`，服务器启用了密码认证和 AOF 持久化。Redis Insight 位于同一实验容器网络，可从宿主机 `http://127.0.0.1:15540` 访问。

## 实验过程

1. 启动 Redis 并检查端口映射。未认证时执行 `PING` 验证服务拒绝处理命令。
2. 认证后运行下列命令。用 `TYPE` 查看键类型，用 `DBSIZE` 核对测试数据库中的键数。

   ```text
   PING
   SET class:service redis-ready
   GET class:service
   TYPE class:service
   DBSIZE
   ```

## 实测结果

未认证的 `PING` 返回 `NOAUTH Authentication required.`。认证后 `PING` 返回 `PONG`，`SET` 返回 `OK`，读回 `redis-ready`。键类型为 `string`，库内共有 1 个键。完整输出见[实测记录](./实测记录.txt)。

Redis Insight 服务已启动并打开首次使用页面，图形界面连接测试待确认客户端条款后继续。
