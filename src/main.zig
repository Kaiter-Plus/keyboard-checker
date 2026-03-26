const std = @import("std");
const rl = @import("raylib");

// ============ 窗口与布局常量 ============
const INITIAL_WIDTH = 1600;
const INITIAL_HEIGHT = 900;

const VIRTUAL_WIDTH: f32 = 1920;
const VIRTUAL_HEIGHT: f32 = 1080;

const KEYBOARD_WIDTH: f32 = 1630;
const KEYBOARD_HEIGHT: f32 = 470;
const KEYBOARD_OFFSET_Y: f32 = 170; // 键盘顶部距虚拟窗口顶部的距离

const TIP_TEXT_SIZE: f32 = 24;
const KEY_TEXT_SIZE: f32 = 18;
const KEY_TEXT_SPACING: f32 = 1.5;

// ============ 配色 ============
const BG_COLOR = rl.Color{ .r = 0x1E, .g = 0x20, .b = 0x26, .a = 0xFF };
const KEYBOARD_BG_COLOR = rl.Color{ .r = 0x2A, .g = 0x2D, .b = 0x35, .a = 0xFF };
const RESET_BTN_COLOR = rl.Color{ .r = 0x60, .g = 0xA5, .b = 0xFA, .a = 0xFF };
const KEY_PRESSED_COLOR = rl.Color{ .r = 0x60, .g = 0xA5, .b = 0xFA, .a = 0xFF };
const KEY_TEXT_LIGHT = rl.Color{ .r = 0xD1, .g = 0xD5, .b = 0xDB, .a = 0xFF };

const KEY_COUNTER_COLORS = [_]rl.Color{
    .{ .r = 0x3C, .g = 0x40, .b = 0x48, .a = 0xFF }, // 默认：炭灰
    .{ .r = 0x81, .g = 0x8C, .b = 0xF8, .a = 0xFF }, // 1次：紫罗兰
    .{ .r = 0xF4, .g = 0x72, .b = 0xB6, .a = 0xFF }, // 2次：粉红
    .{ .r = 0xFB, .g = 0x92, .b = 0x3C, .a = 0xFF }, // 3次：橙色
    .{ .r = 0xEF, .g = 0x44, .b = 0x44, .a = 0xFF }, // 4次+：红色
};

const MAX_COUNTER: u32 = KEY_COUNTER_COLORS.len - 1;

// ============ 按键结构 ============
const Key = struct {
    x: f32,
    y: f32,
    width: f32 = 60,
    height: f32 = 60,
    counter: u32 = 0,
    text: [:0]const u8,
    key_code: rl.KeyboardKey,
    is_pressed: bool = false,

    fn reset(self: *Key) void {
        self.counter = 0;
        self.is_pressed = false;
    }
};

// ============ 键盘布局 ============
var KEYBOARD_LAYOUT = [_]Key{
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
    // ── 第二行 ──
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
    .{ .x = 1400, .y = 100, .text = "/", .key_code = .kp_divide },
    .{ .x = 1470, .y = 100, .text = "*", .key_code = .kp_multiply },
    .{ .x = 1540, .y = 100, .text = "-", .key_code = .kp_subtract },
    // ── 第三行 ──
    .{ .x = 30, .y = 170, .width = 95, .text = "Tab", .key_code = .tab },
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
    .{ .x = 1330, .y = 170, .text = "7", .key_code = .kp_7 },
    .{ .x = 1400, .y = 170, .text = "8", .key_code = .kp_8 },
    .{ .x = 1470, .y = 170, .text = "9", .key_code = .kp_9 },
    .{ .x = 1540, .y = 170, .height = 130, .text = "+", .key_code = .kp_add },
    // ── 第四行 ──
    .{ .x = 30, .y = 240, .width = 125, .text = "CapsLock", .key_code = .caps_lock },
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
    .{ .x = 935, .y = 240, .width = 135, .text = "Enter", .key_code = .enter },
    .{ .x = 1330, .y = 240, .text = "4", .key_code = .kp_4 },
    .{ .x = 1400, .y = 240, .text = "5", .key_code = .kp_5 },
    .{ .x = 1470, .y = 240, .text = "6", .key_code = .kp_6 },
    // ── 第五行 ──
    .{ .x = 30, .y = 310, .width = 150, .text = "Shift", .key_code = .left_shift },
    .{ .x = 190, .y = 310, .text = "Z", .key_code = .z },
    .{ .x = 260, .y = 310, .text = "X", .key_code = .x },
    .{ .x = 330, .y = 310, .text = "C", .key_code = .c },
    .{ .x = 400, .y = 310, .text = "V", .key_code = .v },
    .{ .x = 470, .y = 310, .text = "B", .key_code = .b },
    .{ .x = 540, .y = 310, .text = "N", .key_code = .n },
    .{ .x = 610, .y = 310, .text = "M", .key_code = .m },
    .{ .x = 680, .y = 310, .text = "<\n,", .key_code = .comma },
    .{ .x = 750, .y = 310, .text = ">\n.", .key_code = .period },
    .{ .x = 820, .y = 310, .text = "?\n/", .key_code = .slash },
    .{ .x = 890, .y = 310, .width = 180, .text = "Shift", .key_code = .right_shift },
    .{ .x = 1170, .y = 310, .text = "↑", .key_code = .up },
    .{ .x = 1330, .y = 310, .text = "1", .key_code = .kp_1 },
    .{ .x = 1400, .y = 310, .text = "2", .key_code = .kp_2 },
    .{ .x = 1470, .y = 310, .text = "3", .key_code = .kp_3 },
    .{ .x = 1540, .y = 310, .height = 130, .text = "Enter", .key_code = .kp_enter },
    // ── 第六行 ──
    .{ .x = 30, .y = 380, .text = "Ctrl", .key_code = .left_control },
    .{ .x = 100, .y = 380, .text = "Win", .key_code = .left_super },
    .{ .x = 170, .y = 380, .text = "Alt", .key_code = .left_alt },
    .{ .x = 240, .y = 380, .width = 620, .text = "Space", .key_code = .space },
    .{ .x = 870, .y = 380, .text = "Alt", .key_code = .right_alt },
    .{ .x = 940, .y = 380, .text = "Win", .key_code = .right_super },
    .{ .x = 1010, .y = 380, .text = "Ctrl", .key_code = .right_control },
    .{ .x = 1100, .y = 380, .text = "←", .key_code = .left },
    .{ .x = 1170, .y = 380, .text = "↓", .key_code = .down },
    .{ .x = 1240, .y = 380, .text = "→", .key_code = .right },
    .{ .x = 1330, .y = 380, .width = 130, .text = "0\nIns", .key_code = .kp_0 },
    .{ .x = 1470, .y = 380, .text = ".\nDel", .key_code = .kp_decimal },
};

