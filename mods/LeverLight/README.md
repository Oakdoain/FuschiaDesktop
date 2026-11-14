# LeverLight（控制杆）- Minecraft 1.20.1 / Forge

## 功能

- 仅新增一个物品：`leverlight:control_lever`（控制杆）。它不是 BlockItem，因此不能作为拉杆放置。
- 物品模型继承 `minecraft:item/lever`，使用与原版拉杆完全一致的模型及纹理（不复制 Minecraft 的版权素材）。
- 玩家背包中有控制杆（包括快捷栏、主手、副手）时，在服务端每 20 tick 检查一次并续上迅捷 I 60 tick。比迅捷 I 更高级的迅捷不会被覆盖。
- 将原版拉杆放入任意合成格，直接合成 1 个控制杆，配方为无序合成。
- 光源等级 15：内置 RyoamicLights JSON 和 OptiFine 动态光源 properties。发光依赖客户端安装对应兼容模组、启用动态光源；仅装光影包不能保证生效。通常只在主/副手及掉落物品上生效，背包本身不会照明。
- 在模组的创造模式「工具与实用物品」分类可以直接获取。

## 推荐环境

- Minecraft Java Edition **1.20.1**
- Minecraft Forge **47.x**（使用 `47.4.0` 编译）
- Java **17**

## 构建为真正可安装的 JAR（重要）

这是**完整 Gradle/Forge 源码工程，不是已经编译好的 JAR**。本次交付环境没有 ForgeGradle 所需依赖网络和缓存，因此未能完成正式编译或 Minecraft 游戏验证。

### 路线 A：GitHub Actions（不需要本机装开发软件）

1. 此工程位于 `Oakdoain/FuschiaDesktop` 的 `mods/LeverLight/` 目录中，主项目 Godot 文件保持不变。
2. 推送功能分支或创建 Pull Request 会自动触发构建；**手动 `Run workflow` 需要工作流先合并进入默认分支**。
3. 编译成功后，从该运行页面底部 `Artifacts` 下载 `LeverLight-Forge-1.20.1-Installable-JAR`，解压得到真正的 `.jar`。
4. 将 JAR 放入 Minecraft **mods** 文件夹。联机时需要客户端和服务器安装本模组；动态光源模组通常只需要客户端。

### 路线 B：本地 Gradle

1. 安装 JDK 17 和 Gradle 8.8，保证可联网下载 Forge/ForgeGradle 依赖。
2. 在源码根目录运行 `gradle build`。
3. 编译输出位于 `build/libs/leverlight-forge-1.20.1-1.0.0.jar`（ForgeGradle 将进行 reobf 处理）。

## 测试

1. 使用 `/give @s leverlight:control_lever` 获得控制杆。
2. 将控制杆留在背包并行走，确认获得迅捷 I。
3. 尝试对地面右键，应无法像原版拉杆那样放置控制杆。
4. 将一个原版拉杆单独放入合成栏，确认产出控制杆。
5. 若使用 RyoamicLights，请同时安装其所需依赖并打开动态光源设置（该功能默认可能关闭）；手持或放入副手后在黑暗处验证光照。

## 兼容性说明

- 不添加实际发光方块，不改变世界光照数据，不影响刷怪判定；动态光源是客户端的视觉效果。
- 对于 Iris/Oculus/OptiFine 等光影渲染环境，是否最终显示动态光源取决于具体光源实现和渲染兼容性。
- 本项目源码未在游戏运行验证。若编译失败，请提供 GitHub Actions 的构建日志或 `gradle build` 的完整错误。
