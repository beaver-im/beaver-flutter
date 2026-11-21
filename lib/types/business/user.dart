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

import 'package:equatable/equatable.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/types/business/user_type.dart';

/// 用户仓库接口
abstract class UserRepositoryInterface {
  Future<User?> getUserProfile(String userId);
  Future<UserInfo> getMyUserInfo();
  Future<bool> updateProfile({
    String? nickname,
    String? avatar,
    String? abstract,
    int? gender,
  });
  Future<bool> getEmailCode(String email, String type);
  Future<bool> updateEmail(String email, String code);
}

/// 用户信息模型 (UI)
class UserInfo extends Equatable {
  final String userId;
  final String nickname;
  final String? avatar;
  final String? abstract;
  final String? email;
  final String? phone;
  final int gender;

  /// 账号类型：1 普通用户 / 2 机器人 / 3 数字伙伴。
  /// 好友列表按它区分「人」与「机器人」，所以必须一路从本地 users 表带上来。
  final UserType userType;

  const UserInfo({
    required this.userId,
    required this.nickname,
    this.avatar,
    this.abstract,
    this.email,
    this.phone,
    this.gender = 0,
    this.userType = UserType.normal,
  });

  bool get isHuman => userType == UserType.normal;

  @override
  List<Object?> get props => [
    userId,
    nickname,
    avatar,
    abstract,
    email,
    phone,
    gender,
    userType,
  ];


  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      userId: map['userId'] ?? '',
      nickname: map['nickname'] ?? 'Beaver',
      avatar: map['avatar'],
      abstract: map['abstract'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'] ?? 0,
      userType: UserType.fromValue(map['userType'] as int?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nickname': nickname,
      'avatar': avatar,
      'abstract': abstract,
      'email': email,
      'phone': phone,
      'gender': gender,
      'userType': userType.value,
    };
  }

  UserInfo copyWith({
    String? userId,
    String? nickname,
    String? avatar,
    String? abstract,
    String? email,
    String? phone,
    int? gender,
    UserType? userType,
  }) {
    return UserInfo(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      abstract: abstract ?? this.abstract,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      userType: userType ?? this.userType,
    );
  }
}
