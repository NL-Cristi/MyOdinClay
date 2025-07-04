package main

import clay "clay-odin"
import "core:c"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

windowWidth: i32 = 1024
windowHeight: i32 = 768

// Font IDs
FONT_ID_BODY_16 :: 0
FONT_ID_BODY_24 :: 1
FONT_ID_BODY_28 :: 2

// Colors
COLOR_LIGHT :: clay.Color{244, 235, 230, 255}
COLOR_LIGHT_HOVER :: clay.Color{224, 215, 210, 255}
COLOR_BROWN :: clay.Color{61, 26, 5, 255}
COLOR_RED :: clay.Color{168, 66, 28, 255}
COLOR_RED_HOVER :: clay.Color{148, 46, 8, 255}
COLOR_ORANGE :: clay.Color{225, 138, 50, 255}

// Text configurations
headerTextConfig := clay.TextElementConfig {
    fontId    = FONT_ID_BODY_24,
    fontSize  = 24,
    textColor = COLOR_BROWN,
}

menuItemConfig := clay.TextElementConfig {
    fontId    = FONT_ID_BODY_16,
    fontSize  = 16,
    textColor = COLOR_BROWN,
}

tableHeaderConfig := clay.TextElementConfig {
    fontId    = FONT_ID_BODY_16,
    fontSize  = 16,
    textColor = COLOR_LIGHT,
}

tableItemConfig := clay.TextElementConfig {
    fontId    = FONT_ID_BODY_16,
    fontSize  = 16,
    textColor = COLOR_BROWN,
}

// Border styles
border1pxRed := clay.BorderElementConfig {
    width = {1, 1, 1, 1, 0},
    color = COLOR_RED,
}

// Filter structure
Filter :: struct {
    enabled:        bool,
    excluding:      bool,
    description:    string,
    backColor:      string,
    foreColor:      string,
    type:           string,
    case_sensitive: bool,
    regex:          bool,
    text:           string,
    hits:           int,
    letter:         string,
}

// Sample filters data
allFilters := [26]Filter {
    {
        enabled = true,
        excluding = false,
        description = "Filter A",
        backColor = "Purple",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "apple",
        hits = 5,
        letter = "a",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter B",
        backColor = "Red",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "brown",
        hits = 3,
        letter = "b",
    },
    {
        enabled = false,
        excluding = true,
        description = "Filter C",
        backColor = "Blue",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = true,
        regex = false,
        text = "cat",
        hits = 7,
        letter = "c",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter D",
        backColor = "Green",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "dog",
        hits = 9,
        letter = "d",
    },
    {
        enabled = false,
        excluding = false,
        description = "Filter E",
        backColor = "Yellow",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "elephant",
        hits = 2,
        letter = "e",
    },
    {
        enabled = true,
        excluding = true,
        description = "Filter F",
        backColor = "Orange",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = true,
        regex = false,
        text = "fox",
        hits = 4,
        letter = "f",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter G",
        backColor = "Purple",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "grape",
        hits = 6,
        letter = "g",
    },
    {
        enabled = false,
        excluding = false,
        description = "Filter H",
        backColor = "Red",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "horse",
        hits = 8,
        letter = "h",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter I",
        backColor = "Blue",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = true,
        regex = false,
        text = "ice",
        hits = 1,
        letter = "i",
    },
    {
        enabled = false,
        excluding = true,
        description = "Filter J",
        backColor = "Green",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "jacket",
        hits = 3,
        letter = "j",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter K",
        backColor = "Yellow",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "kite",
        hits = 5,
        letter = "k",
    },
    {
        enabled = false,
        excluding = false,
        description = "Filter L",
        backColor = "Orange",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = true,
        regex = false,
        text = "lion",
        hits = 7,
        letter = "l",
    },
    {
        enabled = true,
        excluding = true,
        description = "Filter M",
        backColor = "Purple",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "mouse",
        hits = 9,
        letter = "m",
    },
    {
        enabled = false,
        excluding = false,
        description = "Filter N",
        backColor = "Red",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "notebook",
        hits = 2,
        letter = "n",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter O",
        backColor = "Blue",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = true,
        regex = false,
        text = "orange",
        hits = 4,
        letter = "o",
    },
    {
        enabled = false,
        excluding = true,
        description = "Filter P",
        backColor = "Green",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "pencil",
        hits = 6,
        letter = "p",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter Q",
        backColor = "Yellow",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "queen",
        hits = 8,
        letter = "q",
    },
    {
        enabled = false,
        excluding = false,
        description = "Filter R",
        backColor = "Orange",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = true,
        regex = false,
        text = "rabbit",
        hits = 1,
        letter = "r",
    },
    {
        enabled = true,
        excluding = true,
        description = "Filter S",
        backColor = "Purple",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "snake",
        hits = 3,
        letter = "s",
    },
    {
        enabled = false,
        excluding = false,
        description = "Filter T",
        backColor = "Red",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "tiger",
        hits = 5,
        letter = "t",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter U",
        backColor = "Blue",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = true,
        regex = false,
        text = "umbrella",
        hits = 7,
        letter = "u",
    },
    {
        enabled = false,
        excluding = true,
        description = "Filter V",
        backColor = "Green",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "violin",
        hits = 9,
        letter = "v",
    },
    {
        enabled = true,
        excluding = false,
        description = "Filter W",
        backColor = "Yellow",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "window",
        hits = 2,
        letter = "w",
    },
    {
        enabled = false,
        excluding = false,
        description = "Filter X",
        backColor = "Orange",
        foreColor = "Black",
        type = "matches_text",
        case_sensitive = true,
        regex = false,
        text = "xylophone",
        hits = 4,
        letter = "x",
    },
    {
        enabled = true,
        excluding = true,
        description = "Filter Y",
        backColor = "Purple",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "yellow",
        hits = 6,
        letter = "y",
    },
    {
        enabled = false,
        excluding = false,
        description = "Filter Z",
        backColor = "Red",
        foreColor = "White",
        type = "matches_text",
        case_sensitive = false,
        regex = false,
        text = "zebra",
        hits = 8,
        letter = "z",
    },
}

