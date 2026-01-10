const std = @import("std");
const rl = @import("raylib");

// 默认(初始化)窗口大小
const INITIAL_WIDTH = 1600;
const INITIAL_HEIGHT = 900;

// 逻辑窗口大小
const VIRTUAL_WIDTH = 1920;
const VIRTUAL_HEIGHT = 1080;

// 原始键盘大小
const KEYBOARD_WIDTH = 1630;
const KEYBOARD_HEIGHT = 470;

// 提示文本大小
const TIP_TEXT_SIZE = 24;

// 按键文字大小
const KEY_TEXT_SIZE = 18;
// 字母间距
const KEY_TEXT_SPACING = 1.5;

// 按键按下颜色
const KEY_PRESSED_COLOR = rl.Color{ .r = 0x00, .g = 0x7d, .b = 0xff, .a = 0xff };

// 按键按下次数颜色
const KEY_COUNTER_COLORS = [_]rl.Color{
    .black,
    .{ .r = 0x00, .g = 0xbf, .b = 0xc9, .a = 0xff },
    .{ .r = 0xff, .g = 0x98, .b = 0x00, .a = 0xff },
    .{ .r = 0x8a, .g = 0x2b, .b = 0xe2, .a = 0xff },
    .{ .r = 0xe4, .g = 0x00, .b = 0x78, .a = 0xff },
};

// 按键结构体
const Key = struct {
    x: f32,
    y: f32,
    width: f32 = 60,
    height: f32 = 60,
    counter: u32 = 0,
    text: [:0]const u8,
    key_code: rl.KeyboardKey,
    is_pressed: bool = false,
};

