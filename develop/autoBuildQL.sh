#!/bin/bash
# autoBuildQL.sh
# 潜龙项目IOS自动打包脚本
# Author:YunLai Test Team
# Date:2014-06-17

#全局变量
BasePath="`pwd`"  #打包项目根代码存放目录
targetStr="ql" #s打包目标
iosSDK="iphoneos7.1"   #打包平台
DEPLOYMENTTARGET="5.1.1"  #打包支持版本
configurationType="Release"    #打包类型
ARCHSType="armv7 armv7s"     #打包支持内核

LogBuildName=$BasePath/build.log  #编译内容日志临时保存位置
BuildSaveFloder="build-ipa"
installConf="conf"	#配置文件存放目录
NowData=`date +%Y%m%d`    #获取当天的日期用来存放文件
NowDataTime=`date +%m%d%H%M`    #获取当天的日期及时间
rsyncServer="192.168.3.99"	#同步服务器
rsyncFloder="qianlong/ios"	#同步目录
rsyncSourceFloder="${BasePath}/${BuildSaveFloder}"	#同步源目录路径

plistName="ql-Info.plist"	#plist文件
pulish_url="http://192.168.3.99/qianlong"

#当传入的第一个参数不为0的时候,退出程序
function errorExit(){
    if [ $1 -ne 0 ];then
        echo $2
        exit 1
    fi       
}

#生成rsync认证文件 
echo "123456"> ./rsync.passwd
chown root ./rsync.passwd
chmod 600 ./rsync.passwd
    
cd $BasePath
errorExit $? "!!!错误!!!找不到目录:"$BasePath
echo "进入文件夹:"`pwd`
rm -rf build ${BuildSaveFloder}