// Define a global variable for the active renderer index
ACTIVE_RENDERER_INDEX: u32 = 0

// Global variable to track which menu is open
OPEN_MENU: string = ""

// Keep the original menu_item_clicked function
menu_item_clicked :: proc(category: string, item: string) {
    fmt.printf("You clicked on %s-%s\n", category, item)

    // Parse the item string to an integer - handle properly in Odin
    index, ok := strconv.parse_int(item, 10)
    if ok {
        ACTIVE_RENDERER_INDEX = u32(index - 1) // Adjust for 1-based menu items
        clay.SetCullingEnabled(ACTIVE_RENDERER_INDEX == 1)
        // clay.SetExternalScrollHandlingEnabled(ACTIVE_RENDERER_INDEX == 0)  // Uncomment if available
    }
}

// Handler for hover callback - don't call this directly
handle_renderer_button_interaction :: proc "c" (element_id: clay.ElementId, pointer_info: clay.PointerData, user_data: rawptr) {
    if pointer_info.state == .PressedThisFrame {
        ACTIVE_RENDERER_INDEX = u32(uintptr(user_data))
        clay.SetCullingEnabled(ACTIVE_RENDERER_INDEX == 1)
        // clay.SetExternalScrollHandlingEnabled(ACTIVE_RENDERER_INDEX == 0)  // Uncomment if available
    }
}

// Modified MenuItem procedure
MenuItem :: proc(category: string, index: int) {
    item_text := fmt.tprintf("%s-%d", category, index + 1)

    if clay.UI()(
    {
        id = clay.ID(fmt.tprintf("MenuItem_%s_%d", category, index)),
        layout = {sizing = {width = clay.SizingGrow({})}, padding = clay.PaddingAll(8)},
        backgroundColor = clay.Hovered() ? COLOR_LIGHT_HOVER : COLOR_LIGHT,
    },
    ) {
        clay.TextDynamic(item_text, clay.TextConfig(menuItemConfig))

        // Register the hover callback
        clay.OnHover(handle_renderer_button_interaction, rawptr(uintptr(index)))

        // Use the original click handler
        if clay.Hovered() && rl.IsMouseButtonPressed(.LEFT) {
            menu_item_clicked(category, fmt.tprintf("%d", index + 1))
        }
    }
}
// Menu dropdown container
MenuDropdown :: proc(category: string) {
    if clay.UI()(
    {
        id = clay.ID(fmt.tprintf("MenuDropdown_%s", category)),
        layout = {layoutDirection = .TopToBottom, sizing = {width = clay.SizingFixed(200)}, childGap = 1},
        backgroundColor = COLOR_LIGHT,
        border = border1pxRed,
        cornerRadius = clay.CornerRadiusAll(4),
    },
    ) {
        for i in 0 ..< 5 {
            MenuItem(category, i)
        }
    }
}