// 键盘布局
var KEYBOARD_LAYOUT = [_]Key{
    // 第一行
    .{ .x = 30, .y = 30, .text = "Esc", .key_code = .escape },
    .{ .x = 170, .y = 30, .text = "F1", .key_code = .f1 },
    .{ .x = 239.7, .y = 30, .text = "F2", .key_code = .f2 },
    .{ .x = 309.7, .y = 30, .text = "F3", .key_code = .f3 },
    .{ .x = 379.7, .y = 30, .text = "F4", .key_code = .f4 },
    .{ .x = 485, .y = 30, .text = "F5", .key_code = .f5 },
    .{ .x = 555, .y = 30, .text = "F6", .key_code = .f6 },
    .{ .x = 625, .y = 30, .text = "F7", .key_code = .f7 },
    .{ .x = 695, .y = 30, .text = "F8", .key_code = .f8 },
    .{ .x = 800, .y = 30, .text = "F9", .key_code = .f9 },
    .{ .x = 870, .y = 30, .text = "F10", .key_code = .f10 },
    .{ .x = 940, .y = 30, .text = "F11", .key_code = .f11 },
    .{ .x = 1010, .y = 30, .text = "F12", .key_code = .f12 },
    .{ .x = 1100, .y = 30, .text = "PrtScn", .key_code = .print_screen },
    .{ .x = 1170, .y = 30, .text = "ScrLK", .key_code = .scroll_lock },
    .{ .x = 1240, .y = 30, .text = "Pause", .key_code = .pause },

    // 第二行
    .{ .x = 30, .y = 100, .text = "~\n`", .key_code = .grave },
    .{ .x = 100, .y = 100, .text = "!\n1", .key_code = .one },
    .{ .x = 170, .y = 100, .text = "@\n2", .key_code = .two },
    .{ .x = 240, .y = 100, .text = "#\n3", .key_code = .three },
    .{ .x = 310, .y = 100, .text = "$\n4", .key_code = .four },
    .{ .x = 380, .y = 100, .text = "%\n5", .key_code = .five },
    .{ .x = 450, .y = 100, .text = "^\n6", .key_code = .six },
    .{ .x = 520, .y = 100, .text = "&\n7", .key_code = .seven },
    .{ .x = 590, .y = 100, .text = "*\n8", .key_code = .eight },
    .{ .x = 660, .y = 100, .text = "(\n9", .key_code = .nine },
    .{ .x = 730, .y = 100, .text = ")\n0", .key_code = .zero },
    .{ .x = 800, .y = 100, .text = "_\n-", .key_code = .minus },
    .{ .x = 870, .y = 100, .text = "+\n=", .key_code = .equal },
    .{ .x = 940, .y = 100, .width = 130, .text = "Backspace", .key_code = .backspace },
    .{ .x = 1100, .y = 100, .text = "Insert", .key_code = .insert },
    .{ .x = 1170, .y = 100, .text = "Home", .key_code = .home },
    .{ .x = 1240, .y = 100, .text = "PgUp", .key_code = .page_up },
    .{ .x = 1330, .y = 100, .text = "Num\nLock", .key_code = .num_lock },
    .{ .x = 1400, .y = 100, .text = "/", .key_code = .kp_divide }, // 小键盘 /
    .{ .x = 1470, .y = 100, .text = "*", .key_code = .kp_multiply }, // 小键盘 *
    .{ .x = 1540, .y = 100, .text = "-", .key_code = .kp_subtract }, // 小键盘 -

    // 第三行
    .{ .x = 30, .y = 170, .width = 95, .text = "Tab    ", .key_code = .tab },
    .{ .x = 135, .y = 170, .text = "Q", .key_code = .q },
    .{ .x = 205, .y = 170, .text = "W", .key_code = .w },
    .{ .x = 275, .y = 170, .text = "E", .key_code = .e },
    .{ .x = 345, .y = 170, .text = "R", .key_code = .r },
    .{ .x = 415, .y = 170, .text = "T", .key_code = .t },
    .{ .x = 485, .y = 170, .text = "Y", .key_code = .y },
    .{ .x = 555, .y = 170, .text = "U", .key_code = .u },
    .{ .x = 625, .y = 170, .text = "I", .key_code = .i },
    .{ .x = 695, .y = 170, .text = "O", .key_code = .o },
    .{ .x = 765, .y = 170, .text = "P", .key_code = .p },
    .{ .x = 835, .y = 170, .text = "{\n[", .key_code = .left_bracket },
    .{ .x = 905, .y = 170, .text = "}\n]", .key_code = .right_bracket },
    .{ .x = 975, .y = 170, .width = 95, .text = "|\n\\", .key_code = .backslash },
    .{ .x = 1100, .y = 170, .text = "Delete", .key_code = .delete },
    .{ .x = 1170, .y = 170, .text = "End", .key_code = .end },
    .{ .x = 1240, .y = 170, .text = "PgDn", .key_code = .page_down },
    .{ .x = 1330, .y = 170, .text = "7", .key_code = .kp_7 }, // 小键盘 7
    .{ .x = 1400, .y = 170, .text = "8", .key_code = .kp_8 },
    .{ .x = 1470, .y = 170, .text = "9", .key_code = .kp_9 },
    .{ .x = 1540, .y = 170, .height = 130, .text = "+", .key_code = .kp_add }, // 小键盘 +

    // 第四行
    .{ .x = 30, .y = 240, .width = 125, .text = "CapsLock ", .key_code = .caps_lock },
    .{ .x = 165, .y = 240, .text = "A", .key_code = .a },
    .{ .x = 235, .y = 240, .text = "S", .key_code = .s },
    .{ .x = 305, .y = 240, .text = "D", .key_code = .d },
    .{ .x = 375, .y = 240, .text = "F", .key_code = .f },
    .{ .x = 445, .y = 240, .text = "G", .key_code = .g },
    .{ .x = 515, .y = 240, .text = "H", .key_code = .h },
    .{ .x = 585, .y = 240, .text = "J", .key_code = .j },
    .{ .x = 655, .y = 240, .text = "K", .key_code = .k },
    .{ .x = 725, .y = 240, .text = "L", .key_code = .l },
    .{ .x = 795, .y = 240, .text = ";\n:", .key_code = .semicolon },
    .{ .x = 865, .y = 240, .text = "'\n\"", .key_code = .apostrophe },
    .{ .x = 935, .y = 240, .width = 135, .text = "    Enter", .key_code = .enter }, // 主键盘 Enter
    .{ .x = 1330, .y = 240, .text = "4", .key_code = .kp_4 }, // 小键盘 4
    .{ .x = 1400, .y = 240, .text = "5", .key_code = .kp_5 },
    .{ .x = 1470, .y = 240, .text = "6", .key_code = .kp_6 },

    // 第五行
    .{ .x = 30, .y = 310, .width = 150, .text = "Shift         ", .key_code = .left_shift },
    .{ .x = 190, .y = 310, .text = "Z", .key_code = .z },
    .{ .x = 260, .y = 310, .text = "X", .key_code = .x },
    .{ .x = 330, .y = 310, .text = "C", .key_code = .c },
    .{ .x = 400, .y = 310, .text = "V", .key_code = .v },
    .{ .x = 470, .y = 310, .text = "B", .key_code = .b },
    .{ .x = 540, .y = 310, .text = "N", .key_code = .n },
    .{ .x = 610, .y = 310, .text = "M", .key_code = .m },
    .{ .x = 680, .y = 310, .text = "<\n,", .key_code = .comma },
    .{ .x = 750, .y = 310, .text = ".\n>", .key_code = .period },
    .{ .x = 820, .y = 310, .text = "?\n/", .key_code = .slash },
    .{ .x = 890, .y = 310, .width = 180, .text = "           Shift", .key_code = .right_shift },
    .{ .x = 1170, .y = 310, .text = "↑", .key_code = .up },
    .{ .x = 1330, .y = 310, .text = "1", .key_code = .kp_1 }, // 小键盘 1
    .{ .x = 1400, .y = 310, .text = "2", .key_code = .kp_2 },
    .{ .x = 1470, .y = 310, .text = "3", .key_code = .kp_3 },
    .{ .x = 1540, .y = 310, .height = 130, .text = "Enter", .key_code = .kp_enter }, // 小键盘 Enter

    // 第六行
    .{ .x = 30, .y = 380, .text = "Ctrl", .key_code = .left_control },
    .{ .x = 100, .y = 380, .text = "Win", .key_code = .null }, // Fn 键通常不被操作系统上报，用 null
    .{ .x = 170, .y = 380, .text = "Alt", .key_code = .left_super },
    .{ .x = 240, .y = 380, .width = 620, .text = "Space", .key_code = .space },
    .{ .x = 870, .y = 380, .text = "Alt", .key_code = .right_alt },
    .{ .x = 940, .y = 380, .text = "Win", .key_code = .right_super },
    .{ .x = 1010, .y = 380, .text = "Ctrl", .key_code = .right_control },
    .{ .x = 1100, .y = 380, .text = "←", .key_code = .left },
    .{ .x = 1170, .y = 380, .text = "↓", .key_code = .down },
    .{ .x = 1240, .y = 380, .text = "→", .key_code = .right },
    .{ .x = 1330, .y = 380, .width = 130, .text = "0\nIns", .key_code = .kp_0 }, // 小键盘 0
    .{ .x = 1470, .y = 380, .text = ".\nDel", .key_code = .kp_decimal }, // 小键盘 .
};

