# Terraform Remote Backend Bootstrap

此目录包含了设置Terraform远程状态存储所需的配置文件。它会创建：

1. 一个专用的资源组（默认：`rg-tfstate`）
2. 一个Azure存储账户（默认：`tfstatemusicactivity`）
3. 一个Blob容器（默认：`tfstate`）

## 注意事项

- **存储账户名称固定**：为了确保每次运行不会创建新的存储账户，我们使用了固定的存储账户名称。
- **全局唯一性**：Azure存储账户名称必须全局唯一，如果默认名称已被使用，请在`variables.tf`中修改`storage_account_name`的默认值。

## 使用方法

从项目根目录运行以下命令：

```bash
# 运行初始化脚本
./scripts/bootstrap.sh
```

脚本会：
1. 创建所需的Azure资源
2. 获取输出值
3. 自动更新`environments/dev`和`environments/test`目录中的`backend.tf`文件

## 手动配置

如果您需要手动配置，可以：

```bash
cd bootstrap
terraform init
terraform apply
```

然后使用输出值手动更新环境配置文件：

```
terraform output
``` 