// Menu bar item that shows dropdown when clicked
MenuBarItem :: proc(category: string, index: int, open_menu: ^string) {
    if clay.UI()(
    {
        id = clay.ID(fmt.tprintf("MenuBarItem_%s", category)),
        layout = {sizing = {width = clay.SizingGrow({max = 120})}, padding = {16, 16, 8, 8}},
        backgroundColor = clay.Hovered() || open_menu^ == category ? COLOR_LIGHT_HOVER : COLOR_LIGHT,
    },
    ) {
        clay.TextDynamic(category, clay.TextConfig(headerTextConfig))

        // Handle clicks to open/close the menu
        if clay.Hovered() && rl.IsMouseButtonPressed(.LEFT) {
            if open_menu^ == category {
                open_menu^ = ""
            } else {
                open_menu^ = category
            }
        }

        // Show dropdown if this menu is open
        if open_menu^ == category {
            if clay.UI()(
            {
                id = clay.ID(fmt.tprintf("MenuDropdownContainer_%s", category)),
                layout = {sizing = {width = clay.SizingFixed(200)}, layoutDirection = .TopToBottom},
                floating = {
                    offset = {0, 40},
                    attachment = {.LeftTop, .LeftTop},
                    attachTo = .ElementWithId,
                    parentId = clay.ID(fmt.tprintf("MenuBarItem_%s", category)).id,
                    zIndex = 100,
                },
            },
            ) {
                MenuDropdown(category)
            }
        }
    }
}

// Main menu bar
MenuBar :: proc(open_menu: ^string) {
    categories := []string{"File", "Edit", "View", "Filters", "Help"}

    if clay.UI()(
    {
        id = clay.ID("MenuBar"),
        layout = {sizing = {width = clay.SizingGrow({})}, padding = {0, 0, 0, 0}, childGap = 1},
        backgroundColor = COLOR_LIGHT,
        border = {COLOR_RED, {0, 0, 0, 1, 0}},
    },
    ) {
        for category, i in categories {
            MenuBarItem(category, i, open_menu)
        }
    }
}

// Text scroll container
TextScrollContainer :: proc() {
    if clay.UI()(
    {
        id = clay.ID("TextScrollContainer"),
        layout = {layoutDirection = .TopToBottom, sizing = {width = clay.SizingGrow({}), height = clay.SizingGrow({min = 250})}, padding = clay.PaddingAll(10), childGap = 4},
        clip = {vertical = true, childOffset = clay.GetScrollOffset()},
        backgroundColor = COLOR_LIGHT,
        border = border1pxRed,
    },
    ) {
        for i in 1 ..= 200 {
            row_text := fmt.tprintf("This is row %d", i)
            if clay.UI()(
            {
                id = clay.ID("TextRow", u32(i)),
                layout = {sizing = {width = clay.SizingGrow({})}, padding = {5, 5, 2, 2}},
                backgroundColor = i % 2 == 0 ? COLOR_LIGHT_HOVER : COLOR_LIGHT,
            },
            ) {
                clay.TextDynamic(row_text, clay.TextConfig(menuItemConfig))
            }
        }
    }
}