// 自定义字体
var font: rl.Font = undefined;
// 字符集
const FONT_CHARS: []const i32 = &.{
    // 小写字母
    'a',   'b',   'c',   'd',   'e',   'f',   'g', 'h', 'i',  'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q',   'r',   's',   't',   'u',   'v',   'w',   'x',   'y',   'z',

    // 大写字母
    'A',   'B',   'C',   'D',   'E',   'F',   'G', 'H', 'I',  'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q',   'R',   'S',   'T',   'U',   'V',   'W',   'X',   'Y',   'Z',

    // 数字和符号
    '0',   '1',   '2',   '3',   '4',   '5',   '6', '7', '8',  '9',

    // 符号
    '~', '`', '!', '@', '#', '$', '%',   '^',   '&',   '*',   '(',   ')',   '-',   '_',   '=',   '+',
    '[',   '{',   ']',   '}',   '\\',  '|',   ';', ':', '\'', '"', ',', '<', '.', '>', '/', '?', '↑', '↓', '→', '←',

    // 中文
    '颜', '色', '对', '照', '表', '按',
    '住', '默', '认', '次', '大', '于',
};

pub fn main() anyerror!void {
    // 配置
    rl.setConfigFlags(.{
        .window_resizable = true,
        .msaa_4x_hint = true,
    });

    // 设置输出日志级别
    rl.setTraceLogLevel(.warning);

    // 初始化窗口
    rl.initWindow(INITIAL_WIDTH, INITIAL_HEIGHT, "键盘检测器");
    defer rl.closeWindow();

    // 设置退出键为空
    rl.setExitKey(rl.KeyboardKey.null);

    // 设置目标帧率
    rl.setTargetFPS(60);

    // 自定义字体
    font = try rl.loadFontEx("./assets/fonts/HarmonyOS_SansSC_Regular.ttf", 256, FONT_CHARS);
    defer rl.unloadFont(font);

    // 设置字体纹理过滤模式为点采样
    rl.setTextureFilter(font.texture, .point);

    // 创建相机
    var camera: rl.Camera2D = .{
        .target = .{ .x = 0, .y = 0 },
        .offset = .{ .x = 0, .y = 0 },
        .rotation = 0.0,
        .zoom = 1.0,
    };

    // 主循环
    while (!rl.windowShouldClose()) {
        // 获取当前窗口大小
        const screen_width = @as(f32, @floatFromInt(rl.getScreenWidth()));
        const screen_height = @as(f32, @floatFromInt(rl.getScreenHeight()));
        // 计算缩放比
        const scale_width = screen_width / @as(f32, @floatFromInt(VIRTUAL_WIDTH));
        const scale_height = screen_height / @as(f32, @floatFromInt(VIRTUAL_HEIGHT));
        const scale = @min(scale_width, scale_height);
        camera.zoom = scale;
        // 计算偏移量
        const offset_x = (screen_width - VIRTUAL_WIDTH * scale) / 2;
        const offset_y = (screen_height - VIRTUAL_HEIGHT * scale) / 2;
        camera.offset = .{ .x = offset_x, .y = offset_y };

        // 开始绘制
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.beginMode2D(camera);
        defer rl.endMode2D();

        // 背景颜色
        rl.clearBackground(.white);

        // 直接在屏幕空间绘制键盘
        try drawKeyboard();
    }
}