// ============ 字体 ============
var font: rl.Font = undefined;

const FONT_CHARS: []const i32 = &.{
    'a',   'b',   'c',   'd',   'e',   'f',   'g',   'h',   'i',   'j',   'k',   'l',   'm',
    'n',   'o',   'p',   'q',   'r',   's',   't',   'u',   'v',   'w',   'x',   'y',   'z',
    'A',   'B',   'C',   'D',   'E',   'F',   'G',   'H',   'I',   'J',   'K',   'L',   'M',
    'N',   'O',   'P',   'Q',   'R',   'S',   'T',   'U',   'V',   'W',   'X',   'Y',   'Z',
    '0',   '1',   '2',   '3',   '4',   '5',   '6',   '7',   '8',   '9',   '~',   '`',   '!',
    '@',   '#',   '$',   '%',   '^',   '&',   '*',   '(',   ')',   '-',   '_',   '=',   '+',
    '[',   '{',   ']',   '}',   '\\',  '|',   ';',   ':',   '\'',  '"',   ',',   '<',   '.',
    '>',   '/',   '?',   '↑', '↓', '→', '←', '颜', '色', '对', '照', '表', '按',
    '住', '默', '认', '次', '大', '于', '重', '置',
};

const RESET_BTN_TEXT = "重置";

// ============ 主函数 ============
pub fn main() anyerror!void {
    rl.setConfigFlags(.{ .window_resizable = true, .window_highdpi = true });
    rl.setTraceLogLevel(.warning);

    rl.initWindow(INITIAL_WIDTH, INITIAL_HEIGHT, "键盘检测器");
    defer rl.closeWindow();

    rl.setExitKey(.null);
    rl.setTargetFPS(60);

    font = try rl.loadFontEx("./assets/fonts/HarmonyOS_SansSC_Regular.ttf", 256, FONT_CHARS);
    defer rl.unloadFont(font);
    rl.setTextureFilter(font.texture, .bilinear);

    var camera: rl.Camera2D = .{ .target = .{ .x = 0, .y = 0 }, .offset = .{ .x = 0, .y = 0 }, .rotation = 0, .zoom = 1 };

    // 重置按钮
    const reset_btn = rl.Rectangle{
        .x = (VIRTUAL_WIDTH - 100) / 2,
        .y = VIRTUAL_HEIGHT - 220,
        .width = 100,
        .height = 50,
    };

    // 主循环
    while (!rl.windowShouldClose()) {
        const screen_w = @as(f32, @floatFromInt(rl.getScreenWidth()));
        const screen_h = @as(f32, @floatFromInt(rl.getScreenHeight()));

        const scale = @min(screen_w / VIRTUAL_WIDTH, screen_h / VIRTUAL_HEIGHT);
        camera.zoom = scale;
        camera.offset = .{
            .x = (screen_w - VIRTUAL_WIDTH * scale) / 2,
            .y = (screen_h - VIRTUAL_HEIGHT * scale) / 2,
        };

        // 鼠标点击检测
        if (rl.isMouseButtonPressed(.left)) {
            const mp = rl.getMousePosition();
            const vp = rl.Vector2{ .x = (mp.x - camera.offset.x) / scale, .y = (mp.y - camera.offset.y) / scale };
            if (rl.checkCollisionPointRec(vp, reset_btn)) {
                for (&KEYBOARD_LAYOUT) |*k| k.reset();
            }
        }

        rl.beginDrawing();
        defer rl.endDrawing();
        rl.beginMode2D(camera);
        defer rl.endMode2D();

        rl.clearBackground(BG_COLOR);

        // 重置按钮
        rl.drawRectangleRounded(reset_btn, 0.1, 50, RESET_BTN_COLOR);
        const btn_text_rect = rl.measureTextEx(font, RESET_BTN_TEXT, TIP_TEXT_SIZE, KEY_TEXT_SPACING);
        rl.drawTextEx(
            font,
            RESET_BTN_TEXT,
            .{ .x = reset_btn.x + (reset_btn.width - btn_text_rect.x) / 2, .y = reset_btn.y + (reset_btn.height - btn_text_rect.y) / 2 },
            TIP_TEXT_SIZE,
            KEY_TEXT_SPACING,
            .white,
        );

        // 绘制键盘
        drawKeyboard();
    }
}

