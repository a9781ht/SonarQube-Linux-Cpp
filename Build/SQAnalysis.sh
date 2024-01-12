#!/bin/bash
XXBuildVersion=1.0.0
 
# download build-wrapper and sonar-scanner
echo
echo '-download build-wrapper'
curl -SL --output $HOME/build-wrapper-linux-x86.zip https://sonarqube.syntecclub.com/static/cpp/build-wrapper-linux-x86.zip
echo '-download sonar-scanner'
curl -SL --output $HOME/sonar-scanner-cli-4.8.0.2856-linux.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
 
# extract zip
echo
echo '-extract build-wrapper'
unzip -q $HOME/build-wrapper-linux-x86.zip -d $HOME/
echo '-extract sonar-scanner'
unzip -q $HOME/sonar-scanner-cli-4.8.0.2856-linux.zip -d $HOME/
 
# add to PATH
echo
echo '-add build-wrapper file path into environment variable'
export PATH=$PATH:$HOME/build-wrapper-linux-x86
echo '-add sonar-scanner file path into environment variable'
export PATH=$PATH:$HOME/sonar-scanner-4.8.0.2856-linux/bin
 
# define New Code
if [[ $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH ]] || [[ $CI_COMMIT_BRANCH =~ ^OCKrnl_ ]]; then
  # master/main branch or release beanch
  newcode='"sonar.projectVersion='$XXBuildVersion'"';
else
  # feature beanch
  newcode='"sonar.newCode.referenceBranch='$NewCodeRefBranch'"';
fi
 
# start to build
echo
echo '==== SonarQube build ===='
build-wrapper-linux-x86-64 --out-dir ./SonarQube ./build.sh Linux_x64
 
# start to scan
echo
echo '==== SonarQube scan ===='
pushd ..
sonar-scanner -D"sonar.cfamily.build-wrapper-output=Build/SonarQube" -D"sonar.host.url=$SONAR_HOST_URL" -D"sonar.login=$SONAR_TOKEN" -D$newcode
if [ $? != 0 ]; then exit 1; fi
popd
 
# clean up
echo
echo '-clean up'
rm -f $HOME/build-wrapper-linux-x86.zip
rm -f $HOME/sonar-scanner-cli-4.8.0.2856-linux.zip
rm -rf $HOME/build-wrapper-linux-x86
rm -rf $HOME/sonar-scanner-4.8.0.2856-linux
 
# check scan status
echo
echo '-check scan status'
TASK_URL=$(grep ceTaskUrl ../.scannerwork/report-task.txt | awk -F 'ceTaskUrl=' '{print $2}')
STATUS=$(curl -u $SONAR_TOKEN: ${TASK_URL} 2>&1 | grep -oE '("status":")[^"]*' | awk -F '"' '{print $NF}')
[ -z "$TASK_URL" ] && STATUS='FAILED'
echo 'Scan Status : '$STATUS
if [[ $STATUS != SUCCESS ]]; then
  exit 1;
fi