// 在屏幕空间绘制键盘（避免相机缩放导致的字体模糊）
fn drawKeyboard() !void {
    // 计算键盘位置（居中）
    const keyboard_x = @as(f32, @floatFromInt(VIRTUAL_WIDTH - KEYBOARD_WIDTH)) / 2.0;
    const keyboard_y = @as(f32, @floatFromInt(VIRTUAL_HEIGHT - KEYBOARD_HEIGHT)) / 2.0;

    // 绘制键盘主容器
    const keyboard_color: rl.Color = .{ .r = 0xf1, .g = 0xf3, .b = 0xf5, .a = 0xff };
    const keyboard_width = @as(f32, @floatFromInt(KEYBOARD_WIDTH));
    const keyboard_height = @as(f32, @floatFromInt(KEYBOARD_HEIGHT));
    rl.drawRectangleRounded(.{ .x = keyboard_x, .y = keyboard_y, .width = keyboard_width, .height = keyboard_height }, 0.1, 4, keyboard_color);

    // 绘制提示文本
    var x = keyboard_x;
    const y = keyboard_y - TIP_TEXT_SIZE - 10;
    const tip_title = "颜色对照表";
    rl.drawTextEx(font, tip_title, .{ .x = x, .y = y }, TIP_TEXT_SIZE, KEY_TEXT_SPACING, .black);
    var text_rect = rl.measureTextEx(font, tip_title, TIP_TEXT_SIZE, KEY_TEXT_SPACING);
    x += text_rect.x + 16;

    const down_color_text = "按住颜色";
    drawHintText(down_color_text, KEY_PRESSED_COLOR, x, y);
    text_rect = rl.measureTextEx(font, down_color_text, TIP_TEXT_SIZE, KEY_TEXT_SPACING);
    x += text_rect.x + 40;

    for (KEY_COUNTER_COLORS, 0..) |color, index| {
        var buf: [128]u8 = undefined;
        var text: [:0]const u8 = undefined;
        if (index == 0) {
            text = "默认颜色";
        } else if (index >= KEY_COUNTER_COLORS.len - 1) {
            text = try std.fmt.bufPrintZ(&buf, "大于{}次", .{index - 1});
        } else {
            text = try std.fmt.bufPrintZ(&buf, "按{}次", .{index});
        }
        drawHintText(text, color, x, y);
        text_rect = rl.measureTextEx(font, text, TIP_TEXT_SIZE, KEY_TEXT_SPACING);
        x += text_rect.x + 40;
    }

    // 绘制按键
    for (&KEYBOARD_LAYOUT) |*key| {
        drawKey(key, keyboard_x, keyboard_y);
    }
}