// Filter table header
FilterTableHeader :: proc() {
    if clay.UI()({id = clay.ID("FilterTableHeader"), layout = {sizing = {width = clay.SizingGrow({})}, padding = clay.PaddingAll(5)}, backgroundColor = COLOR_RED}) {
        // Column headers
        if clay.UI()({id = clay.ID("EnabledHeader"), layout = {sizing = {width = clay.SizingFixed(80)}}}) {
            clay.Text("Enabled", clay.TextConfig({fontId = FONT_ID_BODY_16, fontSize = 16, textColor = COLOR_LIGHT}))
        }
        if clay.UI()({id = clay.ID("DescriptionHeader"), layout = {sizing = {width = clay.SizingGrow({})}}}) {
            clay.Text("Description", clay.TextConfig({fontId = FONT_ID_BODY_16, fontSize = 16, textColor = COLOR_LIGHT}))
        }
        if clay.UI()({id = clay.ID("BackColorHeader"), layout = {sizing = {width = clay.SizingFixed(100)}}}) {
            clay.Text("BackColor", clay.TextConfig({fontId = FONT_ID_BODY_16, fontSize = 16, textColor = COLOR_LIGHT}))
        }
        if clay.UI()({id = clay.ID("ForeColorHeader"), layout = {sizing = {width = clay.SizingFixed(100)}}}) {
            clay.Text("ForeColor", clay.TextConfig({fontId = FONT_ID_BODY_16, fontSize = 16, textColor = COLOR_LIGHT}))
        }
        if clay.UI()({id = clay.ID("TextHeader"), layout = {sizing = {width = clay.SizingFixed(100)}}}) {
            clay.Text("Text", clay.TextConfig({fontId = FONT_ID_BODY_16, fontSize = 16, textColor = COLOR_LIGHT}))
        }
        if clay.UI()({id = clay.ID("HitsHeader"), layout = {sizing = {width = clay.SizingFixed(60)}}}) {
            clay.Text("Hits", clay.TextConfig({fontId = FONT_ID_BODY_16, fontSize = 16, textColor = COLOR_LIGHT}))
        }
        if clay.UI()({id = clay.ID("LetterHeader"), layout = {sizing = {width = clay.SizingFixed(60)}}}) {
            clay.Text("Letter", clay.TextConfig({fontId = FONT_ID_BODY_16, fontSize = 16, textColor = COLOR_LIGHT}))
        }
    }
}

// Filter row
FilterRow :: proc(filter: Filter, index: int) {
    bg_color := index % 2 == 0 ? COLOR_LIGHT_HOVER : COLOR_LIGHT

    if clay.UI()({id = clay.ID("FilterRow", u32(index)), layout = {sizing = {width = clay.SizingGrow({})}, padding = clay.PaddingAll(5)}, backgroundColor = bg_color}) {
        // Enabled column
        if clay.UI()({id = clay.ID("EnabledCell", u32(index)), layout = {sizing = {width = clay.SizingFixed(80)}}}) {
            clay.TextDynamic(filter.enabled ? "Yes" : "No", clay.TextConfig(tableItemConfig))
        }
        // Description column
        if clay.UI()({id = clay.ID("DescriptionCell", u32(index)), layout = {sizing = {width = clay.SizingGrow({})}}}) {
            clay.TextDynamic(filter.description, clay.TextConfig(tableItemConfig))
        }
        // BackColor column
        if clay.UI()({id = clay.ID("BackColorCell", u32(index)), layout = {sizing = {width = clay.SizingFixed(100)}}}) {
            clay.TextDynamic(filter.backColor, clay.TextConfig(tableItemConfig))
        }
        // ForeColor column
        if clay.UI()({id = clay.ID("ForeColorCell", u32(index)), layout = {sizing = {width = clay.SizingFixed(100)}}}) {
            clay.TextDynamic(filter.foreColor, clay.TextConfig(tableItemConfig))
        }
        // Text column
        if clay.UI()({id = clay.ID("TextCell", u32(index)), layout = {sizing = {width = clay.SizingFixed(100)}}}) {
            clay.TextDynamic(filter.text, clay.TextConfig(tableItemConfig))
        }
        // Hits column
        if clay.UI()({id = clay.ID("HitsCell", u32(index)), layout = {sizing = {width = clay.SizingFixed(60)}}}) {
            clay.TextDynamic(fmt.tprintf("%d", filter.hits), clay.TextConfig(tableItemConfig))
        }
        // Letter column
        if clay.UI()({id = clay.ID("LetterCell", u32(index)), layout = {sizing = {width = clay.SizingFixed(60)}}}) {
            clay.TextDynamic(filter.letter, clay.TextConfig(tableItemConfig))
        }
    }
}

