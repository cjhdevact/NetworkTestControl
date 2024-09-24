# NetworkTestControl - 网络测试小工具

## 关于本项目

这是一个检测网络是否正常，不正常就弹出提示的软件。本软件可以安装在大屏上（例如教学大屏），也可以安装在普通电脑上。

## 功能

本程序支持的功能有：

- [x] 检测网络
- [x] 当网络不正常时显示警报
- [x] 当网络延时过高（默认>3000ms）时显示警报
- [x] 支持自定义设置检测信息
- [x] 警报窗口支持移动，防止遮挡内容

## 下载

转到[发布页](https://github.com/cjhdevact/NetworkTestControl/releases)下载程序或源代码。

## 自定义检测信息

本程序支持自定义配置网络检测

你可以通过设置以下注册表值来自定义配置

如果不存在该值或格式无效将使用默认设置。

1.检测网络是否超时的间隔时间（毫秒ms）（建议大于1000ms，否则连接失败提示看不清楚而且间隔越短越耗系统内存）：

项`HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings` 值`TestTimer` 类型`REG_DWORD` （默认值为`1000`）

2.检测网络超时的地址（请确保地址有效，否则检测结果可能不正确！）：

项`HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings` 值`TestHostName` 类型`REG_SZ` （默认值为`www.baidu.com`）

3.检测网络连接是否超时的超时时间（毫秒ms）（请确保超时时间不要设置太短，一般为3000以下都正常）：

项`HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings` 值`Timeout` 类型`REG_DWORD` （默认值为`3000`）

4.检测网络连接状态的间隔时间（毫秒ms）（建议大于1000ms，否则连接失败提示看不清楚而且间隔越短越耗系统内存）：

项`HKEY_CURRENT_USER\Software\CJH\NetworkTestControl\Settings` 值`NetworkTimer` 类型`REG_DWORD` （默认值为`1000`）

## License

本程序基于`GPL-3.0`协议授权。