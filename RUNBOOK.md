# Beaver IM (Flutter) 启动与打包指南

> 本项目使用 **FVM** 管理 Flutter SDK（版本见 `.fvmrc`，当前为 `stable`）。
> 所有命令都在项目根目录 `beaver-flutter/` 下执行。

---

## 0. 环境准备（一次性）

```bash
# 查看 fvm 是否安装
fvm --version

# 项目已配置 SDK（.fvmrc），首次拉代码后安装对应版本
fvm install

# 确认 SDK 可用 / 环境体检
fvm flutter doctor
```

> **本机环境说明**：`fvm` 的 `stable` 版本目录
> `D:\sortware\fvm\cache\versions\stable` 是一个 Junction，指向 `F:\sdk\flutter`。
> 所以 `fvm flutter` 实际用的是 **Flutter 3.47.7 / Dart 3.13.5**（不是旧缓存）。
> 换机器时按实际的 `fvm install` 流程装即可，上面这句只针对当前开发机。

IDE 配置：
- Android Studio / VS Code 的 Flutter SDK 路径指向 `beaver-flutter/.fvm/flutter_sdk`
- 这样 IDE 里的运行/调试也走 FVM 锁定的版本，避免命令行和 IDE 版本不一致

---

## 1. 环境（ENV）说明

环境通过 `--dart-define=ENV=<dev|test|prod>` 传入，**默认 prod**。
`AppConfig.env`（`lib/common/config/config.dart`）读取该值，`AppConfig.init()` 据此切换 `baseUrl / wsUrl`。

| ENV | API baseUrl | WS | 用途 |
|-----|-------------|-----|------|
| `dev` | `http://192.168.3.4:20800` | `ws://192.168.3.4:20800/...` | 本机局域网开发服务器 |
| `test` | `https://server.wsrh8888.com` | `wss://.../beaver/api/ws/socket/v1/ws` | 测试服 |
| `prod` | `https://server.wsrh8888.com` | `wss://.../beaver/api/ws/socket/v1/ws` | 生产服（默认） |

> 改服务器地址：编辑 `lib/common/config/env.dart` 里的 `_configs`。

---

## 2. 启动到真机 / 模拟器（最常用）

### 2.1 先看有哪些设备

```bash
fvm flutter devices
adb devices        # Android 真机/模拟器
```

### 2.2 启动命令模板

```bash
# 指定设备 + 环境（把 <device-id> 换成 flutter devices 里的 id）
fvm flutter run -d <device-id> --dart-define=ENV=dev

# 不指定 -d，只有一台设备时自动选
fvm flutter run --dart-define=ENV=dev

# iOS 真机
fvm flutter run -d <device-id> --dart-define=ENV=test
```

只连了一台设备时，不带 `-d` 即可自动选中：

```bash
fvm flutter run --dart-define=ENV=dev
```

### 2.3 用便捷脚本（ Windows，推荐，免记参数）

`scripts/` 下已备好脚本，双击或在项目根目录执行：

| 脚本 | 作用 |
|------|------|
| `scripts/run-dev.bat` | 启动到小米/红米 M2006J10C（`454pukytzlrkp7bm`），ENV=dev |
| `scripts/run-test.bat` | 启动，自动选设备，ENV=test |
| `scripts/run-prod.bat` | 启动，自动选设备，ENV=prod |

用法（在 PowerShell / CMD 里）：

```bat
scripts\run-dev.bat
scripts\run-test.bat
scripts\run-prod.bat
```

> `run-dev.bat` 强制指定小米设备 `454pukytzlrkp7bm`（改手机需更新脚本里的 `DEVICE_ID`）；
> `run-test.bat` / `run-prod.bat` 不带 `-d`，由 Flutter 自动选设备。

### 2.4 热重载快捷键（run 会话中）

| 键 | 作用 |
|----|------|
| `r` | 热重载（改 UI 后刷新） |
| `R` | 热重启（改了 main()/初始化逻辑必须用这个） |
| `q` | 退出 |

> ⚠️ 改了 `main.dart`、`config.dart`、`env.dart` 等初始化代码后，必须按 `R` 完整重启，热重载 `r` 不生效。

---

## 3. 打包

### 3.1 Android APK（可直接安装调试）

```bash
# dev 环境 debug 包
fvm flutter build apk --debug --dart-define=ENV=dev

# test 环境 release 包（当前 release 用 debug 签名，可直接装）
fvm flutter build apk --release --dart-define=ENV=test

# prod 环境 release 包
fvm flutter build apk --release --dart-define=ENV=prod

# 按 ABI 拆分（体积更小）
fvm flutter build apk --release --split-per-abi --dart-define=ENV=prod
```

产物：`build/app/outputs/flutter-apk/`

### 3.2 Android App Bundle（上架用）

```bash
fvm flutter build appbundle --release --dart-define=ENV=prod
```

