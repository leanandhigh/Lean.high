    local InputService, HttpService, GuiService, RunService, Stats, CoreGui, TweenService, SoundService, Workspace, Players, Lighting = game:GetService("UserInputService"), game:GetService("HttpService"), game:GetService("GuiService"), game:GetService("RunService"), game:GetService("Stats"), game:GetService("CoreGui"), game:GetService("TweenService"), game:GetService("SoundService"), game:GetService("Workspace"), game:GetService("Players"), game:GetService("Lighting")
    local Camera, LocalPlayer, gui_offset = Workspace.CurrentCamera, Players.LocalPlayer, GuiService:GetGuiInset().Y
    local Mouse = LocalPlayer:GetMouse()
    local vec2, vec3, dim2, dim, rect, dim_offset = Vector2.new, Vector3.new, UDim2.new, UDim.new, Rect.new, UDim2.fromOffset
    local color, rgb, hex, hsv, rgbseq, rgbkey, numseq, numkey = Color3.new, Color3.fromRGB, Color3.fromHex, Color3.fromHSV, ColorSequence.new, ColorSequenceKeypoint.new, NumberSequence.new, NumberSequenceKeypoint.new
    local angle, empty_cfr, cfr = CFrame.Angles, CFrame.new(), CFrame.new

    getgenv().Library = {
        Directory = "Lean",
        Folders = {
            "/fonts",
            "/configs",
        },
        Flags = {},
        ConfigFlags = {},
        Connections = {},   
        Notifications = {Notifs = {}},
        OpenElement = {};
        AvailablePanels = {};

        EasingStyle = Enum.EasingStyle.Quint;
        TweeningSpeed = .3;
        DraggingSpeed = .05;
        Tweening = false;
    }

    local themes = {
        preset = {
            inline = rgb(18, 18, 18),
            outline = rgb(18, 18, 18),
            accent = rgb(0, 255, 152),
            background = rgb(18, 18, 18),              
            misc_1 = rgb(34, 34, 34),
            text_color = rgb(255, 255, 255),
            unselected = rgb(34, 34, 34),
            tooltip = rgb(73, 73, 73),
            misc_2 = rgb(18, 18, 18),
            font = "ProggyClean",
            textsize = 12
        },
        utility = {},
        gradients = {
            elements = {}
        },
    }

    for theme, color in themes.preset do 
        if theme == "font" or theme == "textsize" then 
            continue 
        end 

        themes.utility[theme] = {
            BackgroundColor3 = {}; 	
            TextColor3 = {};
            ImageColor3 = {};
            ScrollBarImageColor3 = {};
            Color = {};
        }
    end 

    local Keys = {
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }
        
    Library.__index = Library

    for _,path in Library.Folders do 
        makefolder(Library.Directory .. path)
    end

    local Flags = Library.Flags 
    local ConfigFlags = Library.ConfigFlags
    local Notifications = Library.Notifications 

    local FontNames = {
        ["ProggyClean"] = "ProggyClean.ttf",
        ["Tahoma"] = "fs-tahoma-8px.ttf",
        ["Verdana"] = "Verdana-Font.ttf",
        ["SmallestPixel"] = "smallest_pixel-7.ttf",
        ["ProggyTiny"] = "ProggyTiny.ttf",
        ["Minecraftia"] = "Minecraftia-Regular.ttf",
        ["Tahoma Bold"] = "tahoma_bold.ttf",
        ["Rubik"] = "Rubik-Regular.ttf"
    }

    local FontIndexes = {"ProggyClean", "Tahoma", "Verdana", "SmallestPixel", "ProggyTiny", "Minecraftia", "Tahoma Bold", "Rubik"}

    local Fonts = {}; do
        local function RegisterFont(Name, Weight, Style, Asset)
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end

            if isfile(Name .. ".font") then
                delfile(Name .. ".font")
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Asset.Id),
                    },
                },
            }

            writefile(Name .. ".font", HttpService:JSONEncode(Data))

            return getcustomasset(Name .. ".font");
        end

        for name, suffix in FontNames do 
            local Weight = 400 

            if name == "Rubik" then -- fuckin stupid 
                Weight = 900 
            end 

            local RegisteredFont = RegisterFont(name, Weight, "Normal", {
                Id = suffix,
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/" .. suffix),
            }) 
            
            Fonts[name] = Font.new(RegisteredFont, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end
    end
--

-- Library functions 
    -- Misc functions
        function Library:GetTransparency(obj)
            if obj:IsA("Frame") then
                return {"BackgroundTransparency"}
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif obj:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif obj:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("UIStroke") then 
                return { "Transparency" }
            end
            
            return nil
        end

        function Library:Tween(Object, Properties, Info)
            local tween = TweenService:Create(Object, Info or TweenInfo.new(Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0), Properties)
            tween:Play()
            
            return tween
        end
        
        function Library:Fade(obj, prop, vis, speed)
            if not (obj and prop) then
                return
            end

            local OldTransparency = obj[prop]
            obj[prop] = vis and 1 or OldTransparency

            local Tween = Library:Tween(obj, { [prop] = vis and OldTransparency or 1 }, TweenInfo.new(speed or Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0))
            
            Library:Connection(Tween.Completed, function()
                if not vis then
                    task.wait()
                    obj[prop] = OldTransparency
                end
            end)

            return Tween
        end

        function Library:Resizify(Parent)
            local Resizing = Library:Create("TextButton", {
                Position = dim2(1, -10, 1, -10);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 10, 0, 10);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
                Parent = Parent;
                BackgroundTransparency = 1; 
                Text = ""
            })
            
            local IsResizing = false 
            local Size 
            local InputLost 
            local ParentSize = Parent.Size  
            
            Resizing.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsResizing = true
                    InputLost = input.Position
                    Size = Parent.Size
                end
            end)
            
            Resizing.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsResizing = false
                end
            end)
        
            Library:Connection(InputService.InputChanged, function(input, game_event) 
                if IsResizing and input.UserInputType == Enum.UserInputType.MouseMovement then            
                    Library:Tween(Parent, {
                        Size = dim2(
                            Size.X.Scale,
                            math.clamp(Size.X.Offset + (input.Position.X - InputLost.X), ParentSize.X.Offset, Camera.ViewportSize.X), 
                            Size.Y.Scale, 
                            math.clamp(Size.Y.Offset + (input.Position.Y - InputLost.Y), ParentSize.Y.Offset, Camera.ViewportSize.Y)
                        )
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end
            end)
        end
        
        function Library:Hovering(Object)
            if type(Object) == "table" then 
                local Pass = false;

                for _,obj in Object do 
                    if Library:Hovering(obj) then 
                        Pass = true
                        return Pass
                    end 
                end 
            else 
                local y_cond = Object.AbsolutePosition.Y <= Mouse.Y and Mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
                local x_cond = Object.AbsolutePosition.X <= Mouse.X and Mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
                
                return (y_cond and x_cond)
            end 
        end  

        function Library:ConvertHex(color)
            local r = math.floor(color.R * 255)
            local g = math.floor(color.G * 255)
            local b = math.floor(color.B * 255)
            return string.format("#%02X%02X%02X", r, g, b)
        end

        function Library:ConvertFromHex(color)
            color = color:gsub("#", "")
            local r = tonumber(color:sub(1, 2), 16) / 255
            local g = tonumber(color:sub(3, 4), 16) / 255
            local b = tonumber(color:sub(5, 6), 16) / 255
            return Color3.new(r, g, b)
        end

        function Library:Draggify(Parent)
            local Dragging = false 
            local IntialSize = Parent.Position
            local InitialPosition 

            Parent.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    InitialPosition = Input.Position
                    InitialSize = Parent.Position
                end
            end)

            Parent.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)

            Library:Connection(InputService.InputChanged, function(Input, game_event) 
                if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                    local Horizontal = Camera.ViewportSize.X
                    local Vertical = Camera.ViewportSize.Y

                    local NewPosition = dim2(
                        0,
                        math.clamp(
                            InitialSize.X.Offset + (Input.Position.X - InitialPosition.X),
                            0,
                            Horizontal - Parent.Size.X.Offset
                        ),
                        0,
                        math.clamp(
                            InitialSize.Y.Offset + (Input.Position.Y - InitialPosition.Y),
                            0,
                            Vertical - Parent.Size.Y.Offset
                        )
                    )

                    Library:Tween(Parent, {
                        Position = NewPosition
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end
            end)
        end 

        function Library:Convert(str)
            local Values = {}

            for Value in string.gmatch(str, "[^,]+") do
                table.insert(Values, tonumber(Value))
            end

            if #Values == 3 then              
                return unpack(Values)
            else
                return
            end
        end
        
        function Library:Lerp(start, finish, t)
            t = t or 1 / 8

            return start * (1 - t) + finish * t
        end

        function Library:ConvertEnum(enum)
            local EnumParts = {}

            for _,part in string.gmatch(tostring(enum), "[%w_]+") do
                table.insert(EnumParts, part)
            end
            
            local EnumTable = tostring(enum)  

            for i = 2, #EnumParts do
                local EnumItem = EnumTable[EnumParts[i]]
        
                EnumTable = EnumItem
            end
            
            return EnumTable
        end

        local ConfigHolder;
        function Library:UpdateConfigList() 
            if not ConfigHolder then 
                return 
            end
            
            local List = {}
            
            for _,file in listfiles(Library.Directory .. "/configs") do
                local Name = file:gsub(Library.Directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(Library.Directory .. "\\configs\\", "")
                List[#List + 1] = Name
            end

            ConfigHolder.RefreshOptions(List)
        end
        
        function Library:Keypicker(properties) 
            local Cfg = {
                Name = properties.Name or "Color", 
                Flag = properties.Flag or properties.Name or "Colorpicker",
                Callback = properties.Callback or function() end,

                Color = properties.Color or color(1, 1, 1),
                Alpha = properties.Alpha or properties.Transparency or 0,
                
                Mode = properties.Mode or "Keypicker"; -- Animation

                -- Other
                Open = false, 
                Items = {Dropdown = nil};
                Tweening = false;
            }

            local DraggingSat = false 
            local DraggingHue = false 
            local DraggingAlpha = false 

            local h, s, v = Cfg.Color:ToHSV() 
            local a = Cfg.Alpha 

            Flags[Cfg.Flag] = {Color = Cfg.Color, Transparency = Cfg.Alpha}

            local Items = Cfg.Items; do 
                -- Component
                    Items.ColorpickerObject = Library:Create( "TextButton" , {
                        Name = "\0";
                        Parent = self.Items.Components;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 20, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.ColorpickerObject, "outline", "BackgroundColor3")

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.ColorpickerObject;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 50)
                    });

                    Items.Outline2 = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Outline2, "outline", "BackgroundColor3")

                    Items.MainColor = Library:Create( "Frame" , {
                        Parent = Items.Outline2;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    Items.TransparencyHandler = Library:Create("ImageLabel", {
                        Parent = Items.MainColor;
                        Image = "rbxassetid://18274452449";
                        ZIndex = 3;
                        BackgroundTransparency = 1;
                        ImageTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        ScaleType = Enum.ScaleType.Tile;
                        TileSize = dim2(0, 4, 0, 4);
                    })
                --
                    
                -- Colorpicker
                    Items.Colorpicker = Library:Create( "Frame" , {
                        Parent = Library.Other;
                        Name = "\0";
                        ZIndex = 999;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 179, 0, 234);
                        Visible = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Colorpicker, "outline", "BackgroundColor3"); Library:Resizify(Items.Colorpicker); 

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Colorpicker;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    }); Library:Themify(Items.Inline, "inline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.background
                    }); Library:Themify(Items.Background, "background", "BackgroundColor3")

                    Items.Text = Library:Create( "TextLabel" , {
                        Parent = Items.Background;
                        FontFace = Fonts[themes.preset.font];
                        Name = "\0";
                        TextColor3 = rgb(235, 235, 235);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = Cfg.Name;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Size = dim2(0, 0, 0, 16);
                        Position = dim2(0, 3, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.Text;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Items.Elements = Library:Create( "Frame" , {
                        Parent = Items.Background;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 3, 1, -42);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -6, 0, 18);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 49)
                    });

                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Elements;
                        Padding = dim(0, 2);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        VerticalFlex = Enum.UIFlexAlignment.Fill
                    });

                    local Section = setmetatable(Cfg, Library)

                    Items.RGB = Section:Textbox({Callback = function(text)
                        if Cfg.Set then 
                            local r, g, b = Library:Convert(text)
                            Cfg.Set(rgb(r, g, b), a)
                        end
                    end, Flag = "ignore"})

                    Items.Hex = Section:Textbox({Callback = function(text)
                        if Cfg.Set then 
                            Cfg.Set(Library:ConvertFromHex(text), a)
                        end 
                    end, Flag = "ignore"})

                    Items.Elements = Library:Create( "Frame" , {
                        Parent = Items.Background;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 3, 1, -21);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -6, 0, 18);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 49)
                    });

                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Elements;
                        Padding = dim(0, 2);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });

                    local Section = setmetatable(Cfg, Library)
                    Items.Animations = Section:Dropdown({
                        Options = {"Rainbow", "Breathing"}, 
                        Default = {""}, 
                        Multi = true,
                        Flag = Cfg.Flag .. "_RAINBOW_FLAG"
                    })

                    task.spawn(function()
                        while true do 
                            task.wait()
                            local Flag = Flags[Cfg.Flag .. "_RAINBOW_FLAG"]

                            if not Flag then 
                                continue 
                            end 

                            if not Cfg.Set then 
                                continue 
                            end

                            if #Flag == 0 then 
                                continue 
                            end 

                            local Sine = math.abs(math.sin(tick()))
                            local Hue = table.find(Flag, "Rainbow") and Sine or h 
                            local Alpha = table.find(Flag, "Breathing") and Sine or a

                            Cfg.Set(hsv(Hue, s, v), Alpha) 
                        end     
                    end)

                    Items.SatValHolder = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Background;
                        Name = "\0";
                        Position = dim2(0, 3, 0, 16);
                        Selectable = false;
                        Size = dim2(1, -21, 1, -76);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 49)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.SatValHolder;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(14, 8, 12)
                    });

                    Items.SatValBackground = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -3, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(21, 255, 99)
                    });

                    Items.SatValPicker = Library:Create( "Frame" , {
                        Parent = Items.SatValBackground;
                        Name = "\0";
                        Size = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 3;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.SatValPicker;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Items.Saturation = Library:Create( "Frame" , {
                        Parent = Items.SatValBackground;
                        Name = "\0";
                        Size = dim2(1, 1, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = Items.Saturation;
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });

                    Items.Value = Library:Create( "Frame" , {
                        Rotation = 180;
                        Name = "\0";
                        Parent = Items.SatValBackground;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIGradient" , {
                        Parent = Items.Value;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });

                    Items.Hue = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Background;
                        Name = "\0";
                        Position = dim2(0, 3, 1, -59);
                        Selectable = false;
                        Size = dim2(1, -6, 0, 14);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 49)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Hue;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(14, 8, 12)
                    });

                    Items.HueBackground = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                        Parent = Items.HueBackground
                    });

                    Items.HuePickerHolder = Library:Create( "Frame" , {
                        Parent = Items.HueBackground;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 2, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -4, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.HuePicker = Library:Create( "Frame" , {
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(12, 12, 12);
                        AnchorPoint = vec2(1, 0);
                        Parent = Items.HuePickerHolder;
                        BackgroundTransparency = 0.25;
                        Position = dim2(1, 1, 0, 1);
                        Name = "\0";
                        Size = dim2(0, 2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.HuePicker;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Items.Alpha = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(1, 0);
                        Parent = Items.Background;
                        Name = "\0";
                        Position = dim2(1, -3, 0, 16);
                        Size = dim2(0, 14, 1, -76);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 49)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Alpha;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(14, 8, 12)
                    });

                    Items.AlphaBackground = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.AlphaIndicator = Library:Create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.AlphaBackground;
                        Name = "\0";
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 8, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Fading = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.AlphaBackground;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(21, 255, 99)
                    });

                    Library:Create( "UIGradient" , {
                        Rotation = 90;
                        Transparency = numseq{numkey(0, 1), numkey(1, 0)};
                        Parent = Items.Fading
                    });

                    Items.PickerHolder = Library:Create( "Frame" , {
                        Parent = Items.Fading;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, -4);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.AlphaPicker = Library:Create( "Frame" , {
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(12, 12, 12);
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.PickerHolder;
                        BackgroundTransparency = 0.25;
                        Position = dim2(0, 1, 1, 1);
                        Name = "\0";
                        Size = dim2(1, -2, 0, 2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.AlphaPicker;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });
                --
            end
            
            function Cfg.SetVisible(bool)
                if Cfg.Tweening == true then
                    return 
                end 

                Items.Colorpicker.Position = dim2(0, Items.ColorpickerObject.AbsolutePosition.X + 2, 0, Items.ColorpickerObject.AbsolutePosition.Y + 74)
                
                Cfg.Tween(bool)
                Cfg.Set(hsv(h, s, v), a)
            end

            function Cfg.Tween(bool) 
                if Cfg.Tweening == true then 
                    return 
                end         

                Cfg.Tweening = true 

                if bool then 
                    Items.Colorpicker.Visible = true
                    Items.Colorpicker.Parent = Library.Items
                end

                local Children = Items.Colorpicker:GetDescendants()
                table.insert(Children, Items.Colorpicker)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
                    end
                end

                Library:Connection(Tween.Completed, function()
                    Cfg.Tweening = false
                    Items.Colorpicker.Visible = bool
                end)
            end

            function Cfg.UpdateColor() 
                local Mouse = InputService:GetMouseLocation()
                local offset = vec2(Mouse.X, Mouse.Y - gui_offset) 
                
                if DraggingSat then	
                    s = 1 - math.clamp((offset - Items.SatValHolder.AbsolutePosition).X / Items.SatValHolder.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - Items.SatValHolder.AbsolutePosition).Y / Items.SatValHolder.AbsoluteSize.Y, 0, 1)
                elseif DraggingHue then
                    h = math.clamp((offset - Items.Hue.AbsolutePosition).X / Items.Hue.AbsoluteSize.X, 0, 1)
                elseif DraggingAlpha then
                    a = math.clamp((offset - Items.Alpha.AbsolutePosition).Y / Items.Alpha.AbsoluteSize.Y, 0, 1)
                end

                Cfg.Set()
            end
            
            function Cfg.Set(color, alpha)
                if type(color) == "boolean" then 
                    return
                end 

                if color then 
                    h, s, v = color:ToHSV()
                end
                
                if alpha then 
                    a = alpha
                end 
                
                Items.MainColor.BackgroundColor3 = hsv(h, s, v)
                Items.TransparencyHandler.ImageTransparency = a

                if Items.Colorpicker.Visible then 
                    Library:Tween(Items.SatValPicker, {
                        Position = dim2(1 - s, 0, 1 - v, 0)
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                    Library:Tween(Items.AlphaPicker, {
                        Position = dim2(0, 1, a, 1)
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                    Library:Tween(Items.HuePicker, {
                        Position = dim2(h, 1, 0, 1)
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                    Items.SatValBackground.BackgroundColor3 = hsv(h, 1, 1)
                    Items.Fading.BackgroundColor3 = hsv(h, 1, 1)

                    local Color = Items.MainColor.BackgroundColor3 -- Overwriting to format<<
                    
                    if not Items.RGB.Focused then 
                        Items.RGB.Items.Input.Text = string.format("%s, %s, %s", Library:Round(Color.R * 255), Library:Round(Color.G * 255), Library:Round(Color.B * 255))
                    end 

                    if not Items.Hex.Focused then 
                        Items.Hex.Items.Input.Text = Library:ConvertHex(Color)
                    end 
                end 

                local Color = hsv(h, s, v)

                Flags[Cfg.Flag] = {
                    Color = Color;
                    Transparency = a 
                }
                
                Cfg.Callback(Color, a)
            end

            Items.ColorpickerObject.MouseButton1Click:Connect(function()
                Cfg.Open = not Cfg.Open
                Cfg.SetVisible(Cfg.Open)            
            end)

            InputService.InputChanged:Connect(function(input)
                if (DraggingSat or DraggingHue or DraggingAlpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Cfg.UpdateColor() 
                end
            end)

            Library:Connection(InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:Hovering({Items.Colorpicker, Items.Animations.Items.DropdownElements}) and Items.Colorpicker.Visible then
                    Cfg.SetVisible(false)
                end
            end) 

            Library:Connection(InputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    DraggingSat = false
                    DraggingHue = false
                    DraggingAlpha = false
                end
            end)    

            Items.Alpha.MouseButton1Down:Connect(function()
                DraggingAlpha = true 
            end)
            
            Items.Hue.MouseButton1Down:Connect(function()
                DraggingHue = true 
            end)
            
            Items.SatValHolder.MouseButton1Down:Connect(function()
                DraggingSat = true  
            end)
            
            Cfg.Set(Cfg.Color, Cfg.Alpha)
            Cfg.SetVisible(false)
            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

        function Library:GetConfig()
            local Config = {}
            
            for Idx, Value in Flags do
                if type(Value) == "table" and Value.Key then
                    Config[Idx] = {Active = Value.Active, Mode = Value.Mode, Key = tostring(Value.Key)}
                elseif type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                    Config[Idx] = {Transparency = Value["Transparency"], Color = Value["Color"]:ToHex()}
                else
                    Config[Idx] = Value
                end
            end 

            return HttpService:JSONEncode(Config)
        end

        function Library:LoadConfig(JSON) 
            local Config = HttpService:JSONDecode(JSON)
            
            for Idx, Value in Config do  
                if Idx == "ignore" then 
                    continue 
                end 

                local Function = ConfigFlags[Idx]

                if Function then 
                    if type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                        Function(hex(Value["Color"]), Value["Transparency"])
                    else 
                        Function(Value)
                    end
                end 
            end 
        end 
        
        function Library:Round(num, float) 
            local Multiplier = 1 / (float or 1)
            return math.floor(num * Multiplier + 0.5) / Multiplier
        end

        function Library:Themify(instance, theme, property)
            table.insert(themes.utility[theme][property], instance)
        end

        function Library:SaveGradient(instance, theme)
            table.insert(themes.gradients[theme], instance)
        end

        function Library:RefreshTheme(theme, color)
            for property,instances in themes.utility[theme] do 
                for _,object in instances do
                    if object[property] == themes.preset[theme] then 
                        object[property] = color 
                    end
                end 
            end

            themes.preset[theme] = color 
        end 

        function Library:Connection(signal, callback)
            local connection = signal:Connect(callback)
            
            table.insert(Library.Connections, connection)

            return connection 
        end

        function Library:CloseElement() 
            local IsMulti = typeof(Library.OpenElement)

            if not Library.OpenElement then 
                return 
            end

            for i = 1, #Library.OpenElement do
                local Data = Library.OpenElement[i]

                if Data.Ignore then 
                    continue 
                end 

                Data.SetVisible(false)
                Data.Open = false
            end

            Library.OpenElement = {}
		end

        function Library:Create(instance, options)
            local ins = Instance.new(instance) 

            for prop, value in options do
                ins[prop] = value
            end

            if ins.ClassName == "TextButton" then 
                ins["AutoButtonColor"] = false 
                ins["Text"] = ""
                Library:Themify(ins, "text_color", "TextColor3")
            end 

            if ins.ClassName == "TextLabel" or ins.ClassName == "TextBox" then 
                Library:Themify(ins, "text_color", "TextColor3")
                Library:Themify(ins, "unselected", "TextColor3")
            end 

            return ins 
        end

        function Library:Unload() 
            if not Library then 
                return 
            end 

            if Library.Items then 
                Library.Items:Destroy()
            end

            if Library.Other then 
                Library.Other:Destroy()
            end

            if Library.Elements then 
                Library.Elements:Destroy()
            end 
            
            for _,connection in Library.Connections do 
                if not connection then 
                    continue 
                end 

                connection:Disconnect() 
                connection = nil 
            end

            if Library.Blur then 
                Library.Blur:Destroy()
            end 

            getgenv().Library = nil 
        end
    --
    
    -- List Library 
        function Library:StatusList(properties)
            local Cfg = {
                Name = properties.Name or "List"; 

                Items = {}
            } 

            local Items = Cfg.Items; do 
                -- Top
                    Items.List = Library:Create( "Frame", {
                        Parent = Library.Elements;
                        Size = dim2(0, 0, 0, 20);
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.List, "outline", "BackgroundColor3"); Library:Draggify(Items.List)
                    
                    Items.Inline = Library:Create( "Frame", {
                        Parent = Items.List;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = themes.preset.inline
                    }); Library:Themify(Items.Inline, "inline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame", {
                        Parent = Items.Inline;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = themes.preset.misc_1
                    });	Library:Themify(Items.Background, "misc_1", "BackgroundColor3")

                    Items.StatusList = Library:Create( "TextLabel", {
                        FontFace = Fonts[themes.preset.font];
                        Parent = Items.Background;
                        TextColor3 = themes.preset.text_color;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = Cfg.Name;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Position = dim2(0.5, 0, 0, 5);
                        AnchorPoint = vec2(0.5, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        RichText = true;
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.StatusList, "text_color", "TextColor3")

                    Library:Create( "UIStroke", {
                        Parent = Items.StatusList;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Library:Create( "UIPadding", {
                        PaddingBottom = dim(0, 5);
                        Parent = Items.StatusList;
                        PaddingLeft = dim(0, 5);
                        PaddingRight = dim(0, 3)
                    });

                    Items.Accent = Library:Create( "Frame", {
                        AnchorPoint = vec2(1, 0);
                        Parent = Items.Background;
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.accent
                    }); Library:Themify(Items.Accent, "accent", "BackgroundColor3")

                    Library:Create( "UIPadding", {
                        PaddingRight = dim(0, 2);
                        Parent = Items.Inline
                    });

                    Library:Create( "UIPadding", {
                        PaddingRight = dim(0, 2);
                        Parent = Items.List
                    });
                --

                -- Holder
                    Items.Holder = Library:Create( "Frame", {
                        Parent = Library.Elements;
                        Name = "\0";
                        ZIndex = 5;
                        Position = dim2(0, 300, 0, 100);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); 

                    Library:Create( "UIListLayout", {
                        Parent = Items.Holder;
                        Padding = dim(0, -1);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                --  
            end 

            Items.List:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                Items.Holder.Position = Items.List.Position + dim_offset(0, 23)
                Items.List.Size = dim2(0, math.max(0, Items.Holder.AbsoluteSize.X, 120), 0, 20)
            end)

            Items.Holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                Items.List.Size = dim2(0, math.max(0, Items.Holder.AbsoluteSize.X, 120), 0, 20)
                Items.Holder.Position = Items.List.Position + dim_offset(0, 23)
            end)

            task.delay(0.01, function()
                Items.List.Position = dim2(0, 50, 0, 700);
            end)
            
            return setmetatable(Cfg, Library)
        end 

        function Library:ListElement(properties)
            local Cfg = {
                Name = properties.Name or "Text"; 
                Items = {}
            } 

            local Items = Cfg.Items; do     
                Items.Outline = Library:Create( "Frame", {
                    Parent = self.Items.Holder;
                    Size = dim2(1, 0, 0, 20);
                    Name = "\0";
                    Position = dim2(0, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Inline = Library:Create( "Frame", {
                    Parent = Items.Outline;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.inline 
                }); Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Background = Library:Create( "Frame", {
                    Parent = Items.Inline;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.misc_1
                });	Library:Themify(Items.Background, "misc_1", "BackgroundColor3")

                Items.Title = Library:Create( "TextLabel", {
                    FontFace = Fonts[themes.preset.font];
                    Parent = Items.Background;
                    TextColor3 = themes.preset.text_color;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Position = dim2(0, 0, 0, 3);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    RichText = true;
                    ZIndex = 2;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Title, "text_color", "BackgroundColor3")

                Library:Create( "UIStroke", {
                    Parent = Items.Title;
                    LineJoinMode = Enum.LineJoinMode.Miter
                });

                Library:Create( "UIPadding", {
                    PaddingBottom = dim(0, 5);
                    PaddingLeft = dim(0, 5);
                    Parent = Items.Title
                });

                Library:Create( "UIListLayout", {
                    Parent = Items.Background;
                    Padding = dim(0, 15);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                Library:Create( "UIPadding", {
                    PaddingTop = dim(0, 4);
                    PaddingBottom = dim(0, 2);
                    Parent = Items.Background;
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 2)
                });

                Library:Create( "UIPadding", {
                    PaddingRight = dim(0, 2);
                    Parent = Items.Inline
                });

                Library:Create( "UIPadding", {
                    PaddingRight = dim(0, 2);
                    Parent = Items.Outline
                });
            end 

            function Cfg.SetVisible(bool) 
                Items.Outline.Visible = bool 
            end 

            function Cfg.SetText(string)
                Items.Title.Text = string
            end 
        
            return setmetatable(Cfg, Library)
        end 
    -- 

    -- Image Holders 
        function Library:ImageHolder(properties) 
            local Cfg = {
                Name = properties.Name or "Viewer"; 
                Items = {} 
            }

            local Items = Cfg.Items; do 
                Items.Glow = Library:Create( "ImageLabel", {
                    ImageColor3 = themes.preset.accent;
                    ScaleType = Enum.ScaleType.Slice;
                    ImageTransparency = 0.65;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Library.Elements;
                    Name = "\0";
                    BorderSizePixel = 0;
                    Image = "rbxassetid://18245826428";
                    BackgroundTransparency = 1;
                    BackgroundColor3 = rgb(255, 255, 255);
                    AutomaticSize = Enum.AutomaticSize.XY;
                    SliceCenter = rect(vec2(21, 21), vec2(79, 79))
                }); Library:Themify(Items.Glow, "accent", "ImageColor3"); Library:Draggify(Items.Glow)
                
                Items.OutlineMenu = Library:Create( "Frame", {
                    Parent = Items.Glow;
                    Name = "\0";
                    Size = dim2(0, 0, 0, 101);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.OutlineMenu, "outline", "BackgroundColor3")

                Items.AccentMenu = Library:Create( "Frame", {
                    Parent = Items.OutlineMenu;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.accent
                }); Library:Themify(Items.AccentMenu, "accent", "BackgroundColor3")

                Library:Create( "UIPadding", {
                    PaddingRight = dim(0, 2);
                    Parent = Items.AccentMenu
                });

                Items.InlineMenu = Library:Create( "Frame", {
                    Parent = Items.AccentMenu;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.background
                });	Library:Themify(Items.InlineMenu, "background", "BackgroundColor3")

                Items.StatusList = Library:Create( "TextLabel", {
                    FontFace = Fonts[themes.preset.font];
                    Parent = Items.InlineMenu;
                    TextColor3 = themes.preset.text_color;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Position = dim2(0, 0, 0, 3);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    RichText = true;
                    ZIndex = 2;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.StatusList, "text_color", "BackgroundColor3")

                Library:Create( "UIStroke", {
                    Parent = Items.StatusList;
                    LineJoinMode = Enum.LineJoinMode.Miter
                });

                Library:Create( "UIPadding", {
                    PaddingBottom = dim(0, 5);
                    Parent = Items.StatusList;
                    PaddingLeft = dim(0, 5);
                    PaddingRight = dim(0, 3)
                });

                Items.InnerSection = Library:Create( "Frame", {
                    Parent = Items.InlineMenu;
                    Size = dim2(1, -8, 1, -22);
                    Name = "\0";
                    Position = dim2(0, 4, 0, 18);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.InnerSection, "outline", "BackgroundColor3")

                Items.InnerInline = Library:Create( "Frame", {
                    Parent = Items.InnerSection;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = rgb(46, 46, 46)
                });

                Items.InnerBackground = Library:Create( "Frame", {
                    Parent = Items.InnerInline;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.InnerBackground, "misc_1", "BackgroundColor3")

                Library:Create( "UIListLayout", {
                    Parent = Items.InnerBackground;
                    Padding = dim(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });

                Library:Create( "UIPadding", {
                    PaddingTop = dim(0, 4);
                    PaddingBottom = dim(0, 4);
                    Parent = Items.InnerBackground;
                    PaddingRight = dim(0, -4);
                    PaddingLeft = dim(0, 4)
                });

                Library:Create( "UIPadding", {
                    PaddingRight = dim(0, 2);
                    Parent = Items.InnerInline
                });

                Library:Create( "UIPadding", {
                    PaddingRight = dim(0, 2);
                    Parent = Items.InnerSection
                });

                Library:Create( "UIPadding", {
                    PaddingRight = dim(0, 8);
                    Parent = Items.InlineMenu
                });

                Library:Create( "UIPadding", {
                    PaddingRight = dim(0, 2);
                    Parent = Items.OutlineMenu
                });

                Library:Create( "UIPadding", {
                    PaddingTop = dim(0, 20);
                    PaddingBottom = dim(0, 20);
                    Parent = Items.Glow;
                    PaddingRight = dim(0, 20);
                    PaddingLeft = dim(0, 20)
                });
            end 

            function Cfg.SetVisible(bool)
                Items.Glow.Visible = bool
            end 
            
            return setmetatable(Cfg, Library)
        end 

        function Library:AddImage(properties)
            local Cfg = {
                Image = properties.Image or "rbxassetid://86659429043601"; 
                Items = {} 
            }

            local Items = Cfg.Items; do 
                Items.Outline = Library:Create( "Frame", {
                    Parent = self.Items.InnerBackground;
                    Name = "\0";
                    Position = dim2(0, 4, 0, 18);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 63, 0, 63);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Inline = Library:Create( "Frame", {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.inline
                }); Library:Themify(Items.Inline, "inline", "BackgroundColor3") 
                
                Items.Background = Library:Create( "Frame", {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.misc_1
                });	Library:Themify(Items.Background, "misc_1", "BackgroundColor3")

                Items.Image = Library:Create( "ImageLabel", {
                    Parent = Items.Background;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Image = Cfg.Image;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                });	
            end

            function Cfg.Remove()  
                Items.Outline:Destroy()
            end 

            return setmetatable(Cfg, Library)
        end 
    --  
        
    -- Library element functions
        function Library:Window(properties)
            local Cfg = {
                Name = properties.Name or "nebula";
                Size = properties.Size or dim2(0, 455, 0, 605);
                Items = {};
                Tweening = false;
                Tick = tick();
                Fps = 0;
            }

            Library.Items = Library:Create( "ScreenGui" , {
                Parent = CoreGui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
                DisplayOrder = 100;
            });
            
            Library.Other = Library:Create( "ScreenGui" , {
                Parent = CoreGui;
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            }); 

            Library.Elements = Library:Create( "ScreenGui" , {
                Parent = gethui();
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
                DisplayOrder = 100;
            }); 

            Library.Blur = Library:Create( "BlurEffect" , {
                Parent = Lighting;
                Enabled = true;
                Size = 0
            });

            Library.KeybindList = Library:StatusList({Name = "Keybinds"})

            local Items = Cfg.Items; do
                -- Items 
                    Items.Holder = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Visible = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.FirstInline = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Holder;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 6, 0, 26);
                        Size = dim2(1, -12, 1, -36);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    local Stroke = Library:Create( "UIStroke" , {
                        Color = rgb(40, 40, 45);
                        LineJoinMode = Enum.LineJoinMode.Miter;
                        Parent = Items.FirstInline
                    });	Library:Themify(Stroke, "inline", "Color")

                    Items.SecondInline = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.FirstInline;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 1, 0, 1);
                        Size = dim2(1, -2, 1, -2);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local Stroke = Library:Create( "UIStroke" , {
                        Color = themes.preset.outline;
                        LineJoinMode = Enum.LineJoinMode.Miter;
                        Parent = Items.SecondInline
                    });	Library:Themify(Stroke, "outline", "Color");

                    Items.Accent = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.SecondInline;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.accent
                    });	Library:Themify(Items.Accent, "accent", "BackgroundColor3")

                    Items.ThirdInline = Library:Create( "Frame" , {
                        Parent = Items.SecondInline;
                        Name = "\0";
                        Position = dim2(0, 0, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.ThirdInline, "inline", "BackgroundColor3")

                    Items.Outline = Library:Create( "Frame" , {
                        Parent = Items.SecondInline;
                        Name = "\0";
                        Position = dim2(0, 0, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                    Items.InnerOutline = Library:Create( "Frame" , {
                        Parent = Items.Holder;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 6, 0, 26);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -12, 1, -36);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    local Stroke = Library:Create( "UIStroke" , {
                        Color = rgb(15, 15, 20);
                        LineJoinMode = Enum.LineJoinMode.Miter;
                        Parent = Items.InnerOutline;
                        Thickness = 10000
                    }); Library:Themify(Stroke, "outline", "Color");

                    Items.Title = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        TextColor3 = rgb(235, 235, 235);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Parent = Items.InnerOutline;
                        Name = "\0";
                        AnchorPoint = vec2(0, 1);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(0, -1, 0, -8);
                        BorderColor3 = rgb(0, 0, 0);
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.Title;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Items.WindowButtonHolder = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(1, 1);
                        Parent = Items.InnerOutline;
                        BackgroundTransparency = 1;
                        Position = dim2(1, 1, 0, -6);
                        Name = "\0";
                        Size = dim2(0, 0, 0, 16);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = Items.WindowButtonHolder;
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                -- 

                -- Watermark
                    Items.Watermark = Library:Create( "Frame" , {
                        Parent = Library.Elements;
                        Name = "\0";
                        Visible = false;
                        Position = dim2(0.024000000208616257, 0, 0, 33);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Watermark, "outline", "BackgroundColor3")
                    Library:Draggify(Items.Watermark)

                    Items.AccentLineFade = Library:Create( "Frame" , {
                        Parent = Items.Watermark;
                        Size = dim2(1, -3, 0, 1);
                        Name = "\0";
                        Position = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 3;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.accent
                    }); Library:Themify(Items.AccentLineFade, "accent", "BackgroundColor3")
                    
                    Items.FadingGradient = Library:Create( "UIGradient" , {
                        Offset = vec2(0, 0);
                        Transparency = numseq{numkey(0, 0), numkey(0.5, 1), numkey(1, 0)};
                        Parent = Items.AccentLineFade
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Watermark;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Inline, "inline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = rgb(28, 28, 33)
                    });

                    Items.Text = Library:Create( "TextLabel" , {
                        RichText = true;
                        Parent = Items.Background;
                        TextColor3 = themes.preset.accent;
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = 'octohook.xyz <font color = "rgb(235, 235, 235)">@placeholder / UID @ / Developer / 00/00/0000 / 00:00:00 / 0fps / Oms</font>';
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BorderSizePixel = 0;
                        BorderColor3 = rgb(0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        FontFace = Fonts[themes.preset.font];
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = themes.preset.accent
                    });	Library:Themify(Items.Text, "accent", "TextColor3")

                    Library:Create( "UIStroke" , {
                        Parent = Items.Text;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Library:Create( "UIPadding" , {
                        PaddingTop = dim(0, 5);
                        PaddingBottom = dim(0, 6);
                        Parent = Items.Text;
                        PaddingRight = dim(0, 4);
                        PaddingLeft = dim(0, 6)
                    });

                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 1);
                        PaddingRight = dim(0, 1);
                        Parent = Items.Inline
                    });

                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 1);
                        PaddingRight = dim(0, 1);
                        Parent = Items.Watermark
                    });
                -- 
            end

            function Cfg.ChangeMenuTitle(string)
                Items.Title.Text = string
            end 

            -- recommended that you use richtext for automatic theming of the accent text.
            function Cfg.ChangeWatermarkTitle(string) 
                Items.Text.Text = string
            end 

            function Cfg.SetWatermarkVisible(bool)
                Items.Watermark.Visible = bool
            end

            function Cfg.SetVisible(bool)
                if Library.Tweening then
                    return 
                end     

                Library:Tween(Library.Blur, {Size = bool and (Flags["BlurSize"] or 15) or 0})

                Cfg.Tween(bool)
            end 

            function Cfg.Tween(bool) 
                if Library.Tweening then 
                    return 
                end 

                Library.Tweening = true 

                if bool then 
                    Library.Items.Enabled = true
                end

                local Children = Library.Items:GetDescendants()
                table.insert(Children, Items.Holder)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool)
                    end
                end

                Library:Connection(Tween.Completed, function()
                    Library.Tweening = false
                    Library.Items.Enabled = bool
                end)
            end 
            
            Cfg.SetVisible(true)

            Library:Connection(RunService.RenderStepped, function()
                if not Items.Watermark.Visible then 
                    return 
                end 

                local Tick = tick()
                Cfg.Fps += 1 

                Items.FadingGradient.Offset = vec2(math.sin(Tick), 0) 

                if Tick - Cfg.Tick >= 1 then 
                    Cfg.Tick = Tick

                    local Uid = 0
                    local Status = "Universal"
                    local Ping = math.floor(Stats.PerformanceStats.Ping:GetValue())
                    Cfg.ChangeWatermarkTitle(string.format('%s <font color = "%s">/ UID %s / %s / %s / %sfps / %sms</font>', Cfg.Name, Library:ConvertHex(themes.preset.text_color), Uid, Status, os.date("%x / %X"), Cfg.Fps, Ping))

                    Cfg.Fps = 0
                end 
            end)

            return setmetatable(Cfg, Library)
        end 

        function Library:Panel(properties) 
            local Cfg = {  
                Name = properties.Name or "nebula";
                ButtonName = properties.ButtonName or properties.Name or "Button";
                Size = properties.Size or dim2(0, 455, 0, 605);
                Position = properties.Position or dim2(0.5, 0, 0.5, 0);
                AnchorPoint = properties.AnchorPoint or vec2(0, 0);
                
                TabInfo;
                Open = true; 
                Items = {};
                Tweening = false;
            }

            local Items = Cfg.Items; do
                -- Button 
                    Items.Button = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = self.Items.WindowButtonHolder;
                        Name = "\0";
                        Selectable = false;
                        Size = dim2(0, 0, 0, 16);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Button, "inline", "BackgroundColor3")

                    Items.ButtonTitle = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        Parent = Items.Button;
                        TextColor3 = themes.preset.text_color;
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = Cfg.ButtonName;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        AnchorPoint = vec2(0, 0.5);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0.5, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); Library:Themify(Items.ButtonTitle, "unselected", "TextColor3")

                    Library:Create( "UIStroke" , {
                        Parent = Items.ButtonTitle;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Library:Create( "UIPadding" , {
                        Parent = Items.ButtonTitle;
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 7)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Button;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Inline, "outline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = themes.preset.misc_1
                    }); Library:Themify(Items.Background, "misc_1", "BackgroundColor3");

                    Library:Create( "UIPadding" , {
                        PaddingRight = dim(0, 2);
                        Parent = Items.Inline
                    });

                    Library:Create( "UIPadding" , {
                        PaddingRight = dim(0, 2);
                        Parent = Items.Button
                    });


                -- 

                -- Window 
                    Items.Window = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        Name = "\0";
                        ClipsDescendants = false;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Position = Cfg.Position;
                        AnchorPoint = Cfg.AnchorPoint;
                        Size = Cfg.Size;
                        -- Rotation = 180;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Window, "outline", "BackgroundColor3")

                    Items.Fading = Library:Create( "Frame", {
                        Parent = Items.Panel;
                        BackgroundTransparency = 1; -- 0.6499999761581421
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    -- task.spawn(function()
                    --     while true do 
                    --         Items.Window.Rotation += 1
                    --         task.wait() 
                    --     end 
                    -- end)

                    Items.Glow = Library:Create( "ImageLabel", {
                        ImageColor3 = themes.preset.accent;
                        ScaleType = Enum.ScaleType.Slice;
                        Parent = Items.Window;
                        ImageTransparency = 1; -- 0.6499999761581421
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        Size = dim2(1, 41, 1, 41);
                        BorderSizePixel = 0;
                        AnchorPoint = vec2(0.5, 0.5);
                        Image = "rbxassetid://18245826428";
                        BackgroundTransparency = 1;
                        Position = dim2(0.5, -1, 0.5, -1);
                        BackgroundColor3 = rgb(255, 255, 255);
                        AutomaticSize = Enum.AutomaticSize.XY;
                        SliceCenter = rect(vec2(21, 21), vec2(79, 79))
                    }); Library:Themify(Items.Glow, "accent", "ImageColor3")

                    Library:Create( "UIPadding", {
                        PaddingTop = dim(0, 20);
                        PaddingBottom = dim(0, 20);
                        Parent = Items.Glow;
                        PaddingRight = dim(0, 20);
                        PaddingLeft = dim(0, 20)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Window;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Inline, "inline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.misc_1
                    }); Library:Themify(Items.Background, "misc_1", "BackgroundColor3");

                    Items.PageHolderBackground = Library:Create( "Frame" , {
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Background;
                        Name = "\0";
                        Position = dim2(0, 6, 0, 21);
                        Size = dim2(1, -12, 1, -26);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.PageHolderBackground, "inline", "BackgroundColor3")

                    Items.InlineSecond = Library:Create( "Frame" , {
                        Parent = Items.PageHolderBackground;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.InlineSecond, "outline", "BackgroundColor3")

                    Items.BackgroundSecond = Library:Create( "Frame" , {
                        Parent = Items.InlineSecond;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(15, 15, 20)
                    });

                    Items.Accent = Library:Create( "Frame" , {
                        Parent = Items.BackgroundSecond;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.accent
                    });	Library:Themify(Items.Accent, "accent", "BackgroundColor3")

                    Items.TabButtonHolder = Library:Create( "Frame" , {
                        Parent = Items.BackgroundSecond;
                        Size = dim2(1, -26, 0, 39);
                        Name = "\0";
                        Position = dim2(0, 13, 0, 13);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.TabButtonHolder, "outline", "BackgroundColor3")

                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.TabButtonHolder;
                        Padding = dim(0, -1);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        VerticalFlex = Enum.UIFlexAlignment.Fill
                    });

                    Library:Create( "UIPadding" , {
                        PaddingTop = dim(0, 1);
                        PaddingBottom = dim(0, 1);
                        Parent = Items.TabButtonHolder;
                        PaddingRight = dim(0, 1);
                        PaddingLeft = dim(0, 1)
                    });

                    Items.PageHolder = Library:Create( "Frame" , {
                        Parent = Items.BackgroundSecond;
                        Size = dim2(1, -26, 1, -71);
                        Name = "\0";
                        Position = dim2(0, 13, 0, 58);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.PageHolder, "outline", "BackgroundColor3")

                    Items.InlineThird = Library:Create( "Frame" , {
                        Parent = Items.PageHolder;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.InlineThird, "inline", "BackgroundColor3")

                    Items.PageHolder = Library:Create( "Frame" , {
                        Parent = Items.InlineThird;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(28, 28, 33)
                    });

                    Items.Title = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        TextColor3 = themes.preset.text_color;
                        Text = Cfg.Name;
                        Parent = Items.Background;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0, 5);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.Title;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Library:Create( "UIPadding" , {
                        Parent = Items.Title;
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 7)
                    });
                -- 
            end 

            do -- Other
                Library:Draggify(Items.Window)
                Library:Resizify(Items.Window)
            end

            function Cfg.ChangeName(string)
                Items.Title.Text = string
            end 

            function Cfg.SetMenuVisible(bool)
                if Cfg.Tweening or Library.Tweening then
                    return
                end 

                Library:Tween(Items.ButtonTitle, {TextColor3 = bool and themes.preset.text_color or themes.preset.unselected})
                Cfg.ToggleMenu(bool)
            end 

            Items.Button.MouseButton1Click:Connect(function()
                if self.Tweening then 
                    return 
                end 

                Cfg.Open = not Cfg.Open
                Cfg.SetMenuVisible(Cfg.Open)
            end)

            function Cfg.ToggleMenu(bool)
                if Cfg.Tweening or Library.Tweening then 
                    return 
                end 

                Cfg.Tweening = true 

                if bool then 
                    Items.Window.Visible = true
                end

                local Children = Items.Window:GetDescendants()
                table.insert(Children, Items.Window)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool)
                    end
                end

                Library:Connection(Tween.Completed, function()
                    Cfg.Tweening = false
                    Items.Window.Visible = bool
                end)
            end     

            Items.Window.MouseEnter:Connect(function()
                Library:Tween(Items.Glow, {ImageTransparency = 0.6499999761581421})
            end)

            Items.Window.MouseLeave:Connect(function()
                Library:Tween(Items.Glow, {ImageTransparency = 1})
            end)

            local Index = setmetatable(Cfg, Library)
            Library.AvailablePanels[#Library.AvailablePanels + 1] = Index

            return Index
        end 

        function Library:Tab(properties)
            local Cfg = {
                Name = properties.name or properties.Name or "tab"; 
                Items = {};
                AutoColumn = properties.Columns or true;
                Tweening = false;
            }
            
            local Items = Cfg.Items; do 
                -- Tab buttons 
                    Items.Outline = Library:Create( "TextButton" , {
                        Parent = self.Items.TabButtonHolder;
                        Size = dim2(0, 100, 0, 100);
                        Name = "\0";
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Outline, "inline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIGradient" , {
                        Rotation = 90;
                        Parent = Items.Background;
                        Color = rgbseq{rgbkey(0, rgb(27, 27, 32)), rgbkey(1, rgb(21, 21, 25))}
                    });

                    Items.Title = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        Parent = Items.Background;
                        TextColor3 = rgb(140, 140, 140);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = Cfg.Name;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        AnchorPoint = vec2(0.5, 0.5);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(0.5, 0, 0.5, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.Title;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Library:Create( "UIPadding" , {
                        Parent = Items.Title;
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 7)
                    });
                -- 

                -- Page Directory
                    Items.Page = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Library.Other; -- self.Items.PageHolder
                        Name = "\0";
                        Visible = false;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 6, 0, 6);
                        Size = dim2(1, -12, 1, -12);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Page;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        VerticalFlex = Enum.UIFlexAlignment.Fill
                    });
                --
            end 

            function Cfg.OpenTab() 
                local Tab = self.TabInfo

                if Tab == Cfg then 
                    return 
                end 

                if Tab then
                    Tab.Items.Title.TextColor3 = themes.preset.unselected
                    Tab.Tween(false)
                end

                Cfg.Tween(true)
                Items.Title.TextColor3 = themes.preset.text_color

                self.TabInfo = Cfg
            end

            function Cfg.Tween(bool) 
                if Cfg.Tweening == true then 
                    return 
                end 

                Cfg.Tweening = true 

                if bool then 
                    Items.Page.Visible = true
                    Items.Page.Parent = self.Items.PageHolder
                end

                local Children = Items.Page:GetDescendants()
                table.insert(Children, Items.Page)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
                    end
                end
                
                Library:Connection(Tween.Completed, function()
                    Cfg.Tweening = false
                    Items.Page.Visible = bool
                    Items.Page.Parent = bool and self.Items.PageHolder or Library.Other
                end)
            end

            Items.Outline.MouseButton1Down:Connect(function()
                if Cfg.Tweening or self.TabInfo.Tweening then
                    return 
                end 

                Cfg.OpenTab()
            end)

            if not self.TabInfo then
                Cfg.OpenTab()
            end

            return setmetatable(Cfg, Library)
        end

        function Library:Column(properties)
            local Cfg = {
                Items = {}
            }

            local Items = Cfg.Items; do 
                Items.Column = Library:Create( "Frame" , {
                    Parent = self.Items.Page;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 100, 0, 100);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIListLayout" , {
                    Parent = Items.Column;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Padding = dim(0, 11);
                });
            end 

            return setmetatable(Cfg, Library) 
        end 

        function Library:Section(properties)
            local Cfg = {
                Name = properties.name or properties.Name or "Section"; 
                Side = properties.side or properties.Side or "Left";

                -- Fill settings 
                Size = properties.size or properties.Size or nil;
                
                -- Other
                Items = {};
            };
            
            local Items = Cfg.Items; do
                Items.Outline = Library:Create( "Frame" , {
                    Parent = self.Items.Column;
                    Name = "\0";
                    Size = dim2(0, 100, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = themes.preset.inline
                });	Library:Themify(Items.Outline, "inline", "BackgroundColor3")

                Library:Create( "UIPadding" , {
                    PaddingBottom = dim(0, 2);
                    Parent = Items.Outline
                });

                Items.TitleHolder = Library:Create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Outline;
                    Size = dim2(0, 0, 0, 10);
                    Name = "\0";
                    Position = dim2(0, 10, 0, 0);
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.background
                });	Library:Themify(Items.TitleHolder, "background", "BackgroundColor3")

                Library:Create( "UIPadding" , {
                    Parent = Items.TitleHolder;
                    PaddingRight = dim(0, 2);
                    PaddingLeft = dim(0, 3)
                });

                Items.Title = Library:Create( "TextLabel" , {
                    FontFace = Fonts[themes.preset.font];
                    Parent = Items.TitleHolder;
                    TextColor3 = themes.preset.text_color;
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = Cfg.Name;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    AnchorPoint = vec2(0, 1);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 9);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 2;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Inline, "outline", "BackgroundColor3")

                Library:Create( "UIPadding" , {
                    PaddingBottom = dim(0, 2);
                    Parent = Items.Inline
                });

                Items.Background = Library:Create( "Frame" , {
                    Parent = Items.Inline;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = themes.preset.background
                });	Library:Themify(Items.Background, "background", "BackgroundColor3")

                Items.Accent = Library:Create( "Frame" , {
                    Name = "\0";
                    Parent = Items.Background;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });	Library:Themify(Items.Accent, "accent", "BackgroundColor3")

                Items.Elements = Library:Create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Background;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 12, 0, 15);
                    Size = dim2(1, -24, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIPadding" , {
                    PaddingBottom = dim(0, 5);
                    Parent = Items.Elements
                });

                Library:Create( "UIListLayout" , {
                    Parent = Items.Elements;
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
            end 

            return setmetatable(Cfg, Library)
        end  

        function Library:Toggle(properties) 
            local Cfg = {
                Name = properties.Name or "Toggle";
                Flag = properties.Flag or properties.Name or "Toggle";
                Enabled = properties.Default or false;
                Callback = properties.Callback or function() end;

                -- Sub / Group Section
                Folding = properties.Folding or false;
                Collapsable = properties.Collapsing or true;

                -- Tooltip = {Title = "Title", Text = "Text goes here\n Whatever", Width = 100}
                Tooltip = properties.Tooltip or nil;

                Items = {};
            }

            local Items = Cfg.Items; do
                Items.Toggle = Library:Create( "TextButton" , {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 12);
                    Selectable = false;
                    TextTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Components = Library:Create( "Frame" , {
                    Parent = Items.Toggle;
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = Items.Components;
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                Items.Outline = Library:Create( "Frame" , {
                    Name = "\0";
                    Parent = Items.Toggle;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Title = Library:Create( "TextLabel" , {
                    FontFace = Fonts[themes.preset.font];
                    TextStrokeColor3 = rgb(255, 255, 255);
                    ZIndex = 2;
                    TextSize = 12;
                    Size = dim2(0, 0, 1, 0);
                    RichText = true;
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items.Outline;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Position = dim2(0, 17, 0, -1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if Cfg.Tooltip then 
                    Library:Tooltip({Title = Cfg.Tooltip.Title, Text = Cfg.Tooltip.Text, Width = Cfg.Tooltip.Width, Path = Items.Title})
                end 

                Library:Create( "UIStroke" , {
                    Parent = Items.Title;
                    LineJoinMode = Enum.LineJoinMode.Miter
                });

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    BackgroundColor3 = rgb(45, 45, 50)
                }); Library:Themify(Items.Inline, "accent", "BackgroundColor3")

                Items.Accent2 = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    ZIndex = 1;
                    BackgroundColor3 = themes.preset.accent;
                }); Library:Themify(Items.Accent2, "accent", "BackgroundColor3");

                Items.InlineInline = Library:Create( "Frame" , {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                Items.Background = Library:Create( "Frame" , {
                    Parent = Items.InlineInline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.misc_1
                }); Library:Themify(Items.Background, "misc_1", "BackgroundColor3");
                
                Items.Accent1 = Library:Create( "Frame" , {
                    Parent = Items.InlineInline;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    ZIndex = 1;
                    BackgroundColor3 = themes.preset.accent;
                }); Library:Themify(Items.Accent1, "accent", "BackgroundColor3");
            end 
            
            function Cfg.Set(bool)
                Library:Tween(Items.Accent2, {BackgroundTransparency = bool and 0 or 1})
                Library:Tween(Items.Inline, {BackgroundTransparency = bool and 1 or 0})
                Library:Tween(Items.Accent1, {BackgroundTransparency = bool and 0 or 1})
                Library:Tween(Items.Title, {TextColor3 = bool and themes.preset.text_color or themes.preset.unselected })

                Cfg.Callback(bool)                
                Flags[Cfg.Flag] = bool
            end 
            
            Items.Toggle.MouseButton1Click:Connect(function()
                Cfg.Enabled = not Cfg.Enabled
                Cfg.Set(Cfg.Enabled)
            end)

            Cfg.Set(Cfg.Enabled)

            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 
        
        function Library:Slider(properties) 
            local Cfg = {
                Name = properties.Name or nil,
                Suffix = properties.Suffix or "",
                Flag = properties.Flag or properties.Name or "Slider",
                Callback = properties.Callback or function() end, 

                -- Value Settings
                Min = properties.Min or 0,
                Max = properties.Max or 100,
                Intervals = properties.Decimal or 1,
                Value = properties.Default or 10, 

                -- Other
                Dragging = false,
                Items = {}
            } 

            local Items = Cfg.Items; do
                Items.Slider = Library:Create( "Frame" , {
                    Parent = self.Items.Elements;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, Cfg.Name and 27 or 10);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if Cfg.Name then 
                    Items.Text = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        Parent = Items.Slider;
                        TextColor3 = rgb(145, 145, 145);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = Cfg.Name;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Position = dim2(0, 1, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end

                Library:Create( "UIStroke" , {
                    Parent = Items.Text;
                    LineJoinMode = Enum.LineJoinMode.Miter
                });

                Items.Outline = Library:Create( "TextButton" , {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Slider;
                    Name = "\0";
                    Position = dim2(0, 4, 0, Cfg.Name and 17 or 0);
                    Selectable = false;
                    Size = dim2(1, -8, 0, 10);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(45, 45, 50)
                });

                Items.InlineInline = Library:Create( "Frame" , {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                Items.Background = Library:Create( "Frame" , {
                    Parent = Items.InlineInline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Accent = Library:Create( "Frame" , {
                    Name = "\0";
                    Parent = Items.Background;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });	Library:Themify(Items.Accent, "accent", "BackgroundColor3")

                Items.Value = Library:Create( "TextBox" , {
                    FontFace = Fonts[themes.preset.font];
                    Parent = Items.Accent;
                    TextColor3 = rgb(235, 235, 235);
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = "5000st";
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    AnchorPoint = vec2(0.5, 0.5);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(1, 0, 0.5, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 2;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIStroke" , {
                    Parent = Items.Value;
                    LineJoinMode = Enum.LineJoinMode.Miter
                });

                Library:Create( "UIGradient" , {
                    Rotation = 90;
                    Parent = Items.Accent;
                    Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(42, 42, 42))}
                });

                local Gradient = Library:Create( "UIGradient" , {
                    Rotation = 90;
                    Parent = Items.Background;
                    Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                }); Library:SaveGradient(Gradient, "elements");

                Items.Minus = Library:Create( "TextButton" , {
                    FontFace = Fonts[themes.preset.font];
                    Active = false;
                    AnchorPoint = vec2(1, 0.5);
                    ZIndex = 100;
                    TextSize = 12;
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "-";
                    Parent = Items.Outline;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, -5, 0.5, 0);
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextStrokeColor3 = rgb(255, 255, 255);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); Items.Minus.Text = "-";

                Items.Plus = Library:Create( "TextButton" , {
                    FontFace = Fonts[themes.preset.font];
                    Active = false;
                    AnchorPoint = vec2(0, 0.5);
                    ZIndex = 100;
                    TextSize = 12;
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Outline;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(1, 5, 0.5, 0);
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextStrokeColor3 = rgb(255, 255, 255);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); Items.Plus.Text = "+";
            end 

            function Cfg.Set(value)
                Cfg.Value = math.clamp(Library:Round(value, Cfg.Intervals), Cfg.Min, Cfg.Max)

                Items.Value.Text = tostring(Cfg.Value) .. Cfg.Suffix

                Library:Tween(Items.Accent, 
                    {Size = dim2((Cfg.Value - Cfg.Min) / (Cfg.Max - Cfg.Min), 0, 1, 0)
                }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                Flags[Cfg.Flag] = Cfg.Value
                Cfg.Callback(Flags[Cfg.Flag])
            end
            
            Items.Outline.MouseButton1Down:Connect(function()
                Cfg.Dragging = true 
            end)

            Items.Minus.MouseButton1Click:Connect(function()
                Cfg.Value -= Cfg.Intervals
                Cfg.Set(Cfg.Value)
            end)

            Items.Plus.MouseButton1Click:Connect(function()
                Cfg.Value += Cfg.Intervals
                Cfg.Set(Cfg.Value)
            end)

            Items.Value.Focused:Connect(function()
                if Items.Text then 
                    Library:Tween(Items.Text, 
                        {TextColor3 = themes.preset.text_color,
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end 

                Library:Tween(Items.Value,
                    {TextColor3 = themes.preset.accent,
                }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
            end)

            Items.Value.FocusLost:Connect(function()
                if Items.Text then 
                    Library:Tween(Items.Text,
                        {TextColor3 = themes.preset.unselected,
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end 

                Library:Tween(Items.Value,
                    {TextColor3 = themes.preset.text_color,
                }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                pcall(function() -- me lazy ;(
                    Cfg.Set(Items.Value.Text)
                end)
            end)

            Library:Connection(InputService.InputChanged, function(input)
                if Cfg.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                    local Size = (input.Position.X - Items.Outline.AbsolutePosition.X) / Items.Outline.AbsoluteSize.X
                    local Value = ((Cfg.Max - Cfg.Min) * Size) + Cfg.Min
                    Cfg.Set(Value)
                end
            end)

            Library:Connection(InputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Cfg.Dragging = false
                end 
            end)
            
            Cfg.Set(Cfg.Value)
            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

        function Library:Tooltip(properties)
            local Cfg = {
                Path = properties.Path;
                Text = properties.Text;
                Title = properties.Title;
                Width = properties.Width; 
                
                Items = {};
                Tweening = false;
            }   

            local Items = Cfg.Items; do 
                -- Text
                    Items.Tooltip = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        TextStrokeColor3 = rgb(255, 255, 255);
                        ZIndex = 2;
                        TextSize = 12;
                        Size = dim2(0, 0, 1, 0);
                        RichText = true;
                        TextColor3 = themes.preset.tooltip;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "(?)";
                        Parent = Cfg.Path;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Position = dim2(1, 3, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); Library:Themify(Items.Tooltip, "tooltip", "TextColor3")

                    Library:Create( "UIStroke" , {
                        Parent = Items.Tooltip;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });
                -- 

                -- Holder
                    Items.Outline = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        Name = "\0";
                        Visible = false;
                        Position = dim2(0.024000000208616257, 0, 0, 140);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, Cfg.Width, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = themes.preset.inline
                    });	Library:Themify(Items.Inline, "inline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = themes.preset.background;
                    }); Library:Themify(Items.Background, "background", "BackgroundColor3")

                    Items.Text = Library:Create( "TextLabel" , {
                        RichText = true;
                        Parent = Items.Background;
                        TextColor3 = rgb(235, 235, 235);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = Cfg.Text;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BorderSizePixel = 0;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 0, 0, 18);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        FontFace = Fonts[themes.preset.font];
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Title = Library:Create( "TextLabel" , {
                        RichText = true;
                        Parent = Items.Background;
                        TextColor3 = themes.preset.accent;
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = Cfg.Title;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BorderSizePixel = 0;
                        BorderColor3 = rgb(0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        FontFace = Fonts[themes.preset.font];
                        ZIndex = 2;
                        TextSize = 12;
                    });	Library:Themify(Items.Title, "accent", "TextColor3")

                    Library:Create( "UIStroke" , {
                        Parent = Items.Title;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Library:Create( "UIPadding" , {
                        Parent = Items.Title;
                        PaddingTop = dim(0, 5);
                        PaddingRight = dim(0, 4);
                        PaddingLeft = dim(0, 6)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.Text;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Library:Create( "UIPadding" , {
                        PaddingTop = dim(0, 5);
                        PaddingBottom = dim(0, 6);
                        Parent = Items.Text;
                        PaddingRight = dim(0, 4);
                        PaddingLeft = dim(0, 6)
                    });

                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 1);
                        PaddingRight = dim(0, 1);
                        Parent = Items.Inline
                    });

                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 1);
                        PaddingRight = dim(0, 1);
                        Parent = Items.Outline
                    });

                    Library:Create( "UIGradient" , {
                        Parent = Items.Outline
                    });
                -- 
            end 

            function Cfg.Tween(bool) 
                if Cfg.Tweening then 
                    return 
                end 

                Cfg.Tweening = true 

                if bool then 
                    Items.Outline.Visible = true
                end

                local Children = Items.Outline:GetDescendants()
                table.insert(Children, Items.Outline)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool)
                    end
                end
                
                Library:Connection(Tween.Completed, function()
                    Cfg.Tweening = false
                    Items.Outline.Visible = bool
                end)
            end 

            Items.Tooltip.MouseEnter:Connect(function()
                if Cfg.Tweening or Cfg.Path.TextTransparency == 1 then
                    return 
                end 

                Cfg.Tween(true) 
            end)
            
            Items.Tooltip.MouseLeave:Connect(function()
                if Cfg.Tweening or Cfg.Path.TextTransparency == 1 then
                    return 
                end     

                Cfg.Tween(false)
            end)

            Library:Connection(InputService.InputChanged, function(input)
                if Items.Tooltip.Visible and input.UserInputType == Enum.UserInputType.MouseMovement and Library:Hovering(Items.Tooltip) then 
                    Library:Tween(Items.Outline, {
                        Position = dim_offset(input.Position.X, input.Position.Y + 86)
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end

                if (not Library:Hovering(Items.Tooltip)) and Cfg.Tweening == false and Items.Outline.Visible then 
                    Cfg.Tween(false)   
                end 
            end)

            Cfg.Tween(false)

            return setmetatable(Cfg, Library)
        end 

        function Library:Dropdown(properties) 
            local Cfg = {
                Name = properties.Name or nil;
                Flag = properties.Flag or properties.Name or "Dropdown";
                Options = properties.Options or {""};
                Callback = properties.Callback or function() end;
                Multi = properties.Multi or false;
                Scrolling = properties.Scrolling or false;
                YSize = properties.Size or 100;
                Search = properties.Search or false; 

                -- Ignore these 
                Open = false;
                OptionInstances = {};
                MultiItems = {};
                Items = {};
                Tweening = false;
                Ignore = properties.Ignore or false;
            }   

            Cfg.Default = properties.Default or (Cfg.Multi and {Cfg.Items[1]}) or Cfg.Items[1] or "None"
            Flags[Cfg.Flag] = Cfg.Default
            local Parent; 

            local Items = Cfg.Items; do 
                -- Element
                    Items.Dropdown = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = self.Items.Elements;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, Cfg.Name and 35 or 17);
                        Selectable = false;
                        TextTransparency = 1;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Outline = Library:Create( "TextButton" , {
                        Parent = Items.Dropdown;
                        Name = "\0";
                        Position = dim2(0, 0, 0, Cfg.Name and 18 or 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 17);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 50)
                    });

                    Items.InlineInline = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.InlineInline;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Plus = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        Parent = Items.Background;
                        TextColor3 = rgb(145, 145, 145);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = "+";
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        AnchorPoint = vec2(1, 0);
                        BorderSizePixel = 0;
                        ZIndex = 2;
                        BackgroundTransparency = 1;
                        Position = dim2(1, -2, 0, -1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 444;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.Plus;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });

                    Items.Fading = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(1, 0);
                        Parent = Items.Background;
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, 80, 0, 12);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local Gradient = Library:Create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))};
                        Transparency = numseq{numkey(0, 1), numkey(0.82, 0), numkey(1, 0)};
                        Parent = Items.Fading
                    }); Library:SaveGradient(Gradient, "elements");

                    local Gradient = Library:Create( "UIGradient" , {
                        Rotation = 90;
                        Parent = Items.Background;
                        Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                    }); Library:SaveGradient(Gradient, "elements");

                    Items.Value = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        TextColor3 = rgb(145, 145, 145);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = "...";
                        Parent = Items.Background;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 2, 0, -1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    if Cfg.Name then 
                        Items.Text = Library:Create( "TextLabel" , {
                            FontFace = Fonts[themes.preset.font];
                            Parent = Items.Dropdown;
                            TextColor3 = rgb(145, 145, 145);
                            TextStrokeColor3 = rgb(255, 255, 255);
                            Text = Cfg.Name;
                            Name = "\0";
                            AutomaticSize = Enum.AutomaticSize.XY;
                            Position = dim2(0, 1, 0, 0);
                            BorderSizePixel = 0;
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderColor3 = rgb(0, 0, 0);
                            ZIndex = 2;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Library:Create( "UIStroke" , {
                            Parent = Items.Text;
                            LineJoinMode = Enum.LineJoinMode.Miter
                        });
                    end 
                --  
                    
                -- Element Holder
                    Items.DropdownElements = Library:Create( "Frame" , {
                        Parent = Library.Other;
                        Visible = false;
                        Size = dim2(0, 213, 0, Cfg.Scrolling and Cfg.YSize or 18);
                        Name = "DropdownElements";
                        Position = dim2(0, 300, 0, 300);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.DropdownElements, "outline", "BackgroundColor3")
                    
                    if Cfg.Search then 
                        Library:Create( "UIPadding", {
                            PaddingBottom = dim(0, 1);
                            Parent = Items.DropdownElements
                        });

                        Items.TextboxOutline = Library:Create( "Frame", {
                            Name = "\0";
                            Parent = Items.DropdownElements;
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 0, 18);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.outline
                        });	Library:Themify(Items.TextboxOutline, "outline", "BackgroundColor3")

                        Items.Inline = Library:Create( "Frame", {
                            Parent = Items.TextboxOutline;
                            Name = "\0";
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(45, 45, 50)
                        });

                        Items.InlineInline = Library:Create( "Frame", {
                            Parent = Items.Inline;
                            Name = "\0";
                            Position = dim2(0, 1, 0, 1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -2, 1, -2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.outline
                        });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                        Items.Background = Library:Create( "Frame", {
                            Parent = Items.InlineInline;
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            ClipsDescendants = true;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Items.Fading = Library:Create( "Frame", {
                            BorderColor3 = rgb(0, 0, 0);
                            AnchorPoint = vec2(1, 0);
                            Parent = Items.Background;
                            Name = "\0";
                            Position = dim2(1, 0, 0, 0);
                            Size = dim2(0, 80, 0, 12);
                            ZIndex = 2;
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Library:Create( "UIGradient", {
                            Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))};
                            Transparency = numseq{numkey(0, 1), numkey(0.82, 0), numkey(1, 0)};
                            Parent = Items.Fading
                        }); Library:SaveGradient(Gradient, "elements"); 

                        Library:Create( "UIGradient", {
                            Rotation = 90;
                            Parent = Items.Background;
                            Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                        }); Library:SaveGradient(Gradient, "elements");

                        Items.Textbox = Library:Create( "TextBox", {
                            CursorPosition = -1;
                            Active = false;
                            Selectable = false;
                            ZIndex = 2;
                            TextSize = 12;
                            Size = dim2(1, 0, 1, 0);
                            TextColor3 = rgb(145, 145, 145);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "...";
                            Parent = Items.Background;
                            Name = "\0";
                            FontFace = Fonts[themes.preset.font];
                            BackgroundTransparency = 1;
                            Position = dim2(0, 2, 0, 0);
                            TextStrokeColor3 = rgb(255, 255, 255);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });	Library:Themify(Items.Textbox, "unselected", "BackgroundColor3")
                    end 

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.DropdownElements;
                        Name = "\0";
                        Position = dim2(0, 1, 0, Cfg.Search and 18 or 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, Cfg.Search and 0 or 1, Cfg.Search and Cfg.YSize or -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 50)
                    });

                    Items.InlineInline = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.InlineInline;
                        Size = dim2(1, Cfg.Scrolling and -5 or -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local Gradient = Library:Create( "UIGradient" , {
                        Rotation = 90;
                        Parent = Items.Background;
                        Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                    }); Library:SaveGradient(Gradient, "elements");
                    
                    if Cfg.Scrolling then 
                        Items.ScrollBar = Library:Create( "ScrollingFrame", {
                            ScrollBarImageColor3 = rgb(0, 0, 0);
                            Active = true;
                            ScrollBarThickness = 2;
                            AutomaticCanvasSize = Enum.AutomaticSize.Y;
                            BorderColor3 = rgb(0, 0, 0);
                            CanvasSize = dim2(0, 0, 0, 0);
                            Parent = Items.Background;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BottomImage = "rbxassetid://102257413888451";
                            TopImage = "rbxassetid://102257413888451";
                            MidImage = "rbxassetid://102257413888451";
                            Size = dim2(1, 3, 1, 0);
                            BorderSizePixel = 0;
                            ZIndex = 2;
                            BackgroundColor3 = rgb(255, 255, 255);
                            ScrollBarImageColor3 = themes.preset.accent
                        }); Library:Themify(Items.ScrollBar, "accent", "ScrollBarImageColor3")
                        
                    
                    end 

                    Parent = Cfg.Scrolling and Items.ScrollBar or Items.Background -- gay

                    Library:Create( "UIListLayout" , {
                        Parent = Parent;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 3);
                        Parent = Parent
                    });
                -- 
            end 

            function Cfg.RenderOption(text)       
                local Button = Library:Create( "TextButton" , {
                    FontFace = Fonts[themes.preset.font];
                    TextColor3 = themes.preset.unselected;
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = text;
                    Size = dim2(1, 0, 0, 0);
                    Parent = Cfg.Scrolling and Items.ScrollBar or Items.Background;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 2, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 2;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); Library:Themify(Button, "unselected", "TextColor3"); Button.Text = text;

                Library:Create( "UIPadding" , {
                    PaddingTop = dim(0, 3);
                    PaddingBottom = dim(0, 3);
                    Parent = Button;
                    PaddingRight = dim(0, 3);
                    PaddingLeft = dim(0, 3)
                });

                table.insert(Cfg.OptionInstances, Button)

                return Button
            end
            
            function Cfg.SetVisible(bool)
                if Cfg.Tweening then
                    return 
                end 

                if Library.OpenElement ~= Cfg then 
                    Library:CloseElement(Cfg)
                end

                Items.DropdownElements.Position = dim2(0, Items.Outline.AbsolutePosition.X, 0, Items.Outline.AbsolutePosition.Y + 80)
				Items.DropdownElements.Size = dim_offset(Items.Outline.AbsoluteSize.X + 1, Cfg.Scrolling and Cfg.YSize or 0)

                if not Cfg.Multi then 
                    Items.Plus.Text = bool and "-" or "+"
                end

                Cfg.Tween(bool)
                
                Library.OpenElement = Cfg
            end
            
            function Cfg.Set(value)
                local Selected = {}
                local IsTable = type(value) == "table"

                for _,option in Cfg.OptionInstances do 
                    if option.Text == value or (IsTable and table.find(value, option.Text)) then 
                        table.insert(Selected, option.Text)
                        Cfg.MultiItems = Selected
                        option.TextColor3 = themes.preset.text_color
                    else
                        option.TextColor3 = themes.preset.unselected
                        option.BackgroundTransparency = 1
                    end
                end

                Items.Value.Text = if IsTable then table.concat(Selected, ", ") else Selected[1] or ""
                Flags[Cfg.Flag] = if IsTable then Selected else Selected[1]
                
                Cfg.Callback(Flags[Cfg.Flag]) 
            end
            
            function Cfg.RefreshOptions(options) 
                for _,option in Cfg.OptionInstances do 
                    option:Destroy() 
                end
                
                Cfg.OptionInstances = {} 

                for _,option in options do
                    local Button = Cfg.RenderOption(option)
                    
                    Button.MouseButton1Down:Connect(function()
                        if Cfg.Multi then 
                            local Selected = table.find(Cfg.MultiItems, Button.Text)
                            
                            if Selected then 
                                table.remove(Cfg.MultiItems, Selected)
                            else
                                table.insert(Cfg.MultiItems, Button.Text)
                            end
                            
                            Cfg.Set(Cfg.MultiItems) 				
                        else 
                            Cfg.SetVisible(false)
                            Cfg.Open = false
                            
                            Cfg.Set(Button.Text)
                        end
                    end)
                end

                Items.DropdownElements.Size = dim_offset(Items.Outline.AbsoluteSize.X + 1, Cfg.Scrolling and Cfg.YSize or #Cfg.OptionInstances * themes.preset.textsize)
            end

            function Cfg.Tween(bool) 
                if Cfg.Tweening == true then 
                    return 
                end 

                Cfg.Tweening = true 

                if bool then 
                    Items.DropdownElements.Parent = Library.Items
                    Items.DropdownElements.Visible = true 
                end

                local Children = Items.DropdownElements:GetDescendants()
                table.insert(Children, Items.DropdownElements)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
                    end
                end

                Library:Connection(Tween.Completed, function()
                    Cfg.Tweening = false
                    Items.DropdownElements.Parent = bool and Library.Items or Library.Other
                    Items.DropdownElements.Visible = bool 
                end)
            end

            function Cfg.Filter(text)
                for _,label in Cfg.OptionInstances do 
                    if string.find(label.Text, text) then 
                        label.Visible = true 
                    else 
                        label.Visible = false
                    end
                end
            end

            Items.Outline.MouseButton1Click:Connect(function()
                Cfg.Open = not Cfg.Open 

                Cfg.SetVisible(Cfg.Open)
            end)

            Library:Connection(InputService.InputBegan, function(input, game_event)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Library:Hovering({Items.DropdownElements, Items.Dropdown}) then
                        Cfg.SetVisible(false)
                        Cfg.Open = false
                    end 
                end 
            end)

            if Cfg.Search then 
                Items.Textbox:GetPropertyChangedSignal("Text"):Connect(function()
                    Cfg.Filter(Items.Textbox.Text)
                end)
            end 

            Cfg.SetVisible(false)

            Flags[Cfg.Flag] = {} 
            ConfigFlags[Cfg.Flag] = Cfg.Set
            
            Cfg.RefreshOptions(Cfg.Options)
            Cfg.Set(Cfg.Default)
                
            return setmetatable(Cfg, Library)
        end

        function Library:Label(properties)
            local Cfg = {
                Name = properties.Name or "Label",

                -- Other
                Items = {};
            }

            local Items = Cfg.Items; do 
                Items.Label = Library:Create( "Frame" , {
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 12);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Components = Library:Create( "Frame" , {
                    Parent = Items.Label;
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = Items.Components;
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                Items.Name = Library:Create( "TextLabel" , {
                    Parent = Items.Label;
                    RichText = true;
                    Name = "\0";
                    TextColor3 = rgb(145, 145, 145);
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = Cfg.Name;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    BorderColor3 = rgb(0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    FontFace = Fonts[themes.preset.font];
                    ZIndex = 2;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIStroke" , {
                    Parent = Items.Name;
                    LineJoinMode = Enum.LineJoinMode.Miter
                });
            end 

            function Cfg.Set(Text)
                Items.Name.Text = Text
            end 

            Cfg.Set(Cfg.Name)

            return setmetatable(Cfg, Library)
        end

        function Library:Textbox(properties) 
            local Cfg = {
                Name = properties.Name or nil;
                PlaceHolder = properties.PlaceHolder or properties.PlaceHolderText or properties.Holder or properties.HolderText or "Type here...";
                ClearTextOnFocus = properties.ClearTextOnFocus or false;
                Default = properties.Default or ""; 
                Flag = properties.Flag or properties.Name or "TextBox";
                Callback = properties.Callback or function() end;
                
                Items = {};
                Focused = false;
            }

            Flags[Cfg.Flag] = Cfg.default

            local Items = Cfg.Items; do 
                Items.Textbox = Library:Create( "TextButton" , {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 35);
                    Selectable = false;
                    TextTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if Cfg.Name then 
                    Items.Text = Library:Create( "TextLabel" , {
                        FontFace = Fonts[themes.preset.font];
                        Parent = Items.Textbox;
                        TextColor3 = rgb(145, 145, 145);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = Cfg.Name;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Position = dim2(0, 1, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.Text;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });
                end 

                Items.Outline = Library:Create( "Frame" , {
                    Parent = Items.Textbox;
                    Name = "\0";
                    Position = dim2(0, 0, 0, Cfg.Name and 17 or 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 18);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(45, 45, 50)
                });

                Items.InlineInline = Library:Create( "Frame" , {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                Items.Background = Library:Create( "Frame" , {
                    Parent = Items.InlineInline;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    ClipsDescendants = true;
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(0, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Fading = Library:Create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    AnchorPoint = vec2(1, 0);
                    Parent = Items.Background;
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(0, 80, 0, 12);
                    ZIndex = 3;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                local Gradient = Library:Create( "UIGradient" , {
                    Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))};
                    Transparency = numseq{numkey(0, 1), numkey(0.82, 0), numkey(1, 0)};
                    Parent = Items.Fading
                }); Library:SaveGradient(Gradient, "elements");

                local Gradient = Library:Create( "UIGradient" , {
                    Rotation = 90;
                    Parent = Items.Background;
                    Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                }); Library:SaveGradient(Gradient, "elements");

                Items.Input = Library:Create( "TextBox" , {
                    Parent = Items.Background;
                    FontFace = Fonts[themes.preset.font];
                    Name = "\0";
                    TextColor3 = rgb(145, 145, 145);
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = "";
                    Size = dim2(1, 0, 1, 0);
                    Selectable = false;
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 2, 0, 0);
                    ClearTextOnFocus = Cfg.ClearTextOnFocus;
                    Active = false;
                    ZIndex = 44;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
            end 
            
            function Cfg.Set(text) 
                Flags[Cfg.Flag] = text

                Items.Input.Text = text

                Cfg.Callback(text)
            end 
            
            Items.Input:GetPropertyChangedSignal("Text"):Connect(function()
                if Cfg.Focused then 
                    Cfg.Set(Items.Input.Text)
                end 
            end) 

            Items.Input.Focused:Connect(function()
                Cfg.Focused = true;
            end)

            Items.Input.FocusLost:Connect(function()
                Cfg.Focused = false;
            end)

            if Cfg.Default then 
                Cfg.Set(Cfg.Default) 
            end

            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end

        function Library:Keybind(properties) 
            local Cfg = {
                Flag = properties.Flag or properties.Name;
                Callback = properties.Callback or function() end;
                Name = properties.Name or "Keybind"; 

                Key = properties.Key or nil;
                Mode = properties.Mode or "Toggle";
                Active = properties.Default or false; 
                
                Show = properties.ShowInList or true;

                Open = false;
                Binding;
                Ignore = false;

                Items = {};
                Tweening = false;
            }
            
            Flags[Cfg.Flag] = {
                Mode = Cfg.Mode,
                Key = Cfg.Key, 
                Active = Cfg.Active
            }

            local KeybindElement = Library.KeybindList:ListElement({})

            local Items = Cfg.Items; do 
                -- Component
                    Items.Keybind = Library:Create( "TextButton" , {
                        Parent = self.Items.Components;
                        FontFace = Fonts[themes.preset.font];
                        Name = "\0";
                        TextColor3 = rgb(145, 145, 145);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = "[NONE]";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Size = dim2(0, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 17, 0, 0);
                        RichText = true;
                        ZIndex = 2;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIStroke" , {
                        Parent = Items.Keybind;
                        LineJoinMode = Enum.LineJoinMode.Miter
                    });
                -- 
                
                -- Mode holder
                    Items.Information = Library:Create( "Frame" , {
                        Parent = Library.Other;
                        Size = dim2(0, 213, 0, 71);
                        Name = "\0";
                        Visible = false;
                        Position = dim2(0, 100, 0, 100);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 1;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.Information, "outline", "BackgroundColor3")

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Information;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(45, 45, 50)
                    });

                    Items.InlineInline = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.outline
                    });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                    Items.Background = Library:Create( "Frame" , {
                        Parent = Items.InlineInline;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local Gradient = Library:Create( "UIGradient" , {
                        Rotation = 90;
                        Parent = Items.Background;
                        Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                    }); Library:SaveGradient(Gradient, "elements");

                    Items.Elements = Library:Create( "Frame" , {
                        Parent = Items.Background;
                        Name = "\0";
                        Position = dim2(0, 12, 0, 5);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -24, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIPadding" , {
                        Parent = Items.Elements;
                        PaddingTop = dim(0, 15)
                    });

                    Library:Create( "UIListLayout" , {
                        Parent = Items.Elements;
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    local Section = setmetatable(Cfg, Library)
                    Items.Dropdown = Section:Dropdown({Name = "Mode", Options = {"Toggle", "Hold", "Always"}, Callback = function(option)
                        if Cfg.Set then 
                            Cfg.Set(option)
                        end
                    end, Default = Cfg.Mode, Flag = Cfg.Flag .. "_MODE"})
                    Section:Toggle({Name = "Show on list", Flag = Cfg.Flag .. "_LIST", Callback = function()
                        KeybindElement.SetVisible(Flags[Cfg.Flag .. "_LIST"] and Cfg.Active or false)
                    end})
                --
            end 

            function Cfg.SetMode(mode) 
                Cfg.Mode = mode 

                if mode == "Always" then
                    Cfg.Set(true)
                elseif mode == "Hold" then
                    Cfg.Set(false)
                end

                Flags[Cfg.Flag].Mode = mode
            end

            function Cfg.Set(input)
                if type(input) == "boolean" then 
                    Cfg.Active = input

                    if Cfg.Mode == "Always" then 
                        Cfg.Active = true
                    end
                elseif tostring(input):find("Enum") then 
                    input = input.Name == "Escape" and "NONE" or input
                    
                    Cfg.Key = input or "NONE"	
                elseif table.find({"Toggle", "Hold", "Always"}, input) then 
                    if input == "Always" then 
                        Cfg.Active = true 
                    end 

                    Cfg.Mode = input
                    Cfg.SetMode(Cfg.Mode) 
                elseif type(input) == "table" then
                    input.Key = type(input.Key) == "string" and input.Key ~= "NONE" and Library:ConvertEnum(input.Key) or input.Key
                    input.Key = input.Key == Enum.KeyCode.Escape and "NONE" or input.Key

                    Cfg.Key = input.Key or "NONE"
                    Cfg.Mode = input.Mode or "Toggle"

                    if input.Active then
                        Cfg.Active = input.Active
                    end

                    Cfg.SetMode(Cfg.Mode) 
                end 

                Cfg.Callback(Cfg.Active)

                local text = (tostring(Cfg.Key) ~= "Enums" and (Keys[Cfg.Key] or tostring(Cfg.Key):gsub("Enum.", "")) or nil)
                local __text = text and tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", "") or ""

                Items.Keybind.Text = string.format("[%s]", __text)

                Flags[Cfg.Flag] = {
                    Mode = Cfg.Mode,
                    Key = Cfg.Key, 
                    Active = Cfg.Active
                }
                
                KeybindElement.SetText(string.format("%s [%s] - %s", Cfg.Name, __text, Cfg.Mode))
                KeybindElement.SetVisible(Flags[Cfg.Flag .. "_LIST"] and Cfg.Active or false)
            end

            function Cfg.SetVisible(bool)
                if Cfg.Tweening then  
                    return 
                end 

                Items.Information.Position = dim2(0, Items.Keybind.AbsolutePosition.X + 2, 0, Items.Keybind.AbsolutePosition.Y + 74)
               
                Cfg.Tween(bool)
            end

            function Cfg.Tween(bool) 
                if Cfg.Tweening == true then 
                    return 
                end 

                Cfg.Tweening = true 

                if bool then 
                    Items.Information.Visible = true
                    Items.Information.Parent = Library.Items
                end

                local Children = Items.Information:GetDescendants()
                table.insert(Children, Items.Information)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
                    end
                end

                Library:Connection(Tween.Completed, function()
                    Cfg.Tweening = false
                    Items.Information.Visible = bool
                end)
            end
                         
            Items.Keybind.MouseButton1Down:Connect(function()
                task.wait()
                Items.Keybind.Text = "..."	

                Cfg.Binding = Library:Connection(InputService.InputBegan, function(keycode, game_event)  
                    Cfg.Set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    
                    Cfg.Binding:Disconnect() 
                    Cfg.Binding = nil
                end)
            end)

            Items.Keybind.MouseButton2Down:Connect(function()
                Cfg.Open = not Cfg.Open 

                Cfg.SetVisible(Cfg.Open)
            end)

            Library:Connection(InputService.InputBegan, function(input, game_event) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not (Library:Hovering(Items.Dropdown.Items.DropdownElements) or Library:Hovering(Items.Information)) and Items.Information.Visible then
                        Cfg.SetVisible(false)
                        Cfg.Open = false;
                    end 
                end 
                
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == Cfg.Key or tostring(selected_key) == Cfg.Key then 
                        if Cfg.Mode == "Toggle" then 
                            Cfg.Active = not Cfg.Active
                            Cfg.Set(Cfg.Active)
                        elseif Cfg.Mode == "Hold" then 
                            Cfg.Set(true)
                        end
                    end
                end
            end)    

            Library:Connection(InputService.InputEnded, function(input, game_event) 
                if game_event then 
                    return 
                end 

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
    
                if selected_key == Cfg.Key then
                    if Cfg.Mode == "Hold" then 
                        Cfg.Set(false)
                    end
                end
            end)
            
            Cfg.Set({Mode = Cfg.Mode, Active = Cfg.Active, Key = Cfg.Key})           
            ConfigFlags[Cfg.Flag] = Cfg.Set
            Items.Dropdown.Set(Cfg.Mode)

            return setmetatable(Cfg, Library)
        end
        
        function Library:Button(properties) 
            local Cfg = {
                Name = properties.Name or "TextBox",
                Callback = properties.Callback or function() end,
                 
                -- Other
                Items = {};
            }

            local Items = Cfg.Items; do
                Items.Button = Library:Create( "TextButton" , {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 18);
                    Selectable = false;
                    TextTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                Items.Outline = Library:Create( "TextButton" , {
                    Parent = Items.Button;
                    Size = dim2(1, 0, 0, 18);
                    Name = "\0";
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Selectable = false;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(45, 45, 50)
                });

                Items.InlineInline = Library:Create( "Frame" , {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                Items.Background = Library:Create( "Frame" , {
                    Parent = Items.InlineInline;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    ClipsDescendants = true;
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(0, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                local Gradient = Library:Create( "UIGradient" , {
                    Rotation = 90;
                    Parent = Items.Background;
                    Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                }); Library:SaveGradient(Gradient, "elements");

                Items.Text = Library:Create( "TextLabel" , {
                    FontFace = Fonts[themes.preset.font];
                    Parent = Items.Background;
                    TextColor3 = rgb(145, 145, 145);
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = Cfg.Name;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 2, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 2;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIStroke" , {
                    Parent = Items.Text
                });
            end 

            Items.Outline.MouseButton1Click:Connect(function()
                Cfg.Callback()
            end)
            
            return setmetatable(Cfg, Library)
        end
        
        function Library:Colorpicker(properties) 
            local Cfg = {
                Name = properties.Name or self.Name or "Color", 
                Flag = properties.Flag or properties.Name or self.Name or "Colorpicker",
                Callback = properties.Callback or function() end,

                Color = properties.Color or color(1, 1, 1), -- Default to white color if not provided
                Alpha = properties.Alpha or properties.Transparency or 1,
                
                -- Other
                Open = false;
                Mode = properties.Mode or "Animation";
                Items = {};
            }

            local Picker = self:Keypicker(Cfg)

            local Items = Picker.Items; do
                Cfg.Items = Items
                Cfg.Set = Picker.Set
            end;
            
            Cfg.Set(Cfg.Color, Cfg.Alpha)
            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

        function Library:List(properties)
            local Cfg = {
                Flag = properties.Flag or properties.Name or "Dropdown";
                Options = properties.Options or {""};
                Callback = properties.Callback or function() end;
                Multi = properties.Multi or false;

                AutoSizing = properties.AutoSize or false; 
                Size = properties.Size or 18;
                VisualMode = properties.VisualMode or false;

                Items = {};
                OptionInstances = {};
                MultiItems = {};
            } 

            local Items = Cfg.Items; do 
                Items.List = Library:Create( "TextButton", {
                    Active = false;
                    TextTransparency = 1;
                    Parent = self.Items.Elements;
                    AutoButtonColor = false;
                    Name = "\0";
                    Size = dim2(1, 0, 0, Cfg.Size);
                    BackgroundTransparency = 1;
                    Selectable = false;
                    BorderSizePixel = 0;
                    BorderColor3 = rgb(0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize[Cfg.AutoSize and "Y" or "None"];
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Outline = Library:Create( "TextButton", {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    AutoButtonColor = false;
                    Name = "\0";
                    Parent = Items.List;
                    Selectable = false;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Inline = Library:Create( "Frame", {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(45, 45, 50)
                });

                Items.InlineInline = Library:Create( "Frame", {
                    Parent = Items.Inline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                Items.TextHolder = Library:Create( "Frame", {
                    Parent = Items.InlineInline;
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    ClipsDescendants = true;
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(0, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                local Gradient = Library:Create( "UIGradient", {
                    Rotation = 90;
                    Parent = Items.TextHolder;
                    Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                }); Library:SaveGradient(Gradient, "elements");

                if not Cfg.AutoSizing then 
                    local Old = Items.TextHolder
                    Items.TextHolder = Library:Create( "ScrollingFrame", {
                        ScrollBarImageColor3 = rgb(0, 0, 0);
                        Active = true;
                        BottomImage = "rbxassetid://102257413888451";
                        TopImage = "rbxassetid://102257413888451";
                        MidImage = "rbxassetid://102257413888451";
                        ZIndex = 2;
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarThickness = 2;
                        Parent = Old;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        BackgroundColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        CanvasSize = dim2(0, 0, 0, 0);
                        ScrollBarImageColor3 = themes.preset.accent
                    }); Library:Themify(Items.TextHolder, "accent", "ScrollBarImageColor3")
                end  

                Library:Create( "UIListLayout", {
                    Parent = Items.TextHolder;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill
                });
                
                Library:Create( "UIPadding", {
                    PaddingBottom = dim(0, 4);
                    Parent = Items.TextHolder
                });
            end 

            do -- Functions 
                function Cfg.Set(value) 
                    if Cfg.VisualMode then 
                        return 
                    end 

                    local Selected = {}
                    local IsTable = type(value) == "table"

                    for _,option in Cfg.OptionInstances do 
                        if option.Text == value or (IsTable and table.find(value, option.Text)) then 
                            table.insert(Selected, option.Text)
                            Cfg.MultiItems = Selected
                            option.TextColor3 = themes.preset.text_color
                        else
                            option.TextColor3 = themes.preset.unselected
                        end
                    end

                    Flags[Cfg.Flag] = if IsTable then Selected else Selected[1]
                    
                    Cfg.Callback(Flags[Cfg.Flag]) 
                end 

                function Cfg.RenderOption(name)
                    local Button = Library:Create( "TextButton", {
                        FontFace = Fonts[themes.preset.font];
                        Parent = Items.TextHolder;
                        TextColor3 = rgb(145, 145, 145);
                        TextStrokeColor3 = rgb(255, 255, 255);
                        Text = name;
                        RichText = true;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Size = dim2(0, 0, 0, 0);
                        TextXAlignment = Enum.TextXAlignment[Cfg.VisualMode and "Left" or "Center"];
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 2, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 100;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Button, "unselected", "BackgroundColor3")

                    Button.Text = name

                    Library:Create( "UIStroke", {
                        Parent = Button
                    });

                    Library:Create( "UIPadding", {
                        PaddingTop = dim(0, 3);
                        PaddingBottom = dim(0, 3);
                        Parent = Button;
                        PaddingRight = dim(0, 3);
                        PaddingLeft = dim(0, 3)
                    });
                    
                    table.insert(Cfg.OptionInstances, Button)

                    return Button
                end 

                function Cfg.RefreshOptions(options) 
                    for _,option in Cfg.OptionInstances do 
                        option:Destroy() 
                    end
                    
                    Cfg.OptionInstances = {} 

                    for _,option in options do
                        local Button = Cfg.RenderOption(option)
                        
                        Button.MouseButton1Down:Connect(function()
                            if Cfg.Multi then 
                                local Selected = table.find(Cfg.MultiItems, Button.Text)
                                
                                if Selected then 
                                    table.remove(Cfg.MultiItems, Selected)
                                else
                                    table.insert(Cfg.MultiItems, Button.Text)
                                end
                                
                                Cfg.Set(Cfg.MultiItems) 				
                            else                                 
                                Cfg.Set(Button.Text)
                            end
                        end)
                    end
                end

                function Cfg.Filter(text)
                    for _,label in Cfg.OptionInstances do 
                        if string.find(label.Text, text) then 
                            label.Visible = true 
                        else 
                            label.Visible = false
                        end
                    end
                end

                -- Init
                Flags[Cfg.Flag] = {} 
                ConfigFlags[Cfg.Flag] = Cfg.Set
                Cfg.RefreshOptions(Cfg.Options)
                Cfg.Set(Cfg.Default)
            end 

            return setmetatable(Cfg, Library)
        end 

        function Library:Configs(Window, Tab)
            -- Settings
                local ConfigText;
                local Column = Tab:Column({})
                local Section = Column:Section({Name = "Main"})
                ConfigHolder = Section:List({
                    Name = "Configs", 
                    Flag = "config_Name_list", 
                    Size = 100;
                    Callback = function(option) 
                        if Text and option then 
                            Text.Set(option) 
                        end 
                    end, 
                }); 
                Library:UpdateConfigList();

                Text = Section:Textbox({Name = "Config Name:", Flag = "config_Name_text", Callback = function(text)
                    ConfigText = text
                end})

                Section:Button({Name = "Save", Callback = function() 
                    writefile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg", Library:GetConfig())
                    Library:Notification({Name = "Saved config.", Lifetime = 5})
                    Library:UpdateConfigList()
                end})

                Section:Button({Name = "Load", Callback = function() 
                    Window.Tweening = true 
                    Library:LoadConfig(readfile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg"))  
                    Library:Notification({Name = "Loaded config.", Lifetime = 5})
                    Library:UpdateConfigList() 
                    Window.Tweening = false 
                end})

                Section:Button({Name = "Delete", Callback = function() 
                    delfile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg")  
                    Library:Notification({Name = "Deleted config.", Lifetime = 5})
                    Library:UpdateConfigList() 
                end})

                local Section = Column:Section({Name = "Server"})
                Section:Button({Name = "Copy JobId", Callback = function()
                    setclipboard(game.JobId)
                end})
                Section:Button({Name = "Copy GameID", Callback = function()
                    setclipboard(game.GameId)
                end})
                Section:Button({Name = "Copy Join Script", Callback = function()
                    setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)')
                end})
                Section:Button({Name = "Rejoin", Callback = function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
                end})
                Section:Button({Name = "Join New Server", Callback = function()
                    local apiRequest = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                    local data = apiRequest.data[math.random(1, #apiRequest.data)]

                    if data.playing <= Flags["MaxPlayers"] then 
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.id)
                    end 
                end})
                Section:Slider({Name = "Max Players", Min = 0, Max = 40, Default = 10, Decimal = 1, Flag = "MaxPlayers"})

            -- 

            -- Theming 
                local Column = Tab:Column({})
                local Section = Column:Section({Name = "Other"})
                Section:Label({Name = "Inline"}):Colorpicker({Color = themes.preset.inline, Callback = function(color, alpha)
                    Library:RefreshTheme("inline", color)
                end})
                Section:Label({Name = "Outline"}):Colorpicker({Color = themes.preset.outline, Callback = function(color, alpha)
                    Library:RefreshTheme("outline", color)
                end})
                Section:Label({Name = "Accent"}):Colorpicker({Color = themes.preset.accent, Callback = function(color, alpha)
                    Library:RefreshTheme("accent", color)
                end})
                local Label = Section:Label({Name = "Background"})
                Label:Colorpicker({Color = themes.preset.background, Callback = function(color, alpha)
                    Library:RefreshTheme("background", color)
                end})
                Label:Colorpicker({Color = themes.preset.misc_1, Callback = function(color, alpha)
                    Library:RefreshTheme("misc_1", color)
                end})
                Section:Label({Name = "Text Color"}):Colorpicker({Color = themes.preset.text_color, Callback = function(color, alpha)
                    Library:RefreshTheme("text_color", color)
                end})
                Section:Label({Name = "Tooltip"}):Colorpicker({Color = themes.preset.tooltip, Callback = function(color, alpha)
                    Library:RefreshTheme("tooltip", color)
                end})
                Section:Label({Name = "Unselected"}):Colorpicker({Color = themes.preset.unselected, Callback = function(color, alpha)
                    Library:RefreshTheme("unselected", color)
                end})
                local Label = Section:Label({Name = "Element Gradients"})
                Label:Colorpicker({Color = themes.preset.misc_1, Callback = function(color, alpha)
                    Library:RefreshTheme("misc_1", color)

                    for _,seq in themes.gradients.elements do
                        seq.Color = rgbseq{rgbkey(0, themes.preset.misc_1), rgbkey(1, themes.preset.misc_2)}
                    end
                end, Flag = "Element Gradient 1"})
                Label:Colorpicker({Color = themes.preset.misc_2, Callback = function(color, alpha)
                    themes.preset.misc_2 = color 

                    for _,seq in themes.gradients.elements do
                        seq.Color = rgbseq{rgbkey(0, themes.preset.misc_1), rgbkey(1, themes.preset.misc_2)}
                    end
                end, Flag = "Element Gradient 2"})
                Section:Slider({Name = "Tween Speed", Min = 0, Max = 3, Decimal = Library.DraggingSpeed, Default = .3, Callback = function(num)
                    Library.TweeningSpeed = num
                end})
                Section:Dropdown({Name = "Tweening Style", Options = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"}, Flag = "LibraryEasingStyle", Default = "Quint", Callback = function(Option)
                    Library.EasingStyle = Enum.EasingStyle[Option]
                end});
                Section:Slider({Name = "Dragging Speed", Min = 0, Max = 1, Decimal = .01, Default = .05, Callback = function(num)
                    Library.DraggingSpeed = num
                end})
                Section:Label({Name = "Menu Bind"}):Keybind({Name = "Menu Bind", Key = Enum.KeyCode.RightShift, Callback = function(bool) 
                    print(bool)
                    Window.SetVisible(bool) 
                end})
                Window.Tweening = false
                Section:Toggle({Name = "Toggle Watermark", Callback = function(bool)
                    Window.SetWatermarkVisible(bool)
                end})
                Section:Toggle({Name = "Toggle Keybind List", Callback = function(bool)
                    Library.KeybindList.Items.Holder.Visible = bool 
                    Library.KeybindList.Items.List.Visible = bool 
                end})
                Section:Dropdown({Name = "Font", Options = FontIndexes, Callback = function(option)
                    for _,text in themes.utility.text_color.TextColor3 do 
                        text.FontFace = Fonts[option]
                    end 
                end, Default = "Tahoma", Flag = "Menu Font"})
                Section:Slider({Name = "TextSize", Default = 12, Decimal = 1, Min = 1, Max = 30, Callback = function(int)
                    for _,text in themes.utility.text_color.TextColor3 do 
                        text.TextSize = int
                    end 

                    themes.preset.textsize = int
                end})
                Section:Slider({Name = "Blur Intensity", Default = 14, Decimal = 1, Min = 1, Max = 100, Flag = "BlurSize", Callback = function(int)
                    if Window.Items.Holder.Visible then 
                        Library.Blur.Size = int
                    end 
                end})
        end
        
    -- Notification Library
        local Notifications = Library.Notifications

        function Library:FadeNotification(path, is_fading) -- Horrendous dogshit code from like 500 years ago
            local fading = is_fading and 1 or 0 

            for _, instance in path:GetDescendants() do 
                if not instance:IsA("GuiObject") then 
                    if instance:IsA("UIStroke") then
                        Library:Tween(instance, {Transparency = fading}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, false, 0))
                    end
        
                    continue
                end 
        
                if instance:IsA("TextLabel") then
                    Library:Tween(instance, {TextTransparency = fading}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, false, 0))
                elseif instance:IsA("Frame") then
                    Library:Tween(instance, {BackgroundTransparency = instance.Transparency and 0 and is_fading and 1 or 0}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, false, 0))
                end
            end
        end 

        function Library:ReorderNotifications()
            local Offset = 50
            
            for _,notif in Notifications.Notifs do
                local Position = vec2(20, Offset)
                notif.Position = dim_offset(Position.X, Position.Y)
                -- Library:Tween(notif, {Position =}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, false, 0))
                Offset += (notif.AbsoluteSize.Y + 5)
            end

            return Offset
        end 
        
        function Library:Notification(properties)
            local Cfg = {
                Name = properties.Name or "Notification",
                Lifetime = properties.Lifetime or nil,
                Type = properties.Type or "Normal", -- Flashing, Normal, Fading
                
                Items = {} 
            }

            local Index = #Notifications.Notifs + 1

            local Items = Cfg.Items; do
                Items.Holder = Library:Create( "Frame" , {
                    Parent = Library.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 18, 0, 70);
                    BorderColor3 = rgb(0, 0, 0);
                    AnchorPoint = vec2(1, 0);
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Size = dim2(0, 0, 0, 21);
                    BorderSizePixel = 0;
                });	

                Items.ButtonHolder = Library:Create( "Frame" , {
                    Name = "\0";
                    Position = dim2(0, 0, 1, 5);
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Holder;
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIListLayout" , {
                    Parent = Items.ButtonHolder;
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                }); 

                Items.Notification = Library:Create( "Frame" , {
                    Parent = Items.Holder;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(0, 0, 0, 25);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Notification, "outline", "BackgroundColor3")

                Items.Accent = Library:Create( "Frame" , {
                    Parent = Items.Notification;
                    Size = dim2(0, 1, 1, -4);
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Position = dim2(0, 2, 0, 2);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 3;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent 
                }); Library:Themify(Items.Accent, "accent", "BackgroundColor3")

                Items.Background = Library:Create( "Frame" , {
                    Parent = Items.Notification;
                    Size = dim2(1, -4, 1, -4);
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 2, 0, 2);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 2;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(15, 15, 20)
                });

                Items.FadingLine = Library:Create( "Frame" , {
                    Parent = Items.Notification;
                    Size = dim2(1, -4, 0, 1);
                    Name = "\0";
                    Position = dim2(0, 2, 1, -3);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 2;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                }); Library:Themify(Items.FadingLine, "accent", "BackgroundColor3")

                Items.Title = Library:Create( "TextLabel" , {
                    FontFace = Fonts[themes.preset.font];
                    Parent = Items.Notification;
                    TextColor3 = rgb(235, 235, 235);
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = Cfg.Name;
                    Name = "\0";
                    TextTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    AnchorPoint = vec2(0, 0.5);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 3;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIStroke" , {
                    Parent = Items.Title;
                    LineJoinMode = Enum.LineJoinMode.Miter
                });

                Library:Create( "UIPadding" , {
                    Parent = Items.Title;
                    PaddingRight = dim(0, 7);
                    PaddingLeft = dim(0, 9)
                });

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Notification;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(45, 45, 50)
                });
            end     

            function Cfg.DestroyNotif() 
                local Tween = Library:Tween(Items.Holder, {AnchorPoint = vec2(1, 0)}, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, false, 0))
                Library:FadeNotification(Items.Holder, true)

                Tween.Completed:Connect(function()
                    Items.Holder:Destroy()
                    Notifications.Notifs[Index] = nil
                    Library:ReorderNotifications()
                end)
            end

            local Offset = Library:ReorderNotifications()
            Notifications.Notifs[Index] = Items.Holder
            Library:FadeNotification(Items.Holder, false)

            Library:Tween(Items.Holder, {
                AnchorPoint = vec2(0, 0), 
                BackgroundTransparency = 1,
            }, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, false, 0))

            Items.Holder.Position = dim_offset(20, Offset)

            if Cfg.Lifetime then 
                task.spawn(function() 
                    task.wait(Cfg.Lifetime)
                    Cfg.DestroyNotif()
                end)            
            end 

            return setmetatable(Cfg, Library)
        end 

        function Library:NotificationButton(properties)
            local Cfg = {
                Name = properties.Name or "Name"; 
                Callback = properties.Callback or self.NotificationFade;
                
                Items = {};
            }   

            local Items = Cfg.Items; do 
                Items.Outline = Library:Create( "TextButton" , {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = self.Items.ButtonHolder;
                    Name = "\0";
                    Selectable = false;
                    Size = dim2(0, 0, 0, 18);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.Outline, "outline", "BackgroundColor3")

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Size = dim2(0, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.inline 
                }); Library:Themify(Items.Inline, "inline", "BackgroundColor3")

                Items.InlineInline = Library:Create( "Frame" , {
                    Parent = Items.Inline;
                    Size = dim2(0, -2, 1, -2);
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.outline
                });	Library:Themify(Items.InlineInline, "outline", "BackgroundColor3")

                Items.Background = Library:Create( "Frame" , {
                    ClipsDescendants = true;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.InlineInline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(0, -2, 1, -2);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                local Gradient = Library:Create( "UIGradient" , {
                    Rotation = 90;
                    Parent = Items.Background;
                    Color = rgbseq{rgbkey(0, rgb(30, 30, 35)), rgbkey(1, rgb(23, 23, 28))}
                }); Library:SaveGradient(Gradient, "elements");

                Items.Text = Library:Create( "TextLabel" , {
                    FontFace = Fonts[themes.preset.font];
                    Parent = Items.Background;
                    TextColor3 = rgb(145, 145, 145);
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = Cfg.Name;
                    Name = "\0";
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 2, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 2;
                    TextSize = 12;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIStroke" , {
                    Parent = Items.Text
                });

                Library:Create( "UIPadding" , {
                    PaddingRight = dim(0, 2);
                    Parent = Items.Text
                });

                Library:Create( "UIPadding" , {
                    PaddingRight = dim(0, 3);
                    Parent = Items.InlineInline
                });

                Library:Create( "UIPadding" , {
                    PaddingRight = dim(0, 1);
                    Parent = Items.Inline
                });

                Library:Create( "UIPadding" , {
                    PaddingRight = dim(0, 1);
                    Parent = Items.Outline
                });
            end 

            Items.Outline.MouseButton1Click:Connect(Cfg.Callback)

            return setmetatable(Cfg, Library)
        end

return Library, Options
