## pod项目初始化。
pod install 
pod install --repo-update

## 运行项目配置
iOS 12.0 或更高版本
Xcode 15 或更高版本
Swift 5.0 或更高版本

ssh-keygen -t ed25519 -C "liuweile@algorix.co" -f ~/.ssh/github_deploy_key


Host github.com-repo-0
        Hostname github.com
        IdentityFile=~/.ssh/repo-0_deploy_key