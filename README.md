# GMGN App

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live%20Demo-blue?style=flat-square&logo=github)](https://harry-chen-dev.github.io/gmgn_app/)
[![Flutter](https://img.shields.io/badge/Flutter-3.16.0-blue?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue?style=flat-square&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

一款基于 Flutter 开发的加密货币交易和资产管理移动应用，1:1 还原 GMGN.ai 的设计稿。

## 🌐 在线演示

**[🚀 立即体验 - GitHub Pages 演示](https://harry-chen-dev.github.io/gmgn_app/)**

> 注意：首次加载可能需要一些时间，建议使用 Chrome 浏览器获得最佳体验。

## 📱 项目概述

GMGN App 是一个功能完整的加密货币交易平台移动端应用，提供代币发现、专家跟单、实时交易、资产管理等核心功能。应用采用现代化的 Flutter 架构，使用 BLoC 状态管理模式，确保代码的可维护性和扩展性。

## ✨ 主要功能

### 🔍 发现页面

- **代币列表展示**：实时显示热门代币信息
- **多维度筛选**：支持新创建、即将打满、飙升、已开盘等筛选条件
- **标签导航**：自选列表、战绩、新币、热门、监控广场
- **搜索功能**：快速查找目标代币
- **用户状态管理**：未登录/已登录状态适配

### 👑 牛人榜页面

- **专家排行榜**：展示顶级交易者的实时排名
- **多类型筛选**：全部、Pump 聪明钱、聪明钱、新钱包、KOL/VC
- **详细数据展示**：盈亏、胜率、粉丝数、最后活动时间
- **钱包跟单**：支持自动跟随专家交易
- **关注功能**：一键关注/取消关注专家

### 💹 交易页面

- **专业 K 线图**：基于 candlesticks 库的实时价格图表
- **多时间周期**：1 秒、30 秒、1 分钟、1 小时等
- **交易控制**：买入/卖出切换、立即交易/抄底模式
- **实时价格列表**：右侧实时价格数据展示
- **代币信息**：当前价格、市值、涨跌幅

### 💰 资产页面

- **资产总览**：SOL 余额、总价值、盈亏统计
- **持有代币列表**：详细的代币持仓信息
- **交易活动记录**：买入/卖出历史记录
- **数据分析**：PnL 分析、盈利分布、风险检测
- **隐私保护**：余额显示/隐藏切换

### 🔐 认证系统

- **邮箱登录/注册**：支持邮箱账号系统
- **Telegram 集成**：一键 Telegram 登录
- **状态持久化**：登录状态本地存储
- **安全保护**：完整的认证流程

## 🏗️ 技术架构

### 核心技术栈

- **Flutter**: 3.x (跨平台 UI 框架)
- **Dart**: 3.x (编程语言)
- **BLoC Pattern**: 状态管理架构
- **Equatable**: 对象比较优化

### 主要依赖

```yaml
dependencies:
  flutter_bloc: ^8.1.3 # BLoC状态管理
  equatable: ^2.0.5 # 对象相等性比较
  shared_preferences: ^2.2.2 # 本地数据存储
  candlesticks: ^2.1.0 # K线图组件
  http: ^1.1.0 # 网络请求
```

### 项目结构

```
lib/
├── bloc/                      # BLoC状态管理
│   ├── auth/                  # 认证相关BLoC
│   ├── discover/              # 发现页面BLoC
│   ├── experts/               # 专家页面BLoC
│   ├── trade/                 # 交易页面BLoC
│   └── assets/                # 资产页面BLoC
├── data/                      # 数据层
│   └── mock_data.dart         # 模拟数据
├── models/                    # 数据模型
│   ├── user.dart              # 用户模型
│   ├── token.dart             # 代币模型
│   ├── expert.dart            # 专家模型
│   └── asset.dart             # 资产模型
├── pages/                     # 页面组件
│   ├── auth/                  # 认证页面
│   ├── discover/              # 发现页面
│   ├── experts/               # 专家页面
│   ├── trade/                 # 交易页面
│   ├── assets/                # 资产页面
│   ├── follow/                # 关注页面
│   └── settings/              # 设置页面
├── services/                  # 服务层
│   ├── auth_service.dart      # 认证服务
│   └── local_storage_service.dart # 本地存储服务
└── main.dart                  # 应用入口
```

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Chrome 浏览器 (用于 Web 调试)

### 安装步骤

1. **克隆项目**

```bash
git clone <repository-url>
cd gmgn_app
```

2. **安装依赖**

```bash
flutter pub get
```

3. **运行应用**

在 Chrome 浏览器中运行：

```bash
flutter run -d chrome
```

在 Android 模拟器中运行：

```bash
flutter run
```

在 iOS 模拟器中运行：

```bash
flutter run -d ios
```

## 📋 功能特性

### 🎨 UI/UX 设计

- **1:1 设计还原**：完全按照 GMGN.ai 设计稿实现
- **响应式布局**：适配不同屏幕尺寸
- **流畅动画**：页面切换和交互动画
- **深色/浅色主题**：支持主题切换
- **像素级精度**：精确的颜色、字体、间距

### 📊 数据管理

- **BLoC 状态管理**：统一的状态管理架构
- **Mock 数据支持**：完整的模拟数据系统
- **缓存机制**：本地数据缓存优化
- **实时更新**：支持数据实时刷新

### 🔄 状态管理

- **Loading 状态**：优雅的加载指示器
- **Error 处理**：完善的错误处理机制
- **数据同步**：多页面数据状态同步
- **内存优化**：防止内存泄漏

## 🛠️ 开发指南

### 添加新功能

1. 在`models/`中定义数据模型
2. 在`bloc/`中创建对应的 BLoC
3. 在`pages/`中实现 UI 组件
4. 在`data/mock_data.dart`中添加模拟数据

### 代码规范

- 使用 Dart 官方代码风格
- 遵循 BLoC 设计模式
- 组件化开发，提高代码复用性
- 添加必要的注释和文档

### 测试

```bash
# 运行单元测试
flutter test

# 运行集成测试
flutter test integration_test/
```

## 📱 支持平台

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Web** (Chrome, Safari, Firefox)
- ⚠️ **macOS** (实验性支持)
- ⚠️ **Windows** (实验性支持)
- ⚠️ **Linux** (实验性支持)

## 🔧 配置说明

### 环境配置

应用支持多环境配置，可以通过修改配置文件来适应不同的部署环境：

- **开发环境**：使用 Mock 数据
- **测试环境**：连接测试 API
- **生产环境**：连接正式 API

### 资源文件

- **图片资源**：存放在`assets/images/`目录
- **字体文件**：存放在`assets/fonts/`目录
- **配置文件**：`pubspec.yaml`中配置

## 🐛 问题排查

### 常见问题

1. **编译错误**

   - 确保 Flutter SDK 版本正确
   - 运行`flutter clean && flutter pub get`
   - 检查依赖版本兼容性

2. **Android 构建失败**

   - 检查 Android SDK 配置
   - 更新 Gradle 版本
   - 清理构建缓存

3. **Web 运行问题**
   - 使用 Chrome 浏览器
   - 检查网络连接
   - 清理浏览器缓存

### 性能优化

- 使用`const`构造函数减少重建
- 合理使用 BlocBuilder 避免不必要的重建
- 图片资源优化和懒加载
- 列表虚拟化处理大数据集

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request 来改进项目：

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系方式

如有问题或建议，请通过以下方式联系：

- 项目 Issues: [GitHub Issues](https://github.com/Harry-Chen-Dev/gmgn_app/issues)
- GitHub 仓库: [https://github.com/Harry-Chen-Dev/gmgn_app](https://github.com/Harry-Chen-Dev/gmgn_app)
- 在线演示: [https://harry-chen-dev.github.io/gmgn_app/](https://harry-chen-dev.github.io/gmgn_app/)
- 邮箱: your-email@example.com

## 🙏 致谢

- Flutter 团队提供的优秀框架
- BLoC 库的状态管理支持
- Candlesticks 库的图表功能
- GMGN.ai 提供的设计参考

---

**⭐ 如果这个项目对您有帮助，请给它一个 Star！**