// ============ 绘制函数 ============
fn drawKeyboard() void {
    const kx = (VIRTUAL_WIDTH - KEYBOARD_WIDTH) / 2;
    const ky = (VIRTUAL_HEIGHT - KEYBOARD_HEIGHT) / 2;

    rl.drawRectangleRounded(.{ .x = kx, .y = ky, .width = KEYBOARD_WIDTH, .height = KEYBOARD_HEIGHT }, 0.1, 4, KEYBOARD_BG_COLOR);

    // 颜色对照表
    var tx = kx;
    const ty = ky - TIP_TEXT_SIZE - 10;

    rl.drawTextEx(font, "颜色对照表", .{ .x = tx, .y = ty }, TIP_TEXT_SIZE, KEY_TEXT_SPACING, .white);
    tx += rl.measureTextEx(font, "颜色对照表", TIP_TEXT_SIZE, KEY_TEXT_SPACING).x + 16;

    drawHint("按住颜色", KEY_PRESSED_COLOR, tx, ty);
    tx += rl.measureTextEx(font, "按住颜色", TIP_TEXT_SIZE, KEY_TEXT_SPACING).x + 40;

    for (KEY_COUNTER_COLORS, 0..) |color, i| {
        const label = switch (i) {
            0 => "默认颜色",
            KEY_COUNTER_COLORS.len - 1 => blk: {
                var buf: [16]u8 = undefined;
                break :blk std.fmt.bufPrintZ(&buf, "大于{}次", .{i - 1}) catch "";
            },
            else => blk: {
                var buf: [16]u8 = undefined;
                break :blk std.fmt.bufPrintZ(&buf, "按{}次", .{i}) catch "";
            },
        };
        drawHint(label, color, tx, ty);
        tx += rl.measureTextEx(font, label, TIP_TEXT_SIZE, KEY_TEXT_SPACING).x + 40;
    }

    // 绘制所有按键
    for (&KEYBOARD_LAYOUT) |*key| {
        drawKey(key, kx, ky);
    }
}

fn drawHint(label: [:0]const u8, color: rl.Color, x: f32, y: f32) void {
    rl.drawRectangleRounded(.{ .x = x, .y = y, .width = 24, .height = 24 }, 0.1, 4, color);
    rl.drawTextEx(font, label, .{ .x = x + 30, .y = y }, TIP_TEXT_SIZE, KEY_TEXT_SPACING, .white);
}

fn drawKey(key: *Key, kx: f32, ky: f32) void {
    // 状态更新
    if (key.key_code != .null) {
        if (rl.isKeyPressed(key.key_code)) key.is_pressed = true;
        if (rl.isKeyReleased(key.key_code)) {
            key.is_pressed = false;
            key.counter = @min(key.counter + 1, MAX_COUNTER);
        }
    }

    const sx = kx + key.x;
    const sy = ky + key.y;
    const key_color = if (key.is_pressed) KEY_PRESSED_COLOR else KEY_COUNTER_COLORS[key.counter];

    rl.drawRectangleRounded(.{ .x = sx, .y = sy, .width = key.width, .height = key.height }, 0.2, 4, key_color);

    const text_rect = rl.measureTextEx(font, key.text, KEY_TEXT_SIZE, KEY_TEXT_SPACING);
    const text_x = sx + (key.width - text_rect.x) / 2;
    const multiline = std.mem.containsAtLeast(u8, key.text, 1, "\n");
    const text_y = sy + (key.height - (if (multiline) KEY_TEXT_SIZE * 1.8 else KEY_TEXT_SIZE)) / 2;

    const text_color: rl.Color = if (key.counter == 0 and !key.is_pressed) KEY_TEXT_LIGHT else .white;
    rl.drawTextEx(font, key.text, .{ .x = @floor(text_x), .y = @floor(text_y) }, KEY_TEXT_SIZE, KEY_TEXT_SPACING, text_color);
}
