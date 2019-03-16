# xdebug 設定
複製 xdebug.ini.example 重新命名為 xdebug.ini

# Mac PhpStorm
### Mac 網卡 loopback 增加 IP
```
sudo ifconfig lo0 alias 10.254.254.254 255.255.255.0
```

### PhpStorm Server 設定
- server 設定是 by project, 所以每個 project 分別都會做一次 
 
第一次開網頁會自動跳出 phpstorm 設定  
填上 Local Folder 對應 PHP server 的 DocumentRoot 給 xdebug

例如：  
Local 的 `/git/finaltokyo` 對應到 Docker 的 `/var/www/html/finaltokyo`

第一次沒設定到可以到  
`Preferences | Languages & Frameworks | PHP | Servers`  
找到 local 用的 domain