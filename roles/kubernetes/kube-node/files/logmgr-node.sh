#!/bin/sh

#----------------------------------------------------------------
#日志管理脚本
#主要用于清理由 k8s 组件产生的历史日志文件,k8s组件产生的日志只能会进行切分,但永远不会清理.
#请复制到/etc/cron.daily目录下,赋予执行权限,由系统服务cron每天执行一次
#----------------------------------------------------------------

#删除10天前kubelet日志
find /data/log/kubelet -mtime +10 -type f -name "kubelet.*.log*"| xargs rm -rf
#删除10天前kube-proxy日志
find /data/log/kube-proxy -mtime +10 -type f -name "kube-proxy.*.log*"| xargs rm -rf

exit 0