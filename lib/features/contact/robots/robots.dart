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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/types/business/user_type.dart';
import 'package:beaver/types/cache.dart';

/// 机器人列表：所有非人类账号（机器人 + 数字伙伴）。
///
/// 平铺展示、不分段。具体是机器人还是数字伙伴由行内标签区分——
/// 「机器人」是入口名，不是账号类型名，别把数字伙伴也叫成机器人。
class RobotListPage extends StatelessWidget {
  const RobotListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '机器人',
      showBack: true,
      showHeader: true,
      isScrollable: false,
      child: BlocBuilder<FriendStore, FriendStoreState>(
        builder: (context, state) {
          final robots = state.friends.where((c) => !c.isHuman).toList();

          if (robots.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8.w),
            itemCount: robots.length,
            separatorBuilder: (_, __) => Divider(
              height: 1.w,
              indent: 76.w,
              color: const Color(0xFFEBEEF5),
            ),
            itemBuilder: (context, index) => _buildRobotItem(context, robots[index]),
          );
        },
      ),
    );
  }

  Widget _buildRobotItem(BuildContext context, ContactModel robot) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.contactDetail.replaceAll(':userId', robot.userId),
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
        color: Colors.white,
        child: Row(
          children: [
            BeaverCachedImage(
              fileUrl: robot.avatar,
              type: CacheType.avatar,
              width: 48.w,
              height: 48.w,
              borderRadius: 24.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    robot.notice?.isNotEmpty == true
                        ? robot.notice!
                        : robot.nickname,
                    style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D3436),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (robot.userType.label.isNotEmpty) ...[
                    SizedBox(height: 2.w),
                    Text(
                      robot.userType.label,
                      style: TextStyle(
                        fontSize: 12.w,
                        color: const Color(0xFFB2BEC3),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/common/arrow-right.svg',
              width: 16.w,
              height: 16.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFFB2BEC3),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/friend/ai-assistant.svg',
            width: 60.w,
            height: 60.w,
            colorFilter: const ColorFilter.mode(
              Color(0xFFB2BEC3),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 12.w),
          Text(
            '暂无机器人',
            style: TextStyle(fontSize: 16.w, color: const Color(0xFF636E72)),
          ),
          SizedBox(height: 8.w),
          Text(
            '添加机器人或数字伙伴后会出现在这里',
            style: TextStyle(fontSize: 12.w, color: const Color(0xFFB2BEC3)),
          ),
        ],
      ),
    );
  }
}