// Filter scroll container
FilterScrollContainer :: proc() {
    if clay.UI()(
    {
        id = clay.ID("FilterScrollContainer"),
        layout = {layoutDirection = .TopToBottom, sizing = {width = clay.SizingGrow({}), height = clay.SizingGrow({min = 300})}, padding = clay.PaddingAll(10), childGap = 0},
        backgroundColor = COLOR_LIGHT,
        border = border1pxRed,
    },
    ) {
        FilterTableHeader()

        if clay.UI()(
        {
            id = clay.ID("FilterTableBody"),
            layout = {layoutDirection = .TopToBottom, sizing = {width = clay.SizingGrow({}), height = clay.SizingGrow({})}, childGap = 0},
            clip = {vertical = true, childOffset = clay.GetScrollOffset()},
        },
        ) {
            for filter, i in allFilters {
                FilterRow(filter, i)
            }
        }
    }
}

// Main layout
createLayout :: proc() -> clay.ClayArray(clay.RenderCommand) {
    clay.BeginLayout()

    if clay.UI()(
    {id = clay.ID("MainContainer"), layout = {layoutDirection = .TopToBottom, sizing = {clay.SizingGrow({}), clay.SizingGrow({})}, childGap = 2}, backgroundColor = COLOR_LIGHT},
    ) {
        // Menu bar at top
        MenuBar(&OPEN_MENU)

        // Text scroll container (200 rows)
        TextScrollContainer()

        // Filter scroll container
        FilterScrollContainer()
    }

    return clay.EndLayout()
}

// Helper function to load fonts
loadFont :: proc(fontId: u16, fontSize: u16, path: cstring) {
    append(&raylib_fonts, Raylib_Font{font = rl.LoadFontEx(path, cast(i32)fontSize * 2, nil, 0), fontId = cast(u16)fontId})
    rl.SetTextureFilter(raylib_fonts[len(raylib_fonts) - 1].font.texture, rl.TextureFilter.TRILINEAR)
}

// The main function
main :: proc() {
    minMemorySize: c.size_t = cast(c.size_t)clay.MinMemorySize()
    memory := make([^]u8, minMemorySize)
    arena: clay.Arena = clay.CreateArenaWithCapacityAndMemory(minMemorySize, memory)
    clay.Initialize(arena, {cast(f32)rl.GetScreenWidth(), cast(f32)rl.GetScreenHeight()}, {})
    clay.SetMeasureTextFunction(measure_text, nil)

    rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE, .MSAA_4X_HINT})
    rl.InitWindow(windowWidth, windowHeight, "Menu Example")
    rl.SetTargetFPS(rl.GetMonitorRefreshRate(0))

    // Load fonts
    loadFont(FONT_ID_BODY_16, 16, "resources/Quicksand-Semibold.ttf")
    loadFont(FONT_ID_BODY_24, 24, "resources/Quicksand-Semibold.ttf")
    loadFont(FONT_ID_BODY_28, 28, "resources/Quicksand-Semibold.ttf")

    debugModeEnabled: bool = false

    for !rl.WindowShouldClose() {
        defer free_all(context.temp_allocator)

        windowWidth = rl.GetScreenWidth()
        windowHeight = rl.GetScreenHeight()

        if rl.IsKeyPressed(.D) {
            debugModeEnabled = !debugModeEnabled
            clay.SetDebugModeEnabled(debugModeEnabled)
        }

        clay.SetPointerState(transmute(clay.Vector2)rl.GetMousePosition(), rl.IsMouseButtonDown(rl.MouseButton.LEFT))
        clay.UpdateScrollContainers(false, transmute(clay.Vector2)rl.GetMouseWheelMoveV(), rl.GetFrameTime())
        clay.SetLayoutDimensions({cast(f32)rl.GetScreenWidth(), cast(f32)rl.GetScreenHeight()})

        renderCommands: clay.ClayArray(clay.RenderCommand) = createLayout()

        rl.BeginDrawing()
        rl.ClearBackground(rl.GetColor(0xf4ebe6ff))
        clay_raylib_render(&renderCommands)
        rl.EndDrawing()
    }
}

