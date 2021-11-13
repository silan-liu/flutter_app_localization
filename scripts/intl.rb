
# 目的：解决 intl 插件自动生成的代码中，多插件的语言国际化问题

# 遍历目录下的所有插件，修改 generated/l10n.dart 和 generated/intl/messages_all.dart 文件。

# l10n.dart 修改内容如下：
# 1. 将 import 'package:intl/intl.dart' 替换为 import 'package:xx/intl/my_intl.dart'
# 2. 将 S.load 方法实现替换成 Intl.load。

# messages_all.dart 修改内容如下：
# 添加 getMessageLookup 方法到文件末尾


require 'find'
require 'pathname'
require 'fileutils'

# 当前目录
cur_path = __dir__

puts "cur_path: #{cur_path}"

# 工程目录
project_path = Pathname(cur_path).parent

puts "project path: #{project_path}"

# 改造后的原 my_intl 文件，在 scripts 目录下
my_intl_name = 'my_intl'
$my_intl_path = File.join(cur_path, my_intl_name)

# 生成 messageLookup 的代码
message_look_up_code = """\n\nFuture<MessageLookup?> getMessageLookup(String localeName) async {
    var availableLocale = Intl.verifiedLocale(
        localeName, (locale) => _deferredLibraries[locale] != null,
        onFailure: (_) => null);
    if (availableLocale == null) {
      return new Future.value(null);
    }
    var lib = _deferredLibraries[availableLocale];
    await (lib == null ? new Future.value(null) : lib());
  
    final messageLookup = new CompositeMessageLookup();
    messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  
    return messageLookup;
  }"""


# copy intl 文件
def copyIntl(lib_dir)

    unless File.exists?(lib_dir)
        return
    end

    # copy 到插件的目录
    target_intl_dir_name = 'intl'

    intl_dir = File.join(lib_dir, target_intl_dir_name)

    # copy 到插件中的 my_intl.dart 路径
    target_intl_name ='my_intl.dart'

    intl_path = File.join(intl_dir, target_intl_name)
    
    puts "begin copy my_intl.dart to plugin: #{intl_path}"

    # mkdir
    FileUtils.mkdir_p(intl_dir)

    # cp
    FileUtils.cp($my_intl_path, intl_path)
end

# 追加代码，如果存在，则替换
def appendCode(file_path, code)
    unless !File.exists?(file_path)
        content = File.read(file_path)
        
        if content.include?("getMessageLookup") 
            # 进行替换
            regex = /\s*Future<MessageLookup\?>\s*getMessageLookup\(\s*String\s*\w+\s*\)[\s\S]+}/
            content = content.gsub(regex, code)

            # puts content
            File.write(file_path, content);
        else
            File.write(file_path, code, mode: "a");
        end
    end
end

# 修改 l10n
def modifyL10n(file_path)

    unless File.exists?(file_path)
        return
    end

    # 读取 l10n.dart 文件
    l10n_content = File.read(file_path)

    unless l10n_content.empty?

        puts "begin replace import header ..."

        # 替换头文件，将 import 'package:intl/intl.dart' 替换为 import 'package:xx/intl/my_intl.dart'
        # 兼容 // import 'package:intl/intl.dart' 的情况
        import_regex = /^\s*(\/\/)?\s*import\s* \'package:intl\/intl.dart\'\s*;/
        replaced_l10_content = l10n_content.gsub(import_regex, "import '../intl/my_intl.dart';")

        puts "begin replace S.load ..."

        # 替换 S.load 实现
        replaced_load_impl = '=> Intl.load(locale);'

        # $0 表示匹配的整段字符串，$1 表示 group1
        regex = /(^\s*static\s*Future<S>\s*load\(\s*Locale\s*\w+\)\s*)([\s\w.,!_=()?:;{}>\[\]]+})/
        replaced_l10_content = replaced_l10_content.gsub(regex, '\1' + replaced_load_impl)

        # 写入文件
        File.write(file_path, replaced_l10_content);

        puts "done ..."
    else
        puts "l10n_content is empty ..."
    end
end


# 遍历目录
# 若存在 generated/l10n.dart 文件，则先 copy 一份 my_intl.dart 文件到各个插件的 intl 目录下。
Find.find(project_path) do |path|
    if !path.include?('.') && path.end_with?('/lib')

        dirname = Pathname(path).dirname

        # 取出 plugin 名字
        plugin_name = dirname.basename

        # l10n 文件
        l10n_path = File.join(path, 'generated', 'l10n.dart')

        # messages_all.dart
        messages_all_path = File.join(path, 'generated', 'intl', 'messages_all.dart')

        # pubspec 文件
        pubspec_path = File.join(dirname, 'pubspec.yaml')

        # pubspec.yaml 文件存在，则认为是 package/plugin
        # 且 l10n、 messages_all 文件存在
        if File.exist?(pubspec_path) && File.exist?(l10n_path) && File.exist?(messages_all_path)
                    
            puts "================================================================"

            puts "handle plugin: #{plugin_name}"

            # copy 到插件的目录
            copyIntl(path)

            # 向 messages_all.dart 添加代码
            appendCode(messages_all_path, message_look_up_code)

            # 修改 l10n.dart 文件
            modifyL10n(l10n_path)

            puts "================================================================\n\n"

        end
    end
end



