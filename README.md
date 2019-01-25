# Ext-Framework
延展类的 framwork

使用说明
1.将LsqExtension.framework拖入工程
2.targets->build Settings->enable Bitcode 设置为No
3.argets->build Phases 点击+号，新增一个 New Copy Feils Phases,找到Copy Files ，将Destination选项改为 Frameworks,   Name一栏添加LsqExtension.framework
4.使用的地方需要 import LsqExtension
