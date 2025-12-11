# SonarQube Linux C++ 專案導入示範

此為示範專案，教導如何將 Linux 平台的 C++ 專案導入到 SonarQube。

---

## 使用版本

| 工具 | 版本 |
|------|------|
| SonarQube | Developer Edition v10.6 |
| Build Wrapper | Cpp Linux x86 |
| SonarScanner | CLI 6.1.0.4477 |

---

## 前置作業

1. 透過個人 GitLab 帳號的 **Personal Access Token** 將該 C++ 專案加入到 SonarQube

2. 選擇 **Previous Version** 當作 New Code 的 baseline

3. 將 SonarQube 的 URL 儲存在 GitLab 的**全域變數**裡，取名為 `SONAR_HOST_URL`

4. 將該 C++ 專案在 SonarQube 產生出來的 **Project Key** 儲存到 GitLab 的 **Settings → CI/CD → Variables** 裡，取名為 `SONARQUBE_PROJECT_KEY`

5. 將該 C++ 專案在 SonarQube 產生出來的 **Token** 儲存到 GitLab 的 **Settings → CI/CD → Variables** 裡，取名為 `SONAR_TOKEN`

---

## 專案修改

1. 修改 `.gitlab-ci.yml` 裡的 `image`，選一個可以編譯你軟體的環境，並且該環境也需要擁有 `git` 與 `7z` 等工具

2. 修改 `.gitlab-ci.yml` 裡的 `tag`，選一個 GitLab 有提供的 Linux 環境去啟動 image

3. 修改 `SQAnalysis.sh` 裡的 `version` 軟體版本

4. 修改 `SQAnalysis.sh` 裡的 `release` 分支前綴

---

## 開始分析

| 分支類型 | New Code 區分方式 |
|----------|-------------------|
| `master` | 使用 `SQAnalysis.sh` 裡的 `Version` 變數 |
| `release` | 使用 `SQAnalysis.sh` 裡的 `Version` 變數 |
| `feature` / `bug` | 使用 `.gitlab-ci.yml` 裡的 `NewCodeRefBranch` 變數 |

---

## 備註

Solution 層級
- Makefile： 紀錄該 Solution 支援哪些操作 (Build, Clean, Rebuild)
- SolutionConfig.mk： 紀錄該 Solution 底下有哪些 Project

Project 層級
- Makefile: 紀錄該 Project 要編譯哪些組態與平台
- ProjConfig.mk，紀錄該 Project 的名稱、該 Project 的輸出形式 (exe, dll, lib)、該 Project 的相依性 (compile, link)
- ProjSrcFiles.mk: 紀錄該 Project 底下有哪些 .cpp 檔要編譯
