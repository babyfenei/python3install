pythonpath=`which python` 
currentpython=`ls -l $pythonpath` 

echo $currentpython 
if [[ $currentpython =~ "python2" ]]
then
	echo "当前版本：Python2，开始安装Python3。"
else
	echo "当前版本不是Python2，退出安装。"
	exit
fi

echo "安装依赖包" &&
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make &&

echo "解压Python3" &&
tar -xvJf Python-3.6.6.tar.xz &&
echo "编译安装" &&
cd Python-3.6.6 &&
./configure prefix=/usr/local/python3 &&
make && make install &&
echo "备份Python2软链接" &&
mv -f $pythonpath ${pythonpath}.bak &&
echo "添加Python3软链接" &&
ln -s /usr/local/python3/bin/python3 $pythonpath &&
echo "添加pip软链接" &&
if [ -f /usr/bin/pip ];then
echo "pip文件存在"
rm -f /usr/bin/pip
else
echo "pip文件不存在"
fi
ln -s /usr/local/python3/bin/pip3  /usr/bin/pip &&
echo "修改yum配置" &&
sed -i '1c #!/usr/bin/python2' /usr/bin/yum &&
sed -i '1c #!/usr/bin/python2' /usr/libexec/urlgrabber-ext-down &&
echo "安装完成！"