#删除最近10天的数据
find ${HOME}/${BuildSaveFloder}/* -maxdepth 1 -ctime +10 -exec rm -rf {} \;

case "$1" in
	"Dev" )
	Env=1
	EnvD="Dev"
	dsymZipName="${NowDataTime}D.dsym.zip"    #编译临时中转文件打包名
	ipaName="qianlong${NowDataTime}-reDev.ipa"	#生成的程序ipa名称
	appName="qianlongAppD.app"	#生成的程序app名称
	CFBundleDisplayName="潜龙D$NowDataTime"
	CFBundleName="潜龙D$NowDataTime"
	CFBundleIdentifier="cn.yunlai.qianlong299"
	codeSign="iPhone Distribution: Shenzhen YunLai Network Technology Co., Ltd."  #打包使用证书
	PROVISIONING_PROFILE="6CCB94A2-107E-409D-8D6E-2B66E182407B"     #打包证书重复时，用ID来区分
	;;
	"Test" )
	Env=2
	EnvD="Test"
	dsymZipName="${NowDataTime}T.dsym.zip"    #编译临时中转文件打包名
	ipaName="qianlong${NowDataTime}-reTest.ipa"	#生成的程序ipa名称
	appName="qianlongAppT.app"	#生成的程序app名称
	CFBundleDisplayName="潜龙T$NowDataTime"
	CFBundleName="潜龙T$NowDataTime"
	CFBundleIdentifier="cn.yunlai.qianlong299"
	codeSign="iPhone Distribution: Shenzhen YunLai Network Technology Co., Ltd."  #打包使用证书
	PROVISIONING_PROFILE="6CCB94A2-107E-409D-8D6E-2B66E182407B"     #打包证书重复时，用ID来区分
	;;
	"Pro" )
	Env=3
	EnvD="Pro"
	dsymZipName="${NowDataTime}P.dsym.zip"    #编译临时中转文件打包名
	ipaName="qianlong-product.ipa"	#生成的程序ipa名称
	appName="qianlongApp.app"	#生成的程序app名称
	CFBundleDisplayName="潜龙"
	CFBundleName="潜龙"
	CFBundleIdentifier="cn.yunlai.qianlong299"
	codeSign="iPhone Distribution: Shenzhen YunLai Network Technology Co., Ltd."  #打包使用证书
	PROVISIONING_PROFILE="6CCB94A2-107E-409D-8D6E-2B66E182407B"     #打包证书重复时，用ID来区分
	;;
	* )
	echo "!!!错误!!!未传入环境参数:[Dev | Test | Pro]"
	exit 1
	;;
esac

ITEMLINENUMBER="0"

checkItem="修改App系统环境配置"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
echo $BasePath/${targetStr}/config
cd $BasePath/${targetStr}/config
cp -f $BasePath/${targetStr}/config/config.h $BasePath/config.h.bak #备份配置文件
sed "s/#define EnvironmentJudger [0-9]/#define EnvironmentJudger ${Env}/g" config.h>config.h.tmp
cat config.h.tmp>config.h
rm config.h.tmp

echo "============环境内容打印76到150行开始============"
sed -n "76,150p" config.h
echo "============环境内容打印76到150行结束============"

echo -e "\n\n=========================E结束:${checkItem}========================="

checkItem="修改App命名规则"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
cd $BasePath/${targetStr}
cp -f $BasePath/${targetStr}/${plistName} $BasePath/${plistName}.bak #备份plist文件
echo $BasePath/${targetStr}
/usr/libexec/PlistBuddy -c "set :CFBundleDisplayName ${CFBundleDisplayName}" ${plistName}
/usr/libexec/PlistBuddy -c "set :CFBundleName ${CFBundleName}" ${plistName}
/usr/libexec/PlistBuddy -c "set :CFBundleIdentifier ${CFBundleIdentifier}" ${plistName}

echo "============打印环境内容开始============"
cat ${plistName}
echo "============打印环境内容结束============"
echo -e "\n\n=========================E结束:${checkItem}========================="

cd $BasePath
checkItem="清除编译文件"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
xcodebuild clean -configuration $configurationType -sdk $iosSDK -target $targetStr IPHONEOS_DEPLOYMENT_TARGET=$DEPLOYMENTTARGET GCC_VERSION="com.apple.compilers.llvm.clang.1_0" ARCHS="$ARCHSType" 1>/dev/null
errorExit $? "!!!错误!!!${checkItem}"
echo -e "\n\n=========================E结束:${checkItem}========================="

checkItem="编译发布包文件"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
xcodebuild clean build -configuration $configurationType -sdk $iosSDK -target $targetStr IPHONEOS_DEPLOYMENT_TARGET=$DEPLOYMENTTARGET GCC_VERSION="com.apple.compilers.llvm.clang.1_0" ARCHS="$ARCHSType"  CODE_SIGN_IDENTITY="$codeSign" PROVISIONING_PROFILE="$PROVISIONING_PROFILE" CLANG_CXX_LIBRARY="libstdc++" | tee $LogBuildName
errorFlag=$?
echo -e "\n\n=========================E结束:${checkItem}========================="

checkItem="获取编译中警告和错误日志内容"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
grep -E " warning| error|SUCCEEDED" $LogBuildName
errorExit $? "!!!错误!!!${checkItem}"
echo -e "\n\n=========================E结束:${checkItem}========================="

if [ $errorFlag -ne 0 ];then
    errorExit $errorFlag "!!!错误!!!"
fi

checkItem="获取编译中打包证书"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
grep "${codeSign}" $LogBuildName
errorExit $? "!!!错误!!!${checkItem}"
codeSignCount=`grep -c "${codeSign}" $LogBuildName`
if [ $codeSignCount -ne 2 ];then
    errorExit $? "!!!错误!!!${checkItem}"
fi
echo -e "\n\n=========================E结束:${checkItem}========================="

checkItem="复制 app和dsym 文件备份"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
VersionPath=${HOME}/${BuildSaveFloder}/${NowData}/    #指定备份路径下,生成版本号文件夹,来管理当前对应版本号的内容
if [ ! -d "$VersionPath" ]; then
    mkdir -p "$VersionPath"
    errorExit $? "!!!错误!!!${VersionPath} 生成错误!"
    echo "创建文件夹:$VersionPath"
fi
echo -e "\n\n=========================E结束:${checkItem}========================="

checkItem="压缩一个app的zip文件,用来备份dsym"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
zip -r $dsymZipName build/$configurationType-iphoneos 1>/dev/null
errorExit $? "!!!错误!!!${checkItem}"
mv $dsymZipName $VersionPath
echo -e "\n\n=========================E结束:${checkItem}========================="

checkItem="用xcrun打包,生成一个ipa文件,可以直接安装"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
rm -rf ${BuildSaveFloder}
mkdir -p ${BuildSaveFloder}/${NowData}
mkdir -p ${BuildSaveFloder}/${installConf}
xcrun -sdk $iosSDK PackageApplication -v $BasePath/build/$configurationType-iphoneos/$targetStr.app -o $BasePath/${BuildSaveFloder}/${NowData}/$ipaName 

errorExit $? "!!!错误!!!${checkItem}"
echo -e "\n\n=========================E结束:${checkItem}========================="

checkItem="判断是否生成了ipa文件"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="
ls ./${BuildSaveFloder}/${NowData}/$ipaName &>/dev/null
errorExit $? "!!!错误!!!${checkItem}"
echo -e "\n\n=========================E结束:${checkItem}========================="

mv -f $BasePath/config.h.bak $BasePath/${targetStr}/config/config.h #还原配置文件
mv -f $BasePath/${plistName}.bak $BasePath/${targetStr}/${plistName} #还原plist文件

checkItem="生成itms-services协议的html安装页面"
((ITEMLINENUMBER ++))
echo -e "\n\n${ITEMLINENUMBER}.=========================S开始:${checkItem}========================="

#切换到tmp文件夹
cd /tmp
#创建临时文件夹
tmpfoldername=ipa_tmp
if [ -d ./${tmpfoldername} ];then
	rm -rf ${tmpfoldername}
fi
mkdir -p /tmp/${tmpfoldername}

cd /tmp/${tmpfoldername}
#拷贝ipa到临时文件夹中
cp ${BasePath}/${BuildSaveFloder}/${NowData}/$ipaName ./tmp.zip
#将ipa解压
unzip tmp.zip
#app文件中Info.plist文件路径
app_infoplist_path=$(pwd)/Payload/$targetStr.app/Info.plist
#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${app_infoplist_path})
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${app_infoplist_path})
#取bundleIdentifier
bundleIdentifier=$(/usr/libexec/PlistBuddy -c "print CFBundleIdentifier" ${app_infoplist_path})
#取CFBundleName
target_name=$(/usr/libexec/PlistBuddy -c "print CFBundleName" ${app_infoplist_path})
#取CFBundleDisplayName
display_name=$(/usr/libexec/PlistBuddy -c "print CFBundleDisplayName" ${app_infoplist_path})
errorExit $? "!!!错误!!!${checkItem} # 获取.plist文件中的信息"
#删除临时文件夹
cd ..
rm -rf ${tmpfoldername}

#进入到工程路径下
cd ${BasePath}
cp ${targetStr}/Resources/icon/icon-120.png ${BuildSaveFloder}/${installConf}/${targetStr}_logo.png

#显示名称
ipa_name="${display_name}"

if [ $Env -eq 3 ];then
	#ipa下载url
	ipa_download_url=${pulish_url}/release/$ipaName
else
	#ipa下载url
	ipa_download_url=${pulish_url}/ios/${NowData}/$ipaName
fi
#itms-services协议串
ios_install_url="itms-services://?action=download-manifest&url=https://${rsyncServer}/qianlong/ios/${installConf}/$EnvD-${plistName}"

#生成install.html文件
cat << EOF > ./${BuildSaveFloder}/install_$EnvD.html
<!DOCTYPE HTML>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html" charset="UTF-8" />
    <title>安装${ipa_name}</title>
  </head>
  <body>
  	<div>
		<br>
		<br>
		<br>
		<br>
		<center><img src="${pulish_url}/ios/${installConf}/${targetStr}_logo.png" border="0"/></center>
		<p align=center>
			<font size="6">
				Title: ${ipa_name}
			</font>
		</p>
		<p align=center>
			<font size="6">
				Bundle-identifier: ${bundleIdentifier}
			</font>
		</p>
		<p align=center>
			<font size="6">
				Bundle-version: ${bundleVersion}
			</font>
		</p>
		<br>
		<br>
		<p align=center>
			<font size="10">
				<a href="${ios_install_url}">点击这里在线安装${ipa_name}</a>
			</font>
		</p>
		<br>
		<br>
		<p align=center>
			<font size="6">
				<a href="http://${rsyncServer}/ca.crt">如提示证书无效，请点击这里安装ca.crt证书</a>
			</font>
		</p>
		<br>
		<br>
		<p align=center>
			<font size="6">
				<a href="${ipa_download_url}">点击这里下载安装${ipa_name}</a>
			</font>
		</p>
    </div>
  </body>
</html>
EOF
errorExit $? "!!!错误!!!${checkItem} # 生成install.html文件"

#生成plist文件
cat << EOF > ./${BuildSaveFloder}/${installConf}/$EnvD-${plistName}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   <key>items</key>
   <array>
       <dict>
           <key>assets</key>
           <array>
               <dict>
                   <key>kind</key>
                   <string>software-package</string>
                   <key>url</key>
                   <string>${ipa_download_url}</string>
               </dict>
               <dict>
                   <key>kind</key>
                   <string>display-image</string>
                   <key>needs-shine</key>
                   <true/>
                   <key>url</key>
                   <string>${pulish_url}/ios/${installConf}/${targetStr}_logo.png</string>
               </dict>
	       <dict>
                   <key>kind</key>
                   <string>full-size-image</string>
                   <key>needs-shine</key>
                   <true/>
                   <key>url</key>
                   <string>${pulish_url}/ios/${installConf}/${targetStr}_logo.png</string>
               </dict>
           </array><key>metadata</key>
           <dict>
               <key>bundle-identifier</key>
               <string>${bundleIdentifier}</string>
               <key>bundle-version</key>
               <string>${bundleVersion}</string>
               <key>kind</key>
               <string>software</string>
               <key>subtitle</key>
               <string>${ipa_name}</string>
               <key>title</key>
               <string>${ipa_name}</string>
           </dict>
       </dict>
   </array>
</dict>
</plist>
EOF
errorExit $? "!!!错误!!!${checkItem} # 生成plist文件"
echo -e "\n\n=========================E结束:${checkItem}========================="

checkItem="同步信息到下载服务器上,可以直接通过网页下载安装"
((ITEMLINENUMBER ++))
cp ./${BuildSaveFloder}/${NowData}/$ipaName $VersionPath
if [ $Env -eq 3 ];then
	rsync -av ${BasePath}/${BuildSaveFloder}/${installConf}/ ylftp@$rsyncServer::sync/$rsyncFloder/${installConf} --password-file=${BasePath}/rsync.passwd
	rsync -av ${BasePath}/${BuildSaveFloder}/${NowData}/$ipaName ${BasePath}/${BuildSaveFloder}/install_$EnvD.html ylftp@$rsyncServer::sync/qianlong/release --password-file=${BasePath}/rsync.passwd
else
	rsync -av ${BasePath}/${BuildSaveFloder}/ ylftp@$rsyncServer::sync/$rsyncFloder --password-file=${BasePath}/rsync.passwd
fi
errorExit $? "!!!错误!!!${checkItem}"
echo -e "\n\n=========================E结束:${checkItem}========================="