/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

/// 账号类型（user_type）
///
/// 唯一真相源是服务端 users.user_type（见 usertypeconst）。
/// 「好友」列表只放人，非人类账号（机器人 / 数字伙伴）统一归入「机器人」入口。
enum UserType {
  normal(1), // 普通用户（人）
  bot(2), // 机器人（开放平台创建，工号前缀 B）
  digital(3); // 数字伙伴（Agent，工号前缀 A）

  const UserType(this.value);

  final int value;

  static UserType fromValue(int? value) {
    return switch (value) {
      2 => UserType.bot,
      3 => UserType.digital,
      _ => UserType.normal,
    };
  }

  /// 展示用标签。机器人与数字伙伴是两类东西，不能都叫「机器人」。
  String get label => switch (this) {
    UserType.bot => '机器人',
    UserType.digital => '数字伙伴',
    UserType.normal => '',
  };
}

/// 是否是人类账号。取不到类型时按人处理，避免把老数据藏起来。
bool isHumanUser(int? userType) =>
    UserType.fromValue(userType) == UserType.normal;

/// 是否是非人类账号（机器人 / 数字伙伴）。
/// 注意 bot 只是其中一个子类，这里判断的是「不是人」，不要和 UserType.bot 混用。
bool isNonHumanUser(int? userType) => !isHumanUser(userType);
