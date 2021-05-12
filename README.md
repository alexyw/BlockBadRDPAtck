# BlockBadRDPAtck
本脚本使用PowerShell拦截暴力RDP，即分析安全日志4625事件，超过三次错误即Ban，为避免其他业务受损，只禁止3389端口的Bad IP访问。
1. 首次使用，请开启PowerShell的脚本权限，即运行set-executionpolicy remotesigned
2. 在添加脚本到计划任务前，要先建立一条防火墙规则，可以手动添加，也可以使用命令：
New-NetFirewallRule -DisplayName "BlockRDPBruteForce" –RemoteAddress 1.0.0.1 -Direction Inbound -Protocol TCP –LocalPort 3389 -Action Block
3. 添加到计划任务中，建议使用按事件来触发