产物：`build/app/outputs/bundle/release/`

### 3.3 iOS

```bash
fvm flutter build ios --release --dart-define=ENV=prod
# 或 ipa
fvm flutter build ipa --release --dart-define=ENV=prod
```

### 3.4 打包脚本（免记参数）

| 脚本 | 作用 |
|------|------|
| `scripts/build-apk-prod.bat` | release APK，ENV=prod |

> 正式上架前需替换签名：在 `android/app/` 放 keystore，并配置 `android/key.properties`
> + `android/app/build.gradle` 的 `signingConfigs`。当前 release 暂用 debug 签名（见 build.gradle）。

---

## 4. 常见问题

### Q1: 编译报 `Invalid kernel binary format version (expected xxx, found yyy)`
旧 SDK 残留的编译缓存。清理后重试：

```bash
fvm flutter clean
fvm flutter pub get
fvm flutter run --dart-define=ENV=dev
```

### Q2: `pub get` 卡住不动
本机环境变量可能带了不可用的代理。直连 pub.dev：

```bash
# Git Bash
env -u HTTP_PROXY -u HTTPS_PROXY -u http_proxy -u https_proxy fvm flutter pub get
```

### Q3: 第三方库空安全编译错误（如 livekit_client）
通常是依赖版本与 SDK 版本不匹配。项目已在 `pubspec.yaml` 锁定 `livekit_client: ^2.14.0`（兼容 Dart 3.13+）。
若换 SDK 后再次出现，升级对应依赖即可：`fvm flutter pub upgrade <包名>`。

### Q4: app 装上了但启动卡在闪屏 / Zone mismatch
检查 `lib/main.dart`：`WidgetsFlutterBinding.ensureInitialized()` 必须与 `runApp()` 在同一个
`runZonedGuarded` zone 内。本项目已修复（binding 初始化移入 zone 内）。

### Q5: Gradle 版本 warning
已升级到 Flutter 3.47 推荐组合：**Gradle 9.1.0 / AGP 9.0.1 / Kotlin 2.3.20**（见
`android/gradle/wrapper/gradle-wrapper.properties` 与 `android/settings.gradle.kts`）。
首次构建时 Gradle wrapper 会自动下载 9.1.0；若下载被代理断流（`Unexpected end of file`），
手动下载 `gradle-9.1.0-all.zip` 放到 `~/.gradle/wrapper/dists/gradle-9.1.0-all/` 对应目录即可。
临时跳过版本校验可加 `--android-skip-build-dependency-validation`（不建议，现已无需）。

### Q6: native 库（livekit_ffi / sqlite3）走 GitHub 下载超时 / 502
本机代理白名单不含 `github.com`，hook 里的 `.so` 下载会 `TimeoutException` / `502 Bad Gateway`。
已做的本地绕过（**改的是全局 Pub Cache / 项目 .dart_tool，不在仓库里**，换机或清缓存后需重做）：

- **livekit_ffi**：把已缓存的 `liblivekit_ffi.so` 复制到包根目录
  `C:\Users\hao\AppData\Local\Pub\Cache\hosted\pub.dev\livekit_ffi-0.15.0\`，
  hook 的 `local.exists()` 分支命中后就不会再下载。
- **sqlite3**：`sqlite3-3.2.0/lib/src/hook/assets.dart` 里把缓存目录 hash 改成由稳定字符串计算
  （原 `enum` 的 identity hashCode 跨进程随机，导致 `dirname` 每次变），
  并把正确 hash 的 `libsqlite3.so` 放到
  `.dart_tool/hooks_runner/shared/sqlite3/build/download-13cad883/`。

### Q7: `flutter run` 卡在 `Running Gradle task 'assembleDebug'...` 不动
不一定是 Gradle 真在构建。判断方法：
- 采样 Gradle daemon 的 CPU（`Get-Process -Id <pid> | select CPU`），几秒不动 = 卡住；
- `jstack <daemon-pid>` 看 main 线程，若是 `DaemonStateCoordinator.awaitStop`，
  说明**构建已结束、daemon 已空闲**，卡的是 `flutter run` 进程本身。

常见诱因：给 run 命令接了 `grep ... | head` 这类会提前退出的管道，`head` 收满行数退出后
`tee`/flutter 的 stdout 被 SIGPIPE 掐断，进程僵死。
处理：终止僵死进程，确认没有残留 `dart.exe`，然后用**不截断**的方式重启：

```bash
fvm flutter run --dart-define=ENV=dev 2>&1 | tee /tmp/run.log
# 注意：不要再往后面接 | head / | grep -m N
```

---

## 5. 一条命令速查

```bash
# dev 环境（自动选设备，最常用）
fvm flutter run --dart-define=ENV=dev

# 打 prod release 包
fvm flutter build apk --release --dart-define=ENV=prod
```
