# git status //查看仓库状态


4、提交
　　git add mmm.sss //mmm为文件名称，sss为文件拓展名（常用git add .）
　　git commit -m "hhh" //hhh为git commit 提交信息，是对这个提交的概述
　　git log//用于查看提交日志
　　git push //更新GitHub上的仓库


6、分支操作
　　git branch //显示分支一览表，同时确认当前所在的分支
　　git checkout -b aaa //创建名为aaa的分支，并且切换到aaa分支
　　（git branch aaa //创建名为aaa的分支
　　git checkout aaa // 切换到aaa分支
　　）能和git branch -b aaa 得到同样的效果
　　git checkout - //切换到上一分支

7、合并分支
　　git checkout master //切换到master分支
　　git merge --no--ff aaa // 加--no--ff 参数可以在历史记录中明确地记录本次分支的合并
　　git log --graph //以图表形式查看分支

　　8、更改提交的操作
　　git reset //回溯历史版本
　　git reset --hrad //回溯到指定状态，只要提供目标时间点的哈希值


      9.推送到远程仓库 git push -f

    10。git cherry-pick


thirteen

fff


```
Usage:
  transitStation [command]

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  help        Help about any command
  start       Start the relay server

Flags:
      --config string       config file (default is $HOME/.transitStationConfig.yaml)
      -h, --help            help for transitStation

Use "transitStation [command] --help" for more information about a command.

```