// 绘制提示文本
fn drawHintText(text: [:0]const u8, color: rl.Color, x: f32, y: f32) void {
    rl.drawRectangleRounded(.{ .x = x, .y = y, .width = 24, .height = 24 }, 0.1, 4, color);
    rl.drawTextEx(font, text, .{ .x = x + 30, .y = y }, TIP_TEXT_SIZE, KEY_TEXT_SPACING, .black);
}

// 绘制按键
fn drawKey(key: *Key, keyboard_x: f32, keyboard_y: f32) void {
    // 按键检测
    if (rl.isKeyPressed(key.key_code)) {
        key.is_pressed = true;
    }
    if (rl.isKeyReleased(key.key_code)) {
        key.is_pressed = false;
        key.counter += 1;
        if (key.counter >= KEY_COUNTER_COLORS.len - 1) {
            key.counter = KEY_COUNTER_COLORS.len - 1;
        }
    }

    // 计算屏幕空间中的按键位置和大小
    const screen_key_x = keyboard_x + key.x;
    const screen_key_y = keyboard_y + key.y;
    const screen_key_width = key.width;
    const screen_key_height = key.height;

    // 按键颜色
    const key_color = if (key.is_pressed) KEY_PRESSED_COLOR else KEY_COUNTER_COLORS[key.counter];

    // 绘制按键背景
    rl.drawRectangleRounded(.{
        .x = screen_key_x,
        .y = screen_key_y,
        .width = screen_key_width,
        .height = screen_key_height,
    }, 0.2, 4, key_color);

    // 计算适合当前缩放的文字大小
    const text_size = @max(10.0, KEY_TEXT_SIZE);

    // 测量文本
    const text_rect = rl.measureTextEx(font, key.text, text_size, KEY_TEXT_SPACING);

    // 计算文本位置
    const text_pos_x = screen_key_x + (screen_key_width - text_rect.x) / 2;
    const is_multiline = std.mem.containsAtLeast(u8, key.text, 1, "\n");
    const text_pos_y = if (is_multiline)
        screen_key_y + (screen_key_height - text_size * 1.8) / 2
    else
        screen_key_y + (screen_key_height - text_size) / 2;

    // 文本位置对齐到像素边界
    const aligned_text_pos_x = @floor(text_pos_x);
    const aligned_text_pos_y = @floor(text_pos_y);

    // 绘制文本
    rl.drawTextEx(font, key.text, .{ .x = aligned_text_pos_x, .y = aligned_text_pos_y }, text_size, KEY_TEXT_SPACING, .white);